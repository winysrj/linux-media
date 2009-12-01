Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZLAOS4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 09:18:56 -0500
Message-ID: <4B1525A7.1020307@redhat.com>
Date: Tue, 01 Dec 2009 12:18:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Andy Walls <awalls@radix.net>, Krzysztof Halasa <khc@pm.waw.pl>,
	Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, stefanr@s5r6.in-berlin.de,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>	 <m3aay6y2m1.fsf@intrepid.localdomain>	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>	 <1259450815.3137.19.camel@palomino.walls.org>	 <m3ocml6ppt.fsf@intrepid.localdomain>	 <1259542097.5231.78.camel@palomino.walls.org> <4B14F3EA.4090000@redhat.com> <1259668143.3100.18.camel@palomino.walls.org> <4B1521EA.6050306@redhat.com>
In-Reply-To: <4B1521EA.6050306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gerd Hoffmann wrote:
> On 12/01/09 12:49, Andy Walls wrote:
>> On Tue, 2009-12-01 at 11:46 +0100, Gerd Hoffmann wrote:
>>> Once lirc_dev is merged you can easily fix this:  You'll have *one*
>>> driver which supports *both* evdev and lirc interfaces.  If lircd opens
>>> the lirc interface raw data will be sent there, keystrokes come in via
>>> uinput.  Otherwise keystrokes are send directly via evdev.  Problem
>>> solved.
>>
>> This will be kind of strange for lirc_zilog (aka lirc_pvr150).  It
>> supports IR transmit on the PVR-150, HVR-1600, and HD-PVR.  I don't know
>> if transmit is raw pulse timings, but I'm sure the unit provides codes
>> on receive.  Occasionally blocks of "boot data" need to be programmed
>> into the transmitter side.  I suspect lirc_zilog will likely need
>> rework....
> 
> Well, for IR *output* it doesn't make sense to disable evdev.  One more
> reason which indicates it probaably is better to introduce a ioctl to
> disable evdev reporting.  lircd will probably turn it off, especially
> when sending data to uevent.  debug tools might not, likewise apps
> sending IR.
> 
>>>   so killing the in-kernel IR limits to make ir-kbd-i2c
>>                    ^^^^^^^^^^^^^^^^^^^
>>>        being on par with lirc_i2c might be more useful in this case.
>>
>> I didn't quite understand that.  Can you provide a little more info?
> 
> Such as throwing away the address part of rc5 codes ...

This limit were already removed from the subsystem core by the patches
I committed recently (still only at the devel tree - I should be adding
those patches to my linux-next tree likely today). 

The remaining issue is that we'll need to re-scan the IR tables for 
every supported remote to be sure that we're getting the full RC5 code.
It is not complex, but requires lots of work from people that actually have
those IR's.

Cheers,
Mauro.

