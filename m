Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:50733 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbZDFMkp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 08:40:45 -0400
From: Hardik Shah <hardik.shah@ti.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Hardik Shah <hardik.shah@ti.com>,
	Brijesh Jadav <brijesh.j@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 1/3] Documentation for new V4L2 CIDs added.
Date: Mon,  6 Apr 2009 18:10:35 +0530
Message-Id: <1239021635-16252-1-git-send-email-hardik.shah@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1. Updated for V4L2_CID_BG_COLOR
2. Updated for V4L2_CID_ROTATION
Both of the above are discussed in length with community
3. Updated for new flags and capability field added
to v4l2_frame buffer structure.

Community comments fixed in this post
1. Fixed Few typos.
2. Changed V4L2_CID_ROTATION to V4L2_CID_ROTATE
3. Re-framed source chroma keying related explanation

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
Signed-off-by: Hardik Shah <hardik.shah@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 v4l2-spec/controls.sgml      |   19 ++++++++++++++++++-
 v4l2-spec/vidioc-g-fbuf.sgml |   19 +++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/v4l2-spec/controls.sgml b/v4l2-spec/controls.sgml
index 477a970..3a91061 100644
--- a/v4l2-spec/controls.sgml
+++ b/v4l2-spec/controls.sgml
@@ -281,10 +281,27 @@ minimum value disables backlight compensation.</entry>
 <constant>V4L2_COLORFX_SEPIA</constant> (2).</entry>
 	  </row>
 	  <row>
+ 	    <entry><constant>V4L2_CID_ROTATE</constant></entry>
+ 	    <entry>integer</entry>
+ 	    <entry>Rotates the image by specified angle. Common angles are 90, 270,
+and 180. Rotating the image to 90 and 270 will reverse the height and width of
+the display window.  It is necessary to set the new height and width of the picture
+using S_FMT ioctl see <xref linkend="vidioc-g-fmt"> according to the rotation angle selected</entry>
+ 	  </row>
+ 	  <row>
+ 	    <entry><constant>V4L2_CID_BG_COLOR</constant></entry>
+ 	    <entry>integer</entry>
+ 	    <entry>Sets the background color of the current output device.
+Background color needs to be specified in the RGB24 format.  The supplied 32
+bit value is intepreted as Bits 0-7 Red color information, Bits 8-15 Green color
+information, Bits 16-23 Blue color information and Bits 24-31 must be
+zero.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
 	    <entry></entry>
 	    <entry>End of the predefined control IDs (currently
-<constant>V4L2_CID_COLORFX</constant> + 1).</entry>
+<constant>V4L2_CID_BG_COLOR</constant> + 1).</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
diff --git a/v4l2-spec/vidioc-g-fbuf.sgml b/v4l2-spec/vidioc-g-fbuf.sgml
index 6781b53..13c9ac6 100644
--- a/v4l2-spec/vidioc-g-fbuf.sgml
+++ b/v4l2-spec/vidioc-g-fbuf.sgml
@@ -336,6 +336,13 @@ alpha value. Alpha blending makes no sense for destructive overlays.</entry>
 inverted alpha channel of the framebuffer or VGA signal. Alpha
 blending makes no sense for destructive overlays.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_FBUF_CAP_SRC_CHROMAKEY</constant></entry>
+	    <entry>0x0080</entry>
+	    <entry>The device supports source chroma keying. Video pixels
+	    with the chromakey color are replaced by the framebuffer pixels.
+	    Exactly opposite of <constant>V4L2_FBUF_CAP_CHROMAKEY</constant></entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
@@ -411,6 +418,18 @@ images, but with an inverted alpha value. The blend function is:
 output = framebuffer pixel * (1 - alpha) + video pixel * alpha. The
 actual alpha depth depends on the framebuffer pixel format.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_FBUF_FLAG_SRC_CHROMAKEY</constant></entry>
+	    <entry>0x0040</entry>
+	    <entry>Use source chroma-keying. The chroma-key color is
+determined by the <structfield>chromakey</structfield> field of
+&v4l2-window; and negotiated with the &VIDIOC-S-FMT; ioctl, see <xref
+linkend="overlay"> and <xref linkend="osd">.
+Since any one of the chroma keying can be active at a time as both
+of them are exactly opposite, the same <structfield>chromakey</structfield>
+field of &v4l2-window; can be used to set the chroma key for source
+keying also.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
--
1.6.0.3

