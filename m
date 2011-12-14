Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:59831 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1LNWLR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 17:11:17 -0500
Date: Thu, 15 Dec 2011 00:11:13 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: martin@neutronstar.dyndns.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Vasut <marek.vasut@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3] v4l: Add driver for Micron MT9M032 camera sensor
Message-ID: <20111214221113.GB3677@valkosipuli.localdomain>
References: <1323825633-10543-1-git-send-email-martin@neutronstar.dyndns.org>
 <201112140255.31937.marek.vasut@gmail.com>
 <1323846842.756509.13592@localhost>
 <201112141449.05926.laurent.pinchart@ideasonboard.com>
 <1323889126.283763.19222@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323889126.283763.19222@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Wed, Dec 14, 2011 at 07:58:45PM +0100, martin@neutronstar.dyndns.org wrote:
...
> > > > > +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> > > > > +{
> > > > > +	struct mt9m032_platform_data* pdata = sensor->pdata;
> > > > > +	u16 reg_pll1;
> > > > > +	unsigned int pre_div;
> > > > > +	int res, ret;
> > > > > +
> > > > > +	/* TODO: also support other pre-div values */
> > 
> > I might already have mentioned this, but wouldn't it be time to work a on real 
> > PLL setup code that compute the pre-divisor, multiplier and output divisor 
> > dynamically from the input and output clock frequencies ?
> 
> I'm not sure what the implications for quality and stability of such a
> generic setup would be. My gut feeling is most users go with known working
> hardcoded values.

You'd get a lot better control of the sensor as a bonus in doing so. Also,
you could program the sensor properly suitable for the host it is connected
to, achieving optimal maximum frame rates for it.

These values tend to be relatively board / bridge dependent. On one board
some frequencies might not be usable even if they do not exceed the maximum
for the bridge.

Please also see this:

<URL:http://www.mail-archive.com/linux-media@vger.kernel.org/msg39798.html>

> Also in the datasheet i have access to, this is totally underdocumented.

That's unfortunate. Laurent, is yours the same?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
