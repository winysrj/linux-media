Return-path: <linux-media-owner@vger.kernel.org>
Received: from alt-proxy69.mail.unifiedlayer.com ([67.20.124.9]:54978 "HELO
	alt-proxy69.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751077AbaC1FuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 01:50:06 -0400
From: Olivier Langlois <olivier@trillion01.com>
To: laurent.pinchart@ideasonboard.com, m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Olivier Langlois <olivier@trillion01.com>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH] [media] uvcvideo: Fix clock param realtime setting
Date: Fri, 28 Mar 2014 01:42:38 -0400
Message-Id: <1395985358-17047-1-git-send-email-olivier@trillion01.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

timestamps in v4l2 buffers returned to userspace are updated in
uvc_video_clock_update() which uses timestamps fetched from
uvc_video_clock_decode() by calling unconditionally ktime_get_ts().

Hence setting the module clock param to realtime have no effect
before this patch.

This has been tested with ffmpeg:

ffmpeg -y -f v4l2 -input_format yuyv422 -video_size 640x480 -framerate 30 -i /dev/video0 \
 -f alsa -acodec pcm_s16le -ar 16000 -ac 1 -i default \
 -c:v libx264 -preset ultrafast \
 -c:a libfdk_aac \
 out.mkv

and inspecting the v4l2 input starting timestamp.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 898c208..c79db33 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -361,6 +361,14 @@ static int uvc_commit_video(struct uvc_streaming *stream,
  * Clocks and timestamps
  */
 
+static inline void uvc_video_get_ts(struct timespec *ts)
+{
+	if (uvc_clock_param == CLOCK_MONOTONIC)
+		ktime_get_ts(ts);
+	else
+		ktime_get_real_ts(ts);
+}
+
 static void
 uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 		       const __u8 *data, int len)
@@ -420,7 +428,7 @@ uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 	stream->clock.last_sof = dev_sof;
 
 	host_sof = usb_get_current_frame_number(stream->dev->udev);
-	ktime_get_ts(&ts);
+	uvc_video_get_ts(&ts);
 
 	/* The UVC specification allows device implementations that can't obtain
 	 * the USB frame number to keep their own frame counters as long as they
@@ -1011,10 +1019,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 			return -ENODATA;
 		}
 
-		if (uvc_clock_param == CLOCK_MONOTONIC)
-			ktime_get_ts(&ts);
-		else
-			ktime_get_real_ts(&ts);
+		uvc_video_get_ts(&ts);
 
 		buf->buf.v4l2_buf.sequence = stream->sequence;
 		buf->buf.v4l2_buf.timestamp.tv_sec = ts.tv_sec;
-- 
1.9.1

