Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964801AbdKBUWh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 16:22:37 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] libv4lconvert: We support more then 32 bit src fmts now, so use 64 bit bitmasks
Date: Thu,  2 Nov 2017 21:22:34 +0100
Message-Id: <20171102202234.9140-1-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We support more then 32 bit src fmts now, so we can no longer re-use
struct v4l2_frmsizeenum.pixel_format to store a bitmask of all the
supported src-formats for a given frame-size.

This fixes a subtile bug where we would try to use SE401 as src fmt
instead of YUYV under certain circumstances.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1508706
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/libv4lconvert/libv4lconvert-priv.h | 2 ++
 lib/libv4lconvert/libv4lconvert.c      | 9 ++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
index e2389347..9a467e10 100644
--- a/lib/libv4lconvert/libv4lconvert-priv.h
+++ b/lib/libv4lconvert/libv4lconvert-priv.h
@@ -66,6 +66,8 @@ struct v4lconvert_data {
 	int cinfo_initialized;
 #endif // HAVE_JPEG
 	struct v4l2_frmsizeenum framesizes[V4LCONVERT_MAX_FRAMESIZES];
+	/* Bitmask of all supported src_formats which can do for a size */
+	int64_t framesize_supported_src_formats[V4LCONVERT_MAX_FRAMESIZES];
 	unsigned int no_framesizes;
 	int bandwidth;
 	int fps;
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index 1a5ccec2..d666bd97 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -434,7 +434,8 @@ static int v4lconvert_do_try_format_uvc(struct v4lconvert_data *data,
 
 	for (i = 0; i < ARRAY_SIZE(supported_src_pixfmts); i++) {
 		/* is this format supported? */
-		if (!(data->framesizes[best_framesize].pixel_format & (1 << i)))
+		if (!(data->framesize_supported_src_formats[best_framesize] &
+		      (1ULL << i)))
 			continue;
 
 		/* Note the hardcoded use of discrete is based on this function
@@ -1647,9 +1648,7 @@ static void v4lconvert_get_framesizes(struct v4lconvert_data *data,
 				return;
 			}
 			data->framesizes[data->no_framesizes].type = frmsize.type;
-			/* We use the pixel_format member to store a bitmask of all
-			   supported src_formats which can do this size */
-			data->framesizes[data->no_framesizes].pixel_format = 1 << index;
+			data->framesize_supported_src_formats[data->no_framesizes] = 1ULL << index;
 
 			switch (frmsize.type) {
 			case V4L2_FRMSIZE_TYPE_DISCRETE:
@@ -1662,7 +1661,7 @@ static void v4lconvert_get_framesizes(struct v4lconvert_data *data,
 			}
 			data->no_framesizes++;
 		} else {
-			data->framesizes[j].pixel_format |= 1 << index;
+			data->framesize_supported_src_formats[j] |= 1ULL << index;
 		}
 	}
 }
-- 
2.14.3
