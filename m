Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:25531 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaHTNnZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 09:43:25 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v5 1/3] v4l2-ctrls: add control for flash strobe signal
 providers
Date: Wed, 20 Aug 2014 15:43:09 +0200
Message-id: <1408542191-335-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1408542191-335-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542191-335-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_CID_STROBE_PROVIDER of type menu, which allows
for enumerating of available external flash strobe signal
providers and setting the active one.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   11 +++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    2 ++
 include/uapi/linux/v4l2-controls.h           |    2 ++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 9f5ffd8..bb18b13 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4413,6 +4413,17 @@ interface and may change in the future.</para>
     	    is strobing at the moment or not. This is a read-only
     	    control.</entry>
     	  </row>
+          <row>
+            <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_PROVIDER</constant></entry>
+            <entry>menu</entry>
+          </row>
+          <row>
+            <entry spanname="descr">Provider of the external strobe signal. If a flash
+            device declares more than one available external strobe signal provider then
+            this control allows to select the active one. &VIDIOC-QUERYCTRL; has to be
+            used to get the list of available strobe providers.
+            </entry>
+          </row>
     	  <row>
     	    <entry spanname="id"><constant>V4L2_CID_FLASH_TIMEOUT</constant></entry>
     	    <entry>integer</entry>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index f030d6a..30b6f45 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -844,6 +844,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_FAULT:		return "Faults";
 	case V4L2_CID_FLASH_CHARGE:		return "Charge";
 	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
+	case V4L2_CID_FLASH_STROBE_PROVIDER:	return "Strobe Provider";
 
 	/* JPEG encoder controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -1035,6 +1036,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
 	case V4L2_CID_DETECT_MD_MODE:
+	case V4L2_CID_FLASH_STROBE_PROVIDER:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index e946e43..b79c4aa 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -832,6 +832,8 @@ enum v4l2_flash_strobe_source {
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
 
+#define V4L2_CID_FLASH_STROBE_PROVIDER		(V4L2_CID_FLASH_CLASS_BASE + 13)
+
 
 /* JPEG-class control IDs */
 
-- 
1.7.9.5

