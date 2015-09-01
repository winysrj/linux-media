Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:12512 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbbIANte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2015 09:49:34 -0400
From: "Kaukab, Yousaf" <yousaf.kaukab@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@osg.samsung.com" <mchehab@osg.samsung.com>
Subject: RE: [RFC PATCH] media: uvcvideo: handle urb completion in a work
 queue
Date: Tue, 1 Sep 2015 13:49:31 +0000
Message-ID: <B1AFEC30BE3ADF488E833B59904F5C321D99B0E6@IRSMSX107.ger.corp.intel.com>
References: <1441100711-24519-1-git-send-email-yousaf.kaukab@intel.com>
 <1485166.QsN4P3lvAb@avalon>
In-Reply-To: <1485166.QsN4P3lvAb@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Tuesday, September 1, 2015 2:45 PM
> To: Kaukab, Yousaf
> Cc: linux-media@vger.kernel.org; mchehab@osg.samsung.com
> Subject: Re: [RFC PATCH] media: uvcvideo: handle urb completion in a work
> queue
> 
> Hello Mian Yousaf,
> 
> Thank you for the patch.
Thank you for reviewing it!

> 
> On Tuesday 01 September 2015 11:45:11 Mian Yousaf Kaukab wrote:
> > urb completion callback is executed in host controllers interrupt
> > context. To keep preempt disable time short, add an ordered work-
> > queue. Associate a work_struct with each urb and queue work using it
> > on urb completion.
> >
> > In uvc_uninit_video, usb_kill_urb and usb_free_urb are separated in
> > different loops so that workqueue can be destroyed without a lock.
> 
> This will change the timing of the uvc_video_clock_decode() call. Have you
> double-checked that it won't cause any issue ? It will also increase the delay
> between end of frame reception and timestamp sampling in
> uvc_video_decode_start(), which I'd like to avoid.

Can this be fixed by saving the timestamp from uvc_video_get_ts() in
uvc_urb_complete() and use it in both uvc_video_decode_start() and
uvc_video_clock_decode()?

