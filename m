Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51164 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2CDW4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Mar 2012 17:56:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3 09/10] v4l: Aptina-style sensor PLL support
Date: Sun, 04 Mar 2012 23:57:14 +0100
Message-ID: <6934260.584DCdsOTK@avalon>
In-Reply-To: <4F5383CA.4050202@iki.fi>
References: <1330788495-18762-1-git-send-email-laurent.pinchart@ideasonboard.com> <2059444.5Gn7cyLNBL@avalon> <4F5383CA.4050202@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 04 March 2012 17:01:30 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Sunday 04 March 2012 00:37:07 Sakari Ailus wrote:
> >> On Sat, Mar 03, 2012 at 04:28:14PM +0100, Laurent Pinchart wrote:
> >>> Add a generic helper function to compute PLL parameters for PLL found in
> >>> several Aptina sensors.
> > 
> > [snip]
> > 
> >>> diff --git a/drivers/media/video/aptina-pll.c
> >>> b/drivers/media/video/aptina-pll.c new file mode 100644
> >>> index 0000000..55e4a40
> >>> --- /dev/null
> >>> +++ b/drivers/media/video/aptina-pll.c
> > 
> > [snip]
> > 
> >>> +int aptina_pll_configure(struct device *dev, struct aptina_pll *pll,
> >>> +			 const struct aptina_pll_limits *limits)
> >> 
> >> I've done the same to the SMIA++ PLL: it can be used separately from the
> >> driver now; it'll be part of the next patchset.
> >> 
> >> Do you think it could make sense to swap pll and limits parameters?
> > 
> > Why ? :-)
> 
> Uh, I have it that way. ;-) Also both dev and limits contain perhaps
> less interesting or const information than pll, which contains both
> input and output parameters.

You're lucky, I'm in a good mood, I'll change that ;-)

-- 
Regards,

Laurent Pinchart

