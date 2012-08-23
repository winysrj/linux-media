Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:19526 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab2HWJwM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 05:52:12 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9700EG3CQH07Z0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 18:52:11 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M9700GHMCQHII60@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 18:52:11 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 1/4] V4L: Add V4L2_CID_FRAMESIZE image source class control
Date: Thu, 23 Aug 2012 11:51:26 +0200
Message-id: <1345715489-30158-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_FRAMESIZE control determines maximum number
of media bus samples transmitted within a single data frame.
It is useful for determining size of data buffer at the
receiver side.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 12 ++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
 include/linux/videodev2.h                    |  1 +
 3 files changed, 15 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 93b9c68..ad5d4e5 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4184,6 +4184,18 @@ interface and may change in the future.</para>
 	    conversion.
 	    </entry>
 	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FRAMESIZE</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Maximum size of a data frame in media bus
+	      sample units. This control determines maximum number of samples
+	      transmitted per single compressed data frame. For generic raw
+	      pixel formats the value of this control is undefined. This is
+	      a read-only control.
+	    </entry>
+	  </row>
 	  <row><entry></entry></row>
 	</tbody>
       </tgroup>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6a2ee7..0043fd2 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -727,6 +727,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_VBLANK:			return "Vertical Blanking";
 	case V4L2_CID_HBLANK:			return "Horizontal Blanking";
 	case V4L2_CID_ANALOGUE_GAIN:		return "Analogue Gain";
+	case V4L2_CID_FRAMESIZE:		return "Maximum Frame Size";
 
 	/* Image processing controls */
 	case V4L2_CID_IMAGE_PROC_CLASS:		return "Image Processing Controls";
@@ -933,6 +934,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FLASH_STROBE_STATUS:
 	case V4L2_CID_AUTO_FOCUS_STATUS:
 	case V4L2_CID_FLASH_READY:
+	case V4L2_CID_FRAMESIZE:
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
 	}
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 7a147c8..d3fd19f 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1985,6 +1985,7 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_VBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 1)
 #define V4L2_CID_HBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 2)
 #define V4L2_CID_ANALOGUE_GAIN			(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 3)
+#define V4L2_CID_FRAMESIZE			(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 4)
 
 /* Image processing controls */
 #define V4L2_CID_IMAGE_PROC_CLASS_BASE		(V4L2_CTRL_CLASS_IMAGE_PROC | 0x900)
-- 
1.7.11.3

