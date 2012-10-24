Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60622 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2JXXcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 19:32:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Prashanth Subramanya <sprashanth@aptina.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	g.liakhovetski@gmx.de, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@maxwell.research.nokia.com,
	scott.jiang.linux@gmail.com, DRittersdorf@xrite.com
Subject: Re: [PATCH 2/2] drivers: media: video: Add support for Aptina ar0130 sensor
Date: Thu, 25 Oct 2012 01:33:02 +0200
Message-ID: <4198456.Ul2KJFuirD@avalon>
In-Reply-To: <20121024214818.GE23933@valkosipuli.retiisi.org.uk>
References: <1348842049-32195-1-git-send-email-sprashanth@aptina.com> <20121024214818.GE23933@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 25 October 2012 00:48:18 Sakari Ailus wrote:
> On Fri, Sep 28, 2012 at 07:50:49PM +0530, Prashanth Subramanya wrote:
> > This driver adds basic support for Aptina ar0130 1.2M sensor.
> > 
> > Changes for v2:
> > 1: Include new test pattern control as pointed by Hans and Lad.
> > 2: Remove soc_camera.h as suggested by Guennadi.
> > 3: Change auto exposure control as pointed by Dan Rittersdorf.
> > 4: Change incorrect return value as pointed by Nicolas.
> > 5: Change crop and binning settings.
> > 
> > Signed-off-by: Prashanth Subramanya <sprashanth@aptina.com>
> > ---

[snip]

> > +/**
> > + * PLL Dividers
> > + *
> > + * Calculated according to the following formula:
> > + *
> > + *    target_freq = (ext_freq x M) / (N x P1 x P2)
> > + *    VCO_freq    = (ext_freq x M) / N
> > + *
> > + * And subject to the following limitations:
> > + *
> > + *    Limitations of PLL parameters
> > + *    -----------------------------
> > + *    32     ≤ M        ≤ 384
> > + *    1      ≤ N        ≤ 64
> > + *    1      ≤ P1       ≤ 16
> > + *    4      ≤ P2       ≤ 16
> > + *    384MHz ≤ VCO_freq ≤ 768MHz
> > + *
> > + * TODO: Use Aptina PLL Helper module to calculate dividers
> > + */
> > +
> > +static const struct ar0130_pll_divs ar0130_divs[] = {
> > +	/* ext_freq	target_freq	M	N	p1	p2 */
> > +	{24000000,	48000000,	32,	2,	2,	4},
> > +	{24000000,	66000000,	44,	2,	2,	4},
> > +	{48000000,	48000000,	40,	5,	2,	4}
> > +};
> 
> Do you think you could use the smiapp-pll PLL calculator, as your pll looks
> similar to that? Here you're making a lot of assumptions you wouldn't have
> to make.

The patches that we have worked on together in the past few days are for this 
driver. So, yes, it should use smiapp-pll :-) I've sent the smiapp-pll patches 
to Prashanth already.

-- 
Regards,

Laurent Pinchart

