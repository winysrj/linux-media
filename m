Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbcGDLr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 29/51] Documentation: linux_tv: use references for structures
Date: Mon,  4 Jul 2016 08:46:50 -0300
Message-Id: <9821c734011846060c2839b1428fef5009599bec.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On several places, instead of using references, the code was
using some other tag. Not sure if this was due to the conversion,
or if something were already wrong on the DocBook. In any case,
let's fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/buffer.rst             | 12 ++++++------
 Documentation/linux_tv/media/v4l/dev-osd.rst            |  2 +-
 Documentation/linux_tv/media/v4l/dev-overlay.rst        |  2 +-
 Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst     |  6 +++---
 Documentation/linux_tv/media/v4l/extended-controls.rst  |  2 +-
 Documentation/linux_tv/media/v4l/func-poll.rst          |  2 +-
 Documentation/linux_tv/media/v4l/func-select.rst        |  2 +-
 Documentation/linux_tv/media/v4l/pixfmt-002.rst         |  4 ++--
 Documentation/linux_tv/media/v4l/pixfmt-003.rst         |  6 +++---
 Documentation/linux_tv/media/v4l/pixfmt.rst             |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-enumstd.rst     |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-audio.rst     |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst  |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst      |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst      |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst      |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst       |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst      |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst       |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst     |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst        |  4 ++--
 Documentation/linux_tv/media/v4l/vidioc-querybuf.rst    |  2 +-
 Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst     |  2 +-
 25 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/buffer.rst b/Documentation/linux_tv/media/v4l/buffer.rst
index b535177724b9..1c6c96c37155 100644
--- a/Documentation/linux_tv/media/v4l/buffer.rst
+++ b/Documentation/linux_tv/media/v4l/buffer.rst
@@ -11,14 +11,14 @@ the Streaming I/O methods. In the multi-planar API, the data is held in
 planes, while the buffer structure acts as a container for the planes.
 Only pointers to buffers (planes) are exchanged, the data itself is not
 copied. These pointers, together with meta-information like timestamps
-or field parity, are stored in a struct :c:type:`struct v4l2_buffer`,
+or field parity, are stored in a struct :ref:`struct v4l2_buffer <v4l2-buffer>`,
 argument to the :ref:`VIDIOC_QUERYBUF`,
 :ref:`VIDIOC_QBUF` and
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. In the multi-planar API,
-some plane-specific members of struct :c:type:`struct v4l2_buffer`,
+some plane-specific members of struct :ref:`struct v4l2_buffer <v4l2-buffer>`,
 such as pointers and sizes for each plane, are stored in struct
-:c:type:`struct v4l2_plane` instead. In that case, struct
-:c:type:`struct v4l2_buffer` contains an array of plane structures.
+:ref:`struct v4l2_plane <v4l2-plane>` instead. In that case, struct
+:ref:`struct v4l2_buffer <v4l2-buffer>` contains an array of plane structures.
 
 Dequeued video buffers come with timestamps. The driver decides at which
 part of the frame and with which clock the timestamp is taken. Please
@@ -221,7 +221,7 @@ buffer.
        -  When using the multi-planar API, contains a userspace pointer to
           an array of struct :ref:`v4l2_plane <v4l2-plane>`. The size of
           the array should be put in the ``length`` field of this
-          :c:type:`struct v4l2_buffer` structure.
+          :ref:`struct v4l2_buffer <v4l2-buffer>` structure.
 
     -  .. row 15
 
@@ -780,7 +780,7 @@ buffer.
 Timecodes
 =========
 
-The :c:type:`struct v4l2_timecode` structure is designed to hold a
+The :ref:`struct v4l2_timecode <v4l2-timecode>` structure is designed to hold a
 :ref:`smpte12m` or similar timecode. (struct
 :c:type:`struct timeval` timestamps are stored in struct
 :ref:`v4l2_buffer <v4l2-buffer>` field ``timestamp``.)
diff --git a/Documentation/linux_tv/media/v4l/dev-osd.rst b/Documentation/linux_tv/media/v4l/dev-osd.rst
index f9337001f50d..8b05e3f0587d 100644
--- a/Documentation/linux_tv/media/v4l/dev-osd.rst
+++ b/Documentation/linux_tv/media/v4l/dev-osd.rst
@@ -116,7 +116,7 @@ parameters applications set the ``type`` field of a struct
 :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY`` and call the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
