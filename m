Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbcGDLr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 28/51] Documentation: linux_tv: Error codes should be const
Date: Mon,  4 Jul 2016 08:46:49 -0300
Message-Id: <5a3131968ee8a9ffa0451c7eac97a6d0d112d7c8.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All error codes should be const. Most are, but there are
lots of places where we forgot to add <constant> at the DocBook.

Fix those via this small script:
	for i in $(git grep -lE "\s+E[A-Z]+\b" Documentation/linux_tv/); do perl -ne 's,([^\`])\b(E[A-Z]+)\b,\1``\2``,g; print $_' <$i >a && mv a $i; done

As there are false positives, we needed to merge only the changes
that make sense, skipping the c blocks and skipping things like
EDID, EN, ETS that were also converted by the above code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst  |   6 ++--
 .../linux_tv/media/dvb/FE_GET_FRONTEND.rst         |   2 +-
 .../linux_tv/media/dvb/FE_SET_FRONTEND.rst         |   2 +-
 .../linux_tv/media/dvb/audio_function_calls.rst    |  22 ++++++------
 .../linux_tv/media/dvb/ca_function_calls.rst       |  10 +++---
 Documentation/linux_tv/media/dvb/dmx_fcalls.rst    |  40 ++++++++++-----------
 .../linux_tv/media/dvb/frontend_f_open.rst         |   2 +-
 .../linux_tv/media/dvb/intro_files/dvbstb.png      | Bin 22655 -> 22703 bytes
 .../linux_tv/media/dvb/video_function_calls.rst    |  40 ++++++++++-----------
 Documentation/linux_tv/media/v4l/app-pri.rst       |   2 +-
 Documentation/linux_tv/media/v4l/buffer.rst        |   2 +-
 Documentation/linux_tv/media/v4l/dev-overlay.rst   |   4 +--
 Documentation/linux_tv/media/v4l/dev-raw-vbi.rst   |   8 ++---
 .../linux_tv/media/v4l/dev-sliced-vbi.rst          |  10 +++---
 Documentation/linux_tv/media/v4l/dev-subdev.rst    |   4 +--
 Documentation/linux_tv/media/v4l/diff-v4l.rst      |   8 ++---
 Documentation/linux_tv/media/v4l/dmabuf.rst        |   2 +-
 .../media/v4l/field-order_files/fieldseq_tb.gif    | Bin 25323 -> 25339 bytes
 Documentation/linux_tv/media/v4l/func-open.rst     |   2 +-
 Documentation/linux_tv/media/v4l/func-read.rst     |   2 +-
 Documentation/linux_tv/media/v4l/gen-errors.rst    |  20 +++++------
 Documentation/linux_tv/media/v4l/hist-v4l2.rst     |   8 ++---
 Documentation/linux_tv/media/v4l/lirc_write.rst    |   2 +-
 .../linux_tv/media/v4l/media-ioc-enum-entities.rst |   2 +-
 .../linux_tv/media/v4l/media-ioc-setup-link.rst    |   6 ++--
 Documentation/linux_tv/media/v4l/mmap.rst          |   2 +-
 Documentation/linux_tv/media/v4l/open.rst          |   2 +-
 Documentation/linux_tv/media/v4l/querycap.rst      |   2 +-
 .../media/v4l/remote_controllers_sysfs_nodes.rst   |   4 +--
 Documentation/linux_tv/media/v4l/standard.rst      |   2 +-
 Documentation/linux_tv/media/v4l/streaming-par.rst |   2 +-
 Documentation/linux_tv/media/v4l/userp.rst         |   2 +-
 .../linux_tv/media/v4l/vidioc-create-bufs.rst      |   4 +--
 .../linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst  |   2 +-
 .../linux_tv/media/v4l/vidioc-decoder-cmd.rst      |   6 ++--
 .../linux_tv/media/v4l/vidioc-dv-timings-cap.rst   |   2 +-
 .../linux_tv/media/v4l/vidioc-encoder-cmd.rst      |   6 ++--
 .../linux_tv/media/v4l/vidioc-enum-dv-timings.rst  |   6 ++--
 .../linux_tv/media/v4l/vidioc-enum-fmt.rst         |   4 +--
 .../linux_tv/media/v4l/vidioc-enumaudio.rst        |   4 +--
 .../linux_tv/media/v4l/vidioc-enumaudioout.rst     |   4 +--
 .../linux_tv/media/v4l/vidioc-enuminput.rst        |   4 +--
 .../linux_tv/media/v4l/vidioc-enumoutput.rst       |   2 +-
 .../linux_tv/media/v4l/vidioc-enumstd.rst          |   4 +--
 .../linux_tv/media/v4l/vidioc-g-audio.rst          |   2 +-
 .../linux_tv/media/v4l/vidioc-g-audioout.rst       |   4 +--
 Documentation/linux_tv/media/v4l/vidioc-g-crop.rst |   4 +--
 Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst |   4 +--
 .../linux_tv/media/v4l/vidioc-g-dv-timings.rst     |   4 +--
 Documentation/linux_tv/media/v4l/vidioc-g-edid.rst |  12 +++----
 .../linux_tv/media/v4l/vidioc-g-ext-ctrls.rst      |  10 +++---
 Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst  |   6 ++--
 .../linux_tv/media/v4l/vidioc-g-input.rst          |   2 +-
 .../linux_tv/media/v4l/vidioc-g-modulator.rst      |   6 ++--
 .../linux_tv/media/v4l/vidioc-g-output.rst         |   2 +-
 .../linux_tv/media/v4l/vidioc-g-selection.rst      |   2 +-
 .../linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst |   2 +-
 Documentation/linux_tv/media/v4l/vidioc-g-std.rst  |   6 ++--
 .../linux_tv/media/v4l/vidioc-g-tuner.rst          |   4 +--
 Documentation/linux_tv/media/v4l/vidioc-qbuf.rst   |   2 +-
 .../linux_tv/media/v4l/vidioc-query-dv-timings.rst |   4 +--
 .../linux_tv/media/v4l/vidioc-querycap.rst         |   2 +-
 .../linux_tv/media/v4l/vidioc-queryctrl.rst        |  32 ++++++++---------
 .../linux_tv/media/v4l/vidioc-reqbufs.rst          |   2 +-
 .../linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst   |   2 +-
 .../v4l/vidioc-subdev-enum-frame-interval.rst      |   2 +-
 .../media/v4l/vidioc-subdev-enum-mbus-code.rst     |   4 +--
 .../linux_tv/media/v4l/vidioc-subdev-g-crop.rst    |   2 +-
 68 files changed, 196 insertions(+), 196 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
index 8d1caedd2f97..1951857cde65 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_EVENT.rst
@@ -11,7 +11,7 @@ DESCRIPTION
 This ioctl call returns a frontend event if available. If an event is
 not available, the behavior depends on whether the device is in blocking
 or non-blocking mode. In the latter case, the call fails immediately
-with errno set to EWOULDBLOCK. In the former case, the call blocks until
+with errno set to ``EWOULDBLOCK``. In the former case, the call blocks until
 an event becomes available.
 
 SYNOPSIS
@@ -67,13 +67,13 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EWOULDBLOCK
+       -  ``EWOULDBLOCK``
 
        -  There is no event pending, and the device is in non-blocking mode.
 
     -  .. row 2
 
-       -  EOVERFLOW
+       -  ``EOVERFLOW``
 
        -  Overflow in event queue - one or more events were lost.
 
diff --git a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
index 2e60b239d1da..5bf39ff72bd7 100644
--- a/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
+++ b/Documentation/linux_tv/media/dvb/FE_GET_FRONTEND.rst
@@ -61,7 +61,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  Maximum supported symbol rate reached.
 
diff --git a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst b/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
index f18e12cb3dff..4cb393bbc2e1 100644
--- a/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
+++ b/Documentation/linux_tv/media/dvb/FE_SET_FRONTEND.rst
@@ -68,7 +68,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  Maximum supported symbol rate reached.
 
diff --git a/Documentation/linux_tv/media/dvb/audio_function_calls.rst b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
index a68149e16116..d8abdd0e9417 100644
--- a/Documentation/linux_tv/media/dvb/audio_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/audio_function_calls.rst
@@ -85,19 +85,19 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  ENODEV
+       -  ``ENODEV``
 
        -  Device driver not loaded/available.
 
     -  .. row 2
 
-       -  EBUSY
+       -  ``EBUSY``
 
        -  Device or resource busy.
 
     -  .. row 3
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  Invalid argument.
 
@@ -143,7 +143,7 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  EBADF
+       -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
 
@@ -205,19 +205,19 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  EPERM
+       -  ``EPERM``
 
        -  Mode AUDIO_SOURCE_MEMORY not selected.
 
     -  .. row 2
 
-       -  ENOMEM
+       -  ``ENOMEM``
 
        -  Attempted to write more data than the internal buffer can hold.
 
     -  .. row 3
 
-       -  EBADF
+       -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
 
@@ -1102,7 +1102,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  type is not a valid or supported stream type.
 
@@ -1165,7 +1165,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  id is not a valid id.
 
@@ -1229,7 +1229,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  attr is not a valid or supported attribute setting.
 
@@ -1292,7 +1292,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  karaoke is not a valid or supported karaoke setting.
 
diff --git a/Documentation/linux_tv/media/dvb/ca_function_calls.rst b/Documentation/linux_tv/media/dvb/ca_function_calls.rst
index 9984b355f48f..83bce0420881 100644
--- a/Documentation/linux_tv/media/dvb/ca_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/ca_function_calls.rst
@@ -84,25 +84,25 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  ENODEV
+       -  ``ENODEV``
 
        -  Device driver not loaded/available.
 
     -  .. row 2
 
-       -  EINTERNAL
+       -  ``EINTERNAL``
 
        -  Internal error.
 
     -  .. row 3
 
-       -  EBUSY
+       -  ``EBUSY``
 
        -  Device or resource busy.
 
     -  .. row 4
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  Invalid argument.
 
