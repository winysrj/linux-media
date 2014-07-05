Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:49631 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbaGEIbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jul 2014 04:31:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] DocBook media: fix wrong spacing
Date: Sat,  5 Jul 2014 10:31:03 +0200
Message-Id: <1404549065-25042-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There shouldn't be any spaces after <constant> or before </constant>.
This leads to ugly results like: 'image size set by VIDIOC_S_FMT .'

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/selection-api.xml  | 95 +++++++++++-----------
 .../DocBook/media/v4l/vidioc-g-selection.xml       | 40 +++++----
 2 files changed, 66 insertions(+), 69 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index 4c238ce..28cbded 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -86,47 +86,47 @@ selection targets available for a video capture device.  It is recommended to
 configure the cropping targets before to the composing targets.</para>
 
 <para>The range of coordinates of the top left corner, width and height of
-areas that can be sampled is given by the <constant> V4L2_SEL_TGT_CROP_BOUNDS
-</constant> target. It is recommended for the driver developers to put the
-top/left corner at position <constant> (0,0) </constant>.  The rectangle's
+areas that can be sampled is given by the <constant>V4L2_SEL_TGT_CROP_BOUNDS</constant>
+target. It is recommended for the driver developers to put the
+top/left corner at position <constant>(0,0)</constant>.  The rectangle's
 coordinates are expressed in pixels.</para>
 
 <para>The top left corner, width and height of the source rectangle, that is
-the area actually sampled, is given by the <constant> V4L2_SEL_TGT_CROP
-</constant> target. It uses the same coordinate system as <constant>
-V4L2_SEL_TGT_CROP_BOUNDS </constant>. The active cropping area must lie
-completely inside the capture boundaries. The driver may further adjust the
-requested size and/or position according to hardware limitations.</para>
+the area actually sampled, is given by the <constant>V4L2_SEL_TGT_CROP</constant>
+target. It uses the same coordinate system as <constant>V4L2_SEL_TGT_CROP_BOUNDS</constant>.
+The active cropping area must lie completely inside the capture boundaries. The
+driver may further adjust the requested size and/or position according to hardware
+limitations.</para>
 
 <para>Each capture device has a default source rectangle, given by the
-<constant> V4L2_SEL_TGT_CROP_DEFAULT </constant> target. This rectangle shall
+<constant>V4L2_SEL_TGT_CROP_DEFAULT</constant> target. This rectangle shall
 over what the driver writer considers the complete picture.  Drivers shall set
 the active crop rectangle to the default when the driver is first loaded, but
 not later.</para>
 
 <para>The composing targets refer to a memory buffer. The limits of composing
-coordinates are obtained using <constant> V4L2_SEL_TGT_COMPOSE_BOUNDS
-</constant>.  All coordinates are expressed in pixels. The rectangle's top/left
-corner must be located at position <constant> (0,0) </constant>. The width and
-height are equal to the image size set by <constant> VIDIOC_S_FMT </constant>.
+coordinates are obtained using <constant>V4L2_SEL_TGT_COMPOSE_BOUNDS</constant>.
+All coordinates are expressed in pixels. The rectangle's top/left
+corner must be located at position <constant>(0,0)</constant>. The width and
+height are equal to the image size set by <constant>VIDIOC_S_FMT</constant>.
 </para>
 
 <para>The part of a buffer into which the image is inserted by the hardware is
-controlled by the <constant> V4L2_SEL_TGT_COMPOSE </constant> target.
+controlled by the <constant>V4L2_SEL_TGT_COMPOSE</constant> target.
 The rectangle's coordinates are also expressed in the same coordinate system as
 the bounds rectangle. The composing rectangle must lie completely inside bounds
 rectangle. The driver must adjust the composing rectangle to fit to the
 bounding limits. Moreover, the driver can perform other adjustments according
 to hardware limitations. The application can control rounding behaviour using
-<link linkend="v4l2-selection-flags"> constraint flags </link>.</para>
+<link linkend="v4l2-selection-flags"> constraint flags</link>.</para>
 
 <para>For capture devices the default composing rectangle is queried using
