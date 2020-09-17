# Twittermenti
This app was created as a part of a [Udemy course](https://www.udemy.com/share/101WsWAEMScldUQn8F/) I am taking (September 2020).

The goal was to create an iOS app in which the user enters a handle, hashtag, or phrase to see how Twitter users feel about that particular topic.

The app uses a CoreML model to analyze the individual sentiment of the last 100 Tweets containing the user's entered phrase. An emoji is displayed to the user based on an aggregate sentiment score.

I added in the IQKeyboardManagerSwift Cocoapod to dismiss the keyboard on return or when the user touches anywhere on the screen. I also updated the UI constraints to extend past safe areas for all device types.

## Lesson Objectives

* Create a Twitter sentiment analysis machine learning model using natural language processing (NLP) tools from CreateML.
* How to use the Twitter API
* Work with Cocoapods

>This is a companion project to The App Brewery's Complete App Development Bootcamp, check out the full course at [www.appbrewery.co](https://www.appbrewery.co/)

## Final Result
![](TwittermentiDemo.gif)
