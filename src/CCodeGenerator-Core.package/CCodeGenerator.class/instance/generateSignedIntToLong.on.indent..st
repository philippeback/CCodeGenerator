C translation
generateSignedIntToLong: msgNode on: aStream indent: level
	"Generate the C code for this message onto the given stream."

	aStream nextPutAll: '((usqInt) '.
	(vmClass notNil
	 and: [vmClass wordSize = 8]) ifTrue:
		[aStream nextPutAll: '(int)'].
	self emitCExpression: msgNode receiver on: aStream.
	aStream nextPut: $)