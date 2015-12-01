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

    property var allAutomaton: [
      [[ 2, 3 ],              [ 3 ]],            // Conway's Life
      [[ 4, 5, 6, 7, 8 ],     [ 3 ]],            // Coral
      [[ 3, 4, 6, 7, 8 ],     [ 3, 6, 7, 8 ]],   // Day & Night
      [[  ],                  [ 2 ]],            // Seeds
      [[ 1, 2, 5 ],           [ 3, 6 ]],         // 2x2
      [[ 4, 5, 6, 7 ],        [ 3, 4, 5 ]],      // Assimilation
      [[ 0, 1, 2, 3, 4, 5, 6, 7, 8 ], [ 3 ]],  // Flakes
      [[ 1 ],                 [ 1 ]],            // Gnarl
      [[ 1, 2, 3, 4, 5 ],     [ 3 ]],            // Maze
      [[ 1, 2, 3, 4 ],        [ 3 ]],            // Mazectric
    ]

    property var currentCellularAutomaton: 0
    property var cellSurvival: allAutomaton[currentCellularAutomaton][0]
    property var cellBirth:  allAutomaton[currentCellularAutomaton][1]


    SimulationPage {

    }
}
