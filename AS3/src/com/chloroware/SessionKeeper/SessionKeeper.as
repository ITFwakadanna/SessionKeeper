// ActionScript file
package com.chloroware.SessionKeeper{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	public class SessionKeeper extends EventDispatcher{
		
		private var _ExtensionContext:ExtensionContext;
		
		public function SessionKeeper(target:IEventDispatcher=null){
			//TODO: implement function
			super(target);
			_ExtensionContext = ExtensionContext.createExtensionContext("com.chloroware.SessionKeeper", null);
		}
		
		public function dispose():void{
			_ExtensionContext.dispose();
		}
		
		public function saveCookie():void {
			try{
				_ExtensionContext.call("saveCookie");
			}catch(ex:Error){
				trace(ex.message);
			}
		}
		public function readCookie():void {
			try{
				_ExtensionContext.call("readCookie");
			}catch(ex:Error){
				trace(ex.message);
			}
		}
	}
}