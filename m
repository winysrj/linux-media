Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9846DC43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 12:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B9A12171F
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 12:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731977AbfB1MbD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 07:31:03 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:52429 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731163AbfB1Ma6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 07:30:58 -0500
Received: from [IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a] ([IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zKptgBPp9LMwIzKpugcRHY; Thu, 28 Feb 2019 13:30:56 +0100
Subject: Re: [PATCH v2] media: vim2m: better handle cap/out buffers with
 different sizes
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
References: <8d0a822ce02e1eb95f4a59cc9aabceb5a5661dda.1551202576.git.mchehab+samsung@kernel.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <84696204-2b3a-74ed-f470-52cc54fa201b@xs4all.nl>
Date:   Thu, 28 Feb 2019 13:30:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <8d0a822ce02e1eb95f4a59cc9aabceb5a5661dda.1551202576.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMuYpP0S+84U5T8x/drz96tj5MtnAf4ug+cHh2CYzwsVwMmKTm6Xki4dN/h6CKvcd4UGCE6XTD538z+rSX0Tvna/px+W2avsL84y16N++mDlIKzu1FD9
 WGe1l/7rvgvWYCRgLmFVj7Z30qcDK5+sHPoq+PD7a5leebezBHxxrWlrsowlPQY45kIa+Xe3pet162hmgagl2561FMkZNyd6NapFFclaaEg7YNQp3SyLHfuD
 lUHs7zCbJxojnMtgmOp2l39vFonfOIEXYfP9VdaAUR52FSBJRTaugdwt6DvWMeH7fR3J/uZV/M6ciEXkYAiSRmoc0tYYpmaYH7BZiwPCmMya71zt5M9UkOLs
 fuFI2upg+LST7SC3iCEVLrDbRFgCvsNc3o+58sR5wtlVOI/qNuo=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/26/19 6:36 PM, Mauro Carvalho Chehab wrote:
> The vim2m driver doesn't enforce that the capture and output
> buffers would have the same size. Do the right thing if the
> buffers are different, zeroing the buffer before writing,
> ensuring that lines will be aligned and it won't write past
> the buffer area.

I don't really like this. Since the vimc driver doesn't scale it shouldn't
automatically crop either. If you want to crop/compose, then the
selection API should be implemented.

That would be the right approach to allowing capture and output
formats (we're talking formats here, not buffer sizes) with
different resolutions.

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/platform/vim2m.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index 89384f324e25..46e3e096123e 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -481,7 +481,9 @@ static int device_process(struct vim2m_ctx *ctx,
>  	struct vim2m_dev *dev = ctx->dev;
>  	struct vim2m_q_data *q_data_in, *q_data_out;
>  	u8 *p_in, *p, *p_out;
> -	int width, height, bytesperline, x, y, y_out, start, end, step;
> +	unsigned int width, height, bytesperline, bytesperline_out;
> +	unsigned int x, y, y_out;
> +	int start, end, step;
>  	struct vim2m_fmt *in, *out;
>  
>  	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> @@ -491,8 +493,15 @@ static int device_process(struct vim2m_ctx *ctx,
>  	bytesperline = (q_data_in->width * q_data_in->fmt->depth) >> 3;
>  
>  	q_data_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	bytesperline_out = (q_data_out->width * q_data_out->fmt->depth) >> 3;
>  	out = q_data_out->fmt;
>  
> +	/* Crop to the limits of the destination image */
> +	if (width > q_data_out->width)
> +		width = q_data_out->width;
> +	if (height > q_data_out->height)
> +		height = q_data_out->height;
> +
>  	p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
>  	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
>  	if (!p_in || !p_out) {
> @@ -501,6 +510,10 @@ static int device_process(struct vim2m_ctx *ctx,
>  		return -EFAULT;
>  	}
>  
> +	/* Image size is different. Zero buffer first */
> +	if (q_data_in->width  != q_data_out->width ||
> +	    q_data_in->height != q_data_out->height)
> +		memset(p_out, 0, q_data_out->sizeimage);
>  	out_vb->sequence = get_q_data(ctx,
>  				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
>  	in_vb->sequence = q_data_in->sequence++;
> @@ -524,6 +537,11 @@ static int device_process(struct vim2m_ctx *ctx,
>  		for (x = 0; x < width >> 1; x++)
>  			copy_two_pixels(in, out, &p, &p_out, y_out,
>  					ctx->mode & MEM2MEM_HFLIP);
> +
> +		/* Go to the next line at the out buffer*/

Add space after 'buffer'.

> +		if (width < q_data_out->width)
> +			p_out += ((q_data_out->width - width)
> +				  * q_data_out->fmt->depth) >> 3;
>  	}
>  
>  	return 0;
> @@ -977,12 +995,6 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
>  	dprintk(ctx->dev, 2, "type: %s\n", type_name(vb->vb2_queue->type));
>  
>  	q_data = get_q_data(ctx, vb->vb2_queue->type);
> -	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
> -		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
> -				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
> -		return -EINVAL;
> -	}
> -

As discussed on irc, this can't be removed. It checks if the provided buffer
is large enough for the current format.

Regards,

	Hans

>  	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
>  
>  	return 0;
> 

