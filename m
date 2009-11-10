Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37376 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbZKJOpp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 09:45:45 -0500
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id nAAEjlUk021129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 08:45:50 -0600
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH] v4l2 doc: Added FBUF_CAP_SRC_CHROMAKEY/FLAG_SRC_CHROMAKEY
Date: Tue, 10 Nov 2009 20:15:45 +0530
Message-Id: <1257864345-13595-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 linux/Documentation/DocBook/v4l/videodev2.h.xml   |    2 ++
 linux/Documentation/DocBook/v4l/vidioc-g-fbuf.xml |   17 +++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/linux/Documentation/DocBook/v4l/videodev2.h.xml b/linux/Documentation/DocBook/v4l/videodev2.h.xml
index 9700206..eef7ba4 100644
--- a/linux/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/linux/Documentation/DocBook/v4l/videodev2.h.xml
@@ -565,6 +565,7 @@ struct <link linkend="v4l2-framebuffer">v4l2_framebuffer</link> {
 #define V4L2_FBUF_CAP_LOCAL_ALPHA       0x0010
 #define V4L2_FBUF_CAP_GLOBAL_ALPHA      0x0020
 #define V4L2_FBUF_CAP_LOCAL_INV_ALPHA   0x0040
+#define V4L2_FBUF_CAP_SRC_CHROMAKEY     0x0080
 /*  Flags for the 'flags' field. */
 #define V4L2_FBUF_FLAG_PRIMARY          0x0001
 #define V4L2_FBUF_FLAG_OVERLAY          0x0002
@@ -572,6 +573,7 @@ struct <link linkend="v4l2-framebuffer">v4l2_framebuffer</link> {
 #define V4L2_FBUF_FLAG_LOCAL_ALPHA      0x0008
 #define V4L2_FBUF_FLAG_GLOBAL_ALPHA     0x0010
 #define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA  0x0020
+#define V4L2_FBUF_FLAG_SRC_CHROMAKEY    0x0040
 
 struct <link linkend="v4l2-clip">v4l2_clip</link> {
         struct <link linkend="v4l2-rect">v4l2_rect</link>        c;
diff --git a/linux/Documentation/DocBook/v4l/vidioc-g-fbuf.xml b/linux/Documentation/DocBook/v4l/vidioc-g-fbuf.xml
index f701706..e7dda48 100644
--- a/linux/Documentation/DocBook/v4l/vidioc-g-fbuf.xml
+++ b/linux/Documentation/DocBook/v4l/vidioc-g-fbuf.xml
@@ -336,6 +336,13 @@ alpha value. Alpha blending makes no sense for destructive overlays.</entry>
 inverted alpha channel of the framebuffer or VGA signal. Alpha
 blending makes no sense for destructive overlays.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_FBUF_CAP_SRC_CHROMAKEY</constant></entry>
+	    <entry>0x0080</entry>
+	    <entry>The device supports Source Chroma-keying. Framebuffer pixels
+with the chroma-key colors are replaced by video pixels, which is exactly opposite of
+<constant>V4L2_FBUF_CAP_CHROMAKEY</constant></entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
@@ -411,6 +418,16 @@ images, but with an inverted alpha value. The blend function is:
 output = framebuffer pixel * (1 - alpha) + video pixel * alpha. The
 actual alpha depth depends on the framebuffer pixel format.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_FBUF_FLAG_SRC_CHROMAKEY</constant></entry>
+	    <entry>0x0040</entry>
+	    <entry>Use source chroma-keying. The source chroma-key color is
+determined by the <structfield>chromakey</structfield> field of
+&v4l2-window; and negotiated with the &VIDIOC-S-FMT; ioctl, see <xref
+linkend="overlay" /> and <xref linkend="osd" />.
+Both chroma-keying are mutual exclusive to each other, so same
+<structfield>chromakey</structfield> field of &v4l2-window; is being used.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
1.6.2.4

