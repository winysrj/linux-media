Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44688 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457Ab2GFLVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 07:21:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Subject: Re: omap3isp: cropping bug in previewer?
Date: Fri, 06 Jul 2012 13:21:54 +0200
Message-ID: <1464064.pfLLVkyzGQ@avalon>
In-Reply-To: <B21EB8416BB7744FAB36AEE2627158CD0119103FEC72@REBITSERVER.rebit.local>
References: <B21EB8416BB7744FAB36AEE2627158CD0119103FEC72@REBITSERVER.rebit.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Friday 06 July 2012 11:55:40 Florian Neuhaus wrote:
> Hi Laurent,
> 
> Laurent Pinchart wrote on 2012-07-05:
> > There's really an issue, which was introduced in v3.5-rc1. Could you
> > please try the following patch instead of yours ?
> > 
> > diff --git a/drivers/media/video/omap3isp/isppreview.c
> > b/drivers/media/video/omap3isp/isppreview.c index 9c6dd44..614752a
> > 100644 --- a/drivers/media/video/omap3isp/isppreview.c +++
> > b/drivers/media/video/omap3isp/isppreview.c @@ -1116,7 +1116,7 @@ static
> > void preview_config_input_size(struct isp_prev_device *prev, u32 active)
> > 
> >  	unsigned int elv = prev->crop.top + prev->crop.height - 1;
> >  	u32 features;
> > 
> > -	if (format->code == V4L2_MBUS_FMT_Y10_1X10) {
> > +	if (format->code != V4L2_MBUS_FMT_Y10_1X10) {
> > 
> >  		sph -= 2;
> >  		eph += 2;
> >  		slv -= 2;
> 
> This patch resolves the issue for me. I get a good picture at both the
> previewer and the resizer output. Thanks for your help!

You're welcome. Can I include your

Tested-by: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>

in the patch ?

-- 
Regards,

Laurent Pinchart

