Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C5DC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 10:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AF7E214C6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 10:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfAJKho (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 05:37:44 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:51912 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726255AbfAJKho (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 05:37:44 -0500
Received: from [IPv6:2001:420:44c1:2579:595e:33cd:95d8:785f] ([IPv6:2001:420:44c1:2579:595e:33cd:95d8:785f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id hXiUgkdLQNR5yhXiYg61kx; Thu, 10 Jan 2019 11:37:42 +0100
Subject: Re: [PATCH 1/4] media: v4l2-ctrl: Add control to enable h.264
 constrained intra prediction
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20190108171313.1750-1-p.zabel@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5bb5c9b8-703e-75df-6bf9-5d1845cedec0@xs4all.nl>
Date:   Thu, 10 Jan 2019 11:37:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190108171313.1750-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfI2dZh7QS4iBLFtibcqBu1TUcXooXO9RjsNqttVuhShlTvgpQSd8qCD3rsRAniJDRHKlI+pmCIr50y2cDeNQeHAQ91A9Mo+jDtYDfAVOSMBtcrYGWTTO
 mmpzr4Gk7+7ucitTIVo6cBkXCfe9Gts+liN0+tdRLZdt8UfKvvwWqqKqAaKZGXL23bPW/niOL980DOBXCzrctR5jYK24V+ieaBUK9eI1IFuhE4KV8U+4wy8s
 7hdJ0/XRl6n5r/D+9YDF4sZRnSDbfBxj2ebub9GsbXLirmXohQbpqLPcKUmBe6UrPISc5keZgSI0r66fvFAUVoOwj03tcvquHCDLjIcHfZ5zOkxkPZSRlJfu
 hYlNeJp9ftasZws3OiXLUI6eu6o3DhqfchLSC+NU3FqSGhYmZ+I=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/08/19 18:13, Philipp Zabel wrote:
> Allow to enable h.264 constrained intra prediction (macroblocks using
> intra prediction modes are not allowed to use residual data and decoded
> samples of neighboring macroblocks coded using inter prediction modes).
> This control directly corresponds to the constrained_intra_pred_flag
> field in the h.264 picture parameter set.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/media/uapi/v4l/extended-controls.rst | 4 ++++
>  drivers/media/v4l2-core/v4l2-ctrls.c               | 2 ++
>  include/uapi/linux/v4l2-controls.h                 | 1 +
>  3 files changed, 7 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index af4273aa5e85..235d0c293983 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1154,6 +1154,10 @@ enum v4l2_mpeg_video_h264_entropy_mode -
>  ``V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM (boolean)``
>      Enable 8X8 transform for H264. Applicable to the H264 encoder.
>  
> +``V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION (boolean)``
> +    Enable constrained intra prediction for H264. Applicable to the H264
> +    encoder.
> +
>  ``V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB (integer)``
>      Cyclic intra macroblock refresh. This is the number of continuous
>      macroblocks refreshed every frame. Each frame a successive set of
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index e3bd441fa29a..1f2fd279f37d 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -825,6 +825,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:return "H264 Number of HC Layers";
>  	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
>  								return "H264 Set QP Value for HC Layers";
> +	case V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION:
> +								return "H264 Constrained Intra Prediction";

This string is too long. The one above it ("H264 Set QP Value for HC Layers") has exactly 31
characters, which is the maximum. Perhaps abbreviating "Prediction" by "Pred" will work.

>  	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 3dcfc6148f99..fd65c710b144 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -533,6 +533,7 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type {
>  };
>  #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V4L2_CID_MPEG_BASE+381)
>  #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
> +#define V4L2_CID_MPEG_VIDEO_H264_CONSTRAINED_INTRA_PREDICTION	(V4L2_CID_MPEG_BASE+383)
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+400)
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+401)
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+402)
> 

Regards,

	Hans
