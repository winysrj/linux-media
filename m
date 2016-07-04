Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbcGDLrY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 13/51] Documentation: linux_tv: convert lots of consts to references
Date: Mon,  4 Jul 2016 08:46:34 -0300
Message-Id: <2f5f2a250478faecfff538124b57cb0f5194f9da.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There were lots of consts at the media docbook that should
be, instead, references. Convert the ones that can easily
be done by an automatic script.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/dev-capture.rst     | 16 ++++++++--------
 Documentation/linux_tv/media/v4l/dev-osd.rst         |  4 ++--
 Documentation/linux_tv/media/v4l/dev-output.rst      | 16 ++++++++--------
 Documentation/linux_tv/media/v4l/dev-overlay.rst     | 12 ++++++------
 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst     | 10 +++++-----
 Documentation/linux_tv/media/v4l/format.rst          | 12 ++++++------
 Documentation/linux_tv/media/v4l/io.rst              |  2 +-
 .../linux_tv/media/v4l/selection-api-004.rst         |  4 ++--
 .../linux_tv/media/v4l/selection-api-005.rst         |  2 +-
 Documentation/linux_tv/media/v4l/standard.rst        |  4 ++--
 Documentation/linux_tv/media/v4l/tuner.rst           |  6 +++---
 .../linux_tv/media/v4l/vidioc-create-bufs.rst        |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-cropcap.rst  |  2 +-
 .../linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst    |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst |  2 +-
 .../linux_tv/media/v4l/vidioc-enum-freq-bands.rst    |  2 +-
 .../linux_tv/media/v4l/vidioc-enumaudio.rst          |  2 +-
 .../linux_tv/media/v4l/vidioc-enuminput.rst          |  2 +-
 .../linux_tv/media/v4l/vidioc-enumoutput.rst         |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-enumstd.rst  |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-expbuf.rst   |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-audio.rst  |  6 +++---
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst   | 10 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst   |  6 +++---
 .../linux_tv/media/v4l/vidioc-g-dv-timings.rst       |  6 +++---
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst   |  4 ++--
 .../linux_tv/media/v4l/vidioc-g-enc-index.rst        |  6 +++---
 .../linux_tv/media/v4l/vidioc-g-ext-ctrls.rst        | 20 ++++++++++----------
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst   | 16 ++++++++--------
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst    | 18 +++++++++---------
 .../linux_tv/media/v4l/vidioc-g-frequency.rst        |  6 +++---
 Documentation/linux_tv/media/v4l/vidioc-g-input.rst  |  4 ++--
 .../linux_tv/media/v4l/vidioc-g-modulator.rst        |  8 ++++----
 Documentation/linux_tv/media/v4l/vidioc-g-output.rst |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst   |  2 +-
 .../linux_tv/media/v4l/vidioc-g-priority.rst         |  4 ++--
 .../linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst   |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst    | 10 +++++-----
 Documentation/linux_tv/media/v4l/vidioc-overlay.rst  |  2 +-
 .../linux_tv/media/v4l/vidioc-prepare-buf.rst        |  4 ++--
 .../linux_tv/media/v4l/vidioc-query-dv-timings.rst   |  6 +++---
 Documentation/linux_tv/media/v4l/vidioc-querybuf.rst |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-querystd.rst |  6 +++---
 Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst  |  2 +-
 .../media/v4l/vidioc-subdev-enum-frame-interval.rst  |  2 +-
 .../media/v4l/vidioc-subdev-enum-frame-size.rst      |  2 +-
 .../media/v4l/vidioc-subdev-enum-mbus-code.rst       |  2 +-
 47 files changed, 138 insertions(+), 138 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/dev-capture.rst b/Documentation/linux_tv/media/v4l/dev-capture.rst
index eb5c1522905d..c970a1fd1439 100644
--- a/Documentation/linux_tv/media/v4l/dev-capture.rst
+++ b/Documentation/linux_tv/media/v4l/dev-capture.rst
@@ -75,23 +75,23 @@ To request different parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
 fields of the struct :ref:`v4l2_pix_format <v4l2-pix-format>`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
-of ``VIDIOC_G_FMT``, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
+of :ref:`VIDIOC_G_FMT`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers may adjust the
-parameters and finally return the actual parameters as ``VIDIOC_G_FMT``
+parameters and finally return the actual parameters as :ref:`VIDIOC_G_FMT`
 does.
 
-Like ``VIDIOC_S_FMT`` the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl
+Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl
 can be used to learn about hardware limitations without disabling I/O or
 possibly time consuming hardware preparations.
 
 The contents of struct :ref:`v4l2_pix_format <v4l2-pix-format>` and
 struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` are
 discussed in :ref:`pixfmt`. See also the specification of the
-``VIDIOC_G_FMT``, ``VIDIOC_S_FMT`` and ``VIDIOC_TRY_FMT`` ioctls for
-details. Video capture devices must implement both the ``VIDIOC_G_FMT``
-and ``VIDIOC_S_FMT`` ioctl, even if ``VIDIOC_S_FMT`` ignores all
-requests and always returns default parameters as ``VIDIOC_G_FMT`` does.
-``VIDIOC_TRY_FMT`` is optional.
+:ref:`VIDIOC_G_FMT`, :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctls for
+details. Video capture devices must implement both the :ref:`VIDIOC_G_FMT`
+and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, even if :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ignores all
+requests and always returns default parameters as :ref:`VIDIOC_G_FMT` does.
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` is optional.
 
 
 Reading Images
diff --git a/Documentation/linux_tv/media/v4l/dev-osd.rst b/Documentation/linux_tv/media/v4l/dev-osd.rst
index 27d2cfbf3d9c..4b668a3544b8 100644
--- a/Documentation/linux_tv/media/v4l/dev-osd.rst
+++ b/Documentation/linux_tv/media/v4l/dev-osd.rst
@@ -124,10 +124,10 @@ struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY``, initialize the ``win``
 substructure and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 The driver adjusts the parameters against hardware limits and returns
-the actual parameters as ``VIDIOC_G_FMT`` does. Like ``VIDIOC_S_FMT``,
+the actual parameters as :ref:`VIDIOC_G_FMT` does. Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`,
 the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to learn
 about driver capabilities without actually changing driver state. Unlike
-``VIDIOC_S_FMT`` this also works after the overlay has been enabled.
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` this also works after the overlay has been enabled.
 
 A struct :ref:`v4l2_crop <v4l2-crop>` defines the size and position
 of the target rectangle. The scaling factor of the overlay is implied by
diff --git a/Documentation/linux_tv/media/v4l/dev-output.rst b/Documentation/linux_tv/media/v4l/dev-output.rst
index 1ca0e5873a86..ee62d1a0fb87 100644
--- a/Documentation/linux_tv/media/v4l/dev-output.rst
+++ b/Documentation/linux_tv/media/v4l/dev-output.rst
@@ -72,23 +72,23 @@ To request different parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
 fields of the struct :ref:`v4l2_pix_format <v4l2-pix-format>`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
-of ``VIDIOC_G_FMT``, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
+of :ref:`VIDIOC_G_FMT`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers may adjust the
-parameters and finally return the actual parameters as ``VIDIOC_G_FMT``
+parameters and finally return the actual parameters as :ref:`VIDIOC_G_FMT`
 does.
 
