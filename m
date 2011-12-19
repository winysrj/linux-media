Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39623 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1LSKrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 05:47:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Subject: Re: [PATCH v3] v4l: Add driver for Micron MT9M032 camera sensor
Date: Mon, 19 Dec 2011 11:47:01 +0100
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Vasut <marek.vasut@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1323825633-10543-1-git-send-email-martin@neutronstar.dyndns.org> <20111214221113.GB3677@valkosipuli.localdomain> <1324115451.942577.4988@localhost>
In-Reply-To: <1324115451.942577.4988@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112191147.01592.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Saturday 17 December 2011 10:50:51 martin@neutronstar.dyndns.org wrote:
> On Thu, Dec 15, 2011 at 12:11:13AM +0200, Sakari Ailus wrote:
> > On Wed, Dec 14, 2011 at 07:58:45PM +0100, martin@neutronstar.dyndns.org
> > wrote: ...
> > 
> > > > > > > +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> > > > > > > +{
> > > > > > > +	struct mt9m032_platform_data* pdata = sensor->pdata;
> > > > > > > +	u16 reg_pll1;
> > > > > > > +	unsigned int pre_div;
> > > > > > > +	int res, ret;
> > > > > > > +
> > > > > > > +	/* TODO: also support other pre-div values */
> > > > 
> > > > I might already have mentioned this, but wouldn't it be time to work
> > > > a on real PLL setup code that compute the pre-divisor, multiplier
> > > > and output divisor dynamically from the input and output clock
> > > > frequencies ?
> > > 
> > > I'm not sure what the implications for quality and stability of such a
> > > generic setup would be. My gut feeling is most users go with known
> > > working hardcoded values.
> > 
> > You'd get a lot better control of the sensor as a bonus in doing so.
> > Also, you could program the sensor properly suitable for the host it is
> > connected to, achieving optimal maximum frame rates for it.
> > 
> > These values tend to be relatively board / bridge dependent. On one board
> > some frequencies might not be usable even if they do not exceed the
> > maximum for the bridge.
> 
> Yes, that's why i have exported almost all of the pll details i'm
> reasonanly sure that they are settable in the platform data. I think this
> gives maximum flexibility in the board configuration. Maybe something with
> less values to fiddle with in the normal case would be better. But not
> really by a large amount.
> 
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

That's what I was referring to, yes. The idea would be to pass the input 
(external) clock frequency to the driver, as well as the desired pixel clock. 
Both are properties of the board hardware, so they will be included in DT 
bindings. The PLL parameters are not properties of the board hardware, so they 
should be computed automatically.

> And this driver does feel like it had it's share of tracking in development
> interfaces.
> 
> > Please also see this:
> > 
> > <URL:http://www.mail-archive.com/linux-media@vger.kernel.org/msg39798.htm
> > l>
> 
> Sounds sensible for the future. But let's not hold this driver until
> agreement is reached about the details?

-- 
Regards,

Laurent Pinchart
