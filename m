Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41719 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759327Ab2EDScY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 14:32:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3I00AN9GU72KA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:32:31 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3I00E8XGTWIH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:32:21 +0100 (BST)
Date: Fri, 04 May 2012 20:32:10 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v4 06/12] V4L: Add camera ISO sensitivity controls
In-reply-to: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336156337-10935-7-git-send-email-s.nawrocki@samsung.com>
References: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
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
 drivers/media/video/v4l2-ctrls.c             |   11 ++++++++
 include/linux/videodev2.h                    |    7 +++++
 4 files changed, 67 insertions(+)

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
index 7468267..1300901 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3043,6 +3043,44 @@ control in future, if more options are required.</para></footnote></entry>
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
+		  <entry>Automatic ISO sensitivity adjustments.</entry>
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
index 406916a..b70226e 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -256,6 +256,11 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Shade",
 		NULL,
 	};
+	static const char * const camera_iso_sensitivity_auto[] = {
+		"Manual",
+		"Auto",
+		NULL
+	};
 	static const char * const tune_preemphasis[] = {
 		"No Preemphasis",
 		"50 Microseconds",
@@ -427,6 +432,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return colorfx;
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
 		return auto_n_preset_white_balance;
+	case V4L2_CID_ISO_SENSITIVITY_AUTO:
+		return camera_iso_sensitivity_auto;
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		return tune_preemphasis;
 	case V4L2_CID_FLASH_LED_MODE:
@@ -616,6 +623,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE: return "White Balance, Auto & Preset";
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:	return "Wide Dynamic Range";
 	case V4L2_CID_IMAGE_STABILIZATION:	return "Image Stabilization";
+	case V4L2_CID_ISO_SENSITIVITY:		return "ISO Sensitivity";
+	case V4L2_CID_ISO_SENSITIVITY_AUTO:	return "ISO Sensitivity, Auto";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -755,12 +764,14 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
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
index 9b5fe8a..993af23 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1712,6 +1712,13 @@ enum v4l2_auto_n_preset_white_balance {
 #define V4L2_CID_WIDE_DYNAMIC_RANGE		(V4L2_CID_CAMERA_CLASS_BASE+21)
 #define V4L2_CID_IMAGE_STABILIZATION		(V4L2_CID_CAMERA_CLASS_BASE+22)
 
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

