Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:50945 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbcDNPMw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 11:12:52 -0400
Date: Thu, 14 Apr 2016 08:12:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: tvp5150 regression after commit 9f924169c035
Message-ID: <20160414151244.GM5973@atomide.com>
References: <20160212224018.GZ3500@atomide.com>
 <56BE65F0.8040600@osg.samsung.com>
 <20160212234623.GB3500@atomide.com>
 <56BE993B.3010804@osg.samsung.com>
 <20160412223254.GK1526@katana>
 <570ECAB0.4050107@osg.samsung.com>
 <20160414111257.GG1533@katana>
 <570F9DF1.3070700@osg.samsung.com>
 <20160414141945.GA1539@katana>
 <570FA8D6.5070308@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <570FA8D6.5070308@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

* Javier Martinez Canillas <javier@osg.samsung.com> [160414 07:28]:
> Hello Wofram,
> 
> On 04/14/2016 10:19 AM, Wolfram Sang wrote:
> > 
> >> Yes, I also wonder why I'm the only one facing this issue... maybe no one
> >> else is using the tvp5150 driver on an OMAP board with mainline?
> > 
> > I wonder why it only affects tvp5150. I don't see the connection yet.
> > 
> 
> Yes, me neither. All other I2C devices are working properly on this board.
> 
> The only thing I can think, is that the tvp5150 needs a reset sequence in
> order to be operative. It basically toggles two pins in the chip, this is
> done in tvp5150_init() [0] and is needed before accessing I2C registers.
> 
> Maybe runtime pm has an effect on this and the chip is not reset correctly?

Is this with omap3 and does tvp5150 have a reset GPIO pin?

If so, you could be hitting the GPIO errata where a glitch can happen
when restoring the GPIO state coming back from off mode in idle. This
happes for GPIO pins that are not in GPIO bank1 and have an external
pull down resistor on the line.

The short term workaround is to mux the reset pin to use the internal
pulls by using PIN_INPUT_PULLUP | MUX_MODE7, or depending on the direction,
PIN_INPUT_PULLDOWN | MUX_MODE7.

The long term workaround is tho have gpio-omap.c do this dynamically
with pinctrl-single.c using gpio-ranges, but that's going to take a
while.. You can search for erratum 1.158 for more info.

Regards,

Tony

> [0]: https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/media/i2c/tvp5150.c#n1311