-Like ``VIDIOC_S_FMT`` the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl
+Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl
 can be used to learn about hardware limitations without disabling I/O or
 possibly time consuming hardware preparations.
 
 The contents of struct :ref:`v4l2_pix_format <v4l2-pix-format>` and
 struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` are
 discussed in :ref:`pixfmt`. See also the specification of the
-``VIDIOC_G_FMT``, ``VIDIOC_S_FMT`` and ``VIDIOC_TRY_FMT`` ioctls for
-details. Video output devices must implement both the ``VIDIOC_G_FMT``
-and ``VIDIOC_S_FMT`` ioctl, even if ``VIDIOC_S_FMT`` ignores all
-requests and always returns default parameters as ``VIDIOC_G_FMT`` does.
-``VIDIOC_TRY_FMT`` is optional.
+:ref:`VIDIOC_G_FMT`, :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctls for
+details. Video output devices must implement both the :ref:`VIDIOC_G_FMT`
+and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, even if :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ignores all
+requests and always returns default parameters as :ref:`VIDIOC_G_FMT` does.
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` is optional.
 
 
 Writing Images
diff --git a/Documentation/linux_tv/media/v4l/dev-overlay.rst b/Documentation/linux_tv/media/v4l/dev-overlay.rst
index acbcfb4cbe57..26bd4a15a125 100644
--- a/Documentation/linux_tv/media/v4l/dev-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/dev-overlay.rst
@@ -65,7 +65,7 @@ frame buffer parameters, namely the address and size of the frame buffer
 and the image format, for example RGB 5:6:5. The
 :ref:`VIDIOC_G_FBUF` and
 :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctls are available to get and
-set these parameters, respectively. The ``VIDIOC_S_FBUF`` ioctl is
+set these parameters, respectively. The :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctl is
 privileged because it allows to set up DMA into physical memory,
 bypassing the memory protection mechanisms of the kernel. Only the
 superuser can change the frame buffer address and size. Users are not
@@ -76,8 +76,8 @@ system and program the V4L2 driver at the appropriate time.
 Some devices add the video overlay to the output signal of the graphics
 card. In this case the frame buffer is not modified by the video device,
 and the frame buffer address and pixel format are not needed by the
-driver. The ``VIDIOC_S_FBUF`` ioctl is not privileged. An application
-can check for this type of device by calling the ``VIDIOC_G_FBUF``
+driver. The :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctl is not privileged. An application
+can check for this type of device by calling the :ref:`VIDIOC_G_FBUF`
 ioctl.
 
 A driver may support any (or none) of five clipping/blending methods:
@@ -130,10 +130,10 @@ struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY``, initialize the ``win`` substructure and
 call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. The driver
 adjusts the parameters against hardware limits and returns the actual
-parameters as ``VIDIOC_G_FMT`` does. Like ``VIDIOC_S_FMT``, the
+parameters as :ref:`VIDIOC_G_FMT` does. Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`, the
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to learn
 about driver capabilities without actually changing driver state. Unlike
-``VIDIOC_S_FMT`` this also works after the overlay has been enabled.
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` this also works after the overlay has been enabled.
 
 The scaling factor of the overlaid image is implied by the width and
 height given in struct :ref:`v4l2_window <v4l2-window>` and the size
@@ -199,7 +199,7 @@ are undefined.
     When the application set the ``clips`` field, this field must
     contain the number of clipping rectangles in the list. When clip
     lists are not supported the driver ignores this field, its contents
-    after calling ``VIDIOC_S_FMT`` are undefined. When clip lists are
+    after calling :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` are undefined. When clip lists are
     supported but no clipping is desired this field must be set to zero.
 
 ``void * bitmap``
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
index ca61dde3ad38..2cd813a5b4e4 100644
--- a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
@@ -80,7 +80,7 @@ To request different parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
 fields of the struct :ref:`v4l2_vbi_format <v4l2-vbi-format>`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
-of ``VIDIOC_G_FMT``, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
+of :ref:`VIDIOC_G_FMT`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers return an EINVAL error
 code only when the given parameters are ambiguous, otherwise they modify
 the parameters according to the hardware capabilities and return the
@@ -94,10 +94,10 @@ expect other resource allocation points which may return EBUSY, at the
 :ref:`VIDIOC_STREAMON` ioctl and the first read(),
 write() and select() call.
 
-VBI devices must implement both the ``VIDIOC_G_FMT`` and
-``VIDIOC_S_FMT`` ioctl, even if ``VIDIOC_S_FMT`` ignores all requests
-and always returns default parameters as ``VIDIOC_G_FMT`` does.
-``VIDIOC_TRY_FMT`` is optional.
+VBI devices must implement both the :ref:`VIDIOC_G_FMT` and
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, even if :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ignores all requests
+and always returns default parameters as :ref:`VIDIOC_G_FMT` does.
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` is optional.
 
 
 .. _v4l2-vbi-format:
diff --git a/Documentation/linux_tv/media/v4l/format.rst b/Documentation/linux_tv/media/v4l/format.rst
index 46f740a0092e..0184b5931709 100644
--- a/Documentation/linux_tv/media/v4l/format.rst
+++ b/Documentation/linux_tv/media/v4l/format.rst
@@ -31,10 +31,10 @@ format. The data formats supported by the V4L2 API are covered in the
 respective device section in :ref:`devices`. For a closer look at
 image formats see :ref:`pixfmt`.
 
-The ``VIDIOC_S_FMT`` ioctl is a major turning-point in the
+The :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl is a major turning-point in the
 initialization sequence. Prior to this point multiple panel applications
 can access the same device concurrently to select the current input,
-change controls or modify other properties. The first ``VIDIOC_S_FMT``
+change controls or modify other properties. The first :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 assigns a logical stream (video data, VBI data etc.) exclusively to one
 file descriptor.
 
@@ -50,7 +50,7 @@ example video overlay is about to start or already in progress,
 simultaneous video capturing may be restricted to the same cropping and
 image size.
 
-When applications omit the ``VIDIOC_S_FMT`` ioctl its locking side
+When applications omit the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl its locking side
 effects are implied by the next step, the selection of an I/O method
 with the :ref:`VIDIOC_REQBUFS` ioctl or implicit
 with the first :ref:`read() <func-read>` or
@@ -61,11 +61,11 @@ the exception being drivers permitting simultaneous video capturing and
 overlay using the same file descriptor for compatibility with V4L and
 earlier versions of V4L2. Switching the logical stream or returning into
 "panel mode" is possible by closing and reopening the device. Drivers
-*may* support a switch using ``VIDIOC_S_FMT``.
+*may* support a switch using :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`.
 
 All drivers exchanging data with applications must support the
-``VIDIOC_G_FMT`` and ``VIDIOC_S_FMT`` ioctl. Implementation of the
-``VIDIOC_TRY_FMT`` is highly recommended but optional.
+:ref:`VIDIOC_G_FMT` and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. Implementation of the
+:ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` is highly recommended but optional.
 
 
 Image Format Enumeration
diff --git a/Documentation/linux_tv/media/v4l/io.rst b/Documentation/linux_tv/media/v4l/io.rst
index 651d4530c703..77d13fdd1c28 100644
--- a/Documentation/linux_tv/media/v4l/io.rst
+++ b/Documentation/linux_tv/media/v4l/io.rst
@@ -31,7 +31,7 @@ and drivers permitting simultaneous video capturing and overlay using
 the same file descriptor, for compatibility with V4L and earlier
 versions of V4L2.
 
