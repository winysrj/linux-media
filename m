Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B6AC10F00
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 679292173C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:18:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="CrN/lc/i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfCMASu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:18:50 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42440 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfCMASu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:18:50 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id EBB1E49;
        Wed, 13 Mar 2019 01:18:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552436328;
        bh=WLJ/A3KoCEhH6K1C84kH3ARY3GITuovSpl0s/gwcKrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CrN/lc/iN8/aZfrhDc7+Hq3GzRHkpfg7LpKNnwkWPRljpvvoJBPgUEMIVUsnh+ZpC
         SQME6A3IHABIKvq8yG97EEfGEB3EQ1FSSAQCvRVO94ELI6sdZoPWZEbLiCdiqMjMw3
         jZHeb9VF3qcgv1kUpjVURXuzbHxXMW4bCVpi+pPY=
Date:   Wed, 13 Mar 2019 02:18:41 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 2/2] rcar-csi2: Use standby mode instead of resetting
Message-ID: <20190313001841.GH891@pendragon.ideasonboard.com>
References: <20190312234930.23193-1-niklas.soderlund+renesas@ragnatech.se>
 <20190312234930.23193-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190312234930.23193-3-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Wed, Mar 13, 2019 at 12:49:30AM +0100, Niklas Söderlund wrote:
> Later versions of the datasheet updates the reset procedure to more
> closely resemble the standby mode. Update the driver to enter and exit
> the standby mode instead of resetting the hardware before and after
> streaming is started and stopped. This replaces the software reset
> (SRST.SRST) control.
> 
> While at it break out the full start and stop procedures from
> rcsi2_s_stream() into the existing helper functions.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/Kconfig     |  1 +
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 69 +++++++++++++--------
>  2 files changed, 43 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
> index e3eb8fee253658da..f26f47e3bcf44825 100644
> --- a/drivers/media/platform/rcar-vin/Kconfig
> +++ b/drivers/media/platform/rcar-vin/Kconfig
> @@ -3,6 +3,7 @@ config VIDEO_RCAR_CSI2
>  	tristate "R-Car MIPI CSI-2 Receiver"
>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
>  	depends on ARCH_RENESAS || COMPILE_TEST
> +	select RESET_CONTROLLER
>  	select V4L2_FWNODE
>  	help
>  	  Support for Renesas R-Car MIPI CSI-2 receiver.
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index f64528d2be3c95dd..10f1b4978ed7dcc6 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -14,6 +14,7 @@
>  #include <linux/of_graph.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/reset.h>
>  #include <linux/sys_soc.h>
>  
>  #include <media/v4l2-ctrls.h>
> @@ -350,6 +351,7 @@ struct rcar_csi2 {
>  	struct device *dev;
>  	void __iomem *base;
>  	const struct rcar_csi2_info *info;
> +	struct reset_control *rstc;
>  
>  	struct v4l2_subdev subdev;
>  	struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
> @@ -387,11 +389,19 @@ static void rcsi2_write(struct rcar_csi2 *priv, unsigned int reg, u32 data)
>  	iowrite32(data, priv->base + reg);
>  }
>  
> -static void rcsi2_reset(struct rcar_csi2 *priv)
> +static void rcsi2_enter_standby(struct rcar_csi2 *priv)
>  {
> -	rcsi2_write(priv, SRST_REG, SRST_SRST);
> +	rcsi2_write(priv, PHYCNT_REG, 0);
> +	rcsi2_write(priv, PHTC_REG, PHTC_TESTCLR);
> +	reset_control_assert(priv->rstc);
>  	usleep_range(100, 150);
> -	rcsi2_write(priv, SRST_REG, 0);
> +	pm_runtime_put(priv->dev);
> +}
> +
> +static void rcsi2_exit_standby(struct rcar_csi2 *priv)
> +{
> +	pm_runtime_get_sync(priv->dev);
> +	reset_control_deassert(priv->rstc);
>  }
>  
>  static int rcsi2_wait_phy_start(struct rcar_csi2 *priv)
> @@ -462,7 +472,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
>  	return mbps;
>  }
>  
> -static int rcsi2_start(struct rcar_csi2 *priv)
> +static int rcsi2_start_receiver(struct rcar_csi2 *priv)
>  {
>  	const struct rcar_csi2_format *format;
>  	u32 phycnt, vcdt = 0, vcdt2 = 0;
> @@ -506,7 +516,6 @@ static int rcsi2_start(struct rcar_csi2 *priv)
>  
>  	/* Init */
>  	rcsi2_write(priv, TREF_REG, TREF_TREF);
> -	rcsi2_reset(priv);
>  	rcsi2_write(priv, PHTC_REG, 0);
>  
>  	/* Configure */
> @@ -564,19 +573,36 @@ static int rcsi2_start(struct rcar_csi2 *priv)
>  	return 0;
>  }
>  
> +static int rcsi2_start(struct rcar_csi2 *priv)
> +{
> +	int ret;
> +
> +	rcsi2_exit_standby(priv);
> +
> +	ret = rcsi2_start_receiver(priv);
> +	if (ret) {
> +		rcsi2_enter_standby(priv);
> +		return ret;
> +	}
> +
> +	ret = v4l2_subdev_call(priv->remote, video, s_stream, 1);
> +	if (ret) {
> +		rcsi2_enter_standby(priv);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static void rcsi2_stop(struct rcar_csi2 *priv)
>  {
> -	rcsi2_write(priv, PHYCNT_REG, 0);
> -
> -	rcsi2_reset(priv);
> -
> -	rcsi2_write(priv, PHTC_REG, PHTC_TESTCLR);
> +	rcsi2_enter_standby(priv);
> +	v4l2_subdev_call(priv->remote, video, s_stream, 0);
>  }
>  
>  static int rcsi2_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct rcar_csi2 *priv = sd_to_csi2(sd);
> -	struct v4l2_subdev *nextsd;
>  	int ret = 0;
>  
>  	mutex_lock(&priv->lock);
> @@ -586,27 +612,12 @@ static int rcsi2_s_stream(struct v4l2_subdev *sd, int enable)
>  		goto out;
>  	}
>  
> -	nextsd = priv->remote;
> -
>  	if (enable && priv->stream_count == 0) {
> -		pm_runtime_get_sync(priv->dev);
> -
>  		ret = rcsi2_start(priv);
> -		if (ret) {
> -			pm_runtime_put(priv->dev);
> +		if (ret)
>  			goto out;
> -		}
> -
> -		ret = v4l2_subdev_call(nextsd, video, s_stream, 1);
> -		if (ret) {
> -			rcsi2_stop(priv);
> -			pm_runtime_put(priv->dev);
> -			goto out;
> -		}
>  	} else if (!enable && priv->stream_count == 1) {
>  		rcsi2_stop(priv);
> -		v4l2_subdev_call(nextsd, video, s_stream, 0);
> -		pm_runtime_put(priv->dev);
>  	}
>  
>  	priv->stream_count += enable ? 1 : -1;
> @@ -936,6 +947,10 @@ static int rcsi2_probe_resources(struct rcar_csi2 *priv,
>  	if (irq < 0)
>  		return irq;
>  
> +	priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
> +	if (IS_ERR(priv->rstc))
> +		return PTR_ERR(priv->rstc);
> +
>  	return 0;
>  }
>  

-- 
Regards,

Laurent Pinchart
