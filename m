Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:37384 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751105AbdFAW5x (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Jun 2017 18:57:53 -0400
From: "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Hsu, Cedric" <cedric.hsu@intel.com>
Subject: RE: [PATCH v6 1/1] [media] i2c: add support for OV13858 sensor
Date: Thu, 1 Jun 2017 22:57:51 +0000
Message-ID: <7A4F467111FEF64486F40DFE7DF3500A03EB5EDF@ORSMSX111.amr.corp.intel.com>
References: <1496249050-32364-1-git-send-email-hyungwoo.yang@intel.com>
 <20170601083928.GK1019@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170601083928.GK1019@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Sakari,

I'm so sorry there was huge mistake in testing & submission in v6.
I've submitted v7.

Thanks,
Hyungwoo

-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@iki.fi] 
Sent: Thursday, June 1, 2017 1:39 AM
To: Yang, Hyungwoo <hyungwoo.yang@intel.com>
Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>; tfiga@chromium.org; Hsu, Cedric <cedric.hsu@intel.com>
Subject: Re: [PATCH v6 1/1] [media] i2c: add support for OV13858 sensor

Hi Hyungwoo,

On Wed, May 31, 2017 at 09:44:10AM -0700, Hyungwoo Yang wrote:
> +static int ov13858_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *devid) {
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

This appears to have changed since v1. Shouldn't it be pm_runtime_enable() and conversely pm_runtime_disable() in remove(), as it was in v1?

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
> +static int ov13858_remove(struct i2c_client *client) {
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
