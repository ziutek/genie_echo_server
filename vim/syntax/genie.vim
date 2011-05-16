if exists("b:current_syntax")
    finish
endif

let s:genie_cpo_save = &cpo
set cpo&vim

" Types
syn keyword genieType			bool char double float size_t ssize_t string unichar void
syn keyword genieType 			int int8 int16 int32 int64 long short
syn keyword genieType 			uint uint8 uint16 uint32 uint64 ulong ushort
syn keyword genieType 			array of dict list
" Storage keywords
syn keyword genieStorage		init def class delegate enum exception interface namespace struct
" repeat / condition / label
syn keyword genieRepeat			break continue do for for return while
syn keyword genieConditional		else if case assert
" User Labels
syn keyword genieLabel			when default

" Modifiers
syn keyword genieModifier		abstract const dynamic ensures extern inline internal override 
syn keyword genieModifier 		private protected public requires signal static virtual volatile weak
syn keyword genieModifier 		async owned unowned
" Constants
syn keyword genieConstant		false null true
" Exceptions
syn keyword genieException		try except finally raise
" Unspecified Statements
syn keyword genieUnspecifiedStatement	as super construct final delete get in is lock new out params ref sizeof set this raises typeof uses value var yield prop print

" Comments
syn cluster genieCommentGroup 		contains=genieTodo
syn keyword genieTodo 			contained TODO FIXME XXX NOTE

" geniedoc Comments (ported from javadoc comments in java.vim)
" TODO: need to verify geniedoc syntax
if !exists("genie_ignore_geniedoc")
  syn cluster genieDocCommentGroup 	contains=genieDocTags,genieDocSeeTag
  syn region  genieDocTags 		contained start="{@\(link\|linkplain\|inherit[Dd]oc\|doc[rR]oot\|value\)" end="}"
  syn match   genieDocTags 		contained "@\(param\|exception\|throws\|since\)\s\+\S\+" contains=genieDocParam
  syn match   genieDocParam 		contained "\s\S\+"
  syn match   genieDocTags 		contained "@\(author\|brief\|version\|return\|deprecated\)\>"
  syn region  genieDocSeeTag       	contained matchgroup=genieDocTags start="@see\s\+" matchgroup=NONE end="\_."re=e-1 contains=genieDocSeeTagParam
  syn match   genieDocSeeTagParam  	contained @"\_[^"]\+"\|<a\s\+\_.\{-}</a>\|\(\k\|\.\)*\(#\k\+\((\_[^)]\+)\)\=\)\=@ extend
endif

" Comment Strings (ported from c.vim)
if exists("genie_comment_strings")
  syn match  	genieCommentSkip		contained "^\s*\*\($\|\s\+\)"
  syn region 	genieCommentString	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=genieSpecialChar,genieCommentSkip
  syn region 	genieComment2String	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=genieSpecialChar
  syn cluster 	genieCommentStringGroup 	contains=genieCommentString,genieCharacter,genieNumber

  syn region 	genieCommentL		start="//" end="$" keepend contains=@genieCommentGroup,genieComment2String,genieCharacter,genieNumber,genieSpaceError,@Spell
  syn region 	genieComment		matchgroup=genieCommentStart start="/\*" end="\*/" contains=@genieCommentGroup,@genieCommentStringGroup,genieCommentStartError,genieSpaceError,@Spell extend
  if !exists("genie_ignore_geniedoc")
    syn region 	genieDocComment 		matchgroup=genieCommentStart start="/\*\*" end="\*/" keepend contains=@genieCommentGroup,@genieDocCommentGroup,@genieCommentStringGroup,genieCommentStartError,genieSpaceError,@Spell
  endif
else
  syn region	genieCommentL		start="//" end="$" keepend contains=@genieCommentGroup,genieSpaceError,@Spell
  syn region	genieComment		matchgroup=genieCommentStart start="/\*" end="\*/" contains=@genieCommentGroup,genieCommentStartError,genieSpaceError,@Spell
  if !exists("genie_ignore_geniedoc")
    syn region 	genieDocComment 		matchgroup=genieCommentStart start="/\*\*" end="\*/" keepend contains=@genieCommentGroup,@genieDocCommentGroup,genieCommentStartError,genieSpaceError,@Spell
  endif
