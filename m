Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28DCC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 10:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96F032146F
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 10:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfBSKCw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 05:02:52 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36466 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbfBSKCw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 05:02:52 -0500
Received: from [IPv6:2001:420:44c1:2579:b8fa:fb10:b19b:d205] ([IPv6:2001:420:44c1:2579:b8fa:fb10:b19b:d205])
        by smtp-cloud9.xs4all.net with ESMTPA
        id w2EhgYa0EI8AWw2EkgF5cM; Tue, 19 Feb 2019 11:02:50 +0100
Subject: Re: [PATCH v2 08/10] media: vicodec: call v4l2_m2m_buf_copy_metadata
 also upon error
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190215130509.86290-1-dafna3@gmail.com>
 <20190215130509.86290-9-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3c69f645-1284-f495-39cd-01086e9aea19@xs4all.nl>
Date:   Tue, 19 Feb 2019 11:02:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190215130509.86290-9-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNVhVlIRAgt1oRzbDfxSjlcU7vfYnoyatLLmEb7vn2G8FtTNMY3Hmfq8+Dqd2yL2EK3R3AA5YWJIKx9KUfEoknZ1dyzCWoq/Lv+4EonYqU8JPLOuBMvJ
 BdU7jYkBQS3EHYhVJ4Suv8nnmP2rqteIWg9qP3ib4UtwNblYOYiKAocun+LTHJzVoDSXRfV7kps9gRUp1agpSlhG58th9AqvFdz/HIXfXrYFB3eciSaaPlYF
 OBG+j/dEkp0FVJy1poH7Al7JW+xQLcc3fXd86VdniS223tDQtiHvkb1BJ6jpOQiSOWE6AM+MukhBeDjfzq5v8ug37RsrEli5Ji6hvQRclJEraWAivFJD9E6J
 u+jgNz92
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/15/19 2:05 PM, Dafna Hirschfeld wrote:
> call v4l2_m2m_buf_copy_metadata also if decoding/encoding
> ends with status VB2_BUF_STATE_ERROR.

Is this a bug fix? Why is this needed?

The commit log can use a bit more work :-)

Also, I don't think this has anything to do with the stateless codec,
so I would move this before patch 6 in the patch series.

Regards,

	Hans

> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index e4139f6b0348..031aaf83839c 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -165,12 +165,10 @@ static int device_process(struct vicodec_ctx *ctx,
>  			  struct vb2_v4l2_buffer *dst_vb)
>  {
>  	struct vicodec_dev *dev = ctx->dev;
> -	struct vicodec_q_data *q_dst;
>  	struct v4l2_fwht_state *state = &ctx->state;
>  	u8 *p_src, *p_dst;
>  	int ret;
>  
> -	q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
>  	if (ctx->is_enc)
>  		p_src = vb2_plane_vaddr(&src_vb->vb2_buf, 0);
>  	else
> @@ -192,8 +190,10 @@ static int device_process(struct vicodec_ctx *ctx,
>  			return ret;
>  		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, ret);
>  	} else {
> +		struct vicodec_q_data *q_dst;
>  		unsigned int comp_frame_size = ntohl(ctx->state.header.size);
>  
> +		q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
>  		if (comp_frame_size > ctx->comp_max_size)
>  			return -EINVAL;
>  		state->info = q_dst->info;
> @@ -204,11 +204,6 @@ static int device_process(struct vicodec_ctx *ctx,
>  
>  		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, q_dst->sizeimage);
>  	}
> -
> -	dst_vb->sequence = q_dst->sequence++;
> -	dst_vb->flags &= ~V4L2_BUF_FLAG_LAST;
> -	v4l2_m2m_buf_copy_metadata(src_vb, dst_vb, !ctx->is_enc);
> -
>  	return 0;
>  }
>  
> @@ -282,16 +277,22 @@ static void device_run(void *priv)
>  	struct vicodec_ctx *ctx = priv;
>  	struct vicodec_dev *dev = ctx->dev;
>  	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> -	struct vicodec_q_data *q_src;
> +	struct vicodec_q_data *q_src, *q_dst;
>  	u32 state;
>  
>  	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
>  	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
>  	q_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
>  
>  	state = VB2_BUF_STATE_DONE;
>  	if (device_process(ctx, src_buf, dst_buf))
>  		state = VB2_BUF_STATE_ERROR;
> +	else
> +		dst_buf->sequence = q_dst->sequence++;
> +	dst_buf->flags &= ~V4L2_BUF_FLAG_LAST;
> +	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf, !ctx->is_enc);
> +
>  	ctx->last_dst_buf = dst_buf;
>  
>  	spin_lock(ctx->lock);
> 

