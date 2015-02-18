Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:24272 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbbBRQZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 11:25:56 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v11 15/20] v4l2-ctrls: Add V4L2_CID_FLASH_SYNC_STROBE
 control
Date: Wed, 18 Feb 2015 17:20:36 +0100
Message-id: <1424276441-3969-16-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_CID_FLASH_SYNC_STROBE control for determining
whether a flash device strobe has to be synchronized
with other flash leds controller by the same device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/controls.xml |    9 +++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    2 ++
 include/uapi/linux/v4l2-controls.h           |    1 +
 3 files changed, 12 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 4e9462f..434d020 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4562,6 +4562,15 @@ interface and may change in the future.</para>
     	    after strobe during which another strobe will not be
     	    possible. This is a read-only control.</entry>
     	  </row>
+    	  <row>
+            <entry spanname="id"><constant>V4L2_CID_FLASH_SYNC_STROBE</constant></entry>
+            <entry>menu</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Synchronized strobe: whether the flash
+	    should be strobed synchronously with the other one controlled
+	    by the same device.</entry>
+    	  </row>
     	  <row><entry></entry></row>
     	</tbody>
           </tgroup>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 45c5b47..4bc7e00 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -846,6 +846,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_FAULT:		return "Faults";
 	case V4L2_CID_FLASH_CHARGE:		return "Charge";
 	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
+	case V4L2_CID_FLASH_SYNC_STROBE:	return "Synchronize Strobe";
 
 	/* JPEG encoder controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
@@ -1041,6 +1042,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TUNE_DEEMPHASIS:
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
 	case V4L2_CID_DETECT_MD_MODE:
+	case V4L2_CID_FLASH_SYNC_STROBE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 9f6e108..7084696 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -837,6 +837,7 @@ enum v4l2_flash_strobe_source {
 
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
+#define V4L2_CID_FLASH_SYNC_STROBE		(V4L2_CID_FLASH_CLASS_BASE + 13)
 
 
 /* JPEG-class control IDs */
-- 
1.7.9.5