-<constant> V4L2_SEL_TGT_COMPOSE_DEFAULT </constant>. It is usually equal to the
+<constant>V4L2_SEL_TGT_COMPOSE_DEFAULT</constant>. It is usually equal to the
 bounding rectangle.</para>
 
 <para>The part of a buffer that is modified by the hardware is given by
-<constant> V4L2_SEL_TGT_COMPOSE_PADDED </constant>. It contains all pixels
-defined using <constant> V4L2_SEL_TGT_COMPOSE </constant> plus all
+<constant>V4L2_SEL_TGT_COMPOSE_PADDED</constant>. It contains all pixels
+defined using <constant>V4L2_SEL_TGT_COMPOSE</constant> plus all
 padding data modified by hardware during insertion process. All pixels outside
 this rectangle <emphasis>must not</emphasis> be changed by the hardware. The
 content of pixels that lie inside the padded area but outside active area is
@@ -140,52 +140,51 @@ where the rubbish pixels are located and remove them if needed.</para>
    <title>Configuration of video output</title>
 
 <para>For output devices targets and ioctls are used similarly to the video
-capture case. The <emphasis> composing </emphasis> rectangle refers to the
+capture case. The <emphasis>composing</emphasis> rectangle refers to the
 insertion of an image into a video signal. The cropping rectangles refer to a
 memory buffer. It is recommended to configure the composing targets before to
 the cropping targets.</para>
 
 <para>The cropping targets refer to the memory buffer that contains an image to
 be inserted into a video signal or graphical screen. The limits of cropping
-coordinates are obtained using <constant> V4L2_SEL_TGT_CROP_BOUNDS </constant>.
+coordinates are obtained using <constant>V4L2_SEL_TGT_CROP_BOUNDS</constant>.
 All coordinates are expressed in pixels. The top/left corner is always point
-<constant> (0,0) </constant>.  The width and height is equal to the image size
-specified using <constant> VIDIOC_S_FMT </constant> ioctl.</para>
+<constant>(0,0)</constant>.  The width and height is equal to the image size
+specified using <constant>VIDIOC_S_FMT</constant> ioctl.</para>
 
 <para>The top left corner, width and height of the source rectangle, that is
 the area from which image date are processed by the hardware, is given by the
-<constant> V4L2_SEL_TGT_CROP </constant>. Its coordinates are expressed
+<constant>V4L2_SEL_TGT_CROP</constant>. Its coordinates are expressed
 in in the same coordinate system as the bounds rectangle. The active cropping
 area must lie completely inside the crop boundaries and the driver may further
 adjust the requested size and/or position according to hardware
 limitations.</para>
 
 <para>For output devices the default cropping rectangle is queried using
-<constant> V4L2_SEL_TGT_CROP_DEFAULT </constant>. It is usually equal to the
+<constant>V4L2_SEL_TGT_CROP_DEFAULT</constant>. It is usually equal to the
 bounding rectangle.</para>
 
 <para>The part of a video signal or graphics display where the image is
-inserted by the hardware is controlled by <constant>
-V4L2_SEL_TGT_COMPOSE </constant> target.  The rectangle's coordinates
-are expressed in pixels. The composing rectangle must lie completely inside the
-bounds rectangle.  The driver must adjust the area to fit to the bounding
-limits.  Moreover, the driver can perform other adjustments according to
-hardware limitations. </para>
-
-<para>The device has a default composing rectangle, given by the <constant>
-V4L2_SEL_TGT_COMPOSE_DEFAULT </constant> target. This rectangle shall cover what
+inserted by the hardware is controlled by <constant>V4L2_SEL_TGT_COMPOSE</constant>
+target.  The rectangle's coordinates are expressed in pixels. The composing
+rectangle must lie completely inside the bounds rectangle.  The driver must
+adjust the area to fit to the bounding limits.  Moreover, the driver can
+perform other adjustments according to hardware limitations.</para>
+
+<para>The device has a default composing rectangle, given by the
+<constant>V4L2_SEL_TGT_COMPOSE_DEFAULT</constant> target. This rectangle shall cover what
 the driver writer considers the complete picture. It is recommended for the
