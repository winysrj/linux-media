Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50401 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaB0Lt5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 06:49:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 07/15] vb2: call buf_finish from __dqbuf
Date: Thu, 27 Feb 2014 12:51:17 +0100
Message-ID: <30968653.YUuibDDAk4@avalon>
In-Reply-To: <1393332775-44067-8-git-send-email-hverkuil@xs4all.nl>
References: <1393332775-44067-1-git-send-email-hverkuil@xs4all.nl> <1393332775-44067-8-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 25 February 2014 13:52:47 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This ensures that it is also called from queue_cancel, which also calls
> __dqbuf(). Without this change any time queue_cancel is called while
> streaming the buf_finish op will not be called and any driver cleanup
> will not happen.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index 59bfd85..b5142e5 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1758,6 +1758,8 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
>  	if (vb->state == VB2_BUF_STATE_DEQUEUED)
>  		return;
> 
> +	call_vb_qop(vb, buf_finish, vb);
> +
>  	vb->state = VB2_BUF_STATE_DEQUEUED;
> 
>  	/* unmap DMABUF buffer */
> @@ -1783,8 +1785,6 @@ static int vb2_internal_dqbuf(struct vb2_queue *q,
> struct v4l2_buffer *b, bool n if (ret < 0)
>  		return ret;
> 
> -	call_vb_qop(vb, buf_finish, vb);
> -
>  	switch (vb->state) {
>  	case VB2_BUF_STATE_DONE:
>  		dprintk(3, "dqbuf: Returning done buffer\n");

This will cause an issue with the uvcvideo driver (and possibly others) if I'm 
not mistaken. To give a bit more context, we currently have the following code 
in vb2_internal_dqbuf.

        ret = call_qop(q, buf_finish, vb);
        if (ret) {
                dprintk(1, "dqbuf: buffer finish failed\n");
                return ret;
        }

        switch (vb->state) {
        case VB2_BUF_STATE_DONE:
                dprintk(3, "dqbuf: Returning done buffer\n");
                break;
        case VB2_BUF_STATE_ERROR:
                dprintk(3, "dqbuf: Returning done buffer with errors\n");
                break;
        default:
                dprintk(1, "dqbuf: Invalid buffer state\n");
                return -EINVAL;
        }

        /* Fill buffer information for the userspace */
        __fill_v4l2_buffer(vb, b);
        /* Remove from videobuf queue */
        list_del(&vb->queued_entry);
        /* go back to dequeued state */
        __vb2_dqbuf(vb);

You're thus effectively moving the buf_finish call from before 
__fill_v4l2_buffer() to after it. As the buf_finish operation in uvcvideo 
fills the vb2 timestamp, the timestamp copied to userspace will be wrong.

Other drivers may fill other vb2 fields that need to be copied to userspace as 
well. You should also double check that no driver modifies the vb2 state in 
the buf_finish operation. Expanding the buf_finish documentation to tell what 
drivers are allowed to do could be nice.

-- 
Regards,

Laurent Pinchart

