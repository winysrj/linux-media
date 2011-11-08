Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35476 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1KHMGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 07:06:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Yann Sionneau <yann@minet.net>
Subject: [PATCH 3/4] uvcvideo: Extract timestamp-related statistics
Date: Tue,  8 Nov 2011 13:06:01 +0100
Message-Id: <1320753962-14079-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1320753962-14079-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1320753962-14079-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_video.c |  125 ++++++++++++++++++++++++++++++++++-
 drivers/media/video/uvc/uvcvideo.h  |   23 +++++++
 2 files changed, 146 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 1908dd8..513ba30 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -365,6 +365,11 @@ static void uvc_video_stats_decode(struct uvc_streaming *stream,
 		const __u8 *data, int len)
 {
 	unsigned int header_size;
+	bool has_pts = false;
+	bool has_scr = false;
+	u16 uninitialized_var(scr_sof);
+	u32 uninitialized_var(scr_stc);
+	u32 uninitialized_var(pts);
 
 	if (stream->stats.stream.nb_frames == 0 &&
 	    stream->stats.frame.nb_packets == 0)
@@ -373,12 +378,16 @@ static void uvc_video_stats_decode(struct uvc_streaming *stream,
 	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
 	case UVC_STREAM_PTS | UVC_STREAM_SCR:
 		header_size = 12;
+		has_pts = true;
+		has_scr = true;
 		break;
 	case UVC_STREAM_PTS:
 		header_size = 6;
+		has_pts = true;
 		break;
 	case UVC_STREAM_SCR:
 		header_size = 8;
+		has_scr = true;
 		break;
 	default:
 		header_size = 2;
@@ -391,6 +400,63 @@ static void uvc_video_stats_decode(struct uvc_streaming *stream,
 		return;
 	}
 
+	/* Extract the timestamps. */
+	if (has_pts)
+		pts = get_unaligned_le32(&data[2]);
+
+	if (has_scr) {
+		scr_stc = get_unaligned_le32(&data[header_size - 6]);
+		scr_sof = get_unaligned_le16(&data[header_size - 2]);
+	}
+
+	/* Is PTS constant through the whole frame ? */
+	if (has_pts && stream->stats.frame.nb_pts) {
+		if (stream->stats.frame.pts != pts) {
+			stream->stats.frame.nb_pts_diffs++;
+			stream->stats.frame.last_pts_diff =
+				stream->stats.frame.nb_packets;
+		}
+	}
+
+	if (has_pts) {
+		stream->stats.frame.nb_pts++;
+		stream->stats.frame.pts = pts;
+	}
+
+	/* Do all frames have a PTS in their first non-empty packet, or before
+	 * their first empty packet ?
+	 */
+	if (stream->stats.frame.size == 0) {
+		if (len > header_size)
+			stream->stats.frame.has_initial_pts = has_pts;
+		if (len == header_size && has_pts)
+			stream->stats.frame.has_early_pts = true;
+	}
+
+	/* Do the SCR.STC and SCR.SOF fields vary through the frame ? */
+	if (has_scr && stream->stats.frame.nb_scr) {
+		if (stream->stats.frame.scr_stc != scr_stc)
+			stream->stats.frame.nb_scr_diffs++;
+	}
+
+	if (has_scr) {
+		/* Expand the SOF counter to 32 bits and store its value. */
+		if (stream->stats.stream.nb_frames > 0 ||
+		    stream->stats.frame.nb_scr > 0)
+			stream->stats.stream.scr_sof_count +=
+				(scr_sof - stream->stats.stream.scr_sof) % 2048;
+		stream->stats.stream.scr_sof = scr_sof;
+
+		stream->stats.frame.nb_scr++;
+		stream->stats.frame.scr_stc = scr_stc;
+		stream->stats.frame.scr_sof = scr_sof;
+
+		if (scr_sof < stream->stats.stream.min_sof)
+			stream->stats.stream.min_sof = scr_sof;
+		if (scr_sof > stream->stats.stream.max_sof)
+			stream->stats.stream.max_sof = scr_sof;
+	}
+
 	/* Record the first non-empty packet number. */
 	if (stream->stats.frame.size == 0 && len > header_size)
 		stream->stats.frame.first_data = stream->stats.frame.nb_packets;
@@ -411,9 +477,16 @@ static void uvc_video_stats_update(struct uvc_streaming *stream)
 {
 	struct uvc_stats_frame *frame = &stream->stats.frame;
 
-	uvc_trace(UVC_TRACE_STATS, "frame %u stats: %u/%u/%u packets\n",
+	uvc_trace(UVC_TRACE_STATS, "frame %u stats: %u/%u/%u packets, "
+		  "%u/%u/%u pts (%searly %sinitial), %u/%u scr, "
+		  "last pts/stc/sof %u/%u/%u\n",
 		  stream->sequence, frame->first_data,
-		  frame->nb_packets - frame->nb_empty, frame->nb_packets);
+		  frame->nb_packets - frame->nb_empty, frame->nb_packets,
+		  frame->nb_pts_diffs, frame->last_pts_diff, frame->nb_pts,
+		  frame->has_early_pts ? "" : "!",
+		  frame->has_initial_pts ? "" : "!",
+		  frame->nb_scr_diffs, frame->nb_scr,
+		  frame->pts, frame->scr_stc, frame->scr_sof);
 
 	stream->stats.stream.nb_frames++;
 	stream->stats.stream.nb_packets += stream->stats.frame.nb_packets;
@@ -421,14 +494,47 @@ static void uvc_video_stats_update(struct uvc_streaming *stream)
 	stream->stats.stream.nb_errors += stream->stats.frame.nb_errors;
 	stream->stats.stream.nb_invalid += stream->stats.frame.nb_invalid;
 
+	if (frame->has_early_pts)
+		stream->stats.stream.nb_pts_early++;
+	if (frame->has_initial_pts)
+		stream->stats.stream.nb_pts_initial++;
+	if (frame->last_pts_diff <= frame->first_data)
+		stream->stats.stream.nb_pts_constant++;
+	if (frame->nb_scr >= frame->nb_packets - frame->nb_empty)
+		stream->stats.stream.nb_scr_count_ok++;
+	if (frame->nb_scr_diffs + 1 == frame->nb_scr)
+		stream->stats.stream.nb_scr_diffs_ok++;
+
 	memset(&stream->stats.frame, 0, sizeof(stream->stats.frame));
 }
 
 size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
 			    size_t size)
 {
+	unsigned int scr_sof_freq;
+	unsigned int duration;
+	struct timespec ts;
 	size_t count = 0;
 
+	ts.tv_sec = stream->stats.stream.stop_ts.tv_sec
+		  - stream->stats.stream.start_ts.tv_sec;
+	ts.tv_nsec = stream->stats.stream.stop_ts.tv_nsec
+		   - stream->stats.stream.start_ts.tv_nsec;
+	if (ts.tv_nsec < 0) {
+		ts.tv_sec--;
+		ts.tv_nsec += 1000000000;
+	}
+
+	/* Compute the SCR.SOF frequency estimate. At the nominal 1kHz SOF
+	 * frequency this will not overflow before more than 1h.
+	 */
+	duration = ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
+	if (duration != 0)
+		scr_sof_freq = stream->stats.stream.scr_sof_count * 1000
+			     / duration;
+	else
+		scr_sof_freq = 0;
+
 	count += scnprintf(buf + count, size - count,
 			   "frames:  %u\npackets: %u\nempty:   %u\n"
 			   "errors:  %u\ninvalid: %u\n",
@@ -437,6 +543,20 @@ size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
 			   stream->stats.stream.nb_empty,
 			   stream->stats.stream.nb_errors,
 			   stream->stats.stream.nb_invalid);
+	count += scnprintf(buf + count, size - count,
+			   "pts: %u early, %u initial, %u ok\n",
+			   stream->stats.stream.nb_pts_early,
+			   stream->stats.stream.nb_pts_initial,
+			   stream->stats.stream.nb_pts_constant);
+	count += scnprintf(buf + count, size - count,
+			   "scr: %u count ok, %u diff ok\n",
+			   stream->stats.stream.nb_scr_count_ok,
+			   stream->stats.stream.nb_scr_diffs_ok);
+	count += scnprintf(buf + count, size - count,
+			   "sof: %u <= sof <= %u, freq %u.%03u kHz\n",
+			   stream->stats.stream.min_sof,
+			   stream->stats.stream.max_sof,
+			   scr_sof_freq / 1000, scr_sof_freq % 1000);
 
 	return count;
 }
@@ -444,6 +564,7 @@ size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
 static void uvc_video_stats_start(struct uvc_streaming *stream)
 {
 	memset(&stream->stats, 0, sizeof(stream->stats));
+	stream->stats.stream.min_sof = 2048;
 }
 
 static void uvc_video_stats_stop(struct uvc_streaming *stream)
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index f9ee62e..e4d4b6d 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -364,6 +364,18 @@ struct uvc_stats_frame {
 	unsigned int nb_empty;		/* Number of empty packets */
 	unsigned int nb_invalid;	/* Number of packets with an invalid header */
 	unsigned int nb_errors;		/* Number of packets with the error bit set */
+
+	unsigned int nb_pts;		/* Number of packets with a PTS timestamp */
+	unsigned int nb_pts_diffs;	/* Number of PTS differences inside a frame */
+	unsigned int last_pts_diff;	/* Index of the last PTS difference */
+	bool has_initial_pts;		/* Whether the first non-empty packet has a PTS */
+	bool has_early_pts;		/* Whether a PTS is present before the first non-empty packet */
+	u32 pts;			/* PTS of the last packet */
+
+	unsigned int nb_scr;		/* Number of packets with a SCR timestamp */
+	unsigned int nb_scr_diffs;	/* Number of SCR.STC differences inside a frame */
+	u16 scr_sof;			/* SCR.SOF of the last packet */
+	u32 scr_stc;			/* SCR.STC of the last packet */
 };
 
 struct uvc_stats_stream {
@@ -376,6 +388,17 @@ struct uvc_stats_stream {
 	unsigned int nb_empty;		/* Number of empty packets */
 	unsigned int nb_invalid;	/* Number of packets with an invalid header */
 	unsigned int nb_errors;		/* Number of packets with the error bit set */
+
+	unsigned int nb_pts_constant;	/* Number of frames with constant PTS */
+	unsigned int nb_pts_early;	/* Number of frames with early PTS */
+	unsigned int nb_pts_initial;	/* Number of frames with initial PTS */
+
+	unsigned int nb_scr_count_ok;	/* Number of frames with at least one SCR per non empty packet */
+	unsigned int nb_scr_diffs_ok;	/* Number of frames with varying SCR.STC */
+	unsigned int scr_sof_count;	/* STC.SOF counter accumulated since stream start */
+	unsigned int scr_sof;		/* STC.SOF of the last packet */
+	unsigned int min_sof;		/* Minimum STC.SOF value */
+	unsigned int max_sof;		/* Maximum STC.SOF value */
 };
 
 struct uvc_streaming {
-- 
1.7.3.4

