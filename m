Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbcGDLr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 14/51] Documentation: linux_tv: don't simplify VIDIOC_G_foo references
Date: Mon,  4 Jul 2016 08:46:35 -0300
Message-Id: <0bc19488a49e2d6f329acbb044a73b98b467e443.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As VIDIOC_G_foo is the reference used for VIDIOC_S_foo and
VIDIOC_TRY_foo, we need to explicitly name the reference, as
otherwise, it will mention the three ioctls altogether, with
is not what we want.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/app-pri.rst       |  2 +-
 Documentation/linux_tv/media/v4l/audio.rst         |  6 ++---
 Documentation/linux_tv/media/v4l/control.rst       |  2 +-
 Documentation/linux_tv/media/v4l/crop.rst          |  4 ++--
 Documentation/linux_tv/media/v4l/dev-capture.rst   | 12 +++++-----
 Documentation/linux_tv/media/v4l/dev-osd.rst       |  6 ++---
 Documentation/linux_tv/media/v4l/dev-output.rst    | 12 +++++-----
 Documentation/linux_tv/media/v4l/dev-overlay.rst   | 12 +++++-----
 Documentation/linux_tv/media/v4l/dev-radio.rst     |  4 ++--
 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst   |  8 +++----
 .../linux_tv/media/v4l/dev-sliced-vbi.rst          |  6 ++---
 Documentation/linux_tv/media/v4l/diff-v4l.rst      | 24 +++++++++----------
 Documentation/linux_tv/media/v4l/dv-timings.rst    |  2 +-
 .../linux_tv/media/v4l/extended-controls.rst       |  4 ++--
 Documentation/linux_tv/media/v4l/format.rst        |  4 ++--
 Documentation/linux_tv/media/v4l/func-read.rst     |  2 +-
 Documentation/linux_tv/media/v4l/hist-v4l2.rst     | 28 +++++++++++-----------
 .../linux_tv/media/v4l/libv4l-introduction.rst     |  2 +-
 Documentation/linux_tv/media/v4l/pixfmt-013.rst    |  2 +-
 Documentation/linux_tv/media/v4l/pixfmt.rst        |  2 +-
 Documentation/linux_tv/media/v4l/planar-apis.rst   |  2 +-
 Documentation/linux_tv/media/v4l/standard.rst      |  4 ++--
 Documentation/linux_tv/media/v4l/streaming-par.rst |  2 +-
 Documentation/linux_tv/media/v4l/tuner.rst         |  8 +++----
 Documentation/linux_tv/media/v4l/video.rst         |  4 ++--
 .../linux_tv/media/v4l/vidioc-create-bufs.rst      |  2 +-
 .../linux_tv/media/v4l/vidioc-enumaudio.rst        |  2 +-
 .../linux_tv/media/v4l/vidioc-enumaudioout.rst     |  2 +-
 .../linux_tv/media/v4l/vidioc-enumstd.rst          |  2 +-
 .../linux_tv/media/v4l/vidioc-g-audio.rst          |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst |  4 ++--
 .../linux_tv/media/v4l/vidioc-g-dv-timings.rst     |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst |  4 ++--
 .../linux_tv/media/v4l/vidioc-g-enc-index.rst      |  6 ++---
 .../linux_tv/media/v4l/vidioc-g-ext-ctrls.rst      |  8 +++----
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst |  8 +++----
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst  |  6 ++---
 .../linux_tv/media/v4l/vidioc-g-frequency.rst      |  2 +-
 .../linux_tv/media/v4l/vidioc-g-input.rst          |  2 +-
 .../linux_tv/media/v4l/vidioc-g-modulator.rst      |  2 +-
 .../linux_tv/media/v4l/vidioc-g-output.rst         |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst |  2 +-
 .../linux_tv/media/v4l/vidioc-g-priority.rst       |  2 +-
 .../linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst  |  6 ++---
 .../linux_tv/media/v4l/vidioc-queryctrl.rst        |  2 +-
 47 files changed, 119 insertions(+), 119 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/app-pri.rst b/Documentation/linux_tv/media/v4l/app-pri.rst
index 4faf9042f612..7ff6f44eb591 100644
--- a/Documentation/linux_tv/media/v4l/app-pri.rst
+++ b/Documentation/linux_tv/media/v4l/app-pri.rst
@@ -16,7 +16,7 @@ applications and automatically regain control of the device at a later
 time.
 
 Since these features cannot be implemented entirely in user space V4L2
-defines the :ref:`VIDIOC_G_PRIORITY` and
+defines the :ref:`VIDIOC_G_PRIORITY <VIDIOC_G_PRIORITY>` and
 :ref:`VIDIOC_S_PRIORITY <VIDIOC_G_PRIORITY>` ioctls to request and
 query the access priority associate with a file descriptor. Opening a
 device assigns a medium priority, compatible with earlier versions of
diff --git a/Documentation/linux_tv/media/v4l/audio.rst b/Documentation/linux_tv/media/v4l/audio.rst
index 21db1b97b83c..8c3314218f75 100644
--- a/Documentation/linux_tv/media/v4l/audio.rst
+++ b/Documentation/linux_tv/media/v4l/audio.rst
@@ -33,11 +33,11 @@ The struct :ref:`v4l2_audio <v4l2-audio>` returned by the
 :ref:`VIDIOC_ENUMAUDIO` ioctl also contains signal
 :status information applicable when the current audio input is queried.
 
-The :ref:`VIDIOC_G_AUDIO` and
+The :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
 :ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDIOout>` ioctls report the current
 audio input and output, respectively. Note that, unlike
-:ref:`VIDIOC_G_INPUT` and
-:ref:`VIDIOC_G_OUTPUT` these ioctls return a
+:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
+:ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` these ioctls return a
 structure as :ref:`VIDIOC_ENUMAUDIO` and
 :ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDIOout>` do, not just an index.
 
diff --git a/Documentation/linux_tv/media/v4l/control.rst b/Documentation/linux_tv/media/v4l/control.rst
index 02bd455a2616..d6df648767c5 100644
--- a/Documentation/linux_tv/media/v4l/control.rst
+++ b/Documentation/linux_tv/media/v4l/control.rst
@@ -364,7 +364,7 @@ Control IDs
 Applications can enumerate the available controls with the
 :ref:`VIDIOC_QUERYCTRL` and
 :ref:`VIDIOC_QUERYMENU <VIDIOC_QUERYCTRL>` ioctls, get and set a
-control value with the :ref:`VIDIOC_G_CTRL` and
+control value with the :ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls. Drivers must implement
 ``VIDIOC_QUERYCTRL``, ``VIDIOC_G_CTRL`` and ``VIDIOC_S_CTRL`` when the
 device has one or more controls, ``VIDIOC_QUERYMENU`` when it has one or
diff --git a/Documentation/linux_tv/media/v4l/crop.rst b/Documentation/linux_tv/media/v4l/crop.rst
index 41a5efaaa679..bfb30568df23 100644
--- a/Documentation/linux_tv/media/v4l/crop.rst
+++ b/Documentation/linux_tv/media/v4l/crop.rst
@@ -15,7 +15,7 @@ offset into a video signal.
 Applications can use the following API to select an area in the video
 signal, query the default area and the hardware limits. *Despite their
 name, the :ref:`VIDIOC_CROPCAP`,
-:ref:`VIDIOC_G_CROP` and
+:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
 :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctls apply to input as well
 as output devices.*
 
@@ -23,7 +23,7 @@ Scaling requires a source and a target. On a video capture or overlay
 device the source is the video signal, and the cropping ioctls determine
 the area actually sampled. The target are images read by the application
 or overlaid onto the graphics screen. Their size (and position for an
-overlay) is negotiated with the :ref:`VIDIOC_G_FMT`
+overlay) is negotiated with the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
 and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls.
 
 On a video output device the source are the images passed in by the
diff --git a/Documentation/linux_tv/media/v4l/dev-capture.rst b/Documentation/linux_tv/media/v4l/dev-capture.rst
index c970a1fd1439..0e62dc026251 100644
--- a/Documentation/linux_tv/media/v4l/dev-capture.rst
+++ b/Documentation/linux_tv/media/v4l/dev-capture.rst
@@ -65,7 +65,7 @@ To query the current image format applications set the ``type`` field of
 a struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE`` and call the
-:ref:`VIDIOC_G_FMT` ioctl with a pointer to this
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer to this
 structure. Drivers fill the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
 :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` ``pix_mp``
