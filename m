Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60314 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388241AbeGXMJw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 08:09:52 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [RFC PATCH v1] media: uvcvideo: Cache URB header data before
 processing
To: Keiichi Watanabe <keiichiw@chromium.org>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, tfiga@chromium.org,
        dianders@chromium.org
References: <20180627103408.33003-1-keiichiw@chromium.org>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <7e39029e-4066-26d3-6ca9-e84bb0f4a498@ideasonboard.com>
Date: Tue, 24 Jul 2018 12:03:53 +0100
MIME-Version: 1.0
In-Reply-To: <20180627103408.33003-1-keiichiw@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Keiichi

On 27/06/18 11:34, Keiichi Watanabe wrote:
> On some platforms with non-coherent DMA (e.g. ARM), USB drivers use
> uncached memory allocation methods. In such situations, it sometimes
> takes a long time to access URB buffers.  This can be a cause of video
> flickering problems if a resolution is high and a USB controller has
> a very tight time limit. (e.g. dwc2) To avoid this problem, we copy
> header data from (uncached) URB buffer into (cached) local buffer.
> 
> This change should make the elapsed time of the interrupt handler
> shorter on platforms with non-coherent DMA. We measured the elapsed
> time of each callback of uvc_video_complete without/with this patch
> while capturing Full HD video in
> https://webrtc.github.io/samples/src/content/getusermedia/resolution/.
> I tested it on the top of Kieran Bingham's Asynchronous UVC series
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg128359.html.

I've nudged Laurent to get my Async patches reviewed - but I don't think
it's going to make it into v4.19 at the moment :(


> The test device was Jerry Chromebook (RK3288) with Logitech Brio 4K.
> I collected data for 5 seconds. (There were around 480 callbacks in
> this case.) The following result shows that this patch makes
> uvc_video_complete about 2x faster.
>            | average | median  | min     | max     | standard deviation
> w/o caching| 45319ns | 40250ns | 33834ns | 142625ns| 16611ns
> w/  caching| 20620ns | 19250ns | 12250ns | 56583ns | 6285ns
> 
> In addition, we confirmed that this patch doesn't make it worse on
> coherent DMA architecture by performing the same measurements on a
> Broadwell Chromebox with the same camera.
> 
>            | average | median  | min     | max     | standard deviation
> w/o caching| 21026ns | 21424ns | 12263ns | 23956ns | 1932ns
> w/  caching| 20728ns | 20398ns |  8922ns | 45120ns | 3368ns

Uhm .... what happened there though. The Max has increased?

This is technically still faster than the Chromebook, - but slower than
the "w/o caching" line of the same test. Will this have any impact on
any other use-cases?


> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
> ---
> 
> After applying 6 patches in
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg128359.html,
> I measured elapsed time by adding the following code to
> /drivers/media/usb/uvc/uvc_video.c
> 
> @@ -XXXX,6 +XXXX,9 @@ static void uvc_video_complete(struct urb *urb)
>         struct uvc_video_queue *queue = &stream->queue;
>  	struct uvc_buffer *buf = NULL;
>  	int ret;
> +	ktime_t start, end;
> +	int elapsed_time;
> +	start = ktime_get();
>  	switch (urb->status) {
>  	case 0:
> 
> @@ -XXXX,6 +XXXX,10 @@ static void uvc_video_complete(struct urb *urb)
> 
>  	INIT_WORK(&uvc_urb->work, uvc_video_copy_data_work);
>  	queue_work(stream->async_wq, &uvc_urb->work);
> +
> +	end = ktime_get();
> +	elapsed_time = ktime_to_ns(ktime_sub(end, start));
> +	pr_err("elapsed time: %d ns", elapsed_time);
>  }
> 
>  /*
> 
> 
>  drivers/media/usb/uvc/uvc_video.c | 92 +++++++++++++++----------------
>  1 file changed, 43 insertions(+), 49 deletions(-)
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index a88b2e51a666..ff2eddc55530 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -391,36 +391,15 @@ static inline ktime_t uvc_video_get_time(void)
> 
>  static void
>  uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
> -		       const u8 *data, int len)
> +		       const u8 *data, int len, unsigned int header_size,
> +		       bool has_pts, bool has_scr)
>  {
>  	struct uvc_clock_sample *sample;
> -	unsigned int header_size;
> -	bool has_pts = false;
> -	bool has_scr = false;
>  	unsigned long flags;
>  	ktime_t time;
>  	u16 host_sof;
>  	u16 dev_sof;
> 
> -	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
> -	case UVC_STREAM_PTS | UVC_STREAM_SCR:
> -		header_size = 12;
> -		has_pts = true;
> -		has_scr = true;
> -		break;
> -	case UVC_STREAM_PTS:
> -		header_size = 6;
> -		has_pts = true;
> -		break;
> -	case UVC_STREAM_SCR:
> -		header_size = 8;
> -		has_scr = true;
> -		break;
> -	default:
> -		header_size = 2;
> -		break;
> -	}
> -
>  	/* Check for invalid headers. */
>  	if (len < header_size)
>  		return;
> @@ -717,11 +696,10 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
>   */
> 
>  static void uvc_video_stats_decode(struct uvc_streaming *stream,
> -		const u8 *data, int len)
> +				   const u8 *data, int len,
> +				   unsigned int header_size, bool has_pts,
> +				   bool has_scr)
>  {
> -	unsigned int header_size;
> -	bool has_pts = false;
> -	bool has_scr = false;
>  	u16 uninitialized_var(scr_sof);
>  	u32 uninitialized_var(scr_stc);
>  	u32 uninitialized_var(pts);
> @@ -730,25 +708,6 @@ static void uvc_video_stats_decode(struct uvc_streaming *stream,
>  	    stream->stats.frame.nb_packets == 0)
>  		stream->stats.stream.start_ts = ktime_get();
> 
> -	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
> -	case UVC_STREAM_PTS | UVC_STREAM_SCR:
> -		header_size = 12;
> -		has_pts = true;
> -		has_scr = true;
> -		break;
> -	case UVC_STREAM_PTS:
> -		header_size = 6;
> -		has_pts = true;
> -		break;
> -	case UVC_STREAM_SCR:
> -		header_size = 8;
> -		has_scr = true;
> -		break;
> -	default:
> -		header_size = 2;
> -		break;
> -	}
> -
>  	/* Check for invalid headers. */
>  	if (len < header_size || data[0] < header_size) {
>  		stream->stats.frame.nb_invalid++;
> @@ -957,10 +916,41 @@ static void uvc_video_stats_stop(struct uvc_streaming *stream)
>   * to be called with a NULL buf parameter. uvc_video_decode_data and
>   * uvc_video_decode_end will never be called with a NULL buffer.
>   */
> +static void uvc_video_decode_header_size(const u8 *data, int *header_size,
> +					 bool *has_pts, bool *has_scr)

Rather than passing in pointers, could/should we add these fields to the
struct uvc_buffer? I think they are properties of the buffer object so
they could live there. Then the function prototypes would be kept cleaner.

Although, actually there might be multiple packets with timestamps per
uvc_buffer object, so maybe it needs it's own struct. Or perhaps it's
more appropriate to the stream object, as they refernce the 'last known
time' ?



> +{
> +	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
> +	case UVC_STREAM_PTS | UVC_STREAM_SCR:
> +		*header_size = 12;
> +		*has_pts = true;
> +		*has_scr = true;
> +		break;
> +	case UVC_STREAM_PTS:
> +		*header_size = 6;
> +		*has_pts = true;
> +		break;
> +	case UVC_STREAM_SCR:
> +		*header_size = 8;
> +		*has_scr = true;
> +		break;
> +	default:
> +		*header_size = 2;
> +	}

It looks like we are also extracting the pts, and scr multiple times for
both the clock handling and the stats handling.

As we use "get_unaligned_leXX" macro's for that - I wonder if that's a
slow path that aught to be done only once where possible too?



> +}
> +
>  static int uvc_video_decode_start(struct uvc_streaming *stream,
> -		struct uvc_buffer *buf, const u8 *data, int len)
> +				  struct uvc_buffer *buf, const u8 *urb_data,
> +				  int len)
>  {
>  	u8 fid;
> +	u8 data[12];
> +	unsigned int header_size;
> +	bool has_pts = false, has_scr = false;
> +
> +	/* Cache the header since urb_data is uncached memory. The size of
> +	 * header is at most 12 bytes.
> +	 */
> +	memcpy(data, urb_data, min(len, 12));
> 
>  	/* Sanity checks:
>  	 * - packet must be at least 2 bytes long
> @@ -983,8 +973,12 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
>  			uvc_video_stats_update(stream);
>  	}
> 
> -	uvc_video_clock_decode(stream, buf, data, len);
> -	uvc_video_stats_decode(stream, data, len);
> +	uvc_video_decode_header_size(data, &header_size, &has_pts, &has_scr);

Perhaps just "uvc_video_decode_header()", or to match the style of the
other functions:

	"uvc_video_header_decode()"?


> +
> +	uvc_video_clock_decode(stream, buf, data, len, header_size, has_pts,
> +			       has_scr);
> +	uvc_video_stats_decode(stream, data, len, header_size, has_pts,
> +			       has_scr);
> 
>  	/* Store the payload FID bit and return immediately when the buffer is
>  	 * NULL.
> --
> 2.18.0.rc2.346.g013aa6912e-goog
> 

-- 
Regards
--
Kieran
