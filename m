Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41578 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaFKNL6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 09:11:58 -0400
Message-ID: <1402492315.4107.147.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 05/43] imx-drm: ipu-v3: Map IOMUXC registers
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 15:11:55 +0200
In-Reply-To: <1402178205-22697-6-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-6-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Map the IOMUXC registers, which will be needed by ipu-csi for mux
> control.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/staging/imx-drm/ipu-v3/ipu-common.c |    8 ++++++++
>  drivers/staging/imx-drm/ipu-v3/ipu-prv.h    |    4 ++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> index 2d95a7c..635dafe 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> @@ -1196,6 +1196,14 @@ static int ipu_probe(struct platform_device *pdev)
>  	if (!ipu->cm_reg || !ipu->idmac_reg || !ipu->cpmem_base)
>  		return -ENOMEM;
>  
> +	ipu->gp_reg = syscon_regmap_lookup_by_compatible(
> +		"fsl,imx6q-iomuxc-gpr");
> +	if (IS_ERR(ipu->gp_reg)) {
> +		ret = PTR_ERR(ipu->gp_reg);
> +		dev_err(&pdev->dev, "failed to map iomuxc regs with %d\n", ret);
> +		return ret;
> +	}
> +

This will break i.MX5. The IPU core driver shouldn't touch those
registers anyway.

regards
Philipp

