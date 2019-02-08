Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2330C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A15A821924
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfBHJ6a (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 04:58:30 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:53605 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbfBHJ6a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 04:58:30 -0500
Received: from [IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a] ([IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id s2vSgzDDMBDyIs2vTgLrxf; Fri, 08 Feb 2019 10:58:28 +0100
Subject: Re: [PATCH v3] [media] v4l: add I / P frame min max QP definitions
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
 <20190130091116.256989-1-linfish@google.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <66239266-1d83-8fde-1cd2-632be8f1d0e5@xs4all.nl>
Date:   Fri, 8 Feb 2019 10:58:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190130091116.256989-1-linfish@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMItpaICBbtrhJ9KY159HKCvJST/ZaExwYr3iE79hTxuqO1rNlVNvrBQ/hAl2z/BPANjzp8Z0svaMf8JK4UrBH1kEuVoh/nzcyk+CzbUxGqNPjPmhBMN
 EhXeriXXz8sb99G91Ngl4vEJpJ6uHovoycvajmPbeTT1SPlJHm7hVh7kDDqu2okRRFuaT2Dp3ixHQmQJecpHAqR2ijvI3IJ8j8HXeF7bqvl3QGiAkEQX9N+u
 HL7C5Mk9ireA6sCZL3YZPig6g8lnYD80KbzPWEhBaCIWlZ6kmPCan2/nUUk61RAC7yrC3HkiJEt736gJ3M9shioQoepXEwbQrYBZWNf4S1jjZmnLPj6R77Lh
 w0olC2svo/GuPsnQxtZcBSmUhOEMNzGfd1SGGGDDASXN2+qYMcyyp8PCo/lL4HT9ovWXtpIxNG/qvKIItWt+S1uI0RuGVbvt9Xefz1EnhxHdcPYNelTy3uwi
 sY3NNICPHEv+sO7X3brYaiFsjiejqutidvCn8uWVeWJ4zwHGjOmKrfXuXfZahobjEWTKIRFQQo7m0UZEealAHz3DvGO7IrKpNiVs3XEwqKZ/VWXojOCzv3R+
 T9JcI0Ux/RxXrUsNPWMLRSjW2S9annOfYYkKBaCsQ9RppA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/30/19 10:11 AM, Fish Lin wrote:
> Add following V4L2 QP parameters for H.264:
>  * V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP
>  * V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP
>  * V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP
>  * V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP
> 
> These controls will limit QP range for intra and inter frame,
> provide more manual control to improve video encode quality.
> 
> Signed-off-by: Fish Lin <linfish@google.com>
> ---
> Changelog since v2:
> - Add interaction with V4L2_CID_MPEG_VIDEO_H264_MIN/MAX_QP
>   description in the document.
> 
> Changelog since v1:
> - Add description in document.
> 
>  .../media/uapi/v4l/extended-controls.rst      | 24 +++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  4 ++++
>  include/uapi/linux/v4l2-controls.h            |  6 +++++
>  3 files changed, 34 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index 286a2dd7ec36..402e41eb24ee 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1214,6 +1214,30 @@ enum v4l2_mpeg_video_h264_entropy_mode -
>      Quantization parameter for an B frame for H264. Valid range: from 0
>      to 51.
>  
> +``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP (integer)``
> +    Minimum quantization parameter for H264 I frame, to limit I frame
> +    quality in a range. Valid range: from 0 to 51. If
> +    V4L2_CID_MPEG_VIDEO_H264_MIN_QP is set, the quantization parameter

is set -> is also set

> +    should be chosen to meet both of the requirement.

both of the requirement -> both requirements

Ditto for the other three controls below.

However, you might want to wait a little bit since I have this patch pending:

https://patchwork.linuxtv.org/patch/54388/

which will require a rebase of your patch anyway.

Regards,

	Hans

> +
> +``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP (integer)``
> +    Maximum quantization parameter for H264 I frame, to limit I frame
> +    quality in a range. Valid range: from 0 to 51. If
> +    V4L2_CID_MPEG_VIDEO_H264_MAX_QP is set, the quantization parameter
> +    should be chosen to meet both of the requirement.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP (integer)``
> +    Minimum quantization parameter for H264 P frame, to limit P frame
> +    quality in a range. Valid range: from 0 to 51. If
> +    V4L2_CID_MPEG_VIDEO_H264_MIN_QP is set, the quantization parameter
> +    should be chosen to meet both of the requirement.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP (integer)``
> +    Maximum quantization parameter for H264 P frame, to limit P frame
> +    quality in a range. Valid range: from 0 to 51. If
> +    V4L2_CID_MPEG_VIDEO_H264_MAX_QP is set, the quantization parameter
> +    should be chosen to meet both of the requirement.
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

