Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60154 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab2DQKKG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:10:06 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2M005XMC8LYC@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:09:58 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2M0046RC8PI3@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:10:01 +0100 (BST)
Date: Tue, 17 Apr 2012 12:09:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 01/15] V4L: Extend V4L2_CID_COLORFX with more image effects
In-reply-to: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1334657396-5737-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds definition of additional color effects:
 - V4L2_COLORFX_AQUA,
 - V4L2_COLORFX_ART_FREEZE,
 - V4L2_COLORFX_SILHOUETTE,
 - V4L2_COLORFX_SOLARIZATION,
 - V4L2_COLORFX_ANTIQUE,
 - V4L2_COLORFX_ARBITRARY.

The control's type in the documentation is changed from 'enum' to 'menu'
- V4L2_CID_COLORFX has always been a menu, not an integer type control.

The V4L2_COLORFX_ARBITRARY option enables custom color effects, which are
impossible or impractical to define as the menu items. For example, the
devices may provide coefficients for Cb and Cr manipulation, which yield
many permutations, e.g. many slightly different color tints. Such devices
are better exporting their own API for precise control of non-standard
color effects.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   91 ++++++++++++++++++++++----
 drivers/media/video/v4l2-ctrls.c             |    6 ++
 include/linux/videodev2.h                    |   26 +++++---
 3 files changed, 100 insertions(+), 23 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 6e2a2c6..0e2040d 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -284,19 +284,84 @@ minimum value disables backlight compensation.</entry>
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
+		<row>
+		  <entry><constant>V4L2_COLORFX_ARBITRARY</constant>&nbsp;</entry>
+		  <entry>Arbitrary color effect, determined by other means, e.g.
+with driver private controls.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_ROTATE</constant></entry>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 34ff32d..13e6e8d 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -241,6 +241,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Grass Green",
 		"Skin Whiten",
 		"Vivid",
+		"Aqua",
+		"Art Freeze",
+		"Silhouette",
+		"Solarization",
+		"Antique",
+		"Arbitrary",
 		NULL
 	};
 	static const char * const tune_preemphasis[] = {
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 2503857..95ce588 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1269,16 +1269,22 @@ enum v4l2_power_line_frequency {
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
+	V4L2_COLORFX_ARBITRARY			= 15,
 };
 #define V4L2_CID_AUTOBRIGHTNESS			(V4L2_CID_BASE+32)
 #define V4L2_CID_BAND_STOP_FILTER		(V4L2_CID_BASE+33)
-- 
1.7.10

