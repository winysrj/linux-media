Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42348 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbbICG6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2015 02:58:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Kaukab, Yousaf" <yousaf.kaukab@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@osg.samsung.com" <mchehab@osg.samsung.com>,
	Linux USB <linux-usb@vger.kernel.org>
Subject: Re: [RFC PATCH] media: uvcvideo: handle urb completion in a work queue
Date: Thu, 03 Sep 2015 09:58:44 +0300
Message-ID: <1724373.BI2LFoO6qT@avalon>
In-Reply-To: <B1AFEC30BE3ADF488E833B59904F5C321D99B0E6@IRSMSX107.ger.corp.intel.com>
References: <1441100711-24519-1-git-send-email-yousaf.kaukab@intel.com> <1485166.QsN4P3lvAb@avalon> <B1AFEC30BE3ADF488E833B59904F5C321D99B0E6@IRSMSX107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mian Yousaf,

(CC'ing linux-usb for tips regarding proper handling of URBs in work queues)

On Tuesday 01 September 2015 13:49:31 Kaukab, Yousaf wrote:
> On Tuesday, September 1, 2015 2:45 PM Laurent Pinchart wrote:
> > On Tuesday 01 September 2015 11:45:11 Mian Yousaf Kaukab wrote:
> >> urb completion callback is executed in host controllers interrupt
> >> context. To keep preempt disable time short, add an ordered work-
> >> queue. Associate a work_struct with each urb and queue work using it
> >> on urb completion.
> >> 
> >> In uvc_uninit_video, usb_kill_urb and usb_free_urb are separated in
> >> different loops so that workqueue can be destroyed without a lock.
> > 
> > This will change the timing of the uvc_video_clock_decode() call. Have you
> > double-checked that it won't cause any issue ? It will also increase the
> > delay between end of frame reception and timestamp sampling in
> > uvc_video_decode_start(), which I'd like to avoid.
> 
> Can this be fixed by saving the timestamp from uvc_video_get_ts() in
> uvc_urb_complete() and use it in both uvc_video_decode_start() and
> uvc_video_clock_decode()?

Yes, I think that would work. I think it's especially important in 
uvc_video_decode_start(). For uvc_video_clock_decode() it might not matter (I 
won't mind if you investigate whether it's needed ;-)), but if you use the 
saved timestamp there, you should also save the USB frame number along with 
the timestamp as they must match.

> >> Signed-off-by: Mian Yousaf Kaukab <yousaf.kaukab@intel.com>
> >> ---
> >> 
> >>  drivers/media/usb/uvc/uvc_video.c | 63 ++++++++++++++++++++++++++-------
> >> 
> >>  drivers/media/usb/uvc/uvcvideo.h  |  9 +++++-
> >>  2 files changed, 60 insertions(+), 12 deletions(-)
> >> 
> >> diff --git a/drivers/media/usb/uvc/uvc_video.c
> >> b/drivers/media/usb/uvc/uvc_video.c index f839654..943dbd6 100644
> >> --- a/drivers/media/usb/uvc/uvc_video.c
> >> +++ b/drivers/media/usb/uvc/uvc_video.c
> >> @@ -1317,9 +1317,23 @@ static void uvc_video_encode_bulk(struct urb
> >> *urb, struct uvc_streaming *stream, urb->transfer_buffer_length =
> >> stream->urb_size - len;
> >> 
> >>  }
> >> 
> >> -static void uvc_video_complete(struct urb *urb)
> >> +static void uvc_urb_complete(struct urb *urb)
> >>  {
> >> -	struct uvc_streaming *stream = urb->context;
> >> +	struct uvc_urb_work *uw = urb->context;
> >> +	struct uvc_streaming *stream = uw->stream;
> >> +	/* stream->urb_wq can be set to NULL without lock */
> > 
> > That's sound racy. If stream->urb_wq can be set to NULL and the work queue
> > destroyed by uvc_uninit_video() in parallel to the URB completion handler,
> > the work queue could be destroyed between the if (wq) check and the call
> > to queue_work().
> 
> steam->urb_wq is set to NULL after killing all urbs. There should be
> no completion callback when its NULL. This is the reason for two for-
> loops in uvc_uninit_video()

Indeed, I've missed that.

There's still at least one race condition though. The URB completion handler 
uvc_video_complete() is now called from the work queue. It could thus race 
usb_kill_urb(), which will make resubmission of the URB with usb_submit_urb() 
return -EPERM. The driver will then print an error message to the kernel log 
that could worry the user unnecessarily.

I'm in general a bit wary regarding race conditions, and especially when a 
complex function that used to run synchronously is moved to a work queue. I'm 
wondering whether it wouldn't be better to use a lock, as contention would 
only occur at stream stop time.

Could you please double-check possible race conditions ? Keeping the work 
queue around for the whole duration of the device life time might also help 
simplifying the code, but I haven't investigated that.

Another idea that just came to my mind, wouldn't it be better to add URBs to a 
list in their synchronous completion handler and use a normal work queue ? If 
several URBs complete in a row we could possibly avoid some scheduling context 
switches.

> >> +	struct workqueue_struct *wq = stream->urb_wq;
> >> +
> >> +	if (wq)
> >> +		queue_work(wq, &uw->work);
> >> +}

[snip]

> >> @@ -1445,17 +1459,34 @@ static void uvc_uninit_video(struct
> >> uvc_streaming *stream, int free_buffers)
> >>  {
> >>  	struct urb *urb;
> >>  	unsigned int i;
> >> +	struct workqueue_struct *wq;
> >>
> >>  	uvc_video_stats_stop(stream);
> >>
> >> +	/* Kill all URB first so that urb_wq can be destroyed without a
> >> lock
> >> +*/
> >>  	for (i = 0; i < UVC_URBS; ++i) {
> >> -		urb = stream->urb[i];
> >> +		urb = stream->uw[i].urb;
> >>  		if (urb == NULL)
> >>  			continue;
> >>  		
> >>  		usb_kill_urb(urb);
> >> +	}
> >> +
> >> +	if (stream->urb_wq) {
> >> +		wq = stream->urb_wq;
> >> +		/* Since all URBs are killed set urb_wq to NULL */
> >> +		stream->urb_wq = NULL;
> >> +		flush_workqueue(wq);
> >> +		destroy_workqueue(wq);
> > 
> > Does the work queue really need to be destroyed every time the video
> > stream is stopped ? It looks to me like we could initialize it when the
> > driver is initialized and destroy it only when the device is disconnected.
> 
> Probably yes. But why keep it when it's not in use?

It's a matter of resources consumed by the work queue vs. the time spent to 
create it when starting the stream, as well as code complexity. 

> >> +	}
> >> +
> >> +	for (i = 0; i < UVC_URBS; ++i) {
> >> +		urb = stream->uw[i].urb;
> >> +		if (urb == NULL)
> >> +			continue;
> >> +
> >>  		usb_free_urb(urb);
> >> 
> >> -		stream->urb[i] = NULL;
> >> +		stream->uw[i].urb = NULL;
> >>  	}
> >>  	
> >>  	if (free_buffers)

-- 
Regards,

Laurent Pinchart

