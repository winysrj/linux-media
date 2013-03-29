Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2442 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3C2OOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 10:14:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-controls.h: update private control ranges to prevent  overlap.
Date: Fri, 29 Mar 2013 15:14:32 +0100
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303291514.32190.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These ranges shouldn't overlap.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/v4l2-controls.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 910d7cd..7da22ce 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -153,12 +153,12 @@ enum v4l2_colorfx {
 
 
 /* The base for the s2255 driver controls.
- * We reserve 8 controls for this driver. */
-#define V4L2_CID_USER_S2255_BASE		(V4L2_CID_USER_BASE + 0x1010)
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_S2255_BASE		(V4L2_CID_USER_BASE + 0x1030)
 
 /* The base for the si476x driver controls. See include/media/si476x.h for the list
- * of controls. Total of 16 controls is reserved for that driver */
-#define V4L2_CID_USER_SI476X_BASE		(V4L2_CID_USER_BASE + 0x1010)
+ * of controls. Total of 16 controls is reserved for this driver */
+#define V4L2_CID_USER_SI476X_BASE		(V4L2_CID_USER_BASE + 0x1040)
 
 /* MPEG-class control IDs */
 
-- 
1.7.10.4

