Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.hostpark.net ([212.243.197.31]:33274 "EHLO
	mail1.hostpark.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2GFJzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 05:55:45 -0400
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Date: Fri, 6 Jul 2012 11:55:40 +0200
Subject: RE: omap3isp: cropping bug in previewer?
Message-ID: <B21EB8416BB7744FAB36AEE2627158CD0119103FEC72@REBITSERVER.rebit.local>
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote on 2012-07-05:

> There's really an issue, which was introduced in v3.5-rc1. Could you please try
> the following patch instead of yours ?
> 
> diff --git a/drivers/media/video/omap3isp/isppreview.c
> b/drivers/media/video/omap3isp/isppreview.c index 9c6dd44..614752a
> 100644 --- a/drivers/media/video/omap3isp/isppreview.c +++
> b/drivers/media/video/omap3isp/isppreview.c @@ -1116,7 +1116,7 @@ static
> void preview_config_input_size(struct isp_prev_device *prev, u32 active)
>  	unsigned int elv = prev->crop.top + prev->crop.height - 1;
>  	u32 features;
> -	if (format->code == V4L2_MBUS_FMT_Y10_1X10) {
> +	if (format->code != V4L2_MBUS_FMT_Y10_1X10) {
>  		sph -= 2;
>  		eph += 2;
>  		slv -= 2;

This patch resolves the issue for me. I get a good picture at both the previewer and the resizer output. Thanks for your help!

--
Best regards,
Florian Neuhaus


