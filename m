Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48852 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751932AbdEDOpg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 10:45:36 -0400
Date: Thu, 4 May 2017 17:45:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v4 16/27] rcar-vin: add functions to manipulate Gen3
 CHSEL value
Message-ID: <20170504144503.GY7456@valkosipuli.retiisi.org.uk>
References: <20170427224203.14611-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427224203.14611-17-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170427224203.14611-17-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Fri, Apr 28, 2017 at 12:41:52AM +0200, Niklas Söderlund wrote:
> On Gen3 the CSI-2 routing is controlled by the VnCSI_IFMD register. One
> feature of this register is that it's only present in the VIN0 and VIN4
> instances. The register in VIN0 controls the routing for VIN0-3 and the
> register in VIN4 controls routing for VIN4-7.
> 
> To be able to control routing from a media device these functions need
> to control runtime PM for the subgroup master (VIN0 and VIN4). The
> subgroup master must be switched on before the register is manipulated,
> once the operation is complete it's safe to switch the master off and
> the new routing will still be in effect.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 43 ++++++++++++++++++++++++++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h |  3 +++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index 7fecb616b6c45a32..fef31aac0ed40979 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -16,6 +16,7 @@
>  
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>
> +#include <linux/pm_runtime.h>
>  
>  #include <media/videobuf2-dma-contig.h>
>  
> @@ -1240,3 +1241,45 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
>  
>  	return ret;
>  }
> +
> +/* -----------------------------------------------------------------------------
> + * Gen3 CHSEL manipulation
> + */
> +
> +int rvin_set_chsel(struct rvin_dev *vin, u8 chsel)
> +{
> +	u32 ifmd;
> +
> +	pm_runtime_get_sync(vin->dev);

Can this fail? Just wondering.

> +
> +	/*
> +	 * Undocumented feature: Writing to VNCSI_IFMD_REG will go
> +	 * through and on read back look correct but won't have
> +	 * any effect if VNMC_REG is not first set to 0.
> +	 */
> +	rvin_write(vin, 0, VNMC_REG);
> +
> +	ifmd = VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
> +		VNCSI_IFMD_CSI_CHSEL(chsel);
> +
> +	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
> +
> +	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
> +
> +	pm_runtime_put(vin->dev);
> +
> +	return 0;

If you always return zero, how about void instead?

> +}
> +
> +int rvin_get_chsel(struct rvin_dev *vin)
> +{
> +	int chsel;
> +
> +	pm_runtime_get_sync(vin->dev);

Same here.

> +
> +	chsel = rvin_read(vin, VNCSI_IFMD_REG) & VNCSI_IFMD_CSI_CHSEL_MASK;
> +
> +	pm_runtime_put(vin->dev);
> +
> +	return chsel;
> +}
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 09fc70e192699f35..b1cd0abba9ca9c94 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -163,4 +163,7 @@ void rvin_v4l2_remove(struct rvin_dev *vin);
>  
>  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
>  
> +int rvin_set_chsel(struct rvin_dev *vin, u8 chsel);
> +int rvin_get_chsel(struct rvin_dev *vin);
> +
>  #endif

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