@@ -75,9 +75,9 @@ To request different parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
 fields of the struct :ref:`v4l2_pix_format <v4l2-pix-format>`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
-of :ref:`VIDIOC_G_FMT`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
+of :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers may adjust the
-parameters and finally return the actual parameters as :ref:`VIDIOC_G_FMT`
+parameters and finally return the actual parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
 does.
 
 Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl
@@ -87,10 +87,10 @@ possibly time consuming hardware preparations.
 The contents of struct :ref:`v4l2_pix_format <v4l2-pix-format>` and
 struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` are
 discussed in :ref:`pixfmt`. See also the specification of the
-:ref:`VIDIOC_G_FMT`, :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctls for
-details. Video capture devices must implement both the :ref:`VIDIOC_G_FMT`
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctls for
+details. Video capture devices must implement both the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
 and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, even if :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ignores all
-requests and always returns default parameters as :ref:`VIDIOC_G_FMT` does.
+requests and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does.
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` is optional.
 
 
diff --git a/Documentation/linux_tv/media/v4l/dev-osd.rst b/Documentation/linux_tv/media/v4l/dev-osd.rst
index 4b668a3544b8..f9337001f50d 100644
--- a/Documentation/linux_tv/media/v4l/dev-osd.rst
+++ b/Documentation/linux_tv/media/v4l/dev-osd.rst
@@ -36,7 +36,7 @@ Contrary to the *Video Overlay* interface the framebuffer is normally
 implemented on the TV card and not the graphics card. On Linux it is
 accessible as a framebuffer device (``/dev/fbN``). Given a V4L2 device,
 applications can find the corresponding framebuffer device by calling
-the :ref:`VIDIOC_G_FBUF` ioctl. It returns, amongst
+the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` ioctl. It returns, amongst
 other information, the physical address of the framebuffer in the
 ``base`` field of struct :ref:`v4l2_framebuffer <v4l2-framebuffer>`.
 The framebuffer device ioctl ``FBIOGET_FSCREENINFO`` returns the same
@@ -115,7 +115,7 @@ clipping/blending method to be used for the overlay. To get the current
 parameters applications set the ``type`` field of a struct
 :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY`` and call the
-:ref:`VIDIOC_G_FMT` ioctl. The driver fills the
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
 :c:type:`struct v4l2_window` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
@@ -124,7 +124,7 @@ struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY``, initialize the ``win``
 substructure and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 The driver adjusts the parameters against hardware limits and returns
-the actual parameters as :ref:`VIDIOC_G_FMT` does. Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`,
+the actual parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does. Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`,
 the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to learn
 about driver capabilities without actually changing driver state. Unlike
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` this also works after the overlay has been enabled.
diff --git a/Documentation/linux_tv/media/v4l/dev-output.rst b/Documentation/linux_tv/media/v4l/dev-output.rst
index ee62d1a0fb87..5253498db95a 100644
--- a/Documentation/linux_tv/media/v4l/dev-output.rst
+++ b/Documentation/linux_tv/media/v4l/dev-output.rst
@@ -62,7 +62,7 @@ defaults. An example is given in :ref:`crop`.
 To query the current image format applications set the ``type`` field of
 a struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``
-and call the :ref:`VIDIOC_G_FMT` ioctl with a pointer
+and call the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer
 to this structure. Drivers fill the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
 :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` ``pix_mp``
@@ -72,9 +72,9 @@ To request different parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
 fields of the struct :ref:`v4l2_pix_format <v4l2-pix-format>`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
-of :ref:`VIDIOC_G_FMT`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
+of :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers may adjust the
-parameters and finally return the actual parameters as :ref:`VIDIOC_G_FMT`
+parameters and finally return the actual parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
 does.
 
 Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` the :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl
@@ -84,10 +84,10 @@ possibly time consuming hardware preparations.
 The contents of struct :ref:`v4l2_pix_format <v4l2-pix-format>` and
 struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` are
 discussed in :ref:`pixfmt`. See also the specification of the
-:ref:`VIDIOC_G_FMT`, :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctls for
-details. Video output devices must implement both the :ref:`VIDIOC_G_FMT`
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctls for
+details. Video output devices must implement both the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
 and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, even if :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ignores all
-requests and always returns default parameters as :ref:`VIDIOC_G_FMT` does.
+requests and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does.
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` is optional.
 
 
diff --git a/Documentation/linux_tv/media/v4l/dev-overlay.rst b/Documentation/linux_tv/media/v4l/dev-overlay.rst
index 26bd4a15a125..083cf07e55c5 100644
--- a/Documentation/linux_tv/media/v4l/dev-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/dev-overlay.rst
@@ -63,7 +63,7 @@ Setup
 Before overlay can commence applications must program the driver with
 frame buffer parameters, namely the address and size of the frame buffer
 and the image format, for example RGB 5:6:5. The
-:ref:`VIDIOC_G_FBUF` and
+:ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` and
 :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctls are available to get and
 set these parameters, respectively. The :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctl is
 privileged because it allows to set up DMA into physical memory,
@@ -77,7 +77,7 @@ Some devices add the video overlay to the output signal of the graphics
 card. In this case the frame buffer is not modified by the video device,
 and the frame buffer address and pixel format are not needed by the
 driver. The :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctl is not privileged. An application
-can check for this type of device by calling the :ref:`VIDIOC_G_FBUF`
+can check for this type of device by calling the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`
 ioctl.
 
 A driver may support any (or none) of five clipping/blending methods:
@@ -121,7 +121,7 @@ its position over the graphics surface and the clipping to be applied.
 To get the current parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY`` and call the
-:ref:`VIDIOC_G_FMT` ioctl. The driver fills the
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
 :c:type:`struct v4l2_window` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
@@ -130,7 +130,7 @@ struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY``, initialize the ``win`` substructure and
 call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. The driver
 adjusts the parameters against hardware limits and returns the actual
-parameters as :ref:`VIDIOC_G_FMT` does. Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`, the
+parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does. Like :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`, the
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to learn
 about driver capabilities without actually changing driver state. Unlike
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` this also works after the overlay has been enabled.
@@ -179,7 +179,7 @@ struct v4l2_window
 
 ``struct v4l2_clip * clips``
     When chroma-keying has *not* been negotiated and
-    :ref:`VIDIOC_G_FBUF` indicated this capability,
+    :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` indicated this capability,
     applications can set this field to point to an array of clipping
     rectangles.
 
@@ -204,7 +204,7 @@ are undefined.
 
 ``void * bitmap``
     When chroma-keying has *not* been negotiated and
