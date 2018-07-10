Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:35377 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbeGJHkY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 03:40:24 -0400
From: "Yeh, Andy" <andy.yeh@intel.com>
To: "Chen, Ping-chung" <ping-chung.chen@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "grundler@chromium.org" <grundler@chromium.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Subject: RE: [PATCH] media: imx208: Add imx208 camera sensor driver
Date: Tue, 10 Jul 2018 07:37:54 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D704217@PGSMSX111.gar.corp.intel.com>
References: <1531206936-31447-1-git-send-email-ping-chung.chen@intel.com>
In-Reply-To: <1531206936-31447-1-git-send-email-ping-chung.chen@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi PC,

Thanks for the patch.

Cc in Grant, and Intel Jim/Jason

> -----Original Message-----
> From: Chen, Ping-chung
> Sent: Tuesday, July 10, 2018 3:16 PM
> To: linux-media@vger.kernel.org
> Cc: sakari.ailus@linux.intel.com; Yeh, Andy <andy.yeh@intel.com>;
> tfiga@chromium.org; Chen, Ping-chung <ping-chung.chen@intel.com>
> Subject: [PATCH] media: imx208: Add imx208 camera sensor driver
> +};
> +
> +static int imx208_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_mbus_code_enum *code) {
> +	/* Only one bayer order(GRBG) is supported */
> +	if (code->index > 0)
> +		return -EINVAL;
> +

There is no limitation on using GRBG bayer order now. You can refer to imx355 driver as well.

	+static int imx355_enum_frame_size(struct v4l2_subdev *sd,
	+				   struct v4l2_subdev_pad_config *cfg,
	+				   struct v4l2_subdev_frame_size_enum *fse)
	+{	
	+	struct imx355 *imx355 = to_imx355(sd);

> +	code->code = MEDIA_BUS_FMT_SRGGB10_1X10;
> +
> +	return 0;
> +}
> +
> +static int imx208_enum_frame_size(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_frame_size_enum *fse) {
> +	if (fse->index >= ARRAY_SIZE(supported_modes))
> +		return -EINVAL;
> +
> +	if (fse->code != MEDIA_BUS_FMT_SRGGB10_1X10)
> +		return -EINVAL;
> +
> +	fse->min_width = supported_modes[fse->index].width;
> +	fse->max_width = fse->min_width;
> +	fse->min_height = supported_modes[fse->index].height;
> +	fse->max_height = fse->min_height;
> +
> +	return 0;
> +}
> +
> +static void imx208_update_pad_format(const struct imx208_mode *mode,
> +				      struct v4l2_subdev_format *fmt) {
> +	fmt->format.width = mode->width;
> +	fmt->format.height = mode->height;
> +	fmt->format.code = MEDIA_BUS_FMT_SRGGB10_1X10;
> +	fmt->format.field = V4L2_FIELD_NONE;
> +}
> +
> +
> +static int imx208_probe(struct i2c_client *client) {
> +	struct imx208 *imx208;
> +	int ret;
> +	u32 val = 0;
> +
> +	device_property_read_u32(&client->dev, "clock-frequency", &val);
> +	if (val != 19200000)
> +		return -EINVAL;
> +
> +	imx208 = devm_kzalloc(&client->dev, sizeof(*imx208), GFP_KERNEL);
> +	if (!imx208)
> +		return -ENOMEM;
> +
> +	/* Initialize subdev */
> +	v4l2_i2c_subdev_init(&imx208->sd, client, &imx208_subdev_ops);
> +
> +	/* Check module identity */
> +	ret = imx208_identify_module(imx208);
> +	if (ret)
> +		return ret;
> +
> +	/* Set default mode to max resolution */
> +	imx208->cur_mode = &supported_modes[0];
> +
> +	ret = imx208_init_controls(imx208);
> +	if (ret)
> +		return ret;
> +
> +	/* Initialize subdev */
> +	imx208->sd.internal_ops = &imx208_internal_ops;
> +	imx208->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	imx208->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> +
> +	/* Initialize source pad */
> +	imx208->pad.flags = MEDIA_PAD_FL_SOURCE;

Please refer to IMX355 to change below code to new API on upstreamed kernel.
https://patchwork.linuxtv.org/patch/50028/

	+	/* Initialize subdev */
	+	imx355->sd.internal_ops = &imx355_internal_ops;
	+	imx355->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
	+		V4L2_SUBDEV_FL_HAS_EVENTS;
	+	imx355->sd.entity.ops = &imx355_subdev_entity_ops;
	+	imx355->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
	+	ret = media_entity_pads_init(&imx355->sd.entity, 1, &imx355->pad);


> +	ret = media_entity_init(&imx208->sd.entity, 1, &imx208->pad, 0);
> +	if (ret) {
> +		dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
> +		goto error_handler_free;
> +	}
> +
> +	ret = v4l2_async_register_subdev_sensor_common(&imx208->sd);
> +	if (ret < 0)
> +		goto error_media_entity;
> +
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);
> +	pm_runtime_idle(&client->dev);
> +
> +	return 0;
> +
> +error_media_entity:
> +	media_entity_cleanup(&imx208->sd.entity);
> +
> +error_handler_free:
> +	imx208_free_controls(imx208);
> +
> +	return ret;
> +}
> +
> +static int imx208_remove(struct i2c_client *client) {
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct imx208 *imx208 = to_imx208(sd);
> +
> +	v4l2_async_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	imx208_free_controls(imx208);
> +
> +	pm_runtime_disable(&client->dev);
> +	pm_runtime_set_suspended(&client->dev);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops imx208_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(imx208_suspend, imx208_resume) };
> +
> +#ifdef CONFIG_ACPI
> +static const struct acpi_device_id imx208_acpi_ids[] = {
> +	{ "INT3478" },
> +	{ /* sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(acpi, imx208_acpi_ids); #endif
> +
> +static struct i2c_driver imx208_i2c_driver = {
> +	.driver = {
> +		.name = "imx208",
> +		.pm = &imx208_pm_ops,
> +		.acpi_match_table = ACPI_PTR(imx208_acpi_ids),
> +	},
> +	.probe_new = imx208_probe,
> +	.remove = imx208_remove,
> +};
> +
> +module_i2c_driver(imx208_i2c_driver);
> +
> +MODULE_AUTHOR("Yeh, Andy <andy.yeh@intel.com>");
> MODULE_AUTHOR("Chen,
> +Ping-chung <ping-chung.chen@intel.com>"); MODULE_DESCRIPTION("Sony
> +IMX208 sensor driver"); MODULE_LICENSE("GPL v2");
> --
> 1.9.1
