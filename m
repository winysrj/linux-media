Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33585 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbcEQSfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 14:35:41 -0400
Date: Tue, 17 May 2016 20:33:40 +0200
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	sakari.ailus@iki.fi
Subject: Re: [PATCH] support for AD5820 camera auto-focus coil
Message-ID: <20160517183340.GA10358@gmail.com>
References: <20160517181927.GA28741@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160517181927.GA28741@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, May 17, 2016 at 08:19:27PM +0200, Pavel Machek wrote:
> +static int ad5820_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct ad5820_device *coil =
> +		container_of(ctrl->handler, struct ad5820_device, ctrls);
> +	u32 code;
> +	int r = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_FOCUS_ABSOLUTE:
> +		coil->focus_absolute = ctrl->val;
> +		return ad5820_update_hw(coil);
> +
> +	case V4L2_CID_FOCUS_AD5820_RAMP_TIME:
> +		code = RAMP_US_TO_CODE(ctrl->val);
> +		ctrl->val = CODE_TO_RAMP_US(code);
> +		coil->focus_ramp_time = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_FOCUS_AD5820_RAMP_MODE:
> +		coil->focus_ramp_mode = ctrl->val;
> +		break;
> +	}
> +
> +	return r;

Just return 0 instead, r is not used.

> +static int ad5820_registered(struct v4l2_subdev *subdev)
> +{
> +	static const int CHECK_VALUE = 0x3FF0;

CHECK_VALUE is not used?

> +static int ad5820_probe(struct i2c_client *client,
> +			const struct i2c_device_id *devid)
> +{
> +	struct ad5820_device *coil;
> +	int ret = 0;
> +
> +	coil = kzalloc(sizeof(*coil), GFP_KERNEL);
> +	if (coil == NULL)
> +		return -ENOMEM;
> +
> +	mutex_init(&coil->power_lock);
> +
> +	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);
> +	coil->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	coil->subdev.internal_ops = &ad5820_internal_ops;
> +	strcpy(coil->subdev.name, "ad5820 focus");
> +
> +	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);
> +	if (ret < 0) {
> +		kfree(coil);
> +		return ret;
> +	}
> +
> +	ret = v4l2_async_register_subdev(&coil->subdev);
> +	if (ret < 0)

Do we need to call media_entity_cleanup() here?

> +static int __init ad5820_init(void)
> +{
> +	int rval;
> +
> +	rval = i2c_add_driver(&ad5820_i2c_driver);
> +	if (rval)
> +		printk(KERN_INFO "%s: failed registering " AD5820_NAME "\n",
> +		       __func__);
> +
> +	return rval;
> +}
> +
> +static void __exit ad5820_exit(void)
> +{
> +	i2c_del_driver(&ad5820_i2c_driver);
> +}
> +
> +
> +module_init(ad5820_init);
> +module_exit(ad5820_exit);


Use module_i2c_driver() instead.


Cheers
Marcus Folkesson