-``VIDIOC_S_FMT`` and ``VIDIOC_REQBUFS`` would permit this to some
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_REQBUFS` would permit this to some
 degree, but for simplicity drivers need not support switching the I/O
 method (after first switching away from read/write) other than by
 closing and reopening the device.
diff --git a/Documentation/linux_tv/media/v4l/selection-api-004.rst b/Documentation/linux_tv/media/v4l/selection-api-004.rst
index 4890815e268e..1a8f4d09bff1 100644
--- a/Documentation/linux_tv/media/v4l/selection-api-004.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api-004.rst
@@ -50,7 +50,7 @@ The composing targets refer to a memory buffer. The limits of composing
 coordinates are obtained using ``V4L2_SEL_TGT_COMPOSE_BOUNDS``. All
 coordinates are expressed in pixels. The rectangle's top/left corner
 must be located at position ``(0,0)``. The width and height are equal to
-the image size set by ``VIDIOC_S_FMT``.
+the image size set by :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`.
 
 The part of a buffer into which the image is inserted by the hardware is
 controlled by the ``V4L2_SEL_TGT_COMPOSE`` target. The rectangle's
@@ -90,7 +90,7 @@ to be inserted into a video signal or graphical screen. The limits of
 cropping coordinates are obtained using ``V4L2_SEL_TGT_CROP_BOUNDS``.
 All coordinates are expressed in pixels. The top/left corner is always
 point ``(0,0)``. The width and height is equal to the image size
-specified using ``VIDIOC_S_FMT`` ioctl.
+specified using :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 
 The top left corner, width and height of the source rectangle, that is
 the area from which image date are processed by the hardware, is given
diff --git a/Documentation/linux_tv/media/v4l/selection-api-005.rst b/Documentation/linux_tv/media/v4l/selection-api-005.rst
index aefab87788db..6fdb0af2b13d 100644
--- a/Documentation/linux_tv/media/v4l/selection-api-005.rst
+++ b/Documentation/linux_tv/media/v4l/selection-api-005.rst
@@ -19,7 +19,7 @@ setting the field struct
 :ref:`v4l2_pix_format <v4l2-pix-format>```::bytesperline``.
 Introducing an image offsets could be done by modifying field struct
 :ref:`v4l2_buffer <v4l2-buffer>```::m_userptr`` before calling
-``VIDIOC_QBUF``. Those operations should be avoided because they are not
+:ref:`VIDIOC_QBUF`. Those operations should be avoided because they are not
 portable (endianness), and do not work for macroblock and Bayer formats
 and mmap buffers. The selection API deals with configuration of buffer
 cropping/composing in a clear, intuitive and portable way. Next, with
diff --git a/Documentation/linux_tv/media/v4l/standard.rst b/Documentation/linux_tv/media/v4l/standard.rst
index 3c0f6cb97f13..ec39b2b39e67 100644
--- a/Documentation/linux_tv/media/v4l/standard.rst
+++ b/Documentation/linux_tv/media/v4l/standard.rst
@@ -56,8 +56,8 @@ output device which is:
 
 Here the driver shall set the ``std`` field of struct
 :ref:`v4l2_input <v4l2-input>` and struct
-:ref:`v4l2_output <v4l2-output>` to zero and the ``VIDIOC_G_STD``,
-``VIDIOC_S_STD``, ``VIDIOC_QUERYSTD`` and ``VIDIOC_ENUMSTD`` ioctls
+:ref:`v4l2_output <v4l2-output>` to zero and the :ref:`VIDIOC_G_STD`,
+:ref:`VIDIOC_S_STD <VIDIOC_G_STD>`, :ref:`VIDIOC_QUERYSTD` and :ref:`VIDIOC_ENUMSTD` ioctls
 shall return the ENOTTY error code or the EINVAL error code.
 
 Applications can make use of the :ref:`input-capabilities` and
diff --git a/Documentation/linux_tv/media/v4l/tuner.rst b/Documentation/linux_tv/media/v4l/tuner.rst
index b1be27bd297e..67f4e24709b5 100644
--- a/Documentation/linux_tv/media/v4l/tuner.rst
+++ b/Documentation/linux_tv/media/v4l/tuner.rst
@@ -24,9 +24,9 @@ inputs.
 To query and change tuner properties applications use the
 :ref:`VIDIOC_G_TUNER` and
 :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` ioctls, respectively. The
-struct :ref:`v4l2_tuner <v4l2-tuner>` returned by ``VIDIOC_G_TUNER``
+struct :ref:`v4l2_tuner <v4l2-tuner>` returned by :ref:`VIDIOC_G_TUNER`
 also contains signal status information applicable when the tuner of the
-current video or radio input is queried. Note that ``VIDIOC_S_TUNER``
+current video or radio input is queried. Note that :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>`
 does not switch the current tuner, when there is more than one at all.
 The tuner is solely determined by the current video input. Drivers must
 support both ioctls and set the ``V4L2_CAP_TUNER`` flag in the struct
@@ -61,7 +61,7 @@ cannot specify whether the frequency is for a tuner or a modulator.
 To query and change modulator properties applications use the
 :ref:`VIDIOC_G_MODULATOR` and
 :ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` ioctl. Note that
-``VIDIOC_S_MODULATOR`` does not switch the current modulator, when there
+:ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` does not switch the current modulator, when there
 is more than one at all. The modulator is solely determined by the
 current video output. Drivers must support both ioctls and set the
 ``V4L2_CAP_MODULATOR`` flag in the struct
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
index 9220bcea1259..d269eab4d2b6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
@@ -94,10 +94,10 @@ than the number requested.
        -  ``count``
 
        -  The number of buffers requested or granted. If count == 0, then
-          ``VIDIOC_CREATE_BUFS`` will set ``index`` to the current number of
+          :ref:`VIDIOC_CREATE_BUFS` will set ``index`` to the current number of
           created buffers, and it will check the validity of ``memory`` and
           ``format.type``. If those are invalid -1 is returned and errno is
-          set to EINVAL error code, otherwise ``VIDIOC_CREATE_BUFS`` returns
+          set to EINVAL error code, otherwise :ref:`VIDIOC_CREATE_BUFS` returns
           0. It will never set errno to EBUSY error code in this particular
           case.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
index 22b5efe1d2e4..25ad9b29b160 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-cropcap.rst
@@ -34,7 +34,7 @@ Description
 Applications use this function to query the cropping limits, the pixel
 aspect of images and to calculate scale factors. They set the ``type``
 field of a v4l2_cropcap structure to the respective buffer (stream)
-type and call the ``VIDIOC_CROPCAP`` ioctl with a pointer to this
+type and call the :ref:`VIDIOC_CROPCAP` ioctl with a pointer to this
 structure. Drivers fill the rest of the structure. The results are
 constant except when switching the video standard. Remember this switch
 can occur implicit when switching the video input or output.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
index 12c2e5df48ac..a1534a326bb3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
@@ -49,14 +49,14 @@ Additionally the Linux kernel must be compiled with the
 To query the driver applications must initialize the ``match.type`` and
 ``match.addr`` or ``match.name`` fields of a struct
 :ref:`v4l2_dbg_chip_info <v4l2-dbg-chip-info>` and call
-``VIDIOC_DBG_G_CHIP_INFO`` with a pointer to this structure. On success
+:ref:`VIDIOC_DBG_G_CHIP_INFO` with a pointer to this structure. On success
 the driver stores information about the selected chip in the ``name``
 and ``flags`` fields.
 
 When ``match.type`` is ``V4L2_CHIP_MATCH_BRIDGE``, ``match.addr``
 selects the nth bridge 'chip' on the TV card. You can enumerate all
 chips by starting at zero and incrementing ``match.addr`` by one until
-``VIDIOC_DBG_G_CHIP_INFO`` fails with an EINVAL error code. The number
+:ref:`VIDIOC_DBG_G_CHIP_INFO` fails with an EINVAL error code. The number
 zero always selects the bridge chip itself, e. g. the chip connected to
 the PCI or USB bus. Non-zero numbers identify specific parts of the
 bridge chip such as an AC97 register block.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
