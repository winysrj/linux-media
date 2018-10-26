Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35201 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727507AbeJZUz1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Oct 2018 16:55:27 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: v4l uapi docs: few minor corrections and typos
Date: Fri, 26 Oct 2018 13:18:33 +0100
Message-Id: <20181026121833.2053-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/v4l/app-pri.rst      |  2 +-
 Documentation/media/uapi/v4l/audio.rst        |  2 +-
 Documentation/media/uapi/v4l/dev-capture.rst  |  2 +-
 Documentation/media/uapi/v4l/dev-teletext.rst |  2 +-
 Documentation/media/uapi/v4l/format.rst       |  2 +-
 Documentation/media/uapi/v4l/mmap.rst         | 22 +++++++++----------
 Documentation/media/uapi/v4l/open.rst         |  2 +-
 Documentation/media/uapi/v4l/tuner.rst        |  4 ++--
 Documentation/media/uapi/v4l/userp.rst        |  8 +++----
 Documentation/media/uapi/v4l/video.rst        |  4 ++--
 10 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/Documentation/media/uapi/v4l/app-pri.rst b/Documentation/media/uapi/v4l/app-pri.rst
index a8c41a7ec396..e03929ebe899 100644
--- a/Documentation/media/uapi/v4l/app-pri.rst
+++ b/Documentation/media/uapi/v4l/app-pri.rst
@@ -8,7 +8,7 @@ Application Priority
 
 When multiple applications share a device it may be desirable to assign
 them different priorities. Contrary to the traditional "rm -rf /" school
-of thought a video recording application could for example block other
+of thought, a video recording application could for example block other
 applications from changing video controls or switching the current TV
 channel. Another objective is to permit low priority applications
 working in background, which can be preempted by user controlled
diff --git a/Documentation/media/uapi/v4l/audio.rst b/Documentation/media/uapi/v4l/audio.rst
index 5ec99a2809fe..725a61b59cb1 100644
--- a/Documentation/media/uapi/v4l/audio.rst
+++ b/Documentation/media/uapi/v4l/audio.rst
@@ -31,7 +31,7 @@ outputs applications can enumerate them with the
 :ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDOUT>` ioctl, respectively.
 The struct :c:type:`v4l2_audio` returned by the
 :ref:`VIDIOC_ENUMAUDIO` ioctl also contains signal
-:status information applicable when the current audio input is queried.
+status information applicable when the current audio input is queried.
 
 The :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
 :ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDOUT>` ioctls report the current
diff --git a/Documentation/media/uapi/v4l/dev-capture.rst b/Documentation/media/uapi/v4l/dev-capture.rst
index 4218742ab5d9..09949ac54be4 100644
--- a/Documentation/media/uapi/v4l/dev-capture.rst
+++ b/Documentation/media/uapi/v4l/dev-capture.rst
@@ -99,6 +99,6 @@ requests and always returns default parameters as :ref:`VIDIOC_G_FMT <VIDIOC_G_F
 Reading Images
 ==============
 
-A video capture device may support the ::ref:`read() function <func-read>`
+A video capture device may support the :ref:`read() function <func-read>`
 and/or streaming (:ref:`memory mapping <func-mmap>` or
 :ref:`user pointer <userp>`) I/O. See :ref:`io` for details.
diff --git a/Documentation/media/uapi/v4l/dev-teletext.rst b/Documentation/media/uapi/v4l/dev-teletext.rst
index 2648f6b37ea3..436c7393759a 100644
--- a/Documentation/media/uapi/v4l/dev-teletext.rst
+++ b/Documentation/media/uapi/v4l/dev-teletext.rst
@@ -10,7 +10,7 @@ This interface was aimed at devices receiving and demodulating Teletext
 data [:ref:`ets300706`, :ref:`itu653`], evaluating the Teletext
 packages and storing formatted pages in cache memory. Such devices are
 usually implemented as microcontrollers with serial interface
-(I:sup:`2`\ C) and could be found on old TV cards, dedicated Teletext
+(I\ :sup:`2`\ C) and could be found on old TV cards, dedicated Teletext
 decoding cards and home-brew devices connected to the PC parallel port.
 
 The Teletext API was designed by Martin Buck. It was defined in the
diff --git a/Documentation/media/uapi/v4l/format.rst b/Documentation/media/uapi/v4l/format.rst
index 3e3efb0e349e..dc8ccd8bf982 100644
--- a/Documentation/media/uapi/v4l/format.rst
+++ b/Documentation/media/uapi/v4l/format.rst
@@ -12,7 +12,7 @@ Data Format Negotiation
 
 Different devices exchange different kinds of data with applications,
 for example video images, raw or sliced VBI data, RDS datagrams. Even
-within one kind many different formats are possible, in particular an
+within one kind many different formats are possible, in particular there is an
 abundance of image formats. Although drivers must provide a default and
 the selection persists across closing and reopening a device,
 applications should always negotiate a data format before engaging in
diff --git a/Documentation/media/uapi/v4l/mmap.rst b/Documentation/media/uapi/v4l/mmap.rst
index 670596c1a4f7..0f0968799e69 100644
--- a/Documentation/media/uapi/v4l/mmap.rst
+++ b/Documentation/media/uapi/v4l/mmap.rst
@@ -231,17 +231,17 @@ up the output is started with :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`.
 In the write loop, when the application runs out of free buffers, it
 must wait until an empty buffer can be dequeued and reused.
 
