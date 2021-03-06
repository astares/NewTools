Class {
	#name : #StSpotterModel,
	#superclass : #Object,
	#instVars : [
		'candidateAddedAction',
		'searchUpdatedAction',
		'queries',
		'activeQuery'
	],
	#category : #'NewTools-Spotter-Model'
}

{ #category : #private }
StSpotterModel >> activateQuery: aQuery [

	activeQuery ifNotNil: [ self disconnectQuery: aQuery ].
	activeQuery := aQuery.
	self connectQuery: aQuery
]

{ #category : #private }
StSpotterModel >> announceSearchUpdated [

	searchUpdatedAction ifNil: [ ^ self ].
	searchUpdatedAction value
]

{ #category : #processing }
StSpotterModel >> asyncProcess: aString [

	[ 
		Processor yield.
		self process: aString. 
	] schedule
]

{ #category : #private }
StSpotterModel >> connectQuery: aQuery [

	aQuery announcer
		when: StSpotterCandidateAdded send: #announceSearchUpdated to: self;
		when: StSpotterAllCandidatesAdded send: #announceSearchUpdated to: self.	
]

{ #category : #accessing }
StSpotterModel >> defaultProcessors [

	^ (StSpotterProcessor allEnabledSubclasses 
		collect: [ :each | each new ])
		sort: #order ascending
]

{ #category : #private }
StSpotterModel >> disconnectQuery: aQuery [

	aQuery announcer unsubscribe: self
]

{ #category : #initialization }
StSpotterModel >> initialize [

	super initialize.
	queries := OrderedCollection new
]

{ #category : #accessing }
StSpotterModel >> links [

	^ activeQuery 
		ifNotNil: [ :aQuery | aQuery links ]
		ifNil: [ #() ]
]

{ #category : #processing }
StSpotterModel >> process: aString [
	| query |
	
	query := self queryFor: aString.
	query ifNotNil: [ ^ self activateQuery: query ].

	query := StSpotterQuery on: aString.
	query processors: self defaultProcessors.
	self activateQuery: query.
	query process
]

{ #category : #private }
StSpotterModel >> queryFor: aString [

	^ queries 
		detect: [ :each | each text = aString ]
		ifNone: [ nil ]
]

{ #category : #accessing }
StSpotterModel >> results [

	^ activeQuery 
		ifNotNil: [ :aQuery | aQuery results ]
		ifNil: [ #() ]
]

{ #category : #processing }
StSpotterModel >> startProcessing [

	"First query: empty (to bring windows, menu, etc.)"
	self asyncProcess: ''
]

{ #category : #events }
StSpotterModel >> whenSearchUpdatedDo: aBlock [

	searchUpdatedAction := aBlock
]
