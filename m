Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48267 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZHKMXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 08:23:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
Subject: Re: [PATCH] V4L: videobuf-core.c VIDIOC_QBUF should return video buffer flags
Date: Tue, 11 Aug 2009 12:29:36 +0200
Cc: linux-media@vger.kernel.org, sailus@maxwell.research.nokia.com,
	"Zutshi Vimarsh (Nokia-D/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Lasse.Laukkanen@digia.com
References: <200908102037.40140.tuukka.o.toivonen@nokia.com>
In-Reply-To: <200908102037.40140.tuukka.o.toivonen@nokia.com>
MIME-Version: 1.0
Message-Id: <200908111229.36230.laurent.pinchart@ideasonboard.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 10 August 2009 19:37:40 Tuukka.O Toivonen wrote:
> When user space queues a buffer using VIDIOC_QBUF, the kernel
> should set flags to V4L2_BUF_FLAG_QUEUED in struct v4l2_buffer.
> videobuf_qbuf() was missing a call to videobuf_status() which does
> that. This patch adds the proper function call.
>
> Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>

I was a bit surprised, as I didn't think VIDIOC_QBUF was supposed to update 
the buffer structure, but according to the v4l2 spec it is.

However, I don't think calling videobuf_status() is the right thing to do. It 
will update fields that don't make sense at this point, such as 
v4l2_buffer::timestamp.

Thanks Tuukka for finding this, I'll update the UVC video driver 
accordingly :-)

> ---
>  drivers/media/video/videobuf-core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/videobuf-core.c
> b/drivers/media/video/videobuf-core.c index b7b0584..d212710 100644
> --- a/drivers/media/video/videobuf-core.c
> +++ b/drivers/media/video/videobuf-core.c
> @@ -565,6 +565,8 @@ int videobuf_qbuf(struct videobuf_queue *q,
>  		spin_unlock_irqrestore(q->irqlock, flags);
>  	}
>  	dprintk(1, "qbuf: succeded\n");
> +	memset(b, 0, sizeof(*b));
> +	videobuf_status(q, b, buf, q->type);
>  	retval = 0;
>  	wake_up_interruptible_sync(&q->wait);

-- 
Laurent Pinchart
