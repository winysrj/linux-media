Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44856 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbcGDLrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 24/51] Documentation: crop.rst: fix conversion on this file
Date: Mon,  4 Jul 2016 08:46:45 -0300
Message-Id: <f37d11afd5bc1c1a84247a775e015929c8f67c8c.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion on this file didn't end too well. fix the found
issues:

1) Sphinix seems to not allow things like *foo :ref:`bar`*. At least
on this document, it did the wrong thing. So, change the logic to
something that will work fine with ReST format;

2) Some ioctl pointers were not looking nice;

3) the captions on the examples got discarded;

4) The notes specific to each example were not converted well.
Again, we'll need to replace it for a simpler design, as Sphinx
is a way more limited than DocBook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/crop.rst | 115 +++++++++++++++---------------
 1 file changed, 59 insertions(+), 56 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/crop.rst b/Documentation/linux_tv/media/v4l/crop.rst
index bfb30568df23..e1214d85b9c7 100644
--- a/Documentation/linux_tv/media/v4l/crop.rst
+++ b/Documentation/linux_tv/media/v4l/crop.rst
@@ -13,11 +13,11 @@ image up or down and insert it at an arbitrary scan line and horizontal
 offset into a video signal.
 
 Applications can use the following API to select an area in the video
-signal, query the default area and the hardware limits. *Despite their
-name, the :ref:`VIDIOC_CROPCAP`,
-:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
-:ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctls apply to input as well
-as output devices.*
+signal, query the default area and the hardware limits.
+
+**NOTE**: Despite their name, the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>`,
+:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and :ref:`VIDIOC_S_CROP
+<VIDIOC_G_CROP>` ioctls apply to input as well as output devices.
 
 Scaling requires a source and a target. On a video capture or overlay
 device the source is the video signal, and the cropping ioctls determine
@@ -28,15 +28,19 @@ and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls.
 
 On a video output device the source are the images passed in by the
 application, and their size is again negotiated with the
-``VIDIOC_G/S_FMT`` ioctls, or may be encoded in a compressed video
-stream. The target is the video signal, and the cropping ioctls
-determine the area where the images are inserted.
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
+ioctls, or may be encoded in a compressed video stream. The target is
+the video signal, and the cropping ioctls determine the area where the
+images are inserted.
 
 Source and target rectangles are defined even if the device does not
-support scaling or the ``VIDIOC_G/S_CROP`` ioctls. Their size (and
-position where applicable) will be fixed in this case. *All capture and
-output device must support the ``VIDIOC_CROPCAP`` ioctl such that
-applications can determine if scaling takes place.*
+support scaling or the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
+:ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctls. Their size (and position
+where applicable) will be fixed in this case.
+
+**NOTE:** All capture and output devices must support the
+:ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl such that applications can
+determine if scaling takes place.
 
 
 Cropping Structures
@@ -57,23 +61,24 @@ Cropping Structures
 
 For capture devices the coordinates of the top left corner, width and
 height of the area which can be sampled is given by the ``bounds``
-substructure of the struct :ref:`v4l2_cropcap <v4l2-cropcap>`
-returned by the ``VIDIOC_CROPCAP`` ioctl. To support a wide range of
-hardware this specification does not define an origin or units. However
-by convention drivers should horizontally count unscaled samples
+substructure of the struct :ref:`v4l2_cropcap <v4l2-cropcap>` returned
+by the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl. To support a wide
+range of hardware this specification does not define an origin or units.
+However by convention drivers should horizontally count unscaled samples
 relative to 0H (the leading edge of the horizontal sync pulse, see
 :ref:`vbi-hsync`). Vertically ITU-R line numbers of the first field
-(:ref:`vbi-525`, :ref:`vbi-625`), multiplied by two if the driver
+(see ITU R-525 line numbering for :ref:`525 lines <vbi-525>` and for
+:ref:`625 lines <vbi-625>`), multiplied by two if the driver
 can capture both fields.
 
 The top left corner, width and height of the source rectangle, that is
 the area actually sampled, is given by struct
 :ref:`v4l2_crop <v4l2-crop>` using the same coordinate system as
 struct :ref:`v4l2_cropcap <v4l2-cropcap>`. Applications can use the
-``VIDIOC_G_CROP`` and ``VIDIOC_S_CROP`` ioctls to get and set this
-rectangle. It must lie completely within the capture boundaries and the
-driver may further adjust the requested size and/or position according
-to hardware limitations.
+:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>`
+ioctls to get and set this rectangle. It must lie completely within the
+capture boundaries and the driver may further adjust the requested size
+and/or position according to hardware limitations.
 
 Each capture device has a default source rectangle, given by the
 ``defrect`` substructure of struct
@@ -121,8 +126,8 @@ The driver sets the image size to the closest possible values 304 × 224,
 then chooses the cropping rectangle closest to the requested size, that
 is 608 × 224 (224 × 2:1 would exceed the limit 400). The offset 0, 0 is
 still valid, thus unmodified. Given the default cropping rectangle
