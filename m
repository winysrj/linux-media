Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55097 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933978Ab1KCQWG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 12:22:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: bug-track@fisher-privat.net
Subject: [PATCH 2/2] uvcvideo: Extract video stream statistics
Date: Thu,  3 Nov 2011 17:22:03 +0100
Message-Id: <1320337323-26929-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <4E7983BA.7010103@fisher-privat.net>
References: <4E7983BA.7010103@fisher-privat.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Export the statistics through debugfs.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_debugfs.c |   60 ++++++++++++++++++
 drivers/media/video/uvc/uvc_video.c   |  111 ++++++++++++++++++++++++++++++++-
 drivers/media/video/uvc/uvcvideo.h    |   32 +++++++++-
 3 files changed, 201 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_debugfs.c b/drivers/media/video/uvc/uvc_debugfs.c
index f58969a..bdba016 100644
--- a/drivers/media/video/uvc/uvc_debugfs.c
+++ b/drivers/media/video/uvc/uvc_debugfs.c
@@ -18,6 +18,57 @@
 #include "uvcvideo.h"
 
 /* -----------------------------------------------------------------------------
+ * Statistics
+ */
+
+#define UVC_DEBUGFS_BUF_SIZE	1024
+
+struct uvc_debugfs_buffer {
+	size_t count;
+	char data[UVC_DEBUGFS_BUF_SIZE];
+};
+
+static int uvc_debugfs_stats_open(struct inode *inode, struct file *file)
+{
+	struct uvc_streaming *stream = inode->i_private;
+	struct uvc_debugfs_buffer *buf;
+
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	buf->count = uvc_video_stats_dump(stream, buf->data, sizeof(buf->data));
+
+	file->private_data = buf;
+	return 0;
+}
+
+static ssize_t uvc_debugfs_stats_read(struct file *file, char __user *user_buf,
+				      size_t nbytes, loff_t *ppos)
+{
+	struct uvc_debugfs_buffer *buf = file->private_data;
+
+	return simple_read_from_buffer(user_buf, nbytes, ppos, buf->data,
+				       buf->count);
+}
+
+static int uvc_debugfs_stats_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	file->private_data = NULL;
+
+	return 0;
+}
+
+static const struct file_operations uvc_debugfs_stats_fops = {
+	.owner = THIS_MODULE,
+	.open = uvc_debugfs_stats_open,
+	.llseek = no_llseek,
+	.read = uvc_debugfs_stats_read,
+	.release = uvc_debugfs_stats_release,
+};
+
+/* -----------------------------------------------------------------------------
  * Global and stream initialization/cleanup
  */
 
@@ -43,6 +94,15 @@ int uvc_debugfs_init_stream(struct uvc_streaming *stream)
 
 	stream->debugfs_dir = dent;
 
+	dent = debugfs_create_file("stats", 0600, stream->debugfs_dir,
+				   stream, &uvc_debugfs_stats_fops);
+	if (IS_ERR_OR_NULL(dent)) {
+		uvc_printk(KERN_INFO, "Unable to create debugfs %s directory.\n",
+			   dir_name);
+		uvc_debugfs_cleanup_stream(stream);
+		return -ENODEV;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index a57f813..2ab92a7 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -358,6 +358,106 @@ static int uvc_commit_video(struct uvc_streaming *stream,
 }
 
 /* ------------------------------------------------------------------------
+ * Timestamp statistics
+ */
+
+static void uvc_video_stats_decode(struct uvc_streaming *stream,
+		const __u8 *data, int len)
+{
+	unsigned int header_size;
+
+	if (stream->stats.stream.nb_frames == 0 &&
+	    stream->stats.frame.nb_packets == 0)
+		ktime_get_ts(&stream->stats.stream.start_ts);
+
+	/* Make sure we have at least 2 bytes of header. */
+	if (len < 2) {
+		stream->stats.frame.nb_invalid++;
+		return;
+	}
+
+	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
+	case UVC_STREAM_PTS | UVC_STREAM_SCR:
+		header_size = 12;
+		break;
+	case UVC_STREAM_PTS:
+		header_size = 6;
+		break;
+	case UVC_STREAM_SCR:
+		header_size = 8;
+		break;
+	default:
+		header_size = 2;
+		break;
+	}
+
+	/* Check for invalid headers. */
+	if (len < header_size || data[0] < header_size) {
+		stream->stats.frame.nb_invalid++;
+		return;
+	}
+
+	/* Record the first non-empty packet number. */
+	if (stream->stats.frame.size == 0 && len > header_size)
+		stream->stats.frame.first_data = stream->stats.frame.nb_packets;
+
+	/* Update the frame size. */
+	stream->stats.frame.size += len - header_size;
+
+	/* Update the packets counters. */
+	stream->stats.frame.nb_packets++;
+	if (len > header_size)
+		stream->stats.frame.nb_empty++;
+
+	if (data[1] & UVC_STREAM_ERR)
+		stream->stats.frame.nb_errors++;
+}
+
+static void uvc_video_stats_update(struct uvc_streaming *stream)
+{
+	struct uvc_stats_frame *frame = &stream->stats.frame;
+
+	uvc_trace(UVC_TRACE_STATS, "frame %u stats: %u/%u/%u packets\n",
+		  stream->sequence, frame->first_data,
+		  frame->nb_packets - frame->nb_empty, frame->nb_packets);
+
+	stream->stats.stream.nb_frames++;
+	stream->stats.stream.nb_packets += stream->stats.frame.nb_packets;
+	stream->stats.stream.nb_empty += stream->stats.frame.nb_empty;
+	stream->stats.stream.nb_errors += stream->stats.frame.nb_errors;
+	stream->stats.stream.nb_invalid += stream->stats.frame.nb_invalid;
+
+	memset(&stream->stats.frame, 0, sizeof(stream->stats.frame));
+}
+
+size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
+			    size_t size)
+{
+	size_t count = 0;
+
+	count += scnprintf(buf + count, size - count,
+			   "frames:  %u\npackets: %u\nempty:   %u\n"
+			   "errors:  %u\ninvalid: %u\n",
+			   stream->stats.stream.nb_frames,
+			   stream->stats.stream.nb_packets,
+			   stream->stats.stream.nb_empty,
+			   stream->stats.stream.nb_errors,
+			   stream->stats.stream.nb_invalid);
+
+	return count;
+}
+
+static void uvc_video_stats_start(struct uvc_streaming *stream)
+{
+	memset(&stream->stats, 0, sizeof(stream->stats));
+}
+
+static void uvc_video_stats_stop(struct uvc_streaming *stream)
+{
+	ktime_get_ts(&stream->stats.stream.stop_ts);
+}
+
+/* ------------------------------------------------------------------------
  * Video codecs
  */
 