-driver developers to put the top/left corner at position <constant> (0,0)
-</constant>. Drivers shall set the active composing rectangle to the default
+driver developers to put the top/left corner at position <constant>(0,0)</constant>.
+Drivers shall set the active composing rectangle to the default
 one when the driver is first loaded.</para>
 
 <para>The devices may introduce additional content to video signal other than
 an image from memory buffers.  It includes borders around an image. However,
 such a padded area is driver-dependent feature not covered by this document.
 Driver developers are encouraged to keep padded rectangle equal to active one.
-The padded target is accessed by the <constant> V4L2_SEL_TGT_COMPOSE_PADDED
-</constant> identifier.  It must contain all pixels from the <constant>
-V4L2_SEL_TGT_COMPOSE </constant> target.</para>
+The padded target is accessed by the <constant>V4L2_SEL_TGT_COMPOSE_PADDED</constant>
+identifier.  It must contain all pixels from the <constant>V4L2_SEL_TGT_COMPOSE</constant>
+target.</para>
 
    </section>
 
@@ -194,8 +193,8 @@ V4L2_SEL_TGT_COMPOSE </constant> target.</para>
      <title>Scaling control</title>
 
 <para>An application can detect if scaling is performed by comparing the width
-and the height of rectangles obtained using <constant> V4L2_SEL_TGT_CROP
-</constant> and <constant> V4L2_SEL_TGT_COMPOSE </constant> targets. If
+and the height of rectangles obtained using <constant>V4L2_SEL_TGT_CROP</constant>
+and <constant>V4L2_SEL_TGT_COMPOSE</constant> targets. If
 these are not equal then the scaling is applied. The application can compute
 the scaling ratios using these values.</para>
 
@@ -208,7 +207,7 @@ the scaling ratios using these values.</para>
     <title>Comparison with old cropping API</title>
 
 <para>The selection API was introduced to cope with deficiencies of previous
-<link linkend="crop"> API </link>, that was designed to control simple capture
+<link linkend="crop"> API</link>, that was designed to control simple capture
 devices. Later the cropping API was adopted by video output drivers. The ioctls
 are used to select a part of the display were the video signal is inserted. It
 should be considered as an API abuse because the described operation is
@@ -220,7 +219,7 @@ part of an image by abusing V4L2 API.  Cropping a smaller image from a larger
 one is achieved by setting the field
 &v4l2-pix-format;<structfield>::bytesperline</structfield>.  Introducing an image offsets
 could be done by modifying field &v4l2-buffer;<structfield>::m_userptr</structfield>
-before calling <constant> VIDIOC_QBUF </constant>. Those
+before calling <constant>VIDIOC_QBUF</constant>. Those
 operations should be avoided because they are not portable (endianness), and do
 not work for macroblock and Bayer formats and mmap buffers.  The selection API
 deals with configuration of buffer cropping/composing in a clear, intuitive and
@@ -229,7 +228,7 @@ and constraints flags are introduced.  Finally, &v4l2-crop; and &v4l2-cropcap;
 have no reserved fields. Therefore there is no way to extend their functionality.
 The new &v4l2-selection; provides a lot of place for future
 extensions.  Driver developers are encouraged to implement only selection API.
-The former cropping API would be simulated using the new one. </para>
+The former cropping API would be simulated using the new one.</para>
 
   </section>
 
@@ -238,9 +237,9 @@ The former cropping API would be simulated using the new one. </para>
       <example>
 	<title>Resetting the cropping parameters</title>
 
-	<para>(A video capture device is assumed; change <constant>
-V4L2_BUF_TYPE_VIDEO_CAPTURE </constant> for other devices; change target to
-<constant> V4L2_SEL_TGT_COMPOSE_* </constant> family to configure composing
+	<para>(A video capture device is assumed; change
+<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant> for other devices; change target to
+<constant>V4L2_SEL_TGT_COMPOSE_*</constant> family to configure composing
 area)</para>
 
 	<programlisting>
@@ -292,8 +291,8 @@ area)</para>
 
       <example>
 	<title>Querying for scaling factors</title>
