Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43958 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965361AbcIHMEV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Nick Dyer <nick@shmanahar.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 37/47] [media] docs-rst: simplify c:type: cross references
Date: Thu,  8 Sep 2016 09:03:59 -0300
Message-Id: <c968ffffbdb3f0d7e9625e5089593034b159479d.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using c:type:`struct foo <foo>`, use:
	struct c:type:`foo`

This patch was generated via this shell script:

	for i in `find Documentation/media -type f`; do perl -ne 'if (m/\:c\:type\:\`struct\s+(\S+)\s*\<(\S+)\>\`/) { $s=$1; $r=$2; if ($s eq $r) { s/\:c\:type\:\`struct\s+(\S+)\s*\<(\S+)\>\`/struct :c:type:`$2`/; s/struct\s+struct/struct/;  s/(struct\s+\:c\:type\:\`\S+\`)\s+structure/$1/;  }} print $_' <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/mc-core.rst               | 24 +++++++++++-----------
 Documentation/media/uapi/dvb/dvbproperty.rst       |  2 +-
 Documentation/media/uapi/v4l/buffer.rst            | 12 +++++------
 Documentation/media/uapi/v4l/dev-osd.rst           |  2 +-
 Documentation/media/uapi/v4l/dev-overlay.rst       |  2 +-
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |  6 +++---
 Documentation/media/uapi/v4l/extended-controls.rst |  2 +-
 Documentation/media/uapi/v4l/pixfmt-002.rst        |  4 ++--
 Documentation/media/uapi/v4l/pixfmt-003.rst        |  6 +++---
 Documentation/media/uapi/v4l/pixfmt.rst            |  4 ++--
 .../media/uapi/v4l/vidioc-create-bufs.rst          |  2 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst     |  4 ++--
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |  4 ++--
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |  4 ++--
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-std.rst      |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |  2 +-
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |  2 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  4 ++--
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |  2 +-
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |  2 +-
 25 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/Documentation/media/kapi/mc-core.rst b/Documentation/media/kapi/mc-core.rst
index fb839a6c1f46..1a738e5f6056 100644
--- a/Documentation/media/kapi/mc-core.rst
+++ b/Documentation/media/kapi/mc-core.rst
@@ -34,7 +34,7 @@ pad to a sink pad.
 Media device
 ^^^^^^^^^^^^
 
-A media device is represented by a :c:type:`struct media_device <media_device>`
+A media device is represented by a struct :c:type:`media_device`
 instance, defined in ``include/media/media-device.h``.
 Allocation of the structure is handled by the media device driver, usually by
 embedding the :c:type:`media_device` instance in a larger driver-specific
@@ -47,7 +47,7 @@ and unregistered by calling :c:func:`media_device_unregister()`.
 Entities
 ^^^^^^^^
 
-Entities are represented by a :c:type:`struct media_entity <media_entity>`
+Entities are represented by a struct :c:type:`media_entity`
 instance, defined in ``include/media/media-entity.h``. The structure is usually
 embedded into a higher-level structure, such as
 :c:type:`v4l2_subdev` or :c:type:`video_device`
@@ -65,10 +65,10 @@ Interfaces
 ^^^^^^^^^^
 
 Interfaces are represented by a
-:c:type:`struct media_interface <media_interface>` instance, defined in
+struct :c:type:`media_interface` instance, defined in
 ``include/media/media-entity.h``. Currently, only one type of interface is
 defined: a device node. Such interfaces are represented by a
-:c:type:`struct media_intf_devnode <media_intf_devnode>`.
+struct :c:type:`media_intf_devnode`.
 
 Drivers initialize and create device node interfaces by calling
 :c:func:`media_devnode_create()`
@@ -77,7 +77,7 @@ and remove them by calling:
 
 Pads
 ^^^^
-Pads are represented by a :c:type:`struct media_pad <media_pad>` instance,
+Pads are represented by a struct :c:type:`media_pad` instance,
 defined in ``include/media/media-entity.h``. Each entity stores its pads in
 a pads array managed by the entity driver. Drivers usually embed the array in
 a driver-specific structure.
@@ -85,8 +85,8 @@ a driver-specific structure.
 Pads are identified by their entity and their 0-based index in the pads
 array.
 
