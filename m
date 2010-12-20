Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51289 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab0LTLh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 06:37:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v5 02/13] v4l: Replace enums with fixed-sized fields in public structure
Date: Mon, 20 Dec 2010 12:37:14 +0100
Message-Id: <1292845045-7945-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1292845045-7945-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1292845045-7945-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The v4l2_mbus_framefmt structure will be part of the public userspace
API and used (albeit indirectly) as an ioctl argument. As such, its size
must be fixed across userspace ABIs.

Replace the v4l2_field and v4l2_colorspace enums by __u32 fields.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/v4l2-mediabus.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index a62cd64..a25e19f 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -63,16 +63,16 @@ enum v4l2_mbus_pixelcode {
  * struct v4l2_mbus_framefmt - frame format on the media bus
  * @width:	frame width
  * @height:	frame height
- * @code:	data format code
- * @field:	used interlacing type
- * @colorspace:	colorspace of the data
+ * @code:	data format code (from enum v4l2_mbus_pixelcode)
+ * @field:	used interlacing type (from enum v4l2_field)
+ * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
  */
 struct v4l2_mbus_framefmt {
-	__u32				width;
-	__u32				height;
-	__u32				code;
-	enum v4l2_field			field;
-	enum v4l2_colorspace		colorspace;
+	__u32			width;
+	__u32			height;
+	__u32			code;
+	__u32			field;
+	__u32			colorspace;
 };
 
 #endif
-- 
1.7.2.2