-:c:type:`struct v4l2_window` substructure named ``win``. It is not
+:ref:`struct v4l2_window <v4l2-window>` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
 To program the source rectangle applications set the ``type`` field of a
diff --git a/Documentation/linux_tv/media/v4l/dev-overlay.rst b/Documentation/linux_tv/media/v4l/dev-overlay.rst
index fc71406369a8..dd786b6fc936 100644
--- a/Documentation/linux_tv/media/v4l/dev-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/dev-overlay.rst
@@ -122,7 +122,7 @@ To get the current parameters applications set the ``type`` field of a
 struct :ref:`v4l2_format <v4l2-format>` to
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY`` and call the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
-:c:type:`struct v4l2_window` substructure named ``win``. It is not
+:ref:`struct v4l2_window <v4l2-window>` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
 To program the overlay window applications set the ``type`` field of a
diff --git a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
index b3e89f93d6ad..0b299b51aceb 100644
--- a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
@@ -77,7 +77,7 @@ member, a struct
 Applications can request different parameters by initializing or
 modifying the ``fmt.sliced`` member and calling the
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl with a pointer to the
-:c:type:`struct v4l2_format` structure.
+:ref:`struct v4l2_format <v4l2-format>` structure.
 
 The sliced VBI API is more complicated than the raw VBI API because the
 hardware must be told which VBI service to expect on each scan line. Not
@@ -353,11 +353,11 @@ Reading and writing sliced VBI data
 
 A single :ref:`read() <func-read>` or :ref:`write() <func-write>`
 call must pass all data belonging to one video frame. That is an array
-of :c:type:`struct v4l2_sliced_vbi_data` structures with one or
+of :ref:`struct v4l2_sliced_vbi_data <v4l2-sliced-vbi-data>` structures with one or
 more elements and a total size not exceeding ``io_size`` bytes. Likewise
 in streaming I/O mode one buffer of ``io_size`` bytes must contain data
 of one video frame. The ``id`` of unused
-:c:type:`struct v4l2_sliced_vbi_data` elements must be zero.
+:ref:`struct v4l2_sliced_vbi_data <v4l2-sliced-vbi-data>` elements must be zero.
 
 
 .. _v4l2-sliced-vbi-data:
diff --git a/Documentation/linux_tv/media/v4l/extended-controls.rst b/Documentation/linux_tv/media/v4l/extended-controls.rst
index d5efb5bbf5bf..50598b479273 100644
--- a/Documentation/linux_tv/media/v4l/extended-controls.rst
+++ b/Documentation/linux_tv/media/v4l/extended-controls.rst
@@ -66,7 +66,7 @@ whether the specified control class is supported.
 
 The control array is a struct
 :ref:`v4l2_ext_control <v4l2-ext-control>` array. The
-:c:type:`struct v4l2_ext_control` structure is very similar to
+:ref:`struct v4l2_ext_control <v4l2-ext-control>` structure is very similar to
 struct :ref:`v4l2_control <v4l2-control>`, except for the fact that
 it also allows for 64-bit values and pointers to be passed.
 
diff --git a/Documentation/linux_tv/media/v4l/func-poll.rst b/Documentation/linux_tv/media/v4l/func-poll.rst
index 2de7f8a3a971..3e96d9b0ce38 100644
--- a/Documentation/linux_tv/media/v4l/func-poll.rst
+++ b/Documentation/linux_tv/media/v4l/func-poll.rst
@@ -39,7 +39,7 @@ returns immediately.
 
 On success :c:func:`poll()` returns the number of file descriptors
 that have been selected (that is, file descriptors for which the
-``revents`` field of the respective :c:type:`struct pollfd` structure
+``revents`` field of the respective :c:func:`struct pollfd` structure
 is non-zero). Capture devices set the ``POLLIN`` and ``POLLRDNORM``
 flags in the ``revents`` field, output devices the ``POLLOUT`` and
 ``POLLWRNORM`` flags. When the function timed out it returns a value of