@@ -148,7 +148,7 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  EBADF
+       -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
 
diff --git a/Documentation/linux_tv/media/dvb/dmx_fcalls.rst b/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
index 5982b57f0a3b..4563c8f2a1b8 100644
--- a/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
+++ b/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
@@ -83,25 +83,25 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  ENODEV
+       -  ``ENODEV``
 
        -  Device driver not loaded/available.
 
     -  .. row 2
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  Invalid argument.
 
     -  .. row 3
 
-       -  EMFILE
+       -  ``EMFILE``
 
        -  “Too many open files”, i.e. no more filters available.
 
     -  .. row 4
 
-       -  ENOMEM
+       -  ``ENOMEM``
 
        -  The driver failed to allocate enough memory.
 
@@ -148,7 +148,7 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  EBADF
+       -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
 
@@ -209,26 +209,26 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  EWOULDBLOCK
+       -  ``EWOULDBLOCK``
 
        -  No data to return and O_NONBLOCK was specified.
 
     -  .. row 2
 
-       -  EBADF
+       -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
 
     -  .. row 3
 
-       -  ECRC
+       -  ``ECRC``
 
        -  Last section had a CRC error - no data returned. The buffer is
           flushed.
 
     -  .. row 4
 
-       -  EOVERFLOW
+       -  ``EOVERFLOW``
 
        -  
 
@@ -240,14 +240,14 @@ RETURN VALUE
 
     -  .. row 6
 
-       -  ETIMEDOUT
+       -  ``ETIMEDOUT``
 
        -  The section was not loaded within the stated timeout period. See
           ioctl DMX_SET_FILTER for how to set a timeout.
 
     -  .. row 7
 
-       -  EFAULT
+       -  ``EFAULT``
 
        -  The driver failed to write to the callers buffer due to an invalid
           *buf pointer.
@@ -311,7 +311,7 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  EWOULDBLOCK
+       -  ``EWOULDBLOCK``
 
        -  No data was written. This might happen if O_NONBLOCK was
           specified and there is no more buffer space available (if
@@ -320,7 +320,7 @@ RETURN VALUE
 
     -  .. row 2
 
-       -  EBUSY
+       -  ``EBUSY``
 
        -  This error code indicates that there are conflicting requests. The
           corresponding demux device is setup to receive data from the
@@ -329,7 +329,7 @@ RETURN VALUE
 
     -  .. row 3
 
-       -  EBADF
+       -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
 
@@ -386,14 +386,14 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  Invalid argument, i.e. no filtering parameters provided via the
           DMX_SET_FILTER or DMX_SET_PES_FILTER functions.
 
     -  .. row 2
 
-       -  EBUSY
+       -  ``EBUSY``
 
        -  This error code indicates that there are conflicting requests.
           There are active filters filtering data from another input source.
@@ -564,7 +564,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EBUSY
+       -  ``EBUSY``
 
        -  This error code indicates that there are conflicting requests.
           There are active filters filtering data from another input source.
@@ -635,7 +635,7 @@ DESCRIPTION
 This ioctl call returns an event if available. If an event is not
 available, the behavior depends on whether the device is in blocking or
 non-blocking mode. In the latter case, the call fails immediately with
-errno set to EWOULDBLOCK. In the former case, the call blocks until an
+errno set to ``EWOULDBLOCK``. In the former case, the call blocks until an
 event becomes available.
 
 SYNOPSIS
@@ -686,7 +686,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EWOULDBLOCK
+       -  ``EWOULDBLOCK``
 
        -  There is no event pending, and the device is in non-blocking mode.
 
@@ -753,7 +753,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  Invalid stc number.
 
diff --git a/Documentation/linux_tv/media/dvb/frontend_f_open.rst b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
index 9ef430abcba4..bdc9a8139444 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_open.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
@@ -37,7 +37,7 @@ Arguments
     allowed.
 
     When the ``O_NONBLOCK`` flag is given, the system calls may return
-    EAGAIN error code when no data is available or when the device
+    ``EAGAIN`` error code when no data is available or when the device
     driver is temporarily busy.
 
     Other flags have no effect.
diff --git a/Documentation/linux_tv/media/dvb/intro_files/dvbstb.png b/Documentation/linux_tv/media/dvb/intro_files/dvbstb.png
index 9b8f372e7afd9d016854973ba705dcdfbd1bbf13..5836ea94eba4ec4fd13a83e89ef86b312cc04c02 100644
GIT binary patch
delta 164
zcmeyrfpPst#tjYZ><J03zJUn|o158Ja<c(BVL-N?@L^UCAluE&4aoZ{A<YcpxwyCh
zc_K31j0oOh**boZ5nzQXy2qG6MuY>Ez0rTi#0k+90_5H|`T~{;0<y1~Zea!~3r$Fv
a+-*4t#PkCS%Ue}|jdFDba%Oox<pTgz-8pao

delta 116
zcmZ3#k@5cq#tjYZ%&xwHo7>q}ax=MxZ8j4=%*x{G=H|AUQBs<j#nr{dWwVM*HzS0#
zUAB&&87RBiM)w#KlWX{94uf}0tRO`poBtbq0SX0e{%N{}naMSD@@C6POs;;Ly{#&M
NT3lT>pYnXl2LO%FCVBt>

diff --git a/Documentation/linux_tv/media/dvb/video_function_calls.rst b/Documentation/linux_tv/media/dvb/video_function_calls.rst
index 78917bdf51ed..39eaecd8755a 100644
--- a/Documentation/linux_tv/media/dvb/video_function_calls.rst
+++ b/Documentation/linux_tv/media/dvb/video_function_calls.rst
@@ -87,25 +87,25 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  ENODEV
+       -  ``ENODEV``
 
        -  Device driver not loaded/available.
 
     -  .. row 2
 
-       -  EINTERNAL
+       -  ``EINTERNAL``
 
        -  Internal error.
 
     -  .. row 3
 
-       -  EBUSY
+       -  ``EBUSY``
 
        -  Device or resource busy.
 
     -  .. row 4
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  Invalid argument.
 
@@ -151,7 +151,7 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  EBADF
+       -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
 
@@ -213,19 +213,19 @@ RETURN VALUE
 
     -  .. row 1
 
-       -  EPERM
+       -  ``EPERM``
 
        -  Mode VIDEO_SOURCE_MEMORY not selected.
 
     -  .. row 2
 
-       -  ENOMEM
+       -  ``ENOMEM``
 
        -  Attempted to write more data than the internal buffer can hold.
 
     -  .. row 3
 
-       -  EBADF
+       -  ``EBADF``
 
        -  fd is not a valid open file descriptor.
 
@@ -768,7 +768,7 @@ use the V4L2 :ref:`VIDIOC_DQEVENT` ioctl instead.
 This ioctl call returns an event of type video_event if available. If
 an event is not available, the behavior depends on whether the device is
 in blocking or non-blocking mode. In the latter case, the call fails
-immediately with errno set to EWOULDBLOCK. In the former case, the call
+immediately with errno set to ``EWOULDBLOCK``. In the former case, the call
 blocks until an event becomes available. The standard Linux poll()
 and/or select() system calls can be used with the device file descriptor
 to watch for new events. For select(), the file descriptor should be
@@ -823,13 +823,13 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EWOULDBLOCK
+       -  ``EWOULDBLOCK``
 
        -  There is no event pending, and the device is in non-blocking mode.
 
     -  .. row 2
 
-       -  EOVERFLOW
+       -  ``EOVERFLOW``
 
        -  Overflow in event queue - one or more events were lost.
 
@@ -1154,7 +1154,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EPERM
+       -  ``EPERM``
 
        -  Mode VIDEO_SOURCE_MEMORY not selected.
 
@@ -1218,7 +1218,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EPERM
+       -  ``EPERM``
 
        -  Mode VIDEO_SOURCE_MEMORY not selected.
 
@@ -1332,7 +1332,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  Invalid sub-stream id.
 
@@ -1490,7 +1490,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  format is not a valid video format.
 
@@ -1556,7 +1556,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  system is not a valid or supported video system.
 
@@ -1670,7 +1670,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  input is not a valid spu setting or driver cannot handle SPU.
 
@@ -1733,7 +1733,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  input is not a valid palette or driver doesn’t handle SPU.
 
@@ -1798,7 +1798,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EFAULT
+       -  ``EFAULT``
 
        -  driver is not able to return navigational information
 
@@ -1864,7 +1864,7 @@ appropriately. The generic error codes are described at the
 
     -  .. row 1
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  input is not a valid attribute setting.
 
diff --git a/Documentation/linux_tv/media/v4l/app-pri.rst b/Documentation/linux_tv/media/v4l/app-pri.rst
index 7ff6f44eb591..8c4624dd50e2 100644
--- a/Documentation/linux_tv/media/v4l/app-pri.rst
+++ b/Documentation/linux_tv/media/v4l/app-pri.rst
@@ -26,7 +26,7 @@ different priority will usually call :ref:`VIDIOC_S_PRIORITY
 :ref:`VIDIOC_QUERYCAP` ioctl.
 
 Ioctls changing driver properties, such as
-:ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>`, return an EBUSY error code
+:ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>`, return an ``EBUSY`` error code
 after another application obtained higher priority.
 
 
diff --git a/Documentation/linux_tv/media/v4l/buffer.rst b/Documentation/linux_tv/media/v4l/buffer.rst
index 374e9ba6b4bb..b535177724b9 100644
--- a/Documentation/linux_tv/media/v4l/buffer.rst
+++ b/Documentation/linux_tv/media/v4l/buffer.rst
@@ -651,7 +651,7 @@ buffer.
           the driver will set the ``bytesused`` field to 0, regardless of
           the format. Any Any subsequent call to the
           :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
-          but return an EPIPE error code.
+          but return an ``EPIPE`` error code.
 
     -  .. row 13
 
diff --git a/Documentation/linux_tv/media/v4l/dev-overlay.rst b/Documentation/linux_tv/media/v4l/dev-overlay.rst
index 083cf07e55c5..fc71406369a8 100644
--- a/Documentation/linux_tv/media/v4l/dev-overlay.rst
+++ b/Documentation/linux_tv/media/v4l/dev-overlay.rst
@@ -102,7 +102,7 @@ When simultaneous capturing and overlay is supported and the hardware
 prohibits different image and frame buffer formats, the format requested
 first takes precedence. The attempt to capture
 (:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`) or overlay