> 
> > Signed-off-by: Mian Yousaf Kaukab <yousaf.kaukab@intel.com>
> > ---
> >  drivers/media/usb/uvc/uvc_video.c | 63
> > +++++++++++++++++++++++++++++-------
> >  drivers/media/usb/uvc/uvcvideo.h  |  9 +++++-
> >  2 files changed, 60 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c index f839654..943dbd6 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -1317,9 +1317,23 @@ static void uvc_video_encode_bulk(struct urb
> > *urb, struct uvc_streaming *stream, urb->transfer_buffer_length =
> > stream->urb_size - len;
> >  }
> >
> > -static void uvc_video_complete(struct urb *urb)
> > +static void uvc_urb_complete(struct urb *urb)
> >  {
> > -	struct uvc_streaming *stream = urb->context;
> > +	struct uvc_urb_work *uw = urb->context;
> > +	struct uvc_streaming *stream = uw->stream;
> > +	/* stream->urb_wq can be set to NULL without lock */
> 
> That's sound racy. If stream->urb_wq can be set to NULL and the work queue
> destroyed by uvc_uninit_video() in parallel to the URB completion handler, the
> work queue could be destroyed between the if (wq) check and the call to
> queue_work().
> 
steam->urb_wq is set to NULL after killing all urbs. There should be
no completion callback when its NULL. This is the reason for two for-
loops in uvc_uninit_video()

> > +	struct workqueue_struct *wq = stream->urb_wq;
> > +
> > +	if (wq)
> > +		queue_work(wq, &uw->work);
> > +}
> > +
> > +static void uvc_video_complete_work(struct work_struct *work) {
> > +	struct uvc_urb_work *uw = container_of(work, struct
> uvc_urb_work,
> > +
> 				work);
> > +	struct urb *urb = uw->urb;
> > +	struct uvc_streaming *stream = uw->stream;
> >  	struct uvc_video_queue *queue = &stream->queue;
> >  	struct uvc_buffer *buf = NULL;
> >  	unsigned long flags;
> > @@ -1445,17 +1459,34 @@ static void uvc_uninit_video(struct
> > uvc_streaming *stream, int free_buffers) {
> >  	struct urb *urb;
> >  	unsigned int i;
> > +	struct workqueue_struct *wq;
> >
> >  	uvc_video_stats_stop(stream);
> >
> > +	/* Kill all URB first so that urb_wq can be destroyed without a
> lock
> > +*/
> >  	for (i = 0; i < UVC_URBS; ++i) {
> > -		urb = stream->urb[i];
> > +		urb = stream->uw[i].urb;
> >  		if (urb == NULL)
> >  			continue;
> >
> >  		usb_kill_urb(urb);
> > +	}
> > +
> > +	if (stream->urb_wq) {
> > +		wq = stream->urb_wq;
> > +		/* Since all URBs are killed set urb_wq to NULL */
> > +		stream->urb_wq = NULL;
> > +		flush_workqueue(wq);
> > +		destroy_workqueue(wq);
> 
> Does the work queue really need to be destroyed every time the video stream
> is stopped ? It looks to me like we could initialize it when the driver is initialized
> and destroy it only when the device is disconnected.
> 
Probably yes. But why keep it when it's not in use?


> > +	}
> > +
> > +	for (i = 0; i < UVC_URBS; ++i) {
> > +		urb = stream->uw[i].urb;
> > +		if (urb == NULL)
> > +			continue;
> > +
> >  		usb_free_urb(urb);
> > -		stream->urb[i] = NULL;
> > +		stream->uw[i].urb = NULL;
> >  	}
> >
> >  	if (free_buffers)
> > @@ -1514,7 +1545,7 @@ static int uvc_init_video_isoc(struct
> > uvc_streaming *stream, }
> >
> >  		urb->dev = stream->dev->udev;
> > -		urb->context = stream;
> > +		urb->context = &stream->uw[i];
> >  		urb->pipe = usb_rcvisocpipe(stream->dev->udev,
> >  				ep-
> >desc.bEndpointAddress);
> >  #ifndef CONFIG_DMA_NONCOHERENT
> > @@ -1525,7 +1556,7 @@ static int uvc_init_video_isoc(struct
> > uvc_streaming *stream, #endif
> >  		urb->interval = ep->desc.bInterval;
> >  		urb->transfer_buffer = stream->urb_buffer[i];
> > -		urb->complete = uvc_video_complete;
> > +		urb->complete = uvc_urb_complete;
> >  		urb->number_of_packets = npackets;
> >  		urb->transfer_buffer_length = size;
> >
> > @@ -1534,7 +1565,9 @@ static int uvc_init_video_isoc(struct
> > uvc_streaming *stream, urb->iso_frame_desc[j].length = psize;
> >  		}
> >
> > -		stream->urb[i] = urb;
> > +		stream->uw[i].urb = urb;
> > +		stream->uw[i].stream = stream;
> > +		INIT_WORK(&stream->uw[i].work,
> uvc_video_complete_work);
> >  	}
> >
> >  	return 0;
> > @@ -1580,14 +1613,16 @@ static int uvc_init_video_bulk(struct
> > uvc_streaming *stream, }
> >
> >  		usb_fill_bulk_urb(urb, stream->dev->udev, pipe,
> > -			stream->urb_buffer[i], size,
> uvc_video_complete,
> > -			stream);
> > +			stream->urb_buffer[i], size,
> uvc_urb_complete,
> > +			&stream->uw[i]);
> >  #ifndef CONFIG_DMA_NONCOHERENT
> >  		urb->transfer_flags =
> URB_NO_TRANSFER_DMA_MAP;
> >  		urb->transfer_dma = stream->urb_dma[i];  #endif
> >
> > -		stream->urb[i] = urb;
> > +		stream->uw[i].urb = urb;
> > +		stream->uw[i].stream = stream;
> > +		INIT_WORK(&stream->uw[i].work,
> uvc_video_complete_work);
> >  	}
> >
> >  	return 0;
> > @@ -1676,9 +1711,15 @@ static int uvc_init_video(struct uvc_streaming
> > *stream, gfp_t gfp_flags) if (ret < 0)
> >  		return ret;
> >
> > +	stream->urb_wq = alloc_ordered_workqueue(stream->dev-
> >name, 0);
> > +	if (!stream->urb_wq) {
> > +		uvc_printk(KERN_ERR, "Workqueue allocation
> failed\n");
> > +		return -ENOMEM;
> > +	}
> > +
> >  	/* Submit the URBs. */
> >  	for (i = 0; i < UVC_URBS; ++i) {
> > -		ret = usb_submit_urb(stream->urb[i], gfp_flags);
> > +		ret = usb_submit_urb(stream->uw[i].urb,
> gfp_flags);
> >  		if (ret < 0) {
> >  			uvc_printk(KERN_ERR, "Failed to
> submit URB %u "
> >
> 	"(%d).\n", i, ret);
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h
> > b/drivers/media/usb/uvc/uvcvideo.h index 816dd1a..e2c0617b 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -440,6 +440,12 @@ struct uvc_stats_stream {
> >  	unsigned int max_sof;		/* Maximum
> STC.SOF value */
> >  };
> >
> > +struct uvc_urb_work {
> > +	struct urb *urb;
> > +	struct uvc_streaming *stream;
> > +	struct work_struct work;
> > +};
> > +
> >  struct uvc_streaming {
> >  	struct list_head list;
> >  	struct uvc_device *dev;
> > @@ -482,7 +488,8 @@ struct uvc_streaming {
> >  		__u32 max_payload_size;
> >  	} bulk;
> >
> > -	struct urb *urb[UVC_URBS];
> > +	struct workqueue_struct *urb_wq;
> > +	struct uvc_urb_work uw[UVC_URBS];
> >  	char *urb_buffer[UVC_URBS];
> >  	dma_addr_t urb_dma[UVC_URBS];
> >  	unsigned int urb_size;
> 
> --
> Regards,
> 
> Laurent Pinchart

BR,
Yousaf

