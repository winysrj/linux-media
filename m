Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:14484 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3CLO1q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 10:27:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC PATCH 1/8] s5p-fimc: Add Exynos4x12 FIMC-IS driver
Date: Tue, 12 Mar 2013 15:27:00 +0100
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, dh09.lee@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
References: <1363031092-29950-1-git-send-email-s.nawrocki@samsung.com> <1363031092-29950-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1363031092-29950-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121527.00571.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 11 March 2013 20:44:45 Sylwester Nawrocki wrote:
> This patch adds a set of core files of the Exynos4x12 FIMC-IS
> V4L2 driver. This includes main functionality like allocating
> memory, loading the firmware, FIMC-IS register interface and
> host CPU <-> IS command and error code definitions.
> 
> The driver currently exposes a single subdev named FIMC-IS-ISP,
> which corresponds to the FIMC-IS ISP and DRC IP blocks.
> 
> The FIMC-IS-ISP subdev currently supports only a subset of user
> controls. For other controls we need several extensions at the
> V4L2 API. The supported standard controls are:
> brightness, contrast, saturation, hue, sharpness, 3a_lock,
> exposure_time_absolute, white_balance_auto_preset,
> iso_sensitivity, iso_sensitivity_auto, exposure_metering_mode.
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

<snip most of the patch>

