Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33695 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbcDNX7m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 19:59:42 -0400
Subject: Re: tvp5150 regression after commit 9f924169c035
To: Tony Lindgren <tony@atomide.com>
References: <20160212224018.GZ3500@atomide.com>
 <56BE65F0.8040600@osg.samsung.com> <20160212234623.GB3500@atomide.com>
 <56BE993B.3010804@osg.samsung.com> <20160412223254.GK1526@katana>
 <570ECAB0.4050107@osg.samsung.com> <20160414111257.GG1533@katana>
 <570F9DF1.3070700@osg.samsung.com> <20160414141945.GA1539@katana>
 <570FA8D6.5070308@osg.samsung.com> <20160414151244.GM5973@atomide.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	=?UTF-8?Q?Agust=c3=ad_Fontquerni?= <af@iseebcn.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <57102EE3.3020707@osg.samsung.com>
Date: Thu, 14 Apr 2016 19:59:31 -0400
MIME-Version: 1.0
In-Reply-To: <20160414151244.GM5973@atomide.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Tony,

On 04/14/2016 11:12 AM, Tony Lindgren wrote:
> Hi,
> 
> * Javier Martinez Canillas <javier@osg.samsung.com> [160414 07:28]:
>> Hello Wofram,
>>
>> On 04/14/2016 10:19 AM, Wolfram Sang wrote:
>>>
>>>> Yes, I also wonder why I'm the only one facing this issue... maybe no one
>>>> else is using the tvp5150 driver on an OMAP board with mainline?
>>>
>>> I wonder why it only affects tvp5150. I don't see the connection yet.
>>>
>>
>> Yes, me neither. All other I2C devices are working properly on this board.
>>
>> The only thing I can think, is that the tvp5150 needs a reset sequence in
>> order to be operative. It basically toggles two pins in the chip, this is
>> done in tvp5150_init() [0] and is needed before accessing I2C registers.
>>
>> Maybe runtime pm has an effect on this and the chip is not reset correctly?
> 
> Is this with omap3 and does tvp5150 have a reset GPIO pin?
>

Yes, it's a DM3730 (OMAP3) and yes the tvp5150 (actually it's a tvp5151) has
a reset pin that has to be toggled, along with a power-down pin for the chip
to be in an operative state before accessing the I2C registers. That is the
power/reset sequence I mentioned before.
 
> If so, you could be hitting the GPIO errata where a glitch can happen
> when restoring the GPIO state coming back from off mode in idle. This
> happes for GPIO pins that are not in GPIO bank1 and have an external
> pull down resistor on the line.
>

The GPIO lines connected to these pins are:

GPIO126 (bank4 pin 30) -> tvp5150 power-down pin
GPIO167 (bank6 pin 7)  -> tvp5150 reset pin

Neither are in GPIO bank1 so they could be affected by the errata you
mention but there isn't external pull down (or up) resistors on these
lines AFAICT by looking at the board schematics. I've added to the cc
list to other people that are familiar with the board in case I missed
something.

> The short term workaround is to mux the reset pin to use the internal
> pulls by using PIN_INPUT_PULLUP | MUX_MODE7, or depending on the direction,
> PIN_INPUT_PULLDOWN | MUX_MODE7.
>

I guess you meant MUX_MODE4 here since the pin has to be in GPIO mode?

Also, I wonder how the issue could be related to the GPIO controller
since is when enabling runtime PM for the I2C controller that things
fail. IOW, disabling runtime PM for the I2C adapter shouldn't make
things to work if the problem was caused by the mentioned GPIO errata.

In any case, I've tried to use the internal pulls as you suggested but
that didn't solve the issue.

> The long term workaround is tho have gpio-omap.c do this dynamically
> with pinctrl-single.c using gpio-ranges, but that's going to take a
> while.. You can search for erratum 1.158 for more info.
> 
> Regards,
> 
> Tony
> 
>> [0]: https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/media/i2c/tvp5150.c#n1311

I'm really out of ideas on this, I don't think that Wolfram change has
to be reverted since it seems I'm the only one facing this issue and
also the DTS for the board I'm using is not even in mainline yet.

I'm waiting for some discussions about the Media Controller input
connectors DT bindings to settle before posting the board DTS patches.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
