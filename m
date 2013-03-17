Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43183 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab3CQTjE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 15:39:04 -0400
Message-ID: <51461BD2.8080905@gmail.com>
Date: Sun, 17 Mar 2013 20:38:58 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, dh09.lee@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/8] s5p-fimc: Add Exynos4x12 FIMC-IS driver
References: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com> <1363031092-29950-2-git-send-email-s.nawrocki@samsung.com> <201303121527.00571.hverkuil@xs4all.nl>
In-Reply-To: <201303121527.00571.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 03/12/2013 03:27 PM, Hans Verkuil wrote:
> On Mon 11 March 2013 20:44:45 Sylwester Nawrocki wrote:
[...]
>> +
>> +/* Supported manual ISO values */
>> +static const s64 iso_qmenu[] = {
>> +	50, 100, 200, 400, 800,
>> +};
>> +
>> +static int __ctrl_set_iso(struct fimc_is *is, int value)
>> +{
>> +	unsigned int idx, iso;
>> +
>> +	if (value == V4L2_ISO_SENSITIVITY_AUTO) {
>> +		__is_set_isp_iso(is, ISP_ISO_COMMAND_AUTO, 0);
>> +		return 0;
>> +	}
>> +	idx = is->isp.ctrls.iso->val;
>> +	if (idx>= ARRAY_SIZE(iso_qmenu))
>> +		return -EINVAL;
>> +
>> +	iso = iso_qmenu[idx];
>> +	__is_set_isp_iso(is, ISP_ISO_COMMAND_MANUAL, iso);
>> +	return 0;
>> +}
[...]
>> +int fimc_isp_subdev_create(struct fimc_isp *isp)
>> +{
>> +	const struct v4l2_ctrl_ops *ops =&fimc_isp_ctrl_ops;
>> +	struct v4l2_ctrl_handler *handler =&isp->ctrls.handler;
>> +	struct v4l2_subdev *sd =&isp->subdev;
>> +	struct fimc_isp_ctrls *ctrls =&isp->ctrls;
>> +	int ret;
>> +
>> +	mutex_init(&isp->subdev_lock);
>> +
>> +	v4l2_subdev_init(sd,&fimc_is_subdev_ops);
>> +	sd->grp_id = GRP_ID_FIMC_IS;
>> +	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +	snprintf(sd->name, sizeof(sd->name), "FIMC-IS-ISP");
>> +
>> +	isp->subdev_pads[FIMC_IS_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
>> +	isp->subdev_pads[FIMC_IS_SD_PAD_SRC_FIFO].flags = MEDIA_PAD_FL_SOURCE;
>> +	isp->subdev_pads[FIMC_IS_SD_PAD_SRC_DMA].flags = MEDIA_PAD_FL_SOURCE;
>> +	ret = media_entity_init(&sd->entity, FIMC_IS_SD_PADS_NUM,
>> +				isp->subdev_pads, 0);
>> +	if (ret)
>> +		return ret;
>> +
>> +	v4l2_ctrl_handler_init(handler, 20);
>> +
>> +	ctrls->saturation = v4l2_ctrl_new_std(handler, ops, V4L2_CID_SATURATION,
>> +						-2, 2, 1, 0);
>> +	ctrls->brightness = v4l2_ctrl_new_std(handler, ops, V4L2_CID_BRIGHTNESS,
>> +						-4, 4, 1, 0);
>> +	ctrls->contrast = v4l2_ctrl_new_std(handler, ops, V4L2_CID_CONTRAST,
>> +						-2, 2, 1, 0);
>> +	ctrls->sharpness = v4l2_ctrl_new_std(handler, ops, V4L2_CID_SHARPNESS,
>> +						-2, 2, 1, 0);
>> +	ctrls->hue = v4l2_ctrl_new_std(handler, ops, V4L2_CID_HUE,
>> +						-2, 2, 1, 0);
>> +
>> +	ctrls->auto_wb = v4l2_ctrl_new_std_menu(handler, ops,
>> +					V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
>> +					8, ~0x14e, V4L2_WHITE_BALANCE_AUTO);
>> +
>> +	ctrls->exposure = v4l2_ctrl_new_std(handler, ops,
>> +					V4L2_CID_EXPOSURE_ABSOLUTE,
>> +					-4, 4, 1, 0);
>> +
>> +	ctrls->exp_metering = v4l2_ctrl_new_std_menu(handler, ops,
>> +					V4L2_CID_EXPOSURE_METERING, 3,
>> +					~0xf, V4L2_EXPOSURE_METERING_AVERAGE);
>> +
>> +	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_POWER_LINE_FREQUENCY,
>> +					V4L2_CID_POWER_LINE_FREQUENCY_AUTO, 0,
>> +					V4L2_CID_POWER_LINE_FREQUENCY_AUTO);
>> +	/* ISO sensitivity */
>> +	ctrls->auto_iso = v4l2_ctrl_new_std_menu(handler, ops,
>> +			V4L2_CID_ISO_SENSITIVITY_AUTO, 1, 0,
>> +			V4L2_ISO_SENSITIVITY_AUTO);
>> +
>> +	ctrls->iso = v4l2_ctrl_new_int_menu(handler, ops,
>> +			V4L2_CID_ISO_SENSITIVITY, ARRAY_SIZE(iso_qmenu) - 1,
>> +			ARRAY_SIZE(iso_qmenu)/2 - 1, iso_qmenu);
>> +
>> +	ctrls->aewb_lock = v4l2_ctrl_new_std(handler, ops,
>> +					V4L2_CID_3A_LOCK, 0, 0x3, 0, 0);
>> +
>> +	/* FIXME: Adjust the enabled controls mask according
>> +	   to the ISP capabilities */
>> +	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_COLORFX,
>> +					V4L2_COLORFX_ANTIQUE,
>> +					0, V4L2_COLORFX_NONE);
>> +	if (handler->error) {
>> +		media_entity_cleanup(&sd->entity);
>> +		return handler->error;
>> +	}
>> +
>> +	ctrls->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
>> +				  V4L2_CTRL_FLAG_UPDATE;
>
> Why would auto_iso be volatile? I would expect the iso to be volatile
> (in which case the 'false' argument below would be 'true'). Also,
> v4l2_ctrl_auto_cluster already sets the UPDATE flag.

