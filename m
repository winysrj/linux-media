Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A33C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 09:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3F0C2084D
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 09:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfBYJ0v (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 04:26:51 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:48673 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726376AbfBYJ0v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 04:26:51 -0500
Received: from [IPv6:2001:983:e9a7:1:187c:1a74:db21:99] ([IPv6:2001:983:e9a7:1:187c:1a74:db21:99])
        by smtp-cloud8.xs4all.net with ESMTPA
        id yCX9gKBUO4HFnyCXAgJYBr; Mon, 25 Feb 2019 10:26:48 +0100
Subject: Re: [PATCH v3 15/18] media: vicodec: Introducing stateless fwht defs
 and structs
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190224090234.19723-1-dafna3@gmail.com>
 <20190224090234.19723-16-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <49d7b358-16e6-47ea-52f1-2eeeaf17486b@xs4all.nl>
Date:   Mon, 25 Feb 2019 10:26:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190224090234.19723-16-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHMLXfWgqxtqglNExYGisRVJlUz5s3/omDNclrvdP9VUizXfKGwFgx8++BElDBaCOOGu0nsTxWPAtwCzRApK+uMVcJe6oSOjLkSG36+BLhxLS8M3gIhi
 MdYQHg+eI3QKi7bg8ebPn4VX4vC98xl0SVwg5+EdM/932mZnCP8NVHgtMnKzcqls2TteOc9+g8VAB4PLpJjFbRMAMjKfNI/dfMhvjpSaeidFA51uzvAK3ZHQ
 FVmMu6uf8/Z7vARGGFy+6IVTxpNhpgDWo3Olc+MXCLLp80I2VyS+WmRBwoIpfBLnKrXML8GC0+a8/PMA3SJs0D8Ipgb0alWC1yFD6qlZjbw=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/24/19 10:02 AM, Dafna Hirschfeld wrote:
> Add structs and definitions needed to implement stateless
> decoder for fwht.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 15 +++++---
>  drivers/media/v4l2-core/v4l2-ctrls.c          | 10 ++++++
>  include/media/fwht-ctrls.h                    | 35 +++++++++++++++++++
>  include/media/v4l2-ctrls.h                    |  4 ++-
>  include/uapi/linux/videodev2.h                |  1 +
>  5 files changed, 60 insertions(+), 5 deletions(-)
>  create mode 100644 include/media/fwht-ctrls.h
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 2b71b723862a..869fe33f6f26 100644
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
> @@ -1510,10 +1514,6 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	return vb2_queue_init(dst_vq);
>  }
>  
> -#define VICODEC_CID_CUSTOM_BASE		(V4L2_CID_MPEG_BASE | 0xf000)
> -#define VICODEC_CID_I_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 0)
> -#define VICODEC_CID_P_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 1)
> -
>  static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct vicodec_ctx *ctx = container_of(ctrl->handler,
> @@ -1559,6 +1559,13 @@ static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
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
> index 54d66dbc2a31..bfd51c2c1368 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -849,6 +849,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
>  	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:		return "MPEG-2 Slice Parameters";
>  	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:		return "MPEG-2 Quantization Matrices";
> +	case VICODEC_CID_STATELESS_FWHT:			return "FWHT stateless parameters";
>  
>  	/* VPX controls */
>  	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
> @@ -1303,6 +1304,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
>  		*type = V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
>  		break;
> +	case VICODEC_CID_STATELESS_FWHT:
> +		*type = V4L2_CTRL_TYPE_FWHT_PARAMS;
> +		break;
>  	default:
>  		*type = V4L2_CTRL_TYPE_INTEGER;
>  		break;
> @@ -1669,6 +1673,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
>  		return 0;
>  
> +	case V4L2_CTRL_TYPE_FWHT_PARAMS:
> +		return 0;
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2249,6 +2256,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
>  		elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization);
>  		break;
> +	case V4L2_CTRL_TYPE_FWHT_PARAMS:
> +		elem_size = sizeof(struct v4l2_ctrl_fwht_params);
> +		break;
>  	default:
>  		if (type < V4L2_CTRL_COMPOUND_TYPES)
>  			elem_size = sizeof(s32);
> diff --git a/include/media/fwht-ctrls.h b/include/media/fwht-ctrls.h
> new file mode 100644
> index 000000000000..3e7f411f5f94
> --- /dev/null
> +++ b/include/media/fwht-ctrls.h
> @@ -0,0 +1,35 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * These are the FWHT state controls for use with stateless FWHT
> + * codec drivers.
> + *
> + * It turns out that these structs are not stable yet and will undergo
> + * more changes. So keep them private until they are stable and ready to
> + * become part of the official public API.
> + */
> +
> +#ifndef _FWHT_CTRLS_H_
> +#define _FWHT_CTRLS_H_
> +
> +#define V4L2_CTRL_TYPE_FWHT_PARAMS 0x0105
> +
> +#define VICODEC_CID_CUSTOM_BASE		(V4L2_CID_MPEG_BASE | 0xf000)
> +#define VICODEC_CID_I_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 0)
> +#define VICODEC_CID_P_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 1)
> +#define VICODEC_CID_STATELESS_FWHT	(VICODEC_CID_CUSTOM_BASE + 2)

I think we should make these controls 'official' and part of the public API
(except for the STATELESS_FWHT).

So this becomes:

#define VICODEC_CID_FWHT_I_FRAME_QP		(V4L2_CID_MPEG_BASE + 290)
#define VICODEC_CID_FWHT_P_FRAME_QP		(V4L2_CID_MPEG_BASE + 291)
#define VICODEC_CID_STATELESS_FWHT		(V4L2_CID_MPEG_BASE + 292)

where the first two defines can be added to include/uapi/linux/v4l2-controls.h
(add a comment '/* CIDs for FWHT encoding (vicodec driver) */' before the
defines) and the last define stays in this header.

Regards,

	Hans

> +
> +struct v4l2_ctrl_fwht_params {
> +	__u64 backward_ref_ts;
> +	__u32 version;
> +	__u32 width;
> +	__u32 height;
> +	__u32 flags;
> +	__u32 colorspace;
> +	__u32 xfer_func;
> +	__u32 ycbcr_enc;
> +	__u32 quantization;
> +	__u32 comp_frame_size;
> +};
> +
> +
> +#endif
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index c40dcf79b5b9..4dad20658feb 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -23,10 +23,11 @@
>  #include <media/media-request.h>
>  
>  /*
> - * Include the mpeg2 stateless codec compound control definitions.
> + * Include the mpeg2 and fwht stateless codec compound control definitions.
>   * This will move to the public headers once this API is fully stable.
>   */
>  #include <media/mpeg2-ctrls.h>
> +#include <media/fwht-ctrls.h>
>  
>  /* forward references */
>  struct file;
> @@ -60,6 +61,7 @@ union v4l2_ctrl_ptr {
>  	char *p_char;
>  	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
>  	struct v4l2_ctrl_mpeg2_quantization *p_mpeg2_quantization;
> +	struct v4l2_ctrl_fwht_params *p_fwht_params;
>  	void *p;
>  };
>  
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 97e6a6a968ba..1ac3c22d883a 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -669,6 +669,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
>  #define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC aka H.265 */
>  #define V4L2_PIX_FMT_FWHT     v4l2_fourcc('F', 'W', 'H', 'T') /* Fast Walsh Hadamard Transform (vicodec) */
> +#define V4L2_PIX_FMT_FWHT_STATELESS     v4l2_fourcc('S', 'F', 'W', 'H') /* Stateless FWHT (vicodec) */
>  
>  /*  Vendor-specific formats   */
>  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
> 

