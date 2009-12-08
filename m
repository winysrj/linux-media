Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379AbZLHQ1O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 11:27:14 -0500
Message-ID: <4B1E7E56.80701@redhat.com>
Date: Tue, 08 Dec 2009 14:27:02 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Andy Walls <awalls@radix.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>	 <6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com>	 <1260240142.3086.14.camel@palomino.walls.org>	 <20091208042210.GA11147@core.coreip.homeip.net>	 <1260275743.3094.6.camel@palomino.walls.org>	 <4B1E54FF.8060404@redhat.com>	 <9e4733910912080547j75c2c885o29664470ff5e2c6a@mail.gmail.com>	 <4B1E5BDF.7010202@redhat.com>	 <9e4733910912080619t36089c9bg5e54114844b9694a@mail.gmail.com>	 <4B1E640B.6030705@redhat.com> <9e4733910912080756j7e1fac32qc552c6514a307b7d@mail.gmail.com>
In-Reply-To: <9e4733910912080756j7e1fac32qc552c6514a307b7d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Tue, Dec 8, 2009 at 9:34 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Jon Smirl wrote:
>>> On Tue, Dec 8, 2009 at 8:59 AM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com> wrote:
>>>> Jon Smirl wrote:
>>>>> On Tue, Dec 8, 2009 at 8:30 AM, Mauro Carvalho Chehab
>>>>> <mchehab@redhat.com> wrote:
>>>>>> Andy Walls wrote:
>>>>>>> On Mon, 2009-12-07 at 20:22 -0800, Dmitry Torokhov wrote:
>>>>>>>> On Mon, Dec 07, 2009 at 09:42:22PM -0500, Andy Walls wrote:
>>>>>>>>> So I'll whip up an RC-6 Mode 6A decoder for cx23885-input.c before the
>>>>>>>>> end of the month.
>>>>>>>>>
>>>>>>>>> I can setup the CX2388[58] hardware to look for both RC-5 and RC-6 with
>>>>>>>>> a common set of parameters, so I may be able to set up the decoders to
>>>>>>>>> handle decoding from two different remote types at once.  The HVR boards
>>>>>>>>> can ship with either type of remote AFAIK.
>>>>>>>>>
>>>>>>>>> I wonder if I can flip the keytables on the fly or if I have to create
>>>>>>>>> two different input devices?
>>>>>>>>>
>>>>>>>> Can you distinguish between the 2 remotes (not receivers)?
>>>>>>> Yes.  RC-6 and RC-5 are different enough to distinguish between the two.
>>>>>>> (Honestly I could pile on more protocols that have similar pulse time
>>>>>>> periods, but that's complexity for no good reason and I don't know of a
>>>>>>> vendor that bundles 3 types of remotes per TV card.)
>>>>>> You'll be distinguishing the protocol, not the remote. If I understood
>>>>>> Dmitry's question, he is asking if you can distinguish between two different
>>>>>> remotes that may, for example, be using both RC-5 or both RC-6 or one RC-5
>>>>>> and another RC-6.
>>>>> RC-5 and RC-6 both contain an address field.  My opinion is that
>>>>> different addresses represent different devices and in general they
>>>>> should appear on an input devices per address.
>>>> The same IR can produce two different addresses. The IR bundled with my satellite
>>>> STB produces two different codes, depending if you previously pressed <TV> or <SAT>
>>>> key (in fact, I think it can even produce different protocols for TV, as it can
>>>> be configured to work with different TV sets).
>>> You have a multi-function remote.
>> Yes.
>>
>>> That's why those keys don't send codes. When writing code you should
>>> think of this remote as being two indpendent virtual remotes, not a
>>> single one.
>> Not really. I may think on it as a single device and use the two groups
>> of functions to control two aspects at the same application.
>>
>> For example, I may map the <TV> group on kaffeine for DVB reception and the
>> <SAT> group for DVD (well, probably, in this case, I'll use an IR with
>> <TV> and <DVD> keys, instead ;) ).
>>
>>> By using maps containing the two different addresses for <TV> and
>>> <SAT> you can split these commands onto two different evdev devices.
>> True. I can do it, but I can opt to have both mapped as one evdev device as well.
>> This will basically depend on how I want to mount my environment.
>>
>>> This model is complicated by the fact that some remotes that look like
>>> multi-function remotes aren't really multifunction. The remote bundled
>>> with the MS MCE receiver is one. That remote is a single function
>>> device even though it has function buttons for TV, Music, Pictures,
>>> etc.
>> It is very common to have such remotes bundled with multimedia devices.
>>
>> An unsolved question on my mind is how should we map such IR's? Should we
>> provide a way for them to emulate a multifunction IR (for example, after pressing
>> TV key, subsequent keystrokes would be directed to the TV evdev device?), or
>> should we let this up to some userspace app to handle this case?
> 
> Splitting them into multiple devices requires remembering state and
> scripting so it needs to be done in user space.

