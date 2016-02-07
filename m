Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbcBGQWx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 11:22:53 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 44398C0C2346
	for <linux-media@vger.kernel.org>; Sun,  7 Feb 2016 16:22:53 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH xawtv3] v4l2: Add a workaround for bttv kernel driver planar fmt width bug
Date: Sun,  7 Feb 2016 17:22:48 +0100
Message-Id: <1454862168-12786-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bttv driver has a bug where it will return a width which is not
a multiple of 16 for planar formats, while it cannot handle this,
this commit adds a workaround for this.

A kernel fix has been send upstream for this for 4.5 / 4.6, so
eventually this workaround should be removed again.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 libng/plugins/drv0-v4l2.tmpl.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libng/plugins/drv0-v4l2.tmpl.c b/libng/plugins/drv0-v4l2.tmpl.c
index 2cbd34b..56fff9a 100644
--- a/libng/plugins/drv0-v4l2.tmpl.c
+++ b/libng/plugins/drv0-v4l2.tmpl.c
@@ -1122,6 +1122,22 @@ retry:
     }
     if (h->fmt_v4l2.fmt.pix.pixelformat != xawtv_pixelformat[fmt->fmtid])
 	return -1;
+
+    /*
+     * The bttv driver has a bug where it will return a width which is not
+     * a multiple of 16 for planar formats, while it cannot handle this,
+     * fix this up.
+     *
+     * A kernel fix has been send upstream for this for 4.5 / 4.6, so
+     * eventually this workaround should be removed.
+     */
+    if (0 && !strcmp(h->cap.driver, "bttv") &&
+            (fmt->fmtid == VIDEO_YUV422P || fmt->fmtid == VIDEO_YUV420P) &&
+            h->fmt_v4l2.fmt.pix.width % 16) {
+        fmt->width = h->fmt_v4l2.fmt.pix.width & ~15;
+        goto retry;
+    }
+
     fmt->width        = h->fmt_v4l2.fmt.pix.width;
     fmt->height       = h->fmt_v4l2.fmt.pix.height;
     fmt->bytesperline = h->fmt_v4l2.fmt.pix.bytesperline;
-- 
2.5.0