-(:ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`) may fail with an EBUSY error
+(:ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`) may fail with an ``EBUSY`` error
 code or return accordingly modified parameters..
 
 
@@ -142,7 +142,7 @@ of the cropping rectangle. For more information see :ref:`crop`.
 When simultaneous capturing and overlay is supported and the hardware
 prohibits different image and window sizes, the size requested first
 takes precedence. The attempt to capture or overlay as well
-(:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`) may fail with an EBUSY error
+(:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`) may fail with an ``EBUSY`` error
 code or return accordingly modified parameters.
 
 
diff --git a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
index 596b0a6b2177..20942bf9232e 100644
--- a/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-raw-vbi.rst
@@ -81,16 +81,16 @@ struct :ref:`v4l2_format <v4l2-format>` as above and initialize all
 fields of the struct :ref:`v4l2_vbi_format <v4l2-vbi-format>`
 ``vbi`` member of the ``fmt`` union, or better just modify the results
 of :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`, and call the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
-ioctl with a pointer to this structure. Drivers return an EINVAL error
+ioctl with a pointer to this structure. Drivers return an ``EINVAL`` error
 code only when the given parameters are ambiguous, otherwise they modify
 the parameters according to the hardware capabilities and return the
 actual parameters. When the driver allocates resources at this point, it
-may return an EBUSY error code to indicate the returned parameters are
+may return an ``EBUSY`` error code to indicate the returned parameters are
 valid but the required resources are currently not available. That may
 happen for instance when the video and VBI areas to capture would
 overlap, or when the driver supports multiple opens and another process
 already requested VBI capturing or output. Anyway, applications must
-expect other resource allocation points which may return EBUSY, at the
+expect other resource allocation points which may return ``EBUSY``, at the
 :ref:`VIDIOC_STREAMON` ioctl and the first read(),
 write() and select() call.
 
@@ -341,7 +341,7 @@ using buffer timestamps.
 
 Remember the :ref:`VIDIOC_STREAMON` ioctl and the
 first read(), write() and select() call can be resource allocation
-points returning an EBUSY error code if the required hardware resources
+points returning an ``EBUSY`` error code if the required hardware resources
 are temporarily unavailable, for example the device is already in use by
 another process.
 
diff --git a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
index 3692cdf8e756..b3e89f93d6ad 100644
--- a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
@@ -92,9 +92,9 @@ explicitly.
 
 The :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl modifies the parameters
 according to hardware capabilities. When the driver allocates resources
-at this point, it may return an EBUSY error code if the required
+at this point, it may return an ``EBUSY`` error code if the required
 resources are temporarily unavailable. Other resource allocation points
-which may return EBUSY can be the
+which may return ``EBUSY`` can be the
 :ref:`VIDIOC_STREAMON` ioctl and the first
 :ref:`read() <func-read>`, :ref:`write() <func-write>` and
 :ref:`select() <func-select>` call.
@@ -336,12 +336,12 @@ which may return EBUSY can be the
        -  :cspan:`2` Set of services applicable to 625 line systems.
 
 
-Drivers may return an EINVAL error code when applications attempt to
+Drivers may return an ``EINVAL`` error code when applications attempt to
 read or write data without prior format negotiation, after switching the
 video standard (which may invalidate the negotiated VBI parameters) and
 after switching the video input (which may change the video standard as
 a side effect). The :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl may
-return an EBUSY error code when applications attempt to change the
+return an ``EBUSY`` error code when applications attempt to change the
 format while i/o is in progress (between a
 :ref:`VIDIOC_STREAMON` and
 :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` call, and after the first
@@ -428,7 +428,7 @@ of one video frame. The ``id`` of unused
 
 Packets are always passed in ascending line number order, without
 duplicate line numbers. The :ref:`write() <func-write>` function and
-the :ref:`VIDIOC_QBUF` ioctl must return an EINVAL
+the :ref:`VIDIOC_QBUF` ioctl must return an ``EINVAL``
 error code when applications violate this rule. They must also return an
 EINVAL error code when applications pass an incorrect field or line
 number, or a combination of ``field``, ``line`` and ``id`` which has not
diff --git a/Documentation/linux_tv/media/v4l/dev-subdev.rst b/Documentation/linux_tv/media/v4l/dev-subdev.rst
index 67732da53be5..87a2cec37645 100644
--- a/Documentation/linux_tv/media/v4l/dev-subdev.rst
+++ b/Documentation/linux_tv/media/v4l/dev-subdev.rst
@@ -125,12 +125,12 @@ negotiate formats on a per-pad basis.
 Applications are responsible for configuring coherent parameters on the
 whole pipeline and making sure that connected pads have compatible
 formats. The pipeline is checked for formats mismatch at
-:ref:`VIDIOC_STREAMON` time, and an EPIPE error
+:ref:`VIDIOC_STREAMON` time, and an ``EPIPE`` error
 code is then returned if the configuration is invalid.
 
 Pad-level image format configuration support can be tested by calling
 the :ref:`VIDIOC_SUBDEV_G_FMT` ioctl on pad
-0. If the driver returns an EINVAL error code pad-level format
+0. If the driver returns an ``EINVAL`` error code pad-level format
 configuration is not supported by the sub-device.
 
 
diff --git a/Documentation/linux_tv/media/v4l/diff-v4l.rst b/Documentation/linux_tv/media/v4l/diff-v4l.rst
index ee9623b454a4..da4b391116b5 100644
--- a/Documentation/linux_tv/media/v4l/diff-v4l.rst
+++ b/Documentation/linux_tv/media/v4l/diff-v4l.rst
@@ -78,7 +78,7 @@ V4L prohibits (or used to prohibit) multiple opens of a device file.
 V4L2 drivers *may* support multiple opens, see :ref:`open` for details
 and consequences.
 
-V4L drivers respond to V4L2 ioctls with an EINVAL error code.
+V4L drivers respond to V4L2 ioctls with an ``EINVAL`` error code.
 
 
 Querying Capabilities
@@ -207,7 +207,7 @@ introduction.
        -  Applications can call the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>`
           ioctl to determine if the device supports capturing a subsection
           of the full picture ("cropping" in V4L2). If not, the ioctl
-          returns the EINVAL error code. For more information on cropping
+          returns the ``EINVAL`` error code. For more information on cropping
           and scaling see :ref:`crop`.
 
     -  .. row 12
@@ -791,7 +791,7 @@ differences.
 
        -  The ``VIDIOCMCAPTURE`` ioctl prepares a buffer for capturing. It
           also determines the image format for this buffer. The ioctl
-          returns immediately, eventually with an EAGAIN error code if no
+          returns immediately, eventually with an ``EAGAIN`` error code if no
           video signal had been detected. When the driver supports more than
           one buffer applications can call the ioctl multiple times and thus
           have multiple outstanding capture requests.
@@ -899,7 +899,7 @@ remaining fields are probably equivalent to struct
 Apparently only the Zoran (ZR 36120) driver implements these ioctls. The
 semantics differ from those specified for V4L2 in two ways. The
 parameters are reset on :ref:`open() <func-open>` and
-``VIDIOCSVBIFMT`` always returns an EINVAL error code if the parameters
+``VIDIOCSVBIFMT`` always returns an ``EINVAL`` error code if the parameters
 are invalid.
 
 
diff --git a/Documentation/linux_tv/media/v4l/dmabuf.rst b/Documentation/linux_tv/media/v4l/dmabuf.rst
index 773d39308fd6..6f4f0f03e91d 100644
--- a/Documentation/linux_tv/media/v4l/dmabuf.rst
+++ b/Documentation/linux_tv/media/v4l/dmabuf.rst
@@ -129,7 +129,7 @@ Two methods exist to suspend execution of the application until one or
 more buffers can be dequeued. By default ``VIDIOC_DQBUF`` blocks when no
 buffer is in the outgoing queue. When the ``O_NONBLOCK`` flag was given
 to the :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
-immediately with an EAGAIN error code when no buffer is available. The
+immediately with an ``EAGAIN`` error code when no buffer is available. The
 :ref:`select() <func-select>` and :ref:`poll() <func-poll>`
 functions are always available.
 
diff --git a/Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.gif b/Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.gif
index 718492f1cfc703e6553c3b0e2afc4b269258412b..bf1c3f1b50d5ff04b196659ca5c2629ec9deae03 100644
GIT binary patch
delta 57
zcmaETl=1gb#tlL2YzYajAqfeaL)dQ%f!KjSwxLu47l<7IWKULkZwz9G0og4P>0AJI
C85H6G

delta 41
xcmex;l=1aZ#tlL2Os*lDBiL^XF}VhAwv<ZXVsZ`GJYVI#F_UZ9<|z^BTmVl94*CE9

diff --git a/Documentation/linux_tv/media/v4l/func-open.rst b/Documentation/linux_tv/media/v4l/func-open.rst
index 06937b925be3..dcfce511e273 100644
--- a/Documentation/linux_tv/media/v4l/func-open.rst
+++ b/Documentation/linux_tv/media/v4l/func-open.rst
@@ -33,7 +33,7 @@ Arguments
     devices only writing.
 
     When the ``O_NONBLOCK`` flag is given, the read() function and the
-    :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will return the EAGAIN
+    :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will return the ``EAGAIN``
     error code when no data is available or no buffer is in the driver
     outgoing queue, otherwise these functions block until data becomes
     available. All V4L2 drivers exchanging data with applications must
