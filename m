Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44461 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbbLNMuP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 07:50:15 -0500
Subject: Re: [PATCH v2 6/8] [Media] vcodec: mediatek: Add Mediatek V4L2 Video
 Encoder Driver
To: Tiffany Lin <tiffany.lin@mediatek.com>, daniel.thompson@linaro.org,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>
References: <1449827743-22895-1-git-send-email-tiffany.lin@mediatek.com>
 <1449827743-22895-7-git-send-email-tiffany.lin@mediatek.com>
Cc: Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org, PoChun.Lin@mediatek.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <566EBAFC.3010408@xs4all.nl>
Date: Mon, 14 Dec 2015 13:50:04 +0100
MIME-Version: 1.0
In-Reply-To: <1449827743-22895-7-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

My apologies for the long delay, but I finally have time to do a review of this
code.

On 12/11/2015 10:55 AM, Tiffany Lin wrote:
> From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> 
> Add v4l2 layer encoder driver for MT8173
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  drivers/media/platform/Kconfig                     |   11 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/mtk-vcodec/Makefile         |    8 +
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  412 +++++
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1670 ++++++++++++++++++++
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h |   45 +
>  .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  469 ++++++
>  .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  122 ++
>  .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |  102 ++
>  .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |   29 +
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h  |   26 +
>  .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |  106 ++
>  .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   85 +
>  drivers/media/platform/mtk-vcodec/venc_drv_base.h  |   62 +
>  drivers/media/platform/mtk-vcodec/venc_drv_if.c    |  102 ++
>  drivers/media/platform/mtk-vcodec/venc_drv_if.h    |  174 ++
>  drivers/media/platform/mtk-vcodec/venc_ipi_msg.h   |  212 +++
>  17 files changed, 3637 insertions(+)
>  create mode 100644 drivers/media/platform/mtk-vcodec/Makefile
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_pm.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
>  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_base.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.c
>  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.h
>  create mode 100644 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
> 

<snip>

> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> new file mode 100644
> index 0000000..d59064d
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> @@ -0,0 +1,1670 @@
> +/*
> +* Copyright (c) 2015 MediaTek Inc.
> +* Author: PC Chen <pc.chen@mediatek.com>
> +*         Tiffany Lin <tiffany.lin@mediatek.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*/
> +
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "mtk_vcodec_drv.h"
> +#include "mtk_vcodec_enc.h"
> +#include "mtk_vcodec_intr.h"
> +#include "mtk_vcodec_util.h"
> +#include "venc_drv_if.h"
> +
> +static void mtk_venc_worker(struct work_struct *work);
> +
> +static struct mtk_video_fmt mtk_video_formats[] = {
> +	{
> +		.name		= "4:2:0 3 Planes Y/Cb/Cr",

Don't add the name. The v4l2 core will set that for you. This ensures that the name is
always the same for the format, instead of being driver dependent.

> +		.fourcc		= V4L2_PIX_FMT_YUV420,
> +		.type		= MTK_FMT_FRAME,
> +		.num_planes	= 3,
> +	},
> +	{
> +		.name		= "4:2:0 3 Planes Y/Cr/Cb",
> +		.fourcc		= V4L2_PIX_FMT_YVU420,
> +		.type		= MTK_FMT_FRAME,
> +		.num_planes	= 3,
> +	},
> +	{
> +		.name		= "4:2:0 2 Planes Y/CbCr",
> +		.fourcc		= V4L2_PIX_FMT_NV12,
> +		.type		= MTK_FMT_FRAME,
> +		.num_planes	= 2,
> +	},
> +	{
> +		.name		= "4:2:0 2 Planes Y/CrCb",
> +		.fourcc		= V4L2_PIX_FMT_NV21,
> +		.type		= MTK_FMT_FRAME,
> +		.num_planes	= 2,
> +	},
> +	{
> +		.name		= "4:2:0 3 none contiguous Planes Y/Cb/Cr",
> +		.fourcc		= V4L2_PIX_FMT_YUV420M,
> +		.type		= MTK_FMT_FRAME,
> +		.num_planes	= 3,
> +	},
> +	{
> +		.name		= "4:2:0 3 none contiguous Planes Y/Cr/Cb",
> +		.fourcc		= V4L2_PIX_FMT_YVU420M,
> +		.type		= MTK_FMT_FRAME,
> +		.num_planes	= 3,
> +	},
> +	{
> +		.name		= "4:2:0 2 none contiguous Planes Y/CbCr",
> +		.fourcc 	= V4L2_PIX_FMT_NV12M,
> +		.type		= MTK_FMT_FRAME,
> +		.num_planes	= 2,
> +	},
> +	{
> +		.name		= "4:2:0 2 none contiguous Planes Y/CrCb",
> +		.fourcc		= V4L2_PIX_FMT_NV21M,
> +		.type		= MTK_FMT_FRAME,
> +		.num_planes	= 2,
> +	},
> +	{
> +		.name		= "H264 Encoded Stream",
> +		.fourcc		= V4L2_PIX_FMT_H264,
> +		.type		= MTK_FMT_ENC,
> +		.num_planes	= 1,
> +	},
> +	{
> +		.name		= "VP8 Encoded Stream",
> +		.fourcc		= V4L2_PIX_FMT_VP8,
> +		.type		= MTK_FMT_ENC,
> +		.num_planes	= 1,
> +	},
> +};
> +
> +#define NUM_FORMATS ARRAY_SIZE(mtk_video_formats)
> +
> +static struct mtk_vcodec_ctrl controls[] = {
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_BITRATE,
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.minimum = 1,
> +		.maximum = (1 << 30) - 1,
> +		.step = 1,
> +		.default_value = 4000000,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_B_FRAMES,
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.minimum = 0,
> +		.maximum = 2,
> +		.step = 1,
> +		.default_value = 0,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE,
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.minimum = 0,
> +		.maximum = 1,
> +		.step = 1,
> +		.default_value = 1,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_H264_MAX_QP,
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.minimum = 0,
> +		.maximum = 51,
> +		.step = 1,
> +		.default_value = 51,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_HEADER_MODE,
> +		.type = V4L2_CTRL_TYPE_MENU,
> +		.minimum = V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE,
> +		.maximum = V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
> +		.default_value = V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE,
> +		.menu_skip_mask = 0,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE,
> +		.type = V4L2_CTRL_TYPE_BOOLEAN,
> +		.minimum = 0,
> +		.maximum = 1,
> +		.step = 1,
> +		.default_value = 0,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> +		.type = V4L2_CTRL_TYPE_MENU,
> +		.minimum = V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE,
> +		.maximum = V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
> +		.default_value = V4L2_MPEG_VIDEO_H264_PROFILE_MAIN,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_H264_LEVEL,
> +		.type = V4L2_CTRL_TYPE_MENU,
> +		.minimum = V4L2_MPEG_VIDEO_H264_LEVEL_1_0,
> +		.maximum = V4L2_MPEG_VIDEO_H264_LEVEL_4_2,
> +		.default_value = V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_H264_I_PERIOD,
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.minimum = 0,
> +		.maximum = (1 << 16) - 1,
> +		.step = 1,
> +		.default_value = 30,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_VIDEO_GOP_SIZE,
> +		.type = V4L2_CTRL_TYPE_INTEGER,
> +		.minimum = 0,
> +		.maximum = (1 << 16) - 1,
> +		.step = 1,
> +		.default_value = 30,
> +	},

Instead of using this array, I suggest calling v4l2_ctrl_new_std/v4l2_ctrl_new_std_menu
directly. That will fill in fields like type and flags for you.

> +	{
> +		.id = V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE,
> +		.type = V4L2_CTRL_TYPE_MENU,
> +		.minimum = V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED,
> +		.maximum = V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_NOT_CODED,
> +		.default_value =
> +			V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED,
> +		.menu_skip_mask = 0,
> +	},
> +	{
> +		.id = V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE,
> +		.type = V4L2_CTRL_TYPE_MENU,
> +		.minimum = V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED,
> +		.maximum = V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT,
> +		.default_value = V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED,
> +		.menu_skip_mask = 0,
> +	},

As the name says, these are specific for the Exynos MFC 5.1. For the last one the max
value of BUF_LIMIT makes no sense without the corresponding H264 CPB_SIZE controls.

I wonder if these shouldn't be MediaTek specific controls instead of reusing MFC 5.1
controls.

> +};
> +
> +#define NUM_CTRLS ARRAY_SIZE(controls)
> +
> +static const struct mtk_codec_framesizes mtk_venc_framesizes[] = {
> +	{
> +		.fourcc	= V4L2_PIX_FMT_H264,
> +		.stepwise = {  160, 1920, 16, 128, 1088, 16 },
> +	},
> +	{
> +		.fourcc = V4L2_PIX_FMT_VP8,
> +		.stepwise = {  160, 1920, 16, 128, 1088, 16 },
> +	},
> +};
> +
> +#define NUM_SUPPORTED_FRAMESIZE ARRAY_SIZE(mtk_venc_framesizes)
> +
> +static int vidioc_venc_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mtk_vcodec_ctx *ctx = ctrl_to_ctx(ctrl);
> +	struct mtk_vcodec_dev *dev = ctx->dev;
> +	struct mtk_enc_params *p = &ctx->enc_params;
> +	int ret = 0;
> +
> +	mtk_v4l2_debug(1, "[%d] id = %d/%d, val = %d", ctrl->id,
> +			ctx->idx, ctrl->id - V4L2_CID_MPEG_BASE, ctrl->val);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MPEG_VIDEO_BITRATE:
> +
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_BITRATE val = %d",
> +			ctrl->val);
> +		p->bitrate = ctrl->val;
> +		ctx->param_change |= MTK_ENCODE_PARAM_BITRATE;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_B_FRAMES val = %d",
> +			ctrl->val);
> +		p->num_b_frame = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE val = %d",
> +			ctrl->val);
> +		p->rc_frame = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_H264_MAX_QP val = %d",
> +			ctrl->val);
> +		p->h264_max_qp = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_HEADER_MODE val = %d",
> +			ctrl->val);
> +		p->seq_hdr_mode = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE val = %d",
> +			ctrl->val);
> +		p->rc_mb = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_H264_PROFILE val = %d",
> +			ctrl->val);
> +		p->h264_profile = ctrl->val;
> +		break;
> +
> +	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_H264_LEVEL val = %d",
> +			ctrl->val);
> +		p->h264_level = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_H264_I_PERIOD val = %d",
> +			ctrl->val);
> +	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_VIDEO_GOP_SIZE val = %d",
> +			ctrl->val);
> +		p->gop_size = ctrl->val;
> +		ctx->param_change |= MTK_ENCODE_PARAM_INTRA_PERIOD;
> +		break;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE val = %d",
> +			ctrl->val);
> +		if (ctrl->val ==
> +			V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_NOT_CODED) {
> +			v4l2_err(&dev->v4l2_dev, "unsupported frame type %x\n",
> +				 ctrl->val);
> +			ret = -EINVAL;

Don't do this. Just set the maximum value for this control to V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_I_FRAME.
That way you don't have to check here.

> +			break;
> +		}
> +		if (ctrl->val == V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_I_FRAME)
> +			p->force_intra = 1;
> +		else if (ctrl->val ==
> +			V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED)
> +			p->force_intra = 0;
> +		/* always allow user to insert I frame */
> +		ctrl->val = V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED;
> +		ctx->param_change |= MTK_ENCODE_PARAM_FRAME_TYPE;
> +		break;
> +
> +	case V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE:
> +		mtk_v4l2_debug(1, "V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE val = %d",
> +			ctrl->val);
> +		if (ctrl->val == V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED)
> +			p->skip_frame = 0;
> +		else
> +			p->skip_frame = 1;

