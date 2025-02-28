
contains([Element|_], Element).
contains([_|Tail], Element) :- contains(Tail, Element).

% intersect(List, [FirstElements|OtherElements]) :- contains(List, FirstElements), contains(List, OtherElements).


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



prerequisite(Course, Requisite) :- corequisite(Course, Requisite).


prerequisites(Course, Requisite) :- prerequisite(Course, Requisite).
prerequisites(Course, Requisite) :- prerequisite(Middle, Requisite), prerequisites(Course, Middle).

prerequisites_list(Course, ReducedRequisites) :- findall(Requisite, prerequisites(Course, Requisite), Requisites), list_to_set(Requisites, ReducedRequisites).
