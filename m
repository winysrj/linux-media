Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50430 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab2D3QPH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 12:15:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3A00LKRVSUCX40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 17:14:54 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3A0083IVSH3M@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 17:14:42 +0100 (BST)
Date: Mon, 30 Apr 2012 18:14:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 01/12] V4L: Extend V4L2_CID_COLORFX with more image effects
In-reply-to: <1335802481-18153-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335802481-18153-2-git-send-email-s.nawrocki@samsung.com>
References: <1335802481-18153-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds definition of additional color effects:

 - V4L2_COLORFX_AQUA,
 - V4L2_COLORFX_ART_FREEZE,
 - V4L2_COLORFX_SILHOUETTE,
 - V4L2_COLORFX_SOLARIZATION,
 - V4L2_COLORFX_ANTIQUE,
 - V4L2_COLORFX_SET_CBCR.

The control's type in the documentation is changed from 'enum' to 'menu'
- V4L2_CID_COLORFX has always been a menu, not an integer type control.

The new V4L2_COLORFX_CBCR is added to allow for setting the fixed
Cb, Cr values which are replacing chroma Cb/Cr coefficients in case
of V4L2_COLORFX_SET_CBCR effect.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/compat.xml   |   13 ++++
 Documentation/DocBook/media/v4l/controls.xml |  100 ++++++++++++++++++++++----
 Documentation/DocBook/media/v4l/v4l2.xml     |    5 +-
 drivers/media/video/v4l2-ctrls.c             |    7 ++
 include/linux/videodev2.h                    |   29 +++++---
 5 files changed, 128 insertions(+), 26 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 87339b2..149f65d 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2422,6 +2422,19 @@ details.</para>
 	  &VIDIOC-SUBDEV-G-SELECTION; and
 	  &VIDIOC-SUBDEV-S-SELECTION;.</para>
         </listitem>
+        <listitem>
+	  <para> Added <constant>V4L2_COLORFX_ANTIQUE</constant>,
+	  <constant>V4L2_COLORFX_ART_FREEZE</constant>,
+	  <constant>V4L2_COLORFX_AQUA</constant>,
+	  <constant>V4L2_COLORFX_SILHOUETTE</constant>,
+	  <constant>V4L2_COLORFX_SOLARIZATION</constant>,
+	  <constant>V4L2_COLORFX_VIVID</constant> and
+	  <constant>V4L2_COLORFX_ARBITRARY_CBCR</constant> menu items
+	  to the <constant>V4L2_CID_COLORFX</constant> control.</para>
+        </listitem>
+        <listitem>
+	  <para> Added <constant>V4L2_CID_COLORFX_CBCR</constant> control.</para>
+        </listitem>
       </orderedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 5038a3a..b63e444 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -284,19 +284,93 @@ minimum value disables backlight compensation.</entry>
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
+		  <entry><constant>V4L2_COLORFX_SET_CBCR</constant>&nbsp;</entry>
+		  <entry>The Cb and Cr chroma components are replaced by fixed
+		  coefficients determined by <constant>V4L2_CID_COLORFX_CBCR</constant>
+		  control.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CID_COLORFX_CBCR</constant></entry>
+	    <entry>integer</entry>
+	    <entry>Determines the Cb and Cr coefficients for <constant>V4L2_COLORFX_SET_CBCR</constant>
+	    color effect. Bits [7:0] of the supplied 32 bit value are interpreted as
+	    Cr component, bits [15:8] as Cb component and bits [31:16] must be zero.
+	  </entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_ROTATE</constant></entry>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index fbf808d..35c296b 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -141,9 +141,10 @@ applications. -->
       <revision>
 	<revnumber>3.5</revnumber>
 	<date>2012-04-02</date>
-	<authorinitials>sa</authorinitials>
+	<authorinitials>sa, sn</authorinitials>
 	<revremark>Added V4L2_CTRL_TYPE_INTEGER_MENU and V4L2 subdev
-	    selections API.
+	    selections API. Corrected and extended the description
+	    of V4L2_CID_COLORFX control, added V4L2_CID_COLORFX_CBCR control.
 	</revremark>
       </revision>
 
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index c93a979..4f7b8ab 100644
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
+		"Set Cb/Cr",
 		NULL
 	};
 	static const char * const tune_preemphasis[] = {
@@ -493,6 +499,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:	return "Min Number of Capture Buffers";
 	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:	return "Min Number of Output Buffers";
 	case V4L2_CID_ALPHA_COMPONENT:		return "Alpha Component";
+	case V4L2_CID_COLORFX_CBCR:		return "Color Effects, CbCr";
 
 	/* MPEG controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5a09ac3..becb2ed 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1241,16 +1241,22 @@ enum v4l2_power_line_frequency {
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
+	V4L2_COLORFX_SET_CBCR			= 15,
 };
 #define V4L2_CID_AUTOBRIGHTNESS			(V4L2_CID_BASE+32)
 #define V4L2_CID_BAND_STOP_FILTER		(V4L2_CID_BASE+33)
@@ -1267,9 +1273,10 @@ enum v4l2_colorfx {
 #define V4L2_CID_MIN_BUFFERS_FOR_OUTPUT		(V4L2_CID_BASE+40)
 
 #define V4L2_CID_ALPHA_COMPONENT		(V4L2_CID_BASE+41)
+#define V4L2_CID_COLORFX_CBCR			(V4L2_CID_BASE+42)
 
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+42)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+43)
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
-- 
1.7.10