-Both information are stored in the :c:type:`struct media_pad <media_pad>`,
-making the :c:type:`struct media_pad <media_pad>` pointer the canonical way
+Both information are stored in the struct :c:type:`media_pad`,
+making the struct :c:type:`media_pad` pointer the canonical way
 to store and pass link references.
 
 Pads have flags that describe the pad capabilities and state.
@@ -102,7 +102,7 @@ Pads have flags that describe the pad capabilities and state.
 Links
 ^^^^^
 
-Links are represented by a :c:type:`struct media_link <media_link>` instance,
+Links are represented by a struct :c:type:`media_link` instance,
 defined in ``include/media/media-entity.h``. There are two types of links:
 
 **1. pad to pad links**:
@@ -185,7 +185,7 @@ Use count and power handling
 
 Due to the wide differences between drivers regarding power management
 needs, the media controller does not implement power management. However,
-the :c:type:`struct media_entity <media_entity>` includes a ``use_count``
+the struct :c:type:`media_entity` includes a ``use_count``
 field that media drivers
 can use to track the number of users of every entity for power management
 needs.
@@ -211,11 +211,11 @@ prevent link states from being modified during streaming by calling
 The function will mark all entities connected to the given entity through
 enabled links, either directly or indirectly, as streaming.
 
-The :c:type:`struct media_pipeline <media_pipeline>` instance pointed to by
+The struct :c:type:`media_pipeline` instance pointed to by
 the pipe argument will be stored in every entity in the pipeline.
-Drivers should embed the :c:type:`struct media_pipeline <media_pipeline>`
+Drivers should embed the struct :c:type:`media_pipeline`
 in higher-level pipeline structures and can then access the
-pipeline through the :c:type:`struct media_entity <media_entity>`
+pipeline through the struct :c:type:`media_entity`
 pipe field.
 
 Calls to :c:func:`media_entity_pipeline_start()` can be nested.
diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index 906f3e651e10..dd2d71ce43fa 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -23,7 +23,7 @@ union/struct based approach, in favor of a properties set approach.
 .. note::
 
    On Linux DVB API version 3, setting a frontend were done via
-   :c:type:`struct dvb_frontend_parameters <dvb_frontend_parameters>`.
+   struct :c:type:`dvb_frontend_parameters`.
    This got replaced on version 5 (also called "S2API", as this API were
    added originally_enabled to provide support for DVB-S2), because the
    old API has a very limited support to new standards and new hardware.
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index a52a586b0b41..7b64a1986d66 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -11,14 +11,14 @@ the Streaming I/O methods. In the multi-planar API, the data is held in
 planes, while the buffer structure acts as a container for the planes.
 Only pointers to buffers (planes) are exchanged, the data itself is not
 copied. These pointers, together with meta-information like timestamps
-or field parity, are stored in a struct :c:type:`struct v4l2_buffer <v4l2_buffer>`,
+or field parity, are stored in a struct :c:type:`v4l2_buffer`,
 argument to the :ref:`VIDIOC_QUERYBUF`,
 :ref:`VIDIOC_QBUF` and
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. In the multi-planar API,
-some plane-specific members of struct :c:type:`struct v4l2_buffer <v4l2_buffer>`,
+some plane-specific members of struct :c:type:`v4l2_buffer`,
 such as pointers and sizes for each plane, are stored in struct
-:c:type:`struct v4l2_plane <v4l2_plane>` instead. In that case, struct
-:c:type:`struct v4l2_buffer <v4l2_buffer>` contains an array of plane structures.
+struct :c:type:`v4l2_plane` instead. In that case, struct
+struct :c:type:`v4l2_buffer` contains an array of plane structures.
 
 Dequeued video buffers come with timestamps. The driver decides at which
 part of the frame and with which clock the timestamp is taken. Please
@@ -231,7 +231,7 @@ struct v4l2_buffer
        -  When using the multi-planar API, contains a userspace pointer to
 	  an array of struct :c:type:`v4l2_plane`. The size of
 	  the array should be put in the ``length`` field of this
-	  :c:type:`struct v4l2_buffer <v4l2_buffer>` structure.
+	  struct :c:type:`v4l2_buffer` structure.
 
     -  .. row 15
 
