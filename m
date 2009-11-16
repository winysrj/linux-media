Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50633 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbZKPSdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 13:33:24 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"santiago.nunez@ridgerun.com" <santiago.nunez@ridgerun.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"diego.dompe@ridgerun.com" <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"Grosen, Mark" <mgrosen@ti.com>
Date: Mon, 16 Nov 2009 12:33:19 -0600
Subject: RE: [PATCH 3/4 v7] TVP7002 driver for DM365
Message-ID: <A69FA2915331DC488A831521EAE36FE401559C558C@dlee06.ent.ti.com>
References: <1257889836-19208-1-git-send-email-santiago.nunez@ridgerun.com>
 <200911151416.00674.hverkuil@xs4all.nl>
In-Reply-To: <200911151416.00674.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * tvp7002_s_stream() - V4L2 decoder i/f handler for s_stream
>> + * @sd: pointer to standard V4L2 sub-device structure
>> + * @enable: streaming enable or disable
>> + *
>> + * Sets streaming to enable or disable, if possible.
>> + */
>> +static int tvp7002_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +	struct tvp7002 *device = to_tvp7002(sd);
>> +	int error = 0;
>> +
>> +	if (device->streaming == enable)
>> +		return 0;
>> +
>> +	if (enable) {
>> +		/* Set output state on (low impedance means stream on) */
>> +		device->registers[TVP7002_MISC_CTL_2].value = 0x00;
>> +		/* Power off chip */
>> +		error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x7f);
>> +		if (error) {
>> +			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
>> +			error = -EINVAL;
>> +		}
>> +		/* Power on chip */
>> +		error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x00);
>> +		if (error) {
>> +			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
>> +			return error;
>> +		}
>> +		/* Re-set register values with stored ones */
>> +		error = tvp7002_write_inittab(sd, device->registers);
>
>I still think that this register storing code sucks.

I think Santiago based his driver on tvp514x which doesn't update the register until the chip is ready to stream. Only when STREAMON is called
the chip is powered On and the register values are configured. This looks
perfectly fine to me ( For example due to power savings considerations).
So please elaborate why you think this is not right. IMO, keeping the driver design similar to TVP514x helps in understanding the driver better. So unless you see a serious design flaw with this approach, I wouldn't change
the code.

I would like Vaibhav's opinion as well since he is the owner of TVP514x
driver.

