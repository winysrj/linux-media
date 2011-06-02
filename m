Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42428 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab1FBXNX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 19:13:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [PATCH] media: omap3isp: fix a pontential NULL deref
Date: Thu, 2 Jun 2011 18:49:19 +0200
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
References: <1306946386-31869-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1306946386-31869-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106021849.20046.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Ohad,

On Wednesday 01 June 2011 18:39:46 Ohad Ben-Cohen wrote:
> Fix a potential NULL pointer dereference by skipping registration of
> external entities in case none are provided.
> 
> This is useful at least when testing mere memory-to-memory scenarios.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

Applied, thanks.

> ---
>  drivers/media/video/omap3isp/isp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isp.c
> b/drivers/media/video/omap3isp/isp.c index 2a5fbe6..367ced3 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -1756,7 +1756,7 @@ static int isp_register_entities(struct isp_device
> *isp) goto done;
> 
>  	/* Register external entities */
> -	for (subdevs = pdata->subdevs; subdevs->subdevs; ++subdevs) {
> +	for (subdevs = pdata->subdevs; subdevs && subdevs->subdevs; ++subdevs) {
>  		struct v4l2_subdev *sensor;
>  		struct media_entity *input;
>  		unsigned int flags;

-- 
Regards,

Laurent Pinchart
