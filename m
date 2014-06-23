Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFWXyB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:01 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 04/23] v4l: Add premultiplied alpha flag for pixel formats
Date: Tue, 24 Jun 2014 01:54:10 +0200
Message-Id: <1403567669-18539-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When set, the new V4L2_PIX_FMT_FLAG_PREMUL_ALPHA flag indicates that the
pixel values are premultiplied by the alpha channel value.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 28 +++++++++++++++++++++++++++-
 Documentation/DocBook/media/v4l/v4l2.xml   |  2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c       |  5 +++--
 include/uapi/linux/videodev2.h             |  8 +++++++-
 4 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 8c56cacd..c8e1487 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -135,6 +135,12 @@ extended fields were set to zero. On return drivers must set the
 <constant>V4L2_PIX_FMT_PRIV_MAGIC</constant> and all the extended field to
 applicable values.</para></entry>
 	</row>
+	<row>
+	  <entry>__u32</entry>
+	  <entry><structfield>flags</structfield></entry>
+	    <entry>Flags set by the application or driver, see <xref
+linkend="format-flags" />.</entry>
+	</row>
       </tbody>
     </tgroup>
   </table>
@@ -220,9 +226,15 @@ codes can be used.</entry>
           and the number of valid entries in the
           <structfield>plane_fmt</structfield> array.</entry>
         </row>
+	<row>
+	  <entry>__u8</entry>
+	  <entry><structfield>flags</structfield></entry>
+	  <entry>Flags set by the application or driver, see <xref
+linkend="format-flags" />.</entry>
+	</row>
         <row>
           <entry>__u8</entry>
-          <entry><structfield>reserved[11]</structfield></entry>
+          <entry><structfield>reserved[10]</structfield></entry>
           <entry>Reserved for future extensions. Should be zeroed by the
            application.</entry>
         </row>
@@ -1079,4 +1091,18 @@ concatenated to form the JPEG stream. </para>
 	</tbody>
       </tgroup>
     </table>
+
+    <table frame="none" pgwide="1" id="format-flags">
+      <title>Format Flags</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_PIX_FMT_FLAG_PREMUL_ALPHA</constant></entry>
+	    <entry>0x00000001</entry>
+	    <entry>The pixel values are premultiplied by the alpha channel value.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
   </section>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index d0a48be..f2f81f0 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -155,7 +155,7 @@ applications. -->
 	<revnumber>3.16</revnumber>
 	<date>2014-05-27</date>
 	<authorinitials>lp</authorinitials>
-	<revremark>Extended &v4l2-pix-format;.
+	<revremark>Extended &v4l2-pix-format;. Added format flags.
 	</revremark>
       </revision>
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 01b4588..5a25159 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -256,7 +256,8 @@ static void v4l_print_format(const void *arg, bool write_only)
 		pix = &p->fmt.pix;
 		pr_cont(", width=%u, height=%u, "
 			"pixelformat=%c%c%c%c, field=%s, "
-			"bytesperline=%u, sizeimage=%u, colorspace=%d\n",
+			"bytesperline=%u, sizeimage=%u, colorspace=%d, "
+			"flags %u\n",
 			pix->width, pix->height,
 			(pix->pixelformat & 0xff),
 			(pix->pixelformat >>  8) & 0xff,
@@ -264,7 +265,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 			(pix->pixelformat >> 24) & 0xff,
 			prt_names(pix->field, v4l2_field_names),
 			pix->bytesperline, pix->sizeimage,
-			pix->colorspace);
+			pix->colorspace, pix->flags);
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2656a94..7861b50 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -288,6 +288,7 @@ struct v4l2_pix_format {
 	__u32          		sizeimage;
 	__u32			colorspace;	/* enum v4l2_colorspace */
 	__u32			priv;		/* private data, depends on pixelformat */
+	__u32			flags;		/* format flags (V4L2_PIX_FMT_FLAG_*) */
 };
 
 /*      Pixel format         FOURCC                          depth  Description  */
@@ -452,6 +453,9 @@ struct v4l2_pix_format {
 /* priv field value to indicates that subsequent fields are valid. */
 #define V4L2_PIX_FMT_PRIV_MAGIC		0xdeadbeef
 
+/* Flags */
+#define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA	0x00000001
+
 /*
  *	F O R M A T   E N U M E R A T I O N
  */
@@ -1726,6 +1730,7 @@ struct v4l2_plane_pix_format {
  * @colorspace:		enum v4l2_colorspace; supplemental to pixelformat
  * @plane_fmt:		per-plane information
  * @num_planes:		number of planes for this format
+ * @flags:		format flags (V4L2_PIX_FMT_FLAG_*)
  */
 struct v4l2_pix_format_mplane {
 	__u32				width;
@@ -1736,7 +1741,8 @@ struct v4l2_pix_format_mplane {
 
 	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
 	__u8				num_planes;
-	__u8				reserved[11];
+	__u8				flags;
+	__u8				reserved[10];
 } __attribute__ ((packed));
 
 /**
-- 
1.8.5.5

