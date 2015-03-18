Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:54224 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933211AbbCROOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 10:14:07 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 394182A0084
	for <linux-media@vger.kernel.org>; Wed, 18 Mar 2015 15:13:56 +0100 (CET)
Message-ID: <55098824.4030905@xs4all.nl>
Date: Wed, 18 Mar 2015 15:13:56 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC PATCH] v4l2: add support for colorspace conversion for video
 capture
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For video capture it is the driver that reports the colorspace, Y'CbCr encoding
and quantization range used by the video, and there is no way to request something
different, even though many HDTV receivers have some sort of colorspace conversion
capabilities.

For output video this feature already exists since the application specifies this
information for the video format it will send out, and the transmitter will enable
any available CSC if a format conversion has to be performed in order to match
the capabilities of the sink.

For video capture I propose adding a new pix_format flag: V4L2_PIX_FMT_FLAG_REQUEST_CSC.
When set, the driver will interpret the colorspace, ycbcr_enc and quantization fields
as the requested colorspace information and will attempt to do the conversion.

Drivers do not have to actually look at the flag: if the flag is not set, then the
colorspace, ycbcr_enc and quantization fields are set to the default values by the
core, i.e. just pass on the received format without conversion.

Signed-off-by: Hans Verkuil <Hans Verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 13540fa..23b3472 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -107,7 +107,13 @@ hold an image.</entry>
 	  <entry>This information supplements the
 <structfield>pixelformat</structfield> and must be set by the driver for
 capture streams and by the application for output streams,
-see <xref linkend="colorspaces" />.</entry>
+see <xref linkend="colorspaces" />. If the application sets the flag
+<constant>V4L2_PIX_FMT_FLAG_REQUEST_CSC</constant> then the application can
+set this field for a capture stream to request a specific colorspace for the
+captured image data. The driver will attempt to do colorspace conversion to
+the specified colorspace or return the colorspace it will use if it can't do
+the conversion.
+</entry>
 	</row>
 	<row>
 	  <entry>__u32</entry>
@@ -147,7 +153,12 @@ linkend="format-flags" />.</entry>
 	  <entry>This information supplements the
 <structfield>colorspace</structfield> and must be set by the driver for
 capture streams and by the application for output streams,
-see <xref linkend="colorspaces" />.</entry>
+see <xref linkend="colorspaces" />. If the application sets the flag
+<constant>V4L2_PIX_FMT_FLAG_REQUEST_CSC</constant> then the application can 
+set this field for a capture stream to request a specific Y'CbCr encoding for the
+captured image data. The driver will attempt to do the conversion to 
+the specified Y'CbCr encoding or return the encoding it will use if it can't do 
+the conversion. This field is ignored for non-Y'CbCr pixelformats.</entry>
 	</row>
 	<row>
 	  <entry>&v4l2-quantization;</entry>
@@ -155,7 +166,12 @@ see <xref linkend="colorspaces" />.</entry>
 	  <entry>This information supplements the
 <structfield>colorspace</structfield> and must be set by the driver for
 capture streams and by the application for output streams,
-see <xref linkend="colorspaces" />.</entry>
+see <xref linkend="colorspaces" />. If the application sets the flag
+<constant>V4L2_PIX_FMT_FLAG_REQUEST_CSC</constant> then the application can 
+set this field for a capture stream to request a specific quantization for the
+captured image data. The driver will attempt to do the conversion to 
+the specified quantization or return the quantization it will use if it can't do 
+the conversion.</entry>
 	</row>
       </tbody>
     </tgroup>
@@ -251,18 +267,12 @@ linkend="format-flags" />.</entry>
 	<row>
 	  <entry>&v4l2-ycbcr-encoding;</entry>
 	  <entry><structfield>ycbcr_enc</structfield></entry>
