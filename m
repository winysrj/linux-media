Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35399 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab1LDPQr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Dec 2011 10:16:47 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so5379144wgb.1
        for <linux-media@vger.kernel.org>; Sun, 04 Dec 2011 07:16:46 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com, Sylwester Nawrocki <snjw23@gmail.com>
Subject: [RFC/PATCH 4/5] v4l: Add V4L2_CID_EXPOSURE_BIAS camera control
Date: Sun,  4 Dec 2011 16:16:15 +0100
Message-Id: <1323011776-15967-5-git-send-email-snjw23@gmail.com>
In-Reply-To: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_EXPOSURE_BIAS control allows for manual exposure
compensation when automatic exposure algorithm is enabled.

Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   16 ++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    1 +
 include/linux/videodev2.h                    |    2 ++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 53d7c08..ec5cbc1 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2691,6 +2691,22 @@ and 100000 for 10 seconds.</entry>
 	  <row><entry></entry></row>
 
 	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_EXPOSURE_BIAS</constant>&nbsp;</entry>
+	    <entry>integer (menu?)</entry>
+	  </row><row><entry spanname="descr"> Determines the exposure
+compensation when <constant>V4L2_CID_EXPOSURE_AUTO</constant> control
+is set to <constant>AUTO</constant>, <constant>SHUTTER_PRIORITY
+</constant> or <constant>APERTURE_PRIORITY</constant>. It is expressed
+in terms of EV, drivers should interpret the values as 0.001 EV units,
+where the value 1000 stands for +1 EV.
+<para>Increasing the exposure compensation value is equivalent to
+decreasing the exposure value (EV) and will increase the amount of
+light at the image sensor. The camera performs the exposure compensation
+by adjusting absolute exposure time and/or aperture.</para></entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_EXPOSURE_AUTO_PRIORITY</constant>&nbsp;</entry>
 	    <entry>boolean</entry>
 	  </row><row><entry spanname="descr">When
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 8d0cd0e..ba636f2 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -578,6 +578,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
 	case V4L2_CID_DO_AUTO_FOCUS:		return "Do Auto Focus";
 	case V4L2_CID_METERING_MODE:		return "Metering Mode";
+	case V4L2_CID_EXPOSURE_BIAS:		return "Exposure, Bias";
 
 	/* FM Radio Modulator control */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 8956ed6..37f93cf 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1633,6 +1633,8 @@ enum v4l2_metering_mode {
 	V4L2_METERING_MODE_SPOT,
 };
 
+#define V4L2_CID_EXPOSURE_BIAS			(V4L2_CID_CAMERA_CLASS_BASE+21)
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.4.1

