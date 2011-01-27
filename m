Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59831 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab1A0Ma6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 07:30:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 02/11] v4l: Replace enums with fixed-sized fields in public structure
Date: Thu, 27 Jan 2011 13:30:47 +0100
Message-Id: <1296131456-30000-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131456-30000-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1296131456-30000-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The v4l2_mbus_framefmt structure will be part of the public userspace
API and used (albeit indirectly) as an ioctl argument. As such, its size
must be fixed across userspace ABIs.

Replace the v4l2_field and v4l2_colorspace enums by __u32 fields and add
padding for future enhancements.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/v4l2-mediabus.h |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index a62cd64..feeb88c 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -63,16 +63,17 @@ enum v4l2_mbus_pixelcode {
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
+	__u32			reserved[7];
 };
 
 #endif
-- 
1.7.3.4