-	  <entry>This information supplements the
-<structfield>colorspace</structfield> and must be set by the driver for
-capture streams and by the application for output streams,
-see <xref linkend="colorspaces" />.</entry>
+          <entry>See &v4l2-pix-format;.</entry>
 	</row>
 	<row>
 	  <entry>&v4l2-quantization;</entry>
 	  <entry><structfield>quantization</structfield></entry>
-	  <entry>This information supplements the
-<structfield>colorspace</structfield> and must be set by the driver for
-capture streams and by the application for output streams,
-see <xref linkend="colorspaces" />.</entry>
+          <entry>See &v4l2-pix-format;.</entry>
 	</row>
         <row>
           <entry>__u8</entry>
@@ -498,6 +508,11 @@ so this won't be mentioned explicitly for each colorspace description.</para>
 	</thead>
 	<tbody valign="top">
 	  <row>
+	    <entry><constant>V4L2_COLORSPACE_DEFAULT</constant></entry>
+	    <entry>Use the colorspace as is received from the source or (if unknown)
+fallback to a default colorspace. This 'colorspace' cannot be used with output streams.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_COLORSPACE_SMPTE170M</constant></entry>
 	    <entry>See <xref linkend="col-smpte-170m" />.</entry>
 	  </row>
@@ -1794,6 +1809,16 @@ value. For example, if a light blue pixel with 50% transparency was described by
 RGBA values (128, 192, 255, 128), the same pixel described with premultiplied
 colors would be described by RGBA values (64, 96, 128, 128) </entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_PIX_FMT_FLAG_REQUEST_CSC</constant></entry>
+	    <entry>0x00000002</entry>
+	    <entry>Set by the application. It is only used for capture and is
+ignored for output streams. If set, then request the driver to do colorspace
+conversion from the received colorspace, Y'CbCr encoding and quantization range
+to the requested colorspace, Y'CbCr encoding and quantization range by setting
+the <structfield>colorspace</structfield>, <structfield>ycbcr_enc</structfield>
+and <structfield>quantization</structfield> fields.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 09ad8dd..1a7193a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -991,12 +991,27 @@ static void v4l_sanitize_format(struct v4l2_format *fmt)
 	 * isn't used by applications.
 	 */
 
+	if (fmt->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (fmt->fmt.pix.flags & V4L2_PIX_FMT_FLAG_REQUEST_CSC)
+			return;
+		fmt->fmt.pix.colorspace = V4L2_COLORSPACE_DEFAULT;
+		fmt->fmt.pix.ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+		fmt->fmt.pix.quantization = V4L2_QUANTIZATION_DEFAULT;
+	}
+
 	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    fmt->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return;
 
-	if (fmt->fmt.pix.priv == V4L2_PIX_FMT_PRIV_MAGIC)
+	if (fmt->fmt.pix.priv == V4L2_PIX_FMT_PRIV_MAGIC) {
+		if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+		    (fmt->fmt.pix.flags & V4L2_PIX_FMT_FLAG_REQUEST_CSC))
+			return;
+		fmt->fmt.pix.colorspace = V4L2_COLORSPACE_DEFAULT;
+		fmt->fmt.pix.ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
+		fmt->fmt.pix.quantization = V4L2_QUANTIZATION_DEFAULT;
 		return;
+	}
 
 	fmt->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fbdc360..c780346 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -178,6 +178,12 @@ enum v4l2_memory {
 
 /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
 enum v4l2_colorspace {
+	/*
+	 * Default colorspace, i.e. let the driver figure it out.
+	 * Can only be used with video capture.
+	 */
+	V4L2_COLORSPACE_DEFAULT       = 0,
+
 	/* SMPTE 170M: used for broadcast NTSC/PAL SDTV */
 	V4L2_COLORSPACE_SMPTE170M     = 1,
 
@@ -541,6 +547,7 @@ struct v4l2_pix_format {
 
 /* Flags */
 #define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA	0x00000001
+#define V4L2_PIX_FMT_FLAG_REQUEST_CSC	0x00000002
 
 /*
  *	F O R M A T   E N U M E R A T I O N