-    :ref:`VIDIOC_G_FBUF` indicated this capability,
+    :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` indicated this capability,
     applications can set this field to point to a clipping bit mask.
 
 It must be of the same size as the window, ``w.width`` and ``w.height``.
diff --git a/Documentation/linux_tv/media/v4l/dev-radio.rst b/Documentation/linux_tv/media/v4l/dev-radio.rst
index 7a0d25a143a6..55a56fb5d958 100644
--- a/Documentation/linux_tv/media/v4l/dev-radio.rst
+++ b/Documentation/linux_tv/media/v4l/dev-radio.rst
@@ -47,8 +47,8 @@ discussed in :ref:`tuner`) with index number zero to select the radio
 frequency and to determine if a monaural or FM stereo program is
 received/emitted. Drivers switch automatically between AM and FM
 depending on the selected frequency. The
-:ref:`VIDIOC_G_TUNER` or
-:ref:`VIDIOC_G_MODULATOR` ioctl reports the
+:ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` or
+:ref:`VIDIOC_G_MODULATOR <VIDIOC_G_MODULATOR>` ioctl reports the
 supported frequency range.
 
 
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
index 2cd813a5b4e4..596b0a6b2177 100644
--- a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
@@ -71,7 +71,7 @@ parameters and then checking if the actual parameters are suitable.
 To query the current raw VBI capture parameters applications set the
 ``type`` field of a struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VBI_CAPTURE`` or ``V4L2_BUF_TYPE_VBI_OUTPUT``, and call
-the :ref:`VIDIOC_G_FMT` ioctl with a pointer to this
+the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer to this
 structure. Drivers fill the struct
 :ref:`v4l2_vbi_format <v4l2-vbi-format>` ``vbi`` member of the
 ``fmt`` union.
@@ -80,7 +80,7 @@ To request different parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
 fields of the struct :ref:`v4l2_vbi_format <v4l2-vbi-format>`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
-of :ref:`VIDIOC_G_FMT`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
+of :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl with a pointer to this structure. Drivers return an EINVAL error
 code only when the given parameters are ambiguous, otherwise they modify
 the parameters according to the hardware capabilities and return the
@@ -94,9 +94,9 @@ expect other resource allocation points which may return EBUSY, at the
 :ref:`VIDIOC_STREAMON` ioctl and the first read(),
 write() and select() call.
 
-VBI devices must implement both the :ref:`VIDIOC_G_FMT` and
+VBI devices must implement both the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl, even if :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ignores all requests
-and always returns default parameters as :ref:`VIDIOC_G_FMT` does.
+and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does.
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` is optional.
 
 
diff --git a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
index d53353afbedf..3692cdf8e756 100644
--- a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
@@ -57,7 +57,7 @@ Sliced VBI Format Negotiation
 
 To find out which data services are supported by the hardware
 applications can call the
-:ref:`VIDIOC_G_SLICED_VBI_CAP` ioctl.
+:ref:`VIDIOC_G_SLICED_VBI_CAP <VIDIOC_G_SLICED_VBI_CAP>` ioctl.
 All drivers implementing the sliced VBI interface must support this
 ioctl. The results may differ from those of the
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl when the number of VBI
@@ -70,7 +70,7 @@ To determine the currently selected services applications set the
 ``type`` field of struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_SLICED_VBI_CAPTURE`` or
 ``V4L2_BUF_TYPE_SLICED_VBI_OUTPUT``, and the
-:ref:`VIDIOC_G_FMT` ioctl fills the ``fmt.sliced``
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl fills the ``fmt.sliced``
 member, a struct
 :ref:`v4l2_sliced_vbi_format <v4l2-sliced-vbi-format>`.
 
@@ -432,7 +432,7 @@ the :ref:`VIDIOC_QBUF` ioctl must return an EINVAL
 error code when applications violate this rule. They must also return an
 EINVAL error code when applications pass an incorrect field or line
 number, or a combination of ``field``, ``line`` and ``id`` which has not
-been negotiated with the :ref:`VIDIOC_G_FMT` or
+been negotiated with the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` or
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. When the line numbers are
 unknown the driver must pass the packets in transmitted order. The
 driver can insert empty packets with ``id`` set to zero anywhere in the
diff --git a/Documentation/linux_tv/media/v4l/diff-v4l.rst b/Documentation/linux_tv/media/v4l/diff-v4l.rst
index 06fdd877d77d..ee9623b454a4 100644
--- a/Documentation/linux_tv/media/v4l/diff-v4l.rst
+++ b/Documentation/linux_tv/media/v4l/diff-v4l.rst
@@ -204,7 +204,7 @@ introduction.
 
        -  ``-``
 
-       -  Applications can call the :ref:`VIDIOC_G_CROP`
+       -  Applications can call the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>`
           ioctl to determine if the device supports capturing a subsection
           of the full picture ("cropping" in V4L2). If not, the ioctl
           returns the EINVAL error code. For more information on cropping
@@ -248,7 +248,7 @@ introduction.
 The ``audios`` field was replaced by ``capabilities`` flag
 ``V4L2_CAP_AUDIO``, indicating *if* the device has any audio inputs or
 outputs. To determine their number applications can enumerate audio
-inputs with the :ref:`VIDIOC_G_AUDIO` ioctl. The
+inputs with the :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` ioctl. The
 audio ioctls are described in :ref:`audio`.
 
 The ``maxwidth``, ``maxheight``, ``minwidth`` and ``minheight`` fields
@@ -265,7 +265,7 @@ V4L provides the ``VIDIOCGCHAN`` and ``VIDIOCSCHAN`` ioctl using struct
 :c:type:`struct video_channel` to enumerate the video inputs of a V4L
 device. The equivalent V4L2 ioctls are
 :ref:`VIDIOC_ENUMINPUT`,
-:ref:`VIDIOC_G_INPUT` and
+:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
 :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` using struct
 :ref:`v4l2_input <v4l2-input>` as discussed in :ref:`video`.
 
@@ -328,7 +328,7 @@ Tuning
 The V4L ``VIDIOCGTUNER`` and ``VIDIOCSTUNER`` ioctl and struct
 :c:type:`struct video_tuner` can be used to enumerate the tuners of a
 V4L TV or radio device. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_G_TUNER` and
+:ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` and
 :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` using struct
 :ref:`v4l2_tuner <v4l2-tuner>`. Tuners are covered in :ref:`tuner`.
 
@@ -360,7 +360,7 @@ the struct :ref:`v4l2_tuner <v4l2-tuner>` ``capability`` field.
 
 The ``VIDIOCGFREQ`` and ``VIDIOCSFREQ`` ioctl to change the tuner
 frequency where renamed to
-:ref:`VIDIOC_G_FREQUENCY` and
+:ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
 :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>`. They take a pointer
 to a struct :ref:`v4l2_frequency <v4l2-frequency>` instead of an
 unsigned long integer.
@@ -375,7 +375,7 @@ V4L2 has no equivalent of the ``VIDIOCGPICT`` and ``VIDIOCSPICT`` ioctl
 and struct :c:type:`struct video_picture`. The following fields where
 replaced by V4L2 controls accessible with the
 :ref:`VIDIOC_QUERYCTRL`,
-:ref:`VIDIOC_G_CTRL` and
+:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls:
 
 
@@ -554,7 +554,7 @@ Audio
 The ``VIDIOCGAUDIO`` and ``VIDIOCSAUDIO`` ioctl and struct
 :c:type:`struct video_audio` are used to enumerate the audio inputs
 of a V4L device. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_G_AUDIO` and
+:ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
 :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>` using struct
 :ref:`v4l2_audio <v4l2-audio>` as discussed in :ref:`audio`.
 
@@ -577,7 +577,7 @@ stereo input, regardless if the source is a tuner.
 
 The following fields where replaced by V4L2 controls accessible with the
 :ref:`VIDIOC_QUERYCTRL`,
-:ref:`VIDIOC_G_CTRL` and
+:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls:
 
 
@@ -638,7 +638,7 @@ Frame Buffer Overlay
 ====================
 
 The V4L2 ioctls equivalent to ``VIDIOCGFBUF`` and ``VIDIOCSFBUF`` are
-:ref:`VIDIOC_G_FBUF` and
+:ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` and
 :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`. The ``base`` field of struct
 :c:type:`struct video_buffer` remained unchanged, except V4L2 defines
 a flag to indicate non-destructive overlays instead of a ``NULL``
@@ -650,7 +650,7 @@ list of RGB formats and their respective color depths.
 
 Instead of the special ioctls ``VIDIOCGWIN`` and ``VIDIOCSWIN`` V4L2
 uses the general-purpose data format negotiation ioctls
-:ref:`VIDIOC_G_FMT` and
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`. They take a pointer to a struct
 :ref:`v4l2_format <v4l2-format>` as argument. Here the ``win`` member
 of the ``fmt`` union is used, a struct
@@ -687,7 +687,7 @@ Cropping
 To capture only a subsection of the full picture V4L defines the
 ``VIDIOCGCAPTURE`` and ``VIDIOCSCAPTURE`` ioctls using struct
 :c:type:`struct video_capture`. The equivalent V4L2 ioctls are
-:ref:`VIDIOC_G_CROP` and
+:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
 :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` using struct
 :ref:`v4l2_crop <v4l2-crop>`, and the related
 :ref:`VIDIOC_CROPCAP` ioctl. This is a rather
@@ -726,7 +726,7 @@ functions.
 
 To select an image format and size, V4L provides the ``VIDIOCSPICT`` and
 ``VIDIOCSWIN`` ioctls. V4L2 uses the general-purpose data format
-negotiation ioctls :ref:`VIDIOC_G_FMT` and
+negotiation ioctls :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`. They take a pointer to a struct
 :ref:`v4l2_format <v4l2-format>` as argument, here the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` named ``pix`` of its
diff --git a/Documentation/linux_tv/media/v4l/dv-timings.rst b/Documentation/linux_tv/media/v4l/dv-timings.rst
index 4b22b1b0fccb..cde46bc95c79 100644
--- a/Documentation/linux_tv/media/v4l/dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/dv-timings.rst
@@ -29,7 +29,7 @@ device applications use the
 DV timings for the device applications use the
 :ref:`VIDIOC_S_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl and to get
 current DV timings they use the
-:ref:`VIDIOC_G_DV_TIMINGS` ioctl. To detect
+:ref:`VIDIOC_G_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl. To detect
 the DV timings as seen by the video receiver applications use the
 :ref:`VIDIOC_QUERY_DV_TIMINGS` ioctl.
 
diff --git a/Documentation/linux_tv/media/v4l/extended-controls.rst b/Documentation/linux_tv/media/v4l/extended-controls.rst
index 9a10edc50fa0..38b85d7b1022 100644
--- a/Documentation/linux_tv/media/v4l/extended-controls.rst
+++ b/Documentation/linux_tv/media/v4l/extended-controls.rst
@@ -39,11 +39,11 @@ The Extended Control API
 ========================
 
 Three new ioctls are available:
-:ref:`VIDIOC_G_EXT_CTRLS`,
+:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
 :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and
 :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`. These ioctls act
 on arrays of controls (as opposed to the
-:ref:`VIDIOC_G_CTRL` and
+:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls that act on a single
 control). This is needed since it is often required to atomically change
 several controls at once.
diff --git a/Documentation/linux_tv/media/v4l/format.rst b/Documentation/linux_tv/media/v4l/format.rst
index 0184b5931709..e9b1201fe316 100644
--- a/Documentation/linux_tv/media/v4l/format.rst
+++ b/Documentation/linux_tv/media/v4l/format.rst
@@ -23,7 +23,7 @@ current selection.
 
 A single mechanism exists to negotiate all data formats using the
 aggregate struct :ref:`v4l2_format <v4l2-format>` and the
-:ref:`VIDIOC_G_FMT` and
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls. Additionally the
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl can be used to examine
 what the hardware *could* do, without actually selecting a new data
@@ -64,7 +64,7 @@ earlier versions of V4L2. Switching the logical stream or returning into
 *may* support a switch using :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`.
 
 All drivers exchanging data with applications must support the
-:ref:`VIDIOC_G_FMT` and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. Implementation of the
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. Implementation of the
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` is highly recommended but optional.
 
 
diff --git a/Documentation/linux_tv/media/v4l/func-read.rst b/Documentation/linux_tv/media/v4l/func-read.rst
index 0eae26288189..497bc9a9dd5a 100644
--- a/Documentation/linux_tv/media/v4l/func-read.rst
+++ b/Documentation/linux_tv/media/v4l/func-read.rst
@@ -85,7 +85,7 @@ enough. Again, the behavior when the driver runs out of free buffers
 depends on the discarding policy.
 
 Applications can get and set the number of buffers used internally by
-the driver with the :ref:`VIDIOC_G_PARM` and
+the driver with the :ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and
 :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctls. They are optional,
 however. The discarding policy is not reported and cannot be changed.
 For minimum requirements see :ref:`devices`.
diff --git a/Documentation/linux_tv/media/v4l/hist-v4l2.rst b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
index 4bd621b3aa03..bb115a0f2427 100644
--- a/Documentation/linux_tv/media/v4l/hist-v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
@@ -40,7 +40,7 @@ enumerable.
 :c:type:`struct video_standard` and the color subcarrier fields were
 renamed. The :ref:`VIDIOC_QUERYSTD` ioctl was
 renamed to :ref:`VIDIOC_ENUMSTD`,
-:ref:`VIDIOC_G_INPUT` to
+:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` to
 :ref:`VIDIOC_ENUMINPUT`. A first draft of the
 Codec API was released.
 
@@ -52,7 +52,7 @@ material changes to struct :ref:`v4l2_capability <v4l2-capability>`.
 1998-11-14: ``V4L2_PIX_FMT_RGB24`` changed to ``V4L2_PIX_FMT_BGR24``,
 and ``V4L2_PIX_FMT_RGB32`` changed to ``V4L2_PIX_FMT_BGR32``. Audio
 controls are now accessible with the
-:ref:`VIDIOC_G_CTRL` and
+:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctls under names starting
 with ``V4L2_CID_AUDIO``. The ``V4L2_MAJOR`` define was removed from
 ``videodev.h`` since it was only used once in the ``videodev`` kernel
@@ -142,7 +142,7 @@ common Linux driver API conventions.
        int a = V4L2_XXX; err = ioctl(fd, VIDIOC_XXX, &a);
 
 4. All the different get- and set-format commands were swept into one
-   :ref:`VIDIOC_G_FMT` and
+   :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
    :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl taking a union and a
    type field selecting the union member as parameter. Purpose is to
    simplify the API by eliminating several ioctls and to allow new and
@@ -246,13 +246,13 @@ correctly through the backward compatibility layer. [Solution?]
 2001-04-13: Big endian 16-bit RGB formats were added.
 
 2001-09-17: New YUV formats and the
-:ref:`VIDIOC_G_FREQUENCY` and
+:ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
 :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctls were added.
 (The old ``VIDIOC_G_FREQ`` and ``VIDIOC_S_FREQ`` ioctls did not take
 multiple tuners into account.)
 
 2000-09-18: ``V4L2_BUF_TYPE_VBI`` was added. This may *break
-compatibility* as the :ref:`VIDIOC_G_FMT` and
+compatibility* as the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls may fail now if the struct
 :c:type:`struct v4l2_fmt` ``type`` field does not contain
 ``V4L2_BUF_TYPE_VBI``. In the documentation of the struct
@@ -401,7 +401,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     supported standards with an ioctl applications can now refer to
     standards by :ref:`v4l2_std_id <v4l2-std-id>` and symbols
     defined in the ``videodev2.h`` header file. For details see
-    :ref:`standard`. The :ref:`VIDIOC_G_STD` and
+    :ref:`standard`. The :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and
     :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` now take a pointer to this
     type as argument. :ref:`VIDIOC_QUERYSTD` was
     added to autodetect the received standard, if the hardware has this
