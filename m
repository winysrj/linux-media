Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:58914 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab3EJO0U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 10:26:20 -0400
Date: Fri, 10 May 2013 16:33:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: WARNING: at drivers/media/v4l2-core/videobuf2-core.c:2065
 vb2_queue_init+0x74/0x142()
Message-ID: <20130510143300.GC22942@pd.tnic>
References: <20130508201118.GH30955@pd.tnic>
 <201305101406.50935.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201305101406.50935.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 10, 2013 at 02:06:50PM +0200, Hans Verkuil wrote:
> Can you try this patch? This should fix it.

Yep, it does.

Tested-by: Borislav Petkov <bp@suse.de>

> diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
> index 06231b8..d12bd33 100644
> --- a/drivers/media/parport/bw-qcam.c
> +++ b/drivers/media/parport/bw-qcam.c
> @@ -687,6 +687,7 @@ static int buffer_finish(struct vb2_buffer *vb)
>  
>  	parport_release(qcam->pdev);
>  	mutex_unlock(&qcam->lock);
> +	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
>  	if (len != size)
>  		vb->state = VB2_BUF_STATE_ERROR;
>  	vb2_set_plane_payload(vb, 0, len);
> @@ -964,6 +965,7 @@ static struct qcam *qcam_init(struct parport *port)
>  	q->drv_priv = qcam;
>  	q->ops = &qcam_video_qops;
>  	q->mem_ops = &vb2_vmalloc_memops;
> +	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;

However, just FYI: I do trigger the warning in a guest and not on the
real hardware. So I can't really confirm whether _MONOTONIC is the
proper timestamp type or not. But it looks like you know what you're
doing. :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
