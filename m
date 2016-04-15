Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:51020 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbcDOO6e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 10:58:34 -0400
Date: Fri, 15 Apr 2016 07:58:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	=?utf-8?Q?Agust=C3=AD?= Fontquerni <af@iseebcn.com>
Subject: Re: tvp5150 regression after commit 9f924169c035
Message-ID: <20160415145828.GT5973@atomide.com>
References: <20160212234623.GB3500@atomide.com>
 <56BE993B.3010804@osg.samsung.com>
 <20160412223254.GK1526@katana>
 <570ECAB0.4050107@osg.samsung.com>
 <20160414111257.GG1533@katana>
 <570F9DF1.3070700@osg.samsung.com>
 <20160414141945.GA1539@katana>
 <570FA8D6.5070308@osg.samsung.com>
 <20160414151244.GM5973@atomide.com>
 <57102EE3.3020707@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57102EE3.3020707@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Javier Martinez Canillas <javier@osg.samsung.com> [160414 17:00]:
> On 04/14/2016 11:12 AM, Tony Lindgren wrote:
> > Is this with omap3 and does tvp5150 have a reset GPIO pin?
> 
> Yes, it's a DM3730 (OMAP3) and yes the tvp5150 (actually it's a tvp5151) has
> a reset pin that has to be toggled, along with a power-down pin for the chip
> to be in an operative state before accessing the I2C registers. That is the
> power/reset sequence I mentioned before.
>  
> > If so, you could be hitting the GPIO errata where a glitch can happen
> > when restoring the GPIO state coming back from off mode in idle. This
> > happes for GPIO pins that are not in GPIO bank1 and have an external
> > pull down resistor on the line.
> >
> 
> The GPIO lines connected to these pins are:
> 
> GPIO126 (bank4 pin 30) -> tvp5150 power-down pin
> GPIO167 (bank6 pin 7)  -> tvp5150 reset pin
> 
> Neither are in GPIO bank1 so they could be affected by the errata you
> mention but there isn't external pull down (or up) resistors on these
> lines AFAICT by looking at the board schematics. I've added to the cc
> list to other people that are familiar with the board in case I missed
> something.
> 
> > The short term workaround is to mux the reset pin to use the internal
> > pulls by using PIN_INPUT_PULLUP | MUX_MODE7, or depending on the direction,
> > PIN_INPUT_PULLDOWN | MUX_MODE7.
> 
> I guess you meant MUX_MODE4 here since the pin has to be in GPIO mode?

No, the glitch affects the GPIO mode, so that's why direction + pull +
safe mode is needed.

> Also, I wonder how the issue could be related to the GPIO controller
> since is when enabling runtime PM for the I2C controller that things
> fail. IOW, disabling runtime PM for the I2C adapter shouldn't make
> things to work if the problem was caused by the mentioned GPIO errata.

If you block PM runtime for I2C, then it blocks deeper idle states
for the whole device. Note that you can disable off mode during idle
and suspend with:

# echo 0 > /sys/kernel/debug/pm_debug/enable_off_mode

> In any case, I've tried to use the internal pulls as you suggested but
> that didn't solve the issue.

OK. Just to be sure.. Did you use the safe mode mux option instead
of the GPIO mux option?

Note that in some cases the internal pull is not strong enough to
keep the reset line up if there's an external pull down resistor.

Regards,

Tony