@@ -716,14 +716,14 @@ V4L2 2003-06-19
 
 3. The audio input and output interface was found to be incomplete.
 
-   Previously the :ref:`VIDIOC_G_AUDIO` ioctl would
+   Previously the :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` ioctl would
    enumerate the available audio inputs. An ioctl to determine the
    current audio input, if more than one combines with the current video
    input, did not exist. So ``VIDIOC_G_AUDIO`` was renamed to
    ``VIDIOC_G_AUDIO_OLD``, this ioctl was removed on Kernel 2.6.39. The
    :ref:`VIDIOC_ENUMAUDIO` ioctl was added to
    enumerate audio inputs, while
-   :ref:`VIDIOC_G_AUDIO` now reports the current
+   :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` now reports the current
    audio input.
 
    The same changes were made to
@@ -940,7 +940,7 @@ V4L2 in Linux 2.6.17
 2. A new ``V4L2_TUNER_MODE_LANG1_LANG2`` was defined to record both
    languages of a bilingual program. The use of
    ``V4L2_TUNER_MODE_STEREO`` for this purpose is deprecated now. See
-   the :ref:`VIDIOC_G_TUNER` section for details.
+   the :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` section for details.
 
 
 V4L2 spec erratum 2006-09-23 (Draft 0.15)
@@ -950,13 +950,13 @@ V4L2 spec erratum 2006-09-23 (Draft 0.15)
    ``V4L2_BUF_TYPE_SLICED_VBI_OUTPUT`` of the sliced VBI interface were
    not mentioned along with other buffer types.
 
-2. In :ref:`VIDIOC_G_AUDIO` it was clarified that the struct
+2. In :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` it was clarified that the struct
    :ref:`v4l2_audio <v4l2-audio>` ``mode`` field is a flags field.
 
 3. :ref:`VIDIOC_QUERYCAP` did not mention the sliced VBI and radio
    capability flags.
 
-4. In :ref:`VIDIOC_G_FREQUENCY` it was clarified that applications
+4. In :ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` it was clarified that applications
    must initialize the tuner ``type`` field of struct
    :ref:`v4l2_frequency <v4l2-frequency>` before calling
    :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>`.
@@ -976,7 +976,7 @@ V4L2 spec erratum 2006-09-23 (Draft 0.15)
 V4L2 in Linux 2.6.18
 ====================
 
-1. New ioctls :ref:`VIDIOC_G_EXT_CTRLS`,
+1. New ioctls :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
    :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` and
    :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` were added, a
    flag to skip unsupported controls with
@@ -995,7 +995,7 @@ V4L2 in Linux 2.6.19
    buffer type field was added replacing a reserved field. Note on
    architectures where the size of enum types differs from int types the
    size of the structure changed. The
-   :ref:`VIDIOC_G_SLICED_VBI_CAP` ioctl
+   :ref:`VIDIOC_G_SLICED_VBI_CAP <VIDIOC_G_SLICED_VBI_CAP>` ioctl
    was redefined from being read-only to write-read. Applications must
    initialize the type field and clear the reserved fields now. These
    changes may *break the compatibility* with older drivers and
@@ -1034,7 +1034,7 @@ V4L2 in Linux 2.6.22
 
 2. Three new clipping/blending methods with a global or straight or
    inverted local alpha value were added to the video overlay interface.
-   See the description of the :ref:`VIDIOC_G_FBUF`
+   See the description of the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`
    and :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctls for details.
 
    A new ``global_alpha`` field was added to
diff --git a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
index bc3eb48e1d9f..b8d247dc236d 100644
--- a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
+++ b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
@@ -92,7 +92,7 @@ and to enhance the image quality.
 In most cases, libv4l2 just passes the calls directly through to the
 v4l2 driver, intercepting the calls to
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`,
-:ref:`VIDIOC_G_FMT`
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 :ref:`VIDIOC_ENUM_FRAMESIZES` and
 :ref:`VIDIOC_ENUM_FRAMEINTERVALS` in
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-013.rst b/Documentation/linux_tv/media/v4l/pixfmt-013.rst
index 7584cb2e5702..b3cb7c48eb74 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-013.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-013.rst
@@ -27,7 +27,7 @@ Compressed Formats
 
        -  'JPEG'
 
-       -  TBD. See also :ref:`VIDIOC_G_JPEGCOMP`,
+       -  TBD. See also :ref:`VIDIOC_G_JPEGCOMP <VIDIOC_G_JPEGCOMP>`,
           :ref:`VIDIOC_S_JPEGCOMP <VIDIOC_G_JPEGCOMP>`.
 
     -  .. _`V4L2-PIX-FMT-MPEG`:
diff --git a/Documentation/linux_tv/media/v4l/pixfmt.rst b/Documentation/linux_tv/media/v4l/pixfmt.rst
index b0e6a95a7205..f2c599aaa502 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt.rst
@@ -13,7 +13,7 @@ single-planar API, while the latter is used with the multi-planar
 version (see :ref:`planar-apis`). Image formats are negotiated with
 the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl. (The explanations here
 focus on video capturing and output, for overlay frame buffer formats
-see also :ref:`VIDIOC_G_FBUF`.)
+see also :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`.)
 
 
 .. toctree::
diff --git a/Documentation/linux_tv/media/v4l/planar-apis.rst b/Documentation/linux_tv/media/v4l/planar-apis.rst
index 0546210f868f..cf078650a0a8 100644
--- a/Documentation/linux_tv/media/v4l/planar-apis.rst
+++ b/Documentation/linux_tv/media/v4l/planar-apis.rst
@@ -44,7 +44,7 @@ Calls that distinguish between single and multi-planar APIs
     together with non-multi-planar ones for devices that handle both
     single- and multi-planar formats.
 
-:ref:`VIDIOC_G_FMT`,
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`,
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`,
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`
     New structures for describing multi-planar formats are added: struct
diff --git a/Documentation/linux_tv/media/v4l/standard.rst b/Documentation/linux_tv/media/v4l/standard.rst
index ec39b2b39e67..20c0d044a129 100644
--- a/Documentation/linux_tv/media/v4l/standard.rst
+++ b/Documentation/linux_tv/media/v4l/standard.rst
@@ -36,7 +36,7 @@ Composite input may collapse standards, enumerating "PAL-B/G/H/I",
 "NTSC-M" and "SECAM-D/K". [1]_
 
 To query and select the standard used by the current video input or
