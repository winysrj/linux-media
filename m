Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43849 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965270AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
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
Subject: [PATCH 43/47] [media] docs-rst: fix cross-references for videodev2.h
Date: Thu,  8 Sep 2016 09:04:05 -0300
Message-Id: <74c177593fdfc79ce5672ca1fdbc15d9cb8bb9fa.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several broken references there, due to the conversion to
C domain. Fix them using this shell script and manually adjust what's
broken:

	# funcs is a file with the broken functions/references
	for i in $(cat funcs|sort|uniq|perl -ne 'print "$1\n" if (m/(\S+)$/)'); do
		i=${i//-/_}
		echo $i
		j=${i//_/-}
		for k in $(git grep -l "_$j:" Documentation/); do
			sed s,\_$j\:,"c\:type\:\: $i", <$k >a && mv a $k
		done
		for k in $(git grep -l "$j" Documentation/media/*.exceptions); do
			sed s,$j,":c\:type\:\`$i\`", <$k >a && mv a $k
		done
		for k in $(git grep -l "$j" Documentation/); do
			sed "s,:ref:\`$i <$j>\`,:c:type:\`$i\`," <$k >a && mv a $k
			sed "s,:ref:\`$j\`,:c:type:\`$i\`," <$k >a && mv a $k
			sed -E "s,:ref:\`(.*)<$j>\`,:c:type:\`\1<$i>\`," <$k >a && mv a $k
		done
		for k in $(git grep -l "<$j>" include/media); do
			sed -E "s,:ref:\`(.*)<$j>\`,enum \&$i," <$k >a && mv a $k
		done
	done

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/buffer.rst            |  14 +-
 Documentation/media/uapi/v4l/field-order.rst       |   4 +-
 Documentation/media/uapi/v4l/hist-v4l2.rst         |  30 +--
 Documentation/media/uapi/v4l/pixfmt-002.rst        |  10 +-
 Documentation/media/uapi/v4l/pixfmt-003.rst        |  10 +-
 Documentation/media/uapi/v4l/pixfmt-006.rst        |  16 +-
 Documentation/media/uapi/v4l/planar-apis.rst       |   2 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    |  10 +-
 Documentation/media/uapi/v4l/tuner.rst             |   4 +-
 Documentation/media/uapi/v4l/v4l2.rst              |   4 +-
 .../media/uapi/v4l/vidioc-create-bufs.rst          |   2 +-
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |   2 +-
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |   2 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   2 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   2 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |   2 +-
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |   2 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |   2 +-
 Documentation/media/uapi/v4l/vidioc-expbuf.rst     |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |   2 +-
 .../media/uapi/v4l/vidioc-g-frequency.rst          |   2 +-
 .../media/uapi/v4l/vidioc-g-modulator.rst          |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |   2 +-
 .../media/uapi/v4l/vidioc-g-selection.rst          |   2 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |   2 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |   4 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |   2 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |   4 +-
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |   4 +-
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |   2 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |   7 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-size.rst     |   6 +-
 .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst      |   6 +-
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |   8 +-
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |   2 +-
 .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    |   8 +-
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |   4 +-
 Documentation/media/videodev2.h.rst.exceptions     | 204 ++++++++++-----------
 41 files changed, 201 insertions(+), 202 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index e71a458712d3..21893ee1384a 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -74,7 +74,7 @@ struct v4l2_buffer
        -  Type of the buffer, same as struct
 	  :c:type:`v4l2_format` ``type`` or struct
 	  :c:type:`v4l2_requestbuffers` ``type``, set
-	  by the application. See :ref:`v4l2-buf-type`
+	  by the application. See :c:type:`v4l2_buf_type`
 
     -  .. row 3
 
@@ -110,7 +110,7 @@ struct v4l2_buffer
 
        -
        -  Indicates the field order of the image in the buffer, see
-	  :ref:`v4l2-field`. This field is not used when the buffer
+	  :c:type:`v4l2_field`. This field is not used when the buffer
 	  contains VBI data. Drivers must set it when ``type`` refers to a
 	  capture stream, applications when it refers to an output stream.
 
@@ -142,7 +142,7 @@ struct v4l2_buffer
        -  When ``type`` is ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` and the
 	  ``V4L2_BUF_FLAG_TIMECODE`` flag is set in ``flags``, this
 	  structure contains a frame timecode. In
-	  :ref:`V4L2_FIELD_ALTERNATE <v4l2-field>` mode the top and
+	  :c:type:`V4L2_FIELD_ALTERNATE <v4l2_field>` mode the top and
 	  bottom field contain the same timecode. Timecodes are intended to
 	  help video editing and are typically recorded on video tapes, but
 	  also embedded in compressed formats like MPEG. This field is
@@ -162,7 +162,7 @@ struct v4l2_buffer
 
        -  :cspan:`3`
 
-	  In :ref:`V4L2_FIELD_ALTERNATE <v4l2-field>` mode the top and
+	  In :c:type:`V4L2_FIELD_ALTERNATE <v4l2_field>` mode the top and
 	  bottom field have the same sequence number. The count starts at
 	  zero and includes dropped or repeated frames. A dropped frame was
 	  received by an input device but could not be stored due to lack of
@@ -187,7 +187,7 @@ struct v4l2_buffer
 
        -
        -  This field must be set by applications and/or drivers in
-	  accordance with the selected I/O method. See :ref:`v4l2-memory`
+	  accordance with the selected I/O method. See :c:type:`v4l2_memory`
 
     -  .. row 11
 
@@ -402,7 +402,7 @@ struct v4l2_plane
 
 
 
-.. _v4l2-buf-type:
+.. c:type:: v4l2_buf_type
 
 enum v4l2_buf_type
 ==================
@@ -773,7 +773,7 @@ Buffer Flags
 
 
 
-.. _v4l2-memory:
+.. c:type:: v4l2_memory
 
 enum v4l2_memory
 ================
diff --git a/Documentation/media/uapi/v4l/field-order.rst b/Documentation/media/uapi/v4l/field-order.rst
index 1fa082f34c6f..0d71d5a3fbde 100644
--- a/Documentation/media/uapi/v4l/field-order.rst
+++ b/Documentation/media/uapi/v4l/field-order.rst
@@ -52,11 +52,11 @@ this end applications initialize the ``field`` field of struct
 should have the value ``V4L2_FIELD_ANY`` (0).
 
 
-.. _v4l2-field:
-
 enum v4l2_field
 ===============
 
+.. c:type:: v4l2_field
+
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
 .. flat-table::
diff --git a/Documentation/media/uapi/v4l/hist-v4l2.rst b/Documentation/media/uapi/v4l/hist-v4l2.rst
index d86d6343a20a..dfd55e9066b3 100644
--- a/Documentation/media/uapi/v4l/hist-v4l2.rst
+++ b/Documentation/media/uapi/v4l/hist-v4l2.rst
@@ -438,7 +438,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     ``VIDIOC_S_FMT`` and ``VIDIOC_TRY_FMT``; ioctl. The ``VIDIOC_G_WIN``
     and ``VIDIOC_S_WIN`` ioctls to prepare for a video overlay were
     removed. The ``type`` field changed to type enum
-    :ref:`v4l2_buf_type <v4l2-buf-type>` and the buffer type names
+    :c:type:`v4l2_buf_type` and the buffer type names
     changed as follows.
 
 
@@ -452,7 +452,7 @@ This unnamed version was finally merged into Linux 2.5.46.
 
 	   -  Old defines
 
-	   -  enum :ref:`v4l2_buf_type <v4l2-buf-type>`
+	   -  enum :c:type:`v4l2_buf_type`
 
 	-  .. row 2
 
@@ -534,7 +534,7 @@ This unnamed version was finally merged into Linux 2.5.46.
 
 
 10. In struct :c:type:`v4l2_fmtdesc` a enum
-    :ref:`v4l2_buf_type <v4l2-buf-type>` field named ``type`` was
+    :c:type:`v4l2_buf_type` field named ``type`` was
     added as in struct :c:type:`v4l2_format`. The
     ``VIDIOC_ENUM_FBUFFMT`` ioctl is no longer needed and was removed.
     These calls can be replaced by
@@ -555,7 +555,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     itself was removed.
 
     The interlace flags were replaced by a enum
-    :ref:`v4l2_field <v4l2-field>` value in a newly added ``field``
+    :c:type:`v4l2_field` value in a newly added ``field``
     field.
 
 
@@ -569,7 +569,7 @@ This unnamed version was finally merged into Linux 2.5.46.
 
 	   -  Old flag
 
-	   -  enum :ref:`v4l2_field <v4l2-field>`
+	   -  enum :c:type:`v4l2_field`
 
 	-  .. row 2
 
@@ -615,23 +615,23 @@ This unnamed version was finally merged into Linux 2.5.46.
 
 
     The color space flags were replaced by a enum
-    :ref:`v4l2_colorspace <v4l2-colorspace>` value in a newly added
+    :c:type:`v4l2_colorspace` value in a newly added
     ``colorspace`` field, where one of ``V4L2_COLORSPACE_SMPTE170M``,
     ``V4L2_COLORSPACE_BT878``, ``V4L2_COLORSPACE_470_SYSTEM_M`` or
     ``V4L2_COLORSPACE_470_SYSTEM_BG`` replaces ``V4L2_FMT_CS_601YUV``.
 
 12. In struct :c:type:`v4l2_requestbuffers` the
     ``type`` field was properly defined as enum
-    :ref:`v4l2_buf_type <v4l2-buf-type>`. Buffer types changed as
+    :c:type:`v4l2_buf_type`. Buffer types changed as
     mentioned above. A new ``memory`` field of type enum
-    :ref:`v4l2_memory <v4l2-memory>` was added to distinguish between
+    :c:type:`v4l2_memory` was added to distinguish between
     I/O methods using buffers allocated by the driver or the
     application. See :ref:`io` for details.
 
 13. In struct :c:type:`v4l2_buffer` the ``type`` field was
-    properly defined as enum :ref:`v4l2_buf_type <v4l2-buf-type>`.
+    properly defined as enum :c:type:`v4l2_buf_type`.
     Buffer types changed as mentioned above. A ``field`` field of type
-    enum :ref:`v4l2_field <v4l2-field>` was added to indicate if a
+    enum :c:type:`v4l2_field` was added to indicate if a
     buffer contains a top or bottom field. The old field flags were
     removed. Since no unadjusted system time clock was added to the
     kernel as planned, the ``timestamp`` field changed back from type
@@ -639,7 +639,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     nanoseconds, to struct :c:type:`timeval`. With the addition
     of a second memory mapping method the ``offset`` field moved into
     union ``m``, and a new ``memory`` field of type enum
-    :ref:`v4l2_memory <v4l2-memory>` was added to distinguish between
+    :c:type:`v4l2_memory` was added to distinguish between
     I/O methods. See :ref:`io` for details.
 
     The ``V4L2_BUF_REQ_CONTIG`` flag was used by the V4L compatibility
@@ -667,7 +667,7 @@ This unnamed version was finally merged into Linux 2.5.46.
 
 16. In struct :c:type:`v4l2_window` the ``x``, ``y``,
     ``width`` and ``height`` field moved into a ``w`` substructure as
-    above. A ``field`` field of type %v4l2-field; was added to
+    above. A ``field`` field of type :c:type:`v4l2_field` was added to
     distinguish between field and frame (interlaced) overlay.
 
 17. The digital zoom interface, including struct
@@ -1029,7 +1029,7 @@ V4L2 in Linux 2.6.22
 ====================
 
 1. Two new field orders ``V4L2_FIELD_INTERLACED_TB`` and
-   ``V4L2_FIELD_INTERLACED_BT`` were added. See :ref:`v4l2-field` for
+   ``V4L2_FIELD_INTERLACED_BT`` were added. See :c:type:`v4l2_field` for
    details.
 
 2. Three new clipping/blending methods with a global or straight or
@@ -1357,8 +1357,8 @@ V4L2 in Linux 3.19
 ==================
 
 1. Rewrote Colorspace chapter, added new enum
-   :ref:`v4l2_ycbcr_encoding <v4l2-ycbcr-encoding>` and enum
-   :ref:`v4l2_quantization <v4l2-quantization>` fields to struct
+   :c:type:`v4l2_ycbcr_encoding` and enum
+   :c:type:`v4l2_quantization` fields to struct
    :c:type:`v4l2_pix_format`, struct
    :c:type:`v4l2_pix_format_mplane` and
    struct :c:type:`v4l2_mbus_framefmt`.
diff --git a/Documentation/media/uapi/v4l/pixfmt-002.rst b/Documentation/media/uapi/v4l/pixfmt-002.rst
index 28f14e41631c..fd73f4697878 100644
--- a/Documentation/media/uapi/v4l/pixfmt-002.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-002.rst
@@ -61,7 +61,7 @@ Single-planar format structure
 
     -  .. row 5
 
-       -  enum :ref:`v4l2_field <v4l2-field>`
+       -  enum :c:type::`v4l2_field`
 
        -  ``field``
 
@@ -121,7 +121,7 @@ Single-planar format structure
 
     -  .. row 9
 
-       -  enum :ref:`v4l2_colorspace <v4l2-colorspace>`
+       -  enum :c:type:`v4l2_colorspace`
 
        -  ``colorspace``
 
@@ -170,7 +170,7 @@ Single-planar format structure
 
     -  .. row 12
 
-       -  enum :ref:`v4l2_ycbcr_encoding <v4l2-ycbcr-encoding>`
+       -  enum :c:type:`v4l2_ycbcr_encoding`
 
        -  ``ycbcr_enc``
 
@@ -180,7 +180,7 @@ Single-planar format structure
 
     -  .. row 13
 
-       -  enum :ref:`v4l2_quantization <v4l2-quantization>`
+       -  enum :c:type:`v4l2_quantization`
 
        -  ``quantization``
 
@@ -190,7 +190,7 @@ Single-planar format structure
 
     -  .. row 14
 
-       -  enum :ref:`v4l2_xfer_func <v4l2-xfer-func>`
+       -  enum :c:type:`v4l2_xfer_func`
 
        -  ``xfer_func``
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-003.rst b/Documentation/media/uapi/v4l/pixfmt-003.rst
index e39fa2b732d7..a3c83df3bce5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-003.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-003.rst
@@ -88,7 +88,7 @@ describing all planes of that format.
 
     -  .. row 4
 
-       -  enum :ref:`v4l2_field <v4l2-field>`
+       -  enum :c:type:`v4l2_field`
 
        -  ``field``
 
@@ -96,7 +96,7 @@ describing all planes of that format.
 
     -  .. row 5
 
-       -  enum :ref:`v4l2_colorspace <v4l2-colorspace>`
+       -  enum :c:type:`v4l2_colorspace`
 
        -  ``colorspace``
 
@@ -131,7 +131,7 @@ describing all planes of that format.
 
     -  .. row 9
 
-       -  enum :ref:`v4l2_ycbcr_encoding <v4l2-ycbcr-encoding>`
+       -  enum :c:type:`v4l2_ycbcr_encoding`
 
        -  ``ycbcr_enc``
 
@@ -141,7 +141,7 @@ describing all planes of that format.
 
     -  .. row 10
 
-       -  enum :ref:`v4l2_quantization <v4l2-quantization>`
+       -  enum :c:type:`v4l2_quantization`
 
        -  ``quantization``
 
@@ -151,7 +151,7 @@ describing all planes of that format.
 
     -  .. row 11
 
-       -  enum :ref:`v4l2_xfer_func <v4l2-xfer-func>`
+       -  enum :c:type:`v4l2_xfer_func`
 
        -  ``xfer_func``
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-006.rst b/Documentation/media/uapi/v4l/pixfmt-006.rst
index a97fc28e039d..819299d0291a 100644
--- a/Documentation/media/uapi/v4l/pixfmt-006.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-006.rst
@@ -5,15 +5,15 @@ Defining Colorspaces in V4L2
 ****************************
 
 In V4L2 colorspaces are defined by four values. The first is the
-colorspace identifier (enum :ref:`v4l2_colorspace <v4l2-colorspace>`)
+colorspace identifier (enum :c:type:`v4l2_colorspace`)
 which defines the chromaticities, the default transfer function, the
 default Y'CbCr encoding and the default quantization method. The second
 is the transfer function identifier (enum
-:ref:`v4l2_xfer_func <v4l2-xfer-func>`) to specify non-standard
+:c:type:`v4l2_xfer_func`) to specify non-standard
 transfer functions. The third is the Y'CbCr encoding identifier (enum
-:ref:`v4l2_ycbcr_encoding <v4l2-ycbcr-encoding>`) to specify
+:c:type:`v4l2_ycbcr_encoding`) to specify
 non-standard Y'CbCr encodings and the fourth is the quantization
-identifier (enum :ref:`v4l2_quantization <v4l2-quantization>`) to
+identifier (enum :c:type:`v4l2_quantization`) to
 specify non-standard quantization methods. Most of the time only the
 colorspace field of struct :c:type:`v4l2_pix_format`
 or struct :c:type:`v4l2_pix_format_mplane`
@@ -27,7 +27,7 @@ needs to be filled in.
 
 .. tabularcolumns:: |p{6.0cm}|p{11.5cm}|
 
-.. _v4l2-colorspace:
+.. c:type:: v4l2_colorspace
 
 .. flat-table:: V4L2 Colorspaces
     :header-rows:  1
@@ -119,7 +119,7 @@ needs to be filled in.
 
 
 
-.. _v4l2-xfer-func:
+.. c:type:: v4l2_xfer_func
 
 .. flat-table:: V4L2 Transfer Function
     :header-rows:  1
@@ -182,7 +182,7 @@ needs to be filled in.
 
 
 
-.. _v4l2-ycbcr-encoding:
+.. c:type:: v4l2_ycbcr_encoding
 
 .. tabularcolumns:: |p{6.5cm}|p{11.0cm}|
 
@@ -247,7 +247,7 @@ needs to be filled in.
 
 
 
-.. _v4l2-quantization:
+.. c:type:: v4l2_quantization
 
 .. tabularcolumns:: |p{6.5cm}|p{11.0cm}|
 
diff --git a/Documentation/media/uapi/v4l/planar-apis.rst b/Documentation/media/uapi/v4l/planar-apis.rst
index bd0f88b01c9a..4e059fb44153 100644
--- a/Documentation/media/uapi/v4l/planar-apis.rst
+++ b/Documentation/media/uapi/v4l/planar-apis.rst
@@ -22,7 +22,7 @@ application can choose whether to use one or the other by passing a
 corresponding buffer type to its ioctl calls. Multi-planar versions of
 buffer types are suffixed with an ``_MPLANE`` string. For a list of
 available multi-planar buffer types see enum
-:ref:`v4l2_buf_type <v4l2-buf-type>`.
+:c:type:`v4l2_buf_type`.
 
 
 Multi-planar formats
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index f0d7754f1906..568d5dd56561 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -46,7 +46,7 @@ Media Bus Formats
 
        -  ``field``
 
-       -  Field order, from enum :ref:`v4l2_field <v4l2-field>`. See
+       -  Field order, from enum :c:type:`v4l2_field`. See
 	  :ref:`field-order` for details.
 
     -  .. row 5
@@ -56,12 +56,12 @@ Media Bus Formats
        -  ``colorspace``
 
        -  Image colorspace, from enum
-	  :ref:`v4l2_colorspace <v4l2-colorspace>`. See
+	  :c:type:`v4l2_colorspace`. See
 	  :ref:`colorspaces` for details.
 
     -  .. row 6
 
-       -  enum :ref:`v4l2_ycbcr_encoding <v4l2-ycbcr-encoding>`
+       -  enum :c:type:`v4l2_ycbcr_encoding`
 
        -  ``ycbcr_enc``
 
@@ -71,7 +71,7 @@ Media Bus Formats
 
     -  .. row 7
 
-       -  enum :ref:`v4l2_quantization <v4l2-quantization>`
+       -  enum :c:type:`v4l2_quantization`
 
        -  ``quantization``
 
@@ -81,7 +81,7 @@ Media Bus Formats
 
     -  .. row 8
 
-       -  enum :ref:`v4l2_xfer_func <v4l2-xfer-func>`
+       -  enum :c:type:`v4l2_xfer_func`
 
        -  ``xfer_func``
 
diff --git a/Documentation/media/uapi/v4l/tuner.rst b/Documentation/media/uapi/v4l/tuner.rst
index 4064841d8963..ad117b068831 100644
--- a/Documentation/media/uapi/v4l/tuner.rst
+++ b/Documentation/media/uapi/v4l/tuner.rst
@@ -33,8 +33,8 @@ current video or radio input is queried.
    :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` does not switch the
    current tuner, when there is more than one at all. The tuner is solely
    determined by the current video input. Drivers must support both ioctls
-   and set the ``V4L2_CAP_TUNER`` flag in the struct :ref:`v4l2_capability
-   <v4l2-capability>` returned by the :ref:`VIDIOC_QUERYCAP` ioctl when the
+   and set the ``V4L2_CAP_TUNER`` flag in the struct :c:type:`v4l2_capability`
+   returned by the :ref:`VIDIOC_QUERYCAP` ioctl when the
    device has one or more tuners.
 
 
diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
index e020c57f98d4..55b959dda07e 100644
--- a/Documentation/media/uapi/v4l/v4l2.rst
+++ b/Documentation/media/uapi/v4l/v4l2.rst
@@ -112,8 +112,8 @@ DVB device nodes. Add support for Tuner sub-device.
 :revision: 3.19 / 2014-12-05 (*hv*)
 
 Rewrote Colorspace chapter, added new enum
-:ref:`v4l2_ycbcr_encoding <v4l2-ycbcr-encoding>` and enum
-:ref:`v4l2_quantization <v4l2-quantization>` fields to struct
+:c:type:`v4l2_ycbcr_encoding` and enum
+:c:type:`v4l2_quantization` fields to struct
 :c:type:`v4l2_pix_format`, struct
 :c:type:`v4l2_pix_format_mplane` and struct
 :c:type:`v4l2_mbus_framefmt`.
diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
index b93422400608..810634e47d54 100644
--- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
@@ -111,7 +111,7 @@ than the number requested.
 
        -  Applications set this field to ``V4L2_MEMORY_MMAP``,
 	  ``V4L2_MEMORY_DMABUF`` or ``V4L2_MEMORY_USERPTR``. See
-	  :ref:`v4l2-memory`
+	  :c:type:`v4l2_memory`
 
     -  .. row 4
 
diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
index 945596fcd65f..f7d448cad4eb 100644
--- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
@@ -69,7 +69,7 @@ overlay devices.
        -  Type of the data stream, set by the application. Only these types
 	  are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``,
 	  ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` and
-	  ``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :ref:`v4l2-buf-type`.
+	  ``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type`.
 
     -  .. row 2
 
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
index 08f3c510e440..b875ee2aece7 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
@@ -144,7 +144,7 @@ instructions.
 
        -  ``match``
 
-       -  How to match the chip, see :ref:`v4l2-dbg-match`.
+       -  How to match the chip, see :c:type:`v4l2_dbg_match`.
 
     -  .. row 2
 
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index 1e435ab674a2..6347d2f83a44 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -324,7 +324,7 @@ call.
 
        -  ``field``
 
-       -  The upcoming field. See enum :ref:`v4l2_field <v4l2-field>`.
+       -  The upcoming field. See enum :c:type:`v4l2_field`.
 
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 1df8fccf067f..91fbc4ba209c 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -73,7 +73,7 @@ one until ``EINVAL`` is returned.
 	  ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``,
 	  ``V4L2_BUF_TYPE_VIDEO_OUTPUT``,
 	  ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` and
-	  ``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :ref:`v4l2-buf-type`.
+	  ``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type`.
 
     -  .. row 3
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index 07e94420c4c5..83f641f9f231 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -231,7 +231,7 @@ Enums
 =====
 
 
-.. _v4l2-frmivaltypes:
+.. c:type:: v4l2_frmivaltypes
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index a4ddfe9f8956..9a9571d11f7d 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -254,7 +254,7 @@ Enums
 =====
 
 
-.. _v4l2-frmsizetypes:
+.. c:type:: v4l2_frmsizetypes
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index c38478227031..cc27ad4e2fa7 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -75,7 +75,7 @@ of the corresponding tuner/modulator is set.
 	  set to ``V4L2_TUNER_RADIO`` for ``/dev/radioX`` device nodes, and
 	  to ``V4L2_TUNER_ANALOG_TV`` for all others. Set this field to
 	  ``V4L2_TUNER_RADIO`` for modulators (currently only radio
-	  modulators are supported). See :ref:`v4l2-tuner-type`
+	  modulators are supported). See :c:type:`v4l2_tuner_type`
 
     -  .. row 3
 
diff --git a/Documentation/media/uapi/v4l/vidioc-expbuf.rst b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
index 650757ad8aed..2ae2f5483351 100644
--- a/Documentation/media/uapi/v4l/vidioc-expbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-expbuf.rst
@@ -133,7 +133,7 @@ Examples
        -  Type of the buffer, same as struct
 	  :c:type:`v4l2_format` ``type`` or struct
 	  :c:type:`v4l2_requestbuffers` ``type``, set
-	  by the application. See :ref:`v4l2-buf-type`
+	  by the application. See :c:type:`v4l2_buf_type`
 
     -  .. row 2
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index 4ddd8c08fd1c..9b24ca591ea4 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -94,7 +94,7 @@ When cropping is not supported then no parameters are changed and
        -  Type of the data stream, set by the application. Only these types
 	  are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``,
 	  ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` and
-	  ``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :ref:`v4l2-buf-type`.
+	  ``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type`.
 
     -  .. row 2
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-edid.rst b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
index b288d8ee49ef..1fffca7cc38f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-edid.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
@@ -97,7 +97,7 @@ the EDID data in some way. In any case, the end result is the same: the
 EDID is no longer available.
 
 
-.. _v4l2-edid:
+.. c:type:: v4l2_edid
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index 4ac2625e545d..1ad40a9dd743 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -200,7 +200,7 @@ destructive video overlay.
     -  .. row 12
 
        -
-       -  enum :ref:`v4l2_field <v4l2-field>`
+       -  enum :c:type:`v4l2_field`
 
        -  ``field``
 
@@ -266,7 +266,7 @@ destructive video overlay.
     -  .. row 16
 
        -
-       -  enum :ref:`v4l2_colorspace <v4l2-colorspace>`
+       -  enum :c:type:`v4l2_colorspace`
 
        -  ``colorspace``
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index 037437d66f08..f11dce6dc543 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -101,7 +101,7 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
        -  ``type``
 
        -
-       -  Type of the data stream, see :ref:`v4l2-buf-type`.
+       -  Type of the data stream, see :c:type:`v4l2_buf_type`.
 
     -  .. row 2
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
index 9cbe70098b2b..37ac69acf113 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-frequency.rst
@@ -85,7 +85,7 @@ write-only ioctl, it does not return the actual new frequency.
 	  set to ``V4L2_TUNER_RADIO`` for ``/dev/radioX`` device nodes, and
 	  to ``V4L2_TUNER_ANALOG_TV`` for all others. Set this field to
 	  ``V4L2_TUNER_RADIO`` for modulators (currently only radio
-	  modulators are supported). See :ref:`v4l2-tuner-type`
+	  modulators are supported). See :c:type:`v4l2_tuner_type`
 
     -  .. row 3
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index 5d209efa0965..a8a542dc8a40 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -147,7 +147,7 @@ To change the radio frequency the
 
        -  ``type``
 
-       -  :cspan:`2` Type of the modulator, see :ref:`v4l2-tuner-type`.
+       -  :cspan:`2` Type of the modulator, see :c:type:`v4l2_tuner_type`.
 
     -  .. row 8
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 689b5d92aeae..eb68c34bb9ac 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -70,7 +70,7 @@ union holding separate parameters for input and output devices.
        -
        -  The buffer (stream) type, same as struct
 	  :c:type:`v4l2_format` ``type``, set by the
-	  application. See :ref:`v4l2-buf-type`
+	  application. See :c:type:`v4l2_buf_type`
 
     -  .. row 2
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
index af38b2568e3b..a687e236d0f1 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-selection.rst
@@ -157,7 +157,7 @@ Selection targets and flags are documented in
        -  ``type``
 
        -  Type of the buffer (from enum
-	  :ref:`v4l2_buf_type <v4l2-buf-type>`).
+	  :c:type:`v4l2_buf_type`).
 
     -  .. row 2
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index 4df7227e0490..04fae524850a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -158,7 +158,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
        -  ``type``
 
-       -  Type of the data stream, see :ref:`v4l2-buf-type`. Should be
+       -  Type of the data stream, see :c:type:`v4l2_buf_type`. Should be
 	  ``V4L2_BUF_TYPE_SLICED_VBI_CAPTURE`` or
 	  ``V4L2_BUF_TYPE_SLICED_VBI_OUTPUT``.
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 077da39f3ae6..bfeeeb22c41f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -96,7 +96,7 @@ To change the radio frequency the
 
        -  ``type``
 
-       -  :cspan:`1` Type of the tuner, see :ref:`v4l2-tuner-type`.
+       -  :cspan:`1` Type of the tuner, see :c:type:`v4l2_tuner_type`.
 
     -  .. row 4
 
@@ -263,7 +263,7 @@ To change the radio frequency the
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
-.. _v4l2-tuner-type:
+.. c:type:: v4l2_tuner_type
 
 .. flat-table:: enum v4l2_tuner_type
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 2824ead350b9..f2785cad2e57 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -436,5 +436,5 @@ appropriately. The generic error codes are described at the
 
 .. [#f1]
    The struct :c:type:`v4l2_framebuffer` lacks an
-   enum :ref:`v4l2_buf_type <v4l2-buf-type>` field, therefore the
+   enum :c:type:`v4l2_buf_type` field, therefore the
    type of overlay is implied by the driver capabilities.
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 1a798be69e10..f3ce0ab53bae 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -124,7 +124,7 @@ See also the examples in :ref:`control`.
 
        -  ``type``
 
-       -  Type of control, see :ref:`v4l2-ctrl-type`.
+       -  Type of control, see :c:type:`v4l2_ctrl_type`.
 
     -  .. row 3
 
@@ -251,7 +251,7 @@ See also the examples in :ref:`control`.
 
        -  ``type``
 
-       -  Type of control, see :ref:`v4l2-ctrl-type`.
+       -  Type of control, see :c:type:`v4l2_ctrl_type`.
 
     -  .. row 3
 
diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index fc63045f4143..2c5291b42592 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -91,7 +91,7 @@ any DMA in progress, an implicit
 
        -  Type of the stream or buffers, this is the same as the struct
 	  :c:type:`v4l2_format` ``type`` field. See
-	  :ref:`v4l2-buf-type` for valid values.
+	  :c:type:`v4l2_buf_type` for valid values.
 
     -  .. row 3
 
@@ -101,7 +101,7 @@ any DMA in progress, an implicit
 
        -  Applications set this field to ``V4L2_MEMORY_MMAP``,
 	  ``V4L2_MEMORY_DMABUF`` or ``V4L2_MEMORY_USERPTR``. See
-	  :ref:`v4l2-memory`.
+	  :c:type:`v4l2_memory`.
 
     -  .. row 4
 
diff --git a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
index e33969b9d3da..fc5e31c63b95 100644
--- a/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/media/uapi/v4l/vidioc-s-hw-freq-seek.rst
@@ -87,7 +87,7 @@ error code is returned and no seek takes place.
 
        -  The tuner type. This is the same value as in the struct
 	  :c:type:`v4l2_tuner` ``type`` field. See
-	  :ref:`v4l2-tuner-type`
+	  :c:type:`v4l2_tuner_type`
 
     -  .. row 3
 
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
index db7145016571..16f2945b73dc 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -43,7 +43,7 @@ when enumerating frame intervals.
 
 To enumerate frame intervals applications initialize the ``index``,
 ``pad``, ``which``, ``code``, ``width`` and ``height`` fields of struct
-:ref:`v4l2_subdev_frame_interval_enum <v4l2-subdev-frame-interval-enum>`
+:c:type:`v4l2_subdev_frame_interval_enum`
 and call the :ref:`VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL` ioctl with a pointer
 to this structure. Drivers fill the rest of the structure or return an
 EINVAL error code if one of the input fields is invalid. All frame
@@ -59,8 +59,7 @@ Sub-devices that support the frame interval enumeration ioctl should
 implemented it on a single pad only. Its behaviour when supported on
 multiple pads of the same sub-device is not defined.
 
-
-.. _v4l2-subdev-frame-interval-enum:
+.. c:type:: v4l2_subdev_frame_interval_enum
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -147,7 +146,7 @@ appropriately. The generic error codes are described at the
 
 EINVAL
     The struct
-    :ref:`v4l2_subdev_frame_interval_enum <v4l2-subdev-frame-interval-enum>`
+    :c:type:`v4l2_subdev_frame_interval_enum`
     ``pad`` references a non-existing pad, one of the ``code``,
     ``width`` or ``height`` fields are invalid for the given pad or the
     ``index`` field is out of bounds.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
index 8d2694a96b7d..972df0f74eae 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-size.rst
@@ -39,7 +39,7 @@ ioctl.
 
 To enumerate frame sizes applications initialize the ``pad``, ``which``
 , ``code`` and ``index`` fields of the struct
-:ref:`v4l2_subdev_mbus_code_enum <v4l2-subdev-mbus-code-enum>` and
+:c:type:`v4l2_subdev_mbus_code_enum` and
 call the :ref:`VIDIOC_SUBDEV_ENUM_FRAME_SIZE` ioctl with a pointer to the
 structure. Drivers fill the minimum and maximum frame sizes or return an
 EINVAL error code if one of the input parameters is invalid.
@@ -62,7 +62,7 @@ current values of V4L2 controls. See
 information about try formats.
 
 
-.. _v4l2-subdev-frame-size-enum:
+.. c:type:: v4l2_subdev_frame_size_enum
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -157,6 +157,6 @@ appropriately. The generic error codes are described at the
 
 EINVAL
     The struct
-    :ref:`v4l2_subdev_frame_size_enum <v4l2-subdev-frame-size-enum>`
+    :c:type:`v4l2_subdev_frame_size_enum`
     ``pad`` references a non-existing pad, the ``code`` is invalid for
     the given pad or the ``index`` field is out of bounds.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
index 5ecc33daba8b..b10da0e81268 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -34,7 +34,7 @@ Description
 To enumerate media bus formats available at a given sub-device pad
 applications initialize the ``pad``, ``which`` and ``index`` fields of
 struct
-:ref:`v4l2_subdev_mbus_code_enum <v4l2-subdev-mbus-code-enum>` and
+:c:type:`v4l2_subdev_mbus_code_enum` and
 call the :ref:`VIDIOC_SUBDEV_ENUM_MBUS_CODE` ioctl with a pointer to this
 structure. Drivers fill the rest of the structure or return an ``EINVAL``
 error code if either the ``pad`` or ``index`` are invalid. All media bus
@@ -47,7 +47,7 @@ See :ref:`VIDIOC_SUBDEV_G_FMT` for more
 information about the try formats.
 
 
-.. _v4l2-subdev-mbus-code-enum:
+.. c:type:: v4l2_subdev_mbus_code_enum
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -110,6 +110,6 @@ appropriately. The generic error codes are described at the
 
 EINVAL
     The struct
-    :ref:`v4l2_subdev_mbus_code_enum <v4l2-subdev-mbus-code-enum>`
+    :c:type:`v4l2_subdev_mbus_code_enum`
     ``pad`` references a non-existing pad, or the ``index`` field is out
     of bounds.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
index 80517ec8a847..b5fa4ae25415 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
@@ -41,7 +41,7 @@ Description
     :ref:`the selection API <VIDIOC_SUBDEV_G_SELECTION>`.
 
 To retrieve the current crop rectangle applications set the ``pad``
-field of a struct :ref:`v4l2_subdev_crop <v4l2-subdev-crop>` to the
+field of a struct :c:type:`v4l2_subdev_crop` to the
 desired pad number as reported by the media API and the ``which`` field
 to ``V4L2_SUBDEV_FORMAT_ACTIVE``. They then call the
 ``VIDIOC_SUBDEV_G_CROP`` ioctl with a pointer to this structure. The
@@ -54,7 +54,7 @@ and ``which`` fields and all members of the ``rect`` field. They then
 call the ``VIDIOC_SUBDEV_S_CROP`` ioctl with a pointer to this
 structure. The driver verifies the requested crop rectangle, adjusts it
 based on the hardware capabilities and configures the device. Upon
-return the struct :ref:`v4l2_subdev_crop <v4l2-subdev-crop>`
+return the struct :c:type:`v4l2_subdev_crop`
 contains the current format as would be returned by a
 ``VIDIOC_SUBDEV_G_CROP`` call.
 
@@ -71,7 +71,7 @@ modify the rectangle to match what the hardware can provide. The
 modified format should be as close as possible to the original request.
 
 
-.. _v4l2-subdev-crop:
+.. c:type:: v4l2_subdev_crop
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -131,7 +131,7 @@ EBUSY
     ``VIDIOC_SUBDEV_S_CROP``
 
 EINVAL
-    The struct :ref:`v4l2_subdev_crop <v4l2-subdev-crop>` ``pad``
+    The struct :c:type:`v4l2_subdev_crop` ``pad``
     references a non-existing pad, the ``which`` field references a
     non-existing format, or cropping is not supported on the given
     subdev pad.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
index 90d876faa5b9..2f7ea274c4c2 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst
@@ -109,7 +109,7 @@ should be as close as possible to the original request.
 
        -  ``format``
 
-       -  Definition of an image format, see :ref:`v4l2-mbus-framefmt` for
+       -  Definition of an image format, see :c:type:`v4l2_mbus_framefmt` for
 	  details.
 
     -  .. row 4
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
index 7580174a6ed1..4b150cc82555 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-frame-interval.rst
@@ -42,7 +42,7 @@ don't support frame intervals must not implement these ioctls.
 
 To retrieve the current frame interval applications set the ``pad``
 field of a struct
-:ref:`v4l2_subdev_frame_interval <v4l2-subdev-frame-interval>` to
+:c:type:`v4l2_subdev_frame_interval` to
 the desired pad number as reported by the media controller API. When
 they call the ``VIDIOC_SUBDEV_G_FRAME_INTERVAL`` ioctl with a pointer to
 this structure the driver fills the members of the ``interval`` field.
@@ -53,7 +53,7 @@ field and all members of the ``interval`` field. When they call the
 structure the driver verifies the requested interval, adjusts it based
 on the hardware capabilities and configures the device. Upon return the
 struct
-:ref:`v4l2_subdev_frame_interval <v4l2-subdev-frame-interval>`
+:c:type:`v4l2_subdev_frame_interval`
 contains the current frame interval as would be returned by a
 ``VIDIOC_SUBDEV_G_FRAME_INTERVAL`` call.
 
@@ -67,7 +67,7 @@ on a single pad only. Their behaviour when supported on multiple pads of
 the same sub-device is not defined.
 
 
-.. _v4l2-subdev-frame-interval:
+.. c:type:: v4l2_subdev_frame_interval
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -119,6 +119,6 @@ EBUSY
 
 EINVAL
     The struct
-    :ref:`v4l2_subdev_frame_interval <v4l2-subdev-frame-interval>`
+    :c:type:`v4l2_subdev_frame_interval`
     ``pad`` references a non-existing pad, or the pad doesn't support
     frame intervals.
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
index d581ff6cf458..94789f8f74e3 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-selection.rst
@@ -65,7 +65,7 @@ Selection targets and flags are documented in
 :ref:`v4l2-selections-common`.
 
 
-.. _v4l2-subdev-selection:
+.. c:type:: v4l2_subdev_selection
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
@@ -141,7 +141,7 @@ EBUSY
     ``VIDIOC_SUBDEV_S_SELECTION``
 
 EINVAL
-    The struct :ref:`v4l2_subdev_selection <v4l2-subdev-selection>`
+    The struct :c:type:`v4l2_subdev_selection`
     ``pad`` references a non-existing pad, the ``which`` field
     references a non-existing format, or the selection target is not
     supported on the given subdev pad.
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index f0b243c48118..3828a2983acb 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -15,115 +15,115 @@ ignore symbol V4L2_TUNER_DIGITAL_TV
 ignore symbol V4L2_COLORSPACE_BT878
 
 # Documented enum v4l2_field
-replace symbol V4L2_FIELD_ALTERNATE v4l2-field
-replace symbol V4L2_FIELD_ANY v4l2-field
-replace symbol V4L2_FIELD_BOTTOM v4l2-field
-replace symbol V4L2_FIELD_INTERLACED v4l2-field
-replace symbol V4L2_FIELD_INTERLACED_BT v4l2-field
-replace symbol V4L2_FIELD_INTERLACED_TB v4l2-field
-replace symbol V4L2_FIELD_NONE v4l2-field
-replace symbol V4L2_FIELD_SEQ_BT v4l2-field
-replace symbol V4L2_FIELD_SEQ_TB v4l2-field
-replace symbol V4L2_FIELD_TOP v4l2-field
+replace symbol V4L2_FIELD_ALTERNATE :c:type:`v4l2_field`
+replace symbol V4L2_FIELD_ANY :c:type:`v4l2_field`
+replace symbol V4L2_FIELD_BOTTOM :c:type:`v4l2_field`
+replace symbol V4L2_FIELD_INTERLACED :c:type:`v4l2_field`
+replace symbol V4L2_FIELD_INTERLACED_BT :c:type:`v4l2_field`
+replace symbol V4L2_FIELD_INTERLACED_TB :c:type:`v4l2_field`
+replace symbol V4L2_FIELD_NONE :c:type:`v4l2_field`
+replace symbol V4L2_FIELD_SEQ_BT :c:type:`v4l2_field`
+replace symbol V4L2_FIELD_SEQ_TB :c:type:`v4l2_field`
+replace symbol V4L2_FIELD_TOP :c:type:`v4l2_field`
 
 # Documented enum v4l2_buf_type
-replace symbol V4L2_BUF_TYPE_SDR_CAPTURE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_SDR_OUTPUT v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_SLICED_VBI_OUTPUT v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VBI_CAPTURE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VBI_OUTPUT v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_CAPTURE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY v4l2-buf-type
-replace symbol V4L2_BUF_TYPE_VIDEO_OVERLAY v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_SDR_CAPTURE :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_SDR_OUTPUT :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_SLICED_VBI_OUTPUT :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_VBI_CAPTURE :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_VBI_OUTPUT :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_VIDEO_CAPTURE :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY :c:type:`v4l2_buf_type`
+replace symbol V4L2_BUF_TYPE_VIDEO_OVERLAY :c:type:`v4l2_buf_type`
 
 # Documented enum v4l2_tuner_type
-replace symbol V4L2_TUNER_ANALOG_TV v4l2-tuner-type
-replace symbol V4L2_TUNER_RADIO v4l2-tuner-type
-replace symbol V4L2_TUNER_RF v4l2-tuner-type
-replace symbol V4L2_TUNER_SDR v4l2-tuner-type
+replace symbol V4L2_TUNER_ANALOG_TV :c:type:`v4l2_tuner_type`
+replace symbol V4L2_TUNER_RADIO :c:type:`v4l2_tuner_type`
+replace symbol V4L2_TUNER_RF :c:type:`v4l2_tuner_type`
+replace symbol V4L2_TUNER_SDR :c:type:`v4l2_tuner_type`
 
 # Documented enum v4l2_memory
-replace symbol V4L2_MEMORY_DMABUF v4l2-memory
-replace symbol V4L2_MEMORY_MMAP v4l2-memory
-replace symbol V4L2_MEMORY_OVERLAY v4l2-memory
-replace symbol V4L2_MEMORY_USERPTR v4l2-memory
+replace symbol V4L2_MEMORY_DMABUF :c:type:`v4l2_memory`
+replace symbol V4L2_MEMORY_MMAP :c:type:`v4l2_memory`
+replace symbol V4L2_MEMORY_OVERLAY :c:type:`v4l2_memory`
+replace symbol V4L2_MEMORY_USERPTR :c:type:`v4l2_memory`
 
 # Documented enum v4l2_colorspace
-replace symbol V4L2_COLORSPACE_470_SYSTEM_BG v4l2-colorspace
-replace symbol V4L2_COLORSPACE_470_SYSTEM_M v4l2-colorspace
-replace symbol V4L2_COLORSPACE_ADOBERGB v4l2-colorspace
-replace symbol V4L2_COLORSPACE_BT2020 v4l2-colorspace
-replace symbol V4L2_COLORSPACE_DCI_P3 v4l2-colorspace
-replace symbol V4L2_COLORSPACE_DEFAULT v4l2-colorspace
-replace symbol V4L2_COLORSPACE_JPEG v4l2-colorspace
-replace symbol V4L2_COLORSPACE_RAW v4l2-colorspace
-replace symbol V4L2_COLORSPACE_REC709 v4l2-colorspace
-replace symbol V4L2_COLORSPACE_SMPTE170M v4l2-colorspace
-replace symbol V4L2_COLORSPACE_SMPTE240M v4l2-colorspace
-replace symbol V4L2_COLORSPACE_SRGB v4l2-colorspace
+replace symbol V4L2_COLORSPACE_470_SYSTEM_BG :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_470_SYSTEM_M :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_ADOBERGB :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_BT2020 :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_DCI_P3 :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_DEFAULT :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_JPEG :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_RAW :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_REC709 :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_SMPTE170M :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_SMPTE240M :c:type:`v4l2_colorspace`
+replace symbol V4L2_COLORSPACE_SRGB :c:type:`v4l2_colorspace`
 
 # Documented enum v4l2_xfer_func
-replace symbol V4L2_XFER_FUNC_709 v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_ADOBERGB v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_DCI_P3 v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_DEFAULT v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_NONE v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_SMPTE2084 v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_SMPTE240M v4l2-xfer-func
-replace symbol V4L2_XFER_FUNC_SRGB v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_709 :c:type:`v4l2_xfer_func`
+replace symbol V4L2_XFER_FUNC_ADOBERGB :c:type:`v4l2_xfer_func`
+replace symbol V4L2_XFER_FUNC_DCI_P3 :c:type:`v4l2_xfer_func`
+replace symbol V4L2_XFER_FUNC_DEFAULT :c:type:`v4l2_xfer_func`
+replace symbol V4L2_XFER_FUNC_NONE :c:type:`v4l2_xfer_func`
+replace symbol V4L2_XFER_FUNC_SMPTE2084 :c:type:`v4l2_xfer_func`
+replace symbol V4L2_XFER_FUNC_SMPTE240M :c:type:`v4l2_xfer_func`
+replace symbol V4L2_XFER_FUNC_SRGB :c:type:`v4l2_xfer_func`
 
 # Documented enum v4l2_ycbcr_encoding
-replace symbol V4L2_YCBCR_ENC_601 v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_709 v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_BT2020 v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_BT2020_CONST_LUM v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_DEFAULT v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_SYCC v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_XV601 v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_XV709 v4l2-ycbcr-encoding
-replace symbol V4L2_YCBCR_ENC_SMPTE240M v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_601 :c:type:`v4l2_ycbcr_encoding`
+replace symbol V4L2_YCBCR_ENC_709 :c:type:`v4l2_ycbcr_encoding`
+replace symbol V4L2_YCBCR_ENC_BT2020 :c:type:`v4l2_ycbcr_encoding`
+replace symbol V4L2_YCBCR_ENC_BT2020_CONST_LUM :c:type:`v4l2_ycbcr_encoding`
+replace symbol V4L2_YCBCR_ENC_DEFAULT :c:type:`v4l2_ycbcr_encoding`
+replace symbol V4L2_YCBCR_ENC_SYCC :c:type:`v4l2_ycbcr_encoding`
+replace symbol V4L2_YCBCR_ENC_XV601 :c:type:`v4l2_ycbcr_encoding`
+replace symbol V4L2_YCBCR_ENC_XV709 :c:type:`v4l2_ycbcr_encoding`
+replace symbol V4L2_YCBCR_ENC_SMPTE240M :c:type:`v4l2_ycbcr_encoding`
 
 # Documented enum v4l2_quantization
-replace symbol V4L2_QUANTIZATION_DEFAULT v4l2-quantization
-replace symbol V4L2_QUANTIZATION_FULL_RANGE v4l2-quantization
-replace symbol V4L2_QUANTIZATION_LIM_RANGE v4l2-quantization
+replace symbol V4L2_QUANTIZATION_DEFAULT :c:type:`v4l2_quantization`
+replace symbol V4L2_QUANTIZATION_FULL_RANGE :c:type:`v4l2_quantization`
+replace symbol V4L2_QUANTIZATION_LIM_RANGE :c:type:`v4l2_quantization`
 
 # Documented enum v4l2_priority
-replace symbol V4L2_PRIORITY_BACKGROUND v4l2-priority
-replace symbol V4L2_PRIORITY_DEFAULT v4l2-priority
-replace symbol V4L2_PRIORITY_INTERACTIVE v4l2-priority
-replace symbol V4L2_PRIORITY_RECORD v4l2-priority
-replace symbol V4L2_PRIORITY_UNSET v4l2-priority
+replace symbol V4L2_PRIORITY_BACKGROUND :c:type:`v4l2_priority`
+replace symbol V4L2_PRIORITY_DEFAULT :c:type:`v4l2_priority`
+replace symbol V4L2_PRIORITY_INTERACTIVE :c:type:`v4l2_priority`
+replace symbol V4L2_PRIORITY_RECORD :c:type:`v4l2_priority`
+replace symbol V4L2_PRIORITY_UNSET :c:type:`v4l2_priority`
 
 # Documented enum v4l2_frmsizetypes
-replace symbol V4L2_FRMSIZE_TYPE_CONTINUOUS v4l2-frmsizetypes
-replace symbol V4L2_FRMSIZE_TYPE_DISCRETE v4l2-frmsizetypes
-replace symbol V4L2_FRMSIZE_TYPE_STEPWISE v4l2-frmsizetypes
+replace symbol V4L2_FRMSIZE_TYPE_CONTINUOUS :c:type:`v4l2_frmsizetypes`
+replace symbol V4L2_FRMSIZE_TYPE_DISCRETE :c:type:`v4l2_frmsizetypes`
+replace symbol V4L2_FRMSIZE_TYPE_STEPWISE :c:type:`v4l2_frmsizetypes`
 
 # Documented enum frmivaltypes
-replace symbol V4L2_FRMIVAL_TYPE_CONTINUOUS v4l2-frmivaltypes
-replace symbol V4L2_FRMIVAL_TYPE_DISCRETE v4l2-frmivaltypes
-replace symbol V4L2_FRMIVAL_TYPE_STEPWISE v4l2-frmivaltypes
+replace symbol V4L2_FRMIVAL_TYPE_CONTINUOUS :c:type:`v4l2_frmivaltypes`
+replace symbol V4L2_FRMIVAL_TYPE_DISCRETE :c:type:`v4l2_frmivaltypes`
+replace symbol V4L2_FRMIVAL_TYPE_STEPWISE :c:type:`v4l2_frmivaltypes`
 
-# Documented enum v4l2-ctrl-type
+# Documented enum :c:type:`v4l2_ctrl_type`
 replace symbol V4L2_CTRL_COMPOUND_TYPES vidioc_queryctrl
 
-replace symbol V4L2_CTRL_TYPE_BITMASK v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_BOOLEAN v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_BUTTON v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_CTRL_CLASS v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_INTEGER v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_INTEGER64 v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_INTEGER_MENU v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_MENU v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_STRING v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_U16 v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_U32 v4l2-ctrl-type
-replace symbol V4L2_CTRL_TYPE_U8 v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_BITMASK :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_BOOLEAN :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_BUTTON :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_CTRL_CLASS :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_INTEGER :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_INTEGER64 :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_INTEGER_MENU :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_MENU :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_STRING :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_U16 :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_ctrl_type`
+replace symbol V4L2_CTRL_TYPE_U8 :c:type:`v4l2_ctrl_type`
 
 # V4L2 capability defines
 replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
@@ -155,7 +155,7 @@ replace define V4L2_CAP_DEVICE_CAPS device-capabilities
 replace define V4L2_CAP_TOUCH device-capabilities
 
 # V4L2 pix flags
-replace define V4L2_PIX_FMT_PRIV_MAGIC v4l2-pix-format
+replace define V4L2_PIX_FMT_PRIV_MAGIC :c:type:`v4l2_pix_format`
 replace define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA reserved-formats
 
 # V4L2 format flags
@@ -205,7 +205,7 @@ replace define V4L2_FBUF_FLAG_SRC_CHROMAKEY framebuffer-flags
 # Used on VIDIOC_G_PARM
 
 replace define V4L2_MODE_HIGHQUALITY parm-flags
-replace define V4L2_CAP_TIMEPERFRAME v4l2-captureparm
+replace define V4L2_CAP_TIMEPERFRAME :c:type:`v4l2_captureparm`
 
 # The V4L2_STD_foo are all defined at v4l2_std_id table
 
@@ -258,11 +258,11 @@ replace define V4L2_STD_ALL v4l2-std-id
 
 # V4L2 DT BT timings definitions
 
-replace define V4L2_DV_PROGRESSIVE v4l2-bt-timings
-replace define V4L2_DV_INTERLACED v4l2-bt-timings
+replace define V4L2_DV_PROGRESSIVE :c:type:`v4l2_bt_timings`
+replace define V4L2_DV_INTERLACED :c:type:`v4l2_bt_timings`
 
-replace define V4L2_DV_VSYNC_POS_POL v4l2-bt-timings
-replace define V4L2_DV_HSYNC_POS_POL v4l2-bt-timings
+replace define V4L2_DV_VSYNC_POS_POL :c:type:`v4l2_bt_timings`
+replace define V4L2_DV_HSYNC_POS_POL :c:type:`v4l2_bt_timings`
 
 replace define V4L2_DV_BT_STD_CEA861 dv-bt-standards
 replace define V4L2_DV_BT_STD_DMT dv-bt-standards
@@ -387,11 +387,11 @@ replace define V4L2_AUDMODE_AVL audio-mode
 
 # MPEG
 
-replace define V4L2_ENC_IDX_FRAME_I v4l2-enc-idx
-replace define V4L2_ENC_IDX_FRAME_P v4l2-enc-idx
-replace define V4L2_ENC_IDX_FRAME_B v4l2-enc-idx
-replace define V4L2_ENC_IDX_FRAME_MASK v4l2-enc-idx
-replace define V4L2_ENC_IDX_ENTRIES v4l2-enc-idx
+replace define V4L2_ENC_IDX_FRAME_I :c:type:`v4l2_enc_idx`
+replace define V4L2_ENC_IDX_FRAME_P :c:type:`v4l2_enc_idx`
+replace define V4L2_ENC_IDX_FRAME_B :c:type:`v4l2_enc_idx`
+replace define V4L2_ENC_IDX_FRAME_MASK :c:type:`v4l2_enc_idx`
+replace define V4L2_ENC_IDX_ENTRIES :c:type:`v4l2_enc_idx`
 
 replace define V4L2_ENC_CMD_START encoder-cmds
 replace define V4L2_ENC_CMD_STOP encoder-cmds
@@ -418,10 +418,10 @@ replace define V4L2_DEC_START_FMT_GOP decoder-cmds
 replace define V4L2_VBI_UNSYNC vbifmt-flags
 replace define V4L2_VBI_INTERLACED vbifmt-flags
 
-replace define V4L2_VBI_ITU_525_F1_START v4l2-vbi-format
-replace define V4L2_VBI_ITU_525_F2_START v4l2-vbi-format
-replace define V4L2_VBI_ITU_625_F1_START v4l2-vbi-format
-replace define V4L2_VBI_ITU_625_F2_START v4l2-vbi-format
+replace define V4L2_VBI_ITU_525_F1_START :c:type:`v4l2_vbi_format`
+replace define V4L2_VBI_ITU_525_F2_START :c:type:`v4l2_vbi_format`
+replace define V4L2_VBI_ITU_625_F1_START :c:type:`v4l2_vbi_format`
+replace define V4L2_VBI_ITU_625_F2_START :c:type:`v4l2_vbi_format`
 
 
 replace define V4L2_SLICED_TELETEXT_B vbi-services
@@ -456,7 +456,7 @@ replace define V4L2_EVENT_CTRL_CH_RANGE ctrl-changes-flags
 
 replace define V4L2_EVENT_SRC_CH_RESOLUTION src-changes-flags
 
-replace define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ v4l2-event-motion-det
+replace define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ :c:type:`v4l2_event_motion_det`
 
 replace define V4L2_EVENT_SUB_FL_SEND_INITIAL event-flags
 replace define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK event-flags
-- 
2.7.4