diff --git a/Documentation/linux_tv/media/v4l/func-read.rst b/Documentation/linux_tv/media/v4l/func-read.rst
index 94349fa19215..4a4f3e86fd13 100644
--- a/Documentation/linux_tv/media/v4l/func-read.rst
+++ b/Documentation/linux_tv/media/v4l/func-read.rst
@@ -45,7 +45,7 @@ worth of data.
 
 By default :c:func:`read()` blocks until data becomes available. When
 the ``O_NONBLOCK`` flag was given to the :ref:`open() <func-open>`
-function it returns immediately with an EAGAIN error code when no data
+function it returns immediately with an ``EAGAIN`` error code when no data
 is available. The :ref:`select() <func-select>` or
 :ref:`poll() <func-poll>` functions can always be used to suspend
 execution until data becomes available. All drivers supporting the
diff --git a/Documentation/linux_tv/media/v4l/gen-errors.rst b/Documentation/linux_tv/media/v4l/gen-errors.rst
index 862cdff45f36..ad119579e9ea 100644
--- a/Documentation/linux_tv/media/v4l/gen-errors.rst
+++ b/Documentation/linux_tv/media/v4l/gen-errors.rst
@@ -16,7 +16,7 @@ Generic Error Codes
 
     -  .. row 1
 
-       -  EAGAIN (aka EWOULDBLOCK)
+       -  ``EAGAIN`` (aka ``EWOULDBLOCK``)
 
        -  The ioctl can't be handled because the device is in state where it
           can't perform it. This could happen for example in case where
@@ -26,13 +26,13 @@ Generic Error Codes
 
     -  .. row 2
 
-       -  EBADF
+       -  ``EBADF``
 
        -  The file descriptor is not a valid.
 
     -  .. row 3
 
-       -  EBUSY
+       -  ``EBUSY``
 
        -  The ioctl can't be handled because the device is busy. This is
           typically return while device is streaming, and an ioctl tried to
@@ -43,14 +43,14 @@ Generic Error Codes
 
     -  .. row 4
 
-       -  EFAULT
+       -  ``EFAULT``
 
        -  There was a failure while copying data from/to userspace, probably
           caused by an invalid pointer reference.
 
     -  .. row 5
 
-       -  EINVAL
+       -  ``EINVAL``
 
        -  One or more of the ioctl parameters are invalid or out of the
           allowed range. This is a widely used error code. See the
@@ -58,19 +58,19 @@ Generic Error Codes
 
     -  .. row 6
 
-       -  ENODEV
+       -  ``ENODEV``
 
        -  Device not found or was removed.
 
     -  .. row 7
 
-       -  ENOMEM
+       -  ``ENOMEM``
 
        -  There's not enough memory to handle the desired operation.
 
     -  .. row 8
 
-       -  ENOTTY
+       -  ``ENOTTY``
 
        -  The ioctl is not supported by the driver, actually meaning that
           the required functionality is not available, or the file
@@ -78,7 +78,7 @@ Generic Error Codes
 
     -  .. row 9
 
-       -  ENOSPC
+       -  ``ENOSPC``
 
        -  On USB devices, the stream ioctl's can return this error, meaning
           that this request would overcommit the usb bandwidth reserved for
@@ -86,7 +86,7 @@ Generic Error Codes
 
     -  .. row 10
 
-       -  EPERM
+       -  ``EPERM``
 
        -  Permission denied. Can be returned if the device needs write
           permission, or some special capabilities is needed (e. g. root)
diff --git a/Documentation/linux_tv/media/v4l/hist-v4l2.rst b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
index bb115a0f2427..664fbe4780af 100644
--- a/Documentation/linux_tv/media/v4l/hist-v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
@@ -280,14 +280,14 @@ A number of changes were made to the raw VBI interface.
    transmitted only on the first field. The comment that both ``count``
    values will usually be equal is misleading and pointless and has been
    removed. This change *breaks compatibility* with earlier versions:
-   Drivers may return EINVAL, applications may not function correctly.
+   Drivers may return ``EINVAL``, applications may not function correctly.
 
 3. Drivers are again permitted to return negative (unknown) start values
    as proposed earlier. Why this feature was dropped is unclear. This
    change may *break compatibility* with applications depending on the
    start values being positive. The use of ``EBUSY`` and ``EINVAL``
    error codes with the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl was
-   clarified. The EBUSY error code was finally documented, and the
+   clarified. The ``EBUSY`` error code was finally documented, and the
    ``reserved2`` field which was previously mentioned only in the
    ``videodev.h`` header file.
 
@@ -324,7 +324,7 @@ This unnamed version was finally merged into Linux 2.5.46.
 3.  The struct :ref:`v4l2_capability <v4l2-capability>` changed
     dramatically. Note that also the size of the structure changed,
     which is encoded in the ioctl request code, thus older V4L2 devices
-    will respond with an EINVAL error code to the new
+    will respond with an ``EINVAL`` error code to the new
     :ref:`VIDIOC_QUERYCAP` ioctl.
 
     There are new fields to identify the driver, a new RDS device
@@ -855,7 +855,7 @@ V4L2 spec erratum 2004-08-01
 4. The documentation of the :ref:`VIDIOC_QBUF` and
    :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctls did not mention the
    struct :ref:`v4l2_buffer <v4l2-buffer>` ``memory`` field. It was
-   also missing from examples. Also on the ``VIDIOC_DQBUF`` page the EIO
+   also missing from examples. Also on the ``VIDIOC_DQBUF`` page the ``EIO``
    error code was not documented.
 
 
diff --git a/Documentation/linux_tv/media/v4l/lirc_write.rst b/Documentation/linux_tv/media/v4l/lirc_write.rst
index 167d8b5198d8..234c8f43613e 100644
--- a/Documentation/linux_tv/media/v4l/lirc_write.rst
+++ b/Documentation/linux_tv/media/v4l/lirc_write.rst
@@ -11,7 +11,7 @@ values. Pulses and spaces are only marked implicitly by their position.
 The data must start and end with a pulse, therefore, the data must
 always include an uneven number of samples. The write function must
 block until the data has been transmitted by the hardware. If more data
-is provided than the hardware can send, the driver returns EINVAL.
+is provided than the hardware can send, the driver returns ``EINVAL``.
 
 
 .. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst b/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
index 2549857e681e..6d2deba8dea8 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
@@ -40,7 +40,7 @@ EINVAL error code when the id is invalid.
 Entities can be enumerated by or'ing the id with the
 ``MEDIA_ENT_ID_FLAG_NEXT`` flag. The driver will return information
 about the entity with the smallest id strictly larger than the requested
-one ('next entity'), or the EINVAL error code if there is none.
+one ('next entity'), or the ``EINVAL`` error code if there is none.
 
 Entity IDs can be non-contiguous. Applications must *not* try to
 enumerate entities by calling MEDIA_IOC_ENUM_ENTITIES with increasing
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst b/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
index aa6495fe3608..5b9c44e4ee77 100644
--- a/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
+++ b/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
@@ -43,13 +43,13 @@ not be enabled or disabled.
 
 Link configuration has no side effect on other links. If an enabled link
 at the sink pad prevents the link from being enabled, the driver returns
-with an EBUSY error code.
+with an ``EBUSY`` error code.
 
 Only links marked with the ``DYNAMIC`` link flag can be enabled/disabled
 while streaming media data. Attempting to enable or disable a streaming
-non-dynamic link will return an EBUSY error code.
+non-dynamic link will return an ``EBUSY`` error code.
 
-If the specified link can't be found the driver returns with an EINVAL
+If the specified link can't be found the driver returns with an ``EINVAL``
 error code.
 
 
diff --git a/Documentation/linux_tv/media/v4l/mmap.rst b/Documentation/linux_tv/media/v4l/mmap.rst
index 2013e882f0d4..5f7450ff16c2 100644
--- a/Documentation/linux_tv/media/v4l/mmap.rst
+++ b/Documentation/linux_tv/media/v4l/mmap.rst
@@ -235,7 +235,7 @@ suspend execution of the application until one or more buffers can be
 dequeued. By default ``VIDIOC_DQBUF`` blocks when no buffer is in the
 outgoing queue. When the ``O_NONBLOCK`` flag was given to the
 :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
-immediately with an EAGAIN error code when no buffer is available. The
+immediately with an ``EAGAIN`` error code when no buffer is available. The
 :ref:`select() <func-select>` or :ref:`poll() <func-poll>` functions
 are always available.
 
diff --git a/Documentation/linux_tv/media/v4l/open.rst b/Documentation/linux_tv/media/v4l/open.rst
index ec6b456e37f0..963d2923aaa3 100644
--- a/Documentation/linux_tv/media/v4l/open.rst
+++ b/Documentation/linux_tv/media/v4l/open.rst
@@ -146,7 +146,7 @@ sections.
 .. [1]
    There are still some old and obscure drivers that have not been
    updated to allow for multiple opens. This implies that for such
-   drivers :ref:`open() <func-open>` can return an EBUSY error code
+   drivers :ref:`open() <func-open>` can return an ``EBUSY`` error code
    when the device is already in use.
 
 .. [2]
diff --git a/Documentation/linux_tv/media/v4l/querycap.rst b/Documentation/linux_tv/media/v4l/querycap.rst
index bb905eb82c08..f3fa6cb6befe 100644
--- a/Documentation/linux_tv/media/v4l/querycap.rst
+++ b/Documentation/linux_tv/media/v4l/querycap.rst
@@ -20,7 +20,7 @@ Starting with kernel version 3.1, :ref:`VIDIOC_QUERYCAP`
 will return the V4L2 API version used by the driver, with generally
 matches the Kernel version. There's no need of using
 :ref:`VIDIOC_QUERYCAP` to check if a specific ioctl
-is supported, the V4L2 core now returns ENOTTY if a driver doesn't
+is supported, the V4L2 core now returns ``ENOTTY`` if a driver doesn't
 provide support for an ioctl.
 
 Other features can be queried by calling the respective ioctl, for
diff --git a/Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst b/Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst
index e2fb81144a4d..03d2d422d4c0 100644
--- a/Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst
+++ b/Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst
@@ -49,7 +49,7 @@ Writing "proto" will enable only "proto".
 
 Writing "none" will disable all protocols.
 
