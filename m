Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44037 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3KKB0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 20:26:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 13/19] uvcvideo: Unify UVC payload header parsing.
Date: Mon, 11 Nov 2013 02:27:18 +0100
Message-ID: <1816510.MevHWrmTYX@avalon>
In-Reply-To: <1377829038-4726-14-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-14-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:12 Pawel Osciak wrote:
> Create a separate function for parsing UVC payload headers and extract code
> from other functions into it. Store the parsed values in a header struct.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 270 ++++++++++++++++++-----------------
>  drivers/media/usb/uvc/uvcvideo.h  |  21 +++
>  2 files changed, 157 insertions(+), 134 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 2f9a5fa..59f57a2 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -422,40 +422,14 @@ static int uvc_commit_video(struct uvc_streaming
> *stream,
> 
>  static void
>  uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer
> *buf,
> -		       const __u8 *data, int len)
> +			struct uvc_payload_header *header)
>  {
>  	struct uvc_clock_sample *sample;
> -	unsigned int header_size;
> -	bool has_pts = false;
> -	bool has_scr = false;
>  	unsigned long flags;
>  	struct timespec ts;
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
> -	/* Check for invalid headers. */
> -	if (len < header_size)
> -		return;
> -
>  	/* Extract the timestamps:
>  	 *
>  	 * - store the frame PTS in the buffer structure
> @@ -463,17 +437,17 @@ uvc_video_clock_decode(struct uvc_streaming *stream,
> struct uvc_buffer *buf, *   kernel timestamps and store them with the SCR
> STC and SOF fields *   in the ring buffer
>  	 */
> -	if (has_pts && buf != NULL)
> -		buf->pts = get_unaligned_le32(&data[2]);
> +	if (header->has_pts && buf != NULL)
> +		buf->pts = header->pts;
> 
> -	if (!has_scr)
> +	if (!header->has_scr)
>  		return;
> 
>  	/* To limit the amount of data, drop SCRs with an SOF identical to the
>  	 * previous one.
>  	 */
> -	dev_sof = get_unaligned_le16(&data[header_size - 2]);
> -	if (dev_sof == stream->clock.last_sof)
> +	dev_sof = header->sof;
> +	if (dev_sof <= stream->clock.last_sof)

This change (== -> <=) is unrelated. If it's need it please split it to a 
separate patch.

>  		return;
> 
>  	stream->clock.last_sof = dev_sof;
> @@ -513,7 +487,7 @@ uvc_video_clock_decode(struct uvc_streaming *stream,
> struct uvc_buffer *buf, spin_lock_irqsave(&stream->clock.lock, flags);
> 
>  	sample = &stream->clock.samples[stream->clock.head];
> -	sample->dev_stc = get_unaligned_le32(&data[header_size - 6]);
> +	sample->dev_stc = header->stc;
>  	sample->dev_sof = dev_sof;
>  	sample->host_sof = host_sof;
>  	sample->host_ts = ts;
> @@ -756,114 +730,74 @@ done:
>   */
> 
>  static void uvc_video_stats_decode(struct uvc_streaming *stream,
> -		const __u8 *data, int len)
> +				    struct uvc_payload_header *header)
>  {
> -	unsigned int header_size;
> -	bool has_pts = false;
> -	bool has_scr = false;
> -	u16 uninitialized_var(scr_sof);
> -	u32 uninitialized_var(scr_stc);
> -	u32 uninitialized_var(pts);
> -
>  	if (stream->stats.stream.nb_frames == 0 &&
>  	    stream->stats.frame.nb_packets == 0)
>  		ktime_get_ts(&stream->stats.stream.start_ts);
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
> -	/* Check for invalid headers. */
> -	if (len < header_size || data[0] < header_size) {
> -		stream->stats.frame.nb_invalid++;
> -		return;
> -	}
> -
> -	/* Extract the timestamps. */
> -	if (has_pts)
> -		pts = get_unaligned_le32(&data[2]);
> -
> -	if (has_scr) {
> -		scr_stc = get_unaligned_le32(&data[header_size - 6]);
> -		scr_sof = get_unaligned_le16(&data[header_size - 2]);
> -	}
> -
>  	/* Is PTS constant through the whole frame ? */
> -	if (has_pts && stream->stats.frame.nb_pts) {
> -		if (stream->stats.frame.pts != pts) {
> +	if (header->has_pts && stream->stats.frame.nb_pts) {
> +		if (stream->stats.frame.pts != header->pts) {
>  			stream->stats.frame.nb_pts_diffs++;
>  			stream->stats.frame.last_pts_diff =
>  				stream->stats.frame.nb_packets;
>  		}
>  	}
> 
> -	if (has_pts) {
> +	if (header->has_pts) {
>  		stream->stats.frame.nb_pts++;
> -		stream->stats.frame.pts = pts;
> +		stream->stats.frame.pts = header->pts;
>  	}
> 
>  	/* Do all frames have a PTS in their first non-empty packet, or before
>  	 * their first empty packet ?
>  	 */
>  	if (stream->stats.frame.size == 0) {
> -		if (len > header_size)
> -			stream->stats.frame.has_initial_pts = has_pts;
> -		if (len == header_size && has_pts)
> +		if (header->payload_size > 0)
> +			stream->stats.frame.has_initial_pts = header->has_pts;
> +		if (header->payload_size == 0 && header->has_pts)
>  			stream->stats.frame.has_early_pts = true;
>  	}
> 
>  	/* Do the SCR.STC and SCR.SOF fields vary through the frame ? */
> -	if (has_scr && stream->stats.frame.nb_scr) {
> -		if (stream->stats.frame.scr_stc != scr_stc)
> +	if (header->has_scr && stream->stats.frame.nb_scr) {
> +		if (stream->stats.frame.scr_stc != header->stc)
>  			stream->stats.frame.nb_scr_diffs++;
>  	}
> 
> -	if (has_scr) {
> +	if (header->has_scr) {
>  		/* Expand the SOF counter to 32 bits and store its value. */
>  		if (stream->stats.stream.nb_frames > 0 ||
>  		    stream->stats.frame.nb_scr > 0)
>  			stream->stats.stream.scr_sof_count +=
> -				(scr_sof - stream->stats.stream.scr_sof) % 2048;
> -		stream->stats.stream.scr_sof = scr_sof;
> +				(header->sof - stream->stats.stream.scr_sof)
> +				% 2048;
> +		stream->stats.stream.scr_sof = header->sof;
> 
>  		stream->stats.frame.nb_scr++;
> -		stream->stats.frame.scr_stc = scr_stc;
> -		stream->stats.frame.scr_sof = scr_sof;
> +		stream->stats.frame.scr_stc = header->stc;
> +		stream->stats.frame.scr_sof = header->sof;
> 
> -		if (scr_sof < stream->stats.stream.min_sof)
> -			stream->stats.stream.min_sof = scr_sof;
> -		if (scr_sof > stream->stats.stream.max_sof)
> -			stream->stats.stream.max_sof = scr_sof;
> +		if (header->sof < stream->stats.stream.min_sof)
> +			stream->stats.stream.min_sof = header->sof;
> +		if (header->sof > stream->stats.stream.max_sof)
> +			stream->stats.stream.max_sof = header->sof;
>  	}
> 
>  	/* Record the first non-empty packet number. */
> -	if (stream->stats.frame.size == 0 && len > header_size)
> +	if (stream->stats.frame.size == 0 && header->payload_size > 0)
>  		stream->stats.frame.first_data = stream->stats.frame.nb_packets;
> 
>  	/* Update the frame size. */
> -	stream->stats.frame.size += len - header_size;
> +	stream->stats.frame.size += header->payload_size;
> 
>  	/* Update the packets counters. */
>  	stream->stats.frame.nb_packets++;
> -	if (len > header_size)
> +	if (header->payload_size == 0)

This fixes a bug, could you please split it to a separate patch ? Just turn 
len > header_size into len == header_size in a bugfix patch of its own, before 
this one.

>  		stream->stats.frame.nb_empty++;
> 
> -	if (data[1] & UVC_STREAM_ERR)
> +	if (header->has_err)
>  		stream->stats.frame.nb_errors++;
>  }
> 
> @@ -1006,21 +940,9 @@ static void uvc_video_stats_stop(struct uvc_streaming
> *stream) * uvc_video_decode_end will never be called with a NULL buffer.
>   */
>  static int uvc_video_decode_start(struct uvc_streaming *stream,
> -		struct uvc_buffer *buf, const __u8 *data, int len)
> +		struct uvc_buffer *buf, struct uvc_payload_header *header)
>  {
> -	__u8 fid;
> -
> -	/* Sanity checks:
> -	 * - packet must be at least 2 bytes long
> -	 * - bHeaderLength value must be at least 2 bytes (see above)
> -	 * - bHeaderLength value can't be larger than the packet size.
> -	 */
> -	if (len < 2 || data[0] < 2 || data[0] > len) {
> -		stream->stats.frame.nb_invalid++;
> -		return -EINVAL;
> -	}
> -
> -	fid = data[1] & UVC_STREAM_FID;
> +	u8 fid = header->fid;
> 
>  	/* Increase the sequence number regardless of any buffer states, so
>  	 * that discontinuous sequence numbers always indicate lost frames.
> @@ -1031,8 +953,8 @@ static int uvc_video_decode_start(struct uvc_streaming
> *stream, uvc_video_stats_update(stream);
>  	}
> 
> -	uvc_video_clock_decode(stream, buf, data, len);
> -	uvc_video_stats_decode(stream, data, len);
> +	uvc_video_clock_decode(stream, buf, header);
> +	uvc_video_stats_decode(stream, header);
> 
>  	/* Store the payload FID bit and return immediately when the buffer is
>  	 * NULL.
> @@ -1043,7 +965,7 @@ static int uvc_video_decode_start(struct uvc_streaming
> *stream, }
> 
>  	/* Mark the buffer as bad if the error bit is set. */
> -	if (data[1] & UVC_STREAM_ERR) {
> +	if (header->has_err) {
>  		uvc_trace(UVC_TRACE_FRAME, "Marking buffer as bad (error bit "
>  			  "set).\n");
>  		buf->error = 1;
> @@ -1064,7 +986,7 @@ static int uvc_video_decode_start(struct uvc_streaming
> *stream, uvc_trace(UVC_TRACE_FRAME, "Dropping payload (out of "
>  				"sync).\n");
>  			if ((stream->dev->quirks & UVC_QUIRK_STREAM_NO_FID) &&
> -			    (data[1] & UVC_STREAM_EOF))
> +			    (header->has_eof))
>  				stream->last_fid ^= UVC_STREAM_FID;
>  			return -ENODATA;
>  		}
> @@ -1107,7 +1029,7 @@ static int uvc_video_decode_start(struct uvc_streaming
> *stream,
> 
>  	stream->last_fid = fid;
> 
> -	return data[0];
> +	return 0;
>  }
> 
>  static void uvc_video_decode_data(struct uvc_streaming *stream,
> @@ -1128,18 +1050,20 @@ static void uvc_video_decode_data(struct
> uvc_streaming *stream,
> 
>  	/* Complete the current frame if the buffer size was exceeded. */
>  	if (len > maxlen) {
> -		uvc_trace(UVC_TRACE_FRAME, "Frame complete (overflow).\n");
> +		uvc_trace(UVC_TRACE_FRAME, "Frame complete (overflow) "
> +				"len=%d, buffer size=%d used=%d\n",

The sizes can't be negative, please use %u.

> +				len, buf->length, buf->bytesused);

Do we actually need to print that extra information ? :-) Did you find it 
useful during development ?

>  		buf->state = UVC_BUF_STATE_READY;
>  	}
>  }
> 
>  static void uvc_video_decode_end(struct uvc_streaming *stream,
> -		struct uvc_buffer *buf, const __u8 *data, int len)
> +		struct uvc_buffer *buf, struct uvc_payload_header *header)
>  {
>  	/* Mark the buffer as done if the EOF marker is set. */
> -	if (data[1] & UVC_STREAM_EOF && buf->bytesused != 0) {
> +	if (header->has_eof && buf->bytesused != 0) {
>  		uvc_trace(UVC_TRACE_FRAME, "Frame complete (EOF found).\n");
> -		if (data[0] == len)
> +		if (header->payload_size == 0)
>  			uvc_trace(UVC_TRACE_FRAME, "EOF in empty payload.\n");
>  		buf->state = UVC_BUF_STATE_READY;
>  		if (stream->dev->quirks & UVC_QUIRK_STREAM_NO_FID)
> @@ -1186,6 +1110,75 @@ static int uvc_video_encode_data(struct uvc_streaming
> *stream, return nbytes;
>  }
> 
> +static int uvc_video_parse_header(struct uvc_streaming *stream,
> +		const __u8 *data, int len, struct uvc_payload_header *header)
> +{
> +	int off = 2;

The offset can't be negative, you can thus use an unsigned int type. And I 
don't think there's a need to abbreviate the variable name, you can call it 
offset. The lines below are not that long.

> +
> +	/* Sanity checks:
> +	 * - packet must be at least 2 bytes long
> +	 * - bHeaderLength value must be at least 2 bytes (see above)
> +	 */
> +	if (len < 2 || data[0] < 2)
> +		goto error;
> +
> +	header->length = 2; /* 1 byte of header length + 1 byte of BFH. */
> +
> +	header->has_sli = false;
> +	header->has_eof = data[1] & UVC_STREAM_EOF;
> +	header->has_pts = data[1] & UVC_STREAM_PTS;
> +	header->has_scr = data[1] & UVC_STREAM_SCR;
> +	header->has_err = data[1] & UVC_STREAM_ERR;
> +
> +	if (header->has_pts)
> +		header->length += 4;
> +
> +	if (header->has_scr)
> +		header->length += 6;
> +
> +	if (stream->cur_format->fcc == V4L2_PIX_FMT_VP8) {
> +		/* VP8 payload has 2 additional bytes of BFH. */
> +		header->length += 2;
> +		off += 2;
> +
> +		/* SLI always present for VP8 simulcast (at the end of header),
> +		 * allowed for VP8 non-simulcast.
> +		 */
> +		header->has_sli = data[1] & UVC_STREAM_SLI;
> +		if (header->has_sli)
> +			header->length += 2;
> +	}
> +
> +	/* - bHeaderLength value can't be larger than the packet size. */
> +	if (len < data[0] || data[0] != header->length)

Can you keep the comment and the len < data[0] check above with the other 
sanity checks as in the original code ? The data[0] != header->length check 
obviously needs to stay here.

> +		goto error;
> +
> +	/* PTS 4 bytes, STC 4 bytes, SOF 2 bytes. */
> +	if (header->has_pts) {
> +		header->pts = get_unaligned_le32(&data[off]);
> +		off += 4;
> +	}
> +
> +	if (header->has_scr) {
> +		header->stc = get_unaligned_le32(&data[off]);
> +		off += 4;
> +		header->sof = get_unaligned_le16(&data[off]);
> +		off += 2;
> +	}
> +
> +	if (header->has_sli)
> +		header->sli = get_unaligned_le16(&data[off]);
> +
> +	header->payload_size = len - header->length;
> +	header->fid = data[1] & UVC_STREAM_FID;
> +
> +	return 0;
> +
> +error:
> +	stream->stats.frame.nb_invalid++;
> +	return -EINVAL;
> +}
> +
>  /* ------------------------------------------------------------------------
> * URB handling
>   */
> @@ -1195,9 +1188,11 @@ static int uvc_video_encode_data(struct uvc_streaming
> *stream, */
>  static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming
> *stream) {
> +	unsigned int len;
>  	u8 *mem;
>  	int ret, i;
>  	struct uvc_buffer *buf = NULL;
> +	struct uvc_payload_header header;

Could you move this line to the top of the function ? I try to keep variable 
declarations more or less sorted by line size, even though it seems I've 
failed to do so in every location in this driver :-)

> 
>  	for (i = 0; i < urb->number_of_packets; ++i) {
>  		if (urb->iso_frame_desc[i].status < 0) {
> @@ -1209,12 +1204,16 @@ static void uvc_video_decode_isoc(struct urb *urb,
> struct uvc_streaming *stream) continue;
>  		}
> 
> -		/* Decode the payload header. */
>  		mem = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
> +		len = urb->iso_frame_desc[i].actual_length;
> +
> +		ret = uvc_video_parse_header(stream, mem, len, &header);
> +		if (ret < 0)
> +			continue;
> +
>  		buf = uvc_queue_get_first_buf(&stream->queue);
>  		do {
> -			ret = uvc_video_decode_start(stream, buf, mem,
> -				urb->iso_frame_desc[i].actual_length);
> +			ret = uvc_video_decode_start(stream, buf, &header);
>  			if (ret == -EAGAIN)
>  				buf = uvc_queue_next_buffer(&stream->queue,
>  							    buf);
> @@ -1224,12 +1223,11 @@ static void uvc_video_decode_isoc(struct urb *urb,
> struct uvc_streaming *stream) continue;
> 
>  		/* Decode the payload data. */
> -		uvc_video_decode_data(stream, buf, mem + ret,
> -			urb->iso_frame_desc[i].actual_length - ret);
> +		uvc_video_decode_data(stream, buf, mem + header.length,
> +			urb->iso_frame_desc[i].actual_length - header.length);
> 
>  		/* Process the header again. */
> -		uvc_video_decode_end(stream, buf, mem,
> -			urb->iso_frame_desc[i].actual_length);
> +		uvc_video_decode_end(stream, buf, &header);
> 
>  		if (buf->state == UVC_BUF_STATE_READY) {
>  			if (buf->length != buf->bytesused &&
> @@ -1246,6 +1244,7 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) {
>  	u8 *mem;
>  	int len, ret;
> +	struct uvc_payload_header header;
>  	struct uvc_buffer *buf;
> 
>  	/*
> @@ -1259,6 +1258,10 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) len = urb->actual_length;
>  	stream->bulk.payload_size += len;
> 
> +	ret = uvc_video_parse_header(stream, mem, len, &header);
> +	if (ret < 0)
> +		return;
> +
>  	buf = uvc_queue_get_first_buf(&stream->queue);
> 
>  	/* If the URB is the first of its payload, decode and save the
> @@ -1266,7 +1269,7 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) */
>  	if (stream->bulk.header_size == 0 && !stream->bulk.skip_payload) {
>  		do {
> -			ret = uvc_video_decode_start(stream, buf, mem, len);
> +			ret = uvc_video_decode_start(stream, buf, &header);
>  			if (ret == -EAGAIN)
>  				buf = uvc_queue_next_buffer(&stream->queue,
>  							    buf);
> @@ -1276,11 +1279,11 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) if (ret < 0 || buf == NULL) {
>  			stream->bulk.skip_payload = 1;
>  		} else {
> -			memcpy(stream->bulk.header, mem, ret);
> -			stream->bulk.header_size = ret;
> +			memcpy(stream->bulk.header, mem, header.length);
> +			stream->bulk.header_size = header.length;
> 
> -			mem += ret;
> -			len -= ret;
> +			mem += header.length;
> +			len -= header.length;
>  		}
>  	}
> 
> @@ -1299,8 +1302,7 @@ static void uvc_video_decode_bulk(struct urb *urb,
> struct uvc_streaming *stream) if (urb->actual_length <
> urb->transfer_buffer_length ||
>  	    stream->bulk.payload_size >= stream->bulk.max_payload_size) {
>  		if (!stream->bulk.skip_payload && buf != NULL) {
> -			uvc_video_decode_end(stream, buf, stream->bulk.header,
> -				stream->bulk.payload_size);
> +			uvc_video_decode_end(stream, buf, &header);
>  			if (buf->state == UVC_BUF_STATE_READY)
>  				buf = uvc_queue_next_buffer(&stream->queue,
>  							    buf);
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index bca8715..b355b2c 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -453,6 +453,27 @@ struct uvc_stats_stream {
>  	unsigned int max_sof;		/* Maximum STC.SOF value */
>  };
> 
> +struct uvc_payload_header {
> +	bool has_eof;
> +
> +	bool has_pts;
> +	u32 pts;
> +
> +	bool has_scr;
> +	u16 sof;
> +	u32 stc;
> +
> +	bool has_sli;
> +	u16 sli;
> +
> +	u8 fid;
> +
> +	bool has_err;
> +
> +	int length;
> +	int payload_size;
> +};
> +
>  struct uvc_streaming {
>  	struct list_head list;
>  	struct uvc_device *dev;
-- 
Regards,

Laurent Pinchart