This is weird: SKIP_MODE can have three values: DISABLED, LEVEL_LIMIT or BUF_LIMIT.
I think you only support DISABLED and LEVEL_LIMIT. Again, set the maximum value for
this control to LEVEL_LIMIT.

I really think that these two controls should be new MediaTek specific controls.
And probably boolean controls too, since they just toggle a feature instead of
selecting from multiple values (unless that is a future planned extension).

> +		/* always allow user to skip frame */
> +		ctrl->val = V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED;
> +		ctx->param_change |= MTK_ENCODE_PARAM_SKIP_FRAME;
> +		break;
> +
> +	default:
> +		mtk_v4l2_err("Invalid control, id=%d, val=%d\n",
> +				ctrl->id, ctrl->val);

No need to print anything. This really can't happen, but I generally just return -EINVAL.

> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops mtk_vcodec_enc_ctrl_ops = {
> +	.s_ctrl = vidioc_venc_s_ctrl,
> +};
> +
> +static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
> +			   bool out)
> +{
> +	struct mtk_video_fmt *fmt;
> +	int i, j = 0;
> +
> +	for (i = 0; i < NUM_FORMATS; ++i) {
> +		if (out && mtk_video_formats[i].type != MTK_FMT_FRAME)
> +			continue;
> +		else if (!out && mtk_video_formats[i].type != MTK_FMT_ENC)
> +			continue;
> +
> +		if (j == f->index) {
> +			fmt = &mtk_video_formats[i];
> +			strlcpy(f->description, fmt->name,
> +				sizeof(f->description));

Don't fill the description field, the core does that now for you.

> +			f->pixelformat = fmt->fourcc;
> +			mtk_v4l2_debug(1, "f->index=%d i=%d fmt->name=%s",
> +					 f->index, i, fmt->name);
> +			return 0;
> +		}
> +		++j;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int vidioc_enum_framesizes(struct file *file, void *fh,
> +				  struct v4l2_frmsizeenum *fsize)
> +{
> +	int i = 0;
> +
> +	for (i = 0; i < NUM_SUPPORTED_FRAMESIZE; ++i) {
> +		if (fsize->pixel_format != mtk_venc_framesizes[i].fourcc)
> +			continue;
> +
> +		if (!fsize->index) {
> +			fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> +			fsize->stepwise = mtk_venc_framesizes[i].stepwise;
> +			mtk_v4l2_debug(1, "%d %d %d %d %d %d",
> +					 fsize->stepwise.min_width,
> +					 fsize->stepwise.max_width,
> +					 fsize->stepwise.step_width,
> +					 fsize->stepwise.min_height,
> +					 fsize->stepwise.max_height,
> +					 fsize->stepwise.step_height);

No need for a debug message here. You can debug ioctls by doing:

echo X >/sys/class/video4linux/video0/dev_debug

If X == 2, then you'll see all arguments printed as well. See also
Documentation/video4linux/v4l2-framework.txt, section "video device debugging".

In other words, you can probably drop a lot of the debug messages from the
driver.

> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int vidioc_enum_fmt_vid_cap_mplane(struct file *file, void *pirv,
> +					  struct v4l2_fmtdesc *f)
> +{
> +	return vidioc_enum_fmt(file, f, false);
> +}
> +
> +static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
> +					  struct v4l2_fmtdesc *f)
> +{
> +	return vidioc_enum_fmt(file, f, true);
> +}
> +
> +static int vidioc_venc_streamon(struct file *file, void *priv,
> +				enum v4l2_buf_type type)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> +}

I recommend that you use the v4l2-mem2mem.h v4l2_m2m_ioctl_* helper functions
directly for this and the following wrappers.

> +
> +static int vidioc_venc_streamoff(struct file *file, void *priv,
> +				 enum v4l2_buf_type type)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> +}
> +
> +static int vidioc_venc_reqbufs(struct file *file, void *priv,
> +			       struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	mtk_v4l2_debug(1, "[%d]-> type=%d count=%d",
> +			 ctx->idx, reqbufs->type, reqbufs->count);
> +
> +	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> +}
> +
> +static int vidioc_venc_querybuf(struct file *file, void *priv,
> +				struct v4l2_buffer *buf)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int vidioc_venc_qbuf(struct file *file, void *priv,
> +			    struct v4l2_buffer *buf)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	int ret;
> +#if MTK_V4L2_BENCHMARK
> +	struct timeval begin, end;
> +
> +	do_gettimeofday(&begin);

Don't use do_gettimeofday! Use ktime_get or something like that. You want
monotonic time, not wallclock time.

Even better is to use tracepoints. Actually, I believe (d)qbuf already have
tracepoints in vb2.

I think this benchmark code should be removed unless there is something here
can cannot be done in another way.

> +#endif
> +
> +	ret = v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> +
> +#if MTK_V4L2_BENCHMARK
> +	do_gettimeofday(&end);
> +
> +	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		ctx->total_qbuf_cap_cnt++;
> +		ctx->total_qbuf_cap_time +=
> +			((end.tv_sec - begin.tv_sec) * 1000000 +
> +				end.tv_usec - begin.tv_usec);
> +	}
> +
> +	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		ctx->total_qbuf_out_cnt++;
> +		ctx->total_qbuf_out_time +=
> +			((end.tv_sec - begin.tv_sec) * 1000000 +
> +				end.tv_usec - begin.tv_usec);
> +	}
> +
> +#endif
> +
> +	return ret;
> +}
> +
> +static int vidioc_venc_dqbuf(struct file *file, void *priv,
> +			     struct v4l2_buffer *buf)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	int ret;
> +#if MTK_V4L2_BENCHMARK
> +	struct timeval begin, end;
> +
> +	do_gettimeofday(&begin);
> +#endif
> +
> +	ret = v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> +#if MTK_V4L2_BENCHMARK
> +
> +	do_gettimeofday(&end);
> +	if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		ctx->total_dqbuf_cap_cnt++;
> +		ctx->total_dqbuf_cap_time +=
> +			((end.tv_sec - begin.tv_sec) * 1000000 +
> +				end.tv_usec - begin.tv_usec);
> +	}
> +
> +	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		ctx->total_dqbuf_out_cnt++;
> +		ctx->total_dqbuf_out_time +=
> +			((end.tv_sec - begin.tv_sec) * 1000000 +
> +				end.tv_usec - begin.tv_usec);
> +	}
> +
> +#endif
> +	return ret;
> +}
> +static int vidioc_venc_expbuf(struct file *file, void *priv,
> +			      struct v4l2_exportbuffer *eb)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	int ret;
> +#if MTK_V4L2_BENCHMARK
> +	struct timeval begin, end;
> +
> +	do_gettimeofday(&begin);
> +#endif
> +
> +	ret = v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
> +
> +#if MTK_V4L2_BENCHMARK
> +	do_gettimeofday(&end);
> +	ctx->total_expbuf_time +=
> +		((end.tv_sec - begin.tv_sec) * 1000000 +
> +			end.tv_usec - begin.tv_usec);
> +#endif

Why would you want to benchmark this function? Just curious, as I see no reason for it.

