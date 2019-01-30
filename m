Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB77C282D5
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 645E520882
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfA3H5G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 02:57:06 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:48390 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbfA3H5G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 02:57:06 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id okjzgz2USBDyIokk3gtsND; Wed, 30 Jan 2019 08:57:04 +0100
Subject: Re: [PATCH v2] [media] v4l: add I / P frame min max QP definitions
To:     Fish Lin <linfish@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Keiichi Watanabe <keiichiw@chromium.org>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Will Deacon <will.deacon@arm.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
References: <20190128072948.45788-1-linfish@google.com>
 <20190130074522.155770-1-linfish@google.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <6de7d597-f89a-e20d-a1fd-3f683f4916b8@xs4all.nl>
Date:   Wed, 30 Jan 2019 08:56:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190130074522.155770-1-linfish@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfM7j2IZ7eCBTkkcrymeu6C7i+oWGfJp/BxsHFOpbkzs0KC84CMacwW7lkeoQim44oh6dUqEguYfRR7+FJgTDvtR1bSDVVy5FHtGAiHSs64cYOlXac0J0
 99ZPiqSM1SPKmqmk7DDXi1udOjNAjzR4hvc6vWucVFWChsUiULv7efByp9zPXByGkSXOmVYTMzNL0/LmSEoSjAY1iQ3dt2gMJcAC/ysE9Za1uokCBfih5EK8
 G6zLJCUQVDHwrovechF71m21y/mdogt+z7gQrdbs8cIiPWVrL4ZOvNN3cLnTO4LCG4g2AqhkwKhPbCJ3KAsW3EQJF6usX2G98CVMCVz28ZV2nkp8NnMvblJf
 vwKnWghv3t8Dn2lw5U1sn1rSDIfyFyhfpUQFxKAodIPQF6Dv6VBy2y71umsAxZYMl/EwCfJYA7x+TzZlxa8So/+whud2EXYKue9wwjjtvOQo1sf5TldbtcFm
 sV6DpgHI2br7kEQtVZVF9efbs+Yf3uN01AilBKwVkBGrUdZgIbnYWvhItmg=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/30/19 8:45 AM, Fish Lin wrote:
> Add following V4L2 QP parameters for H.264:
>  * V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP
>  * V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP
>  * V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP
>  * V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP
> 
> These controls will limit QP range for intra and inter frame,
> provide more manual control to improve video encode quality.

How will this interact with V4L2_CID_MPEG_VIDEO_H264_MIN/MAX_QP?

Or are drivers supposed to have either V4L2_CID_MPEG_VIDEO_H264_MIN/MAX_QP
or these new controls? If so, then that should be documented.

Regards,

	Hans

> 
> Signed-off-by: Fish Lin <linfish@google.com>
> ---
> Changelog since v1:
> - Add description in document.
> 
>  .../media/uapi/v4l/extended-controls.rst         | 16 ++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c             |  4 ++++
>  include/uapi/linux/v4l2-controls.h               |  6 ++++++
>  3 files changed, 26 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index 286a2dd7ec36..f5989fad34f9 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1214,6 +1214,22 @@ enum v4l2_mpeg_video_h264_entropy_mode -
>      Quantization parameter for an B frame for H264. Valid range: from 0
>      to 51.
>  
> +``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP (integer)``
> +    Minimum quantization parameter for H264 I frame, to limit I frame
> +    quality in a range. Valid range: from 0 to 51.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP (integer)``
> +    Maximum quantization parameter for H264 I frame, to limit I frame
> +    quality in a range. Valid range: from 0 to 51.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP (integer)``
> +    Minimum quantization parameter for H264 P frame, to limit P frame
> +    quality in a range. Valid range: from 0 to 51.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP (integer)``
> +    Maximum quantization parameter for H264 P frame, to limit P frame
> +    quality in a range. Valid range: from 0 to 51.
> +
>  ``V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP (integer)``
>      Quantization parameter for an I frame for MPEG4. Valid range: from 1
>      to 31.
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 5e3806feb5d7..e2b0af0d2283 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -825,6 +825,10 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:return "H264 Number of HC Layers";
>  	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
>  								return "H264 Set QP Value for HC Layers";
> +	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP:		return "H264 I-Frame Minimum QP Value";
> +	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP:		return "H264 I-Frame Maximum QP Value";
> +	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP:		return "H264 P-Frame Minimum QP Value";
> +	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP:		return "H264 P-Frame Maximum QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 3dcfc6148f99..9519673e6437 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -533,6 +533,12 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type {
>  };
>  #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V4L2_CID_MPEG_BASE+381)
>  #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
> +
> +#define V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP	(V4L2_CID_MPEG_BASE+390)
> +#define V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP	(V4L2_CID_MPEG_BASE+391)
> +#define V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP	(V4L2_CID_MPEG_BASE+392)
> +#define V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP	(V4L2_CID_MPEG_BASE+393)
> +
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+400)
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+401)
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+402)
> 

