Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45397 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbbHMU2T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 16:28:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Helen Fornazier <helen.fornazier@gmail.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 2/7] [media] vimc: sen: Integrate the tpg on the sensor
Date: Thu, 13 Aug 2015 23:29:16 +0300
Message-ID: <5538901.B5EtQysehc@avalon>
In-Reply-To: <e3c80eb0aebe828d2df72be9971ad720f439bb71.1438891530.git.helen.fornazier@gmail.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com> <e3c80eb0aebe828d2df72be9971ad720f439bb71.1438891530.git.helen.fornazier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Thank you for the patch.

On Thursday 06 August 2015 17:26:09 Helen Fornazier wrote:
> Initialize the test pattern generator on the sensor
> Generate a colored bar image instead of a grey one
> 
> Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
> ---
>  drivers/media/platform/vimc/Kconfig       |  1 +
>  drivers/media/platform/vimc/vimc-sensor.c | 44 ++++++++++++++++++++++++++--
>  2 files changed, 43 insertions(+), 2 deletions(-)

[snip]

> diff --git a/drivers/media/platform/vimc/vimc-sensor.c
> b/drivers/media/platform/vimc/vimc-sensor.c index d613792..a2879ad 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -16,15 +16,19 @@
>   */
> 
>  #include <linux/freezer.h>
> +#include <media/tpg.h>
>  #include <linux/vmalloc.h>
>  #include <linux/v4l2-mediabus.h>

media/tpg.h should have been inserted here.

>  #include <media/v4l2-subdev.h>
> 
>  #include "vimc-sensor.h"

[snip]

> +static void vimc_sen_tpg_s_format(struct vimc_sen_device *vsen)
> +{
> +	const struct vimc_pix_map *vpix;
> +
> +	vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
> +	/* This should never be NULL, as we won't allow any format other then
> +	 * the ones in the vimc_pix_map_list table */
> +	BUG_ON(!vpix);

BUG_ON() is quite harsh, it will stop the machine. If the condition can never 
happen then you can remove the check. If you're worried it might happen I'd 
use a WARN_ON() and return.

> +	tpg_s_bytesperline(&vsen->tpg, 0,
> +			   vsen->mbus_format.width * vpix->bpp);
> +	tpg_s_buf_height(&vsen->tpg, vsen->mbus_format.height);
> +	tpg_s_fourcc(&vsen->tpg, vpix->pixelformat);
> +	/* TODO: check why the tpg_s_field need this third argument if
> +	 * it is already receiving the field */
> +	tpg_s_field(&vsen->tpg, vsen->mbus_format.field,
> +		    vsen->mbus_format.field == V4L2_FIELD_ALTERNATE);
> +	tpg_s_colorspace(&vsen->tpg, vsen->mbus_format.colorspace);
> +	tpg_s_ycbcr_enc(&vsen->tpg, vsen->mbus_format.ycbcr_enc);
> +	tpg_s_quantization(&vsen->tpg, vsen->mbus_format.quantization);
> +	tpg_s_xfer_func(&vsen->tpg, vsen->mbus_format.xfer_func);
> +}

-- 
Regards,

Laurent Pinchart

