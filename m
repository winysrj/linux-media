Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3538 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1FOHCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 03:02:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 4/4 v9] MFC: Add MFC 5.1 V4L2 driver
Date: Wed, 15 Jun 2011 09:02:05 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com> <1308069416-24723-5-git-send-email-k.debski@samsung.com>
In-Reply-To: <1308069416-24723-5-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106150902.05493.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, June 14, 2011 18:36:56 Kamil Debski wrote:
> Multi Format Codec 5.1 is a hardware video coding acceleration
> module found in the S5PV210 and Exynos4 Samsung SoCs. It is
> capable of handling a range of video codecs and this driver
> provides a V4L2 interface for video decoding and encoding.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Jeongtae Park <jtp.park@samsung.com>

Just a quick one:

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> new file mode 100644
> index 0000000..a3d7378
> --- /dev/null
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> +static struct mfc_control controls[] = {
> +	{
> +		.id = V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY,
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.name = "H264 Display Delay",
> +		.minimum = 0,
> +		.maximum = 16383,
> +		.step = 1,
> +		.default_value = 0,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE,
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.name = "H264 Display Delay Enable",
> +		.minimum = 0,
> +		.maximum = 1,
> +		.step = 1,
> +		.default_value = 0,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER,
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.name = "Mpeg4 Loop Filter Enable",
> +		.minimum = 0,
> +		.maximum = 1,
> +		.step = 1,
> +		.default_value = 0,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE,
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.name = "Slice Interface Enable",
> +		.minimum = 0,
> +		.maximum = 1,
> +		.step = 1,
> +		.default_value = 0,
> +	},
> +	{
> +		.id = V4L2_CID_MIN_BUFFERS_FOR_CAPTURE,
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.name = "Minimum number of cap bufs",
> +		.minimum = 1,
> +		.maximum = 32,
> +		.step = 1,
> +		.default_value = 1,
> +		.is_volatile = 1,
> +	},
> +};
> +

...

> +	for (i = 0; i < NUM_CTRLS; i++) {
> +
> +		ctx->ctrls[i] = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +				&s5p_mfc_dec_ctrl_ops,
> +				controls[i].id, controls[i].minimum,
> +				controls[i].maximum, controls[i].step,
> +				controls[i].default_value);
> +		if (ctx->ctrl_handler.error) {
> +			mfc_err("Adding control (%d) failed\n", i);
> +			return ctx->ctrl_handler.error;
> +		}
> +		if (controls[i].is_volatile && ctx->ctrls[i]) {
> +			ctx->ctrls[i]->is_volatile = 1;
> +			ctx->ctrls[i]->flags = V4L2_CTRL_FLAG_READ_ONLY;

This flag for V4L2_CID_MIN_BUFFERS_FOR_CAPTURE should have been set in
v4l2_ctrl_fill().

Regards,

	Hans

> +		}
> +	}
> +
> +	return 0;
> +}

Why not just call v4l2_ctrl_new_std? A good non-trivial example of how I would
do things is in media/video/cx2341x.c, cx2341x_handler_init(). Although for the
new_custom calls I would probably use an array of static const struct v4l2_ctrl_config
these days.

Regards,

	Hans
