Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:56028 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab1LQJvD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 04:51:03 -0500
Date: Sat, 17 Dec 2011 10:50:51 +0100
From: martin@neutronstar.dyndns.org
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Vasut <marek.vasut@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3] v4l: Add driver for Micron MT9M032 camera sensor
References: <1323825633-10543-1-git-send-email-martin@neutronstar.dyndns.org>
 <201112140255.31937.marek.vasut@gmail.com>
 <1323846842.756509.13592@localhost>
 <201112141449.05926.laurent.pinchart@ideasonboard.com>
 <1323889126.283763.19222@localhost>
 <20111214221113.GB3677@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214221113.GB3677@valkosipuli.localdomain>
Message-Id: <1324115451.942577.4988@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 15, 2011 at 12:11:13AM +0200, Sakari Ailus wrote:
> Hi Martin,
> 
> On Wed, Dec 14, 2011 at 07:58:45PM +0100, martin@neutronstar.dyndns.org wrote:
> ...
> > > > > > +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> > > > > > +{
> > > > > > +	struct mt9m032_platform_data* pdata = sensor->pdata;
> > > > > > +	u16 reg_pll1;
> > > > > > +	unsigned int pre_div;
> > > > > > +	int res, ret;
> > > > > > +
> > > > > > +	/* TODO: also support other pre-div values */
> > > 
> > > I might already have mentioned this, but wouldn't it be time to work a on real 
> > > PLL setup code that compute the pre-divisor, multiplier and output divisor 
> > > dynamically from the input and output clock frequencies ?
> > 
> > I'm not sure what the implications for quality and stability of such a
> > generic setup would be. My gut feeling is most users go with known working
> > hardcoded values.
> 
> You'd get a lot better control of the sensor as a bonus in doing so. Also,
> you could program the sensor properly suitable for the host it is connected
> to, achieving optimal maximum frame rates for it.
> 
> These values tend to be relatively board / bridge dependent. On one board
> some frequencies might not be usable even if they do not exceed the maximum
> for the bridge.

Yes, that's why i have exported almost all of the pll details i'm reasonanly sure
that they are settable in the platform data. I think this gives maximum
flexibility in the board configuration. Maybe something with less values to fiddle
with in the normal case would be better. But not really by a large amount.

static struct mt9m032_platform_data mt9m032_platform_data = {
	.ext_clock = 13500000,
	.pll_pre_div = 6,
	.pll_mul = 120,
	.pll_out_div = 5,
	.invert_pixclock = 1,
};

I think what Laurent was talking about was moving to a setup where the board
doesn't need to specify the exact details. i.e. have pll_pre_div, pll_mul and
pll_out_div rolled into one. I'm not sure that's something that should be done.

And this driver does feel like it had it's share of tracking in development
interfaces.

> 
> Please also see this:
> 
> <URL:http://www.mail-archive.com/linux-media@vger.kernel.org/msg39798.html>

Sounds sensible for the future. But let's not hold this driver until agreement is
reached about the details?

 - Martin
