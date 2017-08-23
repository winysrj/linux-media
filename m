Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36036 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754034AbdHWN6b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 09:58:31 -0400
Date: Wed, 23 Aug 2017 16:58:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: omap3isp: fix uninitialized variable use
Message-ID: <20170823135827.l7fgozsbhw5opyy3@valkosipuli.retiisi.org.uk>
References: <20170823133044.686146-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170823133044.686146-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Wed, Aug 23, 2017 at 03:30:19PM +0200, Arnd Bergmann wrote:
> A debug printk statement was copied incorrectly into the new
> csi1 parser code and causes a warning there:
> 
> drivers/media/platform/omap3isp/isp.c: In function 'isp_probe':
> include/linux/dynamic_debug.h:134:3: error: 'i' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> Since there is only one lane, the index is never set. This
> changes the debug print to always print a zero instead,
> keeping the original format of the message.
> 
> Fixes: 9211434bad30 ("media: omap3isp: Parse CSI1 configuration from the device tree")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/omap3isp/isp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 83aea08b832d..30c825bf80d9 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2092,7 +2092,7 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
>  			buscfg->bus.ccp2.lanecfg.data[0].pol =
>  				vep.bus.mipi_csi1.lane_polarity[1];
>  
> -			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> +			dev_dbg(dev, "data lane 0 polarity %u, pos %u\n",
>  				buscfg->bus.ccp2.lanecfg.data[0].pol,
>  				buscfg->bus.ccp2.lanecfg.data[0].pos);
>  

Thanks! I removed "0 "; CCP2 always has a single lane. The patch is now:

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 83aea08b832d..1a428fe9f070 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2092,7 +2092,7 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwnode,
 			buscfg->bus.ccp2.lanecfg.data[0].pol =
 				vep.bus.mipi_csi1.lane_polarity[1];
 
-			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
+			dev_dbg(dev, "data lane polarity %u, pos %u\n",
 				buscfg->bus.ccp2.lanecfg.data[0].pol,
 				buscfg->bus.ccp2.lanecfg.data[0].pos);
 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
