Return-path: <linux-media-owner@vger.kernel.org>
Received: from thsmsgxrt13p.thalesgroup.com ([192.54.144.136]:43513 "EHLO
	thsmsgxrt13p.thalesgroup.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756023AbZLCR0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 12:26:31 -0500
Message-ID: <4B17F09E.3020201@thalesgroup.com>
Date: Thu, 03 Dec 2009 18:08:46 +0100
From: =?ISO-8859-1?Q?Emmanuel_Fust=E9?= <emmanuel.fuste@thalesgroup.com>
MIME-Version: 1.0
To: mchehab@redhat.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [RFC v2] Another approach to IR
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Jon Smirl wrote:
> > On Wed, Dec 2, 2009 at 11:13 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> >> On Dec 2, 2009, at 9:48 PM, Trent Piepho wrote:
> >> ...
> >>>>>> Now I understand that if 2 remotes send completely identical signals we
> >>>>>> won't be able to separate them, but in cases when we can I think we
> >>>>>> should.
> >>>>> I don't have a problem with that, if its a truly desired feature.  But
> >>>>> for the most part, I don't see the point.  Generally, you go from
> >>>>> having multiple remotes, one per device (where "device" is your TV,
> >>>>> amplifier, set top box, htpc, etc), to having a single universal remote
> >>>>> that controls all of those devices.  But for each device (IR receiver),
> >>>>> *one* IR command set.  The desire to use multiple distinct remotes with
> >>>>> a single IR receiver doesn't make sense to me.  Perhaps I'm just not
> >>>>> creative enough in my use of IR.  :)
> >>> Most universal remotes I'm familiar with emulate multiple remotes.  I.e.
> >>> my tv remote generates one set of scancodes for the numeric keys.  The DVD
> >>> remote generates a different set.  The amplifier remote in "tv mode"
> >>> generates the same codes as the tv remote, and in "dvd mode" the same codes
> >>> as the dvd remote.  From the perspective of the IR receiver there is no
> >>> difference between having both the DVD and TV remotes, or using the
> >>> aplifier remote to control both devices.
> >> Okay, in the above scenario, you've still got a single input device...
> >>
> >>> Now, my aplifier remote has a number of modes.  Some control devices I
> >>> have, like "vcr mode", and there is nothing I can do about that.  Some,
> >>> like "md mode" don't control devices I have.  That means they are free to
> >>> do things on the computer.  Someone else with the same remote (or any
> >>> number of remotes that use the same protocol and scancodes) might have
> >>> different devices.
> >>>
> >>> So I want my computer to do stuff when I push "JVC MD #xx" keys, but ignore
> >>> "JVC VCR #yyy" yets.  Someone with an MD player and not a VCR would want to
> >>> opposite.  Rather than force everyone to create custom keymaps, it's much
> >>> easier if we can use the standard keymaps from a database of common remotes
> >>> and simply tell mythtv to only use remote #xxx or not to use remote #yyy.
> >> Sure, but the key is that this can't be done automagically. The IR driver has no way of knowing that user A wants JVC MD keys handled and JVC VCR keys ignored, and user B wants vice versa, while user C wants both ignored, etc. This is somewhat tangential to whether or not there's a separate input device per "remote" though. You can use multiple remotes/protocols with a single input device or lirc device already (if the hardware doesn't have to be put explicitly into a mode to listen for that proto, of course, but then its a hardware decoding device feeding a single input device anyway, so...).
> >>
> >>> It sounds like you're thinking of a receiver that came bundled with a
> >>> remote and that's it.  Not someone with a number of remotes that came with
> >>> different pieces of AV gear that they want to use with their computer.
> >> No, I just pick *one* remote and use it for everything, not schizophrenically hopping from one remote to another, expecting them all the be able to control everything. :) Its a hell of a lot easier to find buttons w/o looking at the remote if you always use the same one for everything, for one.
> >>
> >> Anyway, I think I'm talking myself in circles. Supporting multiple remotes via multiple input devices (or even via a single input device) isn't at all interesting to me for my own use, but if there really is demand for such support (and it appears there is), then fine, lets do it.
> > 
> > Simple use case:
> > 
> > You have a multifunction remote. Press the CABLE key - it sends out
> > commands that control the cable box, press the TV key - now the
> > commands control the TV, press CD - now the CD player, etc.
> > 
> > Now imagine a headless Linux box running a music server and a home
> > automation app. Press the CD key - commands get routed to the music
> > server, press the AUX key - commands get routed to the home automation
> > app.
> > 
> > This is accomplished by recognizing the device code part of the IR
> > signal and figuring out that there are two different device codes in
> > use. The commands of then routed to two evdev devices corresponding to
> > the two different device codes.
> > 
> > Using things like Alt-Tab to switch apps is impossible. There's no
> > screen to look at.
>
> This usecase makes sense to me.
>
> With the risk of repeating myself, you don't have two physical remotes.
> The needed feature is a way to split one source of input events (that
> happens to be an infrared remote, but it could also be any other type of input
> device, like a bluetooth remote) into several different evdev interfaces,
> based on scancode groups. 
>
In real world you generally have two physical remote. In this particular case you simply have a sort of semi-universal remote, a two or tree in one remote.
More particularly, you have a remote which is aimed at talking to two or tree different "real" devices or in our case different applications. If the application is a multifunction one it should be seen as multiple application.
Don't mix IR encoding informations and applications : I don't care if each button of my mono-function remote use a different IR protocol that what the mapping table is for. One simple remote is a group of button, each button is the result of an IR transmission decoded in an internal IR stack representation.
Don't mix IR encoding informations and remote representation : that not because a protocol have a concept of vendor/device/command or sort of that we should do automatic grouping by vendor/device/command. These protocol/vendor/device/command informations should only be reported as "raw" data to simplify the life of the application responsible to create the mapping tableS.
We should have one evdev device per mapping table. Each table has a label.
For one simple "mono" function remote, I create one table labeled "simplexyz" or better, I told to my IR config app that I have the remote model "simplexyz" and the good mapping is fetched from the database an injected is the "simplexyz" mapping table, effectively creating the "simplexyz" device. In my cd player app, in the "remote config menu", I chose "simplexyz" device as the used remote.
For my "tree in one" remote model yamahaxyz , my config app fetch and create tree mapping: yamahaxyz-vcr, yamahaxyz-cd, yamahaxyz-tv, creating tree device. In cdplayer application, I add yamahaxyz-cd as a remote, in mythtv, I add yamahaxyz-tv for the TV part and yamahaxyz-vcr for the recording part. Multifunction application should provide a way to use a different device for each "standard as in real world" base function.
In this example, I could assign the same remote yamahaxyz-vcr for tv and vcr part of Mythtv (because vrc generally include a tv tuner and all the button to use it in the vcr ir group) to control the two functions of Mythtv.
In all application, I use standard evdev keycodes, augmented with some new added because of this new kind of input device.
Each IR aware application simply use one or more device for each different base profile function.
(1)You could even think of an application which use one of your remote (mapping table) to re-inject standard keyboad events to control your other applications with key shortcuts. Don't forget to map alt-tab ;-)
With this scheme, we stay in the pure evdev world for more than 90% of the time, even to load mappings/create devices. The only IR-internals aware application is the one to create/modify mappings, a remote editor.

Universal remote are emulating a bunch of simple or multifunction remote and are not a natural beast, users take time to set them up. As such they could be views from your application as a collections of standard remote or one or more purely user defined ones. For this later case, I expect to have a great graphical remote mapping editor with auto learn features. 

This is the most flexible and simple scheme. I could not think of a case it could not handle and it achieve a clean layering between the IR events and the applications.
For the other layers, we have the IR receiver device part, and the decoding part. The device part is an in kernel device driver problem. Even for dumb serial and pp devices for which we should have a line discipline and a parport client driver to archive good acquisition timing and low cpu/power usage (no userspace busywait loop).
Device with hardware decoding and or no raw capability feed directly the input subsystem to be dispatched to the different evdev devices.
lircd could still be used for his scripting part as seen in (1)
For the raw receivers, we could have in kernel decoders and/or lircd in user space. It is just the mater of feeding a sort of lirc device instead of the in kernel decoder. But please, raw ir data in the form of pulse event has nothing to do with the input and event layer.

Splitting one source of input events into several different evdev interfaces is a very simple thing at the input subsystem layer. And as explain, this splitting should never never never be based on protocol/vendor/device/command scancode groups but only based on mapping table.

My two cents, 


Cheers,
Emmanuel.

