Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:44776 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab0IFSLC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Sep 2010 14:11:02 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 81147D480ED
	for <linux-media@vger.kernel.org>; Mon,  6 Sep 2010 20:10:56 +0200 (CEST)
Date: Mon, 6 Sep 2010 20:11:05 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [PATCH] Illuminators and status LED controls
Message-ID: <20100906201105.4029d7e7@tele>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/39OnR3hd2Fo.DqfGaHIW880"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--MP_/39OnR3hd2Fo.DqfGaHIW880
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

This new proposal cancels the previous 'LED control' patch.

Cheers.

--=20
Ken ar c'henta=C3=B1	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/39OnR3hd2Fo.DqfGaHIW880
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=led.patch

Some media devices (microscopes) may have one or many illuminators,
and most webcams have a status LED which is normally on when capture is active.
This patch makes them controlable by the applications.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index 8408caa..77f87ad 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -312,10 +312,27 @@ minimum value disables backlight compensation.</entry>
 	    information and bits 24-31 must be zero.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CID_ILLUMINATORS</constant></entry>
+	    <entry>integer</entry>
+	    <entry>Switch on or off the illuminator(s) of the device
+		(usually a microscope).
+	    The control type and values depend on the driver and may be either
+	    a single boolean (0: off, 1:on) or defined by a menu type.</entry>
+	  </row>
+	  <row id="v4l2_status_led">
+	    <entry><constant>V4L2_CID_STATUS_LED</constant></entry>
+	    <entry>integer</entry>
+	    <entry>Set the status LED behaviour. Possible values for
+<constant>enum v4l2_status_led</constant> are:
+<constant>V4L2_STATUS_LED_AUTO</constant> (0),
+<constant>V4L2_STATUS_LED_ON</constant> (1),
+<constant>V4L2_STATUS_LED_OFF</constant> (2).</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
 	    <entry></entry>
 	    <entry>End of the predefined control IDs (currently
-<constant>V4L2_CID_BG_COLOR</constant> + 1).</entry>
+<constant>V4L2_CID_STATUS_LED</constant> + 1).</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 61490c6..75e8869 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1045,8 +1045,16 @@ enum v4l2_colorfx {
 
 #define V4L2_CID_CHROMA_GAIN                    (V4L2_CID_BASE+36)
 
+#define V4L2_CID_ILLUMINATORS			(V4L2_CID_BASE+37)
+#define V4L2_CID_STATUS_LED			(V4L2_CID_BASE+38)
+enum v4l2_status_led {
+	V4L2_STATUS_LED_AUTO	= 0,
+	V4L2_STATUS_LED_ON	= 1,
+	V4L2_STATUS_LED_OFF	= 2,
+};
+
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+37)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+39)
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)

--MP_/39OnR3hd2Fo.DqfGaHIW880--
