import QtQuick 2.0

import Ubuntu.Components 1.3

/*!
    \brief MainView with a Label and Button elements.
*/
MainView {
   id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    applicationName: "com.ubuntu.developer.sturmflut.gameoflife"


    width: units.gu(70)
    height: units.gu(100)

    property int cellSurvival: 2
    property int cellBirth: 3

    PageStack {
        id: mainStack
    }

    Component.onCompleted: mainStack.push(Qt.resolvedUrl("ui/SimulationPage.qml"))
}
