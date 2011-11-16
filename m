Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49196 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab1KPOKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 09:10:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	andriy.shevchenko@linux.intel.com
Subject: [PATCH v5 1/2] v4l: Add over-current and indicator flash fault bits
Date: Wed, 16 Nov 2011 15:10:56 +0100
Message-Id: <1321452657-24424-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1321452657-24424-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1321452657-24424-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Flash controllers can report over-current and indicator fault
conditions. Define flash fault control bits for them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   10 ++++++++++
 include/linux/videodev2.h                    |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 3bc5ee8..a978b88 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3329,6 +3329,16 @@ interface and may change in the future.</para>
 		  <entry>The short circuit protection of the flash
 		  controller has been triggered.</entry>
 		</row>
+		<row>
+		  <entry><constant>V4L2_FLASH_FAULT_OVER_CURRENT</constant></entry>
+		  <entry>Current in the LED power supply has exceeded the limit
+		  specific to the flash controller.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FLASH_FAULT_INDICATOR</constant></entry>
+		  <entry>The flash controller has detected a short or open
+		  circuit condition on the indicator LED.</entry>
+		</row>
 	      </tbody>
 	    </entrytbl>
 	  </row>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..3d62631 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1682,6 +1682,8 @@ enum v4l2_flash_strobe_source {
 #define V4L2_FLASH_FAULT_TIMEOUT		(1 << 1)
 #define V4L2_FLASH_FAULT_OVER_TEMPERATURE	(1 << 2)
 #define V4L2_FLASH_FAULT_SHORT_CIRCUIT		(1 << 3)
+#define V4L2_FLASH_FAULT_OVER_CURRENT		(1 << 4)
+#define V4L2_FLASH_FAULT_INDICATOR		(1 << 5)
 
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
-- 
1.7.3.4

