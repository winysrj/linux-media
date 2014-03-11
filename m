Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4367 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaCKMbw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 08:31:52 -0400
Message-ID: <531F0208.30102@xs4all.nl>
Date: Tue, 11 Mar 2014 13:31:04 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: k.debski@samsung.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 14/14] v4l: ti-vpe: retain v4l2_buffer flags for captured
 buffers
References: <1393922965-15967-1-git-send-email-archit@ti.com> <1394526833-24805-1-git-send-email-archit@ti.com> <1394526833-24805-15-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-15-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/14 09:33, Archit Taneja wrote:
> The dequed CAPTURE_MPLANE type buffers don't contain the flags that the
> originally queued OUTPUT_MPLANE type buffers have. This breaks compliance.
> 
> Copy the source v4l2_buffer flags to the destination v4l2_buffer flags before
> they are dequed.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/platform/ti-vpe/vpe.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index c884910..f7759e8 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1288,13 +1288,12 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
>  	s_buf = &s_vb->v4l2_buf;
>  	d_buf = &d_vb->v4l2_buf;
>  
> +	d_buf->flags = s_buf->flags;
> +
>  	d_buf->timestamp = s_buf->timestamp;
> -	d_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> -	d_buf->flags |= s_buf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> -	if (s_buf->flags & V4L2_BUF_FLAG_TIMECODE) {
> -		d_buf->flags |= V4L2_BUF_FLAG_TIMECODE;
> +	if (s_buf->flags & V4L2_BUF_FLAG_TIMECODE)
>  		d_buf->timecode = s_buf->timecode;
> -	}
> +
>  	d_buf->sequence = ctx->sequence;
>  
>  	d_q_data = &ctx->q_data[Q_DATA_DST];
> 

