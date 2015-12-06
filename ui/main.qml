import QtQuick 2.4

import Ubuntu.Components 1.2


/*!
    \brief MainView with a Label and Button elements.
*/
MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    applicationName: "com.ubuntu.developer.sturmflut.gameoflife"


    width: units.gu(50)
    height: units.gu(80)

    property var allAutomaton: [
      [[ 2, 3 ],              [ 3 ]],            // Conway's Life        
      [[ 1, 2, 5 ],           [ 3, 6 ]],         // 2x2
      [[ 4, 5, 6, 7 ],        [ 3, 4, 5 ]],      // Assimilation
      [[ 1, 2, 3, 4, 5 ],     [ 3 ]],            // Amazing
      [[ 4, 5, 6 ],           [ 3, 4 ]],         // Bacteria
      [[ 1, 2, 5, 6, 7, 8 ],  [ 3, 6, 7 ]],      // Coagulation
      [[ 4, 5, 6, 7, 8 ],     [ 3 ]],            // Coral
      [[ 3, 4, 6, 7, 8 ],     [ 3, 6, 7, 8 ]],   // Day & Night
      [[ 0, 1, 2, 3, 4, 5, 6, 7, 8 ], [ 3 ]],    // Flakes
      [[ 1 ],                 [ 1 ]],            // Gnarl
      [[  ],                  [ 2 ]],            // Seeds
      [[ 1, 2, 3, 4, 5 ],     [ 3 ]],            // Maze
      [[ 1, 2, 3, 4 ],        [ 3 ]],            // Mazectric
      [[ 2, 3, 4, 5 ],        [ 4, 5, 6, 7, 8 ]] // Walled Cities
    ]

    property int currentCellularAutomaton: 0
    property var cellSurvival: allAutomaton[currentCellularAutomaton][0]
    property var cellBirth:    allAutomaton[currentCellularAutomaton][1]

     PageStack {
        id: mainStack
    }
    Component.onCompleted: mainStack.push(Qt.resolvedUrl("SimulationPage.qml"))

    //SimulationPage {
    //}
}
