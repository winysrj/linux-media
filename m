Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51365 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752396AbeERKdW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 06:33:22 -0400
Message-ID: <1526639598.3948.3.camel@pengutronix.de>
Subject: Re: [PATCH v5 02/12] media: staging/imx7: add imx7 CSI subdev driver
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
        Ryan Harkin <ryan.harkin@linaro.org>, linux-clk@vger.kernel.org
Date: Fri, 18 May 2018 12:33:18 +0200
In-Reply-To: <20180518092806.3829-3-rui.silva@linaro.org>
References: <20180518092806.3829-1-rui.silva@linaro.org>
         <20180518092806.3829-3-rui.silva@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-05-18 at 10:27 +0100, Rui Miguel Silva wrote:
> This add the media entity subdevice and control driver for the i.MX7
> CMOS Sensor Interface.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
[...]
> +static int imx7_csi_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *node = dev->of_node;
> +	struct imx7_csi *csi;
> +	struct resource *res;
> +	int ret;
> +
> +	csi = devm_kzalloc(&pdev->dev, sizeof(*csi), GFP_KERNEL);
> +	if (!csi)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, &csi->sd);
> +	csi->dev = dev;
> +
> +	ret = imx7_csi_parse_dt(csi);
> +	if (ret < 0)
> +		return -ENODEV;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	csi->irq = platform_get_irq(pdev, 0);
> +	if (!res || csi->irq < 0) {
> +		dev_err(dev, "Missing platform resources data\n");
> +		return -ENODEV;
> +	}
> +
> +	csi->regbase = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(csi->regbase)) {
> +		dev_err(dev, "Failed platform resources map\n");
> +		return -ENODEV;
> +	}
> +
> +	spin_lock_init(&csi->irqlock);
> +	mutex_init(&csi->lock);
> +
> +	/* install interrupt handler */
> +	ret = devm_request_irq(dev, csi->irq, imx7_csi_irq_handler, 0, "csi",
> +			       (void *)csi);
> +	if (ret < 0) {
> +		dev_err(dev, "Request CSI IRQ failed.\n");
> +		return -ENODEV;
> +	}
> +
> +	/* add media device */
> +	csi->imxmd = imx_media_dev_init(dev, false);
> +	if (IS_ERR(csi->imxmd))
> +		return PTR_ERR(csi->imxmd);
> +
> +	ret = imx_media_of_add_csi(csi->imxmd, node);
> +	if (ret < 0)
> +		goto media_cleanup;
> +
> +	ret = imx_media_dev_notifier_register(csi->imxmd);
> +	if (ret < 0)
> +		goto media_cleanup;
> +
> +	v4l2_subdev_init(&csi->sd, &imx7_csi_subdev_ops);
> +	v4l2_set_subdevdata(&csi->sd, csi);
> +	csi->sd.internal_ops = &imx7_csi_internal_ops;
> +	csi->sd.entity.ops = &imx7_csi_entity_ops;
> +	csi->sd.entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
> +	csi->sd.dev = &pdev->dev;
> +	csi->sd.owner = THIS_MODULE;
> +	csi->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	csi->sd.grp_id = IMX_MEDIA_GRP_ID_CSI0;

See my comments on the first patch. Since grp_id specifies an IPU CSI0,
it would be better to use a different id here to make clear this is a
standalone CSI as opposed to an IPU CSI.

regards
Philipp
