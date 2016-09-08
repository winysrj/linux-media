Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965473AbcIHMEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 16/47] [media] diff-v4l.rst: Fix V4L version 1 references
Date: Thu,  8 Sep 2016 09:03:38 -0300
Message-Id: <325dbb136e63466705f5054100a36f8e6300a7fa.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L version 1 structures had long gone from the Linux Kernel.
It doesn't make sense to use cross-references for them, as they
won't be found.

So, get rid of them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/diff-v4l.rst | 38 +++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/media/uapi/v4l/diff-v4l.rst b/Documentation/media/uapi/v4l/diff-v4l.rst
index 93794e015e7c..0419e2051759 100644
--- a/Documentation/media/uapi/v4l/diff-v4l.rst
+++ b/Documentation/media/uapi/v4l/diff-v4l.rst
@@ -87,7 +87,7 @@ Querying Capabilities
 The V4L ``VIDIOCGCAP`` ioctl is equivalent to V4L2's
 :ref:`VIDIOC_QUERYCAP`.
 
-The ``name`` field in struct :c:type:`struct video_capability` became
+The ``name`` field in struct ``video_capability`` became
 ``card`` in struct :c:type:`v4l2_capability`, ``type``
 was replaced by ``capabilities``. Note V4L2 does not distinguish between
 device types like this, better think of basic video input, video output
@@ -264,7 +264,7 @@ Video Sources
 =============
 
 V4L provides the ``VIDIOCGCHAN`` and ``VIDIOCSCHAN`` ioctl using struct
-:c:type:`struct video_channel` to enumerate the video inputs of a V4L
+``video_channel`` to enumerate the video inputs of a V4L
 device. The equivalent V4L2 ioctls are
 :ref:`VIDIOC_ENUMINPUT`,
 :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
@@ -283,7 +283,7 @@ video input types were renamed as follows:
 
     -  .. row 1
 
-       -  struct :c:type:`struct video_channel` ``type``
+       -  struct ``video_channel`` ``type``
 
        -  struct :c:type:`v4l2_input` ``type``
 
@@ -328,7 +328,7 @@ Tuning
 ======
 
 The V4L ``VIDIOCGTUNER`` and ``VIDIOCSTUNER`` ioctl and struct
-:c:type:`struct video_tuner` can be used to enumerate the tuners of a
+``video_tuner`` can be used to enumerate the tuners of a
 V4L TV or radio device. The equivalent V4L2 ioctls are
 :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>` and
 :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` using struct
@@ -374,7 +374,7 @@ Image Properties
 ================
 
 V4L2 has no equivalent of the ``VIDIOCGPICT`` and ``VIDIOCSPICT`` ioctl
-and struct :c:type:`struct video_picture`. The following fields where
+and struct ``video_picture``. The following fields where
 replaced by V4L2 controls accessible with the
 :ref:`VIDIOC_QUERYCTRL`,
 :ref:`VIDIOC_G_CTRL <VIDIOC_G_CTRL>` and
@@ -389,7 +389,7 @@ replaced by V4L2 controls accessible with the
 
     -  .. row 1
 
-       -  struct :c:type:`struct video_picture`
+       -  struct ``video_picture``
 
        -  V4L2 Control ID
 
@@ -445,7 +445,7 @@ into the struct :c:type:`v4l2_pix_format`:
 
     -  .. row 1
 
-       -  struct :c:type:`struct video_picture` ``palette``
+       -  struct ``video_picture`` ``palette``
 
        -  struct :c:type:`v4l2_pix_format` ``pixfmt``
 
@@ -554,7 +554,7 @@ Audio
 =====
 
 The ``VIDIOCGAUDIO`` and ``VIDIOCSAUDIO`` ioctl and struct
