Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2483 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaEMIAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 04:00:20 -0400
Message-ID: <5371D0ED.4050208@xs4all.nl>
Date: Tue, 13 May 2014 09:59:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
CC: k.debski@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH v4 2/2] [media] s5p-mfc: Add support for resolution change
 event
References: <1399960743-4542-1-git-send-email-arun.kk@samsung.com> <1399960743-4542-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1399960743-4542-3-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/13/14 07:59, Arun Kumar K wrote:
> From: Pawel Osciak <posciak@chromium.org>
> 
> When a resolution change point is reached, queue an event to signal the
> userspace that a new set of buffers is required before decoding can
> continue.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c     |    7 +++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    2 ++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 54f7ba1..2d7d1ae 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -320,6 +320,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
>  	struct s5p_mfc_buf *src_buf;
>  	unsigned long flags;
>  	unsigned int res_change;
> +	struct v4l2_event ev;
>  
>  	dst_frame_status = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
>  				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
> @@ -351,6 +352,12 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
>  		if (ctx->state == MFCINST_RES_CHANGE_FLUSH) {
>  			s5p_mfc_handle_frame_all_extracted(ctx);
>  			ctx->state = MFCINST_RES_CHANGE_END;
> +
> +			memset(&ev, 0, sizeof(struct v4l2_event));
> +			ev.type = V4L2_EVENT_SOURCE_CHANGE;
> +			ev.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION;

I would replace this by:

		static const struct v4l2_event ev_src_ch = {
			.type = V4L2_EVENT_SOURCE_CHANGE,
			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
		};

No need for memsets or filling in structs at runtime.

Regards,

	Hans

> +			v4l2_event_queue_fh(&ctx->fh, &ev);
> +
>  			goto leave_handle_frame;
>  		} else {
>  			s5p_mfc_handle_frame_all_extracted(ctx);
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 4f94491..b383829 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -855,6 +855,8 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
>  	switch (sub->type) {
>  	case V4L2_EVENT_EOS:
>  		return v4l2_event_subscribe(fh, sub, 2, NULL);
> +	case V4L2_EVENT_SOURCE_CHANGE:
> +		return v4l2_src_change_event_subscribe(fh, sub);
>  	default:
>  		return -EINVAL;
>  	}
> 

