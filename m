Return-path: <mchehab@localhost>
Received: from smtp5-g21.free.fr ([212.27.42.5]:49569 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab0IDLKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Sep 2010 07:10:48 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 83D79D4805F
	for <linux-media@vger.kernel.org>; Sat,  4 Sep 2010 13:10:42 +0200 (CEST)
Date: Sat, 4 Sep 2010 13:10:48 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [PATCH] LED control
Message-ID: <20100904131048.6ca207d1@tele>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/k9=agR0s76BWcZz/De93XEC"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

--MP_/k9=agR0s76BWcZz/De93XEC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Some media devices may have one or many lights (LEDs, illuminators,
lamps..). This patch makes them controlable by the applications.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

--=20
Ken ar c'henta=C3=B1	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/k9=agR0s76BWcZz/De93XEC
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=led.patch

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index 8408caa..c9b8ca5 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -312,6 +312,13 @@ minimum value disables backlight compensation.</entry>
 	    information and bits 24-31 must be zero.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CID_LEDS</constant></entry>
+	    <entry>integer</entry>
+	    <entry>Switch on or off the LED(s) or illuminator(s) of the device.
+	    The control type and values depend on the driver and may be either
+	    a single boolean (0: off, 1:on) or the index in a menu type.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
 	    <entry></entry>
 	    <entry>End of the predefined control IDs (currently
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 61490c6..3807492 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1045,8 +1045,10 @@ enum v4l2_colorfx {
 
 #define V4L2_CID_CHROMA_GAIN                    (V4L2_CID_BASE+36)
 
+#define V4L2_CID_LEDS				(V4L2_CID_BASE+37)
+
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+37)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+38)
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)

--MP_/k9=agR0s76BWcZz/De93XEC--