index f4fc2723f01e..c838f3dbb808 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
@@ -33,7 +33,7 @@ Description
 
 To enumerate image formats applications initialize the ``type`` and
 ``index`` field of struct :ref:`v4l2_fmtdesc <v4l2-fmtdesc>` and call
-the ``VIDIOC_ENUM_FMT`` ioctl with a pointer to this structure. Drivers
+the :ref:`VIDIOC_ENUM_FMT` ioctl with a pointer to this structure. Drivers
 fill the rest of the structure or return an EINVAL error code. All
 formats are enumerable by beginning at index zero and incrementing by
 one until EINVAL is returned.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
index 2f5dbe0583b4..3999c419589a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-freq-bands.rst
@@ -35,7 +35,7 @@ Enumerates the frequency bands that a tuner or modulator supports. To do
 this applications initialize the ``tuner``, ``type`` and ``index``
 fields, and zero out the ``reserved`` array of a struct
 :ref:`v4l2_frequency_band <v4l2-frequency-band>` and call the
-``VIDIOC_ENUM_FREQ_BANDS`` ioctl with a pointer to this structure.
+:ref:`VIDIOC_ENUM_FREQ_BANDS` ioctl with a pointer to this structure.
 
 This ioctl is supported if the ``V4L2_TUNER_CAP_FREQ_BANDS`` capability
 of the corresponding tuner/modulator is set.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
index dcca0591864e..0fc0c3eeae5f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
@@ -33,7 +33,7 @@ Description
 
 To query the attributes of an audio input applications initialize the
 ``index`` field and zero out the ``reserved`` array of a struct
-:ref:`v4l2_audio <v4l2-audio>` and call the ``VIDIOC_ENUMAUDIO``
+:ref:`v4l2_audio <v4l2-audio>` and call the :ref:`VIDIOC_ENUMAUDIO`
 ioctl with a pointer to this structure. Drivers fill the rest of the
 structure or return an EINVAL error code when the index is out of
 bounds. To enumerate all audio inputs applications shall begin at index
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
index 644d50679aa2..131f331462b1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
@@ -33,7 +33,7 @@ Description
 
 To query the attributes of a video input applications initialize the
 ``index`` field of struct :ref:`v4l2_input <v4l2-input>` and call the
-``VIDIOC_ENUMINPUT`` ioctl with a pointer to this structure. Drivers
+:ref:`VIDIOC_ENUMINPUT` ioctl with a pointer to this structure. Drivers
 fill the rest of the structure or return an EINVAL error code when the
 index is out of bounds. To enumerate all inputs applications shall begin
 at index zero, incrementing by one until the driver returns EINVAL.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
index 6ccb3d094dc8..cb0107b9c03b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
@@ -33,7 +33,7 @@ Description
 
 To query the attributes of a video outputs applications initialize the
 ``index`` field of struct :ref:`v4l2_output <v4l2-output>` and call
-the ``VIDIOC_ENUMOUTPUT`` ioctl with a pointer to this structure.
+the :ref:`VIDIOC_ENUMOUTPUT` ioctl with a pointer to this structure.
 Drivers fill the rest of the structure or return an EINVAL error code
 when the index is out of bounds. To enumerate all outputs applications
 shall begin at index zero, incrementing by one until the driver returns
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
index d16a9494d03b..e292b7d50cc3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
@@ -33,7 +33,7 @@ Description
 
 To query the attributes of a video standard, especially a custom (driver
 defined) one, applications initialize the ``index`` field of struct
-:ref:`v4l2_standard <v4l2-standard>` and call the ``VIDIOC_ENUMSTD``
+:ref:`v4l2_standard <v4l2-standard>` and call the :ref:`VIDIOC_ENUMSTD`
 ioctl with a pointer to this structure. Drivers fill the rest of the
 structure or return an EINVAL error code when the index is out of
 bounds. To enumerate all standards applications shall begin at index
@@ -401,7 +401,7 @@ ENODATA
 
 .. [1]
    The supported standards may overlap and we need an unambiguous set to
-   find the current standard returned by ``VIDIOC_G_STD``.
+   find the current standard returned by :ref:`VIDIOC_G_STD`.
 
 .. [2]
    Japan uses a standard similar to M/NTSC (V4L2_STD_NTSC_M_JP).
diff --git a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
index e71925f3f13e..2933640e8c4e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-expbuf.rst
@@ -53,9 +53,9 @@ Additional flags may be posted in the ``flags`` field. Refer to a manual
 for open() for details. Currently only O_CLOEXEC, O_RDONLY, O_WRONLY,
 and O_RDWR are supported. All other fields must be set to zero. In the
 case of multi-planar API, every plane is exported separately using
-multiple ``VIDIOC_EXPBUF`` calls.
+multiple :ref:`VIDIOC_EXPBUF` calls.
 
-After calling ``VIDIOC_EXPBUF`` the ``fd`` field will be set by a
+After calling :ref:`VIDIOC_EXPBUF` the ``fd`` field will be set by a
 driver. This is a DMABUF file descriptor. The application may pass it to
 other DMABUF-aware devices. Refer to :ref:`DMABUF importing <dmabuf>`
 for details about importing DMABUF files into V4L2 nodes. It is
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
index 2a81d01a1c00..be8899d87e33 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
@@ -36,14 +36,14 @@ Description
 
 To query the current audio input applications zero out the ``reserved``
 array of a struct :ref:`v4l2_audio <v4l2-audio>` and call the
-``VIDIOC_G_AUDIO`` ioctl with a pointer to this structure. Drivers fill
+:ref:`VIDIOC_G_AUDIO` ioctl with a pointer to this structure. Drivers fill
 the rest of the structure or return an EINVAL error code when the device
 has no audio inputs, or none which combine with the current video input.
 
 Audio inputs have one writable property, the audio mode. To select the
 current audio input *and* change the audio mode, applications initialize
 the ``index`` and ``mode`` fields, and the ``reserved`` array of a
-:c:type:`struct v4l2_audio` structure and call the ``VIDIOC_S_AUDIO``
+:c:type:`struct v4l2_audio` structure and call the :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>`
 ioctl. Drivers may switch to a different audio mode if the request
 cannot be satisfied. However, this is a write-only ioctl, it does not
 return the actual new audio mode.
@@ -90,7 +90,7 @@ return the actual new audio mode.
        -  ``mode``
 
        -  Audio mode flags set by drivers and applications (on
-          ``VIDIOC_S_AUDIO`` ioctl), see :ref:`audio-mode`.
+          :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>` ioctl), see :ref:`audio-mode`.
 
     -  .. row 5
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
index e66f8c213535..0a9ede92bc9f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
@@ -36,13 +36,13 @@ Description
 
 To query the cropping rectangle size and position applications set the
 ``type`` field of a :c:type:`struct v4l2_crop` structure to the
-respective buffer (stream) type and call the ``VIDIOC_G_CROP`` ioctl
+respective buffer (stream) type and call the :ref:`VIDIOC_G_CROP` ioctl
 with a pointer to this structure. The driver fills the rest of the
 structure or returns the EINVAL error code if cropping is not supported.
 
 To change the cropping rectangle applications initialize the ``type``
 and struct :ref:`v4l2_rect <v4l2-rect>` substructure named ``c`` of a
-v4l2_crop structure and call the ``VIDIOC_S_CROP`` ioctl with a pointer
+v4l2_crop structure and call the :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctl with a pointer
 to this structure.
 
 Do not use the multiplanar buffer types. Use
@@ -64,15 +64,15 @@ the closest size possible while maintaining the current horizontal and
 vertical scaling factor.
 
 Finally the driver programs the hardware with the actual cropping and