@@ -823,7 +823,7 @@ enum v4l2_memory
 Timecodes
 =========
 
-The :c:type:`struct v4l2_timecode <v4l2_timecode>` structure is designed to hold a
+The struct :c:type:`v4l2_timecode` structure is designed to hold a
 :ref:`smpte12m` or similar timecode. (struct
 :c:type:`struct timeval` timestamps are stored in struct
 :c:type:`v4l2_buffer` field ``timestamp``.)
diff --git a/Documentation/media/uapi/v4l/dev-osd.rst b/Documentation/media/uapi/v4l/dev-osd.rst
index a6aaf28807a4..0b246c31b6a3 100644
--- a/Documentation/media/uapi/v4l/dev-osd.rst
+++ b/Documentation/media/uapi/v4l/dev-osd.rst
@@ -121,7 +121,7 @@ parameters applications set the ``type`` field of a struct
 :c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY`` and call the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
-:c:type:`struct v4l2_window <v4l2_window>` substructure named ``win``. It is not
+struct :c:type:`v4l2_window` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
 To program the source rectangle applications set the ``type`` field of a
diff --git a/Documentation/media/uapi/v4l/dev-overlay.rst b/Documentation/media/uapi/v4l/dev-overlay.rst
index 4962947bd8a2..9be14b55e305 100644
--- a/Documentation/media/uapi/v4l/dev-overlay.rst
+++ b/Documentation/media/uapi/v4l/dev-overlay.rst
@@ -125,7 +125,7 @@ To get the current parameters applications set the ``type`` field of a
 struct :c:type:`v4l2_format` to
 ``V4L2_BUF_TYPE_VIDEO_OVERLAY`` and call the
 :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` ioctl. The driver fills the
-:c:type:`struct v4l2_window <v4l2_window>` substructure named ``win``. It is not
+struct :c:type:`v4l2_window` substructure named ``win``. It is not
 possible to retrieve a previously programmed clipping list or bitmap.
 
 To program the overlay window applications set the ``type`` field of a
diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index 2a979aa138bd..7f159c3d4942 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -77,7 +77,7 @@ member, a struct
 Applications can request different parameters by initializing or
 modifying the ``fmt.sliced`` member and calling the
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl with a pointer to the
-:c:type:`struct v4l2_format <v4l2_format>` structure.
+struct :c:type:`v4l2_format` structure.
 
 The sliced VBI API is more complicated than the raw VBI API because the
 hardware must be told which VBI service to expect on each scan line. Not
@@ -376,11 +376,11 @@ Reading and writing sliced VBI data
 
 A single :ref:`read() <func-read>` or :ref:`write() <func-write>`
 call must pass all data belonging to one video frame. That is an array
-of :c:type:`struct v4l2_sliced_vbi_data <v4l2_sliced_vbi_data>` structures with one or
+of struct :c:type:`v4l2_sliced_vbi_data` structures with one or
 more elements and a total size not exceeding ``io_size`` bytes. Likewise
 in streaming I/O mode one buffer of ``io_size`` bytes must contain data
 of one video frame. The ``id`` of unused
-:c:type:`struct v4l2_sliced_vbi_data <v4l2_sliced_vbi_data>` elements must be zero.
+struct :c:type:`v4l2_sliced_vbi_data` elements must be zero.
 
 
 .. c:type:: v4l2_sliced_vbi_data
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 75359739eb52..85e536971923 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -66,7 +66,7 @@ whether the specified control class is supported.
 
 The control array is a struct
 :c:type:`v4l2_ext_control` array. The
-:c:type:`struct v4l2_ext_control <v4l2_ext_control>` structure is very similar to
+struct :c:type:`v4l2_ext_control` is very similar to
 struct :c:type:`v4l2_control`, except for the fact that
 it also allows for 64-bit values and pointers to be passed.
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-002.rst b/Documentation/media/uapi/v4l/pixfmt-002.rst
index 789937900d14..28f14e41631c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-002.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-002.rst
@@ -136,7 +136,7 @@ Single-planar format structure
        -  ``priv``
 
        -  This field indicates whether the remaining fields of the
-	  :c:type:`struct v4l2_pix_format <v4l2_pix_format>` structure, also called the
+	  struct :c:type:`v4l2_pix_format`, also called the
 	  extended fields, are valid. When set to
 	  ``V4L2_PIX_FMT_PRIV_MAGIC``, it indicates that the extended fields
 	  have been correctly initialized. When set to any other value it
@@ -152,7 +152,7 @@ Single-planar format structure
 	  To use the extended fields, applications must set the ``priv``
 	  field to ``V4L2_PIX_FMT_PRIV_MAGIC``, initialize all the extended
 	  fields and zero the unused bytes of the
-	  :c:type:`struct v4l2_format <v4l2_format>` ``raw_data`` field.
+	  struct :c:type:`v4l2_format` ``raw_data`` field.
 
 	  When the ``priv`` field isn't set to ``V4L2_PIX_FMT_PRIV_MAGIC``
 	  drivers must act as if all the extended fields were set to zero.
diff --git a/Documentation/media/uapi/v4l/pixfmt-003.rst b/Documentation/media/uapi/v4l/pixfmt-003.rst
index b214b818baa7..e39fa2b732d7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-003.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-003.rst
@@ -4,11 +4,11 @@
 Multi-planar format structures
 ******************************
 
-The :c:type:`struct v4l2_plane_pix_format <v4l2_plane_pix_format>` structures define size
+The struct :c:type:`v4l2_plane_pix_format` structures define size
 and layout for each of the planes in a multi-planar format. The
-:c:type:`struct v4l2_pix_format_mplane <v4l2_pix_format_mplane>` structure contains
+struct :c:type:`v4l2_pix_format_mplane` structure contains
 information common to all planes (such as image width and height) and an
-array of :c:type:`struct v4l2_plane_pix_format <v4l2_plane_pix_format>` structures,
+array of struct :c:type:`v4l2_plane_pix_format` structures,
 describing all planes of that format.
 
 
diff --git a/Documentation/media/uapi/v4l/pixfmt.rst b/Documentation/media/uapi/v4l/pixfmt.rst
index a6b7871e39e7..4d297f6eb5f1 100644
--- a/Documentation/media/uapi/v4l/pixfmt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt.rst
@@ -6,8 +6,8 @@
 Image Formats
 #############
 The V4L2 API was primarily designed for devices exchanging image data
-with applications. The :c:type:`struct v4l2_pix_format <v4l2_pix_format>` and
-:c:type:`struct v4l2_pix_format_mplane <v4l2_pix_format_mplane>` structures define the
+with applications. The struct :c:type:`v4l2_pix_format` and
+struct :c:type:`v4l2_pix_format_mplane` structures define the
 format and layout of an image in memory. The former is used with the
 single-planar API, while the latter is used with the multi-planar
 version (see :ref:`planar-apis`). Image formats are negotiated with
diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
index c53fdcc3666a..b93422400608 100644
--- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
@@ -39,7 +39,7 @@ over buffers is required. This ioctl can be called multiple times to
 create buffers of different sizes.
 
 To allocate the device buffers applications must initialize the relevant
-fields of the :c:type:`struct v4l2_create_buffers <v4l2_create_buffers>` structure. The
+fields of the struct :c:type:`v4l2_create_buffers` structure. The
 ``count`` field must be set to the number of requested buffers, the
 ``memory`` field specifies the requested I/O method and the ``reserved``
 array must be zeroed.
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index eaac7a2e14c4..7a3a6d6aeb17 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -71,7 +71,7 @@ or output. [#f1]_
 	  set as custom standards. Multiple bits can be set if the hardware
 	  does not distinguish between these standards, however separate
 	  indices do not indicate the opposite. The ``id`` must be unique.
-	  No other enumerated :c:type:`struct v4l2_standard <v4l2_standard>` structure,
+	  No other enumerated struct :c:type:`v4l2_standard` structure,
 	  for this input or output anyway, can contain the same set of bits.
 
     -  .. row 3
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audio.rst b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
index ebf2514464fc..60520318cb4a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audio.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audio.rst
@@ -43,7 +43,7 @@ has no audio inputs, or none which combine with the current video input.
 Audio inputs have one writable property, the audio mode. To select the
 current audio input *and* change the audio mode, applications initialize
 the ``index`` and ``mode`` fields, and the ``reserved`` array of a
-:c:type:`struct v4l2_audio <v4l2_audio>` structure and call the :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>`
+struct :c:type:`v4l2_audio` structure and call the :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>`
 ioctl. Drivers may switch to a different audio mode if the request
 cannot be satisfied. However, this is a write-only ioctl, it does not
 return the actual new audio mode.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
index b21794300efd..e9d264590788 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
@@ -44,7 +44,7 @@ output.
 Audio outputs have no writable properties. Nevertheless, to select the
 current audio output applications can initialize the ``index`` field and
 ``reserved`` array (which in the future may contain writable properties)
-of a :c:type:`struct v4l2_audioout <v4l2_audioout>` structure and call the
+of a struct :c:type:`v4l2_audioout` structure and call the
 ``VIDIOC_S_AUDOUT`` ioctl. Drivers switch to the requested output or
 return the ``EINVAL`` error code when the index is out of bounds. This is a
 write-only ioctl, it does not return the current audio output attributes
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index b99032e59ebe..4ddd8c08fd1c 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -35,7 +35,7 @@ Description
 ===========
 
 To query the cropping rectangle size and position applications set the
-``type`` field of a :c:type:`struct v4l2_crop <v4l2_crop>` structure to the
+``type`` field of a struct :c:type:`v4l2_crop` structure to the
 respective buffer (stream) type and call the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` ioctl
 with a pointer to this structure. The driver fills the rest of the
 structure or returns the ``EINVAL`` error code if cropping is not supported.
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
index 53a6ebe6f744..78c191a89360 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ctrl.rst
@@ -35,10 +35,10 @@ Description
 ===========
 
 To get the current value of a control applications initialize the ``id``
