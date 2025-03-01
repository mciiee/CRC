
% library(lists).

corequisite("MATH 273", "MATH 162").


prerequisite("MATH 162", "MATH 161").

prerequisite("MATH 251", "MATH 161").

prerequisite("MATH 263", "MATH 162").

prerequisite("MATH 273", "MATH 161").

prerequisite("MATH 302", "MATH 251").
prerequisite("MATH 302", "MATH 273").

prerequisite("MATH 361", "MATH 251").
prerequisite("MATH 361", "MATH 263").

prerequisite("MATH 403", "MATH 302").

prerequisite("MATH 460", "MATH 361").

prerequisite("MATH 461", "MATH 361").

%  prerequisite("MATH 461", "MATH 361"): MATH 461 -> MATH 361

prerequisite(Course, Requisite) :- corequisite(Course, Requisite).
% prerequisite(Course, Requisite) :- atom(Course), atom(Requisite), prerequisite(Course, Prerequisite), prerequisite(Prerequisite, Requisite).

prerequisites(Course, Requisite) :- prerequisite(Course, Requisite).
prerequisites(Course, Requisite) :- prerequisite(Middle, Requisite), prerequisites(Course, Middle).

prerequisites_list(Course, Requisites) :- 
    setof(Requisite, prerequisites(Course, Requisite), Requisites). 
    % reverse(Requisites, ReversedReducedRequisites).

% requisites_to_ugraph(Predicate, Course, Graph) :-  Predicate(Course, Requisite), Graph = [Course-[Requsite]].
% prerequisites_to_ugraph(Course, Graph) :-  requisites_to_ugraph(prerequisite, Course, Graph).

% prerequisite_sorted([]).
prerequisite_sorted([_]).
prerequisite_sorted([Course, Requisite]) :- \+(prerequisites(Course, Requisite)).
prerequisite_sorted([Course|[Requisite|Tail]]) :- prerequisite_sorted([Course, Requisite]), prerequisite_sorted([Requisite|Tail]).