-	<para>A video output device is assumed; change <constant>
-V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> for other devices</para>
+	<para>A video output device is assumed; change
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> for other devices</para>
 	<programlisting>
 
 	&v4l2-selection; compose = {
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index b11ec75..9c04ac8 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -58,17 +58,16 @@
 
     <para>The ioctls are used to query and configure selection rectangles.</para>
 
-<para> To query the cropping (composing) rectangle set &v4l2-selection;
+<para>To query the cropping (composing) rectangle set &v4l2-selection;
 <structfield> type </structfield> field to the respective buffer type.
-Do not use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
-</constant> instead of <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
-</constant>.  Use <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> instead of
-<constant> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE </constant>.  The next step is
+Do not use multiplanar buffers.  Use <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>
+instead of <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>.  Use
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> instead of
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant>.  The next step is
 setting the value of &v4l2-selection; <structfield>target</structfield> field
-to <constant> V4L2_SEL_TGT_CROP </constant> (<constant>
-V4L2_SEL_TGT_COMPOSE </constant>).  Please refer to table <xref
-linkend="v4l2-selections-common" /> or <xref linkend="selection-api" /> for additional
-targets.  The <structfield>flags</structfield> and <structfield>reserved
+to <constant>V4L2_SEL_TGT_CROP</constant> (<constant>V4L2_SEL_TGT_COMPOSE</constant>).
+Please refer to table <xref linkend="v4l2-selections-common" /> or <xref linkend="selection-api" />
+for additional targets.  The <structfield>flags</structfield> and <structfield>reserved
 </structfield> fields of &v4l2-selection; are ignored and they must be filled
 with zeros.  The driver fills the rest of the structure or
 returns &EINVAL; if incorrect buffer type or target was used. If cropping
@@ -77,19 +76,18 @@ always equal to the bounds rectangle.  Finally, the &v4l2-rect;
 <structfield>r</structfield> rectangle is filled with the current cropping
 (composing) coordinates. The coordinates are expressed in driver-dependent
 units. The only exception are rectangles for images in raw formats, whose
-coordinates are always expressed in pixels.  </para>
+coordinates are always expressed in pixels.</para>
 
-<para> To change the cropping (composing) rectangle set the &v4l2-selection;
+<para>To change the cropping (composing) rectangle set the &v4l2-selection;
 <structfield>type</structfield> field to the respective buffer type.  Do not
-use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
-</constant> instead of <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
-</constant>.  Use <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> instead of
-<constant> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE </constant>.  The next step is
+use multiplanar buffers.  Use <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>
+instead of <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>.  Use
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> instead of
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant>.  The next step is
 setting the value of &v4l2-selection; <structfield>target</structfield> to
-<constant>V4L2_SEL_TGT_CROP</constant> (<constant>
-V4L2_SEL_TGT_COMPOSE </constant>). Please refer to table <xref
-linkend="v4l2-selections-common" /> or <xref linkend="selection-api" /> for additional
-targets.  The &v4l2-rect; <structfield>r</structfield> rectangle need to be
+<constant>V4L2_SEL_TGT_CROP</constant> (<constant>V4L2_SEL_TGT_COMPOSE</constant>).
+Please refer to table <xref linkend="v4l2-selections-common" /> or <xref linkend="selection-api" />
+for additional targets.  The &v4l2-rect; <structfield>r</structfield> rectangle need to be
 set to the desired active area. Field &v4l2-selection; <structfield> reserved
 </structfield> is ignored and must be filled with zeros.  The driver may adjust
 coordinates of the requested rectangle. An application may
@@ -149,8 +147,8 @@ On success the &v4l2-rect; <structfield>r</structfield> field contains
 the adjusted rectangle. When the parameters are unsuitable the application may
 modify the cropping (composing) or image parameters and repeat the cycle until
 satisfactory parameters have been negotiated. If constraints flags have to be
-violated at then ERANGE is returned. The error indicates that <emphasis> there
-exist no rectangle </emphasis> that satisfies the constraints.</para>
+violated at then ERANGE is returned. The error indicates that <emphasis>there
+exist no rectangle</emphasis> that satisfies the constraints.</para>
 
   <para>Selection targets and flags are documented in <xref
   linkend="v4l2-selections-common"/>.</para>
-- 
2.0.0

