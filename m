Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:41602 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbeG3Rjh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 13:39:37 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [RFC PATCH v1] media: uvcvideo: Cache URB header data before
 processing
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Keiichi Watanabe <keiichiw@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, tfiga@chromium.org,
        dianders@chromium.org, Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
References: <20180627103408.33003-1-keiichiw@chromium.org>
 <11886963.8nkeRH3xvi@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <6970dfda-d43b-3e40-fc17-eec96ded6012@ideasonboard.com>
Date: Mon, 30 Jul 2018 17:03:53 +0100
MIME-Version: 1.0
In-Reply-To: <11886963.8nkeRH3xvi@avalon>
Content-Type: multipart/mixed;
 boundary="------------46588E624CE5F8B368D380F2"
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------46588E624CE5F8B368D380F2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

I'm attaching my debug patch in case it's useful to anyone measuring
performances.

(Recently with an extra metric added thanks to Keiichi)

Also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git uvc/async-ml

Regards
--
Kieran

On 30/07/18 17:00, Laurent Pinchart wrote:
> Hi Keiichi,
> 
> (CC'ing Alan, Ezequiel and Matwey)
> 
> Thank you for the patch.
> 
> On Wednesday, 27 June 2018 13:34:08 EEST Keiichi Watanabe wrote:
>> On some platforms with non-coherent DMA (e.g. ARM), USB drivers use
>> uncached memory allocation methods. In such situations, it sometimes
>> takes a long time to access URB buffers.  This can be a cause of video
>> flickering problems if a resolution is high and a USB controller has
>> a very tight time limit. (e.g. dwc2) To avoid this problem, we copy
>> header data from (uncached) URB buffer into (cached) local buffer.
>>
>> This change should make the elapsed time of the interrupt handler
>> shorter on platforms with non-coherent DMA. We measured the elapsed
>> time of each callback of uvc_video_complete without/with this patch
>> while capturing Full HD video in
>> https://webrtc.github.io/samples/src/content/getusermedia/resolution/.
>> I tested it on the top of Kieran Bingham's Asynchronous UVC series
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg128359.html.
>> The test device was Jerry Chromebook (RK3288) with Logitech Brio 4K.
>> I collected data for 5 seconds. (There were around 480 callbacks in
>> this case.) The following result shows that this patch makes
>> uvc_video_complete about 2x faster.
>>
>>            | average | median  | min     | max     | standard deviation
>>
>> w/o caching| 45319ns | 40250ns | 33834ns | 142625ns| 16611ns
>> w/  caching| 20620ns | 19250ns | 12250ns | 56583ns | 6285ns
>>
>> In addition, we confirmed that this patch doesn't make it worse on
>> coherent DMA architecture by performing the same measurements on a
>> Broadwell Chromebox with the same camera.
>>
>>            | average | median  | min     | max     | standard deviation
>>
>> w/o caching| 21026ns | 21424ns | 12263ns | 23956ns | 1932ns
>> w/  caching| 20728ns | 20398ns |  8922ns | 45120ns | 3368ns
> 
> This is very interesting, and it seems related to https://
> patchwork.kernel.org/patch/10468937/. You might have seen that discussion as 
> you got CC'ed at some point.
> 
> I wonder whether performances couldn't be further improved by allocating the 
> URB buffers cached, as that would speed up the memcpy() as well. Have you 
> tested that by any chance ?
> 
>> Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
>> ---
>>
>> After applying 6 patches in
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg128359.html,
>> I measured elapsed time by adding the following code to
>> /drivers/media/usb/uvc/uvc_video.c
>>
>> @@ -XXXX,6 +XXXX,9 @@ static void uvc_video_complete(struct urb *urb)
>>         struct uvc_video_queue *queue = &stream->queue;
>>  	struct uvc_buffer *buf = NULL;
>>  	int ret;
>> +	ktime_t start, end;
>> +	int elapsed_time;
>> +	start = ktime_get();
>>  	switch (urb->status) {
>>  	case 0:
>>
>> @@ -XXXX,6 +XXXX,10 @@ static void uvc_video_complete(struct urb *urb)
>>
>>  	INIT_WORK(&uvc_urb->work, uvc_video_copy_data_work);
>>  	queue_work(stream->async_wq, &uvc_urb->work);
>> +
>> +	end = ktime_get();
>> +	elapsed_time = ktime_to_ns(ktime_sub(end, start));
>> +	pr_err("elapsed time: %d ns", elapsed_time);
>>  }
>>
>>  /*
>>
>>
>>  drivers/media/usb/uvc/uvc_video.c | 92 +++++++++++++++----------------
>>  1 file changed, 43 insertions(+), 49 deletions(-)
>> diff --git a/drivers/media/usb/uvc/uvc_video.c
>> b/drivers/media/usb/uvc/uvc_video.c index a88b2e51a666..ff2eddc55530 100644
>> --- a/drivers/media/usb/uvc/uvc_video.c
>> +++ b/drivers/media/usb/uvc/uvc_video.c
>> @@ -391,36 +391,15 @@ static inline ktime_t uvc_video_get_time(void)
>>
>>  static void
>>  uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer
>> *buf, -		       const u8 *data, int len)
>> +		       const u8 *data, int len, unsigned int header_size,
>> +		       bool has_pts, bool has_scr)
>>  {
>>  	struct uvc_clock_sample *sample;
>> -	unsigned int header_size;
>> -	bool has_pts = false;
>> -	bool has_scr = false;
>>  	unsigned long flags;
>>  	ktime_t time;
>>  	u16 host_sof;
>>  	u16 dev_sof;
>>
>> -	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
>> -	case UVC_STREAM_PTS | UVC_STREAM_SCR:
>> -		header_size = 12;
>> -		has_pts = true;
>> -		has_scr = true;
>> -		break;
>> -	case UVC_STREAM_PTS:
>> -		header_size = 6;
>> -		has_pts = true;
>> -		break;
>> -	case UVC_STREAM_SCR:
>> -		header_size = 8;
>> -		has_scr = true;
>> -		break;
>> -	default:
>> -		header_size = 2;
>> -		break;
>> -	}
>> -
>>  	/* Check for invalid headers. */
>>  	if (len < header_size)
>>  		return;
>> @@ -717,11 +696,10 @@ void uvc_video_clock_update(struct uvc_streaming
>> *stream, */
>>
>>  static void uvc_video_stats_decode(struct uvc_streaming *stream,
>> -		const u8 *data, int len)
>> +				   const u8 *data, int len,
>> +				   unsigned int header_size, bool has_pts,
>> +				   bool has_scr)
>>  {
>> -	unsigned int header_size;
>> -	bool has_pts = false;
>> -	bool has_scr = false;
>>  	u16 uninitialized_var(scr_sof);
>>  	u32 uninitialized_var(scr_stc);
>>  	u32 uninitialized_var(pts);
>> @@ -730,25 +708,6 @@ static void uvc_video_stats_decode(struct uvc_streaming
>> *stream, stream->stats.frame.nb_packets == 0)
>>  		stream->stats.stream.start_ts = ktime_get();
>>
>> -	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
>> -	case UVC_STREAM_PTS | UVC_STREAM_SCR:
>> -		header_size = 12;
>> -		has_pts = true;
>> -		has_scr = true;
>> -		break;
>> -	case UVC_STREAM_PTS:
>> -		header_size = 6;
>> -		has_pts = true;
>> -		break;
>> -	case UVC_STREAM_SCR:
>> -		header_size = 8;
>> -		has_scr = true;
>> -		break;
>> -	default:
>> -		header_size = 2;
>> -		break;
>> -	}
>> -
>>  	/* Check for invalid headers. */
>>  	if (len < header_size || data[0] < header_size) {
>>  		stream->stats.frame.nb_invalid++;
>> @@ -957,10 +916,41 @@ static void uvc_video_stats_stop(struct uvc_streaming
>> *stream) * to be called with a NULL buf parameter. uvc_video_decode_data
>> and * uvc_video_decode_end will never be called with a NULL buffer.
>>   */
>> +static void uvc_video_decode_header_size(const u8 *data, int *header_size,
>> +					 bool *has_pts, bool *has_scr)
>> +{
>> +	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
>> +	case UVC_STREAM_PTS | UVC_STREAM_SCR:
>> +		*header_size = 12;
>> +		*has_pts = true;
>> +		*has_scr = true;
>> +		break;
>> +	case UVC_STREAM_PTS:
>> +		*header_size = 6;
>> +		*has_pts = true;
>> +		break;
>> +	case UVC_STREAM_SCR:
>> +		*header_size = 8;
>> +		*has_scr = true;
>> +		break;
>> +	default:
>> +		*header_size = 2;
>> +	}
>> +}
>> +
>>  static int uvc_video_decode_start(struct uvc_streaming *stream,
>> -		struct uvc_buffer *buf, const u8 *data, int len)
>> +				  struct uvc_buffer *buf, const u8 *urb_data,
>> +				  int len)
>>  {
>>  	u8 fid;
>> +	u8 data[12];
>> +	unsigned int header_size;
>> +	bool has_pts = false, has_scr = false;
>> +
>> +	/* Cache the header since urb_data is uncached memory. The size of
>> +	 * header is at most 12 bytes.
>> +	 */
>> +	memcpy(data, urb_data, min(len, 12));
>>
>>  	/* Sanity checks:
>>  	 * - packet must be at least 2 bytes long
>> @@ -983,8 +973,12 @@ static int uvc_video_decode_start(struct uvc_streaming
>> *stream, uvc_video_stats_update(stream);
>>  	}
>>
>> -	uvc_video_clock_decode(stream, buf, data, len);
>> -	uvc_video_stats_decode(stream, data, len);
>> +	uvc_video_decode_header_size(data, &header_size, &has_pts, &has_scr);
>> +
>> +	uvc_video_clock_decode(stream, buf, data, len, header_size, has_pts,
>> +			       has_scr);
>> +	uvc_video_stats_decode(stream, data, len, header_size, has_pts,
>> +			       has_scr);
>>
>>  	/* Store the payload FID bit and return immediately when the buffer is
>>  	 * NULL.
>> --
>> 2.18.0.rc2.346.g013aa6912e-goog
> 
> 

-- 
Regards
--
Kieran

--------------46588E624CE5F8B368D380F2
Content-Type: text/x-patch;
 name="0001-uvcvideo-debug-Add-statistics-for-measuring-performa.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-uvcvideo-debug-Add-statistics-for-measuring-performa.pa";
 filename*1="tch"

>From cebbd1b629bbe5f856ec5dc7591478c003f5a944 Mon Sep 17 00:00:00 2001
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Date: Wed, 22 Mar 2017 09:54:11 +0000
Subject: [PATCH] uvcvideo: debug: Add statistics for measuring performance

Measuring the performance of the uvcvideo driver requires introspection
into the internal state.

Extend the information provided at:
 /sys/kernel/debug/usb/uvcvideo/${bus}-${dev}/stats

to track the overall data throughput as well as URB usage and processing
speeds.

This patch is not intended for integration into any release tree, but is
provided as-is to assist in measuring the performance while fine tuning
specific use-cases of the driver.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
---

 v2:
   - uvcvideo: debug: Convert to using ktime_t
   - uvcvideo: debug: Track header processing time
     (H/T Keiichi Watanabe <keiichiw@chromium.org>

Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
---
 drivers/media/usb/uvc/uvc_video.c | 153 +++++++++++++++++++++++++++++-
 drivers/media/usb/uvc/uvcvideo.h  |  20 ++++
 2 files changed, 171 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index a4222d8d09a5..40943890668b 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -863,12 +863,56 @@ static void uvc_video_stats_update(struct uvc_streaming *stream)
 	memset(&stream->stats.frame, 0, sizeof(stream->stats.frame));
 }
 
+size_t uvc_video_dump_time_stats(char *buf, size_t size,
+				 struct uvc_stats_time *stat, const char *pfx)
+{
+	unsigned int avg = 0;
+
+	if (stat->qty)
+		avg = stat->duration / stat->qty;
+
+	/* Stat durations are in nanoseconds, we present in micro-seconds */
+	return scnprintf(buf, size,
+			 "%s: %llu/%u uS/qty: %u.%03u avg %u.%03u min %u.%03u max (uS)\n",
+			 pfx, stat->duration / 1000, stat->qty,
+			  avg / 1000, avg % 1000,
+			  stat->min / 1000, stat->min % 1000,
+			  stat->max / 1000, stat->max % 1000);
+}
+
+size_t uvc_video_dump_speed(char *buf, size_t size, const char *pfx,
+			    u64 bytes, u64 milliseconds)
+{
+	unsigned int rate = 0;
+	bool gbit = false;
+
+	if (milliseconds)
+		rate = bytes * 8 / milliseconds;
+
+	if (rate >= 1000000) {
+		gbit = true;
+		rate /= 1000;
+	}
+
+	/*
+	* bits/milliseconds == kilobits/seconds,
+	* presented here as Mbits/s (or Gbit/s) with 3 decimal places
+	*/
+	return scnprintf(buf, size, "%s: %d.%03d %sbits/s\n",
+			 pfx, rate / 1000, rate % 1000,
+			 gbit ? "G" : "M");
+}
+
 size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
 			    size_t size)
 {
+	u64 bytes = stream->stats.stream.bytes; /* Single sample */
+	unsigned int empty_ratio = 0;
 	unsigned int scr_sof_freq;
 	unsigned int duration;
+	unsigned int fps = 0;
 	size_t count = 0;
+	u64 cpu = 0;
 
 	/* Compute the SCR.SOF frequency estimate. At the nominal 1kHz SOF
 	 * frequency this will not overflow before more than 1h.
@@ -881,12 +925,20 @@ size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
 	else
 		scr_sof_freq = 0;
 
+	if (stream->stats.stream.nb_packets)
+		empty_ratio = stream->stats.stream.nb_empty * 100 /
+			stream->stats.stream.nb_packets;
+
 	count += scnprintf(buf + count, size - count,
-			   "frames:  %u\npackets: %u\nempty:   %u\n"
-			   "errors:  %u\ninvalid: %u\n",
+			   "frames:  %u\n"
+			   "packets: %u\n"
+			   "empty:   %u (%u %%)\n"
+			   "errors:  %u\n"
+			   "invalid: %u\n",
 			   stream->stats.stream.nb_frames,
 			   stream->stats.stream.nb_packets,
 			   stream->stats.stream.nb_empty,
+			   empty_ratio,
 			   stream->stats.stream.nb_errors,
 			   stream->stats.stream.nb_invalid);
 	count += scnprintf(buf + count, size - count,
@@ -903,6 +955,53 @@ size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
 			   stream->stats.stream.min_sof,
 			   stream->stats.stream.max_sof,
 			   scr_sof_freq / 1000, scr_sof_freq % 1000);
+	count += scnprintf(buf + count, size - count,
+			   "bytes %lld : duration %d\n",
+			   bytes, duration);
+
+	if (duration != 0) {
+		/* Duration is in milliseconds, * 100 to gain 2 dp precision */
+		fps = stream->stats.stream.nb_frames * 1000 * 100 / duration;
+		/* CPU usage as a % with 6 decimal places */
+		cpu = stream->stats.urbstat.decode.duration / duration * 100;
+	}
+
+	count += scnprintf(buf + count, size - count,
+			   "FPS: %u.%02u\n", fps / 100, fps % 100);
+
+	/* Processing Times */
+
+	count += uvc_video_dump_time_stats(buf + count, size - count,
+			   &stream->stats.urbstat.urb, "URB");
+	count += uvc_video_dump_time_stats(buf + count, size - count,
+			   &stream->stats.urbstat.header, "header");
+	count += uvc_video_dump_time_stats(buf + count, size - count,
+			   &stream->stats.urbstat.latency, "latency");
+	count += uvc_video_dump_time_stats(buf + count, size - count,
+			   &stream->stats.urbstat.decode, "decode");
+
+	/* Processing Speeds */
+
+	/* This should be representative of the memory bus / cpu speed */
+	count += uvc_video_dump_speed(buf + count, size - count,
+			   "raw decode speed",
+			   bytes,
+			   stream->stats.urbstat.decode.duration / 1000000);
+
+	/* Raw bus speed - scheduling latencies */
+	count += uvc_video_dump_speed(buf + count, size - count,
+			   "raw URB handling speed",
+			   bytes,
+			   stream->stats.urbstat.urb.duration / 1000000);
+
+	/* Throughput against wall clock time, stream duration is in millis*/
+	count += uvc_video_dump_speed(buf + count, size - count,
+			   "throughput", bytes, duration);
+
+	/* Determine the 'CPU Usage' of our URB processing */
+	count += scnprintf(buf + count, size - count,
+			   "URB decode CPU usage %llu.%06llu %%\n",
+			   cpu / 1000000, cpu % 1000000);
 
 	return count;
 }
