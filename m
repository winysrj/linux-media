Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42320 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbcGMLQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 07:16:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/2] [media] doc-rst: use the right markup for footnotes
Date: Wed, 13 Jul 2016 08:15:47 -0300
Message-Id: <4855307b81f02af4853e02cba2ce16eb29376548.1468408280.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According with ReST spec, footnotes should be like:
[#name], and not [name]. So, change them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/audio.rst             |  4 +--
 Documentation/media/uapi/v4l/control.rst           |  4 +--
 Documentation/media/uapi/v4l/dev-overlay.rst       | 16 +++++-----
 Documentation/media/uapi/v4l/dev-raw-vbi.rst       | 18 +++++------
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |  4 +--
 Documentation/media/uapi/v4l/diff-v4l.rst          | 36 +++++++++++-----------
 Documentation/media/uapi/v4l/extended-controls.rst |  4 +--
 Documentation/media/uapi/v4l/format.rst            |  4 +--
 Documentation/media/uapi/v4l/func-select.rst       |  4 +--
 Documentation/media/uapi/v4l/hist-v4l2.rst         |  4 +--
 Documentation/media/uapi/v4l/mmap.rst              | 12 ++++----
 Documentation/media/uapi/v4l/open.rst              | 12 ++++----
 Documentation/media/uapi/v4l/rw.rst                |  8 ++---
 Documentation/media/uapi/v4l/standard.rst          |  4 +--
 Documentation/media/uapi/v4l/userp.rst             |  8 ++---
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    | 26 ++++++++--------
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |  4 +--
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |  8 ++---
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |  4 +--
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  4 +--
 20 files changed, 94 insertions(+), 94 deletions(-)

diff --git a/Documentation/media/uapi/v4l/audio.rst b/Documentation/media/uapi/v4l/audio.rst
index cd3057326de7..4dd11345866c 100644
--- a/Documentation/media/uapi/v4l/audio.rst
+++ b/Documentation/media/uapi/v4l/audio.rst
@@ -11,7 +11,7 @@ capture devices have inputs, output devices have outputs, zero or more
 each. Radio devices have no audio inputs or outputs. They have exactly
 one tuner which in fact *is* an audio source, but this API associates
 tuners with video inputs or outputs only, and radio devices have none of
-these. [1]_ A connector on a TV card to loop back the received audio
+these. [#f1]_ A connector on a TV card to loop back the received audio
 signal to a sound card is not considered an audio output.
 
 Audio and video inputs and outputs are associated. Selecting a video
@@ -88,7 +88,7 @@ Example: Switching to the first audio input
 	exit(EXIT_FAILURE);
     }
 
-.. [1]
+.. [#f1]
    Actually struct :ref:`v4l2_audio <v4l2-audio>` ought to have a
    ``tuner`` field like struct :ref:`v4l2_input <v4l2-input>`, not
    only making the API more consistent but also permitting radio devices
diff --git a/Documentation/media/uapi/v4l/control.rst b/Documentation/media/uapi/v4l/control.rst
index feb55ac14377..10ab53dd3163 100644
--- a/Documentation/media/uapi/v4l/control.rst
+++ b/Documentation/media/uapi/v4l/control.rst
@@ -17,7 +17,7 @@ device.
 
 All controls are accessed using an ID value. V4L2 defines several IDs
 for specific purposes. Drivers can also implement their own custom
-controls using ``V4L2_CID_PRIVATE_BASE``  [1]_ and higher values. The
+controls using ``V4L2_CID_PRIVATE_BASE``  [#f1]_ and higher values. The
 pre-defined control IDs have the prefix ``V4L2_CID_``, and are listed in
 :ref:`control-id`. The ID is used when querying the attributes of a
 control, and when getting or setting the current value.
@@ -522,7 +522,7 @@ Example: Changing controls
     /* Errors ignored */
     ioctl(fd, VIDIOC_S_CTRL, &control);
 
-.. [1]
+.. [#f1]
    The use of ``V4L2_CID_PRIVATE_BASE`` is problematic because different
    drivers may use the same ``V4L2_CID_PRIVATE_BASE`` ID for different
    controls. This makes it hard to programatically set such controls
diff --git a/Documentation/media/uapi/v4l/dev-overlay.rst b/Documentation/media/uapi/v4l/dev-overlay.rst
index bf8a418e7554..3edb53bfaa27 100644
--- a/Documentation/media/uapi/v4l/dev-overlay.rst
+++ b/Documentation/media/uapi/v4l/dev-overlay.rst
@@ -33,7 +33,7 @@ Applications should use different file descriptors for capturing and
 overlay. This must be supported by all drivers capable of simultaneous
 capturing and overlay. Optionally these drivers may also permit
 capturing and overlay with a single file descriptor for compatibility
-with V4L and earlier versions of V4L2. [1]_
+with V4L and earlier versions of V4L2. [#f1]_
 
 
 Querying Capabilities
@@ -216,7 +216,7 @@ bits like:
 
     ((__u8 *) bitmap)[w.width * y + x / 8] & (1 << (x & 7))
 
-where ``0`` ≤ x < ``w.width`` and ``0`` ≤ y <``w.height``. [2]_
+where ``0`` ≤ x < ``w.width`` and ``0`` ≤ y <``w.height``. [#f2]_
 
 When a clipping bit mask is not supported the driver ignores this field,
 its contents after calling :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` are
@@ -227,7 +227,7 @@ Applications need not create a clip list or bit mask. When they pass
 both, or despite negotiating chroma-keying, the results are undefined.
 Regardless of the chosen method, the clipping abilities of the hardware
 may be limited in quantity or quality. The results when these limits are
-exceeded are undefined. [3]_
+exceeded are undefined. [#f3]_
 
 ``__u8 global_alpha``
     The global alpha value used to blend the framebuffer with video
@@ -244,7 +244,7 @@ exceeded are undefined. [3]_
 
 .. _v4l2-clip:
 
-struct v4l2_clip [4]_
+struct v4l2_clip [#f4]_
 ---------------------
 
 ``struct v4l2_rect c``
@@ -284,7 +284,7 @@ Enabling Overlay
 To start or stop the frame buffer overlay applications call the
 :ref:`VIDIOC_OVERLAY` ioctl.
 
-.. [1]
+.. [#f1]
    A common application of two file descriptors is the XFree86
    :ref:`Xv/V4L <xvideo>` interface driver and a V4L2 application.
    While the X server controls video overlay, the application can take
@@ -301,17 +301,17 @@ To start or stop the frame buffer overlay applications call the
    Hence as a complexity trade-off drivers *must* support two file
    descriptors and *may* support single fd operation.
 
-.. [2]
+.. [#f2]
    Should we require ``w.width`` to be a multiple of eight?
 
-.. [3]
+.. [#f3]
    When the image is written into frame buffer memory it will be
    undesirable if the driver clips out less pixels than expected,
    because the application and graphics system are not aware these
    regions need to be refreshed. The driver should clip out more pixels
    or not write the image at all.
 
-.. [4]
+.. [#f4]
    The X Window system defines "regions" which are vectors of ``struct
    BoxRec { short x1, y1, x2, y2; }`` with ``width = x2 - x1`` and
    ``height = y2 - y1``, so one cannot pass X11 clip lists directly.
diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi.rst b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
index da85be88d57e..d5a4b3530b69 100644
--- a/Documentation/media/uapi/v4l/dev-raw-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-raw-vbi.rst
@@ -11,7 +11,7 @@ sequence of lines of an analog video signal. During VBI no picture
 information is transmitted, allowing some time while the electron beam
 of a cathode ray tube TV returns to the top of the screen. Using an
 oscilloscope you will find here the vertical synchronization pulses and
-short data packages ASK modulated [1]_ onto the video signal. These are
+short data packages ASK modulated [#f1]_ onto the video signal. These are
 transmissions of services such as Teletext or Closed Caption.
 
 Subject of this interface type is raw VBI data, as sampled off a video
@@ -143,7 +143,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
        -  ``sample_format``
 
        -  Defines the sample format as in :ref:`pixfmt`, a
-	  four-character-code. [2]_ Usually this is ``V4L2_PIX_FMT_GREY``,
+	  four-character-code. [#f2]_ Usually this is ``V4L2_PIX_FMT_GREY``,
 	  i. e. each sample consists of 8 bits with lower values oriented
 	  towards the black level. Do not assume any other correlation of
 	  values with the signal level. For example, the MSB does not
@@ -155,7 +155,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
        -  __u32
 
-       -  ``start``\ [2]_
+       -  ``start``\ [#f2]_
 
        -  This is the scanning system line number associated with the first
 	  line of the VBI image, of the first and the second field
@@ -173,7 +173,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
        -  __u32
 
-       -  ``count``\ [2]_
+       -  ``count``\ [#f2]_
 
        -  The number of lines in the first and second field image,
 	  respectively.
@@ -218,7 +218,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 
        -  __u32
 
-       -  ``reserved``\ [2]_
+       -  ``reserved``\ [#f2]_
 
        -  This array is reserved for future extensions. Drivers and
 	  applications must set it to zero.
@@ -245,7 +245,7 @@ and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` does
 	  or bottom field depending on the video standard. When this flag is
 	  set the first or second field may be stored first, however the
 	  fields are still in correct temporal order with the older field
-	  first in memory. [3]_
+	  first in memory. [#f3]_
 
     -  .. row 2
 
@@ -336,15 +336,15 @@ points returning an ``EBUSY`` error code if the required hardware resources
 are temporarily unavailable, for example the device is already in use by
 another process.
 
-.. [1]
+.. [#f1]
    ASK: Amplitude-Shift Keying. A high signal level represents a '1'
    bit, a low level a '0' bit.
 
-.. [2]
+.. [#f2]
    A few devices may be unable to sample VBI data at all but can extend
    the video capture window to the VBI region.
 
-.. [3]
+.. [#f3]
    Most VBI services transmit on both fields, but some have different
    semantics depending on the field number. These cannot be reliable
    decoded or encoded when ``V4L2_VBI_UNSYNC`` is set.
diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index fbd04fee0484..ec52a825f4d6 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -126,7 +126,7 @@ struct v4l2_sliced_vbi_format
 	  specified in this field. For example, if ``service_set`` is
 	  initialized with ``V4L2_SLICED_TELETEXT_B | V4L2_SLICED_WSS_625``,
 	  a driver for the cx25840 video decoder sets lines 7-22 of both
-	  fields [1]_ to ``V4L2_SLICED_TELETEXT_B`` and line 23 of the first
+	  fields [#f1]_ to ``V4L2_SLICED_TELETEXT_B`` and line 23 of the first
 	  field to ``V4L2_SLICED_WSS_625``. If ``service_set`` is set to
 	  zero, then the values of ``service_lines`` will be used instead.
 
@@ -817,6 +817,6 @@ Line Identifiers for struct v4l2_mpeg_vbi_itv0_line id field
 
 
 
-.. [1]
+.. [#f1]
    According to :ref:`ETS 300 706 <ets300706>` lines 6-22 of the first
    field and lines 5-22 of the second field may carry Teletext data.
diff --git a/Documentation/media/uapi/v4l/diff-v4l.rst b/Documentation/media/uapi/v4l/diff-v4l.rst
index 5f45ec123162..e1e034df514c 100644
--- a/Documentation/media/uapi/v4l/diff-v4l.rst
+++ b/Documentation/media/uapi/v4l/diff-v4l.rst
@@ -52,7 +52,7 @@ using driver module options. The major device number remains 81.
 
        -  Video capture and overlay
 
-       -  ``/dev/video`` and ``/dev/bttv0``\  [1]_, ``/dev/video0`` to
+       -  ``/dev/video`` and ``/dev/bttv0``\  [#f1]_, ``/dev/video0`` to
 	  ``/dev/video63``
 
        -  0-63
@@ -61,7 +61,7 @@ using driver module options. The major device number remains 81.
 
        -  Radio receiver
 
-       -  ``/dev/radio``\  [2]_, ``/dev/radio0`` to ``/dev/radio63``
+       -  ``/dev/radio``\  [#f2]_, ``/dev/radio0`` to ``/dev/radio63``
 
        -  64-127
 
@@ -457,7 +457,7 @@ into the struct :ref:`v4l2_pix_format <v4l2-pix-format>`:
 
        -  ``VIDEO_PALETTE_HI240``
 
-       -  :ref:`V4L2_PIX_FMT_HI240 <pixfmt-reserved>` [3]_
+       -  :ref:`V4L2_PIX_FMT_HI240 <pixfmt-reserved>` [#f3]_
 
     -  .. row 4
 
@@ -481,7 +481,7 @@ into the struct :ref:`v4l2_pix_format <v4l2-pix-format>`:
 
        -  ``VIDEO_PALETTE_RGB32``
 
-       -  :ref:`V4L2_PIX_FMT_BGR32 <pixfmt-rgb>` [4]_
+       -  :ref:`V4L2_PIX_FMT_BGR32 <pixfmt-rgb>` [#f4]_
 
     -  .. row 8
 
@@ -491,7 +491,7 @@ into the struct :ref:`v4l2_pix_format <v4l2-pix-format>`:
 
     -  .. row 9
 
-       -  ``VIDEO_PALETTE_YUYV``\  [5]_
+       -  ``VIDEO_PALETTE_YUYV``\  [#f5]_
 
        -  :ref:`V4L2_PIX_FMT_YUYV <V4L2-PIX-FMT-YUYV>`
 
@@ -511,13 +511,13 @@ into the struct :ref:`v4l2_pix_format <v4l2-pix-format>`:
 
        -  ``VIDEO_PALETTE_YUV411``
 
-       -  :ref:`V4L2_PIX_FMT_Y41P <V4L2-PIX-FMT-Y41P>` [6]_
+       -  :ref:`V4L2_PIX_FMT_Y41P <V4L2-PIX-FMT-Y41P>` [#f6]_
 
     -  .. row 13
 
        -  ``VIDEO_PALETTE_RAW``
 
-       -  None [7]_
+       -  None [#f7]_
 
     -  .. row 14
 
@@ -529,7 +529,7 @@ into the struct :ref:`v4l2_pix_format <v4l2-pix-format>`:
 
        -  ``VIDEO_PALETTE_YUV411P``
 
-       -  :ref:`V4L2_PIX_FMT_YUV411P <V4L2-PIX-FMT-YUV411P>` [8]_
+       -  :ref:`V4L2_PIX_FMT_YUV411P <V4L2-PIX-FMT-YUV411P>` [#f8]_
 
     -  .. row 16
 
@@ -876,7 +876,7 @@ with the following parameters:
 
        -  count[]
 
-       -  16, 16 [9]_
+       -  16, 16 [#f9]_
 
     -  .. row 8
 
@@ -915,40 +915,40 @@ No replacement exists for ``VIDIOCKEY``, and the V4L functions for
 microcode programming. A new interface for MPEG compression and playback
 devices is documented in :ref:`extended-controls`.
 
-.. [1]
+.. [#f1]
    According to Documentation/devices.txt these should be symbolic links
    to ``/dev/video0``. Note the original bttv interface is not
    compatible with V4L or V4L2.
 
-.. [2]
+.. [#f2]
    According to ``Documentation/devices.txt`` a symbolic link to
    ``/dev/radio0``.
 
-.. [3]
+.. [#f3]
    This is a custom format used by the BTTV driver, not one of the V4L2
    standard formats.
 
-.. [4]
+.. [#f4]
    Presumably all V4L RGB formats are little-endian, although some
    drivers might interpret them according to machine endianness. V4L2
    defines little-endian, big-endian and red/blue swapped variants. For
    details see :ref:`pixfmt-rgb`.
 
-.. [5]
+.. [#f5]
    ``VIDEO_PALETTE_YUV422`` and ``VIDEO_PALETTE_YUYV`` are the same
    formats. Some V4L drivers respond to one, some to the other.
 
-.. [6]
+.. [#f6]
    Not to be confused with ``V4L2_PIX_FMT_YUV411P``, which is a planar
    format.
 
-.. [7]
+.. [#f7]
    V4L explains this as: "RAW capture (BT848)"
 
-.. [8]
+.. [#f8]
    Not to be confused with ``V4L2_PIX_FMT_Y41P``, which is a packed
    format.
 
-.. [9]
+.. [#f9]
    Old driver versions used different values, eventually the custom
    ``BTTV_VBISIZE`` ioctl was added to query the correct values.
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 11d15d3190e9..71071d73747d 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -3183,7 +3183,7 @@ Camera Control IDs
     of the illumination varies significantly throughout the scene, i.e.
     there are simultaneously very dark and very bright areas. It is most
     commonly realized in cameras by combining two subsequent frames with
-    different exposure times.  [1]_
+    different exposure times.  [#f1]_
 
 .. _v4l2-image-stabilization:
 
@@ -4526,6 +4526,6 @@ RF_TUNER Control IDs
     Is synthesizer PLL locked? RF tuner is receiving given frequency
     when that control is set. This is a read-only control.
 
-.. [1]
+.. [#f1]
    This control may be changed to a menu control in the future, if more
    options are required.
diff --git a/Documentation/media/uapi/v4l/format.rst b/Documentation/media/uapi/v4l/format.rst
index a29dd9466b8f..7c73278849ca 100644
--- a/Documentation/media/uapi/v4l/format.rst
+++ b/Documentation/media/uapi/v4l/format.rst
@@ -73,7 +73,7 @@ Image Format Enumeration
 
 Apart of the generic format negotiation functions a special ioctl to
 enumerate all image formats supported by video capture, overlay or
-output devices is available. [1]_
+output devices is available. [#f1]_
 
 The :ref:`VIDIOC_ENUM_FMT` ioctl must be supported
 by all drivers exchanging image data with applications.
@@ -85,7 +85,7 @@ by all drivers exchanging image data with applications.
     If necessary driver writers should publish an example conversion
     routine or library for integration into applications.
 
-.. [1]
+.. [#f1]
    Enumerating formats an application has no a-priori knowledge of
    (otherwise it could explicitly ask for them and need not enumerate)
    seems useless, but there are applications serving as proxy between
diff --git a/Documentation/media/uapi/v4l/func-select.rst b/Documentation/media/uapi/v4l/func-select.rst
index 954dd00b8301..7798384ae396 100644
--- a/Documentation/media/uapi/v4l/func-select.rst
+++ b/Documentation/media/uapi/v4l/func-select.rst
@@ -50,7 +50,7 @@ set appropriately. When the application did not call
 :ref:`VIDIOC_STREAMON` yet the :ref:`select() <func-select>`
 function succeeds, setting the bit of the file descriptor in ``readfds``
 or ``writefds``, but subsequent :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`
-calls will fail. [1]_
+calls will fail. [#f1]_
 
 When use of the :ref:`read() <func-read>` function has been negotiated and the
 driver does not capture yet, the :ref:`select() <func-select>` function starts
@@ -100,7 +100,7 @@ EINVAL
     The ``nfds`` argument is less than zero or greater than
     ``FD_SETSIZE``.
 
-.. [1]
+.. [#f1]
    The Linux kernel implements :ref:`select() <func-select>` like the
    :ref:`poll() <func-poll>` function, but :ref:`select() <func-select>` cannot
    return a ``POLLERR``.
diff --git a/Documentation/media/uapi/v4l/hist-v4l2.rst b/Documentation/media/uapi/v4l/hist-v4l2.rst
index a571e099fde7..3ba1c0c2df1a 100644
--- a/Documentation/media/uapi/v4l/hist-v4l2.rst
+++ b/Documentation/media/uapi/v4l/hist-v4l2.rst
@@ -1391,7 +1391,7 @@ the X Window system, implemented for example by the XFree86 project. Its
 scope is similar to V4L2, an API to video capture and output devices for
 X clients. Xv allows applications to display live video in a window,
 send window contents to a TV output, and capture or output still images
-in XPixmaps [1]_. With their implementation XFree86 makes the extension
+in XPixmaps [#f1]_. With their implementation XFree86 makes the extension
 available across many operating systems and architectures.
 
 Because the driver is embedded into the X server Xv has a number of
@@ -1476,5 +1476,5 @@ should not be implemented in new drivers.
    ``VIDIOC_SUBDEV_G_SELECTION`` and ``VIDIOC_SUBDEV_S_SELECTION``,
    :ref:`VIDIOC_SUBDEV_G_SELECTION`.
 
-.. [1]
+.. [#f1]
    This is not implemented in XFree86.
diff --git a/Documentation/media/uapi/v4l/mmap.rst b/Documentation/media/uapi/v4l/mmap.rst
index 260c2db8916b..7ad5d5e76163 100644
--- a/Documentation/media/uapi/v4l/mmap.rst
+++ b/Documentation/media/uapi/v4l/mmap.rst
@@ -26,7 +26,7 @@ memory.
 A driver can support many sets of buffers. Each set is identified by a
 unique buffer type value. The sets are independent and each set can hold
 a different type of data. To access different sets at the same time
-different file descriptors must be used. [1]_
+different file descriptors must be used. [#f1]_
 
 To allocate device buffers applications call the
 :ref:`VIDIOC_REQBUFS` ioctl with the desired number
@@ -217,7 +217,7 @@ The driver may require a minimum number of buffers enqueued at all times
 to function, apart of this no limit exists on the number of buffers
 applications can enqueue in advance, or dequeue and process. They can
 also enqueue in a different order than buffers have been dequeued, and
-the driver can *fill* enqueued *empty* buffers in any order.  [2]_ The
+the driver can *fill* enqueued *empty* buffers in any order.  [#f2]_ The
 index number of a buffer (struct :ref:`v4l2_buffer <v4l2-buffer>`
 ``index``) plays no role here, it only identifies the buffer.
 
@@ -260,11 +260,11 @@ Drivers implementing memory mapping I/O must support the
 <VIDIOC_QBUF>`, :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
 and :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls, the :ref:`mmap()
 <func-mmap>`, :ref:`munmap() <func-munmap>`, :ref:`select()
-<func-select>` and :ref:`poll() <func-poll>` function. [3]_
+<func-select>` and :ref:`poll() <func-poll>` function. [#f3]_
 
 [capture example]
 
-.. [1]
+.. [#f1]
    One could use one file descriptor and set the buffer type field
    accordingly when calling :ref:`VIDIOC_QBUF` etc.,
    but it makes the :ref:`select() <func-select>` function ambiguous. We also
@@ -272,14 +272,14 @@ and :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls, the :ref:`mmap()
    Video overlay for example is also a logical stream, although the CPU
    is not needed for continuous operation.
 
-.. [2]
+.. [#f2]
    Random enqueue order permits applications processing images out of
    order (such as video codecs) to return buffers earlier, reducing the
    probability of data loss. Random fill order allows drivers to reuse
    buffers on a LIFO-basis, taking advantage of caches holding
    scatter-gather lists and the like.
 
-.. [3]
+.. [#f3]
    At the driver level :ref:`select() <func-select>` and :ref:`poll() <func-poll>` are
    the same, and :ref:`select() <func-select>` is too important to be optional.
    The rest should be evident.
diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index a3e39df91e9d..afd116edb40d 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -99,12 +99,12 @@ linux-media mailing list:
 Multiple Opens
 ==============
 
-V4L2 devices can be opened more than once. [1]_ When this is supported
+V4L2 devices can be opened more than once. [#f1]_ When this is supported
 by the driver, users can for example start a "panel" application to
 change controls like brightness or audio volume, while another
 application captures video and audio. In other words, panel applications
 are comparable to an ALSA audio mixer application. Just opening a V4L2
-device should not change the state of the device. [2]_
+device should not change the state of the device. [#f2]_
 
 Once an application has allocated the memory buffers needed for
 streaming data (by calling the :ref:`VIDIOC_REQBUFS`
@@ -117,7 +117,7 @@ that would affect the buffer sizes (e.g. by calling the
 no longer allowed to allocate buffers or start or stop streaming. The
 EBUSY error code will be returned instead.
 
-Merely opening a V4L2 device does not grant exclusive access. [3]_
+Merely opening a V4L2 device does not grant exclusive access. [#f3]_
 Initiating data exchange however assigns the right to read or write the
 requested type of data, and to change related properties, to this file
 descriptor. Applications can request additional access privileges using
@@ -142,17 +142,17 @@ respectively. Devices are programmed using the
 :ref:`ioctl() <func-ioctl>` function as explained in the following
 sections.
 
-.. [1]
+.. [#f1]
    There are still some old and obscure drivers that have not been
    updated to allow for multiple opens. This implies that for such
    drivers :ref:`open() <func-open>` can return an ``EBUSY`` error code
    when the device is already in use.
 
-.. [2]
+.. [#f2]
    Unfortunately, opening a radio device often switches the state of the
    device to radio mode in many drivers. This behavior should be fixed
    eventually as it violates the V4L2 specification.
 
-.. [3]
+.. [#f3]
    Drivers could recognize the ``O_EXCL`` open flag. Presently this is
    not required, so applications cannot know if it really works.
diff --git a/Documentation/media/uapi/v4l/rw.rst b/Documentation/media/uapi/v4l/rw.rst
index 66ba54648c45..dcac379c484f 100644
--- a/Documentation/media/uapi/v4l/rw.rst
+++ b/Documentation/media/uapi/v4l/rw.rst
@@ -31,17 +31,17 @@ vidctrl tool is fictitious):
 To read from the device applications use the :ref:`read() <func-read>`
 function, to write the :ref:`write() <func-write>` function. Drivers
 must implement one I/O method if they exchange data with applications,
-but it need not be this. [1]_ When reading or writing is supported, the
+but it need not be this. [#f1]_ When reading or writing is supported, the
 driver must also support the :ref:`select() <func-select>` and
-:ref:`poll() <func-poll>` function. [2]_
+:ref:`poll() <func-poll>` function. [#f2]_
 
-.. [1]
+.. [#f1]
    It would be desirable if applications could depend on drivers
    supporting all I/O interfaces, but as much as the complex memory
    mapping I/O can be inadequate for some devices we have no reason to
    require this interface, which is most useful for simple applications
    capturing still images.
 
-.. [2]
+.. [#f2]
    At the driver level :ref:`select() <func-select>` and :ref:`poll() <func-poll>` are
    the same, and :ref:`select() <func-select>` is too important to be optional.
diff --git a/Documentation/media/uapi/v4l/standard.rst b/Documentation/media/uapi/v4l/standard.rst
index 9c390c2a128a..c4f678f545ec 100644
--- a/Documentation/media/uapi/v4l/standard.rst
+++ b/Documentation/media/uapi/v4l/standard.rst
@@ -33,7 +33,7 @@ signals. The first enumerated standard is a set of B and G/PAL, switched
 automatically depending on the selected radio frequency in UHF or VHF
 band. Enumeration gives a "PAL-B/G" or "PAL-I" choice. Similar a
 Composite input may collapse standards, enumerating "PAL-B/G/H/I",
-"NTSC-M" and "SECAM-D/K". [1]_
+"NTSC-M" and "SECAM-D/K". [#f1]_
 
 To query and select the standard used by the current video input or
 output applications call the :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and
@@ -177,7 +177,7 @@ Example: Selecting a new video standard
 	exit(EXIT_FAILURE);
     }
 
-.. [1]
+.. [#f1]
    Some users are already confused by technical terms PAL, NTSC and
    SECAM. There is no point asking them to distinguish between B, G, D,
    or K when the software or hardware can do that automatically.
diff --git a/Documentation/media/uapi/v4l/userp.rst b/Documentation/media/uapi/v4l/userp.rst
index 601963a33acb..1d8b14bd4cdc 100644
--- a/Documentation/media/uapi/v4l/userp.rst
+++ b/Documentation/media/uapi/v4l/userp.rst
@@ -54,7 +54,7 @@ driver swaps memory pages within physical memory to create a continuous
 area of memory. This happens transparently to the application in the
 virtual memory subsystem of the kernel. When buffer pages have been
 swapped out to disk they are brought back and finally locked in physical
-memory for DMA. [1]_
+memory for DMA. [#f1]_
 
 Filled or displayed buffers are dequeued with the
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. The driver can unlock the
@@ -99,9 +99,9 @@ Drivers implementing user pointer I/O must support the
 :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`, :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
 and :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls, the
-:ref:`select() <func-select>` and :ref:`poll() <func-poll>` function. [2]_
+:ref:`select() <func-select>` and :ref:`poll() <func-poll>` function. [#f2]_
 
-.. [1]
+.. [#f1]
    We expect that frequently used buffers are typically not swapped out.
    Anyway, the process of swapping, locking or generating scatter-gather
    lists may be time consuming. The delay can be masked by the depth of
@@ -113,7 +113,7 @@ and :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls, the
    disk. Output buffers must be saved on the incoming and outgoing queue
    because an application may share them with other processes.
 
-.. [2]
+.. [#f2]
    At the driver level :ref:`select() <func-select>` and :ref:`poll() <func-poll>` are
    the same, and :ref:`select() <func-select>` is too important to be optional.
    The rest should be evident.
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index ce911c81bd3d..6699b26cdeb4 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -41,7 +41,7 @@ structure or return an ``EINVAL`` error code when the index is out of
 bounds. To enumerate all standards applications shall begin at index
 zero, incrementing by one until the driver returns ``EINVAL``. Drivers may
 enumerate a different set of standards after switching the video input
-or output. [1]_
+or output. [#f1]_
 
 
 .. _v4l2-standard:
@@ -278,11 +278,11 @@ support digital TV. See also the Linux DVB API at
 
        -  Characteristics
 
-       -  M/NTSC [2]_
+       -  M/NTSC [#f2]_
 
        -  M/PAL
 
-       -  N/PAL [3]_
+       -  N/PAL [#f3]_
 
        -  B, B1, G/PAL
 
@@ -369,7 +369,7 @@ support digital TV. See also the Linux DVB API at
 
        -  + 4.5
 
-       -  + 5.5 ± 0.001  [4]_  [5]_  [6]_  [7]_
+       -  + 5.5 ± 0.001  [#f4]_  [#f5]_  [#f6]_  [#f7]_
 
        -  + 6.5 ± 0.001
 
@@ -383,7 +383,7 @@ support digital TV. See also the Linux DVB API at
 
        -  + 6.5
 
-       -  + 6.5  [8]_
+       -  + 6.5  [#f8]_
 
 
 Return Value
@@ -400,42 +400,42 @@ EINVAL
 ENODATA
     Standard video timings are not supported for this input or output.
 
-.. [1]
+.. [#f1]
    The supported standards may overlap and we need an unambiguous set to
    find the current standard returned by :ref:`VIDIOC_G_STD <VIDIOC_G_STD>`.
 
-.. [2]
+.. [#f2]
    Japan uses a standard similar to M/NTSC (V4L2_STD_NTSC_M_JP).
 
-.. [3]
+.. [#f3]
    The values in brackets apply to the combination N/PAL a.k.a.
    N\ :sub:`C` used in Argentina (V4L2_STD_PAL_Nc).
 
-.. [4]
+.. [#f4]
    In the Federal Republic of Germany, Austria, Italy, the Netherlands,
    Slovakia and Switzerland a system of two sound carriers is used, the
    frequency of the second carrier being 242.1875 kHz above the
    frequency of the first sound carrier. For stereophonic sound
    transmissions a similar system is used in Australia.
 
-.. [5]
+.. [#f5]
    New Zealand uses a sound carrier displaced 5.4996 ± 0.0005 MHz from
    the vision carrier.
 
-.. [6]
+.. [#f6]
    In Denmark, Finland, New Zealand, Sweden and Spain a system of two
    sound carriers is used. In Iceland, Norway and Poland the same system
    is being introduced. The second carrier is 5.85 MHz above the vision
    carrier and is DQPSK modulated with 728 kbit/s sound and data
    multiplex. (NICAM system)
 
-.. [7]
+.. [#f7]
    In the United Kingdom, a system of two sound carriers is used. The
    second sound carrier is 6.552 MHz above the vision carrier and is
    DQPSK modulated with a 728 kbit/s sound and data multiplex able to
    carry two sound channels. (NICAM system)
 
-.. [8]
+.. [#f8]
    In France, a digital carrier 5.85 MHz away from the vision carrier
    may be used in addition to the main sound carrier. It is modulated in
    differentially encoded QPSK with a 728 kbit/s sound and data
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index ef4592c338ef..d182d9f5a50d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -112,7 +112,7 @@ destructive video overlay.
 
        -
        -  Physical base address of the framebuffer, that is the address of
-	  the pixel in the top left corner of the framebuffer. [1]_
+	  the pixel in the top left corner of the framebuffer. [#f1]_
 
     -  .. row 4
 
@@ -492,7 +492,7 @@ EPERM
 EINVAL
     The :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>` parameters are unsuitable.
 
-.. [1]
+.. [#f1]
    A physical base address may not suit all platforms. GK notes in
    theory we should pass something like PCI device + memory region +
    offset instead. If you encounter problems please discuss on the
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index c82085513bee..614db06b8b4b 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -622,7 +622,7 @@ To change the radio frequency the
 
        -  ``LANG2 = SAP``
 
-       -  ``LANG1_LANG2``\  [1]_
+       -  ``LANG1_LANG2``\  [#f1]_
 
     -  .. row 3
 
@@ -686,7 +686,7 @@ To change the radio frequency the
 
        -  Language 1
 
-       -  Lang1/Lang2 (deprecated [2]_) or Lang1/Lang1
+       -  Lang1/Lang2 (deprecated [#f2]_) or Lang1/Lang1
 
        -  Language 1
 
@@ -706,11 +706,11 @@ EINVAL
     The struct :ref:`v4l2_tuner <v4l2-tuner>` ``index`` is out of
     bounds.
 
-.. [1]
+.. [#f1]
    This mode has been added in Linux 2.6.17 and may not be supported by
    older drivers.
 
-.. [2]
+.. [#f2]
    Playback of both languages in ``MODE_STEREO`` is deprecated. In the
    future drivers should produce only the primary language in this mode.
    Applications should request ``MODE_LANG1_LANG2`` to record both
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index f0271f834ac1..b10fed313f99 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -301,7 +301,7 @@ specification the ioctl returns an ``EINVAL`` error code.
 	  secondary function of video output devices and overlays an image
 	  onto an outgoing video signal. When the driver sets this flag, it
 	  must clear the ``V4L2_CAP_VIDEO_OVERLAY`` flag and vice
-	  versa. [1]_
+	  versa. [#f1]_
 
     -  .. row 14
 
@@ -428,7 +428,7 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-.. [1]
+.. [#f1]
    The struct :ref:`v4l2_framebuffer <v4l2-framebuffer>` lacks an
    enum :ref:`v4l2_buf_type <v4l2-buf-type>` field, therefore the
    type of overlay is implied by the driver capabilities.
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 4342aceddd57..8d6e61a7284d 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -53,7 +53,7 @@ returns ``EINVAL``.
 
 In both cases, when the driver sets the ``V4L2_CTRL_FLAG_DISABLED`` flag
 in the ``flags`` field this control is permanently disabled and should
-be ignored by the application. [1]_
+be ignored by the application. [#f1]_
 
 When the application ORs ``id`` with ``V4L2_CTRL_FLAG_NEXT_CTRL`` the
 driver returns the next supported non-compound control, or ``EINVAL`` if
@@ -776,7 +776,7 @@ EINVAL
 EACCES
     An attempt was made to read a write-only control.
 
-.. [1]
+.. [#f1]
    ``V4L2_CTRL_FLAG_DISABLED`` was intended for two purposes: Drivers
    can skip predefined controls not supported by the hardware (although
    returning ``EINVAL`` would do as well), or disable predefined and private
-- 
2.7.4

