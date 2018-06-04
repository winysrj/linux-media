Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:37991 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750868AbeFDMKz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 08:10:55 -0400
Date: Mon, 4 Jun 2018 14:09:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 6/6] media: uvcvideo: Move decode processing to process
 context
In-Reply-To: <cae511f90085701e7093ce39dc8dabf8fc16b844.1522168131.git-series.kieran.bingham@ideasonboard.com>
Message-ID: <alpine.DEB.2.20.1806041407450.23116@axis700.grange>
References: <cover.3cb9065dabdf5d455da508fb4109201e626d5ee7.1522168131.git-series.kieran.bingham@ideasonboard.com> <cae511f90085701e7093ce39dc8dabf8fc16b844.1522168131.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

I've got a question:

On Tue, 27 Mar 2018, Kieran Bingham wrote:

> Newer high definition cameras, and cameras with multiple lenses such as
> the range of stereo-vision cameras now available have ever increasing
> data rates.
> 
> The inclusion of a variable length packet header in URB packets mean
> that we must memcpy the frame data out to our destination 'manually'.
> This can result in data rates of up to 2 gigabits per second being
> processed.
> 
> To improve efficiency, and maximise throughput, handle the URB decode
> processing through a work queue to move it from interrupt context, and
> allow multiple processors to work on URBs in parallel.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> 
> ---
> v2:
>  - Lock full critical section of usb_submit_urb()
> 
> v3:
>  - Fix race on submitting uvc_video_decode_data_work() to work queue.
>  - Rename uvc_decode_op -> uvc_copy_op (Generic to encode/decode)
>  - Rename decodes -> copy_operations
>  - Don't queue work if there is no async task
>  - obtain copy op structure directly in uvc_video_decode_data()
>  - uvc_video_decode_data_work() -> uvc_video_copy_data_work()
> 
> v4:
>  - Provide for_each_uvc_urb()
>  - Simplify fix for shutdown race to flush queue before freeing URBs
>  - Rebase to v4.16-rc4 (linux-media/master) adjusting for metadata
>    conflicts.
> 
>  drivers/media/usb/uvc/uvc_video.c | 107 ++++++++++++++++++++++++-------
>  drivers/media/usb/uvc/uvcvideo.h  |  28 ++++++++-
>  2 files changed, 111 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index 7dd0dcb457f3..a62e8caf367c 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1042,21 +1042,54 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
>  	return data[0];
>  }
>  
> -static void uvc_video_decode_data(struct uvc_streaming *stream,
> +/*
> + * uvc_video_decode_data_work: Asynchronous memcpy processing
> + *
> + * Perform memcpy tasks in process context, with completion handlers
> + * to return the URB, and buffer handles.
> + */
> +static void uvc_video_copy_data_work(struct work_struct *work)
> +{
> +	struct uvc_urb *uvc_urb = container_of(work, struct uvc_urb, work);
> +	unsigned int i;
> +	int ret;
> +
> +	for (i = 0; i < uvc_urb->async_operations; i++) {
> +		struct uvc_copy_op *op = &uvc_urb->copy_operations[i];
> +
> +		memcpy(op->dst, op->src, op->len);
> +
> +		/* Release reference taken on this buffer */
> +		uvc_queue_buffer_release(op->buf);
> +	}
> +
> +	ret = usb_submit_urb(uvc_urb->urb, GFP_ATOMIC);

Does this still have to be ATOMIC now that it's called from a work queue 
context?

> +	if (ret < 0)
> +		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
> +			   ret);
> +}

[snip]

Thannks
Guennadi
