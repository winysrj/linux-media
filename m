Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341Ab0BJSkh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:40:37 -0500
Message-ID: <4B72FD83.1050500@redhat.com>
Date: Wed, 10 Feb 2010 16:40:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: hermann pitton <hermann-pitton@arcor.de>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135 variants
References: <20100127120211.2d022375@hyperion.delvare>	<4B630179.3080006@redhat.com>	<1264812461.16350.90.camel@localhost>	<20100130115632.03da7e1b@hyperion.delvare>	<1264986995.21486.20.camel@pc07.localdom.local>	<20100201105628.77057856@hyperion.delvare>	<1265075273.2588.51.camel@localhost>	<20100202085415.38a1e362@hyperion.delvare>	<4B681173.1030404@redhat.com> <20100210190907.5c695e4e@hyperion.delvare>
In-Reply-To: <20100210190907.5c695e4e@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean Delvare wrote:
> Hi Mauro,
> 
> Sorry for the late answer. I'm tracking so many things in parallel...

No problem.

>> What happens is that the saa7134_board_init1(dev) code has lots of gpio codes, 
>> and most of those code is needed in order to enable i2c bridges or to turn on/reset 
>> some chips that would otherwise be on OFF or undefined state. Without the gpio code, 
>> done by init1, you may not be able to read eeprom or to detect the devices as needed
>> by saa7134_board_init2().
> 
> I don't think I ever said otherwise. I never said that init1 as a whole
> only cared about GPIO IR. That's what I said of function
> saa7134_input_init1() and only this function!

Ah, ok. I suspect I miss-understood when you talked about "init1", since 99%
of the patches about init1 are related to board init, and not to input init.

> My first proposed patch didn't move all of init1 to init2. It was only
> moving saa7134_input_init1 (which doesn't yet have a counterpart in
> init2), and it is moving it from the end of init1 to the beginning of
> init2, so the movement isn't as big as it may sound. The steps
> saa7134_input_init1() is moving over are, in order:
> * saa7134_hw_enable1
> * request_irq
> * saa7134_i2c_register
> 
> So my point was that none of these 3 functions seemed to be dependent
> on saa7134_input_init1() having been called beforehand. Which is why I
> strongly question the fact that moving saa7134_input_init1() _after_
> these 3 other initialization steps can have any negative effect. I
> wouldn't have claimed that moving saa7134_input_init1() _earlier_ in
> the init sequence would be safe, because there's nothing obvious about
> that. But moving it forward where I had put it did not seem terrific.

I agree. In thesis, after board-specific init1 and init2, the device should
be in good health and all the needs for IR should already be available.
The only point that requires a double check is at the suspend function
(as someone may try to suspend the machine in the middle of the board setup).

> I really would like a few users of this driver to just give it a try
> and report, because it seems a much more elegant fix to the bug at
> hand, than the workaround you'd accept instead.

Seems fair to me.
 
>> That's why I'm saying that, if in the specific case of the board you're dealing with,
>> you're sure that an unknown GPIO state won't affect the code at saa7134_hwinit1() and
>> at saa7134_i2c_register(), then you can move the GPIO code for this board to init2.
>>
>> Moving things between init1 and init2 are very tricky and requires testing on all the
>> affected boards. So a change like what your patch proposed would require a test of all
>> the 107 boards that are on init1. I bet you'll break several of them with this change.
> 
> Under the assumption that saa7134_hwinit1() only touches GPIOs
> connected to IR receivers (and it certainly looks like this to me) I
> fail to see how these pins not being initialized could have any effect
> on non-IR code.

Now, i suspect that you're messing things again: are you referring to saa7134_hwinit1() or
to saa7134_input_init1()?

I suspect that you're talking about moving saa7134_input_init1(), since saa7134_hwinit1()
has the muted and spinlock inits. It also has the setups for video, vbi and mpeg. 
So, moving it require more care.

(btw, IMO all those *init1/*init2 names were a terrible choice)

> Now, please don't get me wrong. I don't have any of these devices. I've
> posted that patch because a user incidentally pointed me to a problem
> and I had an idea how it could be fixed. I prefer my initial proposal
> because it looks better in the long run. If you don't like it and
> prefer the second proposal even though I think it's more of a
> workaround than a proper fix, it's really up to you. You're maintaining
> the subsystem and I am not, so you're the one deciding.

Please, don't excuse yourself. You're right proposing a patch to help the user. Thanks for that.
>From my side, I just want to make sure that we won't add any regressions with other boards.

Experience shows that touching at those init sequences (especially at the board init1/init2)
cause lots of problem. For example, before the i2c redesign, there were several GPIO's inside
init2. Due to that, if the i2c module got loaded before init2, several boards would fail.
On those boards, people were required to load the modules on an specific order with some boards
(and sometimes unload/reload an i2c driver), to be sure that the i2c devices would get properly 
initialized. Due to that, several boards didn't work if the drivers were compiled builtin. 
Also, there are some cases where it were impossible to have all saa7134  devices working on a 
machine with multiple saa7134 devices.

During the time the i2c changes got merged, those GPIO sequences were moved to init1, but this
broke several devices, and the init sequences needed to be manually adjusted for those. I don't 
doubt that are there still a few broken. At least now, the driver has not an intermittent behavior.

-- 

Cheers,
Mauro
