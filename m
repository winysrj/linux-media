Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47485 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab2CaJiw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 05:38:52 -0400
Received: by wgbdr13 with SMTP id dr13so1256784wgb.1
        for <linux-media@vger.kernel.org>; Sat, 31 Mar 2012 02:38:50 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH/RFC] V4L: Extend V4L2_CID_COLORFX with more image effects
Date: Sat, 31 Mar 2012 11:38:27 +0200
Message-Id: <1333186707-15772-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds definition of additional color effects:
 - V4L2_COLORFX_AQUA,
 - V4L2_COLORFX_ART_FREEZE,
 - V4L2_COLORFX_SILHOUETTE,
 - V4L2_COLORFX_SOLARIZATION,
 - V4L2_COLORFX_ANTIQUE.

The control's type in the documentation is changed from 'enum' to 'menu'
- V4L2_CID_COLORFX has always been a menu, not an integer type control.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   86 ++++++++++++++++++++++----
 drivers/media/video/v4l2-ctrls.c             |    5 ++
 include/linux/videodev2.h                    |   25 +++++---
 3 files changed, 93 insertions(+), 23 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index b84f25e..582324f 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -284,19 +284,79 @@ minimum value disables backlight compensation.</entry>
 	  </row>
 	  <row id="v4l2-colorfx">
 	    <entry><constant>V4L2_CID_COLORFX</constant></entry>
-	    <entry>enum</entry>
-	    <entry>Selects a color effect. Possible values for
-<constant>enum v4l2_colorfx</constant> are:
-<constant>V4L2_COLORFX_NONE</constant> (0),
-<constant>V4L2_COLORFX_BW</constant> (1),
-<constant>V4L2_COLORFX_SEPIA</constant> (2),
-<constant>V4L2_COLORFX_NEGATIVE</constant> (3),
-<constant>V4L2_COLORFX_EMBOSS</constant> (4),
-<constant>V4L2_COLORFX_SKETCH</constant> (5),
-<constant>V4L2_COLORFX_SKY_BLUE</constant> (6),
-<constant>V4L2_COLORFX_GRASS_GREEN</constant> (7),
-<constant>V4L2_COLORFX_SKIN_WHITEN</constant> (8) and
-<constant>V4L2_COLORFX_VIVID</constant> (9).</entry>
+	    <entry>menu</entry>
+	    <entry>Selects a color effect. The following values are defined:
+	    </entry>
+	  </row><row>
+	  <entry></entry>
+	  <entry></entry>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_COLORFX_NONE</constant>&nbsp;</entry>
+		  <entry>Color effect is disabled.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_ANTIQUE</constant>&nbsp;</entry>
+		  <entry>An aging (old photo) effect.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_ART_FREEZE</constant>&nbsp;</entry>
+		  <entry>Frost color effect.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_AQUA</constant>&nbsp;</entry>
+		  <entry>Water color, cool tone.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_BW</constant>&nbsp;</entry>
+		  <entry>Black and white.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_EMBOSS</constant>&nbsp;</entry>
+		  <entry>Emboss, the highlights and shadows replace light/dark boundaries
+		  and low contrast areas are set to a gray background.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_GRASS_GREEN</constant>&nbsp;</entry>
+		  <entry>Grass green.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_NEGATIVE</constant>&nbsp;</entry>
+		  <entry>Negative.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_SEPIA</constant>&nbsp;</entry>
+		  <entry>Sepia tone.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_SKETCH</constant>&nbsp;</entry>
+		  <entry>Sketch.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_SKIN_WHITEN</constant>&nbsp;</entry>
+		  <entry>Skin whiten.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_SKY_BLUE</constant>&nbsp;</entry>
+		  <entry>Sky blue.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_SOLARIZATION</constant>&nbsp;</entry>
+		  <entry>Solarization, the image is partially reversed in tone,
+		  only color values above or below a certain threshold are inverted.
+		  </entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_SILHOUETTE</constant>&nbsp;</entry>
+		  <entry>Silhouette (outline).</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_COLORFX_VIVID</constant>&nbsp;</entry>
+		  <entry>Vivid colors.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_ROTATE</constant></entry>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 18015c0..7d6617c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -241,6 +241,11 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Grass Green",
 		"Skin Whiten",
 		"Vivid",
+		"Aqua",
+		"Art Freeze",
+		"Silhouette",
+		"Solarization",
+		"Antique",
 		NULL
 	};
 	static const char * const tune_preemphasis[] = {
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index c9c9a46..be50b4d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1237,17 +1237,21 @@ enum v4l2_power_line_frequency {
 #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
 #define V4L2_CID_COLORFX			(V4L2_CID_BASE+31)
 enum v4l2_colorfx {
-	V4L2_COLORFX_NONE	= 0,
-	V4L2_COLORFX_BW		= 1,
-	V4L2_COLORFX_SEPIA	= 2,
-	V4L2_COLORFX_NEGATIVE = 3,
-	V4L2_COLORFX_EMBOSS = 4,
-	V4L2_COLORFX_SKETCH = 5,
-	V4L2_COLORFX_SKY_BLUE = 6,
-	V4L2_COLORFX_GRASS_GREEN = 7,
-	V4L2_COLORFX_SKIN_WHITEN = 8,
-	V4L2_COLORFX_VIVID = 9,
+	V4L2_COLORFX_NONE			= 0,
+	V4L2_COLORFX_BW				= 1,
+	V4L2_COLORFX_SEPIA			= 2,
+	V4L2_COLORFX_NEGATIVE			= 3,
+	V4L2_COLORFX_EMBOSS			= 4,
+	V4L2_COLORFX_SKETCH			= 5,
+	V4L2_COLORFX_SKY_BLUE			= 6,
+	V4L2_COLORFX_GRASS_GREEN		= 7,
+	V4L2_COLORFX_SKIN_WHITEN		= 8,
+	V4L2_COLORFX_VIVID			= 9,
+	V4L2_COLORFX_AQUA			= 10,
+	V4L2_COLORFX_ART_FREEZE			= 11,
+	V4L2_COLORFX_SILHOUETTE			= 12,
+	V4L2_COLORFX_SOLARIZATION		= 13,
+	V4L2_COLORFX_ANTIQUE			= 14,
 };
 #define V4L2_CID_AUTOBRIGHTNESS			(V4L2_CID_BASE+32)
 #define V4L2_CID_BAND_STOP_FILTER		(V4L2_CID_BASE+33)
--
1.7.4.1

