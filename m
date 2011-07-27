Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37252 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1G0Ryc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 13:54:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [PATCH] mt9p031: Aptina (Micron) MT9P031 5MP sensor driver
Date: Wed, 27 Jul 2011 19:54:32 +0200
Cc: linux-media@vger.kernel.org, javier.martin@vista-silicon.com,
	shotty317@gmail.com
References: <CACKLOr1veNZ_6E3V_m1Tf+mxxUAKiRKDbboW-fMbRGUrLns_XA@mail.gmail.com> <1311757981-6968-1-git-send-email-laurent.pinchart@ideasonboard.com> <4E304C2C.6070505@gmail.com>
In-Reply-To: <4E304C2C.6070505@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107271954.33149.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the review.

On Wednesday 27 July 2011 19:34:36 Sylwester Nawrocki wrote:
> On 07/27/2011 11:13 AM, Laurent Pinchart wrote:

[snip]

> > +static int mt9p031_probe(struct i2c_client *client,
> > +				const struct i2c_device_id *did)
> > +{
> > +	struct mt9p031_platform_data *pdata = client->dev.platform_data;
> > +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> > +	struct mt9p031 *mt9p031;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> > +		dev_warn(&adapter->dev,
> > +			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> > +		return -EIO;
> > +	}
> > +
> > +	mt9p031 = kzalloc(sizeof(*mt9p031), GFP_KERNEL);
> > +	if (mt9p031 == NULL)
> > +		return -ENOMEM;
> > +
> > +	mt9p031->pdata = pdata;
> > +	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
> > +	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
> > +
> > +	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 4);
> > +
> > +	v4l2_ctrl_new_std(&mt9p031->ctrls,&mt9p031_ctrl_ops,
> > +			  V4L2_CID_EXPOSURE, MT9P031_SHUTTER_WIDTH_MIN,
> > +			  MT9P031_SHUTTER_WIDTH_MAX, 1,
> > +			  MT9P031_SHUTTER_WIDTH_DEF);
> > +	v4l2_ctrl_new_std(&mt9p031->ctrls,&mt9p031_ctrl_ops,
> > +			  V4L2_CID_GAIN, MT9P031_GLOBAL_GAIN_MIN,
> > +			  MT9P031_GLOBAL_GAIN_MAX, 1, MT9P031_GLOBAL_GAIN_DEF);
> > +	v4l2_ctrl_new_std(&mt9p031->ctrls,&mt9p031_ctrl_ops,
> > +			  V4L2_CID_HFLIP, 0, 1, 1, 0);
> > +	v4l2_ctrl_new_std(&mt9p031->ctrls,&mt9p031_ctrl_ops,
> > +			  V4L2_CID_VFLIP, 0, 1, 1, 0);
> > +
> > +	for (i = 0; i<  ARRAY_SIZE(mt9p031_ctrls); ++i)
> > +		v4l2_ctrl_new_custom(&mt9p031->ctrls,&mt9p031_ctrls[i], NULL);
> > +
> > +	mt9p031->subdev.ctrl_handler =&mt9p031->ctrls;
> > +
> > +	if (mt9p031->ctrls.error)
> > +		printk(KERN_INFO "%s: control initialization error %d\n",
> > +		       __func__, mt9p031->ctrls.error);
> > +
> > +	mutex_init(&mt9p031->power_lock);
> > +	v4l2_i2c_subdev_init(&mt9p031->subdev, client,&mt9p031_subdev_ops);
> > +	mt9p031->subdev.internal_ops =&mt9p031_subdev_internal_ops;
> > +
> > +	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +	ret = media_entity_init(&mt9p031->subdev.entity, 1,&mt9p031->pad, 0);
> > +	if (ret<  0)
> > +		goto done;
> > +
> > +	mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +
> > +	mt9p031->crop.width = MT9P031_WINDOW_WIDTH_DEF;
> > +	mt9p031->crop.height = MT9P031_WINDOW_HEIGHT_DEF;
> > +	mt9p031->crop.left = MT9P031_COLUMN_START_DEF;
> > +	mt9p031->crop.top = MT9P031_ROW_START_DEF;
> > +
> > +	if (mt9p031->pdata->version == MT9P031_MONOCHROME_VERSION)
> > +		mt9p031->format.code = V4L2_MBUS_FMT_Y12_1X12;
> > +	else
> > +		mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
> > +
> > +	mt9p031->format.width = MT9P031_WINDOW_WIDTH_DEF;
> > +	mt9p031->format.height = MT9P031_WINDOW_HEIGHT_DEF;
> > +	mt9p031->format.field = V4L2_FIELD_NONE;
> > +	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
> > +
> > +	ret = mt9p031_pll_get_divs(mt9p031);
> > +
> > +done:
> > +	if (ret<  0)
> 
> It seems there is a v4l2_ctrl_handler_free() missing here...

Good catch. I'll fix that (and the next one as well), and add a 
media_entity_cleanup() here as well.

> > +		kfree(mt9p031);
> > +
> > +	return ret;
> > +}
> > +
> > +static int mt9p031_remove(struct i2c_client *client)
> > +{
> > +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> > +	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
> > +
> > +	v4l2_device_unregister_subdev(subdev);
> > +	media_entity_cleanup(&subdev->entity);
> 
> ... and here.
> 
> > +	kfree(mt9p031);
> > +
> > +	return 0;
> > +}

-- 
Regards,

Laurent Pinchart