-output applications call the :ref:`VIDIOC_G_STD` and
+output applications call the :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` ioctl, respectively. The
 *received* standard can be sensed with the
 :ref:`VIDIOC_QUERYSTD` ioctl. Note that the
@@ -56,7 +56,7 @@ output device which is:
 
 Here the driver shall set the ``std`` field of struct
 :ref:`v4l2_input <v4l2-input>` and struct
-:ref:`v4l2_output <v4l2-output>` to zero and the :ref:`VIDIOC_G_STD`,
+:ref:`v4l2_output <v4l2-output>` to zero and the :ref:`VIDIOC_G_STD <VIDIOC_G_STD>`,
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>`, :ref:`VIDIOC_QUERYSTD` and :ref:`VIDIOC_ENUMSTD` ioctls
 shall return the ENOTTY error code or the EINVAL error code.
 
diff --git a/Documentation/linux_tv/media/v4l/streaming-par.rst b/Documentation/linux_tv/media/v4l/streaming-par.rst
index 10420478a3b0..bb8100b6ef87 100644
--- a/Documentation/linux_tv/media/v4l/streaming-par.rst
+++ b/Documentation/linux_tv/media/v4l/streaming-par.rst
@@ -23,7 +23,7 @@ internally by a driver in read/write mode. For implications see the
 section discussing the :ref:`read() <func-read>` function.
 
 To get and set the streaming parameters applications call the
-:ref:`VIDIOC_G_PARM` and
+:ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and
 :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl, respectively. They take
 a pointer to a struct :ref:`v4l2_streamparm <v4l2-streamparm>`, which
 contains a union holding separate parameters for input and output
diff --git a/Documentation/linux_tv/media/v4l/tuner.rst b/Documentation/linux_tv/media/v4l/tuner.rst
index 67f4e24709b5..9c98e4f64c85 100644
--- a/Documentation/linux_tv/media/v4l/tuner.rst
+++ b/Documentation/linux_tv/media/v4l/tuner.rst
@@ -22,9 +22,9 @@ Radio input devices have exactly one tuner with index zero, no video
 inputs.
 
 To query and change tuner properties applications use the
-:ref:`VIDIOC_G_TUNER` and
+:ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` and
 :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` ioctls, respectively. The
-struct :ref:`v4l2_tuner <v4l2-tuner>` returned by :ref:`VIDIOC_G_TUNER`
+struct :ref:`v4l2_tuner <v4l2-tuner>` returned by :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>`
 also contains signal status information applicable when the tuner of the
 current video or radio input is queried. Note that :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>`
 does not switch the current tuner, when there is more than one at all.
@@ -59,7 +59,7 @@ functionality. The reason is a limitation with the
 cannot specify whether the frequency is for a tuner or a modulator.
 
 To query and change modulator properties applications use the
-:ref:`VIDIOC_G_MODULATOR` and
+:ref:`VIDIOC_G_MODULATOR <VIDIOC_G_MODULATOR>` and
 :ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` ioctl. Note that
 :ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` does not switch the current modulator, when there
 is more than one at all. The modulator is solely determined by the
@@ -74,7 +74,7 @@ Radio Frequency
 ===============
 
 To get and set the tuner or modulator radio frequency applications use
-the :ref:`VIDIOC_G_FREQUENCY` and
+the :ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` and
 :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl which both take
 a pointer to a struct :ref:`v4l2_frequency <v4l2-frequency>`. These
 ioctls are used for TV and radio devices alike. Drivers must support
diff --git a/Documentation/linux_tv/media/v4l/video.rst b/Documentation/linux_tv/media/v4l/video.rst
index 9f2dc4ee4fcd..8e10ecc27123 100644
--- a/Documentation/linux_tv/media/v4l/video.rst
+++ b/Documentation/linux_tv/media/v4l/video.rst
@@ -20,8 +20,8 @@ struct :ref:`v4l2_input <v4l2-input>` returned by the
 :ref:`VIDIOC_ENUMINPUT` ioctl also contains signal
 :status information applicable when the current video input is queried.
 
-The :ref:`VIDIOC_G_INPUT` and
-:ref:`VIDIOC_G_OUTPUT` ioctls return the index of
+The :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
+:ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` ioctls return the index of
 the current video input or output. To select a different input or output
 applications call the :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` and
 :ref:`VIDIOC_S_OUTPUT <VIDIOC_G_OUTPUT>` ioctls. Drivers must
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
index d269eab4d2b6..53db867aa9db 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
@@ -48,7 +48,7 @@ The ``format`` field specifies the image format that the buffers must be
 able to handle. The application has to fill in this struct
 :ref:`v4l2_format <v4l2-format>`. Usually this will be done using the
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` or
-:ref:`VIDIOC_G_FMT` ioctls to ensure that the
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctls to ensure that the
 requested format is supported by the driver. Based on the format's
 ``type`` field the requested buffer size (for single-planar) or plane
 sizes (for multi-planar formats) will be used for the allocated buffers.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
index 0fc0c3eeae5f..8ae7b8bd9333 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
@@ -39,7 +39,7 @@ structure or return an EINVAL error code when the index is out of
 bounds. To enumerate all audio inputs applications shall begin at index
 zero, incrementing by one until the driver returns EINVAL.
 
-See :ref:`VIDIOC_G_AUDIO` for a description of struct
+See :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` for a description of struct
 :ref:`v4l2_audio <v4l2-audio>`.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
index 29735eddac5d..0e45f41fa608 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
@@ -42,7 +42,7 @@ zero, incrementing by one until the driver returns EINVAL.
 Note connectors on a TV card to loop back the received audio signal to a
 sound card are not audio outputs in this sense.
 
-See :ref:`VIDIOC_G_AUDIOout` for a description of struct
+See :ref:`VIDIOC_G_AUDIOout <VIDIOC_G_AUDIOout>` for a description of struct
 :ref:`v4l2_audioout <v4l2-audioout>`.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
index e292b7d50cc3..03353b92449a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
@@ -401,7 +401,7 @@ ENODATA
 
 .. [1]
    The supported standards may overlap and we need an unambiguous set to
-   find the current standard returned by :ref:`VIDIOC_G_STD`.
+   find the current standard returned by :ref:`VIDIOC_G_STD <VIDIOC_G_STD>`.
 
 .. [2]
    Japan uses a standard similar to M/NTSC (V4L2_STD_NTSC_M_JP).
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
index be8899d87e33..4b79523bfbab 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
@@ -36,7 +36,7 @@ Description
 
 To query the current audio input applications zero out the ``reserved``
 array of a struct :ref:`v4l2_audio <v4l2-audio>` and call the
-:ref:`VIDIOC_G_AUDIO` ioctl with a pointer to this structure. Drivers fill
+:ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` ioctl with a pointer to this structure. Drivers fill
 the rest of the structure or return an EINVAL error code when the device
 has no audio inputs, or none which combine with the current video input.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
index 0a9ede92bc9f..b0503710c2dd 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
@@ -36,7 +36,7 @@ Description
 
 To query the cropping rectangle size and position applications set the
 ``type`` field of a :c:type:`struct v4l2_crop` structure to the
-respective buffer (stream) type and call the :ref:`VIDIOC_G_CROP` ioctl
+respective buffer (stream) type and call the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` ioctl
 with a pointer to this structure. The driver fills the rest of the
 structure or returns the EINVAL error code if cropping is not supported.
 
@@ -66,7 +66,7 @@ vertical scaling factor.
 Finally the driver programs the hardware with the actual cropping and
 image parameters. :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` is a write-only ioctl, it does not
 return the actual parameters. To query them applications must call
