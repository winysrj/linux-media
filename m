Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41163 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdLEAhO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 19:37:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, y2038@lists.linaro.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] [media] uvc_video: use ktime_t for timestamps
Date: Tue, 05 Dec 2017 02:37:27 +0200
Message-ID: <2878836.BpTQ5Kp5iv@avalon>
In-Reply-To: <20171127132027.1734806-2-arnd@arndb.de>
References: <20171127132027.1734806-1-arnd@arndb.de> <20171127132027.1734806-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thank you for the patch.

On Monday, 27 November 2017 15:19:54 EET Arnd Bergmann wrote:
> uvc_video_get_ts() returns a 'struct timespec', but all its users
> really want a nanoseconds variable anyway.
> 
> Changing the deprecated ktime_get_ts/ktime_get_real_ts to ktime_get
> and ktime_get_real simplifies the code noticeably, while keeping
> the resulting numbers unchanged.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 37 ++++++++++++-----------------------
>  drivers/media/usb/uvc/uvcvideo.h  |  2 +-
>  2 files changed, 13 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index d6bee37cd1b8..f7a919490b2b 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -369,12 +369,12 @@ static int uvc_commit_video(struct uvc_streaming
> *stream, * Clocks and timestamps
>   */
> 
> -static inline void uvc_video_get_ts(struct timespec *ts)
> +static inline ktime_t uvc_video_get_time(void)
>  {
>  	if (uvc_clock_param == CLOCK_MONOTONIC)
> -		ktime_get_ts(ts);
> +		return ktime_get();
>  	else
> -		ktime_get_real_ts(ts);
> +		return ktime_get_real();
>  }
> 
>  static void
> @@ -386,7 +386,7 @@ uvc_video_clock_decode(struct uvc_streaming *stream,
> struct uvc_buffer *buf, bool has_pts = false;
>  	bool has_scr = false;
>  	unsigned long flags;
> -	struct timespec ts;
> +	ktime_t time;
>  	u16 host_sof;
>  	u16 dev_sof;
> 
> @@ -436,7 +436,7 @@ uvc_video_clock_decode(struct uvc_streaming *stream,
> struct uvc_buffer *buf, stream->clock.last_sof = dev_sof;
> 
>  	host_sof = usb_get_current_frame_number(stream->dev->udev);
> -	uvc_video_get_ts(&ts);
> +	time = uvc_video_get_time();
> 
>  	/* The UVC specification allows device implementations that can't obtain
>  	 * the USB frame number to keep their own frame counters as long as they
> @@ -473,7 +473,7 @@ uvc_video_clock_decode(struct uvc_streaming *stream,
> struct uvc_buffer *buf, sample->dev_stc =
> get_unaligned_le32(&data[header_size - 6]);
>  	sample->dev_sof = dev_sof;
>  	sample->host_sof = host_sof;
> -	sample->host_ts = ts;
> +	sample->host_time = time;
> 
>  	/* Update the sliding window head and count. */
>  	stream->clock.head = (stream->clock.head + 1) % stream->clock.size;
> @@ -613,14 +613,12 @@ void uvc_video_clock_update(struct uvc_streaming
> *stream, struct uvc_clock_sample *first;
>  	struct uvc_clock_sample *last;
>  	unsigned long flags;
> -	struct timespec ts;
> +	u64 timestamp;
>  	u32 delta_stc;
>  	u32 y1, y2;
>  	u32 x1, x2;
>  	u32 mean;
>  	u32 sof;
> -	u32 div;
> -	u32 rem;
>  	u64 y;
> 
>  	if (!uvc_hw_timestamps_param)
> @@ -667,9 +665,8 @@ void uvc_video_clock_update(struct uvc_streaming
> *stream, if (x1 == x2)
>  		goto done;
> 
> -	ts = timespec_sub(last->host_ts, first->host_ts);
>  	y1 = NSEC_PER_SEC;
> -	y2 = (ts.tv_sec + 1) * NSEC_PER_SEC + ts.tv_nsec;
> +	y2 = (u32)ktime_to_ns(ktime_sub(last->host_time, first->host_time)) + y1;
> 
>  	/* Interpolated and host SOF timestamps can wrap around at slightly
>  	 * different times. Handle this by adding or removing 2048 to or from
> @@ -686,24 +683,18 @@ void uvc_video_clock_update(struct uvc_streaming
> *stream, - (u64)y2 * (u64)x1;
>  	y = div_u64(y, x2 - x1);
> 
> -	div = div_u64_rem(y, NSEC_PER_SEC, &rem);
> -	ts.tv_sec = first->host_ts.tv_sec - 1 + div;
> -	ts.tv_nsec = first->host_ts.tv_nsec + rem;
> -	if (ts.tv_nsec >= NSEC_PER_SEC) {
> -		ts.tv_sec++;
> -		ts.tv_nsec -= NSEC_PER_SEC;
> -	}
> +	timestamp = ktime_to_ns(first->host_time) + y - y1;

It took me a few minutes to see that the -1 and -y1 were equivalent. And then 
more time to re-read the code and the comments to understand what I had done. 
I'm impressed that you haven't blindly replaced the +1s and -1s by 
+NSEC_PER_SEC and -NSEC_PER_SEC, but used +y1 and -y1 which I think improves 
readability.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

with the highest honors :-)

Should I merge this through my tree ?

>  	uvc_trace(UVC_TRACE_CLOCK, "%s: SOF %u.%06llu y %llu ts %llu "
>  		  "buf ts %llu (x1 %u/%u/%u x2 %u/%u/%u y1 %u y2 %u)\n",
>  		  stream->dev->name,
>  		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
> -		  y, timespec_to_ns(&ts), vbuf->vb2_buf.timestamp,
> +		  y, timestamp, vbuf->vb2_buf.timestamp,
>  		  x1, first->host_sof, first->dev_sof,
>  		  x2, last->host_sof, last->dev_sof, y1, y2);
> 
>  	/* Update the V4L2 buffer. */
> -	vbuf->vb2_buf.timestamp = timespec_to_ns(&ts);
> +	vbuf->vb2_buf.timestamp = timestamp;
> 
>  done:
>  	spin_unlock_irqrestore(&clock->lock, flags);
> @@ -1007,8 +998,6 @@ static int uvc_video_decode_start(struct uvc_streaming
> *stream, * when the EOF bit is set to force synchronisation on the next
> packet. */
>  	if (buf->state != UVC_BUF_STATE_ACTIVE) {
> -		struct timespec ts;
> -
>  		if (fid == stream->last_fid) {
>  			uvc_trace(UVC_TRACE_FRAME, "Dropping payload (out of "
>  				"sync).\n");
> @@ -1018,11 +1007,9 @@ static int uvc_video_decode_start(struct
> uvc_streaming *stream, return -ENODATA;
>  		}
> 
> -		uvc_video_get_ts(&ts);
> -
>  		buf->buf.field = V4L2_FIELD_NONE;
>  		buf->buf.sequence = stream->sequence;
> -		buf->buf.vb2_buf.timestamp = timespec_to_ns(&ts);
> +		buf->buf.vb2_buf.timestamp = uvc_video_get_time();
> 
>  		/* TODO: Handle PTS and SCR. */
>  		buf->state = UVC_BUF_STATE_ACTIVE;
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index a2c190937067..d7797dfb6468 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -536,8 +536,8 @@ struct uvc_streaming {
>  		struct uvc_clock_sample {
>  			u32 dev_stc;
>  			u16 dev_sof;
> -			struct timespec host_ts;
>  			u16 host_sof;
> +			ktime_t host_time;
>  		} *samples;
> 
>  		unsigned int head;

-- 
Regards,

Laurent Pinchart