-Write fails with EINVAL if an invalid protocol combination or unknown
+Write fails with ``EINVAL`` if an invalid protocol combination or unknown
 protocol name is used.
 
 
@@ -106,7 +106,7 @@ Writing "proto" will use "proto" for wakeup events.
 
 Writing "none" will disable wakeup.
 
-Write fails with EINVAL if an invalid protocol combination or unknown
+Write fails with ``EINVAL`` if an invalid protocol combination or unknown
 protocol name is used, or if wakeup is not supported by the hardware.
 
 
diff --git a/Documentation/linux_tv/media/v4l/standard.rst b/Documentation/linux_tv/media/v4l/standard.rst
index 4131ca880268..67e295daa054 100644
--- a/Documentation/linux_tv/media/v4l/standard.rst
+++ b/Documentation/linux_tv/media/v4l/standard.rst
@@ -58,7 +58,7 @@ Here the driver shall set the ``std`` field of struct
 :ref:`v4l2_input <v4l2-input>` and struct
 :ref:`v4l2_output <v4l2-output>` to zero and the :ref:`VIDIOC_G_STD <VIDIOC_G_STD>`,
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>`, :ref:`VIDIOC_QUERYSTD` and :ref:`VIDIOC_ENUMSTD` ioctls
-shall return the ENOTTY error code or the EINVAL error code.
+shall return the ``ENOTTY`` error code or the ``EINVAL`` error code.
 
 Applications can make use of the :ref:`input-capabilities` and
 :ref:`output-capabilities` flags to determine whether the video
diff --git a/Documentation/linux_tv/media/v4l/streaming-par.rst b/Documentation/linux_tv/media/v4l/streaming-par.rst
index bb8100b6ef87..643bad8cfc1a 100644
--- a/Documentation/linux_tv/media/v4l/streaming-par.rst
+++ b/Documentation/linux_tv/media/v4l/streaming-par.rst
@@ -30,7 +30,7 @@ contains a union holding separate parameters for input and output
 devices.
 
 These ioctls are optional, drivers need not implement them. If so, they
-return the EINVAL error code.
+return the ``EINVAL`` error code.
 
 
 .. ------------------------------------------------------------------------------
diff --git a/Documentation/linux_tv/media/v4l/userp.rst b/Documentation/linux_tv/media/v4l/userp.rst
index a5426d10ceb8..23ef4b71444d 100644
--- a/Documentation/linux_tv/media/v4l/userp.rst
+++ b/Documentation/linux_tv/media/v4l/userp.rst
@@ -77,7 +77,7 @@ Two methods exist to suspend execution of the application until one or
 more buffers can be dequeued. By default ``VIDIOC_DQBUF`` blocks when no
 buffer is in the outgoing queue. When the ``O_NONBLOCK`` flag was given
 to the :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
-immediately with an EAGAIN error code when no buffer is available. The
+immediately with an ``EAGAIN`` error code when no buffer is available. The
 :ref:`select() <func-select>` or :ref:`poll() <func-poll>` function
 are always available.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
index fc9542e4204c..9d872e3b9c22 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-create-bufs.rst
@@ -97,8 +97,8 @@ than the number requested.
           :ref:`VIDIOC_CREATE_BUFS` will set ``index`` to the current number of
           created buffers, and it will check the validity of ``memory`` and
           ``format.type``. If those are invalid -1 is returned and errno is
-          set to EINVAL error code, otherwise :ref:`VIDIOC_CREATE_BUFS` returns
-          0. It will never set errno to EBUSY error code in this particular
+          set to ``EINVAL`` error code, otherwise :ref:`VIDIOC_CREATE_BUFS` returns
+          0. It will never set errno to ``EBUSY`` error code in this particular
           case.
 
     -  .. row 3
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
index 4baf472b658b..7fc1e6b3e892 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dbg-g-chip-info.rst
@@ -56,7 +56,7 @@ and ``flags`` fields.
 When ``match.type`` is ``V4L2_CHIP_MATCH_BRIDGE``, ``match.addr``
 selects the nth bridge 'chip' on the TV card. You can enumerate all
 chips by starting at zero and incrementing ``match.addr`` by one until
-:ref:`VIDIOC_DBG_G_CHIP_INFO` fails with an EINVAL error code. The number
+:ref:`VIDIOC_DBG_G_CHIP_INFO` fails with an ``EINVAL`` error code. The number
 zero always selects the bridge chip itself, e. g. the chip connected to
 the PCI or USB bus. Non-zero numbers identify specific parts of the
 bridge chip such as an AC97 register block.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
index d3b3c8a2ad08..3fd1da8c1132 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
@@ -225,7 +225,7 @@ introduced in Linux 3.3.
           indicated by the driver setting the ``bytesused`` field to 0. Once
           the ``V4L2_BUF_FLAG_LAST`` flag was set, the
           :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
-          but return an EPIPE error code. If
+          but return an ``EPIPE`` error code. If
           ``V4L2_DEC_CMD_STOP_IMMEDIATELY`` is set, then the decoder stops
           immediately (ignoring the ``pts`` value), otherwise it will keep
           decoding until timestamp >= pts or until the last of the pending
@@ -238,7 +238,7 @@ introduced in Linux 3.3.
        -  2
 
        -  Pause the decoder. When the decoder has not been started yet, the
-          driver will return an EPERM error code. When the decoder is
+          driver will return an ``EPERM`` error code. When the decoder is
           already paused, this command does nothing. This command has one
           flag: if ``V4L2_DEC_CMD_PAUSE_TO_BLACK`` is set, then set the
           decoder output to black when paused.
@@ -250,7 +250,7 @@ introduced in Linux 3.3.
        -  3
 
        -  Resume decoding after a PAUSE command. When the decoder has not
-          been started yet, the driver will return an EPERM error code. When
+          been started yet, the driver will return an ``EPERM`` error code. When
           the decoder is already running, this command does nothing. No
           flags are defined for this command.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
index 50133087af5b..dbfc5e92faf3 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
@@ -46,7 +46,7 @@ receivers) or outputs (for DV transmitters), applications must specify
 the desired pad number in the struct
 :ref:`v4l2_dv_timings_cap <v4l2-dv-timings-cap>` ``pad`` field and
 zero the ``reserved`` array. Attempts to query capabilities on a pad
-that doesn't support them will return an EINVAL error code.
+that doesn't support them will return an ``EINVAL`` error code.
 
 
 .. _v4l2-bt-timings-cap:
diff --git a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
index 7d029498d700..b62b508c83a7 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
@@ -135,7 +135,7 @@ introduced in Linux 2.6.21.
           driver setting the ``bytesused`` field to 0. Once the
           ``V4L2_BUF_FLAG_LAST`` flag was set, the
           :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
-          but return an EPIPE error code.
+          but return an ``EPIPE`` error code.
 
     -  .. row 3
 
@@ -144,7 +144,7 @@ introduced in Linux 2.6.21.
        -  2
 
        -  Pause the encoder. When the encoder has not been started yet, the
-          driver will return an EPERM error code. When the encoder is
+          driver will return an ``EPERM`` error code. When the encoder is
           already paused, this command does nothing. No flags are defined
           for this command.
 
@@ -155,7 +155,7 @@ introduced in Linux 2.6.21.
        -  3
 
        -  Resume encoding after a PAUSE command. When the encoder has not
-          been started yet, the driver will return an EPERM error code. When
+          been started yet, the driver will return an ``EPERM`` error code. When
           the encoder is already running, this command does nothing. No
           flags are defined for this command.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
index 4639d9a9f0a6..a3deae4844f5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-dv-timings.rst
@@ -43,10 +43,10 @@ To query the available timings, applications initialize the ``index``
 field, set the ``pad`` field to 0, zero the reserved array of struct
 :ref:`v4l2_enum_dv_timings <v4l2-enum-dv-timings>` and call the
 ``VIDIOC_ENUM_DV_TIMINGS`` ioctl on a video node with a pointer to this
-structure. Drivers fill the rest of the structure or return an EINVAL
+structure. Drivers fill the rest of the structure or return an ``EINVAL``
 error code when the index is out of bounds. To enumerate all supported
 DV timings, applications shall begin at index zero, incrementing by one
-until the driver returns EINVAL. Note that drivers may enumerate a
+until the driver returns ``EINVAL``. Note that drivers may enumerate a
 different set of DV timings after switching the video input or output.
 
 When implemented by the driver DV timings of subdevices can be queried
@@ -56,7 +56,7 @@ or outputs (for DV transmitters), applications must specify the desired
 pad number in the struct
 :ref:`v4l2_enum_dv_timings <v4l2-enum-dv-timings>` ``pad`` field.
 Attempts to enumerate timings on a pad that doesn't support them will
-return an EINVAL error code.
+return an ``EINVAL`` error code.
 
 
 .. _v4l2-enum-dv-timings:
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
index a20ed3ae3417..a8b162ed85a0 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enum-fmt.rst
@@ -34,9 +34,9 @@ Description
 To enumerate image formats applications initialize the ``type`` and
 ``index`` field of struct :ref:`v4l2_fmtdesc <v4l2-fmtdesc>` and call
 the :ref:`VIDIOC_ENUM_FMT` ioctl with a pointer to this structure. Drivers
-fill the rest of the structure or return an EINVAL error code. All
+fill the rest of the structure or return an ``EINVAL`` error code. All
 formats are enumerable by beginning at index zero and incrementing by
-one until EINVAL is returned.
+one until ``EINVAL`` is returned.
 
 Note that after switching input or output the list of enumerated image
 formats may be different.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
index 32ef1fcb013d..51d783734107 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudio.rst
@@ -35,9 +35,9 @@ To query the attributes of an audio input applications initialize the
 ``index`` field and zero out the ``reserved`` array of a struct
 :ref:`v4l2_audio <v4l2-audio>` and call the :ref:`VIDIOC_ENUMAUDIO`
 ioctl with a pointer to this structure. Drivers fill the rest of the
-structure or return an EINVAL error code when the index is out of
+structure or return an ``EINVAL`` error code when the index is out of
 bounds. To enumerate all audio inputs applications shall begin at index
-zero, incrementing by one until the driver returns EINVAL.
+zero, incrementing by one until the driver returns ``EINVAL``.
 
 See :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` for a description of struct
 :ref:`v4l2_audio <v4l2-audio>`.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
