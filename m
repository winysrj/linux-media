Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaI3OFS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 10:05:18 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/3] libv4l2: Move alignment of dest_fmt resolution to v4l2_set_src_and_dest_format
Date: Tue, 30 Sep 2014 16:05:01 +0200
Message-Id: <1412085901-18528-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1412085901-18528-1-git-send-email-hdegoede@redhat.com>
References: <1412085901-18528-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So that we always do the alignment, this is necessary because there are
several code paths where dest_fmt gets set to a fmt which has not been
passed through libv4lconvert_try_fmt, and thus is not aligned.

Also call v4lconvert_fixup_fmt when aligment has changed the height / width,
so that bytesperline and sizeimage get set correctly.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/include/libv4lconvert.h |  3 +++
 lib/libv4l2/libv4l2.c       | 25 ++++++++++++++-----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/lib/include/libv4lconvert.h b/lib/include/libv4lconvert.h
index e94d3bd..d425c51 100644
--- a/lib/include/libv4lconvert.h
+++ b/lib/include/libv4lconvert.h
@@ -147,6 +147,9 @@ LIBV4L_PUBLIC int v4lconvert_supported_dst_format(unsigned int pixelformat);
 LIBV4L_PUBLIC int v4lconvert_get_fps(struct v4lconvert_data *data);
 LIBV4L_PUBLIC void v4lconvert_set_fps(struct v4lconvert_data *data, int fps);
 
+/* Fixup bytesperline and sizeimage for supported destination formats */
+LIBV4L_PUBLIC void v4lconvert_fixup_fmt(struct v4l2_format *fmt);
+
 #ifdef __cplusplus
 }
 #endif /* __cplusplus */
diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index bdfb2fe..966a000 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -765,16 +765,6 @@ no_capture:
 	v4l2_set_src_and_dest_format(index, &devices[index].src_fmt,
 				     &devices[index].dest_fmt);
 
-	/* When a user does a try_fmt with the current dest_fmt and the dest_fmt
-	   is a supported one we will align the resolution (see try_fmt for why).
-	   Do the same here now, so that a try_fmt on the result of a get_fmt done
-	   immediately after open leaves the fmt unchanged. */
-	if (v4lconvert_supported_dst_format(
-				devices[index].dest_fmt.fmt.pix.pixelformat)) {
-		devices[index].dest_fmt.fmt.pix.width &= ~7;
-		devices[index].dest_fmt.fmt.pix.height &= ~1;
-	}
-
 	pthread_mutex_init(&devices[index].stream_lock, NULL);
 
 	devices[index].no_frames = 0;
@@ -948,6 +938,18 @@ static int v4l2_pix_fmt_identical(struct v4l2_format *a, struct v4l2_format *b)
 static void v4l2_set_src_and_dest_format(int index,
 		struct v4l2_format *src_fmt, struct v4l2_format *dest_fmt)
 {
+	/*
+	 * When a user does a try_fmt with the current dest_fmt and the
+	 * dest_fmt is a supported one we will align the resolution (see
+	 * libv4lconvert_try_fmt). We do this here too, in case dest_fmt gets
+	 * set without having gone through libv4lconvert_try_fmt, so that a
+	 * try_fmt on the result of a get_fmt always returns the same result.
+	 */
+	if (v4lconvert_supported_dst_format(dest_fmt->fmt.pix.pixelformat)) {
+		dest_fmt->fmt.pix.width &= ~7;
+		dest_fmt->fmt.pix.height &= ~1;
+	}
+
 	/* Sigh some drivers (pwc) do not properly reflect what one really gets
 	   after a s_fmt in their try_fmt answer. So update dest format (which we
 	   report as result from s_fmt / g_fmt to the app) with all info from the src
@@ -958,7 +960,8 @@ static void v4l2_set_src_and_dest_format(int index,
 	if (v4l2_pix_fmt_compat(src_fmt, dest_fmt)) {
 		dest_fmt->fmt.pix.bytesperline = src_fmt->fmt.pix.bytesperline;
 		dest_fmt->fmt.pix.sizeimage = src_fmt->fmt.pix.sizeimage;
-	}
+	} else
+		v4lconvert_fixup_fmt(dest_fmt);
 
 	devices[index].src_fmt = *src_fmt;
 	devices[index].dest_fmt = *dest_fmt;
-- 
2.1.0

