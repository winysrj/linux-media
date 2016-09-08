Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43879 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965305AbcIHMET (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 38/47] [media] docs-rst: fix some broken struct references
Date: Thu,  8 Sep 2016 09:04:00 -0300
Message-Id: <fe009f43d24b425fe26c2828c746ca6905ea102a.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The :c:type: references point to the structure name, and not to
struct foo.

Fixed via this shell script:

	for i in `find Documentation/media -type f`; do perl -ne 'if (s/\:c\:type\:\`struct\s*(\S+)\`/struct :c:type:`$1`/) { s/struct\s+struct/struct/;  s/(struct\s+\:c\:type\:\`\S+\`)\s+structure/$1/;  } print $_' <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-func-poll.rst |  2 +-
 Documentation/media/uapi/v4l/buffer.rst        |  2 +-
 Documentation/media/uapi/v4l/dev-osd.rst       |  4 +--
 Documentation/media/uapi/v4l/hist-v4l2.rst     | 34 +++++++++++++-------------
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index 5bacb7c6f33b..cfb73e6027a5 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -49,7 +49,7 @@ events.
 
 On success :c:func:`poll()` returns the number of file descriptors
 that have been selected (that is, file descriptors for which the
-``revents`` field of the respective :c:type:`struct pollfd` structure
+``revents`` field of the respective struct :c:type:`pollfd`
 is non-zero). CEC devices set the ``POLLIN`` and ``POLLRDNORM`` flags in
 the ``revents`` field if there are messages in the receive queue. If the
 transmit queue has room for new messages, the ``POLLOUT`` and
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 7b64a1986d66..7d2d81a771b1 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -825,7 +825,7 @@ Timecodes
 
 The struct :c:type:`v4l2_timecode` structure is designed to hold a
 :ref:`smpte12m` or similar timecode. (struct
-:c:type:`struct timeval` timestamps are stored in struct
+struct :c:type:`timeval` timestamps are stored in struct
 :c:type:`v4l2_buffer` field ``timestamp``.)
 
 
diff --git a/Documentation/media/uapi/v4l/dev-osd.rst b/Documentation/media/uapi/v4l/dev-osd.rst
index 0b246c31b6a3..71da85ed7e4b 100644
--- a/Documentation/media/uapi/v4l/dev-osd.rst
+++ b/Documentation/media/uapi/v4l/dev-osd.rst
@@ -44,8 +44,8 @@ other information, the physical address of the framebuffer in the
 ``base`` field of struct :c:type:`v4l2_framebuffer`.
 The framebuffer device ioctl ``FBIOGET_FSCREENINFO`` returns the same
 address in the ``smem_start`` field of struct
-:c:type:`struct fb_fix_screeninfo`. The ``FBIOGET_FSCREENINFO``
-ioctl and struct :c:type:`struct fb_fix_screeninfo` are defined in
+struct :c:type:`fb_fix_screeninfo`. The ``FBIOGET_FSCREENINFO``
+ioctl and struct :c:type:`fb_fix_screeninfo` are defined in
 the ``linux/fb.h`` header file.
 
 The width and height of the framebuffer depends on the current video
diff --git a/Documentation/media/uapi/v4l/hist-v4l2.rst b/Documentation/media/uapi/v4l/hist-v4l2.rst
index bd45431ed00e..b18fb7e6c39a 100644
--- a/Documentation/media/uapi/v4l/hist-v4l2.rst
+++ b/Documentation/media/uapi/v4l/hist-v4l2.rst
@@ -37,7 +37,7 @@ transmission arguments.
 enumerable.
 
 1998-10-02: The ``id`` field was removed from struct
