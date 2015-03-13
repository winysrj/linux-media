Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54309 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753058AbbCMAEW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 20:04:22 -0400
Date: Fri, 13 Mar 2015 02:04:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5] media: i2c: add support for omnivision's ov2659 sensor
Message-ID: <20150313000415.GR11954@valkosipuli.retiisi.org.uk>
References: <1426202556-29156-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1426202556-29156-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Thu, Mar 12, 2015 at 11:22:36PM +0000, Lad Prabhakar wrote:
...
> +static int ov2659_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	const struct ov2659_platform_data *pdata = ov2659_get_pdata(client);
> +	struct v4l2_subdev *sd;
> +	struct ov2659 *ov2659;
> +	struct clk *clk;
> +	int ret;
> +
> +	if (!pdata) {
> +		dev_err(&client->dev, "platform data not specified\n");
> +		return -EINVAL;
> +	}
> +
> +	ov2659 = devm_kzalloc(&client->dev, sizeof(*ov2659), GFP_KERNEL);
> +	if (!ov2659)
> +		return -ENOMEM;
> +
> +	ov2659->pdata = pdata;
> +	ov2659->client = client;
> +
> +	clk = devm_clk_get(&client->dev, "xvclk");
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	ov2659->xvclk_frequency = clk_get_rate(clk);
> +	if (ov2659->xvclk_frequency < 6000000 ||
> +	    ov2659->xvclk_frequency > 27000000)
> +		return -EINVAL;
> +
> +	v4l2_ctrl_handler_init(&ov2659->ctrls, 2);
> +	v4l2_ctrl_new_std(&ov2659->ctrls, &ov2659_ctrl_ops,
> +			  V4L2_CID_PIXEL_RATE, ov2659->xvclk_frequency,
> +			  ov2659->xvclk_frequency, 1, ov2659->xvclk_frequency);

ov2659->xvclk_frequency is the frequency of the external clock, not the
pixel rate. If I understand correctly, you should use the value of the
link-frequency property instead (as long as it's one pixel per clock).

With this fixed,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +	v4l2_ctrl_new_std_menu_items(&ov2659->ctrls, &ov2659_ctrl_ops,
> +				     V4L2_CID_TEST_PATTERN,
> +				     ARRAY_SIZE(ov2659_test_pattern_menu) - 1,
> +				     0, 0, ov2659_test_pattern_menu);
> +	ov2659->sd.ctrl_handler = &ov2659->ctrls;
> +
> +	if (ov2659->ctrls.error) {
> +		dev_err(&client->dev, "%s: control initialization error %d\n",
> +			__func__, ov2659->ctrls.error);
> +		return  ov2659->ctrls.error;
> +	}
> +
> +	sd = &ov2659->sd;
> +	client->flags |= I2C_CLIENT_SCCB;
> +	v4l2_i2c_subdev_init(sd, client, &ov2659_subdev_ops);
> +
> +	sd->internal_ops = &ov2659_subdev_internal_ops;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
> +		     V4L2_SUBDEV_FL_HAS_EVENTS;
> +
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	ov2659->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +	ret = media_entity_init(&sd->entity, 1, &ov2659->pad, 0);
> +	if (ret < 0) {
> +		v4l2_ctrl_handler_free(&ov2659->ctrls);
> +		return ret;
> +	}
> +#endif
> +
> +	mutex_init(&ov2659->lock);
> +
> +	ov2659_get_default_format(&ov2659->format);
> +	ov2659->frame_size = &ov2659_framesizes[2];
> +	ov2659->format_ctrl_regs = ov2659_formats[0].format_ctrl_regs;
> +
> +	ret = ov2659_detect(sd);
> +	if (ret < 0)
> +		goto error;
> +
> +	/* Calculate the PLL register value needed */
> +	ov2659_pll_calc_params(ov2659);
> +
> +	ret = v4l2_async_register_subdev(&ov2659->sd);
> +	if (ret)
> +		goto error;
> +
> +	dev_info(&client->dev, "%s sensor driver registered !!\n", sd->name);
> +
> +	return 0;
> +
> +error:
> +	v4l2_ctrl_handler_free(&ov2659->ctrls);
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	media_entity_cleanup(&sd->entity);
> +#endif
> +	mutex_destroy(&ov2659->lock);
> +	return ret;
> +}

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
