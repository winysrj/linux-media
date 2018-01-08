Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54806 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754828AbeAHWXX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 17:23:23 -0500
Date: Tue, 9 Jan 2018 00:23:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v2 3/4] media: ov2685: add support for OV2685 sensor
Message-ID: <20180108222320.btdni6cwhwmg43wr@valkosipuli.retiisi.org.uk>
References: <1514534905-21393-1-git-send-email-zhengsq@rock-chips.com>
 <1514534905-21393-3-git-send-email-zhengsq@rock-chips.com>
 <20180103114324.za6bmg2rxuygawi4@valkosipuli.retiisi.org.uk>
 <3c2d17bf-60a9-3470-81ee-cf523b082a18@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c2d17bf-60a9-3470-81ee-cf523b082a18@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shunqian,

On Mon, Jan 08, 2018 at 09:37:20PM +0800, Shunqian Zheng wrote:
...
> > > +static int ov2685_probe(struct i2c_client *client,
> > > +			const struct i2c_device_id *id)
> > > +{
> > > +	struct device *dev = &client->dev;
> > > +	struct ov2685 *ov2685;
> > > +	int ret;
> > > +
> > > +	ov2685 = devm_kzalloc(dev, sizeof(*ov2685), GFP_KERNEL);
> > > +	if (!ov2685)
> > > +		return -ENOMEM;
> > > +
> > > +	ov2685->client = client;
> > > +	ov2685->cur_mode = &supported_modes[0];
> > > +
> > > +	ov2685->xvclk = devm_clk_get(dev, "xvclk");
> > > +	if (IS_ERR(ov2685->xvclk)) {
> > > +		dev_err(dev, "Failed to get xvclk\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	ov2685->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
> > > +	if (IS_ERR(ov2685->reset_gpio)) {
> > > +		dev_err(dev, "Failed to get reset-gpios\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	ov2685->avdd_regulator = devm_regulator_get(dev, "avdd");
> > > +	if (IS_ERR(ov2685->avdd_regulator)) {
> > > +		dev_err(dev, "Failed to get avdd-supply\n");
> > > +		return -EINVAL;
> > > +	}
> > > +	ov2685->dovdd_regulator = devm_regulator_get(dev, "dovdd");
> > > +	if (IS_ERR(ov2685->dovdd_regulator)) {
> > > +		dev_err(dev, "Failed to get dovdd-supply\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	mutex_init(&ov2685->mutex);
> > > +	v4l2_i2c_subdev_init(&ov2685->subdev, client, &ov2685_subdev_ops);
> > > +	ret = ov2685_initialize_controls(ov2685);
> > > +	if (ret)
> > > +		goto destroy_mutex;
> > > +
> > > +	ret = ov2685_check_sensor_id(ov2685, client);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > > +	ov2685->subdev.internal_ops = &ov2685_internal_ops;
> > > +#endif
> > > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > > +	ov2685->pad.flags = MEDIA_PAD_FL_SOURCE;
> > > +	ov2685->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > > +	ov2685->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> > > +	ret = media_entity_pads_init(&ov2685->subdev.entity, 1, &ov2685->pad);
> > > +	if (ret < 0)
> > > +		goto free_ctrl_handler;
> > > +#endif
> > > +
> > > +	ret = v4l2_async_register_subdev(&ov2685->subdev);
> > > +	if (ret) {
> > > +		dev_err(dev, "v4l2 async register subdev failed\n");
> > > +		goto clean_entity;
> > > +	}
> > > +
> > The device should be already powered up here... and then:
> > 
> > pm_runtime_set_active(dev);
> In my test case, sensor is not powered (power on and off in
> ov2685_check_sensor_id()).
> Checking the ov13858.c which is turned on by i2c-core with ACPI domain PM,
> this driver
> doesn't depend on ACPI.

Yes, on ACPI based systems the drivers aren't responsible for powering the
devices on and off themselves. They're powered on in probe() without usin
runtime PM.

With DT, the driver should power on the device before using runtime PM.
That way the device gets powered on even if runtime PM is disabled.

Please see the smiapp driver, it works with both DT and ACPI.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
