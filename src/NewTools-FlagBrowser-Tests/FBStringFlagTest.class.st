"
A FBStringFlagTest is a test class for testing the behavior of FBStringFlag
"
Class {
	#name : #FBStringFlagTest,
	#superclass : #FBFlagTest,
	#category : #'NewTools-FlagBrowser-Tests-Base'
}

{ #category : #accessing }
FBStringFlagTest >> actualClass [
	^ FBStringFlag
]

{ #category : #helpers }
FBStringFlagTest >> defaultParameter [
	^ 'test'
]

{ #category : #helpers }
FBStringFlagTest >> insensitiveParameter [
	^ 'Test'
]
