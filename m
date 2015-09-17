Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56812 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbbIQGMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2015 02:12:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] omap3isp: Fix module autoloading
Date: Thu, 17 Sep 2015 09:12:18 +0300
Message-ID: <1861148.Fpo7v6OHii@avalon>
In-Reply-To: <1442446298-28179-1-git-send-email-javier@osg.samsung.com>
References: <1442446298-28179-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 17 September 2015 01:31:38 Javier Martinez Canillas wrote:
> Platform drivers needs to export the OF id table and this be built
> into the module or udev will not have the necessary information to
> autoload the driver module when the device is registered via OF.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
>  drivers/media/platform/omap3isp/isp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 56e683b19a73..2c2840650fb2
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2509,6 +2509,7 @@ static const struct of_device_id omap3isp_of_table[] =
> { { .compatible = "ti,omap3-isp" },
>  	{ },
>  };
> +MODULE_DEVICE_TABLE(of, omap3isp_of_table);
> 
>  static struct platform_driver omap3isp_driver = {
>  	.probe = isp_probe,

-- 
Regards,

Laurent Pinchart

