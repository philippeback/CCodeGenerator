inlining
sizeOfIntegralCType: anIntegralCType "<String>"
	"N.B. Only works for values for which isIntegralCType: answers true."
	| prunedCType index |
	(anIntegralCType beginsWith: 'register ') ifTrue:
		[^self sizeOfIntegralCType: (anIntegralCType allButFirst: 9)].
	prunedCType := (anIntegralCType beginsWith: 'unsigned ')
						ifTrue: [(anIntegralCType allButFirst: 9) trimBoth]
						ifFalse: [(anIntegralCType beginsWith: 'signed ')
									ifTrue: [(anIntegralCType allButFirst: 7) trimBoth]
									ifFalse: [anIntegralCType]].
	^prunedCType asString caseOf: {
		['sqLong']	->	[8].
		['usqLong']	->	[8].
		['long long']	->	[8].
		['sqInt']		->	[BytesPerWord].
		['usqInt']	->	[BytesPerWord].
		['int']		->	[4].
		['short']		->	[2].
		['short int']	->	[2].
		['char']		->	[1].
		['long']		->	[BytesPerWord].
		['size_t']		->	[BytesPerWord].
		['pid_t']		->	[BytesPerWord].
	}
	otherwise:
		[((anIntegralCType beginsWith: 'unsigned') "e.g. 'unsigned  : 8'"
		  and: [(anIntegralCType includesAnyOf: '[*]') not
		  and: [(index := anIntegralCType indexOf: $:) > 0]])
			ifTrue: [(Integer readFrom: (anIntegralCType copyFrom: index + 1 to: anIntegralCType size) trimBoth readStream) + 7 // 8]
			ifFalse: [self error: 'unrecognized integral type']]