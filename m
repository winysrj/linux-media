Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:47674 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbeBDWd0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 17:33:26 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@s-opensource.com, jasmin@anw.at
Subject: [PATCH] build: Added temporarily v4.9_uvcvideo_ktime_conversion.patch
Date: Sun,  4 Feb 2018 23:33:15 +0100
Message-Id: <1517783595-5858-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Due the delay with merging patches to media_tree, add the mentioned
patch temporarily to backports. Once this patch is merged to media_tree,
revert this patch.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/backports.txt                        |  1 +
 backports/v4.9_uvcvideo_ktime_conversion.patch | 42 ++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)
 create mode 100644 backports/v4.9_uvcvideo_ktime_conversion.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index c30ccf0..c148a75 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -43,6 +43,7 @@ add v4.10_refcount.patch
 add v4.9_mm_address.patch
 add v4.9_dvb_net_max_mtu.patch
 add v4.9_ktime_cleanups.patch
+add v4.9_uvcvideo_ktime_conversion.patch
 
 [4.8.255]
 add v4.8_user_pages_flag.patch
diff --git a/backports/v4.9_uvcvideo_ktime_conversion.patch b/backports/v4.9_uvcvideo_ktime_conversion.patch
new file mode 100644
index 0000000..2f56541
--- /dev/null
+++ b/backports/v4.9_uvcvideo_ktime_conversion.patch
@@ -0,0 +1,42 @@
+From fb650b38998f5f84d6f35e52aefd1baec2f54b39 Mon Sep 17 00:00:00 2001
+From: Jasmin Jessich <jasmin@anw.at>
+Date: Sun, 14 Jan 2018 10:11:08 +0000
+Subject: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
+
+Commit 828ee8c71950 ("media: uvcvideo: Use ktime_t for timestamps")
+changed to use ktime_t for timestamps. Older Kernels use a struct for
+ktime_t, which requires the conversion function ktime_to_ns to be used on
+some places. With this patch it will compile now also for older Kernel
+versions.
+
+Signed-off-by: Jasmin Jessich <jasmin@anw.at>
+---
+ drivers/media/usb/uvc/uvc_video.c | 5 +++--
+ 1 file changed, 3 insertions(+), 2 deletions(-)
+
+diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
+index 5441553..1670aeb 100644
+--- a/drivers/media/usb/uvc/uvc_video.c
++++ b/drivers/media/usb/uvc/uvc_video.c
+@@ -1009,7 +1009,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
+ 
+ 		buf->buf.field = V4L2_FIELD_NONE;
+ 		buf->buf.sequence = stream->sequence;
+-		buf->buf.vb2_buf.timestamp = uvc_video_get_time();
++		buf->buf.vb2_buf.timestamp = ktime_to_ns(uvc_video_get_time());
+ 
+ 		/* TODO: Handle PTS and SCR. */
+ 		buf->state = UVC_BUF_STATE_ACTIVE;
+@@ -1191,7 +1191,8 @@ static void uvc_video_decode_meta(struct uvc_streaming *stream,
+ 
+ 	uvc_trace(UVC_TRACE_FRAME,
+ 		  "%s(): t-sys %lluns, SOF %u, len %u, flags 0x%x, PTS %u, STC %u frame SOF %u\n",
+-		  __func__, time, meta->sof, meta->length, meta->flags,
++		  __func__, ktime_to_ns(time), meta->sof, meta->length,
++		  meta->flags,
+ 		  has_pts ? *(u32 *)meta->buf : 0,
+ 		  has_scr ? *(u32 *)scr : 0,
+ 		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
+-- 
+2.7.4
+
-- 
2.7.4
