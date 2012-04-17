Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59161 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab2DQKKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:10:05 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2M00C0TC6Q7O@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:08:51 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2M0047EC8QI3@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:10:02 +0100 (BST)
Date: Tue, 17 Apr 2012 12:09:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 07/15] V4L: Add camera ISO sensitivity controls
In-reply-to: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1334657396-5737-8-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ISO sensitivity and ISO auto/manual controls. The sensitivity
values are related to level of amplification of the analog signal
between image sensor and ADC. These controls allow to support sensors
exposing an interface to accept the ISO values directly.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/biblio.xml   |   11 +++++++++++
 Documentation/DocBook/media/v4l/controls.xml |   24 ++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    5 ++++-
 include/linux/videodev2.h                    |    3 +++
 4 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index 7dc65c5..66a0ef2 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -197,4 +197,15 @@ in the frequency range from 87,5 to 108,0 MHz</title>
       <title>NTSC-4: United States RBDS Standard</title>
     </biblioentry>
 
+    <biblioentry id="iso12232">
+      <abbrev>ISO&nbsp;12232:2006</abbrev>
+      <authorgroup>
+	<corpauthor>International Organization for Standardization
+(<ulink url="http://www.iso.org">http://www.iso.org</ulink>)</corpauthor>
+      </authorgroup>
+      <title>Photography &mdash; Digital still cameras &mdash; Determination
+      of exposure index, ISO speed ratings, standard output sensitivity, and
+      recommended exposure index</title>
+    </biblioentry>
+
   </bibliography>
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 010edc4..c50941e 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3105,6 +3105,30 @@ feature.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_ISO_SENSITIVITY</constant>&nbsp;</entry>
+	    <entry>integer menu</entry>
+	  </row><row><entry spanname="descr">Determines ISO equivalent of an
+image sensor indicating the sensor's sensitivity to light. The numbers are
+expressed in arithmetic scale, as per <xref linkend="iso12232" /> standard,
+where doubling the sensor sensitivity is represented by doubling the numerical
+ISO value. Applications should interpret the values as standard ISO values
+multiplied by 1000, e.g. control value 800 stands for ISO 0.8. Drivers will
+usually support only a subset of standard ISO values.
+</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_ISO_SENSITIVITY_AUTO</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row><row><entry spanname="descr">Enables automatic ISO sensitivity
+adjustments. The effect of setting <constant>V4L2_CID_ISO_SENSITIVITY</constant>
+while automatic ISO control is enabled is undefined, drivers should ignore such
+requests.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index a0d1b4a..aa3d111 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -617,10 +617,11 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
 	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
-
 	case V4L2_CID_WHITE_BALANCE_PRESET:	return "White Balance, Preset";
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:	return "Wide Dynamic Range";
 	case V4L2_CID_IMAGE_STABILIZATION:	return "Image Stabilization";
+	case V4L2_CID_ISO_SENSITIVITY:		return "ISO Sensitivity";
+	case V4L2_CID_ISO_SENSITIVITY_AUTO:	return "ISO Sensitivity, Auto";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -714,6 +715,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 	case V4L2_CID_IMAGE_STABILIZATION:
+	case V4L2_CID_ISO_SENSITIVITY_AUTO:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -766,6 +768,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_RADIO_TEXT:
 		*type = V4L2_CTRL_TYPE_STRING;
 		break;
+	case V4L2_CID_ISO_SENSITIVITY:
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:
 		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 897bf7b..1c6d342 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1744,6 +1744,9 @@ enum v4l2_white_balance_preset {
 #define V4L2_CID_WIDE_DYNAMIC_RANGE		(V4L2_CID_CAMERA_CLASS_BASE+21)
 #define V4L2_CID_IMAGE_STABILIZATION		(V4L2_CID_CAMERA_CLASS_BASE+22)
 
+#define V4L2_CID_ISO_SENSITIVITY		(V4L2_CID_CAMERA_CLASS_BASE+23)
+#define V4L2_CID_ISO_SENSITIVITY_AUTO		(V4L2_CID_CAMERA_CLASS_BASE+24)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.10