index 8412f1c0e4cf..660bcee62fcf 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
@@ -35,9 +35,9 @@ To query the attributes of an audio output applications initialize the
 ``index`` field and zero out the ``reserved`` array of a struct
 :ref:`v4l2_audioout <v4l2-audioout>` and call the ``VIDIOC_G_AUDOUT``
 ioctl with a pointer to this structure. Drivers fill the rest of the
-structure or return an EINVAL error code when the index is out of
+structure or return an ``EINVAL`` error code when the index is out of
 bounds. To enumerate all audio outputs applications shall begin at index
-zero, incrementing by one until the driver returns EINVAL.
+zero, incrementing by one until the driver returns ``EINVAL``.
 
 Note connectors on a TV card to loop back the received audio signal to a
 sound card are not audio outputs in this sense.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
index 3b0577a307e9..7344777e3514 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enuminput.rst
@@ -34,9 +34,9 @@ Description
 To query the attributes of a video input applications initialize the
 ``index`` field of struct :ref:`v4l2_input <v4l2-input>` and call the
 :ref:`VIDIOC_ENUMINPUT` ioctl with a pointer to this structure. Drivers
-fill the rest of the structure or return an EINVAL error code when the
+fill the rest of the structure or return an ``EINVAL`` error code when the
 index is out of bounds. To enumerate all inputs applications shall begin
-at index zero, incrementing by one until the driver returns EINVAL.
+at index zero, incrementing by one until the driver returns ``EINVAL``.
 
 
 .. _v4l2-input:
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
index 1ad68a88e594..de0952353ad0 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumoutput.rst
@@ -34,7 +34,7 @@ Description
 To query the attributes of a video outputs applications initialize the
 ``index`` field of struct :ref:`v4l2_output <v4l2-output>` and call
 the :ref:`VIDIOC_ENUMOUTPUT` ioctl with a pointer to this structure.
-Drivers fill the rest of the structure or return an EINVAL error code
+Drivers fill the rest of the structure or return an ``EINVAL`` error code
 when the index is out of bounds. To enumerate all outputs applications
 shall begin at index zero, incrementing by one until the driver returns
 EINVAL.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
index 6421b37b5ace..f4866719e099 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumstd.rst
@@ -35,9 +35,9 @@ To query the attributes of a video standard, especially a custom (driver
 defined) one, applications initialize the ``index`` field of struct
 :ref:`v4l2_standard <v4l2-standard>` and call the :ref:`VIDIOC_ENUMSTD`
 ioctl with a pointer to this structure. Drivers fill the rest of the
-structure or return an EINVAL error code when the index is out of
+structure or return an ``EINVAL`` error code when the index is out of
 bounds. To enumerate all standards applications shall begin at index
-zero, incrementing by one until the driver returns EINVAL. Drivers may
+zero, incrementing by one until the driver returns ``EINVAL``. Drivers may
 enumerate a different set of standards after switching the video input
 or output. [1]_
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
index 66d74f3964f3..8430b49b770a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audio.rst
@@ -37,7 +37,7 @@ Description
 To query the current audio input applications zero out the ``reserved``
 array of a struct :ref:`v4l2_audio <v4l2-audio>` and call the
 :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` ioctl with a pointer to this structure. Drivers fill
-the rest of the structure or return an EINVAL error code when the device
+the rest of the structure or return an ``EINVAL`` error code when the device
 has no audio inputs, or none which combine with the current video input.
 
 Audio inputs have one writable property, the audio mode. To select the
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
index 990f86a20bd2..e2ca42cbe9ae 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
@@ -37,7 +37,7 @@ Description
 To query the current audio output applications zero out the ``reserved``
 array of a struct :ref:`v4l2_audioout <v4l2-audioout>` and call the
 ``VIDIOC_G_AUDOUT`` ioctl with a pointer to this structure. Drivers fill
-the rest of the structure or return an EINVAL error code when the device
+the rest of the structure or return an ``EINVAL`` error code when the device
 has no audio inputs, or none which combine with the current video
 output.
 
@@ -46,7 +46,7 @@ current audio output applications can initialize the ``index`` field and
 ``reserved`` array (which in the future may contain writable properties)
 of a :c:type:`struct v4l2_audioout` structure and call the
 ``VIDIOC_S_AUDOUT`` ioctl. Drivers switch to the requested output or
-return the EINVAL error code when the index is out of bounds. This is a
+return the ``EINVAL`` error code when the index is out of bounds. This is a
 write-only ioctl, it does not return the current audio output attributes
 as ``VIDIOC_G_AUDOUT`` does.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
index e2ffef351edf..888ddb045340 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-crop.rst
@@ -38,7 +38,7 @@ To query the cropping rectangle size and position applications set the
 ``type`` field of a :c:type:`struct v4l2_crop` structure to the
 respective buffer (stream) type and call the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` ioctl
 with a pointer to this structure. The driver fills the rest of the
-structure or returns the EINVAL error code if cropping is not supported.
+structure or returns the ``EINVAL`` error code if cropping is not supported.
 
 To change the cropping rectangle applications initialize the ``type``
 and struct :ref:`v4l2_rect <v4l2-rect>` substructure named ``c`` of a
@@ -72,7 +72,7 @@ image parameters and repeat the cycle until satisfactory parameters have
 been negotiated.
 
 When cropping is not supported then no parameters are changed and
-:ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` returns the EINVAL error code.
+:ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` returns the ``EINVAL`` error code.
 
 
 .. _v4l2-crop:
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
index 333eb4fa5099..07e27e474326 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ctrl.rst
@@ -39,9 +39,9 @@ value of a control applications initialize the ``id`` and ``value``
 fields of a struct :c:type:`struct v4l2_control` and call the
 :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` ioctl.
 
-When the ``id`` is invalid drivers return an EINVAL error code. When the
+When the ``id`` is invalid drivers return an ``EINVAL`` error code. When the
 ``value`` is out of bounds drivers can choose to take the closest valid
-value or return an ERANGE error code, whatever seems more appropriate.
+value or return an ``ERANGE`` error code, whatever seems more appropriate.
 However, :ref:`VIDIOC_S_CTRL <VIDIOC_G_CTRL>` is a write-only ioctl, it does not return the
 actual new value. If the ``value`` is inappropriate for the control
 (e.g. if it refers to an unsupported menu index of a menu control), then
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
index c9de292ca1d2..2b2e154a2d1f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
@@ -42,13 +42,13 @@ information is filled in using the structure struct
 :ref:`v4l2_dv_timings <v4l2-dv-timings>`. These ioctls take a
 pointer to the struct :ref:`v4l2_dv_timings <v4l2-dv-timings>`
 structure as argument. If the ioctl is not supported or the timing
-values are not correct, the driver returns EINVAL error code.
+values are not correct, the driver returns ``EINVAL`` error code.
 
 The ``linux/v4l2-dv-timings.h`` header can be used to get the timings of
 the formats in the :ref:`cea861` and :ref:`vesadmt` standards. If
 the current input or output does not support DV timings (e.g. if
 :ref:`VIDIOC_ENUMINPUT` does not set the
-``V4L2_IN_CAP_DV_TIMINGS`` flag), then ENODATA error code is returned.
+``V4L2_IN_CAP_DV_TIMINGS`` flag), then ``ENODATA`` error code is returned.
 
 
 Return Value
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
index 54f364bdde8e..b7d56ba0032a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-edid.rst
@@ -48,7 +48,7 @@ returned by :ref:`VIDIOC_ENUMINPUT` and
 :ref:`VIDIOC_ENUMOUTPUT` respectively. When used
 with subdevice nodes the ``pad`` field represents the input or output
 pad of the subdevice. If there is no EDID support for the given ``pad``
-value, then the EINVAL error code will be returned.
+value, then the ``EINVAL`` error code will be returned.
 
 To get the EDID data the application has to fill in the ``pad``,
 ``start_block``, ``blocks`` and ``edid`` fields, zero the ``reserved``
@@ -59,7 +59,7 @@ array and call :ref:`VIDIOC_G_EDID <VIDIOC_G_EDID>`. The current EDID from block
 
 If there are fewer blocks than specified, then the driver will set
 ``blocks`` to the actual number of blocks. If there are no EDID blocks
-available at all, then the error code ENODATA is set.
+available at all, then the error code ``ENODATA`` is set.
 
 If blocks have to be retrieved from the sink, then this call will block
 until they have been read.
@@ -79,9 +79,9 @@ receivers as it makes no sense for a transmitter.
 
 The driver assumes that the full EDID is passed in. If there are more
 EDID blocks than the hardware can handle then the EDID is not written,
-but instead the error code E2BIG is set and ``blocks`` is set to the
+but instead the error code ``E2BIG`` is set and ``blocks`` is set to the
 maximum that the hardware supports. If ``start_block`` is any value
-other than 0 then the error code EINVAL is set.
+other than 0 then the error code ``EINVAL`` is set.
 
 To disable an EDID you set ``blocks`` to 0. Depending on the hardware
 this will drive the hotplug pin low and/or block the source from reading
@@ -155,10 +155,10 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
-ENODATA
+``ENODATA``
     The EDID data is not available.
 
-E2BIG
+``E2BIG``
     The EDID data you provided is more than the hardware can handle.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
index 91a0b8227423..d12021c6fbb8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-ext-ctrls.rst
@@ -54,7 +54,7 @@ the ``id``, ``size`` and ``reserved2`` fields of each struct
 
 If the ``size`` is too small to receive the control result (only
 relevant for pointer-type controls like strings), then the driver will
-set ``size`` to a valid value and return an ENOSPC error code. You
+set ``size`` to a valid value and return an ``ENOSPC`` error code. You
 should re-allocate the memory to this new size and try again. For the
 string type it is possible that the same issue occurs again if the
 string has grown in the meantime. It is recommended to call
@@ -81,13 +81,13 @@ initialize the ``id``, ``size``, ``reserved2`` and
 values are automatically adjusted to a valid value or if an error is
 returned.
 
-When the ``id`` or ``which`` is invalid drivers return an EINVAL error
+When the ``id`` or ``which`` is invalid drivers return an ``EINVAL`` error
 code. When the value is out of bounds drivers can choose to take the
-closest valid value or return an ERANGE error code, whatever seems more
+closest valid value or return an ``ERANGE`` error code, whatever seems more
 appropriate. In the first case the new value is set in struct
 :ref:`v4l2_ext_control <v4l2-ext-control>`. If the new control value
 is inappropriate (e.g. the given menu index is not supported by the menu
-control), then this will also result in an EINVAL error code error.
+control), then this will also result in an ``EINVAL`` error code error.
 
 The driver will only set/get these controls if all control values are
 correct. This prevents the situation where only some of the controls
@@ -124,7 +124,7 @@ still cause this situation.
           size of the memory containing the payload, or that will receive
           the payload. If :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` finds that this value is
           less than is required to store the payload result, then it is set