diff --git a/Documentation/linux_tv/media/v4l/func-select.rst b/Documentation/linux_tv/media/v4l/func-select.rst
index 56d01b33e25d..de5583c4ffb3 100644
--- a/Documentation/linux_tv/media/v4l/func-select.rst
+++ b/Documentation/linux_tv/media/v4l/func-select.rst
@@ -36,7 +36,7 @@ buffer has been filled or displayed and can be dequeued with the
 the outgoing queue of the driver the function returns immediately.
 
 On success :c:func:`select()` returns the total number of bits set in
-the :c:type:`struct fd_set`s. When the function timed out it returns
+:c:func:`struct fd_set`. When the function timed out it returns
 a value of zero. On failure it returns -1 and the ``errno`` variable is
 set appropriately. When the application did not call
 :ref:`VIDIOC_QBUF` or
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-002.rst b/Documentation/linux_tv/media/v4l/pixfmt-002.rst
index d72c36552c4e..a0c8c2298bdd 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-002.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-002.rst
@@ -133,7 +133,7 @@ Single-planar format structure
        -  ``priv``
 
        -  This field indicates whether the remaining fields of the
-          :c:type:`struct v4l2_pix_format` structure, also called the
+          :ref:`struct v4l2_pix_format <v4l2-pix-format>` structure, also called the
           extended fields, are valid. When set to
           ``V4L2_PIX_FMT_PRIV_MAGIC``, it indicates that the extended fields
           have been correctly initialized. When set to any other value it
@@ -149,7 +149,7 @@ Single-planar format structure
           To use the extended fields, applications must set the ``priv``
           field to ``V4L2_PIX_FMT_PRIV_MAGIC``, initialize all the extended
           fields and zero the unused bytes of the
-          :c:type:`struct v4l2_format` ``raw_data`` field.
+          :ref:`struct v4l2_format <v4l2-format>` ``raw_data`` field.
 
           When the ``priv`` field isn't set to ``V4L2_PIX_FMT_PRIV_MAGIC``
           drivers must act as if all the extended fields were set to zero.
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-003.rst b/Documentation/linux_tv/media/v4l/pixfmt-003.rst
index 6ee05ff1dbb5..cc8ef6137618 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-003.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-003.rst
@@ -4,11 +4,11 @@
 Multi-planar format structures
 ******************************
 
-The :c:type:`struct v4l2_plane_pix_format` structures define size
+The :ref:`struct v4l2_plane_pix_format <v4l2-plane-pix-format>` structures define size
 and layout for each of the planes in a multi-planar format. The
-:c:type:`struct v4l2_pix_format_mplane` structure contains
+:ref:`struct v4l2_pix_format_mplane <v4l2-pix-format-mplane>` structure contains
 information common to all planes (such as image width and height) and an
-array of :c:type:`struct v4l2_plane_pix_format` structures,
+array of :ref:`struct v4l2_plane_pix_format <v4l2-plane-pix-format>` structures,
 describing all planes of that format.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt.rst b/Documentation/linux_tv/media/v4l/pixfmt.rst
index f2c599aaa502..417796d39f00 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt.rst
@@ -6,8 +6,8 @@
 Image Formats
 #############
 The V4L2 API was primarily designed for devices exchanging image data
-with applications. The :c:type:`struct v4l2_pix_format` and
-:c:type:`struct v4l2_pix_format_mplane` structures define the
+with applications. The :ref:`struct v4l2_pix_format <v4l2-pix-format>` and
+:ref:`struct v4l2_pix_format_mplane <v4l2-pix-format-mplane>` structures define the
 format and layout of an image in memory. The former is used with the
 single-planar API, while the latter is used with the multi-planar
 version (see :ref:`planar-apis`). Image formats are negotiated with
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
index 9d872e3b9c22..efd9629e099e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
@@ -39,7 +39,7 @@ over buffers is required. This ioctl can be called multiple times to
 create buffers of different sizes.
 
 To allocate the device buffers applications must initialize the relevant
-fields of the :c:type:`struct v4l2_create_buffers` structure. The
+fields of the :ref:`struct v4l2_create_buffers <v4l2-create-buffers>` structure. The
 ``count`` field must be set to the number of requested buffers, the
 ``memory`` field specifies the requested I/O method and the ``reserved``
 array must be zeroed.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
index f4866719e099..0f4433cefc49 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
@@ -69,7 +69,7 @@ or output. [1]_
           set as custom standards. Multiple bits can be set if the hardware
           does not distinguish between these standards, however separate
           indices do not indicate the opposite. The ``id`` must be unique.
