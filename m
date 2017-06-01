Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37798 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751467AbdFAIjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 04:39:32 -0400
Date: Thu, 1 Jun 2017 11:39:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hyungwoo Yang <hyungwoo.yang@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, tfiga@chromium.org, cedric.hsu@intel.com
Subject: Re: [PATCH v6 1/1] [media] i2c: add support for OV13858 sensor
Message-ID: <20170601083928.GK1019@valkosipuli.retiisi.org.uk>
References: <1496249050-32364-1-git-send-email-hyungwoo.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496249050-32364-1-git-send-email-hyungwoo.yang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hyungwoo,

On Wed, May 31, 2017 at 09:44:10AM -0700, Hyungwoo Yang wrote:
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
> +	pm_runtime_put(&client->dev);

This appears to have changed since v1. Shouldn't it be pm_runtime_enable()
and conversely pm_runtime_disable() in remove(), as it was in v1?

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
> +	pm_runtime_get(&client->dev);
> +
> +	return 0;
> +}

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