-image parameters. ``VIDIOC_S_CROP`` is a write-only ioctl, it does not
+image parameters. :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` is a write-only ioctl, it does not
 return the actual parameters. To query them applications must call
-``VIDIOC_G_CROP`` and :ref:`VIDIOC_G_FMT`. When the
+:ref:`VIDIOC_G_CROP` and :ref:`VIDIOC_G_FMT`. When the
 parameters are unsuitable the application may modify the cropping or
 image parameters and repeat the cycle until satisfactory parameters have
 been negotiated.
 
 When cropping is not supported then no parameters are changed and
-``VIDIOC_S_CROP`` returns the EINVAL error code.
+:ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` returns the EINVAL error code.
 
 
 .. _v4l2-crop:
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
index 2c2677a76462..41561c5e444d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
@@ -34,15 +34,15 @@ Description
 
 To get the current value of a control applications initialize the ``id``
 field of a struct :c:type:`struct v4l2_control` and call the
-``VIDIOC_G_CTRL`` ioctl with a pointer to this structure. To change the
+:ref:`VIDIOC_G_CTRL` ioctl with a pointer to this structure. To change the
 value of a control applications initialize the ``id`` and ``value``
 fields of a struct :c:type:`struct v4l2_control` and call the
-``VIDIOC_S_CTRL`` ioctl.
+:ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctl.
 
 When the ``id`` is invalid drivers return an EINVAL error code. When the
 ``value`` is out of bounds drivers can choose to take the closest valid
 value or return an ERANGE error code, whatever seems more appropriate.
-However, ``VIDIOC_S_CTRL`` is a write-only ioctl, it does not return the
+However, :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` is a write-only ioctl, it does not return the
 actual new value. If the ``value`` is inappropriate for the control
 (e.g. if it refers to an unsupported menu index of a menu control), then
 EINVAL error code is returned as well.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
index 8a7fa1c0facf..cc7cf06e74ee 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
@@ -36,8 +36,8 @@ Description
 ===========
 
 To set DV timings for the input or output, applications use the
-``VIDIOC_S_DV_TIMINGS`` ioctl and to get the current timings,
-applications use the ``VIDIOC_G_DV_TIMINGS`` ioctl. The detailed timing
+:ref:`VIDIOC_S_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl and to get the current timings,
+applications use the :ref:`VIDIOC_G_DV_TIMINGS` ioctl. The detailed timing
 information is filled in using the structure struct
 :ref:`v4l2_dv_timings <v4l2-dv-timings>`. These ioctls take a
 pointer to the struct :ref:`v4l2_dv_timings <v4l2-dv-timings>`
@@ -59,7 +59,7 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    This ioctl is not supported, or the ``VIDIOC_S_DV_TIMINGS``
+    This ioctl is not supported, or the :ref:`VIDIOC_S_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>`
     parameter was unsuitable.
 
 ENODATA
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
index 0bd8f1ba84d2..a1311a52b8fa 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
@@ -52,7 +52,7 @@ value, then the EINVAL error code will be returned.
 
 To get the EDID data the application has to fill in the ``pad``,
 ``start_block``, ``blocks`` and ``edid`` fields, zero the ``reserved``
-array and call ``VIDIOC_G_EDID``. The current EDID from block
+array and call :ref:`VIDIOC_G_EDID`. The current EDID from block
 ``start_block`` and of size ``blocks`` will be placed in the memory
 ``edid`` points to. The ``edid`` pointer must point to memory at least
 ``blocks`` * 128 bytes large (the size of one block is 128 bytes).
@@ -65,7 +65,7 @@ If blocks have to be retrieved from the sink, then this call will block
 until they have been read.
 
 If ``start_block`` and ``blocks`` are both set to 0 when
-``VIDIOC_G_EDID`` is called, then the driver will set ``blocks`` to the
+:ref:`VIDIOC_G_EDID` is called, then the driver will set ``blocks`` to the
 total number of available EDID blocks and it will return 0 without
 copying any data. This is an easy way to discover how many EDID blocks
 there are. Note that if there are no EDID blocks available at all, then
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
index 68af83d964f6..77c7eff9732d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
@@ -31,19 +31,19 @@ Arguments
 Description
 ===========
 
-The ``VIDIOC_G_ENC_INDEX`` ioctl provides meta data about a compressed
+The :ref:`VIDIOC_G_ENC_INDEX` ioctl provides meta data about a compressed
 video stream the same or another application currently reads from the
 driver, which is useful for random access into the stream without
 decoding it.
 
-To read the data applications must call ``VIDIOC_G_ENC_INDEX`` with a
+To read the data applications must call :ref:`VIDIOC_G_ENC_INDEX` with a
 pointer to a struct :ref:`v4l2_enc_idx <v4l2-enc-idx>`. On success
 the driver fills the ``entry`` array, stores the number of elements
 written in the ``entries`` field, and initializes the ``entries_cap``
 field.
 
 Each element of the ``entry`` array contains meta data about one
-picture. A ``VIDIOC_G_ENC_INDEX`` call reads up to
+picture. A :ref:`VIDIOC_G_ENC_INDEX` call reads up to
 ``V4L2_ENC_IDX_ENTRIES`` entries from a driver buffer, which can hold up
 to ``entries_cap`` entries. This number can be lower or higher than
 ``V4L2_ENC_IDX_ENTRIES``, but not zero. When the application fails to
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
index cebaa6ea1ba9..fb62cd0a991c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
@@ -48,7 +48,7 @@ by the ``controls`` fields.
 To get the current value of a set of controls applications initialize
 the ``id``, ``size`` and ``reserved2`` fields of each struct
 :ref:`v4l2_ext_control <v4l2-ext-control>` and call the
-``VIDIOC_G_EXT_CTRLS`` ioctl. String controls controls must also set the
+:ref:`VIDIOC_G_EXT_CTRLS` ioctl. String controls controls must also set the
 ``string`` field. Controls of compound types
 (``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is set) must set the ``ptr`` field.
 
@@ -70,14 +70,14 @@ by calling :ref:`VIDIOC_QUERY_EXT_CTRL <VIDIOC_QUERYCTRL>`.
 To change the value of a set of controls applications initialize the
 ``id``, ``size``, ``reserved2`` and ``value/value64/string/ptr`` fields
 of each struct :ref:`v4l2_ext_control <v4l2-ext-control>` and call
-the ``VIDIOC_S_EXT_CTRLS`` ioctl. The controls will only be set if *all*
+the :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctl. The controls will only be set if *all*
 control values are valid.
 
 To check if a set of controls have correct values applications
 initialize the ``id``, ``size``, ``reserved2`` and
 ``value/value64/string/ptr`` fields of each struct
 :ref:`v4l2_ext_control <v4l2-ext-control>` and call the
-``VIDIOC_TRY_EXT_CTRLS`` ioctl. It is up to the driver whether wrong
+:ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctl. It is up to the driver whether wrong
 values are automatically adjusted to a valid value or if an error is
 returned.
 
@@ -122,7 +122,7 @@ still cause this situation.
        -  The total size in bytes of the payload of this control. This is
           normally 0, but for pointer controls this should be set to the
           size of the memory containing the payload, or that will receive
-          the payload. If ``VIDIOC_G_EXT_CTRLS`` finds that this value is
+          the payload. If :ref:`VIDIOC_G_EXT_CTRLS` finds that this value is
           less than is required to store the payload result, then it is set
           to a value large enough to store the payload result and ENOSPC is
           returned. Note that for string controls this ``size`` field should
@@ -248,7 +248,7 @@ still cause this situation.
           handling controls will also accept a value of 0 here, meaning that
           the controls can belong to any control class. Whether drivers
           support this can be tested by setting ``ctrl_class`` to 0 and
