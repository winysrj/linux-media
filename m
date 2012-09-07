Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2681 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2IGN3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 15/28] DocBook: Mark CROPCAP as optional instead of as compulsory.
Date: Fri,  7 Sep 2012 15:29:15 +0200
Message-Id: <a24d3d2fd37d687a6dd5d909e6e5e3606edaf5ea.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While the documentation says that VIDIOC_CROPCAP is compulsory for
all video capture and output devices, in practice VIDIOC_CROPCAP is
only implemented for devices that can do cropping and/or scaling.

Update the documentation to no longer require VIDIOC_CROPCAP if the
driver does not support cropping or scaling or non-square pixels.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/common.xml         |  145 +++++++++-----------
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml |   10 +-
 2 files changed, 75 insertions(+), 80 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index 9378d7b..454258b 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -628,7 +628,7 @@ are available for the device.</para>
 if (-1 == ioctl (fd, &VIDIOC-G-STD;, &amp;std_id)) {
 	/* Note when VIDIOC_ENUMSTD always returns EINVAL this
 	   is no video device or it falls under the USB exception,
-	   and VIDIOC_G_STD returning EINVAL is no error. */
+	   and VIDIOC_G_STD returning ENOTTY is no error. */
 
 	perror ("VIDIOC_G_STD");
 	exit (EXIT_FAILURE);
@@ -905,9 +905,9 @@ inserted.</para>
     <para>Source and target rectangles are defined even if the device
 does not support scaling or the <constant>VIDIOC_G/S_CROP</constant>
 ioctls. Their size (and position where applicable) will be fixed in
-this case. <emphasis>All capture and output device must support the
-<constant>VIDIOC_CROPCAP</constant> ioctl such that applications can
-determine if scaling takes place.</emphasis></para>
+this case. <emphasis>All capture and output device that support cropping
+and/or scaling and/or have non-square pixels must support the <constant>VIDIOC_CROPCAP</constant>
+ioctl such that applications can determine if scaling takes place.</emphasis></para>
 
     <section>
       <title>Cropping Structures</title>
@@ -1032,24 +1032,21 @@ devices.)</para>
 &v4l2-cropcap; cropcap;
 &v4l2-crop; crop;
 
