Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37784 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750747AbdFBH6d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 03:58:33 -0400
Date: Fri, 2 Jun 2017 10:57:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rajmohan Mani <rajmohan.mani@intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        hverkuil@xs4all.nl, tfiga@chromium.org, s.nawrocki@samsung.com,
        tuukka.toivonen@intel.com
Subject: Re: [PATCH v7] dw9714: Initial driver for dw9714 VCM
Message-ID: <20170602075758.GO1019@valkosipuli.retiisi.org.uk>
References: <1496383611-26261-1-git-send-email-rajmohan.mani@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496383611-26261-1-git-send-email-rajmohan.mani@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 01, 2017 at 11:06:51PM -0700, Rajmohan Mani wrote:
> +static int dw9714_probe(struct i2c_client *client,
> +			const struct i2c_device_id *devid)
> +{
> +	struct dw9714_device *dw9714_dev;
> +	int rval;
> +
> +	dw9714_dev = devm_kzalloc(&client->dev, sizeof(*dw9714_dev),
> +				  GFP_KERNEL);
> +	if (dw9714_dev == NULL)
> +		return -ENOMEM;
> +
> +	dw9714_dev->client = client;
> +
> +	v4l2_i2c_subdev_init(&dw9714_dev->sd, client, &dw9714_ops);
> +	dw9714_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	dw9714_dev->sd.internal_ops = &dw9714_int_ops;
> +
> +	rval = dw9714_init_controls(dw9714_dev);
> +	if (rval)
> +		goto err_cleanup;
> +
> +	rval = media_entity_pads_init(&dw9714_dev->sd.entity, 0, NULL);
> +	if (rval < 0)
> +		goto err_cleanup;
> +
> +	dw9714_dev->sd.entity.function = MEDIA_ENT_F_LENS;
> +
> +	rval = v4l2_async_register_subdev(&dw9714_dev->sd);
> +	if (rval < 0)
> +		goto err_cleanup;
> +

You need pm_runtime_set_active() here.

> +	pm_runtime_enable(&client->dev);
> +
> +	return 0;
> +
> +err_cleanup:
> +	dw9714_subdev_cleanup(dw9714_dev);
> +	dev_err(&client->dev, "Probe failed: %d\n", rval);
> +	return rval;
> +}

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