> +	return ret;
> +}
> +
> +static int vidioc_venc_querycap(struct file *file, void *priv,
> +				struct v4l2_capability *cap)
> +{
> +	strncpy(cap->driver, MTK_VCODEC_ENC_NAME, sizeof(cap->driver) - 1);

Use strlcpy.

> +	cap->bus_info[0] = 0;

Always fill this in. For platform devices this is a fixed string that starts with
"platform:" and some meaningful name.

The card field isn't filled in either.

> +	cap->version = KERNEL_VERSION(1, 0, 0);

Don't set this in the driver. The v4l2 core will set this for you.

> +	/*
> +	 * This is only a mem-to-mem video device. The capture and output
> +	 * device capability flags are left only for backward compatibility
> +	 * and are scheduled for removal.
> +	 */
> +	cap->capabilities = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING |
> +			    V4L2_CAP_VIDEO_CAPTURE_MPLANE |
> +			    V4L2_CAP_VIDEO_OUTPUT_MPLANE;

Don't set V4L2_CAP_VIDEO_CAPTURE/OUTPUT_MPLANE. M2M_MPLANE is enough.

You also need to fill in cap->device_caps. For this driver it should be easy:

cap->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

You should run the v4l2-compliance utility. It probably isn't able to correctly
stream for a codec driver like this (known limitation), but it will certainly
find errors like this.

> +
> +	return 0;
> +}
> +
> +static int vidioc_venc_subscribe_event(struct v4l2_fh *fh,
> +		       const struct v4l2_event_subscription *sub)
> +{
> +	return v4l2_event_subscribe(fh, sub, 0, NULL);

Huh? You probably just want to use v4l2_ctrl_subscribe_event() instead of this
wrapper.

> +}
> +
> +static int vidioc_venc_s_parm(struct file *file, void *priv,
> +			      struct v4l2_streamparm *a)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		ctx->enc_params.framerate_num =
> +			a->parm.output.timeperframe.denominator;
> +		ctx->enc_params.framerate_denom =
> +			a->parm.output.timeperframe.numerator;
> +		ctx->param_change |= MTK_ENCODE_PARAM_FRAMERATE;
> +
> +		mtk_v4l2_debug(1, "framerate = %d/%d",
> +				 ctx->enc_params.framerate_num,
> +				 ctx->enc_params.framerate_denom);
> +	} else {
> +		mtk_v4l2_err("Non support param type %d",
> +			 a->type);

Don't spam the log. Just return the error.

> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static struct mtk_q_data *mtk_venc_get_q_data(struct mtk_vcodec_ctx *ctx,
> +					      enum v4l2_buf_type type)
> +{
> +	if (V4L2_TYPE_IS_OUTPUT(type))
> +		return &ctx->q_data[MTK_Q_DATA_SRC];
> +	else

No 'else' needed here.

> +		return &ctx->q_data[MTK_Q_DATA_DST];
> +}
> +
> +static struct mtk_video_fmt *mtk_venc_find_format(struct v4l2_format *f)
> +{
> +	struct mtk_video_fmt *fmt;
> +	unsigned int k;
> +
> +	for (k = 0; k < NUM_FORMATS; k++) {
> +		fmt = &mtk_video_formats[k];
> +		if (fmt->fourcc == f->fmt.pix.pixelformat)
> +			return fmt;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct mtk_video_fmt *fmt;
> +	char str[10];
> +	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> +
> +	mtk_vcodec_fmt2str(f->fmt.pix_mp.pixelformat, str);
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		fmt = mtk_venc_find_format(f);
> +		if (!fmt) {
> +			mtk_v4l2_err("failed to try output format %s\n", str);
> +			return -EINVAL;
> +		}
> +		if (pix_fmt_mp->plane_fmt[0].sizeimage == 0) {
> +			mtk_v4l2_err("must be set encoding output size %s\n",
> +				       str);
> +			return -EINVAL;
> +		}
> +
> +		pix_fmt_mp->plane_fmt[0].bytesperline =
> +			pix_fmt_mp->plane_fmt[0].sizeimage;

What's happening here? For compressed formats bytesperline should be set to 0 (it
makes no sense otherwise).

The sizeimage field should be set by the driver to the maximum buffer size that can
be returned by the hardware for the current codec settings.

try_fmt should also fill in all the other fields (colorspace, field, num_planes).
Again, use v4l2-compliance to check things like that. Also take a look at the virtual
vim2m.c driver: that's a good example on how to handle colorspace and field.
The problem is that the application provides the colorspace information on the VIDEO_OUTPUT
side, and that's copied to the VIDEO_CAPTURE side when streaming.

> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		fmt = mtk_venc_find_format(f);
> +		if (!fmt) {
> +			mtk_v4l2_err("failed to try output format %s\n", str);
> +			return -EINVAL;
> +		}
> +
> +		if (fmt->num_planes != pix_fmt_mp->num_planes) {
> +			mtk_v4l2_err("failed to try output format %d %d %s\n",
> +				       fmt->num_planes, pix_fmt_mp->num_planes,
> +				       str);
> +			return -EINVAL;
> +		}

No, just set pix_fmt_mp->num_planes to fmt->num_planes. try_fmt can only return
an error if the requested pixelformat isn't found, and it has the choice to
pick a default pixelformat in that case as well. Sadly, whether a default should
be picked or an error should be returned is undefined in the spec (both approaches
are used in practice).

> +
> +		v4l_bound_align_image(&pix_fmt_mp->width, 8, 1920, 1,
> +				      &pix_fmt_mp->height, 4, 1080, 1, 0);
> +	} else {
> +		pr_err("invalid buf type %d\n", f->type);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static void mtk_vcodec_enc_calc_src_size(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct mtk_video_fmt *fmt = ctx->q_data[MTK_Q_DATA_SRC].fmt;
> +	struct mtk_q_data *q_data = &ctx->q_data[MTK_Q_DATA_SRC];
> +
> +	ctx->q_data[MTK_Q_DATA_SRC].sizeimage[0] =
> +		((q_data->width + 15) / 16) *
> +		((q_data->height + 15) / 16) * 256;
> +	ctx->q_data[MTK_Q_DATA_SRC].bytesperline[0] = ALIGN(q_data->width, 16);
> +
> +	if (fmt->num_planes == 2) {
> +		ctx->q_data[MTK_Q_DATA_SRC].sizeimage[1] =
> +			((q_data->width + 15) / 16) *
> +			((q_data->height + 15) / 16) * 128;
> +		ctx->q_data[MTK_Q_DATA_SRC].sizeimage[2] = 0;
> +		ctx->q_data[MTK_Q_DATA_SRC].bytesperline[1] =
> +			ALIGN(q_data->width, 16);
> +		ctx->q_data[MTK_Q_DATA_SRC].bytesperline[2] = 0;
> +	} else {
> +		ctx->q_data[MTK_Q_DATA_SRC].sizeimage[1] =
> +			((q_data->width + 15) / 16) *
> +			((q_data->height + 15) / 16) * 64;
> +		ctx->q_data[MTK_Q_DATA_SRC].sizeimage[2] =
> +			((q_data->width + 15) / 16) *
> +			((q_data->height + 15) / 16) * 64;
> +		ctx->q_data[MTK_Q_DATA_SRC].bytesperline[1] =
> +			ALIGN(q_data->width, 16) / 2;
> +		ctx->q_data[MTK_Q_DATA_SRC].bytesperline[2] =
> +			ALIGN(q_data->width, 16) / 2;
> +	}
> +}
> +
> +static int vidioc_venc_s_fmt(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> +	struct vb2_queue *vq;
> +	struct mtk_q_data *q_data;
> +	int i, ret;
> +
> +	ret = vidioc_try_fmt(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq) {
> +		v4l2_err(&dev->v4l2_dev, "fail to get vq\n");
> +		return -EINVAL;
> +	}
> +
> +	if (vb2_is_busy(vq)) {
> +		v4l2_err(&dev->v4l2_dev, "queue busy\n");
> +		return -EBUSY;
> +	}
> +
> +	q_data = mtk_venc_get_q_data(ctx, f->type);
> +	if (!q_data) {
> +		v4l2_err(&dev->v4l2_dev, "fail to get q data\n");
> +		return -EINVAL;
> +	}
> +
> +	q_data->fmt		= mtk_venc_find_format(f);
> +	if (!q_data->fmt) {
> +		v4l2_err(&dev->v4l2_dev, "q data null format\n");
> +		return -EINVAL;
> +	}
> +
> +	q_data->width		= f->fmt.pix_mp.width;
> +	q_data->height		= f->fmt.pix_mp.height;
> +	q_data->colorspace	= f->fmt.pix_mp.colorspace;
> +	q_data->field		= f->fmt.pix_mp.field;
> +
> +	for (i = 0; i < f->fmt.pix_mp.num_planes; i++) {
> +		struct v4l2_plane_pix_format	*plane_fmt;
> +
> +		plane_fmt = &f->fmt.pix_mp.plane_fmt[i];
> +		q_data->bytesperline[i]	= plane_fmt->bytesperline;
> +		q_data->sizeimage[i]	= plane_fmt->sizeimage;
> +	}
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		q_data->width		= f->fmt.pix_mp.width;
> +		q_data->height		= f->fmt.pix_mp.height;
> +
> +		mtk_vcodec_enc_calc_src_size(ctx);
> +		pix_fmt_mp->plane_fmt[0].sizeimage = q_data->sizeimage[0];
> +		pix_fmt_mp->plane_fmt[0].bytesperline =
> +			ctx->q_data[MTK_Q_DATA_SRC].bytesperline[0];
> +		pix_fmt_mp->plane_fmt[1].sizeimage = q_data->sizeimage[1];
> +		pix_fmt_mp->plane_fmt[1].bytesperline =
> +			ctx->q_data[MTK_Q_DATA_SRC].bytesperline[1];
> +		pix_fmt_mp->plane_fmt[2].sizeimage = q_data->sizeimage[2];
> +		pix_fmt_mp->plane_fmt[2].bytesperline =
> +			ctx->q_data[MTK_Q_DATA_SRC].bytesperline[2];
> +	}
> +
> +	mtk_v4l2_debug(1,
> +			 "[%d]: t=%d wxh=%dx%d fmt=%c%c%c%c sz=0x%x-%x-%x",
> +			 ctx->idx,
> +			 f->type,
> +			 q_data->width, q_data->height,
> +			 (f->fmt.pix_mp.pixelformat & 0xff),
> +			 (f->fmt.pix_mp.pixelformat >>  8) & 0xff,
> +			 (f->fmt.pix_mp.pixelformat >> 16) & 0xff,
> +			 (f->fmt.pix_mp.pixelformat >> 24) & 0xff,
> +			 q_data->sizeimage[0],
> +			 q_data->sizeimage[1],
> +			 q_data->sizeimage[2]);
> +
> +	return 0;
> +}
> +
> +static int vidioc_venc_g_fmt(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct vb2_queue *vq;
> +	struct mtk_q_data *q_data;
> +	int i;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = mtk_venc_get_q_data(ctx, f->type);
> +
> +	pix->width = q_data->width;
> +	pix->height = q_data->height;
> +	pix->pixelformat = q_data->fmt->fourcc;
> +	pix->field = q_data->field;
> +	pix->colorspace = q_data->colorspace;
> +	pix->num_planes = q_data->fmt->num_planes;
> +
> +	for (i = 0; i < pix->num_planes; i++) {
> +		pix->plane_fmt[i].bytesperline = q_data->bytesperline[i];
> +		pix->plane_fmt[i].sizeimage = q_data->sizeimage[i];
> +	}
> +
> +	mtk_v4l2_debug(1,
> +			 "[%d]<- type=%d wxh=%dx%d fmt=%c%c%c%c sz[0]=0x%x sz[1]=0x%x",
> +			 ctx->idx, f->type,
> +			 pix->width, pix->height,
> +			 (pix->pixelformat & 0xff),
> +			 (pix->pixelformat >>  8) & 0xff,
> +			 (pix->pixelformat >> 16) & 0xff,
> +			 (pix->pixelformat >> 24) & 0xff,
> +			 pix->plane_fmt[0].sizeimage,
> +			 pix->plane_fmt[1].sizeimage);
> +
> +	return 0;
> +}
> +
> +static int vidioc_venc_g_ctrl(struct file *file, void *fh,
> +			      struct v4l2_control *ctrl)
> +{
> +	int ret = 0;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
> +	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:
> +		ctrl->value = 1;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +	return ret;
> +}

This shouldn't be needed. These are read-only controls which return a single fixed
value, so other than declaring them you don't need to do anything else.

> +
> +static int vidioc_venc_s_crop(struct file *file, void *fh,
> +			      const struct v4l2_crop *a)

Don't use crop. It's deprecated. Use g/s_selection instead (and the core will provide
g/s_crop support for you on top of g/s_selection).

> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(fh);
> +	struct mtk_q_data *q_data;
> +
> +	if (a->c.left || a->c.top)
> +		return -EINVAL;
> +
> +	q_data = mtk_venc_get_q_data(ctx, a->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int vidioc_venc_g_crop(struct file *file, void *fh,
> +					struct v4l2_crop *a)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(fh);
> +	struct mtk_q_data *q_data;
> +
> +	if (a->c.left || a->c.top)
> +		return -EINVAL;
> +
> +	q_data = mtk_venc_get_q_data(ctx, a->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	a->c.width = q_data->width;
> +	a->c.height = q_data->height;
> +
> +	return 0;
> +}
> +
> +
> +const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
> +	.vidioc_streamon		= vidioc_venc_streamon,
> +	.vidioc_streamoff		= vidioc_venc_streamoff,
> +
> +	.vidioc_reqbufs			= vidioc_venc_reqbufs,
> +	.vidioc_querybuf		= vidioc_venc_querybuf,
> +	.vidioc_qbuf			= vidioc_venc_qbuf,
> +	.vidioc_expbuf			= vidioc_venc_expbuf,
> +	.vidioc_dqbuf			= vidioc_venc_dqbuf,
> +
> +	.vidioc_querycap		= vidioc_venc_querycap,
> +	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
> +	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
> +	.vidioc_enum_framesizes = vidioc_enum_framesizes,
> +
> +	.vidioc_subscribe_event		= vidioc_venc_subscribe_event,
> +
> +	.vidioc_s_parm			= vidioc_venc_s_parm,
> +
> +	.vidioc_s_fmt_vid_cap_mplane	= vidioc_venc_s_fmt,
> +	.vidioc_s_fmt_vid_out_mplane	= vidioc_venc_s_fmt,
> +
> +	.vidioc_g_fmt_vid_cap_mplane	= vidioc_venc_g_fmt,
> +	.vidioc_g_fmt_vid_out_mplane	= vidioc_venc_g_fmt,
> +
> +	.vidioc_g_ctrl			= vidioc_venc_g_ctrl,

Definitely not allowed here :-) Just use the control framework. You can't
mix-and-match.

> +
> +	.vidioc_s_crop			= vidioc_venc_s_crop,
> +	.vidioc_g_crop			= vidioc_venc_g_crop,
> +
> +};
> +
> +static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
> +				   const void *parg,
> +				   unsigned int *nbuffers,
> +				   unsigned int *nplanes,
> +				   unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct mtk_q_data *q_data;
> +
> +	q_data = mtk_venc_get_q_data(ctx, vq->type);
> +
> +	if (*nbuffers < 1)
> +		*nbuffers = 1;
> +	if (*nbuffers > MTK_VIDEO_MAX_FRAME)
> +		*nbuffers = MTK_VIDEO_MAX_FRAME;
> +
> +	*nplanes = q_data->fmt->num_planes;
> +
> +	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		unsigned int i;
> +
> +		for (i = 0; i < *nplanes; i++) {
> +			sizes[i] = q_data->sizeimage[i];
> +			alloc_ctxs[i] = ctx->dev->alloc_ctx;
> +		}
> +	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		sizes[0] = q_data->sizeimage[0];
> +		alloc_ctxs[0] = ctx->dev->alloc_ctx;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	mtk_v4l2_debug(2,
> +			"[%d]get %d buffer(s) of size 0x%x each",
> +			ctx->idx, *nbuffers, sizes[0]);
> +
> +	return 0;
> +}
> +
> +static int vb2ops_venc_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct mtk_q_data *q_data;
> +	int i;
> +
> +	q_data = mtk_venc_get_q_data(ctx, vb->vb2_queue->type);
> +
> +	for (i = 0; i < q_data->fmt->num_planes; i++) {
> +		if (vb2_plane_size(vb, i) < q_data->sizeimage[i]) {
> +			mtk_v4l2_debug(2,
> +					"data will not fit into plane %d (%lu < %d)",
> +					i, vb2_plane_size(vb, i),
> +					q_data->sizeimage[i]);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void vb2ops_venc_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct mtk_video_enc_buf *buf =
> +			container_of(vb, struct mtk_video_enc_buf, b);
> +
> +	if ((vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
> +		(ctx->param_change != MTK_ENCODE_PARAM_NONE)) {
> +		mtk_v4l2_debug(1,
> +				"[%d] Before id=%d encode parameter change %x",
> +				ctx->idx, vb->index,
> +				ctx->param_change);
> +		buf->param_change = ctx->param_change;
> +		if (buf->param_change & MTK_ENCODE_PARAM_BITRATE) {
> +			buf->enc_params.bitrate = ctx->enc_params.bitrate;
> +			mtk_v4l2_debug(1, "change param br=%d",
> +				 buf->enc_params.bitrate);
> +		}
> +		if (ctx->param_change & MTK_ENCODE_PARAM_FRAMERATE) {
> +			buf->enc_params.framerate_num =
> +				ctx->enc_params.framerate_num;
> +			buf->enc_params.framerate_denom =
> +				ctx->enc_params.framerate_denom;
> +			mtk_v4l2_debug(1, "change param fr=%d",
> +					buf->enc_params.framerate_num /
> +					buf->enc_params.framerate_denom);
> +		}
> +		if (ctx->param_change & MTK_ENCODE_PARAM_INTRA_PERIOD) {
> +			buf->enc_params.gop_size = ctx->enc_params.gop_size;
> +			mtk_v4l2_debug(1, "change param intra period=%d",
> +					 buf->enc_params.gop_size);
> +		}
> +		if (ctx->param_change & MTK_ENCODE_PARAM_FRAME_TYPE) {
> +			buf->enc_params.force_intra =
> +				ctx->enc_params.force_intra;
> +			mtk_v4l2_debug(1, "change param force I=%d",
> +					 buf->enc_params.force_intra);
> +		}
> +		if (ctx->param_change & MTK_ENCODE_PARAM_SKIP_FRAME) {
> +			buf->enc_params.skip_frame =
> +				ctx->enc_params.skip_frame;
> +			mtk_v4l2_debug(1, "change param skip frame=%d",
> +					 buf->enc_params.skip_frame);
> +		}
> +		ctx->param_change = MTK_ENCODE_PARAM_NONE;
> +	}
> +
> +	v4l2_m2m_buf_queue(ctx->m2m_ctx, to_vb2_v4l2_buffer(vb));
> +}
> +
> +static void mtk_venc_set_param(struct mtk_vcodec_ctx *ctx, void *param)
> +{
> +	struct venc_enc_prm *p = (struct venc_enc_prm *)param;
> +	struct mtk_q_data *q_data_src = &ctx->q_data[MTK_Q_DATA_SRC];
> +	struct mtk_enc_params *enc_params = &ctx->enc_params;
> +	unsigned int frame_rate;
> +
> +	frame_rate = enc_params->framerate_num / enc_params->framerate_denom;
> +
> +	switch (q_data_src->fmt->fourcc) {
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YUV420M:
> +		p->input_fourcc = VENC_YUV_FORMAT_420;
> +		break;
> +	case V4L2_PIX_FMT_YVU420:
> +	case V4L2_PIX_FMT_YVU420M:
> +		p->input_fourcc = VENC_YUV_FORMAT_YV12;
> +		break;
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV12M:
> +		p->input_fourcc = VENC_YUV_FORMAT_NV12;
> +		break;
> +	case V4L2_PIX_FMT_NV21:
> +	case V4L2_PIX_FMT_NV21M:
> +		p->input_fourcc = VENC_YUV_FORMAT_NV21;
> +		break;
> +	}
> +	p->h264_profile = enc_params->h264_profile;
> +	p->h264_level = enc_params->h264_level;
> +	p->width = q_data_src->width;
> +	p->height = q_data_src->height;
> +	p->buf_width = q_data_src->bytesperline[0];
> +	p->buf_height = ((q_data_src->height + 0xf) & (~0xf));
> +	p->frm_rate = frame_rate;
> +	p->intra_period = enc_params->gop_size;
> +	p->bitrate = enc_params->bitrate;
> +
> +	ctx->param_change = MTK_ENCODE_PARAM_NONE;
> +
> +	mtk_v4l2_debug(1,
> +			"fmt 0x%x P/L %d/%d w/h %d/%d buf %d/%d fps/bps %d/%d gop %d",
> +			p->input_fourcc, p->h264_profile, p->h264_level, p->width,
> +			p->height, p->buf_width, p->buf_height, p->frm_rate,
> +			p->bitrate, p->intra_period);
> +}
> +
> +static int vb2ops_venc_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> +	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
> +	int ret;
> +	struct venc_enc_prm param;
> +
> +#if MTK_V4L2_BENCHMARK
> +	struct timeval begin, end;
> +
> +	do_gettimeofday(&begin);
> +#endif
> +
> +	/* Once state turn into MTK_STATE_ABORT, we need stop_streaming to clear it */
> +	if (ctx->state == MTK_STATE_ABORT)
> +		return -EINVAL;
> +
> +	if (!(vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q) &
> +	      vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q))) {
> +		mtk_v4l2_debug(1, "[%d]-> out=%d cap=%d",
> +		 ctx->idx,
> +		 vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q),
> +		 vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q));
> +		return 0;
> +	}
> +
> +
> +		ret = venc_if_create(ctx,
> +				     ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc);

