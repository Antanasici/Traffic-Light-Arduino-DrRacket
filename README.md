# Traffic Light System
# Using Arduino and programmed in DrRacket

[![NPM Version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url]
[![Downloads Stats][npm-downloads]][npm-url]

The challenge your team are faced with is to design and prototype a traffic light system to safely control the flow of traffic along a road. As an example, in the road layout shown in figure 1, roadworks along the main road mean that a temporary traffic light system must be installed, with two sets of lights located at the two points marked Z, allowing traffic to flow alternately from left-to-right and then right-to-left.

![](Report\style\roadwork.png)

As this work is exploratory in nature, the client is interested in innovation and designs that creative responses to the problem, rather than the delivery of complete working products . So that means that an interesting idea or an unusual experiment may be just as good as a more functional but less innovative prototype.

## The idea...
* Three sets of traffic lights [(Z),(Z),(X)], plus the lights for the pedestrian crossing[(Y),(Y)].
* 7-Segment display to show the time for pedastrians to finish
passing the crossing before it changes back to red.
* Simulate a photocam at the way X if the car crosses on the red light.
* Buttons to trigger a pedastrian crossing.
* The sequence of traffic lights should change on it's own.

## How that was done...

One of the first things I did was to create a sequence of the traffic light events. This was a list of sorts where I listed what any given traffic light would be doing relative to the others. This is necessary as I need a precise sequence otherwise the system would be a complete failure.

| Left Z light  | Right Z light |    Light X    |    Light Y    |
|      :---:       |      :---:       |      :---:       |      :---:       |
| RED| RED  | RED  | RED  |
| RED+AMBER  | RED  | RED  | RED  | 
| GREEN  | RED | RED | RED |
| AMBER | RED | RED | RED |
| RED | RED | RED | RED |
| RED | RED+ AMBER | RED | RED |
| RED | GREEN | RED | RED |
| RED | AMBER | RED | RED |
| RED | RED | RED | RED |
| RED | RED | RED+AMBER | RED |
| RED | RED | GREEN | RED |
| RED | RED | AMBER | RED |
| RED | RED | RED | GREEN |

_Finite State Machine (Picture)_

In order to create the light states we used binary integers in a list as can be seen below. It was a list of eleven digit binary values with each of the three numbers representing a traffic light. Meaning 1 to light up and 0 to keep it off. This isn’t too complex and was a good solution for describing lights. The first number represented the red light while the second was an amber and the last was green. Additionally at the end of each line there is a two digit value where we can see the pedestrian crossing being represented. List were added into hash table, for easier reference in the future.
_Code snippet of hash tables containing list's of integers. _
```
1 (list 1 0 0 1 0 0 1 0 0 0 1 ) ; (1st - RED, 2nd - RED, 3rd - RED.) RED
2 (list 1 1 0 1 0 0 1 0 0 0 1) ; (1st - RED + AMBER, 2nd - RED, 3rd - RED.) RED
3 (list 0 0 1 1 0 0 1 0 0 0 1) ; (1st - GREEN , 2nd - RED , 3rd - RED.)RED
4 (list 0 1 0 1 0 0 1 0 0 0 1) ; (1st - AMBER, 2nd - RED , 3rd - RED.) RED
5 (list 1 0 0 1 0 0 1 0 0 0 1) ; (1st - RED, 2nd - RED , 3rd - RED.) RED
6 (list 1 0 0 1 1 0 1 0 0 0 1) ; (1st - RED, 2nd - RED + AMBER , 3rd - RED.)RED
7 (list 1 0 0 0 0 1 1 0 0 0 1) ; (1st - RED, 2nd - GREEN , 3rd - RED .)RED
8 (list 1 0 0 0 1 0 1 0 0 0 1) ; (1st - RED, 2nd - AMBER , 3rd - RED.)RED
9 (list 1 0 0 1 0 0 1 0 0 0 1) ; (1st - RED , 2nd - RED , 3rd -RED .) RED
10 (list 1 0 0 1 0 0 1 1 0 0 1) ; (1st - RED, 2nd - RED , 3rd - AMBER.) RED
11 (list 1 0 0 1 0 0 0 0 1 0 1 ) ; (1st - RED, 2nd - RED , 3rd - GREEN .)RED
12 (list 1 0 0 1 0 0 0 1 0 0 1 ); (1st - RED, 2nd - RED , 3rd - AMBER.)RED
13 (list 1 0 0 1 0 0 1 0 0 1 0 ) ; (1st - RED, 2nd - RED, 3rd - RED.)GREEN 
```
_1 0 0 - Red | 0 1 0 - Amber | 0 0 1 - Green | 1 1 0 - Red&Amber _

We have used the code that was provided with a challenge, to set lights according to list, and check the previous state, changing it into the new state. 


    * (getNextState) - Checks the previous state and decides on a new one
    * (setLights) - takes a list of itegers to set lights.
    * (outputCurrentState) - uses function setLights on list of pins "lights" with the intiger list "lightState"
    * (gotoNextState) - Checks for the current state and changes to the second one.

To change the states with a sequence we have used a code saving time from (current-milliseconds) and comparing it to value. Creating a simple loop. We used a simple approach by calling function (gotoNextState) and sleeping it for a set value to control the time between lights changing. 

*Picture*

After this, we have added 7 segment display with buttons for pedastrian crossing. We did so, by creating a function that catches if the button was pressed, and after cicle finish it's normal sequence it changes to state 13. For 7 segment display, we created different functions to call each number starting from 9 and ending at 1 before changing it to red light ( pedastrian crossing). 

*PICTURE*

The last part we did was to add UltraSonic ( Sound sensor) sensor to check if there is objects on the X way. If there is object in distance between 0 and 20 (0 < x < 20) it checks if red light on way X is on, and if it is, flashes white light (photo shot simulation) 

*PICTURE*

## Issues encountered...

One of the issues we encountered was finding some of the necessary equipment to complete the hardware part of our project. For example we needed a number of red, yellow and green LEDs. The issue was that they didn’t have any of these in the class. We then had to do quite a bit of searching within the building to find the necessary amount.

As we decided to incorporate sensors into our project. However perhaps due to not a great deal of people using these in their project there were none available. This meant we had to do some more searching. We ended up finding a staff member who had access to some and he gave us a couple.

A serious issue that we had towards the end was that the board stopped working for some reason. The LEDS in the breadboard stopped lighting up as usual and there was no real output. The issue arose after we unplugged it and used a different computer the next day. It seemed that there was some issue with the Arduino board communicating with the computer. After spending a great deal of time troubleshooting we ended up coming across a solution. We reinstalled the Asip service pack. After this we received output from the board once again. 

## Things can be improved on...

One thing we could do next time is to change our time spent on the project in the earlier stages. While we did start not long after we were given the assignment, we didn’t spend as much time then and it meant a slight rush toward the end.

Another thing we could do is to integrate our jobs a little better. During this project we were somewhat doing our own things which meant we were not all as clued up on each part of the project as we could have been.

Another thing that would have been a great help but we didn’t really utilise was to find help from other students outside of our group as well as teachers. With some of the bugs we encountered regarding the code we didn’t have the knowledge to easily fix them. While we did eventually it would have been a much quicker and easier process had we found the proper help. 
## Meta

Antanas Icikovic – [LinkedIn](www.linkedin.com/in/antanas-icikovic) – Find me here!

[Video of the project on YouTube](https://www.youtube.com/)