-:ref:`VIDIOC_G_CROP` and :ref:`VIDIOC_G_FMT`. When the
+:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and :ref:`VIDIOC_G_FMT`. When the
 parameters are unsuitable the application may modify the cropping or
 image parameters and repeat the cycle until satisfactory parameters have
 been negotiated.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
index 41561c5e444d..55bb8ae9be10 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
@@ -34,7 +34,7 @@ Description
 
 To get the current value of a control applications initialize the ``id``
 field of a struct :c:type:`struct v4l2_control` and call the
-:ref:`VIDIOC_G_CTRL` ioctl with a pointer to this structure. To change the
+:ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` ioctl with a pointer to this structure. To change the
 value of a control applications initialize the ``id`` and ``value``
 fields of a struct :c:type:`struct v4l2_control` and call the
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctl.
@@ -48,7 +48,7 @@ actual new value. If the ``value`` is inappropriate for the control
 EINVAL error code is returned as well.
 
 These ioctls work only with user controls. For other control classes the
-:ref:`VIDIOC_G_EXT_CTRLS`,
+:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`,
 :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` or
 :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` must be used.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
index cc7cf06e74ee..43734bb649c5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
@@ -37,7 +37,7 @@ Description
 
 To set DV timings for the input or output, applications use the
 :ref:`VIDIOC_S_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl and to get the current timings,
-applications use the :ref:`VIDIOC_G_DV_TIMINGS` ioctl. The detailed timing
+applications use the :ref:`VIDIOC_G_DV_TIMINGS <VIDIOC_G_DV_TIMINGS>` ioctl. The detailed timing
 information is filled in using the structure struct
 :ref:`v4l2_dv_timings <v4l2-dv-timings>`. These ioctls take a
 pointer to the struct :ref:`v4l2_dv_timings <v4l2-dv-timings>`
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
index a1311a52b8fa..d6ccae92e107 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
@@ -52,7 +52,7 @@ value, then the EINVAL error code will be returned.
 
 To get the EDID data the application has to fill in the ``pad``,
 ``start_block``, ``blocks`` and ``edid`` fields, zero the ``reserved``
-array and call :ref:`VIDIOC_G_EDID`. The current EDID from block
+array and call :ref:`VIDIOC_G_EDID <VIDIOC_G_EDID>`. The current EDID from block
 ``start_block`` and of size ``blocks`` will be placed in the memory
 ``edid`` points to. The ``edid`` pointer must point to memory at least
 ``blocks`` * 128 bytes large (the size of one block is 128 bytes).
@@ -65,7 +65,7 @@ If blocks have to be retrieved from the sink, then this call will block
 until they have been read.
 
 If ``start_block`` and ``blocks`` are both set to 0 when
-:ref:`VIDIOC_G_EDID` is called, then the driver will set ``blocks`` to the
+:ref:`VIDIOC_G_EDID <VIDIOC_G_EDID>` is called, then the driver will set ``blocks`` to the
 total number of available EDID blocks and it will return 0 without
 copying any data. This is an easy way to discover how many EDID blocks
 there are. Note that if there are no EDID blocks available at all, then
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
index 77c7eff9732d..c22907cddfac 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-enc-index.rst
@@ -31,19 +31,19 @@ Arguments
 Description
 ===========
 
-The :ref:`VIDIOC_G_ENC_INDEX` ioctl provides meta data about a compressed
+The :ref:`VIDIOC_G_ENC_INDEX <VIDIOC_G_ENC_INDEX>` ioctl provides meta data about a compressed
 video stream the same or another application currently reads from the
 driver, which is useful for random access into the stream without
 decoding it.
 
-To read the data applications must call :ref:`VIDIOC_G_ENC_INDEX` with a
+To read the data applications must call :ref:`VIDIOC_G_ENC_INDEX <VIDIOC_G_ENC_INDEX>` with a
 pointer to a struct :ref:`v4l2_enc_idx <v4l2-enc-idx>`. On success
 the driver fills the ``entry`` array, stores the number of elements
 written in the ``entries`` field, and initializes the ``entries_cap``
 field.
 
 Each element of the ``entry`` array contains meta data about one
-picture. A :ref:`VIDIOC_G_ENC_INDEX` call reads up to
+picture. A :ref:`VIDIOC_G_ENC_INDEX <VIDIOC_G_ENC_INDEX>` call reads up to
 ``V4L2_ENC_IDX_ENTRIES`` entries from a driver buffer, which can hold up
 to ``entries_cap`` entries. This number can be lower or higher than
 ``V4L2_ENC_IDX_ENTRIES``, but not zero. When the application fails to
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
index fb62cd0a991c..040deef04f7d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
@@ -48,7 +48,7 @@ by the ``controls`` fields.
 To get the current value of a set of controls applications initialize
 the ``id``, ``size`` and ``reserved2`` fields of each struct
 :ref:`v4l2_ext_control <v4l2-ext-control>` and call the
-:ref:`VIDIOC_G_EXT_CTRLS` ioctl. String controls controls must also set the
+:ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` ioctl. String controls controls must also set the
 ``string`` field. Controls of compound types
 (``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is set) must set the ``ptr`` field.
 
@@ -122,7 +122,7 @@ still cause this situation.
        -  The total size in bytes of the payload of this control. This is
           normally 0, but for pointer controls this should be set to the
           size of the memory containing the payload, or that will receive
-          the payload. If :ref:`VIDIOC_G_EXT_CTRLS` finds that this value is
+          the payload. If :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` finds that this value is
           less than is required to store the payload result, then it is set
           to a value large enough to store the payload result and ENOSPC is
           returned. Note that for string controls this ``size`` field should
@@ -328,7 +328,7 @@ still cause this situation.
           :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` fails with ``error_idx`` set to ``count``,
           then you can call :ref:`VIDIOC_TRY_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` to try to discover the
           actual control that failed the validation step. Unfortunately,
-          there is no ``TRY`` equivalent for :ref:`VIDIOC_G_EXT_CTRLS`.
+          there is no ``TRY`` equivalent for :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>`.
 
     -  .. row 6
 
@@ -367,7 +367,7 @@ still cause this situation.
        -  The class containing user controls. These controls are described
           in :ref:`control`. All controls that can be set using the
           :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` and
-          :ref:`VIDIOC_G_CTRL` ioctl belong to this
+          :ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` ioctl belong to this
           class.
 
     -  .. row 2
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
index e622e2f2435c..dbc68cfc608a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
@@ -34,7 +34,7 @@ Arguments
 Description
 ===========
 
-Applications can use the :ref:`VIDIOC_G_FBUF` and :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctl
+Applications can use the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` and :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` ioctl
 to get and set the framebuffer parameters for a
 :ref:`Video Overlay <overlay>` or :ref:`Video Output Overlay <osd>`
 (OSD). The type of overlay is implied by the device type (capture or
@@ -48,7 +48,7 @@ of a graphics card. A non-destructive overlay blends video images into a
 VGA signal or graphics into a video signal. *Video Output Overlays* are
 always non-destructive.
 
-To get the current parameters applications call the :ref:`VIDIOC_G_FBUF`
+To get the current parameters applications call the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`
 ioctl with a pointer to a :c:type:`struct v4l2_framebuffer`
 structure. The driver fills all fields of the structure or returns an
 EINVAL error code when overlays are not supported.