-          calling ``VIDIOC_TRY_EXT_CTRLS`` with a ``count`` of 0. If that
+          calling :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` with a ``count`` of 0. If that
           succeeds, then the driver supports this feature.
 
     -  .. row 3
@@ -321,14 +321,14 @@ still cause this situation.
           ``error_idx-1`` were read or written correctly, and the state of
           the remaining controls is undefined.
 
-          Since ``VIDIOC_TRY_EXT_CTRLS`` does not access hardware there is
+          Since :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` does not access hardware there is
           also no need to handle the validation step in this special way, so
           ``error_idx`` will just be set to the control that failed the
           validation step instead of to ``count``. This means that if
-          ``VIDIOC_S_EXT_CTRLS`` fails with ``error_idx`` set to ``count``,
-          then you can call ``VIDIOC_TRY_EXT_CTRLS`` to try to discover the
+          :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` fails with ``error_idx`` set to ``count``,
+          then you can call :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` to try to discover the
           actual control that failed the validation step. Unfortunately,
-          there is no ``TRY`` equivalent for ``VIDIOC_G_EXT_CTRLS``.
+          there is no ``TRY`` equivalent for :ref:`VIDIOC_G_EXT_CTRLS`.
 
     -  .. row 6
 
@@ -467,7 +467,7 @@ EINVAL
     :ref:`v4l2_ext_control <v4l2-ext-control>` ``value`` was
     inappropriate (e.g. the given menu index is not supported by the
     driver). This error code is also returned by the
-    ``VIDIOC_S_EXT_CTRLS`` and ``VIDIOC_TRY_EXT_CTRLS`` ioctls if two or
+    :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctls if two or
     more control values are in conflict.
 
 ERANGE
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
index 0d9b6972bc44..e622e2f2435c 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
@@ -34,7 +34,7 @@ Arguments
 Description
 ===========
 