-:c:type:`struct video_audio` are used to enumerate the audio inputs
+``video_audio`` are used to enumerate the audio inputs
 of a V4L device. The equivalent V4L2 ioctls are
 :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
 :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>` using struct
@@ -591,7 +591,7 @@ The following fields where replaced by V4L2 controls accessible with the
 
     -  .. row 1
 
-       -  struct :c:type:`struct video_audio`
+       -  struct ``video_audio``
 
        -  V4L2 Control ID
 
@@ -629,7 +629,7 @@ and ``VIDEO_AUDIO_MUTE`` flags where replaced by the boolean
 ``V4L2_CID_AUDIO_MUTE`` control.
 
 All V4L2 controls have a ``step`` attribute replacing the struct
-:c:type:`struct video_audio` ``step`` field. The V4L audio controls
+``video_audio`` ``step`` field. The V4L audio controls
 are assumed to range from 0 to 65535 with no particular reset value. The
 V4L2 API permits arbitrary limits and defaults which can be queried with
 the :ref:`VIDIOC_QUERYCTRL` ioctl. For general
@@ -642,7 +642,7 @@ Frame Buffer Overlay
 The V4L2 ioctls equivalent to ``VIDIOCGFBUF`` and ``VIDIOCSFBUF`` are
 :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>` and
 :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`. The ``base`` field of struct
-:c:type:`struct video_buffer` remained unchanged, except V4L2 defines
+``video_buffer`` remained unchanged, except V4L2 defines
 a flag to indicate non-destructive overlays instead of a ``NULL``
 pointer. All other fields moved into the struct
 :c:type:`v4l2_pix_format` ``fmt`` substructure of
@@ -659,13 +659,13 @@ of the ``fmt`` union is used, a struct
 :c:type:`v4l2_window`.
 
 The ``x``, ``y``, ``width`` and ``height`` fields of struct
-:c:type:`struct video_window` moved into struct
+``video_window`` moved into struct
 :c:type:`v4l2_rect` substructure ``w`` of struct
-:c:type:`struct v4l2_window`. The ``chromakey``, ``clips``, and
+:c:type:`v4l2_window`. The ``chromakey``, ``clips``, and
 ``clipcount`` fields remained unchanged. Struct
-:c:type:`struct video_clip` was renamed to struct
+``video_clip`` was renamed to struct
 :c:type:`v4l2_clip`, also containing a struct
-:c:type:`struct v4l2_rect`, but the semantics are still the same.
+:c:type:`v4l2_rect`, but the semantics are still the same.
 
 The ``VIDEO_WINDOW_INTERLACE`` flag was dropped. Instead applications
 must set the ``field`` field to ``V4L2_FIELD_ANY`` or
@@ -675,7 +675,7 @@ name ``V4L2_FBUF_FLAG_CHROMAKEY``.
 
 In V4L, storing a bitmap pointer in ``clips`` and setting ``clipcount``
 to ``VIDEO_CLIP_BITMAP`` (-1) requests bitmap clipping, using a fixed
-size bitmap of 1024 × 625 bits. Struct :c:type:`struct v4l2_window`
+size bitmap of 1024 × 625 bits. Struct :c:type:`v4l2_window`
 has a separate ``bitmap`` pointer field for this purpose and the bitmap
 size is determined by ``w.width`` and ``w.height``.
 
@@ -688,7 +688,7 @@ Cropping
 
 To capture only a subsection of the full picture V4L defines the
 ``VIDIOCGCAPTURE`` and ``VIDIOCSCAPTURE`` ioctls using struct
-:c:type:`struct video_capture`. The equivalent V4L2 ioctls are
+``video_capture``. The equivalent V4L2 ioctls are
 :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
 :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` using struct
 :c:type:`v4l2_crop`, and the related
@@ -697,7 +697,7 @@ complex matter, see :ref:`crop` for details.
 
 The ``x``, ``y``, ``width`` and ``height`` fields moved into struct
 :c:type:`v4l2_rect` substructure ``c`` of struct
-:c:type:`struct v4l2_crop`. The ``decimation`` field was dropped. In
+:c:type:`v4l2_crop`. The ``decimation`` field was dropped. In
 the V4L2 API the scaling factor is implied by the size of the cropping
 rectangle and the size of the captured or overlaid image.
 
@@ -889,7 +889,7 @@ with the following parameters:
 
 Undocumented in the V4L specification, in Linux 2.3 the
 ``VIDIOCGVBIFMT`` and ``VIDIOCSVBIFMT`` ioctls using struct
-:c:type:`struct vbi_format` were added to determine the VBI image
+``vbi_format`` were added to determine the VBI image
 parameters. These ioctls are only partially compatible with the V4L2 VBI
 interface specified in :ref:`raw-vbi`.
 
-- 
2.7.4


