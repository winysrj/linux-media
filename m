Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38310 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758138AbbEaNLx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 09:11:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/9] DocBook/media: document new xfer_func fields.
Date: Sun, 31 May 2015 15:11:32 +0200
Message-Id: <1433077899-18516-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new field and defines to set the transfer function needed
to correctly decode the colors of an image.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml         | 113 +++++++++++++++++----
 Documentation/DocBook/media/v4l/subdev-formats.xml |  12 ++-
 2 files changed, 101 insertions(+), 24 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 6c3d653..e7d8848 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -157,6 +157,14 @@ see <xref linkend="colorspaces" />.</entry>
 capture streams and by the application for output streams,
 see <xref linkend="colorspaces" />.</entry>
 	</row>
+	<row>
+	  <entry>&v4l2-xfer-func;</entry>
+	  <entry><structfield>xfer_func</structfield></entry>
+	  <entry>This information supplements the
+<structfield>colorspace</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
+see <xref linkend="colorspaces" />.</entry>
+	</row>
       </tbody>
     </tgroup>
   </table>
@@ -264,9 +272,17 @@ see <xref linkend="colorspaces" />.</entry>
 capture streams and by the application for output streams,
 see <xref linkend="colorspaces" />.</entry>
 	</row>
+	<row>
+	  <entry>&v4l2-xfer-func;</entry>
+	  <entry><structfield>xfer_func</structfield></entry>
+	  <entry>This information supplements the
+<structfield>colorspace</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
+see <xref linkend="colorspaces" />.</entry>
+	</row>
         <row>
           <entry>__u8</entry>
-          <entry><structfield>reserved[8]</structfield></entry>
+          <entry><structfield>reserved[7]</structfield></entry>
           <entry>Reserved for future extensions. Should be zeroed by the
            application.</entry>
         </row>
@@ -476,15 +492,16 @@ is also very useful.</para>
 
   <section>
     <title>Defining Colorspaces in V4L2</title>
-    <para>In V4L2 colorspaces are defined by three values. The first is the colorspace
-identifier (&v4l2-colorspace;) which defines the chromaticities, the transfer
+    <para>In V4L2 colorspaces are defined by four values. The first is the colorspace
+identifier (&v4l2-colorspace;) which defines the chromaticities, the default transfer
 function, the default Y'CbCr encoding and the default quantization method. The second
-is the Y'CbCr encoding identifier (&v4l2-ycbcr-encoding;) to specify non-standard
-Y'CbCr encodings and the third is the quantization identifier (&v4l2-quantization;)
-to specify non-standard quantization methods. Most of the time only the colorspace
-field of &v4l2-pix-format; or &v4l2-pix-format-mplane; needs to be filled in. Note
-that the default R'G'B' quantization is full range for all colorspaces except for
-BT.2020 which uses limited range R'G'B' quantization.</para>
+is the transfer function identifier (&v4l2-xfer-func;) to specify non-standard
+transfer functions. The third is the Y'CbCr encoding identifier (&v4l2-ycbcr-encoding;)
+to specify non-standard Y'CbCr encodings and the fourth is the quantization identifier
+(&v4l2-quantization;) to specify non-standard quantization methods. Most of the time
+only the colorspace field of &v4l2-pix-format; or &v4l2-pix-format-mplane; needs to
+be filled in. Note that the default R'G'B' quantization is full range for all
+colorspaces except for BT.2020 which uses limited range R'G'B' quantization.</para>
 
     <table pgwide="1" frame="none" id="v4l2-colorspace">
       <title>V4L2 Colorspaces</title>
@@ -549,6 +566,45 @@ BT.2020 which uses limited range R'G'B' quantization.</para>
       </tgroup>
     </table>
 
+    <table pgwide="1" frame="none" id="v4l2-xfer-func">
+      <title>V4L2 Transfer Function</title>
+      <tgroup cols="2" align="left">
+	&cs-def;
+	<thead>
+	  <row>
+	    <entry>Identifier</entry>
+	    <entry>Details</entry>
+	  </row>
+	</thead>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_XFER_FUNC_DEFAULT</constant></entry>
+	    <entry>Use the default transfer function as defined by the colorspace.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_XFER_FUNC_709</constant></entry>
+	    <entry>Use the Rec. 709 transfer function.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_XFER_FUNC_SRGB</constant></entry>
+	    <entry>Use the sRGB transfer function.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_XFER_FUNC_ADOBERGB</constant></entry>
+	    <entry>Use the AdobeRGB transfer function.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_XFER_FUNC_SMPTE240M</constant></entry>
+	    <entry>Use the SMPTE 240M transfer function.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_XFER_FUNC_NONE</constant></entry>
+	    <entry>Do not use a transfer function (i.e. use linear RGB values).</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
     <table pgwide="1" frame="none" id="v4l2-ycbcr-encoding">
       <title>V4L2 Y'CbCr Encodings</title>
       <tgroup cols="2" align="left">