-reported by ``VIDIOC_CROPCAP`` the application can easily propose
-another offset to center the cropping rectangle.
+reported by :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` the application can
+easily propose another offset to center the cropping rectangle.
 
 Now the application may insist on covering an area using a picture
 aspect ratio closer to the original request, so it asks for a cropping
@@ -139,11 +144,11 @@ reopening a device, such that piping data into or out of a device will
 work without special preparations. More advanced applications should
 ensure the parameters are suitable before starting I/O.
 
-(A video capture device is assumed; change
-``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other devices.)
-
+**NOTE:** on the next two examples, a video capture device is assumed;
+change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
 
 .. code-block:: c
+    :caption: Example 11: Resetting the cropping parameters
 
     struct v4l2_cropcap cropcap;
     struct v4l2_crop crop;
@@ -152,8 +157,8 @@ ensure the parameters are suitable before starting I/O.
     cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
     if (-1 == ioctl (fd, VIDIOC_CROPCAP, &cropcap)) {
-        perror ("VIDIOC_CROPCAP");
-        exit (EXIT_FAILURE);
+	perror ("VIDIOC_CROPCAP");
+	exit (EXIT_FAILURE);
     }
 
     memset (&crop, 0, sizeof (crop));
@@ -163,15 +168,13 @@ ensure the parameters are suitable before starting I/O.
     /* Ignore if cropping is not supported (EINVAL). */
 
     if (-1 == ioctl (fd, VIDIOC_S_CROP, &crop)
-        && errno != EINVAL) {
-        perror ("VIDIOC_S_CROP");
-        exit (EXIT_FAILURE);
+	&& errno != EINVAL) {
+	perror ("VIDIOC_S_CROP");
+	exit (EXIT_FAILURE);
     }
 
-(A video capture device is assumed.)
-
-
 .. code-block:: c
+    :caption: Example 12: Simple downscaling
 
     struct v4l2_cropcap cropcap;
     struct v4l2_format format;
@@ -189,15 +192,17 @@ ensure the parameters are suitable before starting I/O.
     format.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
 
     if (-1 == ioctl (fd, VIDIOC_S_FMT, &format)) {
-        perror ("VIDIOC_S_FORMAT");
-        exit (EXIT_FAILURE);
+	perror ("VIDIOC_S_FORMAT");
+	exit (EXIT_FAILURE);
     }
 
     /* We could check the actual image size now, the actual scaling factor
        or if the driver can scale at all. */
 
+**NOTE:** This example assumes an output device.
 
 .. code-block:: c
+    :caption: Example 13. Selecting an output area
 
     struct v4l2_cropcap cropcap;
     struct v4l2_crop crop;
@@ -206,8 +211,8 @@ ensure the parameters are suitable before starting I/O.
     cropcap.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 
     if (-1 == ioctl (fd, VIDIOC_CROPCAP;, &cropcap)) {
-        perror ("VIDIOC_CROPCAP");
-        exit (EXIT_FAILURE);
+	perror ("VIDIOC_CROPCAP");
+	exit (EXIT_FAILURE);
     }
 
     memset (&crop, 0, sizeof (crop));
@@ -226,15 +231,15 @@ ensure the parameters are suitable before starting I/O.
     /* Ignore if cropping is not supported (EINVAL). */
 
     if (-1 == ioctl (fd, VIDIOC_S_CROP, &crop)
-        && errno != EINVAL) {
-        perror ("VIDIOC_S_CROP");
-        exit (EXIT_FAILURE);
+	&& errno != EINVAL) {
+	perror ("VIDIOC_S_CROP");
+	exit (EXIT_FAILURE);
     }
 
-(A video capture device is assumed.)
-
+**NOTE:** This example assumes a video capture device.
 
 .. code-block:: c
+    :caption: Example 14: Current scaling factor and pixel aspect
 
     struct v4l2_cropcap cropcap;
     struct v4l2_crop crop;
@@ -247,29 +252,29 @@ ensure the parameters are suitable before starting I/O.
     cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
     if (-1 == ioctl (fd, VIDIOC_CROPCAP, &cropcap)) {
-        perror ("VIDIOC_CROPCAP");
-        exit (EXIT_FAILURE);
+	perror ("VIDIOC_CROPCAP");
+	exit (EXIT_FAILURE);
     }
 
     memset (&crop, 0, sizeof (crop));
     crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
     if (-1 == ioctl (fd, VIDIOC_G_CROP, &crop)) {
-        if (errno != EINVAL) {
-            perror ("VIDIOC_G_CROP");
-            exit (EXIT_FAILURE);
-        }
+	if (errno != EINVAL) {
+	    perror ("VIDIOC_G_CROP");
+	    exit (EXIT_FAILURE);
+	}
 
-        /* Cropping not supported. */
-        crop.c = cropcap.defrect;
+	/* Cropping not supported. */
+	crop.c = cropcap.defrect;
     }
 
     memset (&format, 0, sizeof (format));
     format.fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
     if (-1 == ioctl (fd, VIDIOC_G_FMT, &format)) {
-        perror ("VIDIOC_G_FMT");
-        exit (EXIT_FAILURE);
+	perror ("VIDIOC_G_FMT");
+	exit (EXIT_FAILURE);
     }
 
     /* The scaling applied by the driver. */
@@ -278,7 +283,7 @@ ensure the parameters are suitable before starting I/O.
     vscale = format.fmt.pix.height / (double) crop.c.height;
 
     aspect = cropcap.pixelaspect.numerator /
-         (double) cropcap.pixelaspect.denominator;
+	 (double) cropcap.pixelaspect.denominator;
     aspect = aspect * hscale / vscale;
 
     /* Devices following ITU-R BT.601 do not capture
@@ -289,8 +294,6 @@ ensure the parameters are suitable before starting I/O.
     dheight = format.fmt.pix.height;
 
 
-
-
 .. ------------------------------------------------------------------------------
 .. This file was automatically converted from DocBook-XML with the dbxml
 .. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-- 
2.7.4