Thanks.
>
>First of all, are you really, really sure that this is the way to program
>this
>device? It seems very peculiar to me.
>
>And secondly, I looked through the code and the only state I see are the
>preset and the gain. So it is much simpler IMHO to just init the chip after
>power on and then just set those two settings again. Then you can drop all
>those shadow register handling.
>
>> +
>> +		if (error < 0) {
>> +			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
>> +			return error;
>> +		}
>> +		device->streaming = enable;
>> +	} else {
>> +		/* Set output state off (low impedance means stream off) */
>> +		device->registers[TVP7002_MISC_CTL_2].value = 0x03;
>> +		error = tvp7002_write(sd, TVP7002_MISC_CTL_2, 0x03);
>> +		if (error) {
>> +			v4l2_dbg(1, debug, sd, "Unable to stop streaming\n");
>> +			error = -EINVAL;
>> +		}
>> +
>> +		device->streaming = enable;
>> +	}
>> +
>> +	return error;
>> +}
>> +
>> +/*
>> + * tvp7002_log_chk() - Check reading the value of a register
>> + * @sd: ptr to v4l2_subdev struct
>> + * @reg: register to read
>> + * @message: register name/function
>> + *
>> + * Check procedure for reading a register.
>> + * Returns nothing (void).
>> + */
>> +static inline void tvp7002_log_chk(struct v4l2_subdev *sd, u8 reg,
>> +							const char *message)
>> +{
>> +	int error;
>> +	u8 result;
>> +
>> +	error = tvp7002_read(sd, reg, &result);
>> +
>> +	if (error >= 0)
>> +		v4l2_info(sd, "%s (0x%02x) = 0x%02x\n", message, reg, result);
>> +}
>> +
>> +/*
>> + * tvp7002_log_status() - Print information about register settings
>> + * @sd: ptr to v4l2_subdev struct
>> + *
>> + * Log register values of a TVP7002 decoder device.
>> + * Returns zero or -EINVAL if read operation fails.
>> + */
>> +static int tvp7002_log_status(struct v4l2_subdev *sd)
>> +{
>> +	struct tvp7002 *device = to_tvp7002(sd);
>> +	struct v4l2_dv_preset preset;
>> +	int i;
>> +
>> +	tvp7002_log_chk(sd, TVP7002_CHIP_REV, "Chip revision number");
>> +
>> +	/* Find my current standard*/
>> +	tvp7002_query_dv_preset(sd, &preset);
>> +
>> +	/* Print standard related code values */
>> +	for (i = 0; i < NUM_PRESETS; i++)
>> +		if (tvp7002_presets[i].preset == preset.preset)
>> +			break;
>> +
>> +	if (i == NUM_PRESETS)
>> +		return -EINVAL;
>
>tvp7002_query_dv_preset returns an error if it can't find a standard. So no
>need to check the preset value, just check the error code.
>
>Also: if no standard was found then that is not a log_status error. Just
>print 'No standard found.' and return 0. After all, that IS the status of
>the
>chip and it is not an error of the status log!
>
>> +
>> +	v4l2_info(sd, "DV Preset: %s\n", tvp7002_presets[i].name);
>> +	v4l2_info(sd, "Pixels per line: %u\n", tvp7002_presets[i].width);
>> +	v4l2_info(sd, "Lines per frame: %u\n", tvp7002_presets[i].height);
>> +	v4l2_info(sd, "Streaming enabled: %s\n", device->streaming ? "yes" :
>"no");
>> +
>> +	/* Print values of the gain control */
>> +	tvp7002_log_chk(sd, TVP7002_B_FINE_GAIN, "Digital fine gain B ch");
>> +	tvp7002_log_chk(sd, TVP7002_G_FINE_GAIN, "Digital fine gain G ch");
>> +	tvp7002_log_chk(sd, TVP7002_R_FINE_GAIN, "Digital fine gain R ch");
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * tvp7002_reset - Reset a TVP7002 device
>> + * @sd: ptr to v4l2_subdev struct
>> + * @val: unsigned integer (not used)
>> + *
>> + * Reset the TVP7002 device
>> + * Returns zero when successful or -EINVAL if register read fails.
>> + */
>> +static int tvp7002_reset(struct v4l2_subdev *sd, u32 val)
>> +{
>> +	struct tvp7002 *device = to_tvp7002(sd);
>> +	struct v4l2_dv_preset preset;
>> +	int polarity_a;
>> +	int polarity_b;
>> +	u8 revision;
>> +	int error;
>> +
>> +	error = tvp7002_read(sd, TVP7002_CHIP_REV, &revision);
>> +	if (error < 0)
>> +		goto found_error;
>> +
>> +	/* Get revision number */
>> +	v4l2_info(sd, "Rev. %02x detected.\n", revision);
>> +	if (revision != 0x02)
>> +		v4l2_info(sd, "Unknown revision detected.\n");
>> +
>> +	/* Power down and up */
>> +	error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x7f);
>> +	if (error < 0)
>> +		goto found_error;
>> +
>> +	error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x00);
>> +	if (error < 0)
>> +		goto found_error;
>> +
>> +	/* Set the default register values */
>> +	memcpy(device->registers, tvp7002_init_default,
>> +					sizeof(tvp7002_init_default));
>> +
>> +	/* Initializes TVP7002 to its default values */
>> +	error = tvp7002_write_inittab(sd, device->registers);
>> +
>> +	if (error < 0)
>> +		goto found_error;
>> +
>> +	/* Set polarity information after registers have been set */
>> +
>> +	polarity_a = 0x20 | device->pdata->hs_polarity << 5
>> +			| device->pdata->vs_polarity << 2;
>> +	error = tvp7002_write(sd, TVP7002_SYNC_CTL_1, polarity_a);
>> +	if (error < 0)
>> +		goto found_error;
>> +
>> +	polarity_b = 0x01  | device->pdata->fid_polarity << 2
>> +			| device->pdata->sog_polarity << 1
>> +			| device->pdata->clk_polarity;
>> +	error = tvp7002_write(sd, TVP7002_MISC_CTL_3, polarity_b);
>> +	if (error < 0)
>> +		goto found_error;
>> +
>> +	/* Save polarity information in register */
>> +	device->registers[TVP7002_SYNC_CTL_1].value = polarity_a;
>> +	device->registers[TVP7002_MISC_CTL_3].value = polarity_b;
>> +	/* Set registers according to default video mode */
>> +	preset.preset = tvp7002_presets[device->current_preset].preset;
>> +	error = tvp7002_s_dv_preset(sd, &preset);
>> +
>> +found_error:
>> +	return error;
>> +};
>> +
>> +/* V4L2 core operation handlers */
>> +static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
>> +	.g_chip_ident = tvp7002_g_chip_ident,
>> +	.log_status = tvp7002_log_status,
>> +	.g_ctrl = tvp7002_g_ctrl,
>> +	.s_ctrl = tvp7002_s_ctrl,
>> +	.queryctrl = tvp7002_queryctrl,
>> +	.reset = tvp7002_reset,
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +	.g_register = tvp7002_g_register,
>> +	.s_register = tvp7002_s_register,
>> +#endif
>> +};
>> +
>> +/* Specific video subsystem operation handlers */
>> +static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
>> +	.s_dv_preset = tvp7002_s_dv_preset,
>> +	.query_dv_preset = tvp7002_query_dv_preset,
>> +	.s_stream = tvp7002_s_stream,
>> +	.g_fmt = tvp7002_g_fmt,
>> +	.s_fmt = tvp7002_s_fmt,
>> +	.enum_fmt = tvp7002_enum_fmt,
>> +};
>> +
>> +/* V4L2 top level operation handlers */
>> +static const struct v4l2_subdev_ops tvp7002_ops = {
>> +	.core = &tvp7002_core_ops,
>> +	.video = &tvp7002_video_ops,
>> +};
>> +
>> +static struct tvp7002 tvp7002_dev = {
>> +	.streaming = 0,
>> +
>> +	.pix = {
>> +		.width = HD_720_NUM_ACTIVE_PIXELS,
>> +		.height = HD_720_NUM_ACTIVE_LINES,
>> +		.pixelformat = V4L2_PIX_FMT_UYVY,
>> +		.field = V4L2_FIELD_NONE,
>> +		.bytesperline = HD_720_NUM_ACTIVE_PIXELS * 2,
>> +		.sizeimage =
>> +		HD_720_NUM_ACTIVE_PIXELS * 2 * HD_720_NUM_ACTIVE_LINES,
>> +		.colorspace = V4L2_COLORSPACE_SMPTE170M,
>> +		},
>> +
>> +	.current_preset = INDEX_720P60,
>
>Rather than keeping this struct around, isn't it easier to just call s_fmt
>during tvp7002_probe to set it up for 720P?
>
>> +};
>> +
>> +/*
>> + * tvp7002_probe - Probe a TVP7002 device
>> + * @sd: ptr to v4l2_subdev struct
>> + * @ctrl: ptr to i2c_device_id struct
>> + *
>> + * Initialize the TVP7002 device
>> + * Returns zero when successful or -EINVAL if register read fails.
>> + */
>> +static int tvp7002_probe(struct i2c_client *c, const struct
>i2c_device_id *id)
>> +{
>> +	struct v4l2_subdev *sd;
>> +	struct tvp7002 *device;
>> +	int error;
>> +
>> +	/* Check if the adapter supports the needed features */
>> +	if (!i2c_check_functionality(c->adapter,
>> +		I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
>> +		return -EIO;
>> +
>> +	if (!c->dev.platform_data) {
>> +		v4l2_err(c, "No platform data!!\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	device = (struct tvp7002 *) kmalloc(sizeof(struct tvp7002),
>> +								GFP_KERNEL);
>> +
>> +	if (!device)
>> +		return -ENOMEM;
>> +
>> +	memcpy(device, &tvp7002_dev, sizeof(struct tvp7002));
>> +	sd = &device->sd;
>> +	device->pdata = c->dev.platform_data;
>> +
>> +	/* Tell v4l2 the device is ready */
>> +	v4l2_i2c_subdev_init(sd, c, &tvp7002_ops);
>> +	v4l_info(c, "tvp7002 found @ 0x%02x (%s)\n",
>> +					c->addr, c->adapter->name);
>> +
>> +	/* Initialize device internals */
>> +	error = tvp7002_reset(sd, 0);
>> +	if (error < 0) {
>> +		kfree(device);
>> +		return error;
>> +	}
>> +	return 0;
>> +}
>> +
>> +/*
>> + * tvp7002_remove - Remove TVP7002 device support
>> + * @c: ptr to i2c_client struct
>> + *
>> + * Reset the TVP7002 device
>> + * Returns zero.
>> + */
>> +static int tvp7002_remove(struct i2c_client *c)
>> +{
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(c);
>> +	struct tvp7002 *device = to_tvp7002(sd);
>> +
>> +	v4l2_dbg(1, debug, sd, "Removing tvp7002 adapter"
>> +				"on address 0x%x\n", c->addr);
>> +
>> +	v4l2_device_unregister_subdev(sd);
>> +	kfree(device);
>> +	return 0;
>> +}
>> +
>> +/* I2C Device ID table */
>> +static const struct i2c_device_id tvp7002_id[] = {
>> +	{ "tvp7002", 0 },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, tvp7002_id);
>> +
>> +/* I2C driver data */
>> +static struct i2c_driver tvp7002_driver = {
>> +	.driver = {
>> +		.owner = THIS_MODULE,
>> +		.name = TVP7002_MODULE_NAME,
>> +	},
>> +	.probe = tvp7002_probe,
>> +	.remove = tvp7002_remove,
>> +	.id_table = tvp7002_id,
>> +};
>> +
>> +/*
>> + * tvp7002_init - Initialize driver via I2C interface
>> + *
>> + * Register the TVP7002 driver.
>> + * Returns 0 on success or < 0 on failure.
>> + */
>> +static int __init tvp7002_init(void)
>> +{
>> +	return i2c_add_driver(&tvp7002_driver);
>> +}
>> +
>> +/*
>> + * tvp7002_exit - Remove driver via I2C interface
>> + *
>> + * Unregister the TVP7002 driver.
>> + * Returns 0 on success or < 0 on failure.
>> + */
>> +static void __exit tvp7002_exit(void)
>> +{
>> +	i2c_del_driver(&tvp7002_driver);
>> +}
>> +
>> +module_init(tvp7002_init);
>> +module_exit(tvp7002_exit);
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

