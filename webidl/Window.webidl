// add missing fields to the window object

partial interface Window {

	// console is defined as a namespace but it's often used as a member of the window object
	readonly attribute ConsoleInstance console;

};