-field of a struct :c:type:`struct v4l2_control <v4l2_control>` and call the
+field of a struct :c:type:`v4l2_control` and call the
 :ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` ioctl with a pointer to this structure. To change the
 value of a control applications initialize the ``id`` and ``value``
-fields of a struct :c:type:`struct v4l2_control <v4l2_control>` and call the
+fields of a struct :c:type:`v4l2_control` and call the
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctl.
 
 When the ``id`` is invalid drivers return an ``EINVAL`` error code. When the
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index 7ade2f7d62be..4ac2625e545d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -49,13 +49,13 @@ VGA signal or graphics into a video signal. *Video Output Overlays* are
 always non-destructive.
 
 To get the current parameters applications call the :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`
-ioctl with a pointer to a :c:type:`struct v4l2_framebuffer <v4l2_framebuffer>`
+ioctl with a pointer to a struct :c:type:`v4l2_framebuffer`
 structure. The driver fills all fields of the structure or returns an
 EINVAL error code when overlays are not supported.
 
 To set the parameters for a *Video Output Overlay*, applications must
 initialize the ``flags`` field of a struct
-:c:type:`struct v4l2_framebuffer <v4l2_framebuffer>`. Since the framebuffer is
+struct :c:type:`v4l2_framebuffer`. Since the framebuffer is
 implemented on the TV card all other parameters are determined by the
 driver. When an application calls :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` with a pointer to
 this structure, the driver prepares for the overlay and returns the
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index dd6c062d267c..037437d66f08 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -40,7 +40,7 @@ These ioctls are used to negotiate the format of data (typically image
 format) exchanged between driver and application.
 
 To query the current parameters applications set the ``type`` field of a
-struct :c:type:`struct v4l2_format <v4l2_format>` to the respective buffer (stream)
+struct :c:type:`v4l2_format` to the respective buffer (stream)
 type. For example video capture devices use
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
 ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``. When the application calls the
@@ -58,7 +58,7 @@ For details see the documentation of the various devices types in
 :ref:`devices`. Good practice is to query the current parameters
 first, and to modify only those parameters not suitable for the
 application. When the application calls the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl with
-a pointer to a :c:type:`struct v4l2_format <v4l2_format>` structure the driver
+a pointer to a struct :c:type:`v4l2_format` structure the driver
 checks and adjusts the parameters against hardware abilities. Drivers
 should not return an error code unless the ``type`` field is invalid,
 this is a mechanism to fathom device capabilities and to approach
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 021b96ee641d..689b5d92aeae 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -47,7 +47,7 @@ section discussing the :ref:`read() <func-read>` function.
 
 To get and set the streaming parameters applications call the
 :ref:`VIDIOC_G_PARM <VIDIOC_G_PARM>` and :ref:`VIDIOC_S_PARM <VIDIOC_G_PARM>` ioctl, respectively. They take a
-pointer to a struct :c:type:`struct v4l2_streamparm <v4l2_streamparm>` which contains a
+pointer to a struct :c:type:`v4l2_streamparm` which contains a
 union holding separate parameters for input and output devices.
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-std.rst b/Documentation/media/uapi/v4l/vidioc-g-std.rst
index c351eb9f6b0e..cd856ad21a28 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-std.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-std.rst
@@ -40,7 +40,7 @@ To query and select the current video standard applications use the
 can return a single flag or a set of flags as in struct
 :c:type:`v4l2_standard` field ``id``. The flags must be
 unambiguous such that they appear in only one enumerated
-:c:type:`struct v4l2_standard <v4l2_standard>` structure.
+struct :c:type:`v4l2_standard` structure.
 
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` accepts one or more flags, being a write-only ioctl it
 does not return the actual new standard as :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` does. When
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 01b7f26bf22f..077da39f3ae6 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -226,7 +226,7 @@ To change the radio frequency the
 	  received audio programs do not match.
 
 	  Currently this is the only field of struct
-	  :c:type:`struct v4l2_tuner <v4l2_tuner>` applications can change.
+	  struct :c:type:`v4l2_tuner` applications can change.
 
     -  .. row 15
 
diff --git a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
index c20e1c7d5f89..bdcfd9fe550d 100644
--- a/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-prepare-buf.rst
@@ -40,7 +40,7 @@ operations are not required, the application can use one of
 ``V4L2_BUF_FLAG_NO_CACHE_INVALIDATE`` and
 ``V4L2_BUF_FLAG_NO_CACHE_CLEAN`` flags to skip the respective step.
 
-The :c:type:`struct v4l2_buffer <v4l2_buffer>` structure is specified in
+The struct :c:type:`v4l2_buffer` structure is specified in
 :ref:`buffer`.
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 727238fc2337..1f3612637200 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -46,7 +46,7 @@ Applications must also set the ``index`` field. Valid index numbers
 range from zero to the number of buffers allocated with
 :ref:`VIDIOC_REQBUFS` (struct
 :c:type:`v4l2_requestbuffers` ``count``) minus
-one. The contents of the struct :c:type:`struct v4l2_buffer <v4l2_buffer>` returned
+one. The contents of the struct :c:type:`v4l2_buffer` returned
 by a :ref:`VIDIOC_QUERYBUF` ioctl will do as well.
 When the buffer is intended for output (``type`` is
 ``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``,
@@ -114,7 +114,7 @@ queue. When the ``O_NONBLOCK`` flag was given to the
 :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
 immediately with an ``EAGAIN`` error code when no buffer is available.
 
-The :c:type:`struct v4l2_buffer <v4l2_buffer>` structure is specified in
+The struct :c:type:`v4l2_buffer` structure is specified in
 :ref:`buffer`.
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-querybuf.rst b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
index 1edd76c06e0a..0bdc8e0abddc 100644
--- a/Documentation/media/uapi/v4l/vidioc-querybuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querybuf.rst
@@ -63,7 +63,7 @@ elements will be used instead and the ``length`` field of struct
 array elements. The driver may or may not set the remaining fields and
 flags, they are meaningless in this context.
 
-The :c:type:`struct v4l2_buffer <v4l2_buffer>` structure is specified in
+The struct :c:type:`v4l2_buffer` structure is specified in
 :ref:`buffer`.
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index 195f0a3d783c..fc63045f4143 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -43,7 +43,7 @@ configures the driver into DMABUF I/O mode without performing any direct
 allocation.
 
 To allocate device buffers applications initialize all fields of the
-:c:type:`struct v4l2_requestbuffers <v4l2_requestbuffers>` structure. They set the ``type``
+struct :c:type:`v4l2_requestbuffers` structure. They set the ``type``
 field to the respective stream or buffer type, the ``count`` field to
 the desired number of buffers, ``memory`` must be set to the requested
 I/O method and the ``reserved`` array must be zeroed. When the ioctl is
-- 
2.7.4