-memset (&amp;cropcap, 0, sizeof (cropcap));
+memset(&amp;cropcap, 0, sizeof(cropcap));
 cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-if (-1 == ioctl (fd, &VIDIOC-CROPCAP;, &amp;cropcap)) {
-	perror ("VIDIOC_CROPCAP");
-	exit (EXIT_FAILURE);
-}
-
-memset (&amp;crop, 0, sizeof (crop));
-crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-crop.c = cropcap.defrect;
+if (0 == ioctl(fd, &VIDIOC-CROPCAP;, &amp;cropcap)) {
+	memset(&amp;crop, 0, sizeof(crop));
+	crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	crop.c = cropcap.defrect;
 
-/* Ignore if cropping is not supported (EINVAL). */
+	/* Ignore if cropping is not supported (ENOTTY). */
 
-if (-1 == ioctl (fd, &VIDIOC-S-CROP;, &amp;crop)
-    &amp;&amp; errno != EINVAL) {
-	perror ("VIDIOC_S_CROP");
-	exit (EXIT_FAILURE);
+	if (-1 == ioctl(fd, &VIDIOC-S-CROP;, &amp;crop)
+	    &amp;&amp; errno != ENOTTY) {
+		perror("VIDIOC_S_CROP");
+		exit(EXIT_FAILURE);
+	}
 }
       </programlisting>
       </example>
@@ -1063,11 +1060,11 @@ if (-1 == ioctl (fd, &VIDIOC-S-CROP;, &amp;crop)
 &v4l2-cropcap; cropcap;
 &v4l2-format; format;
 
-reset_cropping_parameters ();
+reset_cropping_parameters();
 
 /* Scale down to 1/4 size of full picture. */
 
-memset (&amp;format, 0, sizeof (format)); /* defaults */
+memset(&amp;format, 0, sizeof(format)); /* defaults */
 
 format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
@@ -1075,9 +1072,9 @@ format.fmt.pix.width = cropcap.defrect.width &gt;&gt; 1;
 format.fmt.pix.height = cropcap.defrect.height &gt;&gt; 1;
 format.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
 
-if (-1 == ioctl (fd, &VIDIOC-S-FMT;, &amp;format)) {
-	perror ("VIDIOC_S_FORMAT");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-S-FMT;, &amp;format)) {
+	perror("VIDIOC_S_FORMAT");
+	exit(EXIT_FAILURE);
 }
 
 /* We could check the actual image size now, the actual scaling factor
@@ -1092,33 +1089,30 @@ if (-1 == ioctl (fd, &VIDIOC-S-FMT;, &amp;format)) {
 &v4l2-cropcap; cropcap;
 &v4l2-crop; crop;
 
-memset (&amp;cropcap, 0, sizeof (cropcap));
+memset(&amp;cropcap, 0, sizeof (cropcap));
 cropcap.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 
-if (-1 == ioctl (fd, VIDIOC_CROPCAP;, &amp;cropcap)) {
-	perror ("VIDIOC_CROPCAP");
-	exit (EXIT_FAILURE);
-}
-
-memset (&amp;crop, 0, sizeof (crop));
+if (0 == ioctl(fd, &VIDIOC-CROPCAP;, &amp;cropcap)) {
+	memset(&amp;crop, 0, sizeof (crop));
 
-crop.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-crop.c = cropcap.defrect;
+	crop.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	crop.c = cropcap.defrect;
 
-/* Scale the width and height to 50 % of their original size
-   and center the output. */
+	/* Scale the width and height to 50 % of their original size
+	   and center the output. */
 
-crop.c.width /= 2;
-crop.c.height /= 2;
-crop.c.left += crop.c.width / 2;
-crop.c.top += crop.c.height / 2;
+	crop.c.width /= 2;
+	crop.c.height /= 2;
+	crop.c.left += crop.c.width / 2;
+	crop.c.top += crop.c.height / 2;
 
-/* Ignore if cropping is not supported (EINVAL). */
+	/* Ignore if cropping is not supported (ENOTTY). */
 
-if (-1 == ioctl (fd, VIDIOC_S_CROP, &amp;crop)
-    &amp;&amp; errno != EINVAL) {
-	perror ("VIDIOC_S_CROP");
-	exit (EXIT_FAILURE);
+	if (-1 == ioctl(fd, VIDIOC_S_CROP, &amp;crop)
+	    &amp;&amp; errno != ENOTTY) {
+		perror("VIDIOC_S_CROP");
+		exit(EXIT_FAILURE);
+	}
 }
 </programlisting>
       </example>
@@ -1136,50 +1130,47 @@ double hscale, vscale;
 double aspect;
 int dwidth, dheight;
 
-memset (&amp;cropcap, 0, sizeof (cropcap));
-cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+memset(&amp;format, 0, sizeof(format));
+format.fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-if (-1 == ioctl (fd, &VIDIOC-CROPCAP;, &amp;cropcap)) {
-	perror ("VIDIOC_CROPCAP");
-	exit (EXIT_FAILURE);
+if (-1 == ioctl(fd, &VIDIOC-G-FMT;, &amp;format)) {
+	perror("VIDIOC_G_FMT");
+	exit(EXIT_FAILURE);
 }
 
-memset (&amp;crop, 0, sizeof (crop));
-crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+memset(&amp;cropcap, 0, sizeof (cropcap));
+cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-if (-1 == ioctl (fd, &VIDIOC-G-CROP;, &amp;crop)) {
-	if (errno != EINVAL) {
-		perror ("VIDIOC_G_CROP");
-		exit (EXIT_FAILURE);
-	}
+if (0 == ioctl(fd, &VIDIOC-CROPCAP;, &amp;cropcap)) {
+	memset(&amp;crop, 0, sizeof(crop));
+	crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-	/* Cropping not supported. */
-	crop.c = cropcap.defrect;
-}
+	if (-1 == ioctl(fd, &VIDIOC-G-CROP;, &amp;crop)) {
+		if (errno != ENOTTY) {
+			perror("VIDIOC_G_CROP");
+			exit(EXIT_FAILURE);
+		}
 
-memset (&amp;format, 0, sizeof (format));
-format.fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-if (-1 == ioctl (fd, &VIDIOC-G-FMT;, &amp;format)) {
-	perror ("VIDIOC_G_FMT");
-	exit (EXIT_FAILURE);
-}
+		/* Cropping not supported. */
+		crop.c = cropcap.defrect;
+	}
 
-/* The scaling applied by the driver. */
+	/* The scaling applied by the driver. */
 
-hscale = format.fmt.pix.width / (double) crop.c.width;
-vscale = format.fmt.pix.height / (double) crop.c.height;
+	hscale = format.fmt.pix.width / (double)crop.c.width;
+	vscale = format.fmt.pix.height / (double)crop.c.height;
 
-aspect = cropcap.pixelaspect.numerator /
-	 (double) cropcap.pixelaspect.denominator;
-aspect = aspect * hscale / vscale;
+	aspect = cropcap.pixelaspect.numerator /
+		 (double)cropcap.pixelaspect.denominator;
+	aspect = aspect * hscale / vscale;
 
-/* Devices following ITU-R BT.601 do not capture
-   square pixels. For playback on a computer monitor
-   we should scale the images to this size. */
+	/* Devices following ITU-R BT.601 do not capture
+	   square pixels. For playback on a computer monitor
+	   we should scale the images to this size. */
 
-dwidth = format.fmt.pix.width / aspect;
-dheight = format.fmt.pix.height;
+	dwidth = format.fmt.pix.width / aspect;
+	dheight = format.fmt.pix.height;
+}
 	</programlisting>
       </example>
     </section>
@@ -1212,5 +1203,5 @@ a pointer to a &v4l2-streamparm;, which contains a union holding
 separate parameters for input and output devices.</para>
 
     <para>These ioctls are optional, drivers need not implement
-them. If so, they return the &EINVAL;.</para>
+them. If so, they return the &ENOTTY;.</para>
   </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
index 4559c45..bf7cc97 100644
--- a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
@@ -59,6 +59,9 @@ constant except when switching the video standard. Remember this
 switch can occur implicit when switching the video input or
 output.</para>
 
+    <para>This ioctl must be implemented for video capture or output devices that
+support cropping and/or scaling and/or have non-square pixels, and for overlay devices.</para>
+
     <table pgwide="1" frame="none" id="v4l2-cropcap">
       <title>struct <structname>v4l2_cropcap</structname></title>
       <tgroup cols="3">
@@ -70,7 +73,9 @@ output.</para>
 	    <entry>Type of the data stream, set by the application.
 Only these types are valid here:
 <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> and
+<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>,
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>,
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant> and
 <constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>. See <xref linkend="v4l2-buf-type" />.</entry>
 	  </row>
 	  <row>
@@ -154,8 +159,7 @@ on 22 Oct 2002 subject "Re:[V4L][patches!] Re:v4l2/kernel-2.5" -->
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &v4l2-cropcap; <structfield>type</structfield> is
-invalid. This is not permitted for video capture, output and overlay devices,
-which must support <constant>VIDIOC_CROPCAP</constant>.</para>
+invalid.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
-- 
1.7.10.4