Weird indentation.

> +		if (ret) {
> +		v4l2_err(v4l2_dev, "venc_if_create failed=%d, codec type=%x\n",
> +			 ret, ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc);
> +			return -EINVAL;
> +		}
> +
> +		mtk_venc_set_param(ctx, &param);
> +		ret = venc_if_set_param(ctx,
> +					VENC_SET_PARAM_ENC, &param);
> +		if (ret) {
> +			v4l2_err(v4l2_dev, "venc_if_set_param failed=%d\n",
> +				 ret);
> +			venc_if_release(ctx);
> +			return -EINVAL;
> +		}
> +
> +		ctx->state = MTK_STATE_INIT;
> +
> +		if ((ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc ==
> +				V4L2_PIX_FMT_H264) &&
> +			(ctx->enc_params.seq_hdr_mode !=
> +			V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE)) {
> +			ret = venc_if_set_param(ctx,
> +						VENC_SET_PARAM_PREPEND_HEADER,
> +						0);
> +			if (ret) {
> +				v4l2_err(v4l2_dev,
> +					 "venc_if_set_param failed=%d\n",
> +					 ret);
> +				venc_if_release(ctx);
> +				ctx->state = MTK_STATE_FREE;
> +				return -EINVAL;
> +			}
> +			ctx->state = MTK_STATE_HEADER;
> +		}
> +
> +		INIT_WORK(&ctx->encode_work, mtk_venc_worker);
> +
> +#if MTK_V4L2_BENCHMARK
> +	do_gettimeofday(&end);
> +	ctx->total_enc_dec_init_time =
> +		((end.tv_sec - begin.tv_sec) * 1000000 +
> +			end.tv_usec - begin.tv_usec);
> +
> +#endif
> +
> +	return 0;
> +}
> +
> +static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> +	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	int ret;
> +
> +	mtk_v4l2_debug(2, "[%d]-> type=%d", ctx->idx, q->type);
> +
> +	ctx->state = MTK_STATE_ABORT;
> +		queue_work(ctx->dev->encode_workqueue, &ctx->encode_work);
> +		ret = mtk_vcodec_wait_for_done_ctx(ctx,
> +					   MTK_INST_WORK_THREAD_ABORT_DONE,
> +					   WAIT_INTR_TIMEOUT, true);
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		while ((dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx))) {
> +			dst_buf->planes[0].bytesused = 0;
> +			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);

