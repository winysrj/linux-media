Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40477 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1JKJqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 05:46:30 -0400
Date: Tue, 11 Oct 2011 12:46:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Report the ISP revision through the media
 controller API
Message-ID: <20111011094624.GB10001@valkosipuli.localdomain>
References: <1318325944-11666-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318325944-11666-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2011 at 11:39:04AM +0200, Laurent Pinchart wrote:
> Set the media_device::hw_revision field to the ISP revision number.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/omap3isp/isp.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
> index 7b5ab42..192c448 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -1697,6 +1697,7 @@ static int isp_register_entities(struct isp_device *isp)
>  	isp->media_dev.dev = isp->dev;
>  	strlcpy(isp->media_dev.model, "TI OMAP3 ISP",
>  		sizeof(isp->media_dev.model));
> +	isp->media_dev.hw_revision = isp->revision;
>  	isp->media_dev.link_notify = isp_pipeline_link_notify;
>  	ret = media_device_register(&isp->media_dev);
>  	if (ret < 0) {
> -- 
> 1.7.3.4
> 

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
