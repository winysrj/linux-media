Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34586 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZANUIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 15:08:04 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "mchehab@infradead.org" <mchehab@infradead.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
CC: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Curran, Dominic" <dcurran@ti.com>,
	"sakari.ailus@nokia.com" <sakari.ailus@nokia.com>,
	"mikko.hurskainen@nokia.com" <mikko.hurskainen@nokia.com>,
	"tuukka.o.toivonen@nokia.com" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"mschimek@gmx.at" <mschimek@gmx.at>
Date: Wed, 14 Jan 2009 14:05:40 -0600
Subject: RE: Color FX User control proposal
Message-ID: <A24693684029E5489D1D202277BE8944153C47FB@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> For us to apply, We need also a patch updating V4L2 API docbook.
> 
> Cheers,
> Mauro

Hi,

Should below patch to v4l2spec-0.24 be fine?

Regards,
Sergio

v4l2spec: Add colorFX control documentation

This patch adds description for proposed new V4L2_CID_COLORFX user
control.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 Makefile      |    1 +
 controls.sgml |   11 ++++++++++-
 videodev2.h   |    8 +++++++-
 3 files changed, 18 insertions(+), 2 deletions(-)

Index: v4l2spec-0.24/Makefile
===================================================================
--- v4l2spec-0.24.orig/Makefile	2009-01-14 13:30:23.000000000 -0600
+++ v4l2spec-0.24/Makefile	2009-01-14 13:32:14.000000000 -0600
@@ -338,6 +338,7 @@
 	  v4l2_mpeg_videotype \
 	  v4l2_mpeg_videotype \
 	  v4l2_power_line_frequency \
+	  v4l2_colorfx \
 	  v4l2_prio_state \
 	  ; do echo "-e \"s/ *$$i/\\\\&nbsp;$$i/g\""; done)
 
Index: v4l2spec-0.24/controls.sgml
===================================================================
--- v4l2spec-0.24.orig/controls.sgml	2009-01-14 13:17:18.000000000 -0600
+++ v4l2spec-0.24/controls.sgml	2009-01-14 13:32:53.000000000 -0600
@@ -261,11 +261,20 @@
             <entry>Adjusts the backlight compensation in a camera. The
 minimum value disables backlight compensation.</entry>
           </row>
+	  <row>
+            <entry><constant>V4L2_CID_COLORFX</constant></entry>
+            <entry>integer</entry>
+            <entry>Sets the color effect to be applied to the captured
+or displayed image. Possible values are:
+<constant>V4L2_COLORFX_DEFAULT</constant> (0),
+<constant>V4L2_COLORFX_BW</constant> (1) and
+<constant>V4L2_COLORFX_SEPIA</constant> (2).</entry>
+          </row>
           <row>
             <entry><constant>V4L2_CID_LASTP1</constant></entry>
             <entry></entry>
             <entry>End of the predefined control IDs (currently
-<constant>V4L2_CID_BACKLIGHT_COMPENSATION</constant> + 1).</entry>
+<constant>V4L2_CID_COLORFX</constant> + 1).</entry>
           </row>
           <row>
             <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
Index: v4l2spec-0.24/videodev2.h
===================================================================
--- v4l2spec-0.24.orig/videodev2.h	2009-01-14 13:30:57.000000000 -0600
+++ v4l2spec-0.24/videodev2.h	2009-01-14 13:31:53.000000000 -0600
@@ -879,7 +879,13 @@
 #define V4L2_CID_WHITE_BALANCE_TEMPERATURE	(V4L2_CID_BASE+26)
 #define V4L2_CID_SHARPNESS			(V4L2_CID_BASE+27)
 #define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28)
-#define V4L2_CID_LASTP1				(V4L2_CID_BASE+29) /* last CID + 1 */
+#define V4L2_CID_COLORFX			(V4L2_CID_BASE+31)
+enum v4l2_colorfx {
+	V4L2_COLORFX_DEFAULT	= 0,
+	V4L2_COLORFX_BW		= 1,
+	V4L2_COLORFX_SEPIA	= 2,
+};
+#define V4L2_CID_LASTP1				(V4L2_CID_BASE+32) /* last CID + 1 */
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)


