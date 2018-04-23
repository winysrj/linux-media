Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41341 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755981AbeDWPs3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 11:48:29 -0400
Message-ID: <1524498503.3396.5.camel@pengutronix.de>
Subject: Re: [PATCH v2 06/15] media: staging/imx: add imx7 capture subsystem
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Date: Mon, 23 Apr 2018 17:48:23 +0200
In-Reply-To: <20180423134750.30403-7-rui.silva@linaro.org>
References: <20180423134750.30403-1-rui.silva@linaro.org>
         <20180423134750.30403-7-rui.silva@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-04-23 at 14:47 +0100, Rui Miguel Silva wrote:
> Add imx7 capture subsystem to imx-media core to allow the use some of the
> existing modules for i.MX5/6 with i.MX7 SoC.
> 
> Since i.MX7 does not have an IPU unset the ipu_present flag to differentiate
> some runtime behaviors.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  drivers/staging/media/imx/imx-media-dev.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index c0f277adeebe..be68235c4caa 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -486,6 +486,9 @@ static int imx_media_probe(struct platform_device *pdev)
>  
>  	imxmd->ipu_present = true;
>  
> +	if (of_device_is_compatible(node, "fsl,imx7-capture-subsystem"))
> +		imxmd->ipu_present = false;
> +

Is this something of_match_device should be used for?

>  	if (imxmd->ipu_present) {
>  		ret = imx_media_add_internal_subdevs(imxmd);
>  		if (ret) {
> @@ -543,6 +546,7 @@ static int imx_media_remove(struct platform_device *pdev)
>  
>  static const struct of_device_id imx_media_dt_ids[] = {
>  	{ .compatible = "fsl,imx-capture-subsystem" },
> +	{ .compatible = "fsl,imx7-capture-subsystem" },
>  	{ /* sentinel */ }
>  };
>  MODULE_DEVICE_TABLE(of, imx_media_dt_ids);

regards
Philipp
