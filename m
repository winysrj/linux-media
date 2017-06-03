Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35600 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750876AbdFCIiv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Jun 2017 04:38:51 -0400
Date: Sat, 3 Jun 2017 11:38:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hyungwoo Yang <hyungwoo.yang@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, tfiga@chromium.org, cedric.hsu@intel.com
Subject: Re: [PATCH v8 1/1] [media] i2c: add support for OV13858 sensor
Message-ID: <20170603083806.GR1019@valkosipuli.retiisi.org.uk>
References: <1496427085-17721-1-git-send-email-hyungwoo.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496427085-17721-1-git-send-email-hyungwoo.yang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hyungwoo,

On Fri, Jun 02, 2017 at 11:11:25AM -0700, Hyungwoo Yang wrote:
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
> +	/*
> +	 * Device is already turned on by i2c-core with ACPI domain PM.
> +	 * Enable runtime PM and turn off the device.
> +	 */
> +	pm_runtime_get_noresume(&client->dev);
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);
> +	pm_runtime_put(&client->dev);

As you're implying in the above code, pm_runtime_set_active() and
pm_runtime_enable() alone aren't enough to power the device down after
probe. Let's go with this for now and address it later.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

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
> +
> +static int ov13858_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov13858 *ov13858 = to_ov13858(sd);
> +
> +	v4l2_async_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	ov13858_free_controls(ov13858);
> +
> +	/*
> +	 * Disable runtime PM but keep the device turned on.
> +	 * i2c-core with ACPI domain PM will turn off the device.
> +	 */
> +	pm_runtime_get_sync(&client->dev);
> +	pm_runtime_disable(&client->dev);
> +	pm_runtime_set_suspended(&client->dev);
> +	pm_runtime_put_noidle(&client->dev);
> +
> +	return 0;
> +}

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
