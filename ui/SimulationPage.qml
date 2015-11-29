import QtQuick 2.0

import Ubuntu.Components 1.1


/*!
    \brief A Page implementing the actual Game of Life simulation
*/
Page {
    id: simulationPage
    title: i18n.tr("Game of Life")

    head.actions: [

        Action {
            iconName: "reload"
            text: i18n.tr("Reload")
            onTriggered: {
                timer.stop()

                pixelGrid.randomize()

                internal.running = true
                pauseButton.iconName = "media-playback-pause"

                timer.start()
            }
        }
    ]

    Constants {
        id: constants
    }


    QtObject {
        id: internal

        property bool running: true

        property int currentColor: 0
        property int gameSpeed: 700

        property var state: []
        property var oldState: []
    }


    Column {
        spacing: units.gu(1)
        anchors {
            margins: units.gu(2)
            fill: parent
        }

        Row {
            id: statusRow
            width: parent.width
            spacing:  units.gu(3)

            Label {
                id: statusLabel
                fontSize: "x-large"
                width: 0.5 * parent.width 
                text: 0 + " " + i18n.tr("individuals")
            }


            Button {
                id: pauseButton
                text: ""

                iconName: "media-playback-pause"

                width: height

                onClicked: {
                    if(internal.running)
                    {
                        timer.stop()
                        internal.running = false

                        iconName = "media-playback-start"
                        nextStep.enabled = true
                    }
                    else
                    {
                        internal.running = true
                        timer.start()

                        nextStep.enabled = false
                        iconName = "media-playback-pause"
                    }
                }
            }

            Button {
                id: nextStep
                text: ""

                iconName: "media-seek-forward"
                enabled: false 
                width: height

                onClicked: {
                    pixelGrid.update()
                    pixelGrid.drawCells()
                }
            }

            Button {
                id: slowDown
                text: ""

                iconName:  "remove"

                width: height

                onClicked: {
                    if (internal.gameSpeed > 100) {
                        internal.gameSpeed = internal.gameSpeed - 100
                    } else {
                        internal.gameSpeed = 0
                    }
                }
            }

            Label {
                id: speedlabel
                fontSize: "x-large"
                text: 0.01 * internal.gameSpeed
            }

            Button {
                id: speedUp
                text: ""

                iconName: "add"
 
                width: height

                onClicked: {
                    if (internal.gameSpeed < 900) {
                        internal.gameSpeed = internal.gameSpeed + 100
                    }
                }
            }
           
        }


        Rectangle {
            width: parent.width
            height: parent.height - statusRow.height

            PixelGrid {
                id: pixelGrid

                anchors.fill: parent


                Component.onCompleted: {
                    pixelGrid.setSize(constants.size)

                    randomize()
                    drawCells()

                    timer.start()
                }


                function randomize()
                {
                    for(var i = 0; i < pixelGrid.getNumPixels(); i++)
                    {
                        if(Math.random() > 0.6)
                            internal.state[i] =  true
                        else
                            internal.state[i] =  false
                    }

                    internal.currentColor = Math.floor(constants.aliveColors.length * Math.random())
                }


                function drawCells() {
                    for(var i = 0; i < pixelGrid.getNumPixels(); i++)
                        // if(internal.state[i] !== internal.oldState[i])
                        pixelGrid.setColorAt(i, internal.state[i] === true ? constants.aliveColors[internal.currentColor] : constants.deadColor)
                }


                function getOldState(x, y)
                {
                    var realx
                    var realy

                    if(x < 0)
                        realx = x + constants.size
                    else
                        realx = x % constants.size

                    if(y < 0)
                        realy = y + constants.size
                    else
                        realy = y % constants.size

                    return internal.oldState[realy * constants.size + realx]
                }


                function countNeighbors(x, y)
                {
                    var count = 0

                    for(var yd = -1; yd <= 1; yd++)
                        for(var xd = -1; xd <= 1; xd++)
                            if(getOldState(x + xd, y + yd))
                                count++;

                    if(getOldState(x, y))
                        return count - 1
                    else
                        return count
                }


                function processCell(x, y)
                {
                    var numNeighbors = countNeighbors(x, y)

                    if(numNeighbors === mainView.cellBirth)
                        return true

                    if(getOldState(x, y) && numNeighbors === mainView.cellSurvival)
                        return true

                    return false
                }


                function update()
                {
                    // Swap arrays
                    var t = internal.oldState
                    internal.oldState = internal.state
                    internal.state = t

                    var count = 0

                    for(var y = 0; y < constants.size; y++)
                        for(var x = 0; x < constants.size; x++)
                        {
                            internal.state[y * constants.size + x] = processCell(x, y)

                            if(internal.state[y * constants.size + x])
                                count++
                        }

                    statusLabel.text = count + " " + i18n.tr("individuals")
                }
            }

            Timer {
                id: timer

                interval: internal.gameSpeed
                running: false
                repeat: false

                onTriggered: {
                    pixelGrid.update()
                    pixelGrid.drawCells()

                    start()
                }
            }


            MouseArea {
                QtObject {
                    id: mouseInternal

                    property bool mouseDown: false
                }

                anchors.fill: parent

                acceptedButtons: Qt.LeftButton

                onPressed: mouseInternal.mouseDown = true

                onReleased: mouseInternal.mouseDown = false

                onPositionChanged: {
                    if(mouseInternal.mouseDown)
                    {
                        var pixelIndex = pixelGrid.childAt(mouse.x, mouse.y).pixelIndex

                        internal.state[pixelIndex] = true
                    }
                }
            }
        }
    }
}