-To enqueue and dequeue a buffer applications use the :ref:`VIDIOC_QBUF`
-and :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. The status of a buffer
-being mapped, enqueued, full or empty can be determined at any time
-using the :ref:`VIDIOC_QUERYBUF` ioctl. Two methods exist to suspend
-execution of the application until one or more buffers can be dequeued.
-By default :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` blocks when no buffer is
-in the outgoing queue. When the ``O_NONBLOCK`` flag was given to the
-:ref:`open() <func-open>` function, :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`
-returns immediately with an ``EAGAIN`` error code when no buffer is
-available. The :ref:`select() <func-select>` or :ref:`poll()
-<func-poll>` functions are always available.
+To enqueue and dequeue a buffer applications use the
+:ref:`VIVIOC_QBUF <VIDIOC_QBUF>` and :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`
+ioctl. The status of a buffer being mapped, enqueued, full or empty can
+be determined at any time using the :ref:`VIDIOC_QUERYBUF` ioctl. Two
+methods exist to suspend execution of the application until one or more
+buffers can be dequeued.  By default :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`
+blocks when no buffer is in the outgoing queue. When the ``O_NONBLOCK``
+flag was given to the :ref:`open() <func-open>` function,
+:ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` returns immediately with an ``EAGAIN``
+error code when no buffer is available. The :ref:`select() <func-select>`
+or :ref:`poll() <func-poll>` functions are always available.
 
 To start and stop capturing or output applications call the
 :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and :ref:`VIDIOC_STREAMOFF
diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index afd116edb40d..251a788d80f1 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -53,7 +53,7 @@ ranges. These ranges are listed in :ref:`devices`.
 
 The creation of character special files (with mknod) is a privileged
 operation and devices cannot be opened by major and minor number. That
-means applications cannot *reliable* scan for loaded or installed
+means applications cannot *reliably* scan for loaded or installed
 drivers. The user must enter a device name, or the application can try
 the conventional device names.
 
diff --git a/Documentation/media/uapi/v4l/tuner.rst b/Documentation/media/uapi/v4l/tuner.rst
index ad117b068831..178a0aea4d3a 100644
--- a/Documentation/media/uapi/v4l/tuner.rst
+++ b/Documentation/media/uapi/v4l/tuner.rst
@@ -31,7 +31,7 @@ current video or radio input is queried.
 .. note::
 
    :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` does not switch the
-   current tuner, when there is more than one at all. The tuner is solely
+   current tuner, when there is more than one. The tuner is solely
    determined by the current video input. Drivers must support both ioctls
    and set the ``V4L2_CAP_TUNER`` flag in the struct :c:type:`v4l2_capability`
    returned by the :ref:`VIDIOC_QUERYCAP` ioctl when the
@@ -41,7 +41,7 @@ current video or radio input is queried.
 Modulators
 ==========
 
-Video output devices can have one or more modulators, uh, modulating a
+Video output devices can have one or more modulators, that modulate a
 video signal for radiation or connection to the antenna input of a TV
 set or video recorder. Each modulator is associated with one or more
 video outputs, depending on the number of RF connectors on the
diff --git a/Documentation/media/uapi/v4l/userp.rst b/Documentation/media/uapi/v4l/userp.rst
index dc2893a60d65..e25715a2c6fa 100644
--- a/Documentation/media/uapi/v4l/userp.rst
+++ b/Documentation/media/uapi/v4l/userp.rst
@@ -62,9 +62,9 @@ memory pages at any time between the completion of the DMA and this
 ioctl. The memory is also unlocked when
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` is called,
 :ref:`VIDIOC_REQBUFS`, or when the device is closed.
-Applications must take care not to free buffers without dequeuing. For
-once, the buffers remain locked until further, wasting physical memory.
-Second the driver will not be notified when the memory is returned to
+Applications must take care not to free buffers without dequeuing.
+Firstly, the buffers remain locked for longer, wasting physical memory.
+Secondly the driver will not be notified when the memory is returned to
 the application's free list and subsequently reused for other purposes,
 possibly completing the requested DMA and overwriting valuable data.
 
@@ -90,7 +90,7 @@ To start and stop capturing or output applications call the
 
 .. note::
 
-   ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` removes all buffers from
+   :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` removes all buffers from
    both queues and unlocks all buffers as a side effect. Since there is no
    notion of doing anything "now" on a multitasking system, if an
    application needs to synchronize with another event it should examine
diff --git a/Documentation/media/uapi/v4l/video.rst b/Documentation/media/uapi/v4l/video.rst
index d2bc06b064ad..054af871c217 100644
--- a/Documentation/media/uapi/v4l/video.rst
+++ b/Documentation/media/uapi/v4l/video.rst
@@ -7,7 +7,7 @@ Video Inputs and Outputs
 ************************
 
 Video inputs and outputs are physical connectors of a device. These can
-be for example RF connectors (antenna/cable), CVBS a.k.a. Composite
+be for example: RF connectors (antenna/cable), CVBS a.k.a. Composite
 Video, S-Video and RGB connectors. Camera sensors are also considered to
 be a video input. Video and VBI capture devices have inputs. Video and
 VBI output devices have outputs, at least one each. Radio devices have
@@ -19,7 +19,7 @@ outputs applications can enumerate them with the
 :ref:`VIDIOC_ENUMOUTPUT` ioctl, respectively. The
 struct :c:type:`v4l2_input` returned by the
 :ref:`VIDIOC_ENUMINPUT` ioctl also contains signal
-:status information applicable when the current video input is queried.
+status information applicable when the current video input is queried.
 
 The :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
 :ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` ioctls return the index of
-- 
2.17.2
