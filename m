Return-path: <linux-media-owner@vger.kernel.org>
Received: from hm1479-1.locaweb.com.br ([201.76.49.71]:6456 "EHLO
	hm1479-1.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967494Ab3DRPnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 11:43:32 -0400
Received: from mcbain0006.email.locaweb.com.br (189.126.112.72) by hm1479-21.locaweb.com.br (PowerMTA(TM) v3.5r15) id he0aa80nvdcu for <linux-media@vger.kernel.org>; Thu, 18 Apr 2013 12:11:54 -0300 (envelope-from <marcio@netopen.com.br>)
Received: from bart0017.correio.biz (bart0017.correio.biz [200.234.210.19])
	by mcbain0006.email.locaweb.com.br (Postfix) with ESMTP id 48C7634006A
	for <linux-media@vger.kernel.org>; Thu, 18 Apr 2013 12:11:54 -0300 (BRT)
Received: from [192.168.1.3] (unknown [189.48.41.78])
	(Authenticated sender: marcio@netopen.com.br)
	by bart0017.correio.biz (Postfix) with ESMTPA id 39C43D8374
	for <linux-media@vger.kernel.org>; Thu, 18 Apr 2013 12:11:51 -0300 (BRT)
Date: Thu, 18 Apr 2013 12:11:48 -0200
Subject: AT91SAM9M10: Problem porting driver for MT9P031 sensor
From: Marcio Campos de Lima <marcio@netopen.com.br>
To: <linux-media@vger.kernel.org>
Message-ID: <CD959152.AF27%marcio@netopen.com.br>
In-Reply-To: <CD957E83.AF12%marcio@netopen.com.br>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Hi
>
>I am porting the MT9P031 sensor device driver for a custom designed board
>based at the AT91SAM9M45-EK development board and Linux 3.6.9.
>The driver detects the sensor but does not create /dev/video1.
>
>Can anybody help me?
>Thanks
>Marcio

This is the probe code fo the driver if this can help:

/* 
---------------------------------------------------------------------------
--
 * Driver initialization and probing
 */

static int mt9p031_probe(struct i2c_client *client,
			 const struct i2c_device_id *did)
{
	struct mt9p031_platform_data *pdata = client->dev.platform_data;
	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
	struct mt9p031 *mt9p031;
	unsigned int i;
	int ret;

	if (pdata == NULL) {
		dev_err(&client->dev, "No platform data\n");
		return -EINVAL;
	}

	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
		dev_warn(&client->dev,
			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
		return -EIO;
	}

	mt9p031 = kzalloc(sizeof(*mt9p031), GFP_KERNEL);
	if (mt9p031 == NULL)
		return -ENOMEM;

	mt9p031->pdata = pdata;
	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;

	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 4);

	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
			  V4L2_CID_EXPOSURE, MT9P031_SHUTTER_WIDTH_MIN,
			  MT9P031_SHUTTER_WIDTH_MAX, 1,
			  MT9P031_SHUTTER_WIDTH_DEF);
	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
			  V4L2_CID_GAIN, MT9P031_GLOBAL_GAIN_MIN,
			  MT9P031_GLOBAL_GAIN_MAX, 1, MT9P031_GLOBAL_GAIN_DEF);
	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
			  V4L2_CID_HFLIP, 0, 1, 1, 0);
	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
			  V4L2_CID_VFLIP, 0, 1, 1, 0);

	for (i = 0; i < ARRAY_SIZE(mt9p031_ctrls); ++i)
		v4l2_ctrl_new_custom(&mt9p031->ctrls, &mt9p031_ctrls[i], NULL);

	mt9p031->subdev.ctrl_handler = &mt9p031->ctrls;

	if (mt9p031->ctrls.error)
		printk(KERN_INFO "%s: control initialization error %d\n",
		       __func__, mt9p031->ctrls.error);

	mutex_init(&mt9p031->power_lock);
	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;

	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
	ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad, 0);
	if (ret < 0)
		goto done;

	mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;

	mt9p031->crop.width = MT9P031_WINDOW_WIDTH_DEF;
	mt9p031->crop.height = MT9P031_WINDOW_HEIGHT_DEF;
	mt9p031->crop.left = MT9P031_COLUMN_START_DEF;
	mt9p031->crop.top = MT9P031_ROW_START_DEF;

	if (mt9p031->pdata->version == MT9P031_MONOCHROME_VERSION)
		mt9p031->format.code = V4L2_MBUS_FMT_Y12_1X12;
	else
		mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;

	mt9p031->format.width = MT9P031_WINDOW_WIDTH_DEF;
	mt9p031->format.height = MT9P031_WINDOW_HEIGHT_DEF;
	mt9p031->format.field = V4L2_FIELD_NONE;
	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
	isi_set_clk();
	mt9p031->pdata->ext_freq=21000000;
	mt9p031->pdata->target_freq=48000000;
	ret = mt9p031_pll_get_divs(mt9p031);

done:
	if (ret < 0) {
		v4l2_ctrl_handler_free(&mt9p031->ctrls);
		media_entity_cleanup(&mt9p031->subdev.entity);
		kfree(mt9p031);
	}

	return ret;
}



