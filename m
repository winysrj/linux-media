Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:46159 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZBQBtS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 20:49:18 -0500
Date: Mon, 16 Feb 2009 20:00:34 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Adam Baker <linux@baker-net.org.uk>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Adding a control for Sensor Orientation
In-Reply-To: <200902162236.23516.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.0902161817430.3019@banach.math.auburn.edu>
References: <59373.62.70.2.252.1234773218.squirrel@webmail.xs4all.nl> <200902162236.23516.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 16 Feb 2009, Adam Baker wrote:

> Lots of snipping below so I hope I get the attributions correct.
>
> On Monday 16 February 2009, Hans Verkuil wrote:
>>
>> We are talking about a core change, so some careful thought should go into
>> this.
>
> Agreed, a few days or even weeks spent getting the right solution is far
> better than having to update lots of drivers and apps if we get it wrong.

Also agreed. But please permit me to express surprise that such a problem
never came up before, and does not seem to have been envisioned.

>
>>
>>> So Adam, kilgota, please ignore the rest of this thread and move forward
>>> with the driver, just add the necessary buffer flags to videodev2.h as
>>> part of  your patch (It is usually to submit new API stuff with the same
>>> patch which introduces the first users of this API.
>>
>> Don't ignore it yet :-)
>>

Yeah ...


> I've tried twice to write some code when I thought the discussion had died
> down

I didn't. And now one sees why.

- I'll wait a while before attempting version 3.

Indeed.

>
>> Hans de Goede <hdegoede@redhat.com> wrote:
>>> I welcome libv4l patches to use these flags.
>
> Olivier Lorin submitted a patch to use the flags to support the 180 degree
> rotation - it was pretty trivial but
>
> a) didn't allow v4lconvert_flags to over-ride it to support kernels that don't
> specify behaviour for those cameras

Eeps. So all those legacy kernels out there need to be supported, too.

> b) only coped with HFLIP and VFLIP both being set

Won't fit the present case.

>
> Given an agreed solution I intend to fix both of those problems.

[...]

> I certainly agree that re-using the existing controls doesn't seem like a good
> idea - it seems to combine the case of "the user made a creative decision to
> produce flipped video" with "this hardware always creates flipped video so
> please fix it" [...]

Well put.

> Where does all of that leave us?

Immobilized, apparently.


Sorry, I would be more patient and less flippant if only everything said 
had addressed the point instead of flying off on tangents and discussing 
things which will not solve the problem, no matter how they are decided. 
As an egregious example, it was brought up that there is/is not/should 
be/should not be a table of devices which behave this way or that way, 
according to USB Vendor:Product number. Now, perhaps it is possible to 
construct an ontological argument for the existence of the Perfect Table, 
or one could argue in some neo-Platonist sense that the Perfect Table 
already exists, in the Realm of Ideals, and we mere mortals only need to 
decide where to keep our imperfect copy. But after seeing that discussion 
I feel forced to point out -- again -- right here and right now there sure 
as hell is a device that can't fit in that table, even if said table 
exists and is Perfect, and no matter where it is kept.

Again, the problem is that here is a set of devices all of which have the 
same USB Vendor:Product number, namely 0x2770:0x9120, and some of them 
require that one does A with the output and others require B. How do you 
tell by the Vendor:Product number whether A is required. or B? You don't. 
What you have to do is to ask the device, and it will answer your 
question. Since nothing else in the kernel or in userspace can do that 
asking other than code internal to the module, the only entity which can 
put the question to the device is the module itself. So, I ask everybody, 
please, this is the actual situation. Deal with it.

I am also quite puzzled that no one seems to have anticipated such a 
situation. I am a bit new to the business of writing a kernel module. But 
I have, in recent years, dealt with a lot of the shit hardware that comes 
our way over at Gphoto, the really cheap $10 to $20 cameras which 
sometimes are even used as prizes in boxes of breakfast cereal The SQ905 
cameras are but one example of these. One thing I have definitely learned 
is that hardware can destroy all "reasonable" expectations. One has to 
adjust. We still have to support the hardware.

Returning to the present discussion, what is wrong with a manufacturer 
producing several devices with minor variations and putting the same 
Vendor:Product number on all of them, and providing a way to query the 
specific capabilities and needs of each of them? Nothing, actually. So why 
does it create such a tailspin? Why do I get the impression that nobody 
else here has ever confronted, envisioned, or anticipated such a scenario?
I confess that I am surprised.

Theodore Kilgore
