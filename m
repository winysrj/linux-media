Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35399 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1LDPQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Dec 2011 10:16:49 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so5379144wgb.1
        for <linux-media@vger.kernel.org>; Sun, 04 Dec 2011 07:16:48 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com, Sylwester Nawrocki <snjw23@gmail.com>
Subject: [RFC/PATCH 5/5] v4l: Add V4L2_CID_ISO and V4L2_CID_ISO_AUTO controls
Date: Sun,  4 Dec 2011 16:16:16 +0100
Message-Id: <1323011776-15967-6-git-send-email-snjw23@gmail.com>
In-Reply-To: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add manual and automatic ISO controls. The ISO values are related to
the level of amplification of the analog signal between image sensor
and ADC, but some sensors with an integrated SoC ISP expose
an interface to accept the ISO values directly.

Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---

These controls depend on the integer menu control support.
Corresponding patches from Sakari can be found here:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg39733.html
---
 Documentation/DocBook/media/v4l/biblio.xml   |   11 +++++++++++
 Documentation/DocBook/media/v4l/controls.xml |   23 +++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    3 +++
 include/linux/videodev2.h                    |    2 ++
 4 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index afc8a0d..61f6ff3 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -177,6 +177,17 @@ in the frequency range from 87,5 to 108,0 MHz</title>
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
 
   <!--
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index ec5cbc1..48a0434 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2949,6 +2949,29 @@ giving priority to the center of the metered area.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_ISO</constant>&nbsp;</entry>
+	    <entry>integer menu</entry>
+	  </row><row><entry spanname="descr">Determines ISO equivalent of an
+image sensor indicating the sensor's sensitivity to light. The numbers are
+expressed in arithmetic scale, as per <xref linkend="iso12232" /> standard,
+where doubling the sensor sensitivity is represented by doubling the numerical
+ISO value. Applications should interpret the values as standard ISO values
+multiplied by 1000, e.g. control value 800 stands for ISO 0.8. Drivers will
+usually support only subset of standard ISO values.
+</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_ISO_AUTO</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row><row><entry spanname="descr">Enables automatic ISO control.
+The effect of setting <constant>V4L2_CID_ISO</constant> while automatic
+ISO control is enabled is undefined, drivers should ignore such request.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index ba636f2..96ec73d 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -579,6 +579,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_DO_AUTO_FOCUS:		return "Do Auto Focus";
 	case V4L2_CID_METERING_MODE:		return "Metering Mode";
 	case V4L2_CID_EXPOSURE_BIAS:		return "Exposure, Bias";
+	case V4L2_CID_ISO:			return "Sensitivity (ISO)";
+	case V4L2_CID_ISO_AUTO:			return "Sensitivity (ISO), Auto";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -638,6 +640,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_HFLIP:
 	case V4L2_CID_VFLIP:
 	case V4L2_CID_HUE_AUTO:
+	case V4L2_CID_ISO_AUTO:
 	case V4L2_CID_CHROMA_AGC:
 	case V4L2_CID_COLOR_KILLER:
 	case V4L2_CID_MPEG_AUDIO_MUTE:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 37f93cf..d43149c 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1634,6 +1634,8 @@ enum v4l2_metering_mode {
 };
 
 #define V4L2_CID_EXPOSURE_BIAS			(V4L2_CID_CAMERA_CLASS_BASE+21)
+#define V4L2_CID_ISO				(V4L2_CID_CAMERA_CLASS_BASE+22)
+#define V4L2_CID_ISO_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+23)
 
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
-- 
1.7.4.1

