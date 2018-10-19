Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:57217 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726584AbeJSPTc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 11:19:32 -0400
Subject: Re: [PATCH 1/2] vicodec: Have decoder propagate changes to the
 CAPTURE queue
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
References: <20181018160841.17674-1-ezequiel@collabora.com>
 <20181018160841.17674-2-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a81e37eb-9d85-7a52-1098-d067c719f1e1@xs4all.nl>
Date: Fri, 19 Oct 2018 09:14:39 +0200
MIME-Version: 1.0
In-Reply-To: <20181018160841.17674-2-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2018 06:08 PM, Ezequiel Garcia wrote:
> The decoder interface (not yet merged) specifies that
> width and height values set on the OUTPUT queue, must
> be propagated to the CAPTURE queue.
> 
> This is not enough to comply with the specification,
> which would require to properly support stream resolution
> changes detection and notification.
> 
> However, it's a relatively small change, which fixes behavior
> required by some applications such as gstreamer.
> 
> With this change, it's possible to run a simple T(T⁻¹) pipeline:
> 
> gst-launch-1.0 videotestsrc ! v4l2fwhtenc ! v4l2fwhtdec ! fakevideosink
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 1eb9132bfc85..a2c487b4b80d 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -673,6 +673,13 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  		q_data->width = pix->width;
>  		q_data->height = pix->height;
>  		q_data->sizeimage = pix->sizeimage;
> +
> +		/* Propagate changes to CAPTURE queue */
> +		if (!ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type)) {

Do we need !ctx->is_enc? Isn't this the same for both decoder and encoder?

> +			ctx->q_data[V4L2_M2M_DST].width = pix->width;
> +			ctx->q_data[V4L2_M2M_DST].height = pix->height;
> +			ctx->q_data[V4L2_M2M_DST].sizeimage = pix->sizeimage;

This is wrong: you are copying the sizeimage for the compressed format as the
sizeimage for the raw format, which is quite different.

I think you need to make a little helper function that can update the width/height
of a particular queue and that can calculate the sizeimage correctly.

Regards,

	Hans

> +		}
>  		break;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> @@ -693,6 +700,14 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
>  		q_data->width = pix_mp->width;
>  		q_data->height = pix_mp->height;
>  		q_data->sizeimage = pix_mp->plane_fmt[0].sizeimage;
> +
> +		/* Propagate changes to CAPTURE queue */
> +		if (!ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type)) {
> +			ctx->q_data[V4L2_M2M_DST].width = pix_mp->width;
> +			ctx->q_data[V4L2_M2M_DST].height = pix_mp->height;
> +			ctx->q_data[V4L2_M2M_DST].sizeimage =
> +				pix_mp->plane_fmt[0].sizeimage;
> +		}
>  		break;
>  	default:
>  		return -EINVAL;
> 
