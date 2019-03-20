Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F23C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 15:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47BCE2146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 15:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfCTPAl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 11:00:41 -0400
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:46213 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbfCTPAk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 11:00:40 -0400
Received: from [IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e] ([IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 6chohdtuQeXb86chphD1sx; Wed, 20 Mar 2019 16:00:38 +0100
Subject: Re: [PATCH v4] Add following V4L2 QP parameters for H.264: *
 V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP *
 V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP *
 V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP *
 V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP
To:     Fish Lin <linfish@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Smitha T Murthy <smitha.t@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190128072948.45788-1-linfish@google.com>
 <20190315084021.3572-1-linfish@google.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <ef29126b-c118-f91f-3b23-c5103bad232a@xs4all.nl>
Date:   Wed, 20 Mar 2019 16:00:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190315084021.3572-1-linfish@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEUxzkJ2cIXlmv8EMcwunJB9fCwILe6xzJ6W6LUw0iJTsT83opMXrNQPKWYm3GnT3sk1hv+EXm/apYXclJz4OvKgRFtEzAWI1JNRqO5AVuG9y17yzSGZ
 /+vRjr2GH35qu9n0wtgDKVmTvd8pILU4l7tHAhPdTWPJG2TIFn/pb6j2a3avRgsx+UfihL8h7nnt5ae+//39zNjJ2flzWVByfMTmUlkUUuppenD8gIr2YJm7
 S6pDFZac9+x2n3ENtebKXqVs13OJ7+AgWk/18Vz9JMuoAByM7y5ypHeZrIEUoL+81j9d3kPnx+CbDWAufEjc99jOEUfu5fPAzYkpZgpepGQwZh9v92vaPkfJ
 yIVxMo/B/ZSdmk36mrpndoRt9eVzuyRCpboMOMEdCGf0JCQ1Vqy39E59qIJ4CxShyUDtHzBnAqo3w6+BLZQw8YudLQdC/TOaekH5dwAUvGyDz2Tv7FCkDXYP
 ORIQtXCsoN6BX5WE3GDkmbMBSfHf711Z8krexcxxe59MT1ip2b6TNh8tyP9PvgiDjyIUzYYMwnLRs5Gax/89X7diYKgTb7y7hd+7fg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This subject line is insanely long :-)

Please use a short subject line for v5 (i.e. "Add V4L2 QP parameters for H.264")
and mention the actual parameters you are adding in the commit log.

Some more comments below:

On 3/15/19 9:40 AM, Fish Lin wrote:
> These controls will limit QP range for intra and inter frame,
> provide more manual control to improve video encode quality.
> 
> Signed-off-by: Fish Lin <linfish@google.com>
> ---
> Changelog since v3:
> - Put document in ext-ctrls-codec.rst instead of extended-controls.rst
>   (which was previous version).
> 
> Changelog since v2:
> - Add interaction with V4L2_CID_MPEG_VIDEO_H264_MIN/MAX_QP
>   description in the document.
> 
> Changelog since v1:
> - Add description in document.
> 
>  .../media/uapi/v4l/ext-ctrls-codec.rst        | 24 +++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  4 ++++
>  include/uapi/linux/v4l2-controls.h            |  6 +++++
>  3 files changed, 34 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> index c97fb7923be5..de60b2e788eb 100644
> --- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> +++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> @@ -1048,6 +1048,30 @@ enum v4l2_mpeg_video_h264_entropy_mode -
>      Quantization parameter for an B frame for H264. Valid range: from 0
>      to 51.
>  
> +``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP (integer)``
> +    Minimum quantization parameter for H264 I frame, to limit I frame

H264 -> the H264
frame, to -> frame to

Same below.

> +    quality in a range. Valid range: from 0 to 51. If

in -> to

(you limit a value *to* a range, not 'in a range')

Same below.

Regards,

	Hans

> +    V4L2_CID_MPEG_VIDEO_H264_MIN_QP is also set, the quantization parameter
> +    should be chosen to meet both requirements.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP (integer)``
> +    Maximum quantization parameter for H264 I frame, to limit I frame
> +    quality in a range. Valid range: from 0 to 51. If
> +    V4L2_CID_MPEG_VIDEO_H264_MAX_QP is also set, the quantization parameter
> +    should be chosen to meet both requirements.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP (integer)``
> +    Minimum quantization parameter for H264 P frame, to limit P frame
> +    quality in a range. Valid range: from 0 to 51. If
> +    V4L2_CID_MPEG_VIDEO_H264_MIN_QP is also set, the quantization parameter
> +    should be chosen to meet both requirements.
> +
> +``V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP (integer)``
> +    Maximum quantization parameter for H264 P frame, to limit P frame
> +    quality in a range. Valid range: from 0 to 51. If
> +    V4L2_CID_MPEG_VIDEO_H264_MAX_QP is also set, the quantization parameter
> +    should be chosen to meet both requirements.
> +
>  ``V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP (integer)``
>      Quantization parameter for an I frame for MPEG4. Valid range: from 1
>      to 31.
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b79d3bbd8350..115fb8debe23 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -828,6 +828,10 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION:
>  								return "H264 Constrained Intra Pred";
>  	case V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET:	return "H264 Chroma QP Index Offset";
> +	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP:		return "H264 I-Frame Minimum QP Value";
> +	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP:		return "H264 I-Frame Maximum QP Value";
> +	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP:		return "H264 P-Frame Minimum QP Value";
> +	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP:		return "H264 P-Frame Maximum QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 06479f2fb3ae..4421baa84177 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -535,6 +535,12 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type {
>  #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
>  #define V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION	(V4L2_CID_MPEG_BASE+383)
>  #define V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET		(V4L2_CID_MPEG_BASE+384)
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

