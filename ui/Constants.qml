import QtQuick 2.0


QtObject {
    readonly property int size: 50

    readonly property color deadColor: "black"
    readonly property var aliveColors: [ "blue", "green", "red", "yellow", "orange", "cyan", "white" ]
    readonly property var newBornColors: [ "mediumblue", "mediumseagreen", "orangered", "yellowgreen", "darkorange", "lightcyan", "lightgray" ]
}