This should be state ERROR since it doesn't actually contain any valid data.

> +		}
> +	} else {
> +		while ((src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx)))
> +			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), VB2_BUF_STATE_DONE);

Ditto.

> +	}
> +
> +	if ((q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> +	     vb2_is_streaming(&ctx->m2m_ctx->out_q_ctx.q)) ||
> +	     (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
> +	     vb2_is_streaming(&ctx->m2m_ctx->cap_q_ctx.q))) {
> +		mtk_v4l2_debug(1, "[%d]-> q type %d out=%d cap=%d",
> +				 ctx->idx, q->type,
> +				 vb2_is_streaming(&ctx->m2m_ctx->out_q_ctx.q),
> +				 vb2_is_streaming(&ctx->m2m_ctx->cap_q_ctx.q));
> +		return;
> +	}
> +
> +	ret = venc_if_release(ctx);
> +	if (ret)
> +		v4l2_err(v4l2_dev, "venc_if_release failed=%d\n", ret);
> +
> +	ctx->state = MTK_STATE_FREE;
> +}
> +
> +static struct vb2_ops mtk_venc_vb2_ops = {
> +	.queue_setup			= vb2ops_venc_queue_setup,
> +	.buf_prepare			= vb2ops_venc_buf_prepare,
> +	.buf_queue			= vb2ops_venc_buf_queue,
> +	.wait_prepare			= vb2_ops_wait_prepare,
> +	.wait_finish			= vb2_ops_wait_finish,
> +	.start_streaming		= vb2ops_venc_start_streaming,
> +	.stop_streaming			= vb2ops_venc_stop_streaming,
> +};
> +
> +static int mtk_venc_encode_header(void *priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
> +	int ret;
> +	struct vb2_buffer *dst_buf;
> +	struct mtk_vcodec_mem bs_buf;
> +	struct venc_done_result enc_result;
> +
> +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +	if (!dst_buf) {
> +		mtk_v4l2_debug(1, "No dst buffer");
> +		return -EINVAL;
> +	}
> +
> +	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
> +	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +	bs_buf.size = (unsigned int)dst_buf->planes[0].length;
> +
> +	mtk_v4l2_debug(1,
> +			"buf idx=%d va=0x%p dma_addr=0x%llx size=0x%lx",
> +			dst_buf->index, bs_buf.va,
> +			(u64)bs_buf.dma_addr, bs_buf.size);
> +
> +	ret = venc_if_encode(ctx,
> +			VENC_START_OPT_ENCODE_SEQUENCE_HEADER,
> +			0, &bs_buf, &enc_result);
> +
> +	if (ret) {
> +		dst_buf->planes[0].bytesused = 0;
> +		ctx->state = MTK_STATE_ABORT;
> +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_ERROR);
> +		v4l2_err(v4l2_dev, "venc_if_encode failed=%d", ret);
> +		return -EINVAL;
> +	}
> +
> +	ctx->state = MTK_STATE_HEADER;
> +	dst_buf->planes[0].bytesused = enc_result.bs_size;
> +
> +#if defined(DEBUG)
> +{
> +	int i;
> +	mtk_v4l2_debug(1, "venc_if_encode header len=%d",
> +			enc_result.bs_size);
> +	for (i = 0; i < enc_result.bs_size; i++) {
> +		unsigned char *p = (unsigned char *)bs_buf.va;
> +
> +		mtk_v4l2_debug(1, "buf[%d]=0x%2x", i, p[i]);
> +	}
> +}
> +#endif
> +	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);
> +
> +	return 0;
> +}
> +
> +static int mtk_venc_param_change(struct mtk_vcodec_ctx *ctx, void *priv)
> +{
> +	struct vb2_buffer *vb = priv;
> +	struct mtk_video_enc_buf *buf =
> +			container_of(vb, struct mtk_video_enc_buf, b);
> +	int ret = 0;
> +
> +	if (buf->param_change == MTK_ENCODE_PARAM_NONE)
> +		return 0;
> +
> +	mtk_v4l2_debug(1, "encode parameters change id=%d", vb->index);
> +	if (buf->param_change & MTK_ENCODE_PARAM_BITRATE) {
> +		struct venc_enc_prm enc_prm;
> +
> +		enc_prm.bitrate = buf->enc_params.bitrate;
> +		mtk_v4l2_debug(1, "change param br=%d",
> +				 enc_prm.bitrate);
> +		ret |= venc_if_set_param(ctx,
> +					 VENC_SET_PARAM_ADJUST_BITRATE,
> +					 &enc_prm);
> +	}
> +	if (buf->param_change & MTK_ENCODE_PARAM_FRAMERATE) {
> +		struct venc_enc_prm enc_prm;
> +
> +		enc_prm.frm_rate = buf->enc_params.framerate_num /
> +				   buf->enc_params.framerate_denom;
> +		mtk_v4l2_debug(1, "change param fr=%d",
> +				 enc_prm.frm_rate);
> +		ret |= venc_if_set_param(ctx,
> +					 VENC_SET_PARAM_ADJUST_FRAMERATE,
> +					 &enc_prm);
> +	}
> +	if (buf->param_change & MTK_ENCODE_PARAM_INTRA_PERIOD) {
> +		mtk_v4l2_debug(1, "change param intra period=%d",
> +				 buf->enc_params.gop_size);
> +		ret |= venc_if_set_param(ctx,
> +					 VENC_SET_PARAM_I_FRAME_INTERVAL,
> +					 &buf->enc_params.gop_size);
> +	}
> +	if (buf->param_change & MTK_ENCODE_PARAM_FRAME_TYPE) {
> +		mtk_v4l2_debug(1, "change param force I=%d",
> +				 buf->enc_params.force_intra);
> +		if (buf->enc_params.force_intra)
> +			ret |= venc_if_set_param(ctx,
> +						 VENC_SET_PARAM_FORCE_INTRA,
> +						 0);
> +	}
> +	if (buf->param_change & MTK_ENCODE_PARAM_SKIP_FRAME) {
> +		mtk_v4l2_debug(1, "change param skip frame=%d",
> +				 buf->enc_params.skip_frame);
> +		if (buf->enc_params.skip_frame)
> +			ret |= venc_if_set_param(ctx,
> +						 VENC_SET_PARAM_SKIP_FRAME,
> +						 0);
> +	}
> +	buf->param_change = MTK_ENCODE_PARAM_NONE;
> +
> +	if (ret) {
> +		ctx->state = MTK_STATE_ABORT;
> +		mtk_v4l2_err("venc_if_set_param %d failed=%d\n",
> +			MTK_ENCODE_PARAM_FRAME_TYPE, ret);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static void mtk_venc_worker(struct work_struct *work)
> +{
> +	struct mtk_vcodec_ctx *ctx = container_of(work, struct mtk_vcodec_ctx,
> +				    encode_work);
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	struct vb2_v4l2_buffer *v4l2_vb;
> +	struct venc_frm_buf frm_buf;
> +	struct mtk_vcodec_mem bs_buf;
> +	struct venc_done_result enc_result;
> +	int ret;
> +
> +#if MTK_V4L2_BENCHMARK
> +	struct timeval begin, end;
> +	struct timeval begin1, end1;
> +	do_gettimeofday(&begin);
> +#endif
> +	mutex_lock(&ctx->dev->dev_mutex);
> +
> +	if (ctx->state == MTK_STATE_ABORT) {
> +		v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
> +		mtk_v4l2_debug(0, "[%d] [MTK_INST_ABORT]", ctx->idx);
> +		ctx->int_cond = 1;
> +		ctx->int_type = MTK_INST_WORK_THREAD_ABORT_DONE;
> +		wake_up_interruptible(&ctx->queue);
> +		mutex_unlock(&ctx->dev->dev_mutex);
> +		return;
> +	}
> +
> +	if ((ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc ==
> +				V4L2_PIX_FMT_H264) &&
> +		(ctx->state != MTK_STATE_HEADER)) {
> +		/* encode h264 sps/pps header */
> +#if MTK_V4L2_BENCHMARK
> +		do_gettimeofday(&begin1);
> +#endif
> +		mtk_venc_encode_header(ctx);
> +#if MTK_V4L2_BENCHMARK
> +		do_gettimeofday(&end1);
> +		ctx->total_enc_hdr_time +=
> +			((end1.tv_sec - begin1.tv_sec) * 1000000 +
> +				end1.tv_usec - begin1.tv_usec);
> +#endif
> +
> +		v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
> +		mutex_unlock(&ctx->dev->dev_mutex);
> +		return;
> +	}
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	if (!src_buf) {
> +		mutex_unlock(&ctx->dev->dev_mutex);
> +		return;
> +	}
> +
> +	mtk_venc_param_change(ctx, src_buf);
> +
> +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +	if (!dst_buf) {
> +		mutex_unlock(&ctx->dev->dev_mutex);
> +		return;
> +	}
> +
> +	frm_buf.fb_addr.va = vb2_plane_vaddr(src_buf, 0);
> +	frm_buf.fb_addr.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +	frm_buf.fb_addr.size = (unsigned int)src_buf->planes[0].length;
> +	frm_buf.fb_addr1.va = vb2_plane_vaddr(src_buf, 1);
> +	frm_buf.fb_addr1.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 1);
> +	frm_buf.fb_addr1.size = (unsigned int)src_buf->planes[1].length;
> +	if (src_buf->num_planes == 3) {
> +		frm_buf.fb_addr2.va = vb2_plane_vaddr(src_buf, 2);
> +		frm_buf.fb_addr2.dma_addr =
> +			vb2_dma_contig_plane_dma_addr(src_buf, 2);
> +		frm_buf.fb_addr2.size =
> +			(unsigned int)src_buf->planes[2].length;
> +	} else {
> +		frm_buf.fb_addr2.va = NULL;
> +		frm_buf.fb_addr2.dma_addr = 0;
> +		frm_buf.fb_addr2.size = 0;
> +	}
> +	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
> +	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +	bs_buf.size = (unsigned int)dst_buf->planes[0].length;
> +
> +	mtk_v4l2_debug(1,
> +			"Framebuf VA=%p PA=%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx",
> +			frm_buf.fb_addr.va,
> +			(u64)frm_buf.fb_addr.dma_addr,
> +			frm_buf.fb_addr.size,
> +			frm_buf.fb_addr1.va,
> +			(u64)frm_buf.fb_addr1.dma_addr,
> +			frm_buf.fb_addr1.size,
> +			frm_buf.fb_addr2.va,
> +			(u64)frm_buf.fb_addr2.dma_addr,
> +			frm_buf.fb_addr2.size);
> +
> +	ret = venc_if_encode(ctx, VENC_START_OPT_ENCODE_FRAME,
> +			     &frm_buf, &bs_buf, &enc_result);
> +
> +	switch (enc_result.msg) {
> +	case VENC_MESSAGE_OK:
> +		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), VB2_BUF_STATE_DONE);
> +		dst_buf->planes[0].bytesused = enc_result.bs_size;
> +		break;
> +	default:
> +		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), VB2_BUF_STATE_ERROR);
> +		dst_buf->planes[0].bytesused = 0;
> +		break;
> +	}
> +	if (enc_result.is_key_frm) {
> +		v4l2_vb = to_vb2_v4l2_buffer(dst_buf);
> +		v4l2_vb->flags |= V4L2_BUF_FLAG_KEYFRAME;
> +	}
> +
> +	if (ret) {
> +		ctx->state = MTK_STATE_ABORT;
> +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_ERROR);
> +		mtk_v4l2_err("venc_if_encode failed=%d", ret);
> +	} else {
> +		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);
> +		mtk_v4l2_debug(1, "venc_if_encode bs size=%d",
> +				 enc_result.bs_size);
> +	}
> +
> +#if MTK_V4L2_BENCHMARK
> +	do_gettimeofday(&end);
> +	ctx->total_enc_dec_cnt++;
> +	ctx->total_enc_dec_time +=
> +		((end.tv_sec - begin.tv_sec) * 1000000 +
> +			end.tv_usec - begin.tv_usec);
> +#endif
> +
> +	v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
> +
> +	mtk_v4l2_debug(1, "<=== src_buf[%d] dst_buf[%d] venc_if_encode ret=%d Size=%u===>",
> +			src_buf->index, dst_buf->index, ret,
> +			enc_result.bs_size);
> +	mutex_unlock(&ctx->dev->dev_mutex);
> +
> +}
> +
> +static void m2mops_venc_device_run(void *priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +	queue_work(ctx->dev->encode_workqueue, &ctx->encode_work);
> +}
> +
> +static int m2mops_venc_job_ready(void *m2m_priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> +
> +	if (!v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx)) {
> +		mtk_v4l2_debug(3,
> +				"[%d]Not ready: not enough video dst buffers.",
> +				ctx->idx);
> +		return 0;
> +	}
> +
> +	if (!v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx)) {
> +			mtk_v4l2_debug(3,
> +					"[%d]Not ready: not enough video src buffers.",
> +					ctx->idx);
> +			return 0;
> +		}
> +
> +	if (ctx->state == MTK_STATE_ABORT) {
> +		mtk_v4l2_debug(3,
> +				"[%d]Not ready: state=0x%x.",
> +				ctx->idx, ctx->state);
> +		return 0;
> +	}
> +
> +	if (ctx->state == MTK_STATE_FREE) {
> +		mtk_v4l2_debug(3,
> +				"[%d]Not ready: state=0x%x.",
> +				ctx->idx, ctx->state);
> +		return 0;
> +	}
> +
> +	mtk_v4l2_debug(3, "[%d]ready!", ctx->idx);
> +
> +	return 1;
> +}
> +
> +static void m2mops_venc_job_abort(void *priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +
> +	mtk_v4l2_debug(3, "[%d]type=%d", ctx->idx, ctx->type);
> +	ctx->state = MTK_STATE_ABORT;
> +
> +	v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
> +}
> +
> +static void m2mops_venc_lock(void *m2m_priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> +
> +	mutex_lock(&ctx->dev->dev_mutex);
> +}
> +
> +static void m2mops_venc_unlock(void *m2m_priv)
> +{
> +	struct mtk_vcodec_ctx *ctx = m2m_priv;
> +
> +	mutex_unlock(&ctx->dev->dev_mutex);
> +}
> +
> +const struct v4l2_m2m_ops mtk_venc_m2m_ops = {
> +	.device_run			= m2mops_venc_device_run,
> +	.job_ready			= m2mops_venc_job_ready,
> +	.job_abort			= m2mops_venc_job_abort,
> +	.lock				= m2mops_venc_lock,
> +	.unlock				= m2mops_venc_unlock,
> +};
> +
> +#define IS_MTK_VENC_PRIV(x) ((V4L2_CTRL_ID2CLASS(x) == V4L2_CTRL_CLASS_MPEG) &&\
> +			     V4L2_CTRL_DRIVER_PRIV(x))
> +
> +static const char *const *mtk_vcodec_enc_get_menu(u32 id)
> +{
> +	static const char *const mtk_vcodec_enc_video_frame_skip[] = {
> +		"Disabled",
> +		"Level Limit",
> +		"VBV/CPB Limit",
> +		NULL,
> +	};
> +	static const char *const mtk_vcodec_enc_video_force_frame[] = {
> +		"Disabled",
> +		"I Frame",
> +		"Not Coded",
> +		NULL,
> +	};
> +	switch (id) {
> +	case V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE:
> +		return mtk_vcodec_enc_video_frame_skip;
> +	case V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE:
> +		return mtk_vcodec_enc_video_force_frame;
> +	}
> +	return NULL;
> +}
> +
> +int mtk_venc_ctrls_setup(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct v4l2_ctrl_config cfg;
> +	int i;
> +
> +	v4l2_ctrl_handler_init(&ctx->ctrl_hdl, NUM_CTRLS);
> +	if (ctx->ctrl_hdl.error) {
> +		v4l2_err(&ctx->dev->v4l2_dev, "Init control handler fail %d\n",
> +			 ctx->ctrl_hdl.error);
> +		return ctx->ctrl_hdl.error;
> +	}
> +	for (i = 0; i < NUM_CTRLS; i++) {
> +		if (IS_MTK_VENC_PRIV(controls[i].id)) {
> +			memset(&cfg, 0, sizeof(struct v4l2_ctrl_config));
> +			cfg.ops = &mtk_vcodec_enc_ctrl_ops;
> +			cfg.id = controls[i].id;
> +			cfg.min = controls[i].minimum;
> +			cfg.max = controls[i].maximum;
> +			cfg.def = controls[i].default_value;
> +			cfg.name = controls[i].name;
> +			cfg.type = controls[i].type;
> +			cfg.flags = 0;
> +			if (cfg.type == V4L2_CTRL_TYPE_MENU) {
> +				cfg.step = 0;
> +				cfg.menu_skip_mask = cfg.menu_skip_mask;
> +				cfg.qmenu = mtk_vcodec_enc_get_menu(cfg.id);
> +			} else {
> +				cfg.step = controls[i].step;
> +				cfg.menu_skip_mask = 0;
> +			}
> +			v4l2_ctrl_new_custom(&ctx->ctrl_hdl, &cfg, NULL);
> +		} else {
> +			if ((controls[i].type == V4L2_CTRL_TYPE_MENU) ||
> +			    (controls[i].type == V4L2_CTRL_TYPE_INTEGER_MENU)) {
> +				v4l2_ctrl_new_std_menu(
> +					&ctx->ctrl_hdl,
> +					&mtk_vcodec_enc_ctrl_ops,
> +					controls[i].id,
> +					controls[i].maximum, 0,
> +					controls[i].default_value);
> +			} else {
> +				v4l2_ctrl_new_std(
> +					&ctx->ctrl_hdl,
> +					&mtk_vcodec_enc_ctrl_ops,
> +					controls[i].id,
> +					controls[i].minimum,
> +					controls[i].maximum,
> +					controls[i].step,
> +					controls[i].default_value);
> +			}
> +		}
> +
> +		if (ctx->ctrl_hdl.error) {
> +			v4l2_err(&ctx->dev->v4l2_dev,
> +				"Adding control (%d) failed %d\n",
> +				i, ctx->ctrl_hdl.error);
> +			return ctx->ctrl_hdl.error;
> +		}
> +	}
> +
> +	v4l2_ctrl_handler_setup(&ctx->ctrl_hdl);
> +	return 0;
> +}
> +
> +void mtk_venc_ctrls_free(struct mtk_vcodec_ctx *ctx)
> +{
> +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);