@@ -911,6 +1010,10 @@ static void uvc_video_stats_start(struct uvc_streaming *stream)
 {
 	memset(&stream->stats, 0, sizeof(stream->stats));
 	stream->stats.stream.min_sof = 2048;
+
+	stream->stats.urbstat.urb.min = -1;
+	stream->stats.urbstat.latency.min = -1;
+	stream->stats.urbstat.decode.min = -1;
 }
 
 static void uvc_video_stats_stop(struct uvc_streaming *stream)
@@ -918,6 +1021,27 @@ static void uvc_video_stats_stop(struct uvc_streaming *stream)
 	stream->stats.stream.stop_ts = ktime_get();
 }
 
+static s64 uvc_stats_add(struct uvc_stats_time *s,
+			 const ktime_t a, const ktime_t b)
+{
+	ktime_t delta;
+	u64 duration;
+
+	delta = ktime_sub(b, a);
+	duration = ktime_to_ns(delta);
+
+	s->qty++;
+	s->duration += duration;
+
+	if (duration < s->min)
+		s->min = duration;
+
+	if (duration > s->max)
+		s->max = duration;
+
+	return duration;
+}
+
 /* ------------------------------------------------------------------------
  * Video codecs
  */
@@ -981,6 +1105,9 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 		stream->sequence++;
 		if (stream->sequence)
 			uvc_video_stats_update(stream);
