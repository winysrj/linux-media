Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:53841 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZLCFSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 00:18:49 -0500
MIME-Version: 1.0
In-Reply-To: <5FED031C-C24B-4F82-9621-EB1C8A5B928B@wilsonet.com>
References: <4B155288.1060509@redhat.com> <4B16614A.3000208@redhat.com>
	 <20091202171059.GC17839@core.coreip.homeip.net>
	 <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
	 <4B16BE6A.7000601@redhat.com>
	 <20091202195634.GB22689@core.coreip.homeip.net>
	 <2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>
	 <9e4733910912021620s7a2b09a8v88dd45eef38835a@mail.gmail.com>
	 <Pine.LNX.4.58.0912021827120.4729@shell2.speakeasy.net>
	 <5FED031C-C24B-4F82-9621-EB1C8A5B928B@wilsonet.com>
Date: Thu, 3 Dec 2009 00:18:54 -0500
Message-ID: <9e4733910912022118h28058f4dt2815c3da4f717b02@mail.gmail.com>
Subject: Re: [RFC v2] Another approach to IR
From: Jon Smirl <jonsmirl@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 2, 2009 at 11:13 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> On Dec 2, 2009, at 9:48 PM, Trent Piepho wrote:
> ...
>>>>> Now I understand that if 2 remotes send completely identical signals we
>>>>> won't be able to separate them, but in cases when we can I think we
>>>>> should.
>>>>
>>>> I don't have a problem with that, if its a truly desired feature.  But
>>>> for the most part, I don't see the point.  Generally, you go from
>>>> having multiple remotes, one per device (where "device" is your TV,
>>>> amplifier, set top box, htpc, etc), to having a single universal remote
>>>> that controls all of those devices.  But for each device (IR receiver),
>>>> *one* IR command set.  The desire to use multiple distinct remotes with
>>>> a single IR receiver doesn't make sense to me.  Perhaps I'm just not
>>>> creative enough in my use of IR.  :)
>>
>> Most universal remotes I'm familiar with emulate multiple remotes.  I.e.
>> my tv remote generates one set of scancodes for the numeric keys.  The DVD
>> remote generates a different set.  The amplifier remote in "tv mode"
>> generates the same codes as the tv remote, and in "dvd mode" the same codes
>> as the dvd remote.  From the perspective of the IR receiver there is no
>> difference between having both the DVD and TV remotes, or using the
>> aplifier remote to control both devices.
>
> Okay, in the above scenario, you've still got a single input device...
>
>> Now, my aplifier remote has a number of modes.  Some control devices I
>> have, like "vcr mode", and there is nothing I can do about that.  Some,
>> like "md mode" don't control devices I have.  That means they are free to
>> do things on the computer.  Someone else with the same remote (or any
>> number of remotes that use the same protocol and scancodes) might have
>> different devices.
>>
>> So I want my computer to do stuff when I push "JVC MD #xx" keys, but ignore
>> "JVC VCR #yyy" yets.  Someone with an MD player and not a VCR would want to
>> opposite.  Rather than force everyone to create custom keymaps, it's much
>> easier if we can use the standard keymaps from a database of common remotes
>> and simply tell mythtv to only use remote #xxx or not to use remote #yyy.
>
> Sure, but the key is that this can't be done automagically. The IR driver has no way of knowing that user A wants JVC MD keys handled and JVC VCR keys ignored, and user B wants vice versa, while user C wants both ignored, etc. This is somewhat tangential to whether or not there's a separate input device per "remote" though. You can use multiple remotes/protocols with a single input device or lirc device already (if the hardware doesn't have to be put explicitly into a mode to listen for that proto, of course, but then its a hardware decoding device feeding a single input device anyway, so...).
>
>> It sounds like you're thinking of a receiver that came bundled with a
>> remote and that's it.  Not someone with a number of remotes that came with
>> different pieces of AV gear that they want to use with their computer.
>
> No, I just pick *one* remote and use it for everything, not schizophrenically hopping from one remote to another, expecting them all the be able to control everything. :) Its a hell of a lot easier to find buttons w/o looking at the remote if you always use the same one for everything, for one.
>
> Anyway, I think I'm talking myself in circles. Supporting multiple remotes via multiple input devices (or even via a single input device) isn't at all interesting to me for my own use, but if there really is demand for such support (and it appears there is), then fine, lets do it.

Simple use case:

You have a multifunction remote. Press the CABLE key - it sends out
commands that control the cable box, press the TV key - now the
commands control the TV, press CD - now the CD player, etc.

Now imagine a headless Linux box running a music server and a home
automation app. Press the CD key - commands get routed to the music
server, press the AUX key - commands get routed to the home automation
app.

This is accomplished by recognizing the device code part of the IR
signal and figuring out that there are two different device codes in
use. The commands of then routed to two evdev devices corresponding to
the two different device codes.

Using things like Alt-Tab to switch apps is impossible. There's no
screen to look at.

>
> --
> Jarod Wilson
> jarod@wilsonet.com
>
>
>
>



-- 
Jon Smirl
jonsmirl@gmail.com
