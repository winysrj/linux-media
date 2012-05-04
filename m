Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58214 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2EDScX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 14:32:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3I00AUCGSVRTA0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:31:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3I00HWOGTTGD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:32:18 +0100 (BST)
Date: Fri, 04 May 2012 20:32:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v4 02/12] V4L: Add camera exposure bias control
In-reply-to: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336156337-10935-3-git-send-email-s.nawrocki@samsung.com>
References: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The camera may in some conditions incorrectly determine the exposure,
and a manual automatic exposure correction may be needed. This patch
adds V4L2_CID_AUTO_EXPOSURE_BIAS control which allows to add some
offset in the automatic exposure control loop, to compensate for
frame under- or over-exposure.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   16 ++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    4 ++++
 include/linux/videodev2.h                    |    2 ++
 3 files changed, 22 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 5e12257..612009f 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2775,6 +2775,22 @@ remain constant.</entry>
 	  <row><entry></entry></row>
 
 	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_EXPOSURE_BIAS</constant>&nbsp;</entry>
+	    <entry>integer menu</entry>
+	  </row><row><entry spanname="descr"> Determines the automatic
+exposure compensation, it is effective only when <constant>V4L2_CID_EXPOSURE_AUTO</constant>
+control is set to <constant>AUTO</constant>, <constant>SHUTTER_PRIORITY </constant>
+or <constant>APERTURE_PRIORITY</constant>.
+It is expressed in terms of EV, drivers should interpret the values as 0.001 EV
+units, where the value 1000 stands for +1 EV.
+<para>Increasing the exposure compensation value is equivalent to decreasing
+the exposure value (EV) and will increase the amount of light at the image
+sensor. The camera performs the exposure compensation by adjusting absolute
+exposure time and/or aperture.</para></entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_PAN_RELATIVE</constant>&nbsp;</entry>
 	    <entry>integer</entry>
 	  </row><row><entry spanname="descr">This control turns the
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index e0725b5..1d7091f 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -597,6 +597,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_PRIVACY:			return "Privacy";
 	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
 	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
+	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -739,6 +740,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_RADIO_TEXT:
 		*type = V4L2_CTRL_TYPE_STRING;
 		break;
+	case V4L2_CID_AUTO_EXPOSURE_BIAS:
+		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
+		break;
 	case V4L2_CID_USER_CLASS:
 	case V4L2_CID_CAMERA_CLASS:
 	case V4L2_CID_MPEG_CLASS:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5a09ac3..da60cbb 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1693,6 +1693,8 @@ enum  v4l2_exposure_auto_type {
 #define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
 #define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)
 
+#define V4L2_CID_AUTO_EXPOSURE_BIAS		(V4L2_CID_CAMERA_CLASS_BASE+19)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.10

