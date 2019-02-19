Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557C1C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 10:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D38021773
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 10:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfBSKpp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 05:45:45 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:46599 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727991AbfBSKpp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 05:45:45 -0500
Received: from [IPv6:2001:420:44c1:2579:b8fa:fb10:b19b:d205] ([IPv6:2001:420:44c1:2579:b8fa:fb10:b19b:d205])
        by smtp-cloud9.xs4all.net with ESMTPA
        id w2uBgZ2uAI8AWw2uEgFHW0; Tue, 19 Feb 2019 11:45:43 +0100
Subject: Re: [PATCH v2 06/10] media: vicodec: Introducing stateless fwht defs
 and structs
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190215130509.86290-1-dafna3@gmail.com>
 <20190215130509.86290-7-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <44906c0a-6126-a3c5-00c8-75b61966512f@xs4all.nl>
Date:   Tue, 19 Feb 2019 11:45:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190215130509.86290-7-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIHEs/u+SgaKN+ze/I+DGh3xe4ozNe2h0EOv2ZPhksN58QGVwgliOxWRv6WA6rh4fq5AxeVfmbKntmvUPOKa365je5eRHedYgRTjMI8D34VW5DfV15il
 IfhgB+yz04tlybw+oV6sHtwv7GS6ZkMh0qX0pLCpz45whYVZvcwqZzQCmv/mN/3/nw6woXPXCI4SI55nAsR4Usm1fcoqZ/167X2LlBHjomUZunMjsAEyX2oK
 4rUIZbd3xGemPi1VGzR5Sxij3w30fSOY9+HAl8cUXVk5nw0WOe764REtoYHWBGeMzczfFgkA8xcO/Fd4hPuGIvjPrbImdZaxq+k7dtXeJjkxhLF1RXTmjSnR
 fKAYh6gS
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/15/19 2:05 PM, Dafna Hirschfeld wrote:
> Add structs and definitions needed to implement stateless
> decoder for fwht.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 12 ++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  6 ++++++
>  include/uapi/linux/v4l2-controls.h            | 13 +++++++++++++
>  include/uapi/linux/videodev2.h                |  1 +
>  4 files changed, 32 insertions(+)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 5e5bbc99a8bb..79b69faf3983 100644
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
> @@ -1480,6 +1484,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  #define VICODEC_CID_CUSTOM_BASE		(V4L2_CID_MPEG_BASE | 0xf000)
>  #define VICODEC_CID_I_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 0)
>  #define VICODEC_CID_P_FRAME_QP		(VICODEC_CID_CUSTOM_BASE + 1)
> +#define VICODEC_CID_STATELESS_FWHT	(VICODEC_CID_CUSTOM_BASE + 2)
>  
>  static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> @@ -1526,6 +1531,13 @@ static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
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
> index ff75f84011f8..5f2382f3a1a2 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1671,6 +1671,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
>  		return 0;
>  
> +	case V4L2_CTRL_TYPE_FWHT_PARAMS:
> +		return 0;
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2251,6 +2254,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
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
> index 06479f2fb3ae..0358a3b22391 100644
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
> @@ -1096,4 +1097,16 @@ enum v4l2_detect_md_mode {
>  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
>  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
>  
> +struct v4l2_ctrl_fwht_params {
> +	__u64 backward_ref_ts;
> +	__u32 width;
> +	__u32 height;
> +	__u32 flags;
> +	__u32 colorspace;
> +	__u32 xfer_func;
> +	__u32 ycbcr_enc;
> +	__u32 quantization;
> +	__u32 comp_frame_size;
> +};

This should also be added to the union v4l2_ctrl_ptr in include/media/v4l2-ctrls.h.
Same as v4l2_ctrl_mpeg2_slice_params.

Regards,

	Hans

> +
>  #endif
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index a78bfdc1df97..6a692114e989 100644
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