> +
> +/* Supported manual ISO values */
> +static const s64 iso_qmenu[] = {
> +	50, 100, 200, 400, 800,
> +};
> +
> +static int __ctrl_set_iso(struct fimc_is *is, int value)
> +{
> +	unsigned int idx, iso;
> +
> +	if (value == V4L2_ISO_SENSITIVITY_AUTO) {
> +		__is_set_isp_iso(is, ISP_ISO_COMMAND_AUTO, 0);
> +		return 0;
> +	}
> +	idx = is->isp.ctrls.iso->val;
> +	if (idx >= ARRAY_SIZE(iso_qmenu))
> +		return -EINVAL;
> +
> +	iso = iso_qmenu[idx];
> +	__is_set_isp_iso(is, ISP_ISO_COMMAND_MANUAL, iso);
> +	return 0;
> +}
> +
> +static int __ctrl_set_metering(struct fimc_is *is, unsigned int value)
> +{
> +	unsigned int val;
> +
> +	switch (value) {
> +	case V4L2_EXPOSURE_METERING_AVERAGE:
> +		val = ISP_METERING_COMMAND_AVERAGE;
> +		break;
> +	case V4L2_EXPOSURE_METERING_CENTER_WEIGHTED:
> +		val = ISP_METERING_COMMAND_CENTER;
> +		break;
> +	case V4L2_EXPOSURE_METERING_SPOT:
> +		val = ISP_METERING_COMMAND_SPOT;
> +		break;
> +	case V4L2_EXPOSURE_METERING_MATRIX:
> +		val = ISP_METERING_COMMAND_MATRIX;
> +		break;
> +	default:
> +		return -EINVAL;
> +	};
> +
> +	__is_set_isp_metering(is, IS_METERING_CONFIG_CMD, val);
> +	return 0;
> +}
> +
> +static int __ctrl_set_afc(struct fimc_is *is, int value)
> +{
> +	switch (value) {
> +	case V4L2_CID_POWER_LINE_FREQUENCY_DISABLED:
> +		__is_set_isp_afc(is, ISP_AFC_COMMAND_DISABLE, 0);
> +		break;
> +	case V4L2_CID_POWER_LINE_FREQUENCY_50HZ:
> +		__is_set_isp_afc(is, ISP_AFC_COMMAND_MANUAL, 50);
> +		break;
> +	case V4L2_CID_POWER_LINE_FREQUENCY_60HZ:
> +		__is_set_isp_afc(is, ISP_AFC_COMMAND_MANUAL, 60);
> +		break;
> +	case V4L2_CID_POWER_LINE_FREQUENCY_AUTO:
> +		__is_set_isp_afc(is, ISP_AFC_COMMAND_AUTO, 0);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +#if 0
> +static int __ctrl_set_flash_mode(struct fimc_is *is, int value)
> +{
> +	switch (value) {
> +	case IS_FLASH_MODE_OFF:
> +		__is_set_isp_flash(is, ISP_FLASH_COMMAND_DISABLE, 0);
> +		break;
> +	case IS_FLASH_MODE_AUTO:
> +		__is_set_isp_flash(is, ISP_FLASH_COMMAND_AUTO, 0);
> +		break;
> +	case IS_FLASH_MODE_AUTO_REDEYE:
> +		__is_set_isp_flash(is, ISP_FLASH_COMMAND_AUTO, 1);
> +		break;
> +	case IS_FLASH_MODE_ON:
> +		__is_set_isp_flash(is, ISP_FLASH_COMMAND_MANUALON, 0);
> +		break;
> +	case IS_FLASH_MODE_TORCH:
> +		__is_set_isp_flash(is, ISP_FLASH_COMMAND_TORCH, 0);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +static int __ctrl_set_image_effect(struct fimc_is *is, int value)
> +{
> +	/* FIXME: */
> +	__is_set_isp_effect(is, value);
> +	return 0;
> +}
> +
> +static int fimc_is_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct fimc_isp *isp = ctrl_to_fimc_isp(ctrl);
> +	struct fimc_is *is = fimc_isp_to_is(isp);
> +	bool set_param = true;
> +	int ret = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_CONTRAST:
> +		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_CONTRAST,
> +				    ctrl->val);
> +		break;
> +
> +	case V4L2_CID_SATURATION:
> +		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_SATURATION,
> +				    ctrl->val);
> +		break;
> +
> +	case V4L2_CID_SHARPNESS:
> +		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_SHARPNESS,
> +				    ctrl->val);
> +		break;
> +
> +	case V4L2_CID_EXPOSURE_ABSOLUTE:
> +		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_EXPOSURE,
> +				    ctrl->val);
> +		break;
> +
> +	case V4L2_CID_BRIGHTNESS:
> +		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_BRIGHTNESS,
> +				    ctrl->val);
> +		break;
> +
> +	case V4L2_CID_HUE:
> +		__is_set_isp_adjust(is, ISP_ADJUST_COMMAND_MANUAL_HUE,
> +				    ctrl->val);
> +		break;
> +
> +	case V4L2_CID_EXPOSURE_METERING:
> +		ret = __ctrl_set_metering(is, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
> +		ret = __ctrl_set_white_balance(is, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_3A_LOCK:
> +		ret = __ctrl_set_aewb_lock(is, ctrl);
> +		set_param = false;
> +		break;
> +
> +	case V4L2_CID_ISO_SENSITIVITY_AUTO:
> +		ret = __ctrl_set_iso(is, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_POWER_LINE_FREQUENCY:
> +		ret = __ctrl_set_afc(is, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_COLORFX:
> +		__ctrl_set_image_effect(is, ctrl->val);
> +		break;
> +
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	if (ret < 0) {
> +		v4l2_err(&isp->subdev, "%s() failed, ctrl: %s, val: %d\n",
> +			 __func__, ctrl->name, ctrl->val);
> +		return ret;
> +	}
> +
> +	if (set_param && test_bit(IS_ST_STREAM_ON, &is->state))
> +		return fimc_is_itf_s_param(is, true);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops fimc_isp_ctrl_ops = {
> +	.s_ctrl	= fimc_is_s_ctrl,
> +};
> +
> +int fimc_isp_subdev_create(struct fimc_isp *isp)
> +{
> +	const struct v4l2_ctrl_ops *ops = &fimc_isp_ctrl_ops;
> +	struct v4l2_ctrl_handler *handler = &isp->ctrls.handler;
> +	struct v4l2_subdev *sd = &isp->subdev;
> +	struct fimc_isp_ctrls *ctrls = &isp->ctrls;
> +	int ret;
> +
> +	mutex_init(&isp->subdev_lock);
> +
> +	v4l2_subdev_init(sd, &fimc_is_subdev_ops);
> +	sd->grp_id = GRP_ID_FIMC_IS;
> +	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	snprintf(sd->name, sizeof(sd->name), "FIMC-IS-ISP");
> +
> +	isp->subdev_pads[FIMC_IS_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
> +	isp->subdev_pads[FIMC_IS_SD_PAD_SRC_FIFO].flags = MEDIA_PAD_FL_SOURCE;
> +	isp->subdev_pads[FIMC_IS_SD_PAD_SRC_DMA].flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&sd->entity, FIMC_IS_SD_PADS_NUM,
> +				isp->subdev_pads, 0);
> +	if (ret)
> +		return ret;
> +
> +	v4l2_ctrl_handler_init(handler, 20);
> +
> +	ctrls->saturation = v4l2_ctrl_new_std(handler, ops, V4L2_CID_SATURATION,
> +						-2, 2, 1, 0);
> +	ctrls->brightness = v4l2_ctrl_new_std(handler, ops, V4L2_CID_BRIGHTNESS,
> +						-4, 4, 1, 0);
> +	ctrls->contrast = v4l2_ctrl_new_std(handler, ops, V4L2_CID_CONTRAST,
> +						-2, 2, 1, 0);
> +	ctrls->sharpness = v4l2_ctrl_new_std(handler, ops, V4L2_CID_SHARPNESS,
> +						-2, 2, 1, 0);
> +	ctrls->hue = v4l2_ctrl_new_std(handler, ops, V4L2_CID_HUE,
> +						-2, 2, 1, 0);
> +
> +	ctrls->auto_wb = v4l2_ctrl_new_std_menu(handler, ops,
> +					V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
> +					8, ~0x14e, V4L2_WHITE_BALANCE_AUTO);
> +
> +	ctrls->exposure = v4l2_ctrl_new_std(handler, ops,
> +					V4L2_CID_EXPOSURE_ABSOLUTE,
> +					-4, 4, 1, 0);
> +
> +	ctrls->exp_metering = v4l2_ctrl_new_std_menu(handler, ops,
> +					V4L2_CID_EXPOSURE_METERING, 3,
> +					~0xf, V4L2_EXPOSURE_METERING_AVERAGE);
> +
> +	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_POWER_LINE_FREQUENCY,
> +					V4L2_CID_POWER_LINE_FREQUENCY_AUTO, 0,
> +					V4L2_CID_POWER_LINE_FREQUENCY_AUTO);
> +	/* ISO sensitivity */
> +	ctrls->auto_iso = v4l2_ctrl_new_std_menu(handler, ops,
> +			V4L2_CID_ISO_SENSITIVITY_AUTO, 1, 0,
> +			V4L2_ISO_SENSITIVITY_AUTO);
> +
> +	ctrls->iso = v4l2_ctrl_new_int_menu(handler, ops,
> +			V4L2_CID_ISO_SENSITIVITY, ARRAY_SIZE(iso_qmenu) - 1,
> +			ARRAY_SIZE(iso_qmenu)/2 - 1, iso_qmenu);
> +
> +	ctrls->aewb_lock = v4l2_ctrl_new_std(handler, ops,
> +					V4L2_CID_3A_LOCK, 0, 0x3, 0, 0);
> +
> +	/* FIXME: Adjust the enabled controls mask according
> +	   to the ISP capabilities */
> +	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_COLORFX,
> +					V4L2_COLORFX_ANTIQUE,
> +					0, V4L2_COLORFX_NONE);
> +	if (handler->error) {
> +		media_entity_cleanup(&sd->entity);
> +		return handler->error;
> +	}
> +
> +	ctrls->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
> +				  V4L2_CTRL_FLAG_UPDATE;

Why would auto_iso be volatile? I would expect the iso to be volatile
(in which case the 'false' argument below would be 'true'). Also,
v4l2_ctrl_auto_cluster already sets the UPDATE flag.

> +	v4l2_ctrl_auto_cluster(2, &ctrls->auto_iso, 0, false);
> +
> +	sd->ctrl_handler = handler;
> +	sd->internal_ops = &fimc_is_subdev_internal_ops;
> +	sd->entity.ops = &fimc_is_subdev_media_ops;
> +	v4l2_set_subdevdata(sd, isp);
> +
> +	return 0;
> +}
> +
> +void fimc_isp_subdev_destroy(struct fimc_isp *isp)
> +{
> +	struct v4l2_subdev *sd = &isp->subdev;
> +
> +	v4l2_device_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	v4l2_ctrl_handler_free(&isp->ctrls.handler);
> +	v4l2_set_subdevdata(sd, NULL);
> +}
> diff --git a/drivers/media/platform/s5p-fimc/fimc-isp.h b/drivers/media/platform/s5p-fimc/fimc-isp.h
> new file mode 100644
> index 0000000..654039e
> --- /dev/null
> +++ b/drivers/media/platform/s5p-fimc/fimc-isp.h
> @@ -0,0 +1,205 @@
> +/*
> + * Samsung EXYNOS4x12 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + *
> + * Authors: Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *          Younghwan Joo <yhwan.joo@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef FIMC_ISP_H_
> +#define FIMC_ISP_H_
> +
> +#include <asm/sizes.h>
> +#include <linux/io.h>
> +#include <linux/irqreturn.h>
> +#include <linux/platform_device.h>
> +#include <linux/sched.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/media-entity.h>
> +#include <media/videobuf2-core.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-mediabus.h>
> +#include <media/s5p_fimc.h>
> +
> +#include "fimc-core.h"
> +
> +/* TODO: revisit these constraints */
> +#define FIMC_ISP_SINK_WIDTH_MIN		(16 + 8)
> +#define FIMC_ISP_SINK_HEIGHT_MIN	(12 + 8)
> +#define FIMC_ISP_SOURCE_WIDTH_MIN	8
> +#define FIMC_ISP_SOURC_HEIGHT_MIN	8
> +/* FIXME: below are random numbers... */
> +#define FIMC_ISP_SINK_WIDTH_MAX		(4000 - 16)
> +#define FIMC_ISP_SINK_HEIGHT_MAX	(4000 + 12)
> +#define FIMC_ISP_SOURCE_WIDTH_MAX	4000
> +#define FIMC_ISP_SOURC_HEIGHT_MAX	4000
> +
> +#define FIMC_ISP_NUM_FORMATS		3
> +#define FIMC_IS_REQ_BUFS_MIN		2
> +
> +#define FIMC_IS_SD_PAD_SINK		0
> +#define FIMC_IS_SD_PAD_SRC_FIFO		1
> +#define FIMC_IS_SD_PAD_SRC_DMA		2
> +#define FIMC_IS_SD_PADS_NUM		3
> +#define FIMC_IS_MAX_PLANES		1
> +
> +/**
> + * struct fimc_isp_frame - source/target frame properties
> + * @f_width: full pixel width
> + * @f_height: full pixel height
> + * @rect: crop/composition rectangle
> + */
> +struct fimc_isp_frame {
> +	u16 f_width;
> +	u16 f_height;
> +	struct v4l2_rect rect;
> +};
> +
> +/**
> + * struct fimc_isp_buffer - video buffer structure
> + * @vb: vb2 buffer
> + * @list: list head for the buffers queue
> + * @paddr: precalculated physical address
> + */
> +struct fimc_isp_buffer {
> +	struct vb2_buffer vb;
> +	struct list_head list;
> +	dma_addr_t paddr;
> +};
> +
> +struct fimc_isp_ctrls {
> +	struct v4l2_ctrl_handler handler;
> +	/* Internal mode selection */
> +	struct v4l2_ctrl *scenario;
> +	/* Frame rate */
> +	struct v4l2_ctrl *fps;
> +	/* Touch AF position */
> +	struct v4l2_ctrl *af_position_x;
> +	struct v4l2_ctrl *af_position_y;
> +	/* Auto white balance */
> +	struct v4l2_ctrl *auto_wb;
> +	/* ISO sensitivity */
> +	struct v4l2_ctrl *auto_iso;
> +	struct v4l2_ctrl *iso;

I suggest putting this in an anonymous struct:

	struct { /* Auto ISO control cluster */
		struct v4l2_ctrl *auto_iso;
		struct v4l2_ctrl *iso;
	};

That way you visually emphasize that these belong together and that you
shouldn't move them around.

> +
> +	struct v4l2_ctrl *contrast;
> +	struct v4l2_ctrl *saturation;
> +	struct v4l2_ctrl *sharpness;
> +	/* Auto/manual exposure */
> +	struct v4l2_ctrl *auto_exp;
> +	/* Manual exposure value */
> +	struct v4l2_ctrl *exposure;
> +	/* Adjust - brightness */
> +	struct v4l2_ctrl *brightness;
> +	/* Adjust - hue */
> +	struct v4l2_ctrl *hue;
> +	/* Exposure metering mode */
> +	struct v4l2_ctrl *exp_metering;
> +	/* AFC */
> +	struct v4l2_ctrl *afc;
> +	/* AE/AWB lock/unlock */
> +	struct v4l2_ctrl *aewb_lock;
> +	/* AF */
> +	struct v4l2_ctrl *focus_mode;
> +	/* AF status */
> +	struct v4l2_ctrl *af_status;
> +};
> +
> +/**
> + * struct fimc_isp - fimc isp structure
> + * @pdev: pointer to FIMC-LITE platform device
> + * @variant: variant information for this IP
> + * @v4l2_dev: pointer to top the level v4l2_device
> + * @vfd: video device node
> + * @fh: v4l2 file handle
> + * @alloc_ctx: videobuf2 memory allocator context
> + * @subdev: FIMC-LITE subdev
> + * @vd_pad: media (sink) pad for the capture video node
> + * @subdev_pads: the subdev media pads
> + * @ctrl_handler: v4l2 control handler
> + * @test_pattern: test pattern controls
> + * @index: FIMC-LITE platform device index
> + * @pipeline: video capture pipeline data structure
> + * @slock: spinlock protecting this data structure and the hw registers
> + * @video_lock: mutex serializing video device and the subdev operations
> + * @clock: FIMC-LITE gate clock
> + * @regs: memory mapped io registers
> + * @irq_queue: interrupt handler waitqueue
> + * @fmt: pointer to color format description structure
> + * @payload: image size in bytes (w x h x bpp)
> + * @inp_frame: camera input frame structure
> + * @out_frame: DMA output frame structure
> + * @out_path: output data path (DMA or FIFO)
> + * @source_subdev_grp_id: source subdev group id
> + * @cac_margin_x: horizontal CAC margin in pixels
> + * @cac_margin_y: vertical CAC margin in pixels
> + * @state: driver state flags
> + * @pending_buf_q: pending buffers queue head
> + * @active_buf_q: the queue head of buffers scheduled in hardware
> + * @capture_vb_queue: vb2 buffers queue for ISP capture video node
> + * @active_buf_count: number of video buffers scheduled in hardware
> + * @frame_count: the captured frames counter
> + * @reqbufs_count: the number of buffers requested with REQBUFS ioctl
> + * @ref_count: driver's private reference counter
> + */
> +struct fimc_isp {
> +	struct platform_device		*pdev;
> +	struct fimc_is_variant		*variant;
> +	struct v4l2_device		*v4l2_dev;
> +	struct video_device		vfd;
> +	struct v4l2_fh			fh;
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +	struct v4l2_subdev		subdev;
> +	struct media_pad		vd_pad;
> +	struct media_pad		subdev_pads[FIMC_IS_SD_PADS_NUM];
> +	struct v4l2_mbus_framefmt	subdev_fmt;
> +	struct v4l2_ctrl		*test_pattern;
> +	struct fimc_pipeline		pipeline;
> +	struct fimc_isp_ctrls		ctrls;
> +
> +	u32				index;
> +	struct mutex			video_lock;
> +	struct mutex			subdev_lock;
> +	spinlock_t			slock;
> +
> +	wait_queue_head_t		irq_queue;
> +
> +	const struct fimc_fmt		*video_capture_format;
> +	unsigned long			payload[FIMC_IS_MAX_PLANES];
> +	struct fimc_isp_frame		inp_frame;
> +	struct fimc_isp_frame		out_frame;
> +	enum fimc_datapath		out_path;
> +	unsigned int			source_subdev_grp_id;
> +
> +	unsigned int			cac_margin_x;
> +	unsigned int 			cac_margin_y;
> +
> +	unsigned long			state;
> +	struct list_head		pending_buf_q;
> +	struct list_head		active_buf_q;
> +	struct vb2_queue		capture_vb_queue;
> +	unsigned int			frame_count;
> +	unsigned int			reqbufs_count;
> +	int				ref_count;
> +};
> +
> +#define ctrl_to_fimc_isp(_ctrl) \
> +	container_of(ctrl->handler, struct fimc_isp, ctrls.handler)
> +
> +struct fimc_is;
> +
> +int fimc_isp_subdev_create(struct fimc_isp *isp);
> +void fimc_isp_subdev_destroy(struct fimc_isp *isp);
> +void fimc_isp_irq_handler(struct fimc_is *is);
> +int fimc_is_create_controls(struct fimc_isp *isp);
> +int fimc_is_delete_controls(struct fimc_isp *isp);
> +const struct fimc_fmt *fimc_isp_find_format(const u32 *pixelformat,
> +					const u32 *mbus_code, int index);
> +#endif /* FIMC_ISP_H_ */
> 

Otherwise this patch looks very clean and I really have no other comments.

Regards,

	Hans
