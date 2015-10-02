Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61363 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbbJBMoZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2015 08:44:25 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Andrzej Hajda' <a.hajda@samsung.com>,
	"'open list:ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC)...'"
	<linux-media@vger.kernel.org>
Cc: 'Bartlomiej Zolnierkiewicz' <b.zolnierkie@samsung.com>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jeongtae Park' <jtp.park@samsung.com>,
	'Mauro Carvalho Chehab' <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org
References: <1443787779-18458-1-git-send-email-a.hajda@samsung.com>
 <1443787779-18458-2-git-send-email-a.hajda@samsung.com>
In-reply-to: <1443787779-18458-2-git-send-email-a.hajda@samsung.com>
Subject: RE: [PATCH v2 2/2] s5p-mfc: use MFC_BUF_FLAG_EOS to identify last
 buffers in decoder capture queue
Date: Fri, 02 Oct 2015 14:44:22 +0200
Message-id: <002701d0fd10$1056ea60$3104bf20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

> From: Andrzej Hajda [mailto:a.hajda@samsung.com]
> Sent: Friday, October 02, 2015 2:10 PM
> 
> MFC driver never delivered EOS event to apps feeding constantly its
capture
> buffer with fresh buffers. The patch fixes it by marking last buffers
returned
> by MFC with MFC_BUF_FLAG_EOS flag and firing EOS event on de-queuing
> such buffers.

Checkpatch complains that lines in the description are too long.
WARNING: Possible unwrapped commit description (prefer a maximum 75 chars
per line)
#23:

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi,
> 
> This version is rebased on latest media_tree branch.
> 
> Regards
> Andrzej
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c     |  1 +
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 21 +++++++++++++-------
> -
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 05a31ee..3ffe2ec 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -196,6 +196,7 @@ static void
> s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
>  		vb2_set_plane_payload(&dst_buf->b->vb2_buf, 0, 0);
>  		vb2_set_plane_payload(&dst_buf->b->vb2_buf, 1, 0);
>  		list_del(&dst_buf->list);
> +		dst_buf->flags |= MFC_BUF_FLAG_EOS;
>  		ctx->dst_queue_cnt--;
>  		dst_buf->b->sequence = (ctx->sequence++);
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 1734775..8d3d40c 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -645,17 +645,22 @@ static int vidioc_dqbuf(struct file *file, void
*priv,
> struct v4l2_buffer *buf)
>  		mfc_err("Call on DQBUF after unrecoverable error\n");
>  		return -EIO;
>  	}
> -	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> -		ret = vb2_dqbuf(&ctx->vq_src, buf, file->f_flags &
> O_NONBLOCK);
> -	else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +
> +	switch (buf->type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		return vb2_dqbuf(&ctx->vq_src, buf, file->f_flags &
> O_NONBLOCK);
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>  		ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags &
> O_NONBLOCK);
> -		if (ret == 0 && ctx->state == MFCINST_FINISHED &&
> -				list_empty(&ctx->vq_dst.done_list))
> +		if (ret)
> +			return ret;
> +
> +		if (ctx->state == MFCINST_FINISHED &&
> +		    (ctx->dst_bufs[buf->index].flags & MFC_BUF_FLAG_EOS))
>  			v4l2_event_queue_fh(&ctx->fh, &ev);
> -	} else {
> -		ret = -EINVAL;
> +		return 0;
> +	default:
> +		return -EINVAL;
>  	}
> -	return ret;
>  }
> 
>  /* Export DMA buffer */
> --
> 1.9.1