-:c:type:`struct video_standard` and the color subcarrier fields were
+struct :c:type:`video_standard` and the color subcarrier fields were
 renamed. The :ref:`VIDIOC_QUERYSTD` ioctl was
 renamed to :ref:`VIDIOC_ENUMSTD`,
 :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` to
@@ -151,7 +151,7 @@ common Linux driver API conventions.
    This change obsoletes the following ioctls: ``VIDIOC_S_INFMT``,
    ``VIDIOC_G_INFMT``, ``VIDIOC_S_OUTFMT``, ``VIDIOC_G_OUTFMT``,
    ``VIDIOC_S_VBIFMT`` and ``VIDIOC_G_VBIFMT``. The image format
-   structure :c:type:`struct v4l2_format` was renamed to struct
+   structure struct :c:type:`v4l2_format` was renamed to struct
    :c:type:`v4l2_pix_format`, while struct
    :c:type:`v4l2_format` is now the envelopping structure
    for all format negotiations.
@@ -254,7 +254,7 @@ multiple tuners into account.)
 2000-09-18: ``V4L2_BUF_TYPE_VBI`` was added. This may *break
 compatibility* as the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls may fail now if the struct
-:c:type:`struct v4l2_fmt` ``type`` field does not contain
+struct :c:type:`v4l2_fmt` ``type`` field does not contain
 ``V4L2_BUF_TYPE_VBI``. In the documentation of the struct
 :c:type:`v4l2_vbi_format` ``offset`` field the
 ambiguous phrase "rising edge" was changed to "leading edge".
@@ -415,7 +415,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     originally needed to distguish between variations of standards, were
     removed.
 
-    Struct :c:type:`struct v4l2_enumstd` ceased to be.
+    Struct struct :c:type:`v4l2_enumstd` ceased to be.
     :ref:`VIDIOC_ENUMSTD` now takes a pointer to a
     struct :c:type:`v4l2_standard` directly. The
     information which standards are supported by a particular video
@@ -636,7 +636,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     removed. Since no unadjusted system time clock was added to the
     kernel as planned, the ``timestamp`` field changed back from type
     stamp_t, an unsigned 64 bit integer expressing the sample time in
-    nanoseconds, to struct :c:type:`struct timeval`. With the addition
+    nanoseconds, to struct :c:type:`timeval`. With the addition
     of a second memory mapping method the ``offset`` field moved into
     union ``m``, and a new ``memory`` field of type enum
     :ref:`v4l2_memory <v4l2-memory>` was added to distinguish between
@@ -671,11 +671,11 @@ This unnamed version was finally merged into Linux 2.5.46.
     distinguish between field and frame (interlaced) overlay.
 
 17. The digital zoom interface, including struct
-    :c:type:`struct v4l2_zoomcap`, struct
-    :c:type:`struct v4l2_zoom`, ``V4L2_ZOOM_NONCAP`` and
+    struct :c:type:`v4l2_zoomcap`, struct
+    struct :c:type:`v4l2_zoom`, ``V4L2_ZOOM_NONCAP`` and
     ``V4L2_ZOOM_WHILESTREAMING`` was replaced by a new cropping and
     scaling interface. The previously unused struct
-    :c:type:`struct v4l2_cropcap` and :c:type:`struct v4l2_crop`
+    struct :c:type:`v4l2_cropcap` and :c:type:`struct v4l2_crop`
     where redefined for this purpose. See :ref:`crop` for details.
 
 18. In struct :c:type:`v4l2_vbi_format` the
@@ -694,7 +694,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     Similar changes were made to struct
     :c:type:`v4l2_outputparm`.
 
-20. The struct :c:type:`struct v4l2_performance` and
+20. The struct :c:type:`v4l2_performance` and
     ``VIDIOC_G_PERF`` ioctl were dropped. Except when using the
     :ref:`read/write I/O method <rw>`, which is limited anyway, this
     information is already available to applications.
@@ -882,7 +882,7 @@ V4L2 in Linux 2.6.15
 3. The ``VIDIOC_G_COMP`` and ``VIDIOC_S_COMP`` ioctl were renamed to
    ``VIDIOC_G_MPEGCOMP`` and ``VIDIOC_S_MPEGCOMP`` respectively. Their
    argument was replaced by a struct
-   :c:type:`struct v4l2_mpeg_compression` pointer. (The
+   struct :c:type:`v4l2_mpeg_compression` pointer. (The
    ``VIDIOC_G_MPEGCOMP`` and ``VIDIOC_S_MPEGCOMP`` ioctls where removed
    in Linux 2.6.25.)
 
@@ -925,7 +925,7 @@ V4L2 spec erratum 2006-02-04
 1. The ``clips`` field in struct :c:type:`v4l2_window`
    must point to an array of struct :c:type:`v4l2_clip`, not
    a linked list, because drivers ignore the struct
-   :c:type:`struct v4l2_clip`. ``next`` pointer.
+   struct :c:type:`v4l2_clip`. ``next`` pointer.
 
 
 V4L2 in Linux 2.6.17
@@ -1040,7 +1040,7 @@ V4L2 in Linux 2.6.22
    A new ``global_alpha`` field was added to
    :c:type:`v4l2_window`, extending the structure. This
    may *break compatibility* with applications using a struct
-   :c:type:`struct v4l2_window` directly. However the
+   struct :c:type:`v4l2_window` directly. However the
    :ref:`VIDIOC_G/S/TRY_FMT <VIDIOC_G_FMT>` ioctls, which take a
    pointer to a :c:type:`v4l2_format` parent structure
    with padding bytes at the end, are not affected.
@@ -1127,8 +1127,8 @@ V4L2 in Linux 2.6.29
 1. The ``VIDIOC_G_CHIP_IDENT`` ioctl was renamed to
    ``VIDIOC_G_CHIP_IDENT_OLD`` and ``VIDIOC_DBG_G_CHIP_IDENT`` was
    introduced in its place. The old struct
-   :c:type:`struct v4l2_chip_ident` was renamed to
-   :c:type:`struct v4l2_chip_ident_old`.
+   struct :c:type:`v4l2_chip_ident` was renamed to
+   struct :c:type:`v4l2_chip_ident_old`.
 
 2. The pixel formats ``V4L2_PIX_FMT_VYUY``, ``V4L2_PIX_FMT_NV16`` and
    ``V4L2_PIX_FMT_NV61`` were added.
@@ -1279,7 +1279,7 @@ V4L2 in Linux 3.5
 V4L2 in Linux 3.6
 =================
 
-1. Replaced ``input`` in :c:type:`struct v4l2_buffer` by
+1. Replaced ``input`` in struct :c:type:`v4l2_buffer` by
    ``reserved2`` and removed ``V4L2_BUF_FLAG_INPUT``.
 
 2. Added V4L2_CAP_VIDEO_M2M and V4L2_CAP_VIDEO_M2M_MPLANE
@@ -1293,7 +1293,7 @@ V4L2 in Linux 3.9
 =================
 
 1. Added timestamp types to ``flags`` field in
-   :c:type:`struct v4l2_buffer`. See :ref:`buffer-flags`.
+   struct :c:type:`v4l2_buffer`. See :ref:`buffer-flags`.
 
 2. Added ``V4L2_EVENT_CTRL_CH_RANGE`` control event changes flag. See
    :ref:`ctrl-changes-flags`.
@@ -1320,7 +1320,7 @@ V4L2 in Linux 3.11
 V4L2 in Linux 3.14
 ==================
 
-1. In struct :c:type:`struct v4l2_rect`, the type of ``width`` and
+1. In struct :c:type:`v4l2_rect`, the type of ``width`` and
    ``height`` fields changed from _s32 to _u32.
 
 
-- 
2.7.4


