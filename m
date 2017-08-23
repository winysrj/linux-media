Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56301 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754054AbdHWNzX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 09:55:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: omap3isp: fix uninitialized variable use
Date: Wed, 23 Aug 2017 16:55:53 +0300
Message-ID: <1715918.7tP7qczlmH@avalon>
In-Reply-To: <20170823133044.686146-1-arnd@arndb.de>
References: <20170823133044.686146-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thank you for the patch.

On Wednesday, 23 August 2017 16:30:19 EEST Arnd Bergmann wrote:
> A debug printk statement was copied incorrectly into the new
> csi1 parser code and causes a warning there:
> 
> drivers/media/platform/omap3isp/isp.c: In function 'isp_probe':
> include/linux/dynamic_debug.h:134:3: error: 'i' may be used uninitialized in
> this function [-Werror=maybe-uninitialized]
> 
> Since there is only one lane, the index is never set. This
> changes the debug print to always print a zero instead,
> keeping the original format of the message.
> 
> Fixes: 9211434bad30 ("media: omap3isp: Parse CSI1 configuration from the
> device tree")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/isp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 83aea08b832d..30c825bf80d9
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2092,7 +2092,7 @@ static int isp_fwnode_parse(struct device *dev, struct
> fwnode_handle *fwnode, buscfg->bus.ccp2.lanecfg.data[0].pol =
>  				vep.bus.mipi_csi1.lane_polarity[1];
> 
> -			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> +			dev_dbg(dev, "data lane 0 polarity %u, pos %u\n",
>  				buscfg->bus.ccp2.lanecfg.data[0].pol,
>  				buscfg->bus.ccp2.lanecfg.data[0].pos);


-- 
Regards,

Laurent Pinchart
