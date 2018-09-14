Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39266 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbeIOCKr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 22:10:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id q8-v6so3289303wmq.4
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2018 13:54:36 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] media: soc_camera: ov9640: move ov9640 out of
 soc_camera
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
References: <cover.1534339750.git.petrcvekcz@gmail.com>
 <dc99bd37408f42a342b1b878d01c16f8c25b758b.1534339750.git.petrcvekcz@gmail.com>
 <20180914125910.4ju2utqdlk3klmoz@valkosipuli.retiisi.org.uk>
From: Petr Cvek <petrcvekcz@gmail.com>
Message-ID: <e12dab78-5a85-a94f-e892-0723592cd2dd@gmail.com>
Date: Fri, 14 Sep 2018 22:54:51 +0200
MIME-Version: 1.0
In-Reply-To: <20180914125910.4ju2utqdlk3klmoz@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 14.9.2018 v 14:59 Sakari Ailus napsal(a):
> Hi Petr,
> 
> Thanks for the patchset, and my apologies for reviewing it so late!
> 
> I'm commenting this one but feel free to add patches to address the
> comments.
> 

Hi and thanks for the review. I would like to have this patch set to be
as much as possible only a conversion from soc-camera, but I guess I can
fix the error handling in probe and the missing newlines. For the
enhanced functionality, I would like to have a new patch set after I'll
patch the controller (pxa camera) on my testing platform.

>> +/* Start/Stop streaming from the device */
>> +static int ov9640_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +	return 0;
> 
> Doesn't the sensor provide any control over the streaming state? Just
> wondering...
> 

Before the PXA camera switch from soc-camera I've found some
deficiencies in register settings so I'm planning to test them all. With
the current state of vanilla I wouldn't be able to test the change.
After the quick search in datasheet I wasn't able to find any (stream,
capture, start) flag. It may be controlled by just setting the output
format flags, but these registers are some of those I will be changing
in the future.

>> +static int ov9640_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>> +	struct ov9640_priv *priv = to_ov9640_sensor(sd);
>> +
>> +	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
> 
> Runtime PM support would be nice --- but not needed in this set IMO.
> 

If I remember correctly a suspend to mem will freeze the whole machine,
so in the future :-/.


>> +}
>> +
>> +/* select nearest higher resolution for capture */
>> +static void ov9640_res_roundup(u32 *width, u32 *height)
>> +{
>> +	int i;
> 
> unsigned int
> 
> Same for other loops where no negative values or test below zero are
> needed (or where the value which is compared against is signed).
> 
Just re-declaring: unsigned int i; ... OK

>> +
>> +	cfg->try_fmt = *mf;
> 
> Newline here?
> 
>> +	return 0;
>> +}
>> +
>> +static int ov9640_enum_mbus_code(struct v4l2_subdev *sd,
>> +		struct v4l2_subdev_pad_config *cfg,
>> +		struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +	if (code->pad || code->index >= ARRAY_SIZE(ov9640_codes))
>> +		return -EINVAL;
>> +
>> +	code->code = ov9640_codes[code->index];
> 
> And here.
> 

np

>> +/* Request bus settings on camera side */
>> +static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
>> +				struct v4l2_mbus_config *cfg)
>> +{
>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>> +
>> +	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
>> +		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
>> +		V4L2_MBUS_DATA_ACTIVE_HIGH;
> 
> This should come from DT instead. Could you add DT binding documentation
> for the sensor, please? There's already some for ov9650; I wonder how
> similar that one is.

The platform doesn't support it yet, so I have no way to test any DT
patches.

>> +	cfg->type = V4L2_MBUS_PARALLEL;
>> +	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_subdev_video_ops ov9640_video_ops = {
>> +	.s_stream	= ov9640_s_stream,
>> +	.g_mbus_config	= ov9640_g_mbus_config,
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops ov9640_pad_ops = {
>> +	.enum_mbus_code = ov9640_enum_mbus_code,
>> +	.get_selection	= ov9640_get_selection,
>> +	.set_fmt	= ov9640_set_fmt,
> 
> Please add an operating to get the format as well.

OK, but it will be tested on a preliminary hacked pxa-camera :-).

> 
>> +};
>> +
>> +static const struct v4l2_subdev_ops ov9640_subdev_ops = {
>> +	.core	= &ov9640_core_ops,
>> +	.video	= &ov9640_video_ops,
>> +	.pad	= &ov9640_pad_ops,
>> +};
>> +
>> +/*
>> + * i2c_driver function
>> + */
>> +static int ov9640_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *did)
>> +{
>> +	struct ov9640_priv *priv;
>> +	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>> +	int ret;
>> +
>> +	if (!ssdd) {
>> +		dev_err(&client->dev, "Missing platform_data for driver\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>> +	if (!priv)
>> +		return -ENOMEM;
>> +
>> +	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
>> +
>> +	v4l2_ctrl_handler_init(&priv->hdl, 2);
>> +	v4l2_ctrl_new_std(&priv->hdl, &ov9640_ctrl_ops,
>> +			V4L2_CID_VFLIP, 0, 1, 1, 0);
>> +	v4l2_ctrl_new_std(&priv->hdl, &ov9640_ctrl_ops,
>> +			V4L2_CID_HFLIP, 0, 1, 1, 0);
>> +	priv->subdev.ctrl_handler = &priv->hdl;
>> +	if (priv->hdl.error)
> 
> v4l2_ctrl_handler_free() is missing here. The function would benefit from
> goto-based error handling.
> 

+ rest -> np


best regards,
pc2005
