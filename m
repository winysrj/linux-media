Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:46740 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1LSVpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 16:45:44 -0500
Date: Mon, 19 Dec 2011 23:43:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: martin@neutronstar.dyndns.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Vasut <marek.vasut@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3] v4l: Add driver for Micron MT9M032 camera sensor
Message-ID: <20111219214332.GM3677@valkosipuli.localdomain>
References: <1323825633-10543-1-git-send-email-martin@neutronstar.dyndns.org>
 <201112140255.31937.marek.vasut@gmail.com>
 <1323846842.756509.13592@localhost>
 <201112141449.05926.laurent.pinchart@ideasonboard.com>
 <1323889126.283763.19222@localhost>
 <20111214221113.GB3677@valkosipuli.localdomain>
 <1324115451.942577.4988@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324115451.942577.4988@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Sat, Dec 17, 2011 at 10:50:51AM +0100, martin@neutronstar.dyndns.org wrote:
> On Thu, Dec 15, 2011 at 12:11:13AM +0200, Sakari Ailus wrote:
> > Hi Martin,
> > 
> > On Wed, Dec 14, 2011 at 07:58:45PM +0100, martin@neutronstar.dyndns.org wrote:
> > ...
> > > > > > > +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> > > > > > > +{
> > > > > > > +	struct mt9m032_platform_data* pdata = sensor->pdata;
> > > > > > > +	u16 reg_pll1;
> > > > > > > +	unsigned int pre_div;
> > > > > > > +	int res, ret;
> > > > > > > +
> > > > > > > +	/* TODO: also support other pre-div values */
> > > > 
> > > > I might already have mentioned this, but wouldn't it be time to work a on real 
> > > > PLL setup code that compute the pre-divisor, multiplier and output divisor 
> > > > dynamically from the input and output clock frequencies ?
> > > 
> > > I'm not sure what the implications for quality and stability of such a
> > > generic setup would be. My gut feeling is most users go with known working
> > > hardcoded values.
> > 
> > You'd get a lot better control of the sensor as a bonus in doing so. Also,
> > you could program the sensor properly suitable for the host it is connected
> > to, achieving optimal maximum frame rates for it.
> > 
> > These values tend to be relatively board / bridge dependent. On one board
> > some frequencies might not be usable even if they do not exceed the maximum
> > for the bridge.
> 
> Yes, that's why i have exported almost all of the pll details i'm reasonanly sure
> that they are settable in the platform data. I think this gives maximum
> flexibility in the board configuration. Maybe something with less values to fiddle
> with in the normal case would be better. But not really by a large amount.

I originally thought it was part of the driver; that's how it is in most of
the drivers currently. But these values also depend on the use cases, how
you want to use the sensor essentially.

A concrete example is the OMAP 3 ISP. The CSI-2 receiver's speed is 200 Mp/s
while the rest of the ISP is only 100 Mp/s. Capturing a high-resolution
still photo is best done by reading the sensor's pixel array as fast as
possible --- 200 Mp/s.

Such images must be then processed through the ISP from memory to memory.

> static struct mt9m032_platform_data mt9m032_platform_data = {
> 	.ext_clock = 13500000,
> 	.pll_pre_div = 6,
> 	.pll_mul = 120,
> 	.pll_out_div = 5,
> 	.invert_pixclock = 1,
> };
> 
> I think what Laurent was talking about was moving to a setup where the
> board doesn't need to specify the exact details. i.e. have pll_pre_div,
> pll_mul and pll_out_div rolled into one. I'm not sure that's something
> that should be done.

Consider the above example. The answer is "yes". Still, the user should not
have to deal with the internal clock tree of the hardware, and I don't see a
reason why it would be needed.

> And this driver does feel like it had it's share of tracking in development
> interfaces.
> 
> > 
> > Please also see this:
> > 
> > <URL:http://www.mail-archive.com/linux-media@vger.kernel.org/msg39798.html>
> 
> Sounds sensible for the future. But let's not hold this driver until
> agreement is reached about the details?

I assume the spec is public for this sensor? Albeit specifying the PLL
configuration in the platform data is not ideal, it is still indefinitely
better than specifying it in the driver itself.

Calculating the PLL parameters based on higher level concept of link
frequency would still be preferred, I think. It can be done now, even if the
link frequency isn't currently selectable by the user.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