@@ -401,6 +501,8 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 {
 	__u8 fid;
 
+	uvc_video_stats_decode(stream, data, len);
+
 	/* Sanity checks:
 	 * - packet must be at least 2 bytes long
 	 * - bHeaderLength value must be at least 2 bytes (see above)
@@ -414,8 +516,11 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	/* Increase the sequence number regardless of any buffer states, so
 	 * that discontinuous sequence numbers always indicate lost frames.
 	 */
-	if (stream->last_fid != fid)
+	if (stream->last_fid != fid) {
 		stream->sequence++;
+		if (stream->sequence)
+			uvc_video_stats_update(stream);
+	}
 
 	/* Store the payload FID bit and return immediately when the buffer is
 	 * NULL.
@@ -860,6 +965,8 @@ static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
 	struct urb *urb;
 	unsigned int i;
 
+	uvc_video_stats_stop(stream);
+
 	for (i = 0; i < UVC_URBS; ++i) {
 		urb = stream->urb[i];
 		if (urb == NULL)
@@ -999,6 +1106,8 @@ static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 	stream->bulk.skip_payload = 0;
 	stream->bulk.payload_size = 0;
 
+	uvc_video_stats_start(stream);
+
 	if (intf->num_altsetting > 1) {
 		struct usb_host_endpoint *best_ep = NULL;
 		unsigned int best_psize = 3 * 1024;
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 2d45e58..e2da57b 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -356,6 +356,28 @@ struct uvc_video_chain {
 	struct mutex ctrl_mutex;		/* Protects ctrl.info */
 };
 
+struct uvc_stats_frame {
+	unsigned int size;		/* Number of bytes captured */
+	unsigned int first_data;	/* Index of the first non-empty packet */
+
+	unsigned int nb_packets;	/* Number of packets */
+	unsigned int nb_empty;		/* Number of empty packets */
+	unsigned int nb_invalid;	/* Number of packets with an invalid header */
+	unsigned int nb_errors;		/* Number of packets with the error bit set */
+};
+
+struct uvc_stats_stream {
+	struct timespec start_ts;	/* Stream start timestamp */
+	struct timespec stop_ts;	/* Stream stop timestamp */
+
+	unsigned int nb_frames;		/* Number of frames */
+
+	unsigned int nb_packets;	/* Number of packets */
+	unsigned int nb_empty;		/* Number of empty packets */
+	unsigned int nb_invalid;	/* Number of packets with an invalid header */
+	unsigned int nb_errors;		/* Number of packets with the error bit set */
+};
+
 struct uvc_streaming {
 	struct list_head list;
 	struct uvc_device *dev;
@@ -406,6 +428,10 @@ struct uvc_streaming {
 
 	/* debugfs */
 	struct dentry *debugfs_dir;
+	struct {
+		struct uvc_stats_frame frame;
+		struct uvc_stats_stream stream;
+	} stats;
 };
 
 enum uvc_device_state {
@@ -477,6 +503,7 @@ struct uvc_driver {
 #define UVC_TRACE_SUSPEND	(1 << 8)
 #define UVC_TRACE_STATUS	(1 << 9)
 #define UVC_TRACE_VIDEO		(1 << 10)
+#define UVC_TRACE_STATS		(1 << 11)
 
 #define UVC_WARN_MINMAX		0
 #define UVC_WARN_PROBE_DEF	1
@@ -608,10 +635,13 @@ extern struct usb_host_endpoint *uvc_find_endpoint(
 void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
 		struct uvc_buffer *buf);
 
-/* debugfs */
+/* debugfs and statistics */
 int uvc_debugfs_init(void);
 void uvc_debugfs_cleanup(void);
 int uvc_debugfs_init_stream(struct uvc_streaming *stream);
 void uvc_debugfs_cleanup_stream(struct uvc_streaming *stream);
 
+size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
+			    size_t size);
+
 #endif
-- 
1.7.3.4

