Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:41564 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbeG3Rfr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 13:35:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Keiichi Watanabe <keiichiw@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kieran.bingham@ideasonboard.com,
        tfiga@chromium.org, dianders@chromium.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: Re: [RFC PATCH v1] media: uvcvideo: Cache URB header data before processing
Date: Mon, 30 Jul 2018 19:00:46 +0300
Message-ID: <11886963.8nkeRH3xvi@avalon>
In-Reply-To: <20180627103408.33003-1-keiichiw@chromium.org>
References: <20180627103408.33003-1-keiichiw@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Keiichi,

(CC'ing Alan, Ezequiel and Matwey)

Thank you for the patch.

On Wednesday, 27 June 2018 13:34:08 EEST Keiichi Watanabe wrote:
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
> The test device was Jerry Chromebook (RK3288) with Logitech Brio 4K.
> I collected data for 5 seconds. (There were around 480 callbacks in
> this case.) The following result shows that this patch makes
> uvc_video_complete about 2x faster.
> 
>            | average | median  | min     | max     | standard deviation
> 
> w/o caching| 45319ns | 40250ns | 33834ns | 142625ns| 16611ns
> w/  caching| 20620ns | 19250ns | 12250ns | 56583ns | 6285ns
> 
> In addition, we confirmed that this patch doesn't make it worse on
> coherent DMA architecture by performing the same measurements on a
> Broadwell Chromebox with the same camera.
> 
>            | average | median  | min     | max     | standard deviation
> 
> w/o caching| 21026ns | 21424ns | 12263ns | 23956ns | 1932ns
> w/  caching| 20728ns | 20398ns |  8922ns | 45120ns | 3368ns

This is very interesting, and it seems related to https://
patchwork.kernel.org/patch/10468937/. You might have seen that discussion as 
you got CC'ed at some point.

I wonder whether performances couldn't be further improved by allocating the 
URB buffers cached, as that would speed up the memcpy() as well. Have you 
tested that by any chance ?

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
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index a88b2e51a666..ff2eddc55530 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -391,36 +391,15 @@ static inline ktime_t uvc_video_get_time(void)
> 
>  static void
>  uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer
> *buf, -		       const u8 *data, int len)
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
> @@ -717,11 +696,10 @@ void uvc_video_clock_update(struct uvc_streaming
> *stream, */
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
> @@ -730,25 +708,6 @@ static void uvc_video_stats_decode(struct uvc_streaming
> *stream, stream->stats.frame.nb_packets == 0)
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
> @@ -957,10 +916,41 @@ static void uvc_video_stats_stop(struct uvc_streaming
> *stream) * to be called with a NULL buf parameter. uvc_video_decode_data
> and * uvc_video_decode_end will never be called with a NULL buffer.
>   */
> +static void uvc_video_decode_header_size(const u8 *data, int *header_size,
> +					 bool *has_pts, bool *has_scr)
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
> @@ -983,8 +973,12 @@ static int uvc_video_decode_start(struct uvc_streaming
> *stream, uvc_video_stats_update(stream);
>  	}
> 
> -	uvc_video_clock_decode(stream, buf, data, len);
> -	uvc_video_stats_decode(stream, data, len);
> +	uvc_video_decode_header_size(data, &header_size, &has_pts, &has_scr);
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


-- 
Regards,

Laurent Pinchart
