Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54464 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZBPTBu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 14:01:50 -0500
Date: Mon, 16 Feb 2009 16:01:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Schimek <mschimek@gmx.at>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fw: [PATCH v2] V4L2: Add COLORFX user control
Message-ID: <20090216160122.7a165792@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael/Hans,

As nobody complained, and this seems to be required by some webcams, I'm
committing this changeset. Please update V4L2 API to reflect this change.

Cheers,
Mauro.

Forwarded message:

Date: Tue, 20 Jan 2009 16:29:26 -0600
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>, "Nagalla, Hari" <hnagalla@ti.com>, Sakari Ailus <sakari.ailus@nokia.com>, "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "mikko.hurskainen@nokia.com" <mikko.hurskainen@nokia.com>, "Curran, Dominic" <dcurran@ti.com>
Subject: [PATCH v2] V4L2: Add COLORFX user control


>From 07396d67b39bf7bcc81440d3e72d253ad6c54f11 Mon Sep 17 00:00:00 2001
From: Sergio Aguirre <saaguirre@ti.com>
Date: Tue, 20 Jan 2009 15:34:43 -0600
Subject: [PATCH v2] V4L2: Add COLORFX user control

This is a common feature on many cameras. the options are:
Default colors,
B & W,
Sepia

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 include/linux/videodev2.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4669d7e..89ed395 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -876,8 +876,15 @@ enum v4l2_power_line_frequency {
 #define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28)
 #define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
 #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
+#define V4L2_CID_COLORFX			(V4L2_CID_BASE+31)
+enum v4l2_colorfx {
+	V4L2_COLORFX_NONE	= 0,
+	V4L2_COLORFX_BW		= 1,
+	V4L2_COLORFX_SEPIA	= 2,
+};
+
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+31)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+32)
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
-- 
1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