-          to a value large enough to store the payload result and ENOSPC is
+          to a value large enough to store the payload result and ``ENOSPC`` is
           returned. Note that for string controls this ``size`` field should
           not be confused with the length of the string. This field refers
           to the size of the memory that contains the string. The actual
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
index 173e4aca7ee1..24fac4536196 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-fmt.rst
@@ -47,7 +47,7 @@ devices that is either the struct
 :ref:`v4l2_pix_format <v4l2-pix-format>` ``pix`` or the struct
 :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>` ``pix_mp``
 member. When the requested buffer type is not supported drivers return
-an EINVAL error code.
+an ``EINVAL`` error code.
 
 To change the current format parameters applications initialize the
 ``type`` field and all fields of the respective ``fmt`` union member.
@@ -69,11 +69,11 @@ application must implement the :ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>` and :ref:`VIDI
 ioctl. When the requested buffer type is not supported drivers return an
 EINVAL error code on a :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` attempt. When I/O is already in
 progress or the resource is not available for other reasons drivers
-return the EBUSY error code.
+return the ``EBUSY`` error code.
 
 The :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` ioctl is equivalent to :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` with one
 exception: it does not change driver state. It can also be called at any
-time, never returning EBUSY. This function is provided to negotiate
+time, never returning ``EBUSY``. This function is provided to negotiate
 parameters, to learn about hardware limitations, without disabling I/O
 or possibly time consuming hardware preparations. Although strongly
 recommended drivers are not required to implement this ioctl.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
index 6b1fc39c602f..1c14f7dcffeb 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-input.rst
@@ -36,7 +36,7 @@ To query the current video input applications call the
 :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` ioctl with a pointer to an integer where the driver
 stores the number of the input, as in the struct
 :ref:`v4l2_input <v4l2-input>` ``index`` field. This ioctl will fail
-only when there are no video inputs, returning EINVAL.
+only when there are no video inputs, returning ``EINVAL``.
 
 To select a video input applications store the number of the desired
 input in an integer and call the :ref:`VIDIOC_S_INPUT <VIDIOC_G_INPUT>` ioctl with a pointer
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
index b41ec0fe6acc..2342e036850b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-modulator.rst
@@ -38,7 +38,7 @@ To query the attributes of a modulator applications initialize the
 ``index`` field and zero out the ``reserved`` array of a struct
 :ref:`v4l2_modulator <v4l2-modulator>` and call the
 :ref:`VIDIOC_G_MODULATOR <VIDIOC_G_MODULATOR>` ioctl with a pointer to this structure. Drivers
-fill the rest of the structure or return an EINVAL error code when the
+fill the rest of the structure or return an ``EINVAL`` error code when the
 index is out of bounds. To enumerate all modulators applications shall
 begin at index zero, incrementing by one until the driver returns
 EINVAL.
@@ -199,7 +199,7 @@ To change the radio frequency the
           ``V4L2_TUNER_SUB_SAP``. If the hardware does not support the
           respective audio matrix, or the current video standard does not
           permit bilingual audio the :ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` ioctl shall
-          return an EINVAL error code and the driver shall fall back to mono
+          return an ``EINVAL`` error code and the driver shall fall back to mono
           or stereo mode.
 
     -  .. row 4
@@ -230,7 +230,7 @@ To change the radio frequency the
           ``V4L2_TUNER_SUB_MONO`` or ``V4L2_TUNER_SUB_STEREO``. If the
           hardware does not support the respective audio matrix, or the
           current video standard does not permit SAP the
-          :ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` ioctl shall return an EINVAL error code and
+          :ref:`VIDIOC_S_MODULATOR <VIDIOC_G_MODULATOR>` ioctl shall return an ``EINVAL`` error code and
           driver shall fall back to mono or stereo mode.
 
     -  .. row 6
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
index 95d7a9b19166..03defa561e5b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-output.rst
@@ -36,7 +36,7 @@ To query the current video output applications call the
 :ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` ioctl with a pointer to an integer where the driver
 stores the number of the output, as in the struct
 :ref:`v4l2_output <v4l2-output>` ``index`` field. This ioctl will
-fail only when there are no video outputs, returning the EINVAL error
+fail only when there are no video outputs, returning the ``EINVAL`` error
 code.
 
 To select a video output applications store the number of the desired
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
index 271610e06b2b..1159b012a0a1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-selection.rst
@@ -113,7 +113,7 @@ On success the struct :ref:`v4l2_rect <v4l2-rect>` ``r`` field
 contains the adjusted rectangle. When the parameters are unsuitable the
 application may modify the cropping (composing) or image parameters and
 repeat the cycle until satisfactory parameters have been negotiated. If
-constraints flags have to be violated at then ERANGE is returned. The
+constraints flags have to be violated at then ``ERANGE`` is returned. The
 error indicates that *there exist no rectangle* that satisfies the
 constraints.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
index 00a9b61002de..ac08f606fdd8 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -35,7 +35,7 @@ To find out which data services are supported by a sliced VBI capture or
 output device, applications initialize the ``type`` field of a struct
 :ref:`v4l2_sliced_vbi_cap <v4l2-sliced-vbi-cap>`, clear the
 ``reserved`` array and call the :ref:`VIDIOC_G_SLICED_VBI_CAP <VIDIOC_G_SLICED_VBI_CAP>` ioctl. The
-driver fills in the remaining fields or returns an EINVAL error code if
+driver fills in the remaining fields or returns an ``EINVAL`` error code if
 the sliced VBI API is unsupported or ``type`` is invalid.
 
 Note the ``type`` field was added, and the ioctl changed from read-only
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
index 5644cc670381..67b4d7da6473 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-std.rst
@@ -45,11 +45,11 @@ unambiguous such that they appear in only one enumerated
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` accepts one or more flags, being a write-only ioctl it
 does not return the actual new standard as :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` does. When
 no flags are given or the current input does not support the requested
-standard the driver returns an EINVAL error code. When the standard set
-is ambiguous drivers may return EINVAL or choose any of the requested
+standard the driver returns an ``EINVAL`` error code. When the standard set
+is ambiguous drivers may return ``EINVAL`` or choose any of the requested
 standards. If the current input or output does not support standard
 video timings (e.g. if :ref:`VIDIOC_ENUMINPUT`
-does not set the ``V4L2_IN_CAP_STD`` flag), then ENODATA error code is
+does not set the ``V4L2_IN_CAP_STD`` flag), then ``ENODATA`` error code is
 returned.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
index 8e119fa28ccd..078fe6db751e 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-tuner.rst
@@ -38,9 +38,9 @@ To query the attributes of a tuner applications initialize the ``index``
 field and zero out the ``reserved`` array of a struct
 :ref:`v4l2_tuner <v4l2-tuner>` and call the ``VIDIOC_G_TUNER`` ioctl
 with a pointer to this structure. Drivers fill the rest of the structure
-or return an EINVAL error code when the index is out of bounds. To
+or return an ``EINVAL`` error code when the index is out of bounds. To
 enumerate all tuners applications shall begin at index zero,
-incrementing by one until the driver returns EINVAL.
+incrementing by one until the driver returns ``EINVAL``.
 
 Tuners have two writable properties, the audio mode and the radio
 frequency. To change the audio mode, applications initialize the
diff --git a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
index 380970ba9a12..ab567559a0ac 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-qbuf.rst
@@ -110,7 +110,7 @@ array must be passed in as well.
 By default ``VIDIOC_DQBUF`` blocks when no buffer is in the outgoing
 queue. When the ``O_NONBLOCK`` flag was given to the
 :ref:`open() <func-open>` function, ``VIDIOC_DQBUF`` returns
-immediately with an EAGAIN error code when no buffer is available.
+immediately with an ``EAGAIN`` error code when no buffer is available.
 
 The :c:type:`struct v4l2_buffer` structure is specified in
 :ref:`buffer`.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
index 9f067f587e42..0c01ed49065f 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-query-dv-timings.rst
@@ -51,11 +51,11 @@ and start streaming again.
 
 If the timings could not be detected because there was no signal, then
 ENOLINK is returned. If a signal was detected, but it was unstable and
-the receiver could not lock to the signal, then ENOLCK is returned. If
+the receiver could not lock to the signal, then ``ENOLCK`` is returned. If
 the receiver could lock to the signal, but the format is unsupported
 (e.g. because the pixelclock is out of range of the hardware
 capabilities), then the driver fills in whatever timings it could find
-and returns ERANGE. In that case the application can call
+and returns ``ERANGE``. In that case the application can call
 :ref:`VIDIOC_DV_TIMINGS_CAP` to compare the
 found timings with the hardware's capabilities in order to give more
 precise feedback to the user.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
