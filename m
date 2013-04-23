Return-path: <linux-media-owner@vger.kernel.org>
Received: from hm1480-10.locaweb.com.br ([201.76.49.107]:12134 "EHLO
	hm1480-10.locaweb.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab3DWPkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 11:40:32 -0400
Received: from mcbain0007.email.locaweb.com.br (189.126.112.75) by hm1480-23.locaweb.com.br (PowerMTA(TM) v3.5r15) id heqln00nva41 for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 12:40:28 -0300 (envelope-from <marcio@netopen.com.br>)
Date: Tue, 23 Apr 2013 12:40:34 -0200
Subject: Re: AT91SAM9M10: Problem porting driver for MT9P031 sensor
From: Marcio Campos de Lima <marcio@netopen.com.br>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>
Message-ID: <CD9C3147.AFBE%marcio@netopen.com.br>
In-Reply-To: <Pine.LNX.4.64.1304191441170.591@axis700.grange>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi

What is the Linux version that has all of your patches already applied?
Where can I download it?

Thanks
Marcio

On 19/04/13 10:42, "Guennadi Liakhovetski" <g.liakhovetski@gmx.de> wrote:

>On Thu, 18 Apr 2013, Marcio Campos de Lima wrote:
>
>> Hi Guennadi
>> 
>> Thanks a lot for your attention.
>> I think I cannot apply the patches. My Linux sources, downloaded from
>> www.at91.com, does not have the V4l2-async.h header and, I suppose, many
>> others headers. The MT9P031 sources have been modified and it is in a
>> different tree. Can you tell me where I can download an already patched
>> Kernel 3.6.9 which I can add theses functionality to the driver I am
>>using?
>
>Hm, no, sorry, today isn't your lucky day. I don't think I can help you
>with a 3.6 kernel.
>
>Thanks
>Guennadi
>
>> By the way, our MT9P031 sensor board has 10-bit format. I have fixed
>> already.
>> 
>> Regards
>> MArcio 
>> 
>> On 18/04/13 19:44, "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
>>wrote:
>> 
>> >Hi Marcio
>> >
>> >On Thu, 18 Apr 2013, Marcio Campos de Lima wrote:
>> >
>> >> >Hi
>> >> >
>> >> >I am porting the MT9P031 sensor device driver for a custom designed
>> >>board
>> >> >based at the AT91SAM9M45-EK development board and Linux 3.6.9.
>> >> >The driver detects the sensor but does not create /dev/video1.
>> >> >
>> >> >Can anybody help me?
>> >
>> >Congratulations, today is your lucky day :-) I've just posted a
>> >patch-series
>> >
>> 
>>>http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/6
>>>35
>> >04
>> >
>> >to do exactly what you need. Well, 99% of what you need :) With at91
>> >you're using the atmel-isi soc-camera camera host driver. Shich isn't
>> >extended by this patch series to support the asynchronous subdevice
>> >registration, but it's rather easy to add, please, have a look at patch
>> >#15 for an example, based on the mx3_camera driver. Then there's a
>>slight
>> >problem of mt9p031 only exporting 12-bit formats. You can "fix" it
>> >internally by substituting 8-bit formats (you are using 8 bits, right?)
>> >instead. We'll need a proper solution at some point. The last patch in
>> >the 
>> >series shows how to add support for the mt9p031 sensor to a board.
>> >
>> >Anyway, give it a try, feel free to ask.
>> >
>> >Thanks
>> >Guennadi
>> >
>> >> >Thanks
>> >> >Marcio
>> >> 
>> >> This is the probe code fo the driver if this can help:
>> >> 
>> >> /* 
>> >> 
>> 
>>>>-----------------------------------------------------------------------
>>>>--
>> >>--
>> >> --
>> >>  * Driver initialization and probing
>> >>  */
>> >> 
>> >> static int mt9p031_probe(struct i2c_client *client,
>> >> 			 const struct i2c_device_id *did)
>> >> {
>> >> 	struct mt9p031_platform_data *pdata = client->dev.platform_data;
>> >> 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>> >> 	struct mt9p031 *mt9p031;
>> >> 	unsigned int i;
>> >> 	int ret;
>> >> 
>> >> 	if (pdata == NULL) {
>> >> 		dev_err(&client->dev, "No platform data\n");
>> >> 		return -EINVAL;
>> >> 	}
>> >> 
>> >> 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
>> >> 		dev_warn(&client->dev,
>> >> 			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
>> >> 		return -EIO;
>> >> 	}
>> >> 
>> >> 	mt9p031 = kzalloc(sizeof(*mt9p031), GFP_KERNEL);
>> >> 	if (mt9p031 == NULL)
>> >> 		return -ENOMEM;
>> >> 
>> >> 	mt9p031->pdata = pdata;
>> >> 	mt9p031->output_control	= MT9P031_OUTPUT_CONTROL_DEF;
>> >> 	mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
>> >> 
>> >> 	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) +
>>4);
>> >> 
>> >> 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
>> >> 			  V4L2_CID_EXPOSURE, MT9P031_SHUTTER_WIDTH_MIN,
>> >> 			  MT9P031_SHUTTER_WIDTH_MAX, 1,
>> >> 			  MT9P031_SHUTTER_WIDTH_DEF);
>> >> 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
>> >> 			  V4L2_CID_GAIN, MT9P031_GLOBAL_GAIN_MIN,
>> >> 			  MT9P031_GLOBAL_GAIN_MAX, 1, MT9P031_GLOBAL_GAIN_DEF);
>> >> 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
>> >> 			  V4L2_CID_HFLIP, 0, 1, 1, 0);
>> >> 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
>> >> 			  V4L2_CID_VFLIP, 0, 1, 1, 0);
>> >> 
>> >> 	for (i = 0; i < ARRAY_SIZE(mt9p031_ctrls); ++i)
>> >> 		v4l2_ctrl_new_custom(&mt9p031->ctrls, &mt9p031_ctrls[i], NULL);
>> >> 
>> >> 	mt9p031->subdev.ctrl_handler = &mt9p031->ctrls;
>> >> 
>> >> 	if (mt9p031->ctrls.error)
>> >> 		printk(KERN_INFO "%s: control initialization error %d\n",
>> >> 		       __func__, mt9p031->ctrls.error);
>> >> 
>> >> 	mutex_init(&mt9p031->power_lock);
>> >> 	v4l2_i2c_subdev_init(&mt9p031->subdev, client, &mt9p031_subdev_ops);
>> >> 	mt9p031->subdev.internal_ops = &mt9p031_subdev_internal_ops;
>> >> 
>> >> 	mt9p031->pad.flags = MEDIA_PAD_FL_SOURCE;
>> >> 	ret = media_entity_init(&mt9p031->subdev.entity, 1, &mt9p031->pad,
>>0);
>> >> 	if (ret < 0)
>> >> 		goto done;
>> >> 
>> >> 	mt9p031->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> >> 
>> >> 	mt9p031->crop.width = MT9P031_WINDOW_WIDTH_DEF;
>> >> 	mt9p031->crop.height = MT9P031_WINDOW_HEIGHT_DEF;
>> >> 	mt9p031->crop.left = MT9P031_COLUMN_START_DEF;
>> >> 	mt9p031->crop.top = MT9P031_ROW_START_DEF;
>> >> 
>> >> 	if (mt9p031->pdata->version == MT9P031_MONOCHROME_VERSION)
>> >> 		mt9p031->format.code = V4L2_MBUS_FMT_Y12_1X12;
>> >> 	else
>> >> 		mt9p031->format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
>> >> 
>> >> 	mt9p031->format.width = MT9P031_WINDOW_WIDTH_DEF;
>> >> 	mt9p031->format.height = MT9P031_WINDOW_HEIGHT_DEF;
>> >> 	mt9p031->format.field = V4L2_FIELD_NONE;
>> >> 	mt9p031->format.colorspace = V4L2_COLORSPACE_SRGB;
>> >> 	isi_set_clk();
>> >> 	mt9p031->pdata->ext_freq=21000000;
>> >> 	mt9p031->pdata->target_freq=48000000;
>> >> 	ret = mt9p031_pll_get_divs(mt9p031);
>> >> 
>> >> done:
>> >> 	if (ret < 0) {
>> >> 		v4l2_ctrl_handler_free(&mt9p031->ctrls);
>> >> 		media_entity_cleanup(&mt9p031->subdev.entity);
>> >> 		kfree(mt9p031);
>> >> 	}
>> >> 
>> >> 	return ret;
>> >> }
>> >> 
>> >> 
>> >> 
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe
>>linux-media"
>> >>in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> 
>> >
>> >---
>> >Guennadi Liakhovetski, Ph.D.
>> >Freelance Open-Source Software Developer
>> >http://www.open-technology.de/
>> 
>> 
>
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/