endif
" match comment errors
syntax match genieCommentError 		display "\*/"
syntax match genieCommentStartError 	display "/\*"me=e-1 contained
" match the special comment /**/
syn match   genieComment		 	"/\*\*/"

" Genie Code Attributes
syn region  genieAttribute 		start="^\s*\[" end="\]$" contains=genieComment,genieString keepend
syn region  genieAttribute 		start="\[CCode" end="\]" contains=genieComment,genieString

" Avoid escaped keyword matching
syn match   genieUserContent 		display "@\I*"

" Strings and constants
syn match   genieSpecialError		contained "\\."
syn match   genieSpecialCharError	contained "[^']"
syn match   genieSpecialChar		contained +\\["\\'0abfnrtvx]+
syn region  genieString			start=+"+  end=+"+ end=+$+ contains=genieSpecialChar,genieSpecialError,genieUnicodeNumber,@Spell
syn region  genieVerbatimString		start=+"""+ end=+"""+ contains=@Spell
syn match   genieUnicodeNumber		+\\\(u\x\{4}\|U\x\{8}\)+ contained contains=genieUnicodeSpecifier
syn match   genieUnicodeSpecifier	+\\[uU]+ contained
syn match   genieCharacter		"'[^']*'" contains=genieSpecialChar,genieSpecialCharError
syn match   genieCharacter		"'\\''" contains=genieSpecialChar
syn match   genieCharacter		"'[^\\]'"
syn match   genieNumber			display "\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
syn match   genieNumber			display "\(\<\d\+\.\d*\|\.\d\+\)\([eE][-+]\=\d\+\)\=[fFdD]\="
syn match   genieNumber			display "\<\d\+[eE][-+]\=\d\+[fFdD]\=\>"
syn match   genieNumber			display "\<\d\+\([eE][-+]\=\d\+\)\=[fFdD]\>"

" when wanted, highlight trailing white space
if exists("genie_space_errors")
  if !exists("genie_no_trail_space_error")
    syn match genieSpaceError		display excludenl "\s\+$"
  endif
  if !exists("genie_no_tab_space_error")
    syn match genieSpaceError 		display " \+\t"me=e-1
  endif
endif

" when wanted, set minimum lines for comment syntax syncing
if exists("genie_minlines")
  let b:genie_minlines = genie_minlines
else
  let b:genie_minlines = 50
endif
exec "syn sync ccomment genieComment minlines=" . b:genie_minlines

" The default highlighting.
hi def link genieType			Type
hi def link genieStorage			StorageClass
hi def link genieRepeat			Repeat
hi def link genieConditional		Conditional
hi def link genieLabel			Label
hi def link genieModifier		StorageClass
hi def link genieConstant		Constant
hi def link genieException		Exception
hi def link genieUnspecifiedStatement	Statement
hi def link genieUnspecifiedKeyword	Keyword
hi def link genieContextualStatement	Statement

hi def link genieCommentError		Error
hi def link genieCommentStartError	Error
hi def link genieSpecialError		Error
hi def link genieSpecialCharError	Error
hi def link genieSpaceError 		Error

hi def link genieTodo			Todo
hi def link genieCommentL		genieComment
hi def link genieCommentStart		genieComment
hi def link genieCommentSkip		genieComment
hi def link genieComment			Comment
hi def link genieDocComment		Comment
hi def link genieDocTags 		Special
hi def link genieDocParam 		Function
hi def link genieDocSeeTagParam 		Function
hi def link genieAttribute 		PreCondit

hi def link genieCommentString		genieString
hi def link genieComment2String		genieString
hi def link genieString			String
hi def link genieVerbatimString		String
hi def link genieCharacter		Character
hi def link genieSpecialChar		SpecialChar
hi def link genieNumber			Number
hi def link genieUnicodeNumber		SpecialChar
hi def link genieUnicodeSpecifier	SpecialChar

let b:current_syntax = "genie"

let &cpo = s:genie_cpo_save
unlet s:genie_cpo_save

" vim: ts=8