Thanks for spotting this. I should have removed this flags set up
since the g_volatile_ctrl op is not currently supported and as far
as I know the firmware doesn't support reading actual ISO value in
auto mode. I'll need to check if there are any commands available
for that.

Anyway auto_iso is not supposed to have the flags set up like this
and that also tells me that I need to inspect my other driver where
this code originally came from. :)

>> +	v4l2_ctrl_auto_cluster(2,&ctrls->auto_iso, 0, false);
>> +
>> +	sd->ctrl_handler = handler;
>> +	sd->internal_ops =&fimc_is_subdev_internal_ops;
>> +	sd->entity.ops =&fimc_is_subdev_media_ops;
>> +	v4l2_set_subdevdata(sd, isp);
>> +
>> +	return 0;
>> +}

>> diff --git a/drivers/media/platform/s5p-fimc/fimc-isp.h b/drivers/media/platform/s5p-fimc/fimc-isp.h
>> new file mode 100644
>> index 0000000..654039e
>> --- /dev/null
>> +++ b/drivers/media/platform/s5p-fimc/fimc-isp.h
>> @@ -0,0 +1,205 @@
[...]
>> +struct fimc_isp_ctrls {
>> +	struct v4l2_ctrl_handler handler;
>> +	/* Internal mode selection */
>> +	struct v4l2_ctrl *scenario;
>> +	/* Frame rate */
>> +	struct v4l2_ctrl *fps;
>> +	/* Touch AF position */
>> +	struct v4l2_ctrl *af_position_x;
>> +	struct v4l2_ctrl *af_position_y;
>> +	/* Auto white balance */
>> +	struct v4l2_ctrl *auto_wb;
>> +	/* ISO sensitivity */
>> +	struct v4l2_ctrl *auto_iso;
>> +	struct v4l2_ctrl *iso;
>
> I suggest putting this in an anonymous struct:
>
> 	struct { /* Auto ISO control cluster */
> 		struct v4l2_ctrl *auto_iso;
> 		struct v4l2_ctrl *iso;
> 	};
>
> That way you visually emphasize that these belong together and that you
> shouldn't move them around.

Agreed. I'll make them grouped in separate structs wherever a cluster
is used.

>> +	struct v4l2_ctrl *contrast;
>> +	struct v4l2_ctrl *saturation;
>> +	struct v4l2_ctrl *sharpness;
>> +	/* Auto/manual exposure */
>> +	struct v4l2_ctrl *auto_exp;
>> +	/* Manual exposure value */
>> +	struct v4l2_ctrl *exposure;
>> +	/* Adjust - brightness */
>> +	struct v4l2_ctrl *brightness;
>> +	/* Adjust - hue */
>> +	struct v4l2_ctrl *hue;
>> +	/* Exposure metering mode */
>> +	struct v4l2_ctrl *exp_metering;
>> +	/* AFC */
>> +	struct v4l2_ctrl *afc;
>> +	/* AE/AWB lock/unlock */
>> +	struct v4l2_ctrl *aewb_lock;
>> +	/* AF */
>> +	struct v4l2_ctrl *focus_mode;
>> +	/* AF status */
>> +	struct v4l2_ctrl *af_status;
>> +};
[...]
>
> Otherwise this patch looks very clean and I really have no other comments.

Thanks a lot for a prompt review!

--

Regards,
Sylwester
