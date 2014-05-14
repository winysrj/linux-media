Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3180 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaENHJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 03:09:44 -0400
Message-ID: <53731693.80002@xs4all.nl>
Date: Wed, 14 May 2014 09:09:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
CC: k.debski@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, arunkk.samsung@gmail.com
Subject: Re: [PATCH v2] [media] s5p-mfc: Dequeue sequence header after STREAMON
References: <1400048996-726-1-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400048996-726-1-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2014 08:29 AM, Arun Kumar K wrote:
> MFCv6 encoder needs specific minimum number of buffers to
> be queued in the CAPTURE plane. This minimum number will
> be known only when the sequence header is generated.
> So we used to allow STREAMON on the CAPTURE plane only after
> sequence header is generated and checked with the minimum
> buffer requirement.
> 
> But this causes a problem that we call a vb2_buffer_done
> for the sequence header buffer before doing a STREAON on the
> CAPTURE plane. 

How could this ever have worked? Buffers aren't queued to the driver until
STREAMON is called, and calling vb2_buffer_done for a buffer that is not queued
first to the driver will mess up internal data (q->queued_count for one).

> This used to still work fine until this patch
> was merged -
> b3379c6 : vb2: only call start_streaming if sufficient buffers are queued

Are you testing with CONFIG_VIDEO_ADV_DEBUG set? If not, you should do so. That
will check whether all the vb2 calls are balanced.

BTW, that's a small typo in s5p_mfc_enc.c (search for 'inavlid').

> This problem should also come in earlier MFC firmware versions
> if the application calls STREAMON on CAPTURE with some delay
> after doing STREAMON on OUTPUT.

You can also play around with the min_buffers_needed field. My rule-of-thumb is that
when start_streaming is called everything should be ready to stream. It is painful
for drivers to have to keep track of the 'do I have enough buffers' status.

For that reason I introduced the min_buffers_needed field. What I believe you can
do here is to set it initially to a large value, preventing start_streaming from
being called, and once you really know the minimum number of buffers that you need
it can be updated again to the actual value.

I don't know this driver well enough to tell whether that works here or not, but
it is worth looking at IMHO.

Regards,

	Hans

> So this patch keeps the header buffer until the other frame
> buffers are ready and dequeues it just before the first frame
> is ready.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
> Changes from v1
> - Addressed review comments from Sachin
>   https://patchwork.linuxtv.org/patch/23839/
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |    6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index f5404a6..cc2b96e 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -523,6 +523,7 @@ struct s5p_mfc_codec_ops {
>   * @output_state:	state of the output buffers queue
>   * @src_bufs:		information on allocated source buffers
>   * @dst_bufs:		information on allocated destination buffers
> + * @header_mb:		buffer pointer of the encoded sequence header
>   * @sequence:		counter for the sequence number for v4l2
>   * @dec_dst_flag:	flags for buffers queued in the hardware
>   * @dec_src_buf_size:	size of the buffer for source buffers in decoding
> @@ -607,6 +608,7 @@ struct s5p_mfc_ctx {
>  	int src_bufs_cnt;
>  	struct s5p_mfc_buf dst_bufs[MFC_MAX_BUFFERS];
>  	int dst_bufs_cnt;
> +	struct s5p_mfc_buf *header_mb;
>  
>  	unsigned int sequence;
>  	unsigned long dec_dst_flag;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index f8c7053..0c8d593e 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -787,7 +787,7 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
>  		ctx->dst_queue_cnt--;
>  		vb2_set_plane_payload(dst_mb->b, 0,
>  			s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev));
> -		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
> +		ctx->header_mb = dst_mb;
>  		spin_unlock_irqrestore(&dev->irqlock, flags);
>  	}
>  
> @@ -845,6 +845,10 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
>  	unsigned int strm_size;
>  	unsigned long flags;
>  
> +	if (ctx->header_mb) {
> +		vb2_buffer_done(ctx->header_mb->b, VB2_BUF_STATE_DONE);
> +		ctx->header_mb = NULL;
> +	}
>  	slice_type = s5p_mfc_hw_call(dev->mfc_ops, get_enc_slice_type, dev);
>  	strm_size = s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev);
>  	mfc_debug(2, "Encoded slice type: %d\n", slice_type);
> 