-Applications can use the ``VIDIOC_G_FBUF`` and ``VIDIOC_S_FBUF`` ioctl
+Applications can use the :ref:`VIDIOC_G_FBUF` and :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctl
 to get and set the framebuffer parameters for a
 :ref:`Video Overlay <overlay>` or :ref:`Video Output Overlay <osd>`
 (OSD). The type of overlay is implied by the device type (capture or
@@ -48,7 +48,7 @@ of a graphics card. A non-destructive overlay blends video images into a
 VGA signal or graphics into a video signal. *Video Output Overlays* are
 always non-destructive.
 
-To get the current parameters applications call the ``VIDIOC_G_FBUF``
+To get the current parameters applications call the :ref:`VIDIOC_G_FBUF`
 ioctl with a pointer to a :c:type:`struct v4l2_framebuffer`
 structure. The driver fills all fields of the structure or returns an
 EINVAL error code when overlays are not supported.
@@ -57,15 +57,15 @@ To set the parameters for a *Video Output Overlay*, applications must
 initialize the ``flags`` field of a struct
 :c:type:`struct v4l2_framebuffer`. Since the framebuffer is
 implemented on the TV card all other parameters are determined by the
-driver. When an application calls ``VIDIOC_S_FBUF`` with a pointer to
+driver. When an application calls :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` with a pointer to
 this structure, the driver prepares for the overlay and returns the
-framebuffer parameters as ``VIDIOC_G_FBUF`` does, or it returns an error
+framebuffer parameters as :ref:`VIDIOC_G_FBUF` does, or it returns an error
 code.
 
 To set the parameters for a *non-destructive Video Overlay*,
 applications must initialize the ``flags`` field, the ``fmt``
-substructure, and call ``VIDIOC_S_FBUF``. Again the driver prepares for
-the overlay and returns the framebuffer parameters as ``VIDIOC_G_FBUF``
+substructure, and call :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`. Again the driver prepares for
+the overlay and returns the framebuffer parameters as :ref:`VIDIOC_G_FBUF`
 does, or it returns an error code.
 
 For a *destructive Video Overlay* applications must additionally provide
@@ -486,11 +486,11 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EPERM
-    ``VIDIOC_S_FBUF`` can only be called by a privileged user to
+    :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` can only be called by a privileged user to
     negotiate the parameters for a destructive overlay.
 
 EINVAL
-    The ``VIDIOC_S_FBUF`` parameters are unsuitable.
+    The :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` parameters are unsuitable.
 
 .. [1]
    A physical base address may not suit all platforms. GK notes in
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
index 1d392e6c538d..8c07fe2454e2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
@@ -41,7 +41,7 @@ struct :c:type:`struct v4l2_format` to the respective buffer (stream)
 type. For example video capture devices use
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``. When the application calls the
-``VIDIOC_G_FMT`` ioctl with a pointer to this structure the driver fills
+:ref:`VIDIOC_G_FMT` ioctl with a pointer to this structure the driver fills
 the respective member of the ``fmt`` union. In case of video capture
 devices that is either the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
@@ -54,32 +54,32 @@ To change the current format parameters applications initialize the
 For details see the documentation of the various devices types in
 :ref:`devices`. Good practice is to query the current parameters
 first, and to modify only those parameters not suitable for the
-application. When the application calls the ``VIDIOC_S_FMT`` ioctl with
+application. When the application calls the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl with
 a pointer to a :c:type:`struct v4l2_format` structure the driver
 checks and adjusts the parameters against hardware abilities. Drivers
 should not return an error code unless the ``type`` field is invalid,
 this is a mechanism to fathom device capabilities and to approach
 parameters acceptable for both the application and driver. On success
 the driver may program the hardware, allocate resources and generally
-prepare for data exchange. Finally the ``VIDIOC_S_FMT`` ioctl returns
-the current format parameters as ``VIDIOC_G_FMT`` does. Very simple,
+prepare for data exchange. Finally the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl returns
+the current format parameters as :ref:`VIDIOC_G_FMT` does. Very simple,
 inflexible devices may even ignore all input and always return the
 default parameters. However all V4L2 devices exchanging data with the
-application must implement the ``VIDIOC_G_FMT`` and ``VIDIOC_S_FMT``
+application must implement the :ref:`VIDIOC_G_FMT` and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl. When the requested buffer type is not supported drivers return an
-EINVAL error code on a ``VIDIOC_S_FMT`` attempt. When I/O is already in
+EINVAL error code on a :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` attempt. When I/O is already in
 progress or the resource is not available for other reasons drivers
 return the EBUSY error code.
 
-The ``VIDIOC_TRY_FMT`` ioctl is equivalent to ``VIDIOC_S_FMT`` with one
+The :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl is equivalent to :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` with one
 exception: it does not change driver state. It can also be called at any
 time, never returning EBUSY. This function is provided to negotiate
 parameters, to learn about hardware limitations, without disabling I/O
 or possibly time consuming hardware preparations. Although strongly
 recommended drivers are not required to implement this ioctl.
 
-The format as returned by ``VIDIOC_TRY_FMT`` must be identical to what
-``VIDIOC_S_FMT`` returns for the same input or output.
+The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical to what
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` returns for the same input or output.
 
 
 .. _v4l2-format:
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
index ce247577c3a0..19a5ae9c4bcd 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
@@ -39,15 +39,15 @@ the ``tuner`` field of a struct
 :ref:`v4l2_frequency <v4l2-frequency>` to the respective tuner or
 modulator number (only input devices have tuners, only output devices
 have modulators), zero out the ``reserved`` array and call the
-``VIDIOC_G_FREQUENCY`` ioctl with a pointer to this structure. The
+:ref:`VIDIOC_G_FREQUENCY` ioctl with a pointer to this structure. The
 driver stores the current frequency in the ``frequency`` field.
 
 To change the current tuner or modulator radio frequency applications
 initialize the ``tuner``, ``type`` and ``frequency`` fields, and the
 ``reserved`` array of a struct :ref:`v4l2_frequency <v4l2-frequency>`
-and call the ``VIDIOC_S_FREQUENCY`` ioctl with a pointer to this
+and call the :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl with a pointer to this
 structure. When the requested frequency is not possible the driver
-assumes the closest possible value. However ``VIDIOC_S_FREQUENCY`` is a
+assumes the closest possible value. However :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` is a
 write-only ioctl, it does not return the actual new frequency.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
index d0abf6231b7d..2bcaa324aa33 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
@@ -33,13 +33,13 @@ Description
 ===========
 
 To query the current video input applications call the
-``VIDIOC_G_INPUT`` ioctl with a pointer to an integer where the driver
+:ref:`VIDIOC_G_INPUT` ioctl with a pointer to an integer where the driver
 stores the number of the input, as in the struct
 :ref:`v4l2_input <v4l2-input>` ``index`` field. This ioctl will fail
 only when there are no video inputs, returning EINVAL.
 
 To select a video input applications store the number of the desired
-input in an integer and call the ``VIDIOC_S_INPUT`` ioctl with a pointer
+input in an integer and call the :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` ioctl with a pointer
 to this integer. Side effects are possible. For example inputs may
 support different video standards, so the driver may implicitly switch
 the current standard. Because of these possible side effects
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
index 4399a13f94c1..83e761eaef2b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
@@ -37,7 +37,7 @@ Description
 To query the attributes of a modulator applications initialize the
 ``index`` field and zero out the ``reserved`` array of a struct
 :ref:`v4l2_modulator <v4l2-modulator>` and call the
-``VIDIOC_G_MODULATOR`` ioctl with a pointer to this structure. Drivers
+:ref:`VIDIOC_G_MODULATOR` ioctl with a pointer to this structure. Drivers
 fill the rest of the structure or return an EINVAL error code when the
 index is out of bounds. To enumerate all modulators applications shall
 begin at index zero, incrementing by one until the driver returns
@@ -46,7 +46,7 @@ EINVAL.
 Modulators have two writable properties, an audio modulation set and the
 radio frequency. To change the modulated audio subprograms, applications
 initialize the ``index`` and ``txsubchans`` fields and the ``reserved``
-array and call the ``VIDIOC_S_MODULATOR`` ioctl. Drivers may choose a
+array and call the :ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` ioctl. Drivers may choose a
 different audio modulation if the request cannot be satisfied. However
 this is a write-only ioctl, it does not return the actual audio
 modulation selected.
@@ -198,7 +198,7 @@ To change the radio frequency the
           ``V4L2_TUNER_SUB_MONO``, ``V4L2_TUNER_SUB_STEREO`` or
           ``V4L2_TUNER_SUB_SAP``. If the hardware does not support the
           respective audio matrix, or the current video standard does not
-          permit bilingual audio the ``VIDIOC_S_MODULATOR`` ioctl shall
+          permit bilingual audio the :ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` ioctl shall
           return an EINVAL error code and the driver shall fall back to mono
           or stereo mode.
 
@@ -230,7 +230,7 @@ To change the radio frequency the
           ``V4L2_TUNER_SUB_MONO`` or ``V4L2_TUNER_SUB_STEREO``. If the
           hardware does not support the respective audio matrix, or the
           current video standard does not permit SAP the
-          ``VIDIOC_S_MODULATOR`` ioctl shall return an EINVAL error code and
+          :ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` ioctl shall return an EINVAL error code and
           driver shall fall back to mono or stereo mode.
 
     -  .. row 6
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
index a38d6a118cf4..ebed04ae48da 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
@@ -33,14 +33,14 @@ Description
 ===========
 
 To query the current video output applications call the
-``VIDIOC_G_OUTPUT`` ioctl with a pointer to an integer where the driver
+:ref:`VIDIOC_G_OUTPUT` ioctl with a pointer to an integer where the driver
 stores the number of the output, as in the struct
 :ref:`v4l2_output <v4l2-output>` ``index`` field. This ioctl will
 fail only when there are no video outputs, returning the EINVAL error
 code.
 
 To select a video output applications store the number of the desired
-output in an integer and call the ``VIDIOC_S_OUTPUT`` ioctl with a
+output in an integer and call the :ref:`VIDIOC_S_OUTPUT <VIDIOC_G_OUTPUT>` ioctl with a
 pointer to this integer. Side effects are possible. For example outputs
 may support different video standards, so the driver may implicitly
 switch the current standard. standard. Because of these possible side
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
index 07432d386356..906faaa85bfa 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
@@ -44,7 +44,7 @@ internally by a driver in read/write mode. For implications see the
 section discussing the :ref:`read() <func-read>` function.
 
 To get and set the streaming parameters applications call the
-``VIDIOC_G_PARM`` and ``VIDIOC_S_PARM`` ioctl, respectively. They take a
+:ref:`VIDIOC_G_PARM` and :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl, respectively. They take a
 pointer to a struct :c:type:`struct v4l2_streamparm` which contains a
 union holding separate parameters for input and output devices.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
index ee80c9e0c7d4..db95647d3a80 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
@@ -36,11 +36,11 @@ Description
 ===========
 
 To query the current access priority applications call the
-``VIDIOC_G_PRIORITY`` ioctl with a pointer to an enum v4l2_priority
+:ref:`VIDIOC_G_PRIORITY` ioctl with a pointer to an enum v4l2_priority
 variable where the driver stores the current priority.
 
 To request an access priority applications store the desired priority in
-an enum v4l2_priority variable and call ``VIDIOC_S_PRIORITY`` ioctl
+an enum v4l2_priority variable and call :ref:`VIDIOC_S_PRIORITY <VIDIOC_G_PRIORITY>` ioctl
 with a pointer to this variable.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
index 8c86d2b41a5b..635cb9b2c250 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -34,7 +34,7 @@ Description
 To find out which data services are supported by a sliced VBI capture or
 output device, applications initialize the ``type`` field of a struct
 :ref:`v4l2_sliced_vbi_cap <v4l2-sliced-vbi-cap>`, clear the
-``reserved`` array and call the ``VIDIOC_G_SLICED_VBI_CAP`` ioctl. The
+``reserved`` array and call the :ref:`VIDIOC_G_SLICED_VBI_CAP` ioctl. The
 driver fills in the remaining fields or returns an EINVAL error code if
 the sliced VBI API is unsupported or ``type`` is invalid.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
index fa9da29e0657..bc8e071401b0 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
@@ -35,15 +35,15 @@ Description
 ===========
 
 To query and select the current video standard applications use the
-``VIDIOC_G_STD`` and ``VIDIOC_S_STD`` ioctls which take a pointer to a
-:ref:`v4l2_std_id <v4l2-std-id>` type as argument. ``VIDIOC_G_STD``
+:ref:`VIDIOC_G_STD` and :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` ioctls which take a pointer to a
+:ref:`v4l2_std_id <v4l2-std-id>` type as argument. :ref:`VIDIOC_G_STD`
 can return a single flag or a set of flags as in struct
 :ref:`v4l2_standard <v4l2-standard>` field ``id``. The flags must be
 unambiguous such that they appear in only one enumerated
 :c:type:`struct v4l2_standard` structure.
 
-``VIDIOC_S_STD`` accepts one or more flags, being a write-only ioctl it
-does not return the actual new standard as ``VIDIOC_G_STD`` does. When
+:ref:`VIDIOC_S_STD <VIDIOC_G_STD>` accepts one or more flags, being a write-only ioctl it
+does not return the actual new standard as :ref:`VIDIOC_G_STD` does. When
 no flags are given or the current input does not support the requested
 standard the driver returns an EINVAL error code. When the standard set
 is ambiguous drivers may return EINVAL or choose any of the requested
@@ -61,7 +61,7 @@ appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
 EINVAL
-    The ``VIDIOC_S_STD`` parameter was unsuitable.
+    The :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` parameter was unsuitable.
 
 ENODATA
     Standard video timings are not supported for this input or output.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
index fe9084147b93..10faf2517392 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-overlay.rst
@@ -32,7 +32,7 @@ Description
 ===========
 
 This ioctl is part of the :ref:`video overlay <overlay>` I/O method.
-Applications call ``VIDIOC_OVERLAY`` to start or stop the overlay. It
+Applications call :ref:`VIDIOC_OVERLAY` to start or stop the overlay. It
 takes a pointer to an integer which must be set to zero by the
 application to stop overlay, to one to start.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
index fb3ac38b3db2..0b51c587701b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
@@ -31,9 +31,9 @@ Arguments
 Description
 ===========
 
-Applications can optionally call the ``VIDIOC_PREPARE_BUF`` ioctl to
+Applications can optionally call the :ref:`VIDIOC_PREPARE_BUF` ioctl to
 pass ownership of the buffer to the driver before actually enqueuing it,
-using the ``VIDIOC_QBUF`` ioctl, and to prepare it for future I/O. Such
+using the :ref:`VIDIOC_QBUF` ioctl, and to prepare it for future I/O. Such
 preparations may include cache invalidation or cleaning. Performing them
 in advance saves time during the actual I/O. In case such cache
 operations are not required, the application can use one of
diff --git a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
index ba78f7e5bbe8..0120432de989 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
@@ -34,18 +34,18 @@ Description
 
 The hardware may be able to detect the current DV timings automatically,
 similar to sensing the video standard. To do so, applications call
-``VIDIOC_QUERY_DV_TIMINGS`` with a pointer to a struct
+:ref:`VIDIOC_QUERY_DV_TIMINGS` with a pointer to a struct
 :ref:`v4l2_dv_timings <v4l2-dv-timings>`. Once the hardware detects
 the timings, it will fill in the timings structure.
 
 Please note that drivers shall *not* switch timings automatically if new
 timings are detected. Instead, drivers should send the
 ``V4L2_EVENT_SOURCE_CHANGE`` event (if they support this) and expect
-that userspace will take action by calling ``VIDIOC_QUERY_DV_TIMINGS``.
+that userspace will take action by calling :ref:`VIDIOC_QUERY_DV_TIMINGS`.
 The reason is that new timings usually mean different buffer sizes as
 well, and you cannot change buffer sizes on the fly. In general,
 applications that receive the Source Change event will have to call
-``VIDIOC_QUERY_DV_TIMINGS``, and if the detected timings are valid they
+:ref:`VIDIOC_QUERY_DV_TIMINGS`, and if the detected timings are valid they
 will have to stop streaming, set the new timings, allocate new buffers
 and start streaming again.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
index 744cd9da45a3..280fb795c0b9 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
@@ -48,7 +48,7 @@ using the :ref:`multi-planar API <planar-apis>`, the ``m.planes``
 field must contain a userspace pointer to an array of struct
 :ref:`v4l2_plane <v4l2-plane>` and the ``length`` field has to be set
 to the number of elements in that array. After calling
-``VIDIOC_QUERYBUF`` with a pointer to this structure drivers return an
+:ref:`VIDIOC_QUERYBUF` with a pointer to this structure drivers return an
 error code or fill the rest of the structure.
 
 In the ``flags`` field the ``V4L2_BUF_FLAG_MAPPED``,
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
index 1d825fff9d15..29ce879a708b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querystd.rst
@@ -32,7 +32,7 @@ Description
 ===========
 
 The hardware may be able to detect the current video standard
-automatically. To do so, applications call ``VIDIOC_QUERYSTD`` with a
+automatically. To do so, applications call :ref:`VIDIOC_QUERYSTD` with a
 pointer to a :ref:`v4l2_std_id <v4l2-std-id>` type. The driver
 stores here a set of candidates, this can be a single flag or a set of
 supported standards if for example the hardware can only distinguish
@@ -45,10 +45,10 @@ Please note that drivers shall *not* switch the video standard
 automatically if a new video standard is detected. Instead, drivers
 should send the ``V4L2_EVENT_SOURCE_CHANGE`` event (if they support
 this) and expect that userspace will take action by calling
-``VIDIOC_QUERYSTD``. The reason is that a new video standard can mean
+:ref:`VIDIOC_QUERYSTD`. The reason is that a new video standard can mean
 different buffer sizes as well, and you cannot change buffer sizes on
 the fly. In general, applications that receive the Source Change event
-will have to call ``VIDIOC_QUERYSTD``, and if the detected video
+will have to call :ref:`VIDIOC_QUERYSTD`, and if the detected video
 standard is valid they will have to stop streaming, set the new
 standard, allocate new buffers and start streaming again.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
index c17d3b0465d6..451cf7b11c3d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
@@ -58,7 +58,7 @@ buffers, one displayed and one filled by the application.
 When the I/O method is not supported the ioctl returns an EINVAL error
 code.
 
-Applications can call ``VIDIOC_REQBUFS`` again to change the number of
+Applications can call :ref:`VIDIOC_REQBUFS` again to change the number of
 buffers, however this cannot succeed when any buffers are still mapped.
 A ``count`` value of zero frees all buffers, after aborting or finishing
 any DMA in progress, an implicit
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
index ab1368786038..07ad0a98ead2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -44,7 +44,7 @@ when enumerating frame intervals.
 To enumerate frame intervals applications initialize the ``index``,
 ``pad``, ``which``, ``code``, ``width`` and ``height`` fields of struct
 :ref:`v4l2_subdev_frame_interval_enum <v4l2-subdev-frame-interval-enum>`
-and call the ``VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL`` ioctl with a pointer
+and call the :ref:`VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL` ioctl with a pointer
 to this structure. Drivers fill the rest of the structure or return an
 EINVAL error code if one of the input fields is invalid. All frame
 intervals are enumerable by beginning at index zero and incrementing by
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
index e08de6040757..39393ef11590 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-size.rst
@@ -40,7 +40,7 @@ ioctl.
 To enumerate frame sizes applications initialize the ``pad``, ``which``
 , ``code`` and ``index`` fields of the struct
 :ref:`v4l2_subdev_mbus_code_enum <v4l2-subdev-mbus-code-enum>` and
-call the ``VIDIOC_SUBDEV_ENUM_FRAME_SIZE`` ioctl with a pointer to the
+call the :ref:`VIDIOC_SUBDEV_ENUM_FRAME_SIZE` ioctl with a pointer to the
 structure. Drivers fill the minimum and maximum frame sizes or return an
 EINVAL error code if one of the input parameters is invalid.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
index 0daf410c1546..f50a1f1c68d5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -35,7 +35,7 @@ To enumerate media bus formats available at a given sub-device pad
 applications initialize the ``pad``, ``which`` and ``index`` fields of
 struct
 :ref:`v4l2_subdev_mbus_code_enum <v4l2-subdev-mbus-code-enum>` and
-call the ``VIDIOC_SUBDEV_ENUM_MBUS_CODE`` ioctl with a pointer to this
+call the :ref:`VIDIOC_SUBDEV_ENUM_MBUS_CODE` ioctl with a pointer to this
 structure. Drivers fill the rest of the structure or return an EINVAL
 error code if either the ``pad`` or ``index`` are invalid. All media bus
 formats are enumerable by beginning at index zero and incrementing by
-- 
2.7.4


