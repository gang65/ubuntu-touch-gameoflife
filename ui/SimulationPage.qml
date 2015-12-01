import QtQuick 2.4

import Ubuntu.Components 1.3


/*!
    \brief A Page implementing the actual Game of Life simulation
*/
Page {
    id: simulationPage
    title: i18n.tr("Game of Life")

    head.actions: [

        Action {
            id: pauseAction

            iconName: internal.running ? "media-playback-pause" : "media-playback-start"
            text: i18n.tr("Pause")

            onTriggered: {
                internal.running = !internal.running

            }
        },

        Action {
            id: nextStepAction

            iconName: "media-seek-forward"
            text: i18n.tr("Forward")

            enabled: !internal.running

            onTriggered: {
                pixelGrid.update()
                pixelGrid.drawCells()
            }
        },

        Action {
            id: cleanUp

            iconName: "select-none"
            text: i18n.tr("Clean world")

            onTriggered: {
                internal.running = false
                internal.stepNumber = 0

                pixelGrid.cleanWorld()
                pixelGrid.drawCells()
            }
        },

        Action {
            iconName: "reload"
            text: i18n.tr("Random world")

            onTriggered: {
                internal.running = false
                internal.stepNumber = 0

                pixelGrid.randomize()
                pixelGrid.drawCells()
            }
        }
    ]

    Constants {
        id: constants
    }


    QtObject {
        id: internal

        property bool running: false

        property int currentColor: 0
        property int gameSpeed: 4

        property int stepNumber: 0

        property var state: []
        property var oldState: []
    }


    Timer {
        id: timer

        interval: 3000 / internal.gameSpeed
        repeat: true
        running: internal.running

        onTriggered: {
            pixelGrid.update()
            pixelGrid.drawCells()
        }
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
            spacing:  units.gu(2)

            Label {
                fontSize: "large"

                text: i18n.tr("Speed:")
            }

            Button {
                id: slowDown
                text: ""

                iconName:  "remove"

                width: height

                onClicked: {
                    if (internal.gameSpeed > 1) {
                        internal.gameSpeed = internal.gameSpeed - 1
                    }
                }
            }

            Label {
                id: speedlabel
                fontSize: "large"

                text: internal.gameSpeed
            }

            Button {
                id: speedUp
                text: ""

                iconName: "add"
 
                width: height

                onClicked: {
                    if (internal.gameSpeed < 20) {
                        internal.gameSpeed = internal.gameSpeed + 1
                   }
                }
            }

            Label {
                id: statusLabel
                fontSize: "large"

                text: i18n.tr("Step:") + " 0   " + i18n.tr("Cells:") + " 0" 
            }
        }


        Rectangle {
            width: parent.width
            height: parent.height - statusRow.height

            MouseArea {
                anchors.fill: parent

                QtObject {
                    id: mouseInternal
                    property bool addingCellState: false
                }

                onPressed: { 
                   var pixelIndex = pixelGrid.childAt(mouse.x, mouse.y).pixelIndex
                   mouseInternal.addingCellState = !internal.state[pixelIndex]
                   internal.state[pixelIndex] = mouseInternal.addingCellState
                   pixelGrid.drawSingleCell(pixelIndex)
                }

                onPositionChanged: { 
                   var pixelIndex = pixelGrid.childAt(mouse.x, mouse.y).pixelIndex

                   //We are not changing if it was already changed
                   if (internal.state[pixelIndex] !== mouseInternal.addingCellState) {
                      internal.state[pixelIndex] = mouseInternal.addingCellState
                      pixelGrid.drawSingleCell(pixelIndex)
                   }
                }
            }

            PixelGrid {
                id: pixelGrid

                anchors.fill: parent


                Component.onCompleted: {
                    pixelGrid.setSize(constants.size)

                    randomize()
                    drawCells()

                    internal.running = true
                }

                function cleanWorld()
                {
                    for(var i = 0; i < pixelGrid.getNumPixels(); i++)
                    {
                        internal.state[i] =  false
                    }

                    internal.currentColor = Math.floor(constants.aliveColors.length * Math.random())
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

                function drawSingleCell(i) {
                    pixelGrid.setColorAt(i, internal.state[i] === true ?
                       (internal.oldState[i] === true ? constants.aliveColors[internal.currentColor] : constants.newBornColors[internal.currentColor])
                       : constants.deadColor)
                }


                function drawCells() {
                    for(var i = 0; i < pixelGrid.getNumPixels(); i++)
                        drawSingleCell(i)
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

                    // We don't want new birth if cell is already exists
                    if (!getOldState(x, y) && mainView.cellBirth.indexOf(numNeighbors) > -1)
                        return true

                    if (getOldState(x, y) && (mainView.cellSurvival.indexOf(numNeighbors) > -1)) 
                        return true

                    return false
                }


                function update()
                {
                    // Swap arrays
                    internal.stepNumber += 1
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

                    statusLabel.text =  i18n.tr("Step:") + " " + internal.stepNumber + "   " + i18n.tr("Cells:") + " " + count
                }
            }
        }
    }
}
