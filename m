Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42592 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752096AbeDSMW6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 08:22:58 -0400
Date: Thu, 19 Apr 2018 15:22:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/15] media: staging/imx7: add imx7 CSI subdev driver
Message-ID: <20180419122230.6wygwob2ajbkbv7o@mwanda>
References: <20180419101812.30688-1-rui.silva@linaro.org>
 <20180419101812.30688-3-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419101812.30688-3-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 19, 2018 at 11:17:59AM +0100, Rui Miguel Silva wrote:
> +static int imx7_csi_link_setup(struct media_entity *entity,
> +			       const struct media_pad *local,
> +			       const struct media_pad *remote, u32 flags)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> +	struct imx7_csi *csi = v4l2_get_subdevdata(sd);
> +	struct v4l2_subdev *remote_sd;
> +	int ret = 0;
> +
> +	dev_dbg(csi->dev, "link setup %s -> %s\n", remote->entity->name,
> +		local->entity->name);
> +
> +	mutex_lock(&csi->lock);
> +
> +	if (local->flags & MEDIA_PAD_FL_SINK) {
> +		if (!is_media_entity_v4l2_subdev(remote->entity)) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +
> +		remote_sd = media_entity_to_v4l2_subdev(remote->entity);
> +
> +		if (flags & MEDIA_LNK_FL_ENABLED) {
> +			if (csi->src_sd) {
> +				ret = -EBUSY;
> +				goto unlock;
> +			}
> +			csi->src_sd = remote_sd;
> +		} else {
> +			csi->src_sd = NULL;
> +		}
> +
> +		goto init;
> +	}
> +
> +	/* source pad */
> +	if (flags & MEDIA_LNK_FL_ENABLED) {
> +		if (csi->sink) {
> +			ret = -EBUSY;
> +			goto unlock;
> +		}
> +		csi->sink = remote->entity;
> +	} else {
> +		v4l2_ctrl_handler_free(&csi->ctrl_hdlr);
> +		v4l2_ctrl_handler_init(&csi->ctrl_hdlr, 0);
> +		csi->sink = NULL;
> +	}
> +
> +init:
> +	if (csi->sink || csi->src_sd)
> +		imx7_csi_init(csi);
> +	else
> +		imx7_csi_deinit(csi);
> +
> +unlock:
> +	mutex_unlock(&csi->lock);
> +
> +	return 0;

This should be "return ret;" because the failure paths go through here
as well.

> +}
> +
> +static int imx7_csi_pad_link_validate(struct v4l2_subdev *sd,
> +				      struct media_link *link,
> +				      struct v4l2_subdev_format *source_fmt,
> +				      struct v4l2_subdev_format *sink_fmt)
> +{
> +	struct imx7_csi *csi = v4l2_get_subdevdata(sd);
> +	struct v4l2_fwnode_endpoint upstream_ep;
> +	int ret;
> +
> +	ret = v4l2_subdev_link_validate_default(sd, link, source_fmt, sink_fmt);
> +	if (ret)
> +		return ret;
> +
> +	ret = imx7_csi_get_upstream_endpoint(csi, &upstream_ep, true);
> +	if (ret) {
> +		v4l2_err(&csi->sd, "failed to find upstream endpoint\n");
> +		return ret;
> +	}
> +
> +	mutex_lock(&csi->lock);
> +
> +	csi->upstream_ep = upstream_ep;
> +	csi->is_csi2 = (upstream_ep.bus_type == V4L2_MBUS_CSI2);
> +
> +	mutex_unlock(&csi->lock);
> +
> +	return ret;

return 0;

> +}
> +

[ snip ]

> +
> +static int imx7_csi_remove(struct platform_device *pdev)
> +{
> +	return 0;
> +}

There is no need for this empty (struct platform_driver)->remove()
function.  See platform_drv_remove() for how it's called.

This looks nice, though.

regards,
dan carpenter
