
% library(lists).

corequisite("MATH 273", ["MATH 162"]).


prerequisites("MATH 162", ["MATH 161"]).

prerequisites("MATH 251", ["MATH 161"]).

prerequisites("MATH 273", ["MATH 161"]).

prerequisites("MATH 302", ["MATH 251", "MATH 273"]).

prerequisites("MATH 361", ["MATH 251", "MATH 263"]).

prerequisites("MATH 403", ["MATH 302"]).

prerequisites("MATH 460", ["MATH 361"]).

prerequisites("MATH 461", ["MATH 361"]).


prerequisites(Course, Requisite) :- 
    % writeln(["corequisite:", Course]), 
    corequisite(Course, Requisite).


prerequisite(Course, Requisite) :- prerequisites(Course, Requisites), member(Requisite, Requisites).

prerequisite(Course, Requisite) :- prerequisites(Course, Middles), member(Middle, Middles), prerequisite(Middle, Requisite).
% prerequisite(Course, Requisite) :- prerequisite(Course, Middles), member(Middle, Middles), prerequisites(Middle, Requisite).

% prerequisites_all(Course, Requisites) :- findall(Courses, prerequisites(Course, Courses), Requisites).

prerequisites_all(Course, RequisiteSet) :- findall(C, prerequisite(Course, C), Requisites), list_to_set(Requisites, RequisiteSet).
% prerequisites(Course, FlatRequisites) :-
%     % writeln(["prerequisites:", Course]),
%     prerequisites(Course, Middle), 
%     maplist(prerequisites, Middle, Requisite), 
%     flatten(Requisite, FlatRequisites).

% prerequisite(Course, Requisite) :- prerequisites(Course, Requisites), member(Requisite, Requisites).
% prerequisite(Course, FlatRequisitesSet) :- 
%     prerequisites(Course, Requisites), 
%     maplist(prerequisite, Requisites, Requisite), 
%     flatten(Requisite, FlatRequisites), 
%     list_to_set(FlatRequisites, FlatRequisitesSet).
%