-          No other enumerated :c:type:`struct v4l2_standard` structure,
+          No other enumerated :ref:`struct v4l2_standard <v4l2-standard>` structure,
           for this input or output anyway, can contain the same set of bits.
 
     -  .. row 3
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
index 8430b49b770a..abf441a04673 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
@@ -43,7 +43,7 @@ has no audio inputs, or none which combine with the current video input.
 Audio inputs have one writable property, the audio mode. To select the
 current audio input *and* change the audio mode, applications initialize
 the ``index`` and ``mode`` fields, and the ``reserved`` array of a
-:c:type:`struct v4l2_audio` structure and call the :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>`
+:ref:`struct v4l2_audio <v4l2-audio>` structure and call the :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>`
 ioctl. Drivers may switch to a different audio mode if the request
 cannot be satisfied. However, this is a write-only ioctl, it does not
 return the actual new audio mode.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
index e2ca42cbe9ae..6bfd5b1d5428 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
@@ -44,7 +44,7 @@ output.
 Audio outputs have no writable properties. Nevertheless, to select the
 current audio output applications can initialize the ``index`` field and
 ``reserved`` array (which in the future may contain writable properties)
-of a :c:type:`struct v4l2_audioout` structure and call the
+of a :ref:`struct v4l2_audioout <v4l2-audioout>` structure and call the
 ``VIDIOC_S_AUDOUT`` ioctl. Drivers switch to the requested output or
 return the ``EINVAL`` error code when the index is out of bounds. This is a
 write-only ioctl, it does not return the current audio output attributes
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
index 888ddb045340..aba0dc9b4390 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
@@ -35,7 +35,7 @@ Description
 ===========
 
 To query the cropping rectangle size and position applications set the
-``type`` field of a :c:type:`struct v4l2_crop` structure to the
+``type`` field of a :ref:`struct v4l2_crop <v4l2-crop>` structure to the
 respective buffer (stream) type and call the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` ioctl
 with a pointer to this structure. The driver fills the rest of the
 structure or returns the ``EINVAL`` error code if cropping is not supported.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
index 07e27e474326..77a5d1aca78a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
@@ -33,10 +33,10 @@ Description
 ===========
 
 To get the current value of a control applications initialize the ``id``
-field of a struct :c:type:`struct v4l2_control` and call the
+field of a struct :ref:`struct v4l2_control <v4l2-control>` and call the
 :ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` ioctl with a pointer to this structure. To change the
 value of a control applications initialize the ``id`` and ``value``
-fields of a struct :c:type:`struct v4l2_control` and call the
+fields of a struct :ref:`struct v4l2_control <v4l2-control>` and call the
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctl.
 
 When the ``id`` is invalid drivers return an ``EINVAL`` error code. When the
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
index abf997fea991..e52361001bb9 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fbuf.rst
@@ -49,13 +49,13 @@ VGA signal or graphics into a video signal. *Video Output Overlays* are
 always non-destructive.
 
 To get the current parameters applications call the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`
-ioctl with a pointer to a :c:type:`struct v4l2_framebuffer`
+ioctl with a pointer to a :ref:`struct v4l2_framebuffer <v4l2-framebuffer>`
 structure. The driver fills all fields of the structure or returns an
 EINVAL error code when overlays are not supported.
 
 To set the parameters for a *Video Output Overlay*, applications must
 initialize the ``flags`` field of a struct
-:c:type:`struct v4l2_framebuffer`. Since the framebuffer is
+:ref:`struct v4l2_framebuffer <v4l2-framebuffer>`. Since the framebuffer is
 implemented on the TV card all other parameters are determined by the
 driver. When an application calls :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` with a pointer to
 this structure, the driver prepares for the overlay and returns the
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
index 24fac4536196..869c7cc08035 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
@@ -37,7 +37,7 @@ These ioctls are used to negotiate the format of data (typically image
 format) exchanged between driver and application.
 
 To query the current parameters applications set the ``type`` field of a
-struct :c:type:`struct v4l2_format` to the respective buffer (stream)
+struct :ref:`struct v4l2_format <v4l2-format>` to the respective buffer (stream)
 type. For example video capture devices use
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``. When the application calls the
@@ -55,7 +55,7 @@ For details see the documentation of the various devices types in
 :ref:`devices`. Good practice is to query the current parameters
 first, and to modify only those parameters not suitable for the
 application. When the application calls the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl with
