Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16988 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3AUHe4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 02:34:56 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGY005EFT1VON80@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jan 2013 07:34:54 +0000 (GMT)
Received: from AMDC1061.digital.local ([106.116.147.88])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MGY002TYT201L00@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jan 2013 07:34:54 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC] V4L: Add underexposure metering flash controls
Date: Mon, 21 Jan 2013 08:34:35 +0100
Message-id: <1358753675-10784-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add flash controls for metering of the light conditions
regarding the necessity of the flash firing.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   25 +++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    4 ++++
 include/uapi/linux/v4l2-controls.h           |    3 +++
 3 files changed, 32 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 9d4af8a..7496dca 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4247,6 +4247,31 @@ interface and may change in the future.</para>
     	    after strobe during which another strobe will not be
     	    possible. This is a read-only control.</entry>
     	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_UNDEREXPOSURE_METERING</constant></entry>
+    	    <entry>boolean</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Enable or disable metering of the light
+    	    conditions regarding the necessity of the flash firing.</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_UNDEREXPOSURE_LEVEL</constant></entry>
+    	    <entry>integer</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">This is a read-only control that can be read
+    	    by the application and used as a hint to determine if the flash
+    	    should be used to obtain optimal exposure. Valid only if
+    	    <constant>V4L2_CID_FLASH_UNDEREXPOSURE_METERING</constant>
+    	    is enabled. Value 0 means the flash should not be used.
+    	    Otherwise the flash should be used and the value indicates the
+    	    optimal intensity of the flash. It should use the same units as
+    	    <constant>V4L2_CID_FLASH_INTENSITY</constant>. In case
+    	    <constant>V4L2_CID_FLASH_INTENSITY</constant> is not supported the
+    	    maximum value should be 1.
+    	    </entry>
+    	  </row>
     	  <row><entry></entry></row>
     	</tbody>
           </tgroup>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 9cdf4b8..8a7e4f7 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -779,6 +779,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_FAULT:		return "Faults";
 	case V4L2_CID_FLASH_CHARGE:		return "Charge";
 	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
+	case V4L2_CID_FLASH_UNDEREXPOSURE_METERING: return "Underexposure Metering";
+	case V4L2_CID_FLASH_UNDEREXPOSURE_LEVEL: return "Underexposure Level";
 
 	/* JPEG encoder controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -857,6 +859,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 	case V4L2_CID_IMAGE_STABILIZATION:
+	case V4L2_CID_FLASH_UNDEREXPOSURE_METERING:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -962,6 +965,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
 	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:
+	case V4L2_CID_FLASH_UNDEREXPOSURE_LEVEL:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 0eb1c1a..4cb493a 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -763,6 +763,9 @@ enum v4l2_flash_strobe_source {
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
 
+#define V4L2_CID_FLASH_UNDEREXPOSURE_METERING	(V4L2_CID_FLASH_CLASS_BASE + 13)
+#define V4L2_CID_FLASH_UNDEREXPOSURE_LEVEL	(V4L2_CID_FLASH_CLASS_BASE + 14)
+
 
 /* JPEG-class control IDs */
 
-- 
1.7.10.4

