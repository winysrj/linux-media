Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37724 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750747AbdFBHye (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 03:54:34 -0400
Date: Fri, 2 Jun 2017 10:54:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hyungwoo Yang <hyungwoo.yang@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, tfiga@chromium.org, cedric.hsu@intel.com
Subject: Re: [PATCH v7 1/1] [media] i2c: add support for OV13858 sensor
Message-ID: <20170602075429.GN1019@valkosipuli.retiisi.org.uk>
References: <1496357116-23194-1-git-send-email-hyungwoo.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496357116-23194-1-git-send-email-hyungwoo.yang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hyungwoo,

On Thu, Jun 01, 2017 at 03:45:16PM -0700, Hyungwoo Yang wrote:
...
> +static int ov13858_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *devid)
> +{
> +	struct ov13858 *ov13858;
> +	int ret;
> +
> +	ov13858 = devm_kzalloc(&client->dev, sizeof(*ov13858), GFP_KERNEL);
> +	if (!ov13858)
> +		return -ENOMEM;
> +
> +	/* Initialize subdev */
> +	v4l2_i2c_subdev_init(&ov13858->sd, client, &ov13858_subdev_ops);
> +
> +	/*
> +	 * Enable runtime PM.
> +	 * The sensor is already powered on ACPI domain PM
> +	 */
> +	pm_runtime_get_noresume(&client->dev);
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);

As you already have in comments, the device is already powered on in an ACPI
based system. pm_runtime_get_noresume() prevents powering the device off
during probe after runtime PM is enabled.

It'd be better to also move the calls to pm_runtime_set_active() and
pm_runtime_enable() just before returning 0. This way you can get rid of
extra error handling you'd otherwise need to do: once you call
pm_runtime_get_noresume(), you need to call pm_runtime_put() or one of its
variants as well.

> +
> +	/* Check module identity */
> +	ret = ov13858_identify_module(ov13858);
> +	if (ret) {
> +		dev_err(&client->dev, "failed to find sensor: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Set default mode to max resolution */
> +	ov13858->cur_mode = &supported_modes[0];
> +
> +	ret = ov13858_init_controls(ov13858);
> +	if (ret)
> +		return ret;
> +
> +	/* Initialize subdev */
> +	ov13858->sd.internal_ops = &ov13858_internal_ops;
> +	ov13858->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	ov13858->sd.entity.ops = &ov13858_subdev_entity_ops;
> +	ov13858->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +
> +	/* Initialize source pad */
> +	ov13858->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_pads_init(&ov13858->sd.entity, 1, &ov13858->pad);
> +	if (ret) {
> +		dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
> +		goto error_handler_free;
> +	}
> +
> +	ret = v4l2_async_register_subdev(&ov13858->sd);
> +	if (ret < 0)
> +		goto error_media_entity;
> +
> +	/* Turn off */
> +	pm_runtime_put(&client->dev);
> +
> +	return 0;
> +
> +error_media_entity:
> +	media_entity_cleanup(&ov13858->sd.entity);
> +
> +error_handler_free:
> +	ov13858_free_controls(ov13858);
> +	dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
> +
> +	return ret;
> +}

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