-a pointer to a :c:type:`struct v4l2_format` structure the driver
+a pointer to a :ref:`struct v4l2_format <v4l2-format>` structure the driver
 checks and adjusts the parameters against hardware abilities. Drivers
 should not return an error code unless the ``type`` field is invalid,
 this is a mechanism to fathom device capabilities and to approach
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
index 2fbec8a6adfc..73974cd938b8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
@@ -45,7 +45,7 @@ section discussing the :ref:`read() <func-read>` function.
 
 To get and set the streaming parameters applications call the
 :ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl, respectively. They take a
-pointer to a struct :c:type:`struct v4l2_streamparm` which contains a
+pointer to a struct :ref:`struct v4l2_streamparm <v4l2-streamparm>` which contains a
 union holding separate parameters for input and output devices.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
index 67b4d7da6473..8cacecfb8c97 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
@@ -40,7 +40,7 @@ To query and select the current video standard applications use the
 can return a single flag or a set of flags as in struct
 :ref:`v4l2_standard <v4l2-standard>` field ``id``. The flags must be
 unambiguous such that they appear in only one enumerated
-:c:type:`struct v4l2_standard` structure.
+:ref:`struct v4l2_standard <v4l2-standard>` structure.
 
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` accepts one or more flags, being a write-only ioctl it
 does not return the actual new standard as :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` does. When
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
index 078fe6db751e..c5f947811746 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
@@ -221,7 +221,7 @@ To change the radio frequency the
           received audio programs do not match.
 
           Currently this is the only field of struct
-          :c:type:`struct v4l2_tuner` applications can change.
+          :ref:`struct v4l2_tuner <v4l2-tuner>` applications can change.
 
     -  .. row 15
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
index 79a6a1009703..bf31aaaf6c76 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-prepare-buf.rst
@@ -40,7 +40,7 @@ operations are not required, the application can use one of
 ``V4L2_BUF_FLAG_NO_CACHE_INVALIDATE`` and
 ``V4L2_BUF_FLAG_NO_CACHE_CLEAN`` flags to skip the respective step.
 
-The :c:type:`struct v4l2_buffer` structure is specified in
+The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
 :ref:`buffer`.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
index ab567559a0ac..b51db1311e9f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
@@ -44,7 +44,7 @@ Applications must also set the ``index`` field. Valid index numbers
 range from zero to the number of buffers allocated with
 :ref:`VIDIOC_REQBUFS` (struct
 :ref:`v4l2_requestbuffers <v4l2-requestbuffers>` ``count``) minus
-one. The contents of the struct :c:type:`struct v4l2_buffer` returned
+one. The contents of the struct :ref:`struct v4l2_buffer <v4l2-buffer>` returned
 by a :ref:`VIDIOC_QUERYBUF` ioctl will do as well.
 When the buffer is intended for output (``type`` is
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``,
@@ -112,7 +112,7 @@ queue. When the ``O_NONBLOCK`` flag was given to the
 :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
 immediately with an ``EAGAIN`` error code when no buffer is available.
 
-The :c:type:`struct v4l2_buffer` structure is specified in
+The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
 :ref:`buffer`.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
index efc8143edc34..11c9c59688ae 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querybuf.rst
@@ -63,7 +63,7 @@ elements will be used instead and the ``length`` field of struct
 array elements. The driver may or may not set the remaining fields and
 flags, they are meaningless in this context.
 
-The :c:type:`struct v4l2_buffer` structure is specified in
+The :ref:`struct v4l2_buffer <v4l2-buffer>` structure is specified in
 :ref:`buffer`.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
index 411b5bf80313..065ea275c0df 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
@@ -43,7 +43,7 @@ configures the driver into DMABUF I/O mode without performing any direct
 allocation.
 
 To allocate device buffers applications initialize all fields of the
-:c:type:`struct v4l2_requestbuffers` structure. They set the ``type``
+:ref:`struct v4l2_requestbuffers <v4l2-requestbuffers>` structure. They set the ``type``
 field to the respective stream or buffer type, the ``count`` field to
 the desired number of buffers, ``memory`` must be set to the requested
 I/O method and the ``reserved`` array must be zeroed. When the ioctl is
-- 
2.7.4


