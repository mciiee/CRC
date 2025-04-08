:- set_prolog_flag(double_quotes, chars).
:- set_prolog_flag(answer_write_options,[max_depth(0)]).
:- use_module(library(dcg/basics)).
:- use_module(library(ctypes)).

ws --> "" | ['\n'] | ['\t'] | ['\r'].
ws --> ['\n'], ws.
ws --> ['\t'], ws.
ws --> ['\r'], ws.

is_course_subject_check("MATH").
is_course_subject_check("CSCI").

courseSubject(X) -->  [X], {is_course_subject_check(X)}.
singleNonZeroDigit(X) --> [X], {X>=1, 9>=X}.
singleDigit(X) --> [X], {9>=X}.
courseCodes([X,Y,Z]) --> singleNonZeroDigit(X), singleDigit(Y), singleDigit(Z).

course([]) --> "".
course([[CourseSubject,CourseCode]]) --> courseSubject(CourseSubject), ws, courseCodes(CourseCode).
course([[CourseSubject,CourseCode]|Tail]) --> course([CourseSubject,CourseCode]), "/", course(Tail), {\+(Tail = [])}.

is_whitespace_sans_newline(' ').
is_whitespace_sans_newline('').
is_whitespace_sans_newline('\t').

util_is_newline('\n').
util_is_newline('\r').



tokenize_chararray([WhiteSpaceNotNewline|InputTail], Acc, Tokens) :- char_type(WhiteSpaceNotNewline, white), tokenize_chararray(InputTail, [whitespace_token|Acc], Tokens).
tokenize_chararray([WhiteSpaceNotNewline|InputTail], [whitespace_token|Acc], Tokens) :- char_type(WhiteSpaceNotNewline, white), tokenize_chararray(InputTail, [whitespace_token|Acc], Tokens).


tokenize_chararray([Newline|InputTail], [newline_token|Acc], Tokens) :- util_is_newline(Newline), tokenize_chararray(InputTail, [newline_token|Acc], Tokens).
tokenize_chararray([Newline|InputTail], Acc, Tokens) :- util_is_newline(Newline), tokenize_chararray(InputTail, [newline_token|Acc], Tokens).


tokenize_chararray(['-','>'|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [prereq_arrow_token|Acc], Tokens). 
tokenize_chararray(['~','>'|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [coreq_arrow_token|Acc], Tokens). 
tokenize_chararray(['!','>'|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [antireq_arrow_token|Acc], Tokens).

tokenize_chararray([','|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [conjunction_token|Acc], Tokens).
tokenize_chararray(['|'|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [disjunction_token|Acc], Tokens).

tokenize_chararray(['/'|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [adjunction_token|Acc], Tokens).


tokenize_chararray(['#'|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [comment_token|Acc], Tokens).

tokenize_chararray(['.'|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [end_of_sentence_token|Acc], Tokens).



tokenize_chararray(['('|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [paren_open_token|Acc], Tokens).
tokenize_chararray([')'|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [paren_close_token|Acc], Tokens).

% Cuts are purely for optimization
tokenize_chararray([Char|InputTail], [course_subject_chars_token([PrevChar|PrevCharTail])|Acc], Tokens) :- char_type(Char, ascii), char_type(Char, upper), append([PrevChar|PrevCharTail], [Char], CourseSubj), tokenize_chararray(InputTail, [course_subject_chars_token(CourseSubj)|Acc], Tokens), !.
tokenize_chararray([Char|InputTail], Acc, Tokens) :- char_type(Char, ascii), char_type(Char, upper), tokenize_chararray(InputTail, [course_subject_chars_token([Char])|Acc], Tokens), !.



tokenize_chararray([Digit|InputTail], [course_code_digits_token([PrevDigit|PrevDigitTail])|Acc], Tokens) :- char_type(Digit, digit), append([PrevDigit|PrevDigitTail], [Digit], Digits), tokenize_chararray(InputTail, [course_code_digits_token(Digits)|Acc], Tokens), !.
tokenize_chararray([Digit|InputTail], Acc, Tokens) :- char_type(Digit, digit), tokenize_chararray(InputTail, [course_code_digits_token([Digit])|Acc], Tokens), !.


tokenize_chararray([Head|InputTail], [unknown_token([Prev|PrevTail])|Acc], Tokens) :- append([Prev|PrevTail], [Head], TotalToken), tokenize_chararray(InputTail, [unknown_token(TotalToken)|Acc], Tokens), !.
tokenize_chararray([Head|InputTail], [unknown_token(Prev)|Acc], Tokens) :- tokenize_chararray(InputTail, [unknown_token([Prev,Head])|Acc], Tokens), !.
tokenize_chararray([Head|InputTail], Acc, Tokens) :- tokenize_chararray(InputTail, [unknown_token(Head)|Acc], Tokens), !.


tokenize_chararray([], Acc, Acc). 



course_entries([]).
course_entries([CourseEntry|Courses]) --> course_dependencies_entry(CourseEntry), course_entries(Courses).


