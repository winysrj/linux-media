Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:26292 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932961AbeFULZT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 07:25:19 -0400
Date: Thu, 21 Jun 2018 14:25:16 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        tfiga@google.com, jacopo@jmondi.org, rajmohan.mani@intel.com,
        bingbu.cao@linux.intel.com, tian.shu.qiu@intel.com,
        jian.xu.zheng@intel.com
Subject: Re: [PATCH v5 2/2] media: ak7375: Add ak7375 lens voice coil driver
Message-ID: <20180621112516.mwlph7u6et65gbh6@paasikivi.fi.intel.com>
References: <1529388107-14308-1-git-send-email-bingbu.cao@intel.com>
 <1529388107-14308-2-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1529388107-14308-2-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 19, 2018 at 02:01:47PM +0800, bingbu.cao@intel.com wrote:
> +static int ak7375_probe(struct i2c_client *client)
> +{
> +	struct ak7375_device *ak7375_dev;
> +	int val;
> +
> +	ak7375_dev = devm_kzalloc(&client->dev, sizeof(*ak7375_dev),
> +				  GFP_KERNEL);
> +	if (!ak7375_dev)
> +		return -ENOMEM;
> +
> +	v4l2_i2c_subdev_init(&ak7375_dev->sd, client, &ak7375_ops);
> +	ak7375_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	ak7375_dev->sd.internal_ops = &ak7375_int_ops;
> +	ak7375_dev->sd.entity.function = MEDIA_ENT_F_LENS;
> +
> +	val = ak7375_init_controls(ak7375_dev);
> +	if (val)
> +		goto err_cleanup;
> +
> +	val = media_entity_pads_init(&ak7375_dev->sd.entity, 0, NULL);
> +	if (val < 0)
> +		goto err_cleanup;
> +
> +	val = v4l2_async_register_subdev(&ak7375_dev->sd);
> +	if (val < 0)
> +		goto err_cleanup;
> +
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);
> +	pm_runtime_idle(&client->dev);
> +
> +	return 0;
> +
> +err_cleanup:
> +	v4l2_ctrl_handler_free(&ak7375_dev->ctrls_vcm);
> +	media_entity_cleanup(&ak7375_dev->sd.entity);
> +	dev_err(&client->dev, "Probe failed: %d\n", val);

This line is redundant, too: the kernel already prints the error value.

> +
> +	return val;
> +}

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
