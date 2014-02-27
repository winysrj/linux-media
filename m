Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50077 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaB0KvG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 05:51:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 03/15] vb2: fix PREPARE_BUF regression
Date: Thu, 27 Feb 2014 11:52:20 +0100
Message-ID: <2857474.2sTDPpVYBC@avalon>
In-Reply-To: <1393332775-44067-4-git-send-email-hverkuil@xs4all.nl>
References: <1393332775-44067-1-git-send-email-hverkuil@xs4all.nl> <1393332775-44067-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 25 February 2014 13:52:43 Hans Verkuil wrote:
> Fix an incorrect test in vb2_internal_qbuf() where only DEQUEUED buffers
> are allowed. But PREPARED buffers are also OK.
> 
> Introduced by commit 4138111a27859dcc56a5592c804dd16bb12a23d1
> ("vb2: simplify qbuf/prepare_buf by removing callback").
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I wonder how I've managed to ack the commit that broke this without noticing 
the problem :-/ Sorry about that.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index f1a2857c..909f367 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1420,11 +1420,6 @@ static int vb2_internal_qbuf(struct vb2_queue *q,
> struct v4l2_buffer *b) return ret;
> 
>  	vb = q->bufs[b->index];
> -	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
> -		dprintk(1, "%s(): invalid buffer state %d\n", __func__,
> -			vb->state);
> -		return -EINVAL;
> -	}
> 
>  	switch (vb->state) {
>  	case VB2_BUF_STATE_DEQUEUED:
> @@ -1438,7 +1433,8 @@ static int vb2_internal_qbuf(struct vb2_queue *q,
> struct v4l2_buffer *b) dprintk(1, "qbuf: buffer still being prepared\n");
>  		return -EINVAL;
>  	default:
> -		dprintk(1, "qbuf: buffer already in use\n");
> +		dprintk(1, "%s(): invalid buffer state %d\n", __func__,
> +			vb->state);
>  		return -EINVAL;
>  	}

-- 
Regards,

Laurent Pinchart