@@ -636,7 +692,8 @@ is mapped to [16&hellip;235]. Cb and Cr are mapped from [-0.5&hellip;0.5] to [16
     <section id="col-smpte-170m">
       <title>Colorspace SMPTE 170M (<constant>V4L2_COLORSPACE_SMPTE170M</constant>)</title>
       <para>The <xref linkend="smpte170m" /> standard defines the colorspace used by NTSC and PAL and by SDTV
-in general. The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_601</constant>.
+in general. The default transfer function is <constant>V4L2_XFER_FUNC_709</constant>.
+The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_601</constant>.
 The default Y'CbCr quantization is limited range. The chromaticities of the primary colors and
 the white reference are:</para>
       <table frame="none">
@@ -718,7 +775,8 @@ rarely seen.</para>
 
     <section id="col-rec709">
       <title>Colorspace Rec. 709 (<constant>V4L2_COLORSPACE_REC709</constant>)</title>
-      <para>The <xref linkend="itu709" /> standard defines the colorspace used by HDTV in general. The default
+      <para>The <xref linkend="itu709" /> standard defines the colorspace used by HDTV in general.
+The default transfer function is <constant>V4L2_XFER_FUNC_709</constant>. The default
 Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_709</constant>. The default Y'CbCr quantization is
 limited range. The chromaticities of the primary colors and the white reference are:</para>
       <table frame="none">
@@ -829,9 +887,11 @@ The xvYCC encodings always use full range quantization.</para>
 
     <section id="col-srgb">
       <title>Colorspace sRGB (<constant>V4L2_COLORSPACE_SRGB</constant>)</title>
-      <para>The <xref linkend="srgb" /> standard defines the colorspace used by most webcams and computer graphics. The
-default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_SYCC</constant>. The default Y'CbCr quantization
-is full range. The chromaticities of the primary colors and the white reference are:</para>
+      <para>The <xref linkend="srgb" /> standard defines the colorspace used by most webcams
+and computer graphics. The default transfer function is <constant>V4L2_XFER_FUNC_SRGB</constant>.
+The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_SYCC</constant>. The default Y'CbCr
+quantization is full range. The chromaticities of the primary colors and the white
+reference are:</para>
       <table frame="none">
         <title>sRGB Chromaticities</title>
         <tgroup cols="3" align="left">
@@ -908,6 +968,7 @@ values before quantization, but this encoding does not do that.</para>
       <title>Colorspace Adobe RGB (<constant>V4L2_COLORSPACE_ADOBERGB</constant>)</title>
       <para>The <xref linkend="adobergb" /> standard defines the colorspace used by computer graphics
 that use the AdobeRGB colorspace. This is also known as the <xref linkend="oprgb" /> standard.
+The default transfer function is <constant>V4L2_XFER_FUNC_ADOBERGB</constant>.
 The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_601</constant>. The default Y'CbCr
 quantization is limited range. The chromaticities of the primary colors and the white reference
 are:</para>
@@ -979,7 +1040,8 @@ SMPTE 170M/BT.601. The Y'CbCr quantization is limited range.</para>
     <section id="col-bt2020">
       <title>Colorspace BT.2020 (<constant>V4L2_COLORSPACE_BT2020</constant>)</title>
       <para>The <xref linkend="itu2020" /> standard defines the colorspace used by Ultra-high definition
-television (UHDTV). The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_BT2020</constant>.
+television (UHDTV). The default transfer function is <constant>V4L2_XFER_FUNC_709</constant>.
+The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_BT2020</constant>.
 The default R'G'B' quantization is limited range (!), and so is the default Y'CbCr quantization.
 The chromaticities of the primary colors and the white reference are:</para>
       <table frame="none">
@@ -1094,8 +1156,10 @@ clamped to the range [-0.5&hellip;0.5]. The Yc'CbcCrc quantization is limited ra
 
     <section id="col-smpte-240m">
       <title>Colorspace SMPTE 240M (<constant>V4L2_COLORSPACE_SMPTE240M</constant>)</title>
-      <para>The <xref linkend="smpte240m" /> standard was an interim standard used during the early days of HDTV (1988-1998).
-It has been superseded by Rec. 709. The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_SMPTE240M</constant>.
+      <para>The <xref linkend="smpte240m" /> standard was an interim standard used during
+the early days of HDTV (1988-1998).  It has been superseded by Rec. 709.
+The default transfer function is <constant>V4L2_XFER_FUNC_SMPTE240M</constant>.
+The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_SMPTE240M</constant>.
 The default Y'CbCr quantization is limited range. The chromaticities of the primary colors and the
 white reference are:</para>
       <table frame="none">
@@ -1168,8 +1232,10 @@ clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range
     <section id="col-sysm">
       <title>Colorspace NTSC 1953 (<constant>V4L2_COLORSPACE_470_SYSTEM_M</constant>)</title>
       <para>This standard defines the colorspace used by NTSC in 1953. In practice this
-colorspace is obsolete and SMPTE 170M should be used instead. The default Y'CbCr encoding
-is <constant>V4L2_YCBCR_ENC_601</constant>. The default Y'CbCr quantization is limited range.
+colorspace is obsolete and SMPTE 170M should be used instead.
+The default transfer function is <constant>V4L2_XFER_FUNC_709</constant>.
+The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_601</constant>.
+The default Y'CbCr quantization is limited range.
 The chromaticities of the primary colors and the white reference are:</para>
       <table frame="none">
         <title>NTSC 1953 Chromaticities</title>
@@ -1246,8 +1312,10 @@ This transform is identical to one defined in SMPTE 170M/BT.601.</para>
     <section id="col-sysbg">
       <title>Colorspace EBU Tech. 3213 (<constant>V4L2_COLORSPACE_470_SYSTEM_BG</constant>)</title>
       <para>The <xref linkend="tech3213" /> standard defines the colorspace used by PAL/SECAM in 1975. In practice this
-colorspace is obsolete and SMPTE 170M should be used instead. The default Y'CbCr encoding
-is <constant>V4L2_YCBCR_ENC_601</constant>. The default Y'CbCr quantization is limited range.
+colorspace is obsolete and SMPTE 170M should be used instead.
+The default transfer function is <constant>V4L2_XFER_FUNC_709</constant>.
+The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_601</constant>.
+The default Y'CbCr quantization is limited range.
 The chromaticities of the primary colors and the white reference are:</para>
       <table frame="none">
         <title>EBU Tech. 3213 Chromaticities</title>
@@ -1320,7 +1388,8 @@ This transform is identical to one defined in SMPTE 170M/BT.601.</para>
     <section id="col-jpeg">
       <title>Colorspace JPEG (<constant>V4L2_COLORSPACE_JPEG</constant>)</title>
       <para>This colorspace defines the colorspace used by most (Motion-)JPEG formats. The chromaticities
-of the primary colors and the white reference are identical to sRGB. The Y'CbCr encoding is
+of the primary colors and the white reference are identical to sRGB. The transfer
+function use is <constant>V4L2_XFER_FUNC_SRGB</constant>. The Y'CbCr encoding is
 <constant>V4L2_YCBCR_ENC_601</constant> with full range quantization where
 Y' is scaled to [0&hellip;255] and Cb/Cr are scaled to [-128&hellip;128] and
 then clipped to [-128&hellip;127].</para>
diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 2588ad7..4e73345 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -50,8 +50,16 @@ capture streams and by the application for output streams,
 see <xref linkend="colorspaces" />.</entry>
 	</row>
 	<row>
-	  <entry>__u32</entry>
-	  <entry><structfield>reserved</structfield>[6]</entry>
+	  <entry>&v4l2-xfer-func;</entry>
+	  <entry><structfield>xfer_func</structfield></entry>
+	  <entry>This information supplements the
+<structfield>colorspace</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
+see <xref linkend="colorspaces" />.</entry>
+	</row>
+	<row>
+	  <entry>__u16</entry>
+	  <entry><structfield>reserved</structfield>[11]</entry>
 	  <entry>Reserved for future extensions. Applications and drivers must
 	  set the array to zero.</entry>
 	</row>
-- 
2.1.4