index 91551fe448fc..0776232be520 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-querycap.rst
@@ -36,7 +36,7 @@ identify kernel devices compatible with this specification and to obtain
 information about driver and hardware capabilities. The ioctl takes a
 pointer to a struct :ref:`v4l2_capability <v4l2-capability>` which is
 filled by the driver. When the driver is not compatible with this
-specification the ioctl returns an EINVAL error code.
+specification the ioctl returns an ``EINVAL`` error code.
 
 
 .. _v4l2-capability:
diff --git a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
index a08c68262871..2c8ef053a1ab 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-queryctrl.rst
@@ -40,30 +40,30 @@ Description
 To query the attributes of a control applications set the ``id`` field
 of a struct :ref:`v4l2_queryctrl <v4l2-queryctrl>` and call the
 ``VIDIOC_QUERYCTRL`` ioctl with a pointer to this structure. The driver
-fills the rest of the structure or returns an EINVAL error code when the
+fills the rest of the structure or returns an ``EINVAL`` error code when the
 ``id`` is invalid.
 
 It is possible to enumerate controls by calling ``VIDIOC_QUERYCTRL``
 with successive ``id`` values starting from ``V4L2_CID_BASE`` up to and
-exclusive ``V4L2_CID_LASTP1``. Drivers may return EINVAL if a control in
+exclusive ``V4L2_CID_LASTP1``. Drivers may return ``EINVAL`` if a control in
 this range is not supported. Further applications can enumerate private
 controls, which are not defined in this specification, by starting at
 ``V4L2_CID_PRIVATE_BASE`` and incrementing ``id`` until the driver
-returns EINVAL.
+returns ``EINVAL``.
 
 In both cases, when the driver sets the ``V4L2_CTRL_FLAG_DISABLED`` flag
 in the ``flags`` field this control is permanently disabled and should
 be ignored by the application. [1]_
 
 When the application ORs ``id`` with ``V4L2_CTRL_FLAG_NEXT_CTRL`` the
-driver returns the next supported non-compound control, or EINVAL if
+driver returns the next supported non-compound control, or ``EINVAL`` if
 there is none. In addition, the ``V4L2_CTRL_FLAG_NEXT_COMPOUND`` flag
 can be specified to enumerate all compound controls (i.e. controls with
 type ≥ ``V4L2_CTRL_COMPOUND_TYPES`` and/or array control, in other words
 controls that contain more than one value). Specify both
 ``V4L2_CTRL_FLAG_NEXT_CTRL`` and ``V4L2_CTRL_FLAG_NEXT_COMPOUND`` in
 order to enumerate all controls, compound or not. Drivers which do not
-support these flags yet always return EINVAL.
+support these flags yet always return ``EINVAL``.
 
 The ``VIDIOC_QUERY_EXT_CTRL`` ioctl was introduced in order to better
 support controls that can use compound types, and to expose additional
@@ -78,12 +78,12 @@ Additional information is required for menu controls: the names of the
 menu items. To query them applications set the ``id`` and ``index``
 fields of struct :ref:`v4l2_querymenu <v4l2-querymenu>` and call the
 ``VIDIOC_QUERYMENU`` ioctl with a pointer to this structure. The driver
-fills the rest of the structure or returns an EINVAL error code when the
+fills the rest of the structure or returns an ``EINVAL`` error code when the
 ``id`` or ``index`` is invalid. Menu items are enumerated by calling
 ``VIDIOC_QUERYMENU`` with successive ``index`` values from struct
 :ref:`v4l2_queryctrl <v4l2-queryctrl>` ``minimum`` to ``maximum``,
 inclusive. Note that it is possible for ``VIDIOC_QUERYMENU`` to return
-an EINVAL error code for some indices between ``minimum`` and
+an ``EINVAL`` error code for some indices between ``minimum`` and
 ``maximum``. In that case that particular menu item is not supported by
 this driver. Also note that the ``minimum`` value is not necessarily 0.
 
@@ -108,7 +108,7 @@ See also the examples in :ref:`control`.
           :ref:`control-id` for predefined IDs. When the ID is ORed with
           V4L2_CTRL_FLAG_NEXT_CTRL the driver clears the flag and
           returns the first control with a higher ID. Drivers which do not
-          support this flag yet always return an EINVAL error code.
+          support this flag yet always return an ``EINVAL`` error code.
 
     -  .. row 2
 
@@ -533,7 +533,7 @@ See also the examples in :ref:`control`.
        -  0
 
        -  A control which performs an action when set. Drivers must ignore
-          the value passed with ``VIDIOC_S_CTRL`` and return an EINVAL error
+          the value passed with ``VIDIOC_S_CTRL`` and return an ``EINVAL`` error
           code on a ``VIDIOC_G_CTRL`` attempt.
 
     -  .. row 8
@@ -588,7 +588,7 @@ See also the examples in :ref:`control`.
           control ID equal to a control class code (see :ref:`ctrl-class`)
           + 1, the ioctl returns the name of the control class and this
           control type. Older drivers which do not support this feature
-          return an EINVAL error code.
+          return an ``EINVAL`` error code.
 
     -  .. row 11
 
@@ -647,7 +647,7 @@ See also the examples in :ref:`control`.
 
        -  This control is permanently disabled and should be ignored by the
           application. Any attempt to change the control will result in an
-          EINVAL error code.
+          ``EINVAL`` error code.
 
     -  .. row 2
 
@@ -658,7 +658,7 @@ See also the examples in :ref:`control`.
        -  This control is temporarily unchangeable, for example because
           another application took over control of the respective resource.
           Such controls may be displayed specially in a user interface.
-          Attempts to change the control may result in an EBUSY error code.
+          Attempts to change the control may result in an ``EBUSY`` error code.
 
     -  .. row 3
 
@@ -667,7 +667,7 @@ See also the examples in :ref:`control`.
        -  0x0004
 
        -  This control is permanently readable only. Any attempt to change
-          the control will result in an EINVAL error code.
+          the control will result in an ``EINVAL`` error code.
 
     -  .. row 4
 
@@ -706,7 +706,7 @@ See also the examples in :ref:`control`.
        -  0x0040
 
        -  This control is permanently writable only. Any attempt to read the
-          control will result in an EACCES error code error code. This flag
+          control will result in an ``EACCES`` error code error code. This flag
           is typically present for relative controls or action controls
           where writing a value will cause the device to carry out a given
           action (e. g. motor control) but no meaningful value can be
@@ -775,9 +775,9 @@ EACCES
 .. [1]
    ``V4L2_CTRL_FLAG_DISABLED`` was intended for two purposes: Drivers
    can skip predefined controls not supported by the hardware (although
-   returning EINVAL would do as well), or disable predefined and private
+   returning ``EINVAL`` would do as well), or disable predefined and private
    controls after hardware detection without the trouble of reordering
-   control arrays and indices (EINVAL cannot be used to skip private
+   control arrays and indices (``EINVAL`` cannot be used to skip private
    controls because it would prematurely end the enumeration).
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
index 23b2fee646a1..411b5bf80313 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-reqbufs.rst
@@ -55,7 +55,7 @@ number is also possible when the driver requires more buffers to
 function correctly. For example video output requires at least two
 buffers, one displayed and one filled by the application.
 
-When the I/O method is not supported the ioctl returns an EINVAL error
+When the I/O method is not supported the ioctl returns an ``EINVAL`` error
 code.
 
 Applications can call :ref:`VIDIOC_REQBUFS` again to change the number of
diff --git a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
index 226440e4bb76..68c96236806d 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-s-hw-freq-seek.rst
@@ -55,7 +55,7 @@ If an error is returned, then the original frequency will be restored.
 This ioctl is supported if the ``V4L2_CAP_HW_FREQ_SEEK`` capability is
 set.
 
-If this ioctl is called from a non-blocking filehandle, then EAGAIN
+If this ioctl is called from a non-blocking filehandle, then ``EAGAIN``
 error code is returned and no seek takes place.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
index bcf161cd5012..8c5298175ba5 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-frame-interval.rst
@@ -48,7 +48,7 @@ and call the :ref:`VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL` ioctl with a pointer
 to this structure. Drivers fill the rest of the structure or return an
 EINVAL error code if one of the input fields is invalid. All frame
 intervals are enumerable by beginning at index zero and incrementing by
-one until EINVAL is returned.
+one until ``EINVAL`` is returned.
 
 Available frame intervals may depend on the current 'try' formats at
 other pads of the sub-device, as well as on the current active links.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
index dbaf866e82fe..13d466c2a4e1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-enum-mbus-code.rst
@@ -36,10 +36,10 @@ applications initialize the ``pad``, ``which`` and ``index`` fields of
 struct
 :ref:`v4l2_subdev_mbus_code_enum <v4l2-subdev-mbus-code-enum>` and
 call the :ref:`VIDIOC_SUBDEV_ENUM_MBUS_CODE` ioctl with a pointer to this
-structure. Drivers fill the rest of the structure or return an EINVAL
+structure. Drivers fill the rest of the structure or return an ``EINVAL``
 error code if either the ``pad`` or ``index`` are invalid. All media bus
 formats are enumerable by beginning at index zero and incrementing by
-one until EINVAL is returned.
+one until ``EINVAL`` is returned.
 
 Available media bus formats may depend on the current 'try' formats at
 other pads of the sub-device, as well as on the current active links.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
index 46776cdfa7b5..88416ba28d86 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-subdev-g-crop.rst
@@ -45,7 +45,7 @@ field of a struct :ref:`v4l2_subdev_crop <v4l2-subdev-crop>` to the
 desired pad number as reported by the media API and the ``which`` field
 to ``V4L2_SUBDEV_FORMAT_ACTIVE``. They then call the
 ``VIDIOC_SUBDEV_G_CROP`` ioctl with a pointer to this structure. The
-driver fills the members of the ``rect`` field or returns EINVAL error
+driver fills the members of the ``rect`` field or returns ``EINVAL`` error
 code if the input arguments are invalid, or if cropping is not supported
 on the given pad.
 
-- 
2.7.4