+
+		/* Update the stream timer each frame */
+		stream->stats.stream.stop_ts = ktime_get();
 	}
 
 	uvc_video_clock_decode(stream, buf, data, len);
@@ -1063,18 +1190,34 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 static void uvc_video_copy_data_work(struct work_struct *work)
 {
 	struct uvc_urb *uvc_urb = container_of(work, struct uvc_urb, work);
+	ktime_t now;
 	unsigned int i;
 	int ret;
 
+	/* Measure decode performance */
+	uvc_urb->decode_start = ktime_get();
+	/* Measure scheduling latency */
+	uvc_stats_add(&uvc_urb->stream->stats.urbstat.latency,
+		      uvc_urb->received, uvc_urb->decode_start);
+
 	for (i = 0; i < uvc_urb->async_operations; i++) {
 		struct uvc_copy_op *op = &uvc_urb->copy_operations[i];
 
 		memcpy(op->dst, op->src, op->len);
+		uvc_urb->stream->stats.stream.bytes += op->len;
 
 		/* Release reference taken on this buffer */
 		uvc_queue_buffer_release(op->buf);
 	}
 
+	now = ktime_get();
+	/* measure 'memcpy time' */
+	uvc_stats_add(&uvc_urb->stream->stats.urbstat.decode,
+		      uvc_urb->decode_start, now);
+	/* measure 'full urb processing time' */
+	uvc_stats_add(&uvc_urb->stream->stats.urbstat.urb,
+		      uvc_urb->received, now);
+
 	ret = usb_submit_urb(uvc_urb->urb, GFP_ATOMIC);
 	if (ret < 0)
 		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
@@ -1461,6 +1604,9 @@ static void uvc_video_complete(struct urb *urb)
 	unsigned long flags;
 	int ret;
 
+	/* Track URB processing performance */
+	uvc_urb->received = ktime_get();
+
 	switch (urb->status) {
 	case 0:
 		break;
@@ -1512,6 +1658,9 @@ static void uvc_video_complete(struct urb *urb)
 
 	INIT_WORK(&uvc_urb->work, uvc_video_copy_data_work);
 	queue_work(stream->async_wq, &uvc_urb->work);
+
+	uvc_stats_add(&uvc_urb->stream->stats.urbstat.header,
+		      uvc_urb->received, ktime_get());
 }
 
 /*
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 7ebeb680710b..efaa55a24a68 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -462,6 +462,13 @@ struct uvc_stats_frame {
 	u32 scr_stc;			/* SCR.STC of the last packet */
 };
 
