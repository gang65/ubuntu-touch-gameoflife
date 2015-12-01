import QtQuick 2.4

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

    property var cellSurvival: [ 2, 3 ]
    property var cellBirth: [ 3 ]

    SimulationPage {

    }
}
