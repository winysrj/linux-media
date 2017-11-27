Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:55950 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752083AbdK0NUh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 08:20:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] [media] uvc_video: use ktime_t for stats
Date: Mon, 27 Nov 2017 14:19:53 +0100
Message-Id: <20171127132027.1734806-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'struct timespec' works fine here, but we try to migrate
away from it in favor of ktime_t or timespec64. In this
case, using ktime_t produces the simplest code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/uvc/uvc_video.c | 11 ++++-------
 drivers/media/usb/uvc/uvcvideo.h  |  4 ++--
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index fb86d6af398d..d6bee37cd1b8 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -725,7 +725,7 @@ static void uvc_video_stats_decode(struct uvc_streaming *stream,
 
 	if (stream->stats.stream.nb_frames == 0 &&
 	    stream->stats.frame.nb_packets == 0)
-		ktime_get_ts(&stream->stats.stream.start_ts);
+		stream->stats.stream.start_ts = ktime_get();
 
 	switch (data[1] & (UVC_STREAM_PTS | UVC_STREAM_SCR)) {
 	case UVC_STREAM_PTS | UVC_STREAM_SCR:
@@ -865,16 +865,13 @@ size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
 {
 	unsigned int scr_sof_freq;
 	unsigned int duration;
-	struct timespec ts;
 	size_t count = 0;
 
-	ts = timespec_sub(stream->stats.stream.stop_ts,
-			  stream->stats.stream.start_ts);
-
 	/* Compute the SCR.SOF frequency estimate. At the nominal 1kHz SOF
 	 * frequency this will not overflow before more than 1h.
 	 */
-	duration = ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
+	duration = ktime_ms_delta(stream->stats.stream.stop_ts,
+				  stream->stats.stream.start_ts);
 	if (duration != 0)
 		scr_sof_freq = stream->stats.stream.scr_sof_count * 1000
 			     / duration;
@@ -915,7 +912,7 @@ static void uvc_video_stats_start(struct uvc_streaming *stream)
 
 static void uvc_video_stats_stop(struct uvc_streaming *stream)
 {
-	ktime_get_ts(&stream->stats.stream.stop_ts);
+	stream->stats.stream.stop_ts = ktime_get();
 }
 
 /* ------------------------------------------------------------------------
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 05398784d1c8..a2c190937067 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -452,8 +452,8 @@ struct uvc_stats_frame {
 };
 
 struct uvc_stats_stream {
-	struct timespec start_ts;	/* Stream start timestamp */
-	struct timespec stop_ts;	/* Stream stop timestamp */
+	ktime_t start_ts;		/* Stream start timestamp */
+	ktime_t stop_ts;		/* Stream stop timestamp */
 
 	unsigned int nb_frames;		/* Number of frames */
 
-- 
2.9.0
