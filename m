Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43799 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941745AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 42/47] [media] hist-v4l2.rst: don't do refs to old structures
Date: Thu,  8 Sep 2016 09:04:04 -0300
Message-Id: <1a4d42c17cda3c315d7827fc10e9bdbe0ab76429.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several structs were renamed or removed during V4L2 development.
Don't try to cross-reference the legacy ones.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/hist-v4l2.rst | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/media/uapi/v4l/hist-v4l2.rst b/Documentation/media/uapi/v4l/hist-v4l2.rst
index b18fb7e6c39a..d86d6343a20a 100644
--- a/Documentation/media/uapi/v4l/hist-v4l2.rst
+++ b/Documentation/media/uapi/v4l/hist-v4l2.rst
@@ -30,14 +30,14 @@ aliases ``O_NONCAP`` and ``O_NOIO`` were defined. Applications can set
 this flag if they intend to access controls only, as opposed to capture
 applications which need exclusive access. The ``VIDEO_STD_XXX``
 identifiers are now ordinals instead of flags, and the
-:c:func:`video_std_construct()` helper function takes id and
+``video_std_construct()`` helper function takes id and
 transmission arguments.
 
 1998-09-28: Revamped video standard. Made video controls individually
 enumerable.
 
 1998-10-02: The ``id`` field was removed from struct
-struct :c:type:`video_standard` and the color subcarrier fields were
+struct ``video_standard`` and the color subcarrier fields were
 renamed. The :ref:`VIDIOC_QUERYSTD` ioctl was
 renamed to :ref:`VIDIOC_ENUMSTD`,
 :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` to
@@ -254,7 +254,7 @@ multiple tuners into account.)
 2000-09-18: ``V4L2_BUF_TYPE_VBI`` was added. This may *break
 compatibility* as the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and
 :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctls may fail now if the struct
-struct :c:type:`v4l2_fmt` ``type`` field does not contain
+struct ``v4l2_fmt`` ``type`` field does not contain
 ``V4L2_BUF_TYPE_VBI``. In the documentation of the struct
 :c:type:`v4l2_vbi_format` ``offset`` field the
 ambiguous phrase "rising edge" was changed to "leading edge".
@@ -415,7 +415,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     originally needed to distguish between variations of standards, were
     removed.
 
-    Struct struct :c:type:`v4l2_enumstd` ceased to be.
+    Struct ``v4l2_enumstd`` ceased to be.
     :ref:`VIDIOC_ENUMSTD` now takes a pointer to a
     struct :c:type:`v4l2_standard` directly. The
     information which standards are supported by a particular video
@@ -671,11 +671,11 @@ This unnamed version was finally merged into Linux 2.5.46.
     distinguish between field and frame (interlaced) overlay.
 
 17. The digital zoom interface, including struct
-    struct :c:type:`v4l2_zoomcap`, struct
-    struct :c:type:`v4l2_zoom`, ``V4L2_ZOOM_NONCAP`` and
+    struct ``v4l2_zoomcap``, struct
+    struct ``v4l2_zoom``, ``V4L2_ZOOM_NONCAP`` and
     ``V4L2_ZOOM_WHILESTREAMING`` was replaced by a new cropping and
     scaling interface. The previously unused struct
-    struct :c:type:`v4l2_cropcap` and :c:type:`struct v4l2_crop`
+    struct :c:type:`v4l2_cropcap` and struct :c:type:`v4l2_crop`
     where redefined for this purpose. See :ref:`crop` for details.
 
 18. In struct :c:type:`v4l2_vbi_format` the
@@ -694,7 +694,7 @@ This unnamed version was finally merged into Linux 2.5.46.
     Similar changes were made to struct
     :c:type:`v4l2_outputparm`.
 
-20. The struct :c:type:`v4l2_performance` and
+20. The struct ``v4l2_performance`` and
     ``VIDIOC_G_PERF`` ioctl were dropped. Except when using the
     :ref:`read/write I/O method <rw>`, which is limited anyway, this
     information is already available to applications.
@@ -882,7 +882,7 @@ V4L2 in Linux 2.6.15
 3. The ``VIDIOC_G_COMP`` and ``VIDIOC_S_COMP`` ioctl were renamed to
    ``VIDIOC_G_MPEGCOMP`` and ``VIDIOC_S_MPEGCOMP`` respectively. Their
    argument was replaced by a struct
-   struct :c:type:`v4l2_mpeg_compression` pointer. (The
+   ``v4l2_mpeg_compression`` pointer. (The
    ``VIDIOC_G_MPEGCOMP`` and ``VIDIOC_S_MPEGCOMP`` ioctls where removed
    in Linux 2.6.25.)
 
@@ -982,7 +982,7 @@ V4L2 in Linux 2.6.18
    flag to skip unsupported controls with
    :ref:`VIDIOC_QUERYCTRL`, new control types
    ``V4L2_CTRL_TYPE_INTEGER64`` and ``V4L2_CTRL_TYPE_CTRL_CLASS``
-   (:ref:`v4l2-ctrl-type`), and new control flags
+   (:c:type:`v4l2_ctrl_type`), and new control flags
    ``V4L2_CTRL_FLAG_READ_ONLY``, ``V4L2_CTRL_FLAG_UPDATE``,
    ``V4L2_CTRL_FLAG_INACTIVE`` and ``V4L2_CTRL_FLAG_SLIDER``
    (:ref:`control-flags`). See :ref:`extended-controls` for details.
@@ -1127,8 +1127,8 @@ V4L2 in Linux 2.6.29
 1. The ``VIDIOC_G_CHIP_IDENT`` ioctl was renamed to
    ``VIDIOC_G_CHIP_IDENT_OLD`` and ``VIDIOC_DBG_G_CHIP_IDENT`` was
    introduced in its place. The old struct
-   struct :c:type:`v4l2_chip_ident` was renamed to
-   struct :c:type:`v4l2_chip_ident_old`.
+   struct ``v4l2_chip_ident`` was renamed to
+   struct ``v4l2_chip_ident_old``.
 
 2. The pixel formats ``V4L2_PIX_FMT_VYUY``, ``V4L2_PIX_FMT_NV16`` and
    ``V4L2_PIX_FMT_NV61`` were added.
-- 
2.7.4


