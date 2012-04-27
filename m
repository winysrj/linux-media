Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63374 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2D0OXh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:23:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3500AQJ6NK4Q30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M350025Y6N855@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:32 +0100 (BST)
Date: Fri, 27 Apr 2012 16:23:23 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v3 06/14] V4L: Add camera ISO sensitivity controls
In-reply-to: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335536611-4298-7-git-send-email-s.nawrocki@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ISO sensitivity and ISO auto/manual controls. The sensitivity
values are related to level of amplification of the analog signal
between image sensor and ADC. These controls allow to support sensors
exposing an interface to accept the ISO values directly.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/biblio.xml   |   11 ++++++++
 Documentation/DocBook/media/v4l/controls.xml |   38 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |   10 +++++++
 include/linux/videodev2.h                    |    7 +++++
 4 files changed, 66 insertions(+)

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
index ac27444..557daae 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3069,6 +3069,44 @@ times.</entry>
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
+usually support only a subset of standard ISO values. The effect of setting
+this control while the <constant>V4L2_CID_ISO_SENSITIVITY_AUTO</constant>
+control is set to a value other than <constant>V4L2_CID_ISO_SENSITIVITY_MANUAL
+</constant> is undefined, drivers should ignore such requests.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row id="v4l2-iso-sensitivity-auto-type">
+	    <entry spanname="id"><constant>V4L2_CID_ISO_SENSITIVITY_AUTO</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_iso_sensitivity_type</entry>
+	  </row><row><entry spanname="descr">Enables or disables automatic ISO
+sensitivity adjustments.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_CID_ISO_SENSITIVITY_MANUAL</constant>&nbsp;</entry>
+		  <entry>Manual ISO sensitivity.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_CID_ISO_SENSITIVITY_AUTO</constant>&nbsp;</entry>
+		  <entry>Automatic ISO sensititivity adjustments.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 305a203..3d8af91 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -264,6 +264,10 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	static const char * const camera_image_stabilization[] = {
 		"Disabled",
 		"Enabled",
+	};
+	static const char * const camera_iso_sensitivity_auto[] = {
+		"Manual",
+		"Auto",
 		NULL
 	};
 	static const char * const tune_preemphasis[] = {
@@ -441,6 +445,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return camera_wide_dynamic_range;
 	case V4L2_CID_IMAGE_STABILIZATION:
 		return camera_image_stabilization;
+	case V4L2_CID_ISO_SENSITIVITY_AUTO:
+		return camera_iso_sensitivity_auto;
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		return tune_preemphasis;
 	case V4L2_CID_FLASH_LED_MODE:
@@ -630,6 +636,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE: return "White Balance, Auto & Preset";
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:	return "Wide Dynamic Range";
 	case V4L2_CID_IMAGE_STABILIZATION:	return "Image Stabilization";
+	case V4L2_CID_ISO_SENSITIVITY:		return "ISO Sensitivity";
+	case V4L2_CID_ISO_SENSITIVITY_AUTO:	return "ISO Sensitivity, Auto";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -769,12 +777,14 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 	case V4L2_CID_IMAGE_STABILIZATION:
+	case V4L2_CID_ISO_SENSITIVITY_AUTO:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
 	case V4L2_CID_RDS_TX_RADIO_TEXT:
 		*type = V4L2_CTRL_TYPE_STRING;
 		break;
+	case V4L2_CID_ISO_SENSITIVITY:
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:
 		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 62d1d66..12cc16d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1720,6 +1720,13 @@ enum v4l2_image_stabilization_type {
 	V4L2_IMAGE_STABILIZATION_ENABLED	= 1,
 };
 
+#define V4L2_CID_ISO_SENSITIVITY		(V4L2_CID_CAMERA_CLASS_BASE+23)
+#define V4L2_CID_ISO_SENSITIVITY_AUTO		(V4L2_CID_CAMERA_CLASS_BASE+24)
+enum v4l2_iso_sensitivity_auto_type {
+	V4L2_ISO_SENSITIVITY_MANUAL		= 0,
+	V4L2_ISO_SENSITIVITY_AUTO		= 1,
+};
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.10