Why not call v4l2_ctrl_handler_free() directly instead of going through
an unnecessary wrapper function?

> +}
> +
> +int m2mctx_venc_queue_init(void *priv, struct vb2_queue *src_vq,
> +			   struct vb2_queue *dst_vq)
> +{
> +	struct mtk_vcodec_ctx *ctx = priv;
> +	int ret;
> +
> +	src_vq->type		= V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	src_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;

You're using videobuf2-dma-contig, so VB2_USERPTR is generally useless in that
case. I would drop it.

> +	src_vq->drv_priv	= ctx;
> +	src_vq->buf_struct_size = sizeof(struct mtk_video_enc_buf);
> +	src_vq->ops		= &mtk_venc_vb2_ops;
> +	src_vq->mem_ops		= &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->vb2_mutex;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	dst_vq->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	dst_vq->io_modes	= VB2_DMABUF | VB2_MMAP | VB2_USERPTR;

Ditto.

> +	dst_vq->drv_priv	= ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops		= &mtk_venc_vb2_ops;
> +	dst_vq->mem_ops		= &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->vb2_mutex;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +int mtk_venc_unlock(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct mtk_vcodec_dev *dev = ctx->dev;
> +
> +	mutex_unlock(&dev->enc_mutex);
> +	return 0;
> +}
> +
> +int mtk_venc_lock(struct mtk_vcodec_ctx *ctx)
> +{
> +	struct mtk_vcodec_dev *dev = ctx->dev;
> +
> +	mutex_lock(&dev->enc_mutex);
> +	dev->curr_ctx = ctx->idx;
> +	return 0;
> +}
> +
> +void mtk_vcodec_venc_release(struct mtk_vcodec_ctx *ctx)
> +{
> +	venc_if_release(ctx);
> +
> +#if MTK_V4L2_BENCHMARK
> +	mtk_v4l2_debug(0, "\n\nMTK_V4L2_BENCHMARK");
> +
> +	mtk_v4l2_debug(0, "  total_enc_dec_cnt: %d ", ctx->total_enc_dec_cnt);
> +	mtk_v4l2_debug(0, "  total_enc_dec_time: %d us",
> +				ctx->total_enc_dec_time);
> +	mtk_v4l2_debug(0, "  total_enc_dec_init_time: %d us",
> +				ctx->total_enc_dec_init_time);
> +	mtk_v4l2_debug(0, "  total_enc_hdr_time: %d us",
> +				ctx->total_enc_hdr_time);
> +	mtk_v4l2_debug(0, "  total_qbuf_out_time: %d us",
> +				ctx->total_qbuf_out_time);
> +	mtk_v4l2_debug(0, "  total_qbuf_out_cnt: %d ",
> +				ctx->total_qbuf_out_cnt);
> +	mtk_v4l2_debug(0, "  total_qbuf_cap_time: %d us",
> +				ctx->total_qbuf_cap_time);
> +	mtk_v4l2_debug(0, "  total_qbuf_cap_cnt: %d ",
> +				ctx->total_qbuf_cap_cnt);
> +
> +	mtk_v4l2_debug(0, "  total_dqbuf_out_time: %d us",
> +				ctx->total_dqbuf_out_time);
> +	mtk_v4l2_debug(0, "  total_dqbuf_out_cnt: %d ",
> +				ctx->total_dqbuf_out_cnt);
> +	mtk_v4l2_debug(0, "  total_dqbuf_cap_time: %d us",
> +				ctx->total_dqbuf_cap_time);
> +	mtk_v4l2_debug(0, "  total_dqbuf_cap_cnt: %d ",
> +				ctx->total_dqbuf_cap_cnt);
> +
> +	mtk_v4l2_debug(0, "  total_expbuf_time: %d us",
> +				ctx->total_expbuf_time);
> +
> +#endif
> +
> +}
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
> new file mode 100644
> index 0000000..0d6b79a
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
> @@ -0,0 +1,45 @@
> +/*
> +* Copyright (c) 2015 MediaTek Inc.
> +* Author: PC Chen <pc.chen@mediatek.com>
> +*         Tiffany Lin <tiffany.lin@mediatek.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*/
> +
> +
> +#ifndef _MTK_VCODEC_ENC_H_
> +#define _MTK_VCODEC_ENC_H_
> +
> +#include <media/videobuf2-core.h>
> +
> +/**
> + * struct mtk_video_enc_buf - Private data related to each VB2 buffer.
> + * @b:			Pointer to related VB2 buffer.
> + * @param_change:	Types of encode parameter change before encode this
> + *			buffer
> + * @enc_params		Encode parameters changed before encode this buffer
> + */
> +struct mtk_video_enc_buf {
> +	struct vb2_buffer b;
> +	struct list_head list;
> +
> +	enum mtk_encode_param param_change;
> +	struct mtk_enc_params enc_params;
> +};
> +
> +int mtk_venc_unlock(struct mtk_vcodec_ctx *ctx);
> +int mtk_venc_lock(struct mtk_vcodec_ctx *ctx);
> +int m2mctx_venc_queue_init(void *priv, struct vb2_queue *src_vq,
> +	struct vb2_queue *dst_vq);
> +void mtk_vcodec_venc_release(struct mtk_vcodec_ctx *ctx);
> +int mtk_venc_ctrls_setup(struct mtk_vcodec_ctx *ctx);
> +void mtk_venc_ctrls_free(struct mtk_vcodec_ctx *ctx);
> +
> +#endif /* _MTK_VCODEC_ENC_H_ */
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> new file mode 100644
> index 0000000..116ab97
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> @@ -0,0 +1,469 @@
> +/*
> +* Copyright (c) 2015 MediaTek Inc.
> +* Author: PC Chen <pc.chen@mediatek.com>
> +*         Tiffany Lin <tiffany.lin@mediatek.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*/
> +
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/of.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <linux/pm_runtime.h>
> +
> +#include "mtk_vcodec_drv.h"
> +#include "mtk_vcodec_enc.h"
> +#include "mtk_vcodec_pm.h"
> +#include "mtk_vcodec_intr.h"
> +#include "mtk_vcodec_util.h"
> +#include "mtk_vpu.h"
> +
> +static irqreturn_t mtk_vcodec_enc_irq_handler(int irq, void *priv);
> +
> +/* Wake up context wait_queue */
> +static void wake_up_ctx(struct mtk_vcodec_ctx *ctx, unsigned int reason)
> +{
> +	ctx->int_cond = 1;
> +	ctx->int_type = reason;
> +	wake_up_interruptible(&ctx->queue);
> +}
> +
> +static irqreturn_t mtk_vcodec_enc_irq_handler(int irq, void *priv)
> +{
> +	struct mtk_vcodec_dev *dev = priv;
> +	struct mtk_vcodec_ctx *ctx;
> +	unsigned int irq_status;
> +
> +	ctx = dev->ctx[dev->curr_ctx];
> +	if (ctx == NULL) {
> +		mtk_v4l2_err("ctx==NULL");
> +		return IRQ_HANDLED;
> +	}
> +	mtk_v4l2_debug(1, "idx=%d", ctx->idx);
> +	irq_status = readl(dev->reg_base[VENC_SYS] +
> +				(MTK_VENC_IRQ_STATUS_OFFSET));
> +	if (irq_status & MTK_VENC_IRQ_STATUS_PAUSE)
> +		writel((MTK_VENC_IRQ_STATUS_PAUSE),
> +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_SWITCH)
> +		writel((MTK_VENC_IRQ_STATUS_SWITCH),
> +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_DRAM)
> +		writel((MTK_VENC_IRQ_STATUS_DRAM),
> +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_SPS)
> +		writel((MTK_VENC_IRQ_STATUS_SPS),
> +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_PPS)
> +		writel((MTK_VENC_IRQ_STATUS_PPS),
> +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_FRM)
> +		writel((MTK_VENC_IRQ_STATUS_FRM),
> +		       dev->reg_base[VENC_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	ctx->irq_status = irq_status;
> +	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
> +	return IRQ_HANDLED;
> +}
> +
> +#if 1 /* VENC_LT */
> +static irqreturn_t mtk_vcodec_enc_irq_handler2(int irq, void *priv)
> +{
> +	struct mtk_vcodec_dev *dev = priv;
> +	struct mtk_vcodec_ctx *ctx;
> +	unsigned int irq_status;
> +
> +	ctx = dev->ctx[dev->curr_ctx];
> +	if (ctx == NULL) {
> +		mtk_v4l2_err("ctx==NULL");
> +		return IRQ_HANDLED;
> +	}
> +	mtk_v4l2_debug(1, "idx=%d", ctx->idx);
> +	irq_status = readl(dev->reg_base[VENC_LT_SYS] +
> +				(MTK_VENC_IRQ_STATUS_OFFSET));
> +	if (irq_status & MTK_VENC_IRQ_STATUS_PAUSE)
> +		writel((MTK_VENC_IRQ_STATUS_PAUSE),
> +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_SWITCH)
> +		writel((MTK_VENC_IRQ_STATUS_SWITCH),
> +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_DRAM)
> +		writel((MTK_VENC_IRQ_STATUS_DRAM),
> +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_SPS)
> +		writel((MTK_VENC_IRQ_STATUS_SPS),
> +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_PPS)
> +		writel((MTK_VENC_IRQ_STATUS_PPS),
> +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	if (irq_status & MTK_VENC_IRQ_STATUS_FRM)
> +		writel((MTK_VENC_IRQ_STATUS_FRM),
> +		       dev->reg_base[VENC_LT_SYS] + (MTK_VENC_IRQ_ACK_OFFSET));
> +
> +	ctx->irq_status = irq_status;
> +	wake_up_ctx(ctx, MTK_INST_IRQ_RECEIVED);
> +	return IRQ_HANDLED;
> +}
> +#endif
> +
> +static int fops_vcodec_open(struct file *file)
> +{
> +	struct video_device *vfd = video_devdata(file);
> +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> +	struct mtk_vcodec_ctx *ctx = NULL;
> +	int ret = 0;
> +
> +	mutex_lock(&dev->dev_mutex);
> +
> +	ctx = devm_kzalloc(&dev->plat_dev->dev, sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		ret = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	if (dev->num_instances >= MTK_VCODEC_MAX_ENCODER_INSTANCES) {
> +		mtk_v4l2_err("Too many open contexts\n");
> +		ret = -EBUSY;
> +		goto err_no_ctx;
> +	}
> +
> +	ctx->idx = ffz(dev->instance_mask[0]);
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +	ctx->dev = dev;
> +	mutex_init(&ctx->encode_param_mutex);
> +	mutex_init(&ctx->vb2_mutex);
> +
> +	if (vfd == dev->vfd_enc) {
> +		ctx->type = MTK_INST_ENCODER;
> +		ret = mtk_venc_ctrls_setup(ctx);
> +		if (ret) {
> +			mtk_v4l2_err("Failed to setup controls() (%d)\n",
> +				       ret);
> +			goto err_ctrls_setup;
> +		}
> +		ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev_enc, ctx,
> +						 &m2mctx_venc_queue_init);
> +		if (IS_ERR(ctx->m2m_ctx)) {
> +			ret = PTR_ERR(ctx->m2m_ctx);
> +			mtk_v4l2_err("Failed to v4l2_m2m_ctx_init() (%d)\n",
> +				       ret);
> +			goto err_ctx_init;
> +		}
> +		ctx->fh.ctrl_handler = &ctx->ctrl_hdl;
> +	} else {
> +		mtk_v4l2_err("Invalid vfd !\n");
> +		ret = -ENOENT;
> +		goto err_ctx_init;
> +	}
> +
> +	init_waitqueue_head(&ctx->queue);
> +	dev->num_instances++;
> +
> +	if (dev->num_instances == 1) {
> +		ret = vpu_load_firmware(dev->vpu_plat_dev);
> +		if (ret < 0) {
> +				mtk_v4l2_err("vpu_load_firmware failed!\n");
> +			goto err_load_fw;
> +		}
> +
> +		dev->enc_capability =
> +			vpu_get_venc_hw_capa(dev->vpu_plat_dev);
> +		mtk_v4l2_debug(0, "encoder capability %x", dev->enc_capability);
> +	}
> +
> +	mtk_v4l2_debug(2, "Create instance [%d]@%p m2m_ctx=%p type=%d\n",
> +			 ctx->idx, ctx, ctx->m2m_ctx, ctx->type);
> +	set_bit(ctx->idx, &dev->instance_mask[0]);
> +	dev->ctx[ctx->idx] = ctx;
> +
> +	mutex_unlock(&dev->dev_mutex);
> +	mtk_v4l2_debug(0, "%s encoder [%d]", dev_name(&dev->plat_dev->dev), ctx->idx);
> +	return ret;
> +
> +	/* Deinit when failure occurred */
> +err_load_fw:
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	dev->num_instances--;
> +err_ctx_init:
> +err_ctrls_setup:
> +	mtk_venc_ctrls_free(ctx);
> +err_no_ctx:
> +	devm_kfree(&dev->plat_dev->dev, ctx);
> +err_alloc:
> +	mutex_unlock(&dev->dev_mutex);
> +	return ret;
> +}
> +
> +static int fops_vcodec_release(struct file *file)
> +{
> +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	mtk_v4l2_debug(2, "[%d]\n", ctx->idx);
> +	mutex_lock(&dev->dev_mutex);
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	mtk_vcodec_venc_release(ctx);
> +	mtk_venc_ctrls_free(ctx);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	dev->ctx[ctx->idx] = NULL;
> +	dev->num_instances--;
> +	clear_bit(ctx->idx, &dev->instance_mask[0]);
> +	devm_kfree(&dev->plat_dev->dev, ctx);
> +	mutex_unlock(&dev->dev_mutex);
> +	return 0;
> +}
> +
> +static unsigned int fops_vcodec_poll(struct file *file,
> +				     struct poll_table_struct *wait)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> +	struct mtk_vcodec_dev *dev = ctx->dev;
> +	int ret;
> +
> +	mutex_lock(&dev->dev_mutex);
> +	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +	mutex_unlock(&dev->dev_mutex);

Use v4l2_m2m_fop_poll instead.

> +
> +	return ret;
> +}
> +
> +static int fops_vcodec_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);

v4l2_m2m_fop_mmap

> +}
> +
> +static const struct v4l2_file_operations mtk_vcodec_fops = {
> +	.owner				= THIS_MODULE,
> +	.open				= fops_vcodec_open,
> +	.release			= fops_vcodec_release,
> +	.poll				= fops_vcodec_poll,
> +	.unlocked_ioctl			= video_ioctl2,
> +	.mmap				= fops_vcodec_mmap,
> +};
> +
> +static int mtk_vcodec_probe(struct platform_device *pdev)
> +{
> +	struct mtk_vcodec_dev *dev;
> +	struct video_device *vfd_enc;
> +	struct resource *res;
> +	int i, j, ret;
> +
> +	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	dev->plat_dev = pdev;
> +
> +	dev->vpu_plat_dev = vpu_get_plat_device(dev->plat_dev);
> +	if (dev->vpu_plat_dev == NULL) {
> +		mtk_v4l2_err("[VPU] vpu device in not ready\n");
> +		return -EPROBE_DEFER;
> +	}
> +
> +	ret = mtk_vcodec_init_enc_pm(dev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to get mt vcodec clock source!\n");
> +		return ret;
> +	}
> +
> +	for (i = VENC_SYS, j = 0; i < NUM_MAX_VCODEC_REG_BASE; i++, j++) {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, j);
> +		if (res == NULL) {
> +			dev_err(&pdev->dev, "get memory resource failed.\n");
> +			ret = -ENXIO;
> +			goto err_res;
> +		}
> +		dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
> +		if (IS_ERR(dev->reg_base[i])) {
> +			dev_err(&pdev->dev,
> +				"devm_ioremap_resource %d failed.\n", i);
> +			ret = PTR_ERR(dev->reg_base);
> +			goto err_res;
> +		}
> +		mtk_v4l2_debug(2, "reg[%d] base=0x%p\n", i, dev->reg_base[i]);
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "failed to get irq resource\n");
> +		ret = -ENOENT;
> +		goto err_res;
> +	}
> +
> +	dev->enc_irq = platform_get_irq(pdev, 0);
> +	ret = devm_request_irq(&pdev->dev, dev->enc_irq,
> +			       mtk_vcodec_enc_irq_handler,
> +			       0, pdev->name, dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to install dev->enc_irq %d (%d)\n",
> +			dev->enc_irq,
> +			ret);
> +		ret = -EINVAL;
> +		goto err_res;
> +	}
> +
> +	dev->enc_lt_irq = platform_get_irq(pdev, 1);
> +	ret = devm_request_irq(&pdev->dev,
> +			       dev->enc_lt_irq, mtk_vcodec_enc_irq_handler2,
> +			       0, pdev->name, dev);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +			"Failed to install dev->enc_lt_irq %d (%d)\n",
> +			dev->enc_lt_irq, ret);
> +		ret = -EINVAL;
> +		goto err_res;
> +	}
> +
> +	disable_irq(dev->enc_irq);
> +	disable_irq(dev->enc_lt_irq); /* VENC_LT */
> +	mutex_init(&dev->enc_mutex);
> +	mutex_init(&dev->dev_mutex);
> +
> +	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
> +		 "[MTK_V4L2_VENC]");
> +
> +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> +	if (ret) {
> +		mtk_v4l2_err("v4l2_device_register err=%d\n", ret);
> +		return ret;
> +	}
> +
> +	init_waitqueue_head(&dev->queue);
> +
> +	/* allocate video device for encoder and register it */
> +	vfd_enc = video_device_alloc();
> +	if (!vfd_enc) {
> +		mtk_v4l2_err("Failed to allocate video device\n");
> +		ret = -ENOMEM;
> +		goto err_enc_alloc;
> +	}
> +	vfd_enc->fops           = &mtk_vcodec_fops;
> +	vfd_enc->ioctl_ops      = &mtk_venc_ioctl_ops;
> +	vfd_enc->release        = video_device_release;
> +	vfd_enc->lock           = &dev->dev_mutex;
> +	vfd_enc->v4l2_dev       = &dev->v4l2_dev;
> +	vfd_enc->vfl_dir        = VFL_DIR_M2M;
> +
> +	snprintf(vfd_enc->name, sizeof(vfd_enc->name), "%s",
> +		 MTK_VCODEC_ENC_NAME);
> +	video_set_drvdata(vfd_enc, dev);
> +	dev->vfd_enc = vfd_enc;
> +	platform_set_drvdata(pdev, dev);
> +	ret = video_register_device(vfd_enc, VFL_TYPE_GRABBER, 1);
> +	if (ret) {
> +		mtk_v4l2_err("Failed to register video device\n");
> +		goto err_enc_reg;
> +	}
> +	mtk_v4l2_debug(0, "encoder registered as /dev/video%d\n",
> +			 vfd_enc->num);
> +
> +	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(dev->alloc_ctx)) {
> +		mtk_v4l2_err("Failed to alloc vb2 dma context 0\n");
> +		ret = PTR_ERR(dev->alloc_ctx);
> +		goto err_vb2_ctx_init;
> +	}
> +
> +	dev->m2m_dev_enc = v4l2_m2m_init(&mtk_venc_m2m_ops);
> +	if (IS_ERR(dev->m2m_dev_enc)) {
> +		mtk_v4l2_err("Failed to init mem2mem enc device\n");
> +		ret = PTR_ERR(dev->m2m_dev_enc);
> +		goto err_enc_mem_init;
> +	}
> +
> +	dev->encode_workqueue =
> +			alloc_ordered_workqueue(MTK_VCODEC_ENC_NAME, WQ_MEM_RECLAIM | WQ_FREEZABLE);
> +	if (!dev->encode_workqueue) {
> +		mtk_v4l2_err("Failed to create encode workqueue\n");
> +		ret = -EINVAL;
> +		goto err_event_workq;
> +	}
> +
> +	return 0;
> +
> +err_event_workq:
> +	v4l2_m2m_release(dev->m2m_dev_enc);
> +err_enc_mem_init:
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +err_vb2_ctx_init:
> +	video_unregister_device(vfd_enc);
> +err_enc_reg:
> +	video_device_release(vfd_enc);
> +err_enc_alloc:
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +err_res:
> +	mtk_vcodec_release_enc_pm(dev);
> +	return ret;
> +}
> +
> +static const struct of_device_id mtk_vcodec_match[] = {
> +	{.compatible = "mediatek,mt8173-vcodec-enc",},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, mtk_vcodec_match);
> +
> +static int mtk_vcodec_remove(struct platform_device *pdev)
> +{
> +	struct mtk_vcodec_dev *dev = platform_get_drvdata(pdev);
> +
> +	mtk_v4l2_debug_enter();
> +	flush_workqueue(dev->encode_workqueue);
> +	destroy_workqueue(dev->encode_workqueue);
> +	if (dev->m2m_dev_enc)
> +		v4l2_m2m_release(dev->m2m_dev_enc);
> +	if (dev->alloc_ctx)
> +		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> +
> +	if (dev->vfd_enc) {
> +		video_unregister_device(dev->vfd_enc);
> +		video_device_release(dev->vfd_enc);
> +	}
> +	v4l2_device_unregister(&dev->v4l2_dev);
> +	mtk_vcodec_release_enc_pm(dev);
> +	return 0;
> +}
> +
> +static struct platform_driver mtk_vcodec_driver = {
> +	.probe	= mtk_vcodec_probe,
> +	.remove	= mtk_vcodec_remove,
> +	.driver	= {
> +		.name	= MTK_VCODEC_ENC_NAME,
> +		.owner	= THIS_MODULE,
> +		.of_match_table = mtk_vcodec_match,
> +	},
> +};
> +
> +module_platform_driver(mtk_vcodec_driver);
> +
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Mediatek video codec V4L2 driver");

<snip>

Regards,

	Hans