@@ -59,13 +59,13 @@ initialize the ``flags`` field of a struct
 implemented on the TV card all other parameters are determined by the
 driver. When an application calls :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` with a pointer to
 this structure, the driver prepares for the overlay and returns the
-framebuffer parameters as :ref:`VIDIOC_G_FBUF` does, or it returns an error
+framebuffer parameters as :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` does, or it returns an error
 code.
 
 To set the parameters for a *non-destructive Video Overlay*,
 applications must initialize the ``flags`` field, the ``fmt``
 substructure, and call :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`. Again the driver prepares for
-the overlay and returns the framebuffer parameters as :ref:`VIDIOC_G_FBUF`
+the overlay and returns the framebuffer parameters as :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`
 does, or it returns an error code.
 
 For a *destructive Video Overlay* applications must additionally provide
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
index 8c07fe2454e2..3ac4fb764a7e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
@@ -41,7 +41,7 @@ struct :c:type:`struct v4l2_format` to the respective buffer (stream)
 type. For example video capture devices use
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``. When the application calls the
-:ref:`VIDIOC_G_FMT` ioctl with a pointer to this structure the driver fills
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl with a pointer to this structure the driver fills
 the respective member of the ``fmt`` union. In case of video capture
 devices that is either the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
@@ -62,10 +62,10 @@ this is a mechanism to fathom device capabilities and to approach
 parameters acceptable for both the application and driver. On success
 the driver may program the hardware, allocate resources and generally
 prepare for data exchange. Finally the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl returns
-the current format parameters as :ref:`VIDIOC_G_FMT` does. Very simple,
+the current format parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does. Very simple,
 inflexible devices may even ignore all input and always return the
 default parameters. However all V4L2 devices exchanging data with the
-application must implement the :ref:`VIDIOC_G_FMT` and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
+application must implement the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
 ioctl. When the requested buffer type is not supported drivers return an
 EINVAL error code on a :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` attempt. When I/O is already in
 progress or the resource is not available for other reasons drivers
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
index 19a5ae9c4bcd..b187f1345bb4 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-frequency.rst
@@ -39,7 +39,7 @@ the ``tuner`` field of a struct
 :ref:`v4l2_frequency <v4l2-frequency>` to the respective tuner or
 modulator number (only input devices have tuners, only output devices
 have modulators), zero out the ``reserved`` array and call the
-:ref:`VIDIOC_G_FREQUENCY` ioctl with a pointer to this structure. The
+:ref:`VIDIOC_G_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl with a pointer to this structure. The
 driver stores the current frequency in the ``frequency`` field.
 
 To change the current tuner or modulator radio frequency applications
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
index 2bcaa324aa33..bb5944449650 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
@@ -33,7 +33,7 @@ Description
 ===========
 
 To query the current video input applications call the
-:ref:`VIDIOC_G_INPUT` ioctl with a pointer to an integer where the driver
+:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` ioctl with a pointer to an integer where the driver
 stores the number of the input, as in the struct
 :ref:`v4l2_input <v4l2-input>` ``index`` field. This ioctl will fail
 only when there are no video inputs, returning EINVAL.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
index 83e761eaef2b..913b7d96faba 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
@@ -37,7 +37,7 @@ Description
 To query the attributes of a modulator applications initialize the
 ``index`` field and zero out the ``reserved`` array of a struct
 :ref:`v4l2_modulator <v4l2-modulator>` and call the
-:ref:`VIDIOC_G_MODULATOR` ioctl with a pointer to this structure. Drivers
+:ref:`VIDIOC_G_MODULATOR <VIDIOC_G_MODULATOR>` ioctl with a pointer to this structure. Drivers
 fill the rest of the structure or return an EINVAL error code when the
 index is out of bounds. To enumerate all modulators applications shall
 begin at index zero, incrementing by one until the driver returns
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
index ebed04ae48da..e48bf39cfa10 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
@@ -33,7 +33,7 @@ Description
 ===========
 
 To query the current video output applications call the
-:ref:`VIDIOC_G_OUTPUT` ioctl with a pointer to an integer where the driver
+:ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` ioctl with a pointer to an integer where the driver
 stores the number of the output, as in the struct
 :ref:`v4l2_output <v4l2-output>` ``index`` field. This ioctl will
 fail only when there are no video outputs, returning the EINVAL error
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
index 906faaa85bfa..0567fce18144 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
@@ -44,7 +44,7 @@ internally by a driver in read/write mode. For implications see the
 section discussing the :ref:`read() <func-read>` function.
 
 To get and set the streaming parameters applications call the
-:ref:`VIDIOC_G_PARM` and :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl, respectively. They take a
+:ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl, respectively. They take a
 pointer to a struct :c:type:`struct v4l2_streamparm` which contains a
 union holding separate parameters for input and output devices.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
index db95647d3a80..b241970c8aee 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-priority.rst
@@ -36,7 +36,7 @@ Description
 ===========
 
 To query the current access priority applications call the
-:ref:`VIDIOC_G_PRIORITY` ioctl with a pointer to an enum v4l2_priority
+:ref:`VIDIOC_G_PRIORITY <VIDIOC_G_PRIORITY>` ioctl with a pointer to an enum v4l2_priority
 variable where the driver stores the current priority.
 
 To request an access priority applications store the desired priority in
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
index 635cb9b2c250..a051f93252d0 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -34,7 +34,7 @@ Description
 To find out which data services are supported by a sliced VBI capture or
 output device, applications initialize the ``type`` field of a struct
 :ref:`v4l2_sliced_vbi_cap <v4l2-sliced-vbi-cap>`, clear the
-``reserved`` array and call the :ref:`VIDIOC_G_SLICED_VBI_CAP` ioctl. The
+``reserved`` array and call the :ref:`VIDIOC_G_SLICED_VBI_CAP <VIDIOC_G_SLICED_VBI_CAP>` ioctl. The
 driver fills in the remaining fields or returns an EINVAL error code if
 the sliced VBI API is unsupported or ``type`` is invalid.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
index bc8e071401b0..a7257f0b38a2 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
@@ -35,15 +35,15 @@ Description
 ===========
 
 To query and select the current video standard applications use the
-:ref:`VIDIOC_G_STD` and :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` ioctls which take a pointer to a
-:ref:`v4l2_std_id <v4l2-std-id>` type as argument. :ref:`VIDIOC_G_STD`
+:ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` ioctls which take a pointer to a
+:ref:`v4l2_std_id <v4l2-std-id>` type as argument. :ref:`VIDIOC_G_STD <VIDIOC_G_STD>`
 can return a single flag or a set of flags as in struct
 :ref:`v4l2_standard <v4l2-standard>` field ``id``. The flags must be
 unambiguous such that they appear in only one enumerated
 :c:type:`struct v4l2_standard` structure.
 
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` accepts one or more flags, being a write-only ioctl it
-does not return the actual new standard as :ref:`VIDIOC_G_STD` does. When
+does not return the actual new standard as :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` does. When
 no flags are given or the current input does not support the requested
 standard the driver returns an EINVAL error code. When the standard set
 is ambiguous drivers may return EINVAL or choose any of the requested
diff --git a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
index 2b11efc3d257..7d38a51c4f73 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
@@ -569,7 +569,7 @@ See also the examples in :ref:`control`.
           :ref:`VIDIOC_S_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` you need to
           set the ``size`` field of struct
           :ref:`v4l2_ext_control <v4l2-ext-control>` to 9. For
-          :ref:`VIDIOC_G_EXT_CTRLS` you can set
+          :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` you can set
           the ``size`` field to ``maximum`` + 1. Which character encoding is
           used will depend on the string control itself and should be part
           of the control documentation.
-- 
2.7.4