+struct uvc_stats_time {
+	u64 duration;			/* Cumulative total duration between two events */
+	unsigned int qty;		/* Number of events represented in the total */
+	unsigned int min;		/* Shortest duration */
+	unsigned int max;		/* Longest duration */
+};
+
 struct uvc_stats_stream {
 	ktime_t start_ts;		/* Stream start timestamp */
 	ktime_t stop_ts;		/* Stream stop timestamp */
@@ -483,6 +490,8 @@ struct uvc_stats_stream {
 	unsigned int scr_sof;		/* STC.SOF of the last packet */
 	unsigned int min_sof;		/* Minimum STC.SOF value */
 	unsigned int max_sof;		/* Maximum STC.SOF value */
+
+	unsigned long bytes;		/* Successfully transferred bytes */
 };
 
 #define UVC_METATADA_BUF_SIZE 1024
@@ -512,6 +521,8 @@ struct uvc_copy_op {
  * @async_operations: counter to indicate the number of copy operations
  * @copy_operations: work descriptors for asynchronous copy operations
  * @work: work queue entry for asynchronous decode
+ * @received: URB interrupt time stamp
+ * @decode_start: URB processing start time stamp
  */
 struct uvc_urb {
 	struct urb *urb;
@@ -523,6 +534,9 @@ struct uvc_urb {
 	unsigned int async_operations;
 	struct uvc_copy_op copy_operations[UVC_MAX_PACKETS];
 	struct work_struct work;
+
+	ktime_t received;
+	ktime_t decode_start;
 };
 
 struct uvc_streaming {
@@ -585,6 +599,12 @@ struct uvc_streaming {
 	struct {
 		struct uvc_stats_frame frame;
 		struct uvc_stats_stream stream;
+		struct uvc_stats_urb {
+			struct uvc_stats_time header;
+			struct uvc_stats_time latency;
+			struct uvc_stats_time decode;
+			struct uvc_stats_time urb;
+		} urbstat;
 	} stats;
 
 	/* Timestamps support. */
-- 
2.17.1


--------------46588E624CE5F8B368D380F2--
