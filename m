Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A036C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1285B217D9
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 15:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbfBRPOp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:14:45 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:57858 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbfBRPOp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 10:14:45 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id vkcxgbcW54HFnvkd0g0IHq; Mon, 18 Feb 2019 16:14:42 +0100
Subject: Re: [PATCH] media: v4l: ioctl: Sanitize num_planes before using it
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
References: <20190218102542.21776-1-ezequiel@collabora.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <e67041df-07de-c7ea-5848-6cb4db6734f8@xs4all.nl>
Date:   Mon, 18 Feb 2019 16:14:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190218102542.21776-1-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfO0m1MAliWecKQLKmCzyHjCnEudA9U+69waNn8hrmqTQ95SfiXY2X7DE/iyvk6JZ6agbOSGMEuctluUOXLEnb4TFAiyyD/biGNcOCPN7iH6op14pI5G3
 fFAtN67l/SVkhotK6kYWgDqxc8Z5AIRGq0u5L48cA0ICtlrDIgDfF3VYS/0oyxIR0amCTXBMGmS8l8fWfehH41J+Dd4QITXBd9agfW/GeEYmrrLt2GgQvgWx
 d7kf85Of1tp6/X4qDUJNXnIVFdDIwQZToN8wwHRRoj9y4bU0Ki5OWattPg42lOin
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/18/19 11:25 AM, Ezequiel Garcia wrote:
> The linked commit changed s_fmt/try_fmt to fail if num_planes is bogus.
> This, however, is against the spec, which mandates drivers
> to return a proper num_planes value, without an error.
> 
> Replace the num_planes check and instead clamp it to a sane value,
> so we still make sure we don't overflow the planes array by accident.
> 
> Fixes: 9048b2e15b11c5 ("media: v4l: ioctl: Validate num_planes before using it")
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks!

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 90aad465f9ed..206b7348797e 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1017,6 +1017,12 @@ static void v4l_sanitize_format(struct v4l2_format *fmt)
>  {
>  	unsigned int offset;
>  
> +	/* Make sure num_planes is not bogus */
> +	if (fmt->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ||
> +	    fmt->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		fmt->fmt.pix_mp.num_planes = min_t(u32, fmt->fmt.pix_mp.num_planes,
> +					       VIDEO_MAX_PLANES);
> +
>  	/*
>  	 * The v4l2_pix_format structure has been extended with fields that were
>  	 * not previously required to be set to zero by applications. The priv
> @@ -1553,8 +1559,6 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> -		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> -			break;
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i],
>  					  bytesperline);
> @@ -1586,8 +1590,6 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> -		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> -			break;
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i],
>  					  bytesperline);
> @@ -1656,8 +1658,6 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> -		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> -			break;
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i],
>  					  bytesperline);
> @@ -1689,8 +1689,6 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
>  			break;
>  		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> -		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
> -			break;
>  		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
>  			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i],
>  					  bytesperline);
> 

