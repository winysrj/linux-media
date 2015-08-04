Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34174 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034AbbHDLV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 07:21:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] media: atmel-isi: parse the DT parameters for vsync/hsync/pixclock polarity
Date: Tue, 04 Aug 2015 14:22:13 +0300
Message-ID: <3317317.RTpCstaHHn@avalon>
In-Reply-To: <1438681069-16981-1-git-send-email-josh.wu@atmel.com>
References: <1438681069-16981-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thank you for the patch.

On Tuesday 04 August 2015 17:37:49 Josh Wu wrote:
> This patch will get the DT parameters of vsync/hsync/pixclock polarity, and
> pass to driver.
> 
> Also add a debug information for test purpose.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
> Changes in v3:
> - add embedded sync dt property support.
> 
> Changes in v2:
> - rewrite the debug message and add pix clock polarity setup thanks to
>   Laurent.
> - update the commit log.
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> b/drivers/media/platform/soc_camera/atmel-isi.c index fead841..4efc939
> 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -1061,6 +1061,11 @@ static int isi_camera_set_bus_param(struct
> soc_camera_device *icd) if (common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
>  		cfg1 |= ISI_CFG1_PIXCLK_POL_ACTIVE_FALLING;
> 
> +	dev_dbg(icd->parent, "vsync active %s, hsync active %s, sampling on pix
> clock %s edge\n", +		common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? "low" :
> "high",
> +		common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? "low" : "high",
> +		common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING ? "falling" : "rising");
> +
>  	if (isi->pdata.has_emb_sync)
>  		cfg1 |= ISI_CFG1_EMB_SYNC;
>  	if (isi->pdata.full_mode)
> @@ -1148,6 +1153,16 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
>  		return -EINVAL;
>  	}
> 
> +	if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> +		isi->pdata.hsync_act_low = true;
> +	if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
> +		isi->pdata.vsync_act_low = true;
> +	if (ep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
> +		isi->pdata.pclk_act_falling = true;
> +
> +	if (ep.bus_type == V4L2_MBUS_BT656)
> +		isi->pdata.has_emb_sync = true;
> +
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

