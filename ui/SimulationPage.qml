import QtQuick 2.0

import Ubuntu.Components 1.1

/*!
    \brief A Page implementing the actual "Flood It" game.
*/
Page {
    id: simulationPage
    title: i18n.tr("Game of Life")


    Constants {
        id: constants
    }


    QtObject {
        id: internal

        property var state: []
        property var oldState: []
    }


    PixelGrid {
        id: pixelGrid

        anchors {
            margins: units.gu(2)
            fill: parent
        }


        Component.onCompleted: {
            pixelGrid.setSize(constants.size)

            randomize()
            drawCells()

            timer.start()
        }


        Timer {
            id: timer

            interval: 256
            running: false
            repeat: false

            onTriggered: {
                pixelGrid.update()
                pixelGrid.drawCells()

                start()
            }
        }


        function randomize()
        {
            for(var i = 0; i < pixelGrid.getNumPixels(); i++)
            {
                if(Math.random() > 0.8)
                    internal.state[i] =  true
                else
                    internal.state[i] =  false

                //console.log(i + " " + internal.state[i])
            }
        }


        function drawCells() {
            for(var i = 0; i < pixelGrid.getNumPixels(); i++)
                // if(internal.state[i] !== internal.oldState[i])
                pixelGrid.setColorAt(i, internal.state[i] === true ? constants.aliveColor : constants.deadColor)
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

            if(numNeighbors === 3)
                return true

            if(getOldState(x, y) && numNeighbors === 2)
                return true

            return false
        }


        function update()
        {
            // Swap arrays
            var t = internal.oldState
            internal.oldState = internal.state
            internal.state = t

            for(var y = 0; y < constants.size; y++)
                for(var x = 0; x < constants.size; x++)
                {
                    internal.state[y * constants.size + x] = processCell(x, y)
                }
        }
    }
}
