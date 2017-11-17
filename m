Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:54463 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753528AbdKQLXB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 06:23:01 -0500
Subject: Re: [PATCH v7 14/25] rcar-vin: add function to manipulate Gen3 CHSEL
 value
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
 <20171111003835.4909-15-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9365f2dd-10f5-5947-e52e-95c077ba6891@xs4all.nl>
Date: Fri, 17 Nov 2017 12:22:58 +0100
MIME-Version: 1.0
In-Reply-To: <20171111003835.4909-15-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/17 01:38, Niklas Söderlund wrote:
> On Gen3 the CSI-2 routing is controlled by the VnCSI_IFMD register. One
> feature of this register is that it's only present in the VIN0 and VIN4
> instances. The register in VIN0 controls the routing for VIN0-3 and the
> register in VIN4 controls routing for VIN4-7.
> 
> To be able to control routing from a media device this function is need
> to control runtime PM for the subgroup master (VIN0 and VIN4). The
> subgroup master must be switched on before the register is manipulated,
> once the operation is complete it's safe to switch the master off and
> the new routing will still be in effect.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 25 +++++++++++++++++++++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index c4f8e81e88c99e28..463c656b9878be52 100644
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
> @@ -1228,3 +1229,27 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
>  
>  	return ret;
>  }
> +
> +/* -----------------------------------------------------------------------------
> + * Gen3 CHSEL manipulation
> + */
> +
> +void rvin_set_chsel(struct rvin_dev *vin, u8 chsel)
> +{
> +	u32 ifmd, vnmc;
> +
> +	pm_runtime_get_sync(vin->dev);
> +
> +	/* Make register writes take effect immediately */
> +	vnmc = rvin_read(vin, VNMC_REG) & ~VNMC_VUP;
> +	rvin_write(vin, vnmc, VNMC_REG);
> +
> +	ifmd = VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
> +		VNCSI_IFMD_CSI_CHSEL(chsel);
> +
> +	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
> +
> +	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
> +
> +	pm_runtime_put(vin->dev);
> +}
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 1f761518a6cc60b8..8a7c51724a90786c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -164,4 +164,6 @@ int rvin_reset_format(struct rvin_dev *vin);
>  
>  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
>  
> +void rvin_set_chsel(struct rvin_dev *vin, u8 chsel);
> +
>  #endif
> 
