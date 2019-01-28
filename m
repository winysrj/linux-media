Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68AC3C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 09:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41A4220880
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 09:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfA1J2l (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:28:41 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:41700 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbfA1J2l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 04:28:41 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id o3DXglgAWBDyIo3DbgnLBR; Mon, 28 Jan 2019 10:28:39 +0100
Subject: Re: [PATCH 2/3] media: vicodec: Introducing stateless fwht defs and
 structs
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190126134759.97680-1-dafna3@gmail.com>
 <20190126134759.97680-3-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8b58f9e2-46f5-8481-3432-d7280c3aad2e@xs4all.nl>
Date:   Mon, 28 Jan 2019 10:28:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190126134759.97680-3-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfB3QBJUqUjbW1wufDr3EZM6gDb6nnSg/e2+wZbUXyl9WHq8+TYdvcpCYLH01GLpuSFYinAJxqpcKwZydQcg43azP/XzEN68AQHkLCA3OiptO4X7pa2T+
 YXtol9bo+/ArAHFwcq5Pm5WLq9wAympalExins7XAF8aYDR9TTeQdDU5vXuHwgLu0EI1Bv1jfRlBS10O9Wlu1PFDgJrCD30pIsKdkNEc/JwIpyc0mdG/ZBbM
 7l4AMCvwTmPh/dyG/WMPAA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/26/19 2:47 PM, Dafna Hirschfeld wrote:
> Add structs and definitions needed to implement stateless
> decoder for fwht.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 12 ++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  6 ++++++
>  include/uapi/linux/v4l2-controls.h            | 10 ++++++++++
>  include/uapi/linux/videodev2.h                |  1 +
>  4 files changed, 29 insertions(+)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 370517707324..25831d992681 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -64,6 +64,10 @@ static const struct v4l2_fwht_pixfmt_info pixfmt_fwht = {
>  	V4L2_PIX_FMT_FWHT, 0, 3, 1, 1, 1, 1, 1, 0, 1
>  };
>  
> +static const struct v4l2_fwht_pixfmt_info pixfmt_stateless_fwht = {
> +	V4L2_PIX_FMT_FWHT_STATELESS, 0, 3, 1, 1, 1, 1, 1, 0, 1
> +};
> +
>  static void vicodec_dev_release(struct device *dev)
>  {
>  }
> @@ -1463,6 +1467,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  #define VICODEC_CID_CUSTOM_BASE		(V4L2_CID_MPEG_BASE | 0xf000)
>  #define VICODEC_CID_I_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 0)
>  #define VICODEC_CID_P_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 1)
> +#define VICODEC_CID_STATELESS_FWHT	(VICODEC_CID_CUSTOM_BASE + 2)
>  
>  static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> @@ -1509,6 +1514,13 @@ static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
>  	.step = 1,
>  };
>  
> +static const struct v4l2_ctrl_config vicodec_ctrl_stateless_state = {
> +	.id		= VICODEC_CID_STATELESS_FWHT,
> +	.elem_size	= sizeof(struct v4l2_ctrl_fwht_params),
> +	.name		= "FWHT-Stateless State Params",
> +	.type		= V4L2_CTRL_TYPE_FWHT_PARAMS,
> +};
> +
>  /*
>   * File operations
>   */
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 99308dac2daa..b05e51312430 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1669,6 +1669,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
>  		return 0;
>  
> +	case V4L2_CTRL_TYPE_FWHT_PARAMS:
> +		return 0;
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2249,6 +2252,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
>  		elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization);
>  		break;
> +	case V4L2_CTRL_TYPE_FWHT_PARAMS:
> +		elem_size = sizeof(struct v4l2_ctrl_fwht_params);
> +		break;
>  	default:
>  		if (type < V4L2_CTRL_COMPOUND_TYPES)
>  			elem_size = sizeof(s32);
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 06479f2fb3ae..2d6e91cb615a 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -52,6 +52,7 @@
>  
>  #include <linux/types.h>
>  
> +#define V4L2_CTRL_TYPE_FWHT_PARAMS 0x0105
>  /* Control classes */
>  #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
>  #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
> @@ -1096,4 +1097,13 @@ enum v4l2_detect_md_mode {
>  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
>  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
>  
> +struct v4l2_ctrl_fwht_params {
> +	__u32 flags;
> +	__u32 colorspace;
> +	__u32 xfer_func;
> +	__u32 ycbcr_enc;
> +	__u32 quantization;
> +	__u64 backward_ref_ts;

It is best if backward_ref_ts is moved to the beginning of the struct.

The problem here is that 64 bit fields are aligned to an 8 byte
boundary and so a 4 byte hole is inserted before backward_ref_ts. Also,
the i686 architecture is different from most other 32 bit architectures
in that it aligns 64 bit values to a 4 byte boundary. As a result using
this structure will require a 32 bit to 64 bit conversion since the
layout is different.

To avoid all this mess it is best to always place 64 bit values at a
proper 8 byte alignment.

> +};
> +
>  #endif
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 9a920f071ff9..37ac240eba01 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -665,6 +665,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
>  #define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC aka H.265 */
>  #define V4L2_PIX_FMT_FWHT     v4l2_fourcc('F', 'W', 'H', 'T') /* Fast Walsh Hadamard Transform (vicodec) */
> +#define V4L2_PIX_FMT_FWHT_STATELESS     v4l2_fourcc('S', 'F', 'W', 'H') /* Stateless FWHT (vicodec) */
>  
>  /*  Vendor-specific formats   */
>  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
> 

Regards,

	Hans