It shouldn't be hard to do it in kernelspace, since you'll need to have
one evdev interface associated with the IR anyway, but this will add
some extra complexity at the scancode->keycode conversion, but I'm wandering
if we should do it or not.

Maybe the better is to not do it in kernelspace, to avoid adding there an
extra complexity that can easily be done in userspace.

> If the user wants to
> control a radio app and a home automation app they need to choose.
> Keep the bundled remote and do some non-trivial scripting or buy a
> universal remote.

Ok, but using the shipped IR even without a separate address group for
different applications, and having it controlling radio app and tv app
(not simultaneously) should not be hard, but I LIRC already covers such
usecase, so maybe we don't need to worry about it.

> Universal remotes make it much easier to achieve "just works".

True.

> The IR core can contain default universal profiles for various classes
> of devices. Say Morotola_DVR and SciAtlanta_DVR. The core would check
> if the receiver is cable of receiving these profiles before loading
> them. There would be ten of these default universal profiles at most
> and you can unload them from RAM if they aren't needed.
> 
> Now Myth can have a menu with three remote choices:
>  Universal Morotola_DVR
>  Universal SciAtlanta_DVR
>  Bundled
> 
> The Bundled choice came from the map built into the IR receiver's device driver.
> The other two choices were loaded by the IR core after ensuring that
> the hardware could receive from a universal remote.
> 
> The core would also load a couple of default radio profiles
>  Univeral SonyDR112_RADIO
>  Univeral OnkyoTX8255_RADIO
> Same for automation and mouse/keyboard emulation.

Agreed.

> Myth looks in sysfs and builds a menu containing DVR devices and all
> bundled entries. First app to open the "Bundled" device gets to keep
> it.

Myth (or other userspace apps) don't need to to that, since we've standardized
the keycode actions (see the IR chapter of the media DocBook). It just
needs to support the keycodes already defined, for the common case.

> These apps could take "just works" even farther. When they start up
> they could listen on all three evdev devices:  Morotola_DVR,
> SciAtlanta_DVR,   Bundled. And then if you find Myth responding to
> unwanted commands you could disable the unwanted profiles by
> deselecting them in the Myth UI.

I don't like the idea of automatically loading 3 different keycodes at the
same time. You may have overlaps between different keycode tables. The
better is to have some userspace GUI that will allow the user to select
what keycode table(s) he want to be available, if he decides to not use the
bundled IR.

The same applies to applications: if you have 3 keymaps loaded, is because you
want do do different things with the 3 keymaps (like using keymap 1 for kaffeine,
keymap 2 for mplayer, keymap 3 for mythtv).

So, IR-aware applications should have a setup interface to specify what IR keycodes
are relevant to that particular application, and how to associate an evdev interface
to an specific group of functions (for applications that supports several different
types of media, like MythTV and Kaffeine, where you'll end by having a "TV" keymap/evdev,
a "Radio" keymap/evdev, a "CD/DVD" Keymap/evdev, etc).

Btw, if we're doing that, IMO, we should have an string sysfs alias attribute,
to allow associating the userspace application to an specific keymap alias 
(like "radio", "tv", etc.).

> All of this may seem complicated to build, but the purpose is to
> create an environment where a non-technical user can get an IR remote
> working without needing detailed knowledge about how IR protocols
> work.

IMO, this is an important requisite to fulfill.

Cheers,
Mauro.
