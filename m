Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38685 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbcGEBb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 16/41] Documentation: linux_tv: avoid using c:func::
Date: Mon,  4 Jul 2016 22:30:51 -0300
Message-Id: <5de9ffd5fb0803f06bbb88cfc2e1da8bcc16a6aa.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using auto-generated links is dangerous, as there are multiple
definitions for syscalls (at least one on each book part).

So, reference them by their explicit reference.

I used this small script to help writing this patch:

for i in $(git grep -l "c:func:"); do perl -ne 's/\:c\:func:\`(open|close|read|poll|write|select|mmap|munmap|ioctl)\(\)`/:ref:`$1() <func-$1>`/; print $_' < $i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../linux_tv/media/dvb/frontend_f_open.rst         |  5 ++--
 Documentation/linux_tv/media/v4l/dmabuf.rst        |  2 +-
 Documentation/linux_tv/media/v4l/func-ioctl.rst    |  2 +-
 Documentation/linux_tv/media/v4l/func-mmap.rst     |  8 ++---
 Documentation/linux_tv/media/v4l/func-munmap.rst   |  4 +--
 Documentation/linux_tv/media/v4l/func-open.rst     |  6 ++--
 Documentation/linux_tv/media/v4l/func-poll.rst     | 32 ++++++++++----------
 Documentation/linux_tv/media/v4l/func-read.rst     | 26 ++++++++---------
 Documentation/linux_tv/media/v4l/func-select.rst   | 34 +++++++++++-----------
 Documentation/linux_tv/media/v4l/func-write.rst    |  6 ++--
 Documentation/linux_tv/media/v4l/io.rst            |  4 +--
 .../linux_tv/media/v4l/media-func-close.rst        |  2 +-
 .../linux_tv/media/v4l/media-func-ioctl.rst        |  2 +-
 .../linux_tv/media/v4l/media-func-open.rst         |  4 +--
 Documentation/linux_tv/media/v4l/mmap.rst          | 12 ++++----
 Documentation/linux_tv/media/v4l/rw.rst            |  8 ++---
 Documentation/linux_tv/media/v4l/userp.rst         |  6 ++--
 .../linux_tv/media/v4l/vidioc-decoder-cmd.rst      |  4 +--
 .../linux_tv/media/v4l/vidioc-encoder-cmd.rst      |  8 ++---
 Documentation/linux_tv/media/v4l/vidioc-g-parm.rst |  8 ++---
 20 files changed, 92 insertions(+), 91 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/frontend_f_open.rst b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
index ba9fbb17f70d..d28c64514433 100644
--- a/Documentation/linux_tv/media/dvb/frontend_f_open.rst
+++ b/Documentation/linux_tv/media/dvb/frontend_f_open.rst
@@ -72,8 +72,9 @@ that possible.
 Return Value
 ============
 
-On success :c:func:`open()` returns the new file descriptor. On error
--1 is returned, and the ``errno`` variable is set appropriately.
+On success :ref:`open() <frontend_f_open>` returns the new file descriptor.
+On error, -1 is returned, and the ``errno`` variable is set appropriately.
+
 Possible error codes are:
 
 EACCES
diff --git a/Documentation/linux_tv/media/v4l/dmabuf.rst b/Documentation/linux_tv/media/v4l/dmabuf.rst
index cd68f755c0e3..ae1bd2dfc61e 100644
--- a/Documentation/linux_tv/media/v4l/dmabuf.rst
+++ b/Documentation/linux_tv/media/v4l/dmabuf.rst
@@ -146,4 +146,4 @@ outputted buffers.
 Drivers implementing DMABUF importing I/O must support the
 ``VIDIOC_REQBUFS``, ``VIDIOC_QBUF``, ``VIDIOC_DQBUF``,
 ``VIDIOC_STREAMON`` and ``VIDIOC_STREAMOFF`` ioctls, and the
-:c:func:`select()` and :c:func:`poll()` functions.
+:ref:`select() <func-select>` and :ref:`poll() <func-poll>` functions.
diff --git a/Documentation/linux_tv/media/v4l/func-ioctl.rst b/Documentation/linux_tv/media/v4l/func-ioctl.rst
index d442d9b56dfb..fafec5f56a36 100644
--- a/Documentation/linux_tv/media/v4l/func-ioctl.rst
+++ b/Documentation/linux_tv/media/v4l/func-ioctl.rst
@@ -38,7 +38,7 @@ Arguments
 Description
 ===========
 
-The :c:func:`ioctl()` function is used to program V4L2 devices. The
+The :ref:`ioctl() <func-ioctl>` function is used to program V4L2 devices. The
 argument ``fd`` must be an open file descriptor. An ioctl ``request``
 has encoded in it whether the argument is an input, output or read/write
 parameter, and the size of the argument ``argp`` in bytes. Macros and
diff --git a/Documentation/linux_tv/media/v4l/func-mmap.rst b/Documentation/linux_tv/media/v4l/func-mmap.rst
index a0be2d9b5421..345ac3005c8f 100644
--- a/Documentation/linux_tv/media/v4l/func-mmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-mmap.rst
@@ -49,7 +49,7 @@ Arguments
     module, which is used by the bttv, saa7134, saa7146, cx88 and vivi
     driver supports only ``PROT_READ`` | ``PROT_WRITE``. When the
     driver does not support the desired protection the
-    :c:func:`mmap()` function fails.
+    :ref:`mmap() <func-mmap>` function fails.
 
     Note device memory accesses (e. g. the memory on a graphics card
     with video capturing hardware) may incur a performance penalty
@@ -65,7 +65,7 @@ Arguments
 
     ``MAP_FIXED`` requests that the driver selects no other address than
     the one specified. If the specified address cannot be used,
-    :c:func:`mmap()` will fail. If ``MAP_FIXED`` is specified,
+    :ref:`mmap() <func-mmap>` will fail. If ``MAP_FIXED`` is specified,
     ``start`` must be a multiple of the pagesize. Use of this option is
     discouraged.
 
@@ -92,7 +92,7 @@ Arguments
 Description
 ===========
 
-The :c:func:`mmap()` function asks to map ``length`` bytes starting at
+The :ref:`mmap() <func-mmap>` function asks to map ``length`` bytes starting at
 ``offset`` in the memory of the device specified by ``fd`` into the
 application address space, preferably at address ``start``. This latter
 address is a hint only, and is usually specified as 0.
@@ -108,7 +108,7 @@ To unmap buffers the :ref:`munmap() <func-munmap>` function is used.
 Return Value
 ============
 
-On success :c:func:`mmap()` returns a pointer to the mapped buffer. On
+On success :ref:`mmap() <func-mmap>` returns a pointer to the mapped buffer. On
 error ``MAP_FAILED`` (-1) is returned, and the ``errno`` variable is set
 appropriately. Possible error codes are:
 
diff --git a/Documentation/linux_tv/media/v4l/func-munmap.rst b/Documentation/linux_tv/media/v4l/func-munmap.rst
index 1f9831795db7..f87eb387f499 100644
--- a/Documentation/linux_tv/media/v4l/func-munmap.rst
+++ b/Documentation/linux_tv/media/v4l/func-munmap.rst
@@ -31,7 +31,7 @@ Arguments
 
 ``length``
     Length of the mapped buffer. This must be the same value as given to
-    :c:func:`mmap()` and returned by the driver in the struct
+    :ref:`mmap() <func-mmap>` and returned by the driver in the struct
     :ref:`v4l2_buffer <v4l2-buffer>` ``length`` field for the
     single-planar API and in the struct
     :ref:`v4l2_plane <v4l2-plane>` ``length`` field for the
@@ -48,7 +48,7 @@ buffer and frees it, if possible.
 Return Value
 ============
 
-On success :c:func:`munmap()` returns 0, on failure -1 and the
+On success :ref:`munmap() <func-munmap>` returns 0, on failure -1 and the
 ``errno`` variable is set appropriately:
 
 EINVAL
diff --git a/Documentation/linux_tv/media/v4l/func-open.rst b/Documentation/linux_tv/media/v4l/func-open.rst
index c021772a9dee..9598c0fd592e 100644
--- a/Documentation/linux_tv/media/v4l/func-open.rst
+++ b/Documentation/linux_tv/media/v4l/func-open.rst
@@ -45,10 +45,10 @@ Arguments
 Description
 ===========
 
-To open a V4L2 device applications call :c:func:`open()` with the
+To open a V4L2 device applications call :ref:`open() <func-open>` with the
 desired device name. This function has no side effects; all data format
 parameters, current input or output, control values or other properties
-remain unchanged. At the first :c:func:`open()` call after loading the
+remain unchanged. At the first :ref:`open() <func-open>` call after loading the
 driver they will be reset to default values, drivers are never in an
 undefined state.
 
@@ -56,7 +56,7 @@ undefined state.
 Return Value
 ============
 
-On success :c:func:`open()` returns the new file descriptor. On error
+On success :ref:`open() <func-open>` returns the new file descriptor. On error
 -1 is returned, and the ``errno`` variable is set appropriately.
 Possible error codes are:
 
diff --git a/Documentation/linux_tv/media/v4l/func-poll.rst b/Documentation/linux_tv/media/v4l/func-poll.rst
index bfbcec2bb0cd..27f381d75de1 100644
--- a/Documentation/linux_tv/media/v4l/func-poll.rst
+++ b/Documentation/linux_tv/media/v4l/func-poll.rst
@@ -24,7 +24,7 @@ Synopsis
 Description
 ===========
 
-With the :c:func:`poll()` function applications can suspend execution
+With the :ref:`poll() <func-poll>` function applications can suspend execution
 until the driver has captured data or is ready to accept data for
 output.
 
@@ -37,7 +37,7 @@ display. When buffers are already in the outgoing queue of the driver
 (capture) or the incoming queue isn't full (display) the function
 returns immediately.
 
-On success :c:func:`poll()` returns the number of file descriptors
+On success :ref:`poll() <func-poll>` returns the number of file descriptors
 that have been selected (that is, file descriptors for which the
 ``revents`` field of the respective :c:func:`struct pollfd` structure
 is non-zero). Capture devices set the ``POLLIN`` and ``POLLRDNORM``
@@ -45,49 +45,49 @@ flags in the ``revents`` field, output devices the ``POLLOUT`` and
 ``POLLWRNORM`` flags. When the function timed out it returns a value of
 zero, on failure it returns -1 and the ``errno`` variable is set
 appropriately. When the application did not call
-:ref:`VIDIOC_STREAMON` the :c:func:`poll()`
+:ref:`VIDIOC_STREAMON` the :ref:`poll() <func-poll>`
 function succeeds, but sets the ``POLLERR`` flag in the ``revents``
 field. When the application has called
 :ref:`VIDIOC_STREAMON` for a capture device but
 hasn't yet called :ref:`VIDIOC_QBUF`, the
-:c:func:`poll()` function succeeds and sets the ``POLLERR`` flag in
+:ref:`poll() <func-poll>` function succeeds and sets the ``POLLERR`` flag in
 the ``revents`` field. For output devices this same situation will cause
-:c:func:`poll()` to succeed as well, but it sets the ``POLLOUT`` and
+:ref:`poll() <func-poll>` to succeed as well, but it sets the ``POLLOUT`` and
 ``POLLWRNORM`` flags in the ``revents`` field.
 
 If an event occurred (see :ref:`VIDIOC_DQEVENT`)
 then ``POLLPRI`` will be set in the ``revents`` field and
-:c:func:`poll()` will return.
+:ref:`poll() <func-poll>` will return.
 
-When use of the :c:func:`read()` function has been negotiated and the
-driver does not capture yet, the :c:func:`poll()` function starts
+When use of the :ref:`read() <func-read>` function has been negotiated and the
+driver does not capture yet, the :ref:`poll() <func-poll>` function starts
 capturing. When that fails it returns a ``POLLERR`` as above. Otherwise
 it waits until data has been captured and can be read. When the driver
 captures continuously (as opposed to, for example, still images) the
 function may return immediately.
 
-When use of the :c:func:`write()` function has been negotiated and the
-driver does not stream yet, the :c:func:`poll()` function starts
+When use of the :ref:`write() <func-write>` function has been negotiated and the
+driver does not stream yet, the :ref:`poll() <func-poll>` function starts
 streaming. When that fails it returns a ``POLLERR`` as above. Otherwise
 it waits until the driver is ready for a non-blocking
-:c:func:`write()` call.
+:ref:`write() <func-write>` call.
 
 If the caller is only interested in events (just ``POLLPRI`` is set in
-the ``events`` field), then :c:func:`poll()` will *not* start
+the ``events`` field), then :ref:`poll() <func-poll>` will *not* start
 streaming if the driver does not stream yet. This makes it possible to
 just poll for events and not for buffers.
 
-All drivers implementing the :c:func:`read()` or :c:func:`write()`
-function or streaming I/O must also support the :c:func:`poll()`
+All drivers implementing the :ref:`read() <func-read>` or :ref:`write() <func-write>`
+function or streaming I/O must also support the :ref:`poll() <func-poll>`
 function.
 
-For more details see the :c:func:`poll()` manual page.
+For more details see the :ref:`poll() <func-poll>` manual page.
 
 
 Return Value
 ============
 
-On success, :c:func:`poll()` returns the number structures which have
+On success, :ref:`poll() <func-poll>` returns the number structures which have
 non-zero ``revents`` fields, or zero if the call timed out. On error -1
 is returned, and the ``errno`` variable is set appropriately:
 
diff --git a/Documentation/linux_tv/media/v4l/func-read.rst b/Documentation/linux_tv/media/v4l/func-read.rst
index 9238ecddec72..75985f664da7 100644
--- a/Documentation/linux_tv/media/v4l/func-read.rst
+++ b/Documentation/linux_tv/media/v4l/func-read.rst
@@ -34,48 +34,48 @@ Arguments
 Description
 ===========
 
-:c:func:`read()` attempts to read up to ``count`` bytes from file
+:ref:`read() <func-read>` attempts to read up to ``count`` bytes from file
 descriptor ``fd`` into the buffer starting at ``buf``. The layout of the
 data in the buffer is discussed in the respective device interface
-section, see ##. If ``count`` is zero, :c:func:`read()` returns zero
+section, see ##. If ``count`` is zero, :ref:`read() <func-read>` returns zero
 and has no other results. If ``count`` is greater than ``SSIZE_MAX``,
 the result is unspecified. Regardless of the ``count`` value each
-:c:func:`read()` call will provide at most one frame (two fields)
+:ref:`read() <func-read>` call will provide at most one frame (two fields)
 worth of data.
 
-By default :c:func:`read()` blocks until data becomes available. When
+By default :ref:`read() <func-read>` blocks until data becomes available. When
 the ``O_NONBLOCK`` flag was given to the :ref:`open() <func-open>`
 function it returns immediately with an ``EAGAIN`` error code when no data
 is available. The :ref:`select() <func-select>` or
 :ref:`poll() <func-poll>` functions can always be used to suspend
 execution until data becomes available. All drivers supporting the
-:c:func:`read()` function must also support :c:func:`select()` and
-:c:func:`poll()`.
+:ref:`read() <func-read>` function must also support :ref:`select() <func-select>` and
+:ref:`poll() <func-poll>`.
 
 Drivers can implement read functionality in different ways, using a
 single or multiple buffers and discarding the oldest or newest frames
 once the internal buffers are filled.
 
-:c:func:`read()` never returns a "snapshot" of a buffer being filled.
+:ref:`read() <func-read>` never returns a "snapshot" of a buffer being filled.
 Using a single buffer the driver will stop capturing when the
 application starts reading the buffer until the read is finished. Thus
 only the period of the vertical blanking interval is available for
 reading, or the capture rate must fall below the nominal frame rate of
 the video standard.
 
-The behavior of :c:func:`read()` when called during the active picture
+The behavior of :ref:`read() <func-read>` when called during the active picture
 period or the vertical blanking separating the top and bottom field
 depends on the discarding policy. A driver discarding the oldest frames
 keeps capturing into an internal buffer, continuously overwriting the
 previously, not read frame, and returns the frame being received at the
-time of the :c:func:`read()` call as soon as it is complete.
+time of the :ref:`read() <func-read>` call as soon as it is complete.
 
 A driver discarding the newest frames stops capturing until the next
-:c:func:`read()` call. The frame being received at :c:func:`read()`
+:ref:`read() <func-read>` call. The frame being received at :ref:`read() <func-read>`
 time is discarded, returning the following frame instead. Again this
 implies a reduction of the capture rate to one half or less of the
 nominal frame rate. An example of this model is the video read mode of
-the bttv driver, initiating a DMA to user memory when :c:func:`read()`
+the bttv driver, initiating a DMA to user memory when :ref:`read() <func-read>`
 is called and returning when the DMA finished.
 
 In the multiple buffer model drivers maintain a ring of internal
@@ -97,7 +97,7 @@ Return Value
 On success, the number of bytes read is returned. It is not an error if
 this number is smaller than the number of bytes requested, or the amount
 of data required for one frame. This may happen for example because
-:c:func:`read()` was interrupted by a signal. On error, -1 is
+:ref:`read() <func-read>` was interrupted by a signal. On error, -1 is
 returned, and the ``errno`` variable is set appropriately. In this case
 the next read will start at the beginning of a new frame. Possible error
 codes are:
@@ -125,5 +125,5 @@ EIO
     communicate with a remote device (USB camera etc.).
 
 EINVAL
-    The :c:func:`read()` function is not supported by this driver, not
+    The :ref:`read() <func-read>` function is not supported by this driver, not
     on this device, or generally not on this type of device.
diff --git a/Documentation/linux_tv/media/v4l/func-select.rst b/Documentation/linux_tv/media/v4l/func-select.rst
index 5f2ff6a5e00c..57089f5cc6cd 100644
--- a/Documentation/linux_tv/media/v4l/func-select.rst
+++ b/Documentation/linux_tv/media/v4l/func-select.rst
@@ -26,7 +26,7 @@ Synopsis
 Description
 ===========
 
-With the :c:func:`select()` function applications can suspend
+With the :ref:`select() <func-select>` function applications can suspend
 execution until the driver has captured data or is ready to accept data
 for output.
 
@@ -35,40 +35,40 @@ buffer has been filled or displayed and can be dequeued with the
 :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. When buffers are already in
 the outgoing queue of the driver the function returns immediately.
 
-On success :c:func:`select()` returns the total number of bits set in
+On success :ref:`select() <func-select>` returns the total number of bits set in
 :c:func:`struct fd_set`. When the function timed out it returns
 a value of zero. On failure it returns -1 and the ``errno`` variable is
 set appropriately. When the application did not call
 :ref:`VIDIOC_QBUF` or
-:ref:`VIDIOC_STREAMON` yet the :c:func:`select()`
+:ref:`VIDIOC_STREAMON` yet the :ref:`select() <func-select>`
 function succeeds, setting the bit of the file descriptor in ``readfds``
 or ``writefds``, but subsequent :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>`
 calls will fail. [1]_
 
-When use of the :c:func:`read()` function has been negotiated and the
-driver does not capture yet, the :c:func:`select()` function starts
-capturing. When that fails, :c:func:`select()` returns successful and
-a subsequent :c:func:`read()` call, which also attempts to start
+When use of the :ref:`read() <func-read>` function has been negotiated and the
+driver does not capture yet, the :ref:`select() <func-select>` function starts
+capturing. When that fails, :ref:`select() <func-select>` returns successful and
+a subsequent :ref:`read() <func-read>` call, which also attempts to start
 capturing, will return an appropriate error code. When the driver
 captures continuously (as opposed to, for example, still images) and
-data is already available the :c:func:`select()` function returns
+data is already available the :ref:`select() <func-select>` function returns
 immediately.
 
-When use of the :c:func:`write()` function has been negotiated the
-:c:func:`select()` function just waits until the driver is ready for a
-non-blocking :c:func:`write()` call.
+When use of the :ref:`write() <func-write>` function has been negotiated the
+:ref:`select() <func-select>` function just waits until the driver is ready for a
+non-blocking :ref:`write() <func-write>` call.
 
-All drivers implementing the :c:func:`read()` or :c:func:`write()`
-function or streaming I/O must also support the :c:func:`select()`
+All drivers implementing the :ref:`read() <func-read>` or :ref:`write() <func-write>`
+function or streaming I/O must also support the :ref:`select() <func-select>`
 function.
 
-For more details see the :c:func:`select()` manual page.
+For more details see the :ref:`select() <func-select>` manual page.
 
 
 Return Value
 ============
 
-On success, :c:func:`select()` returns the number of descriptors
+On success, :ref:`select() <func-select>` returns the number of descriptors
 contained in the three returned descriptor sets, which will be zero if
 the timeout expired. On error -1 is returned, and the ``errno`` variable
 is set appropriately; the sets and ``timeout`` are undefined. Possible
@@ -94,6 +94,6 @@ EINVAL
     ``FD_SETSIZE``.
 
 .. [1]
-   The Linux kernel implements :c:func:`select()` like the
-   :ref:`poll() <func-poll>` function, but :c:func:`select()` cannot
+   The Linux kernel implements :ref:`select() <func-select>` like the
+   :ref:`poll() <func-poll>` function, but :ref:`select() <func-select>` cannot
    return a ``POLLERR``.
diff --git a/Documentation/linux_tv/media/v4l/func-write.rst b/Documentation/linux_tv/media/v4l/func-write.rst
index fee5fe004c0a..a4b093ba15c3 100644
--- a/Documentation/linux_tv/media/v4l/func-write.rst
+++ b/Documentation/linux_tv/media/v4l/func-write.rst
@@ -34,10 +34,10 @@ Arguments
 Description
 ===========
 
-:c:func:`write()` writes up to ``count`` bytes to the device
+:ref:`write() <func-write>` writes up to ``count`` bytes to the device
 referenced by the file descriptor ``fd`` from the buffer starting at
 ``buf``. When the hardware outputs are not active yet, this function
-enables them. When ``count`` is zero, :c:func:`write()` returns 0
+enables them. When ``count`` is zero, :ref:`write() <func-write>` returns 0
 without any other effect.
 
 When the application does not provide more data in time, the previous
@@ -76,5 +76,5 @@ EIO
     I/O error. This indicates some hardware problem.
 
 EINVAL
-    The :c:func:`write()` function is not supported by this driver,
+    The :ref:`write() <func-write>` function is not supported by this driver,
     not on this device, or generally not on this type of device.
diff --git a/Documentation/linux_tv/media/v4l/io.rst b/Documentation/linux_tv/media/v4l/io.rst
index e68342606ed3..94b38a10ee65 100644
--- a/Documentation/linux_tv/media/v4l/io.rst
+++ b/Documentation/linux_tv/media/v4l/io.rst
@@ -9,8 +9,8 @@ The V4L2 API defines several different methods to read from or write to
 a device. All drivers exchanging data with applications must support at
 least one of them.
 
-The classic I/O method using the :c:func:`read()` and
-:c:func:`write()` function is automatically selected after opening a
+The classic I/O method using the :ref:`read() <func-read>` and
+:ref:`write() <func-write>` function is automatically selected after opening a
 V4L2 device. When the driver does not support this method attempts to
 read or write will fail at any time.
 
diff --git a/Documentation/linux_tv/media/v4l/media-func-close.rst b/Documentation/linux_tv/media/v4l/media-func-close.rst
index 959bfa0cb6a8..109b831e4047 100644
--- a/Documentation/linux_tv/media/v4l/media-func-close.rst
+++ b/Documentation/linux_tv/media/v4l/media-func-close.rst
@@ -38,7 +38,7 @@ are freed. The device configuration remain unchanged.
 Return Value
 ============
 
-:c:func:`close()` returns 0 on success. On error, -1 is returned, and
+:ref:`close() <func-close>` returns 0 on success. On error, -1 is returned, and
 ``errno`` is set appropriately. Possible error codes are:
 
 EBADF
diff --git a/Documentation/linux_tv/media/v4l/media-func-ioctl.rst b/Documentation/linux_tv/media/v4l/media-func-ioctl.rst
index d7a3a01771ec..c56ccb9c9b39 100644
--- a/Documentation/linux_tv/media/v4l/media-func-ioctl.rst
+++ b/Documentation/linux_tv/media/v4l/media-func-ioctl.rst
@@ -38,7 +38,7 @@ Arguments
 Description
 ===========
 
-The :c:func:`ioctl()` function manipulates media device parameters.
+The :ref:`ioctl() <func-ioctl>` function manipulates media device parameters.
 The argument ``fd`` must be an open file descriptor.
 
 The ioctl ``request`` code specifies the media function to be called. It
diff --git a/Documentation/linux_tv/media/v4l/media-func-open.rst b/Documentation/linux_tv/media/v4l/media-func-open.rst
index fc731060a726..627860b33ae2 100644
--- a/Documentation/linux_tv/media/v4l/media-func-open.rst
+++ b/Documentation/linux_tv/media/v4l/media-func-open.rst
@@ -35,7 +35,7 @@ Arguments
 Description
 ===========
 
-To open a media device applications call :c:func:`open()` with the
+To open a media device applications call :ref:`open() <func-open>` with the
 desired device name. The function has no side effects; the device
 configuration remain unchanged.
 
@@ -47,7 +47,7 @@ EBADF.
 Return Value
 ============
 
-:c:func:`open()` returns the new file descriptor on success. On error,
+:ref:`open() <func-open>` returns the new file descriptor on success. On error,
 -1 is returned, and ``errno`` is set appropriately. Possible error codes
 are:
 
diff --git a/Documentation/linux_tv/media/v4l/mmap.rst b/Documentation/linux_tv/media/v4l/mmap.rst
index 5769ed36872f..1ed17fa3368a 100644
--- a/Documentation/linux_tv/media/v4l/mmap.rst
+++ b/Documentation/linux_tv/media/v4l/mmap.rst
@@ -40,7 +40,7 @@ location of the buffers in device memory can be determined with the
 :ref:`VIDIOC_QUERYBUF` ioctl. In the single-planar
 API case, the ``m.offset`` and ``length`` returned in a struct
 :ref:`v4l2_buffer <v4l2-buffer>` are passed as sixth and second
-parameter to the :c:func:`mmap()` function. When using the
+parameter to the :ref:`mmap() <func-mmap>` function. When using the
 multi-planar API, struct :ref:`v4l2_buffer <v4l2-buffer>` contains an
 array of struct :ref:`v4l2_plane <v4l2-plane>` structures, each
 containing its own ``m.offset`` and ``length``. When using the
@@ -251,15 +251,15 @@ event it should examine the struct :ref:`v4l2_buffer <v4l2-buffer>`
 Drivers implementing memory mapping I/O must support the
 ``VIDIOC_REQBUFS``, ``VIDIOC_QUERYBUF``, ``VIDIOC_QBUF``,
 ``VIDIOC_DQBUF``, ``VIDIOC_STREAMON`` and ``VIDIOC_STREAMOFF`` ioctl,
-the :c:func:`mmap()`, :c:func:`munmap()`, :c:func:`select()` and
-:c:func:`poll()` function. [3]_
+the :ref:`mmap() <func-mmap>`, :ref:`munmap() <func-munmap>`, :ref:`select() <func-select>` and
+:ref:`poll() <func-poll>` function. [3]_
 
 [capture example]
 
 .. [1]
    One could use one file descriptor and set the buffer type field
    accordingly when calling :ref:`VIDIOC_QBUF` etc.,
-   but it makes the :c:func:`select()` function ambiguous. We also
+   but it makes the :ref:`select() <func-select>` function ambiguous. We also
    like the clean approach of one file descriptor per logical stream.
    Video overlay for example is also a logical stream, although the CPU
    is not needed for continuous operation.
@@ -272,6 +272,6 @@ the :c:func:`mmap()`, :c:func:`munmap()`, :c:func:`select()` and
    scatter-gather lists and the like.
 
 .. [3]
-   At the driver level :c:func:`select()` and :c:func:`poll()` are
-   the same, and :c:func:`select()` is too important to be optional.
+   At the driver level :ref:`select() <func-select>` and :ref:`poll() <func-poll>` are
+   the same, and :ref:`select() <func-select>` is too important to be optional.
    The rest should be evident.
diff --git a/Documentation/linux_tv/media/v4l/rw.rst b/Documentation/linux_tv/media/v4l/rw.rst
index 9dc58651ef02..66ba54648c45 100644
--- a/Documentation/linux_tv/media/v4l/rw.rst
+++ b/Documentation/linux_tv/media/v4l/rw.rst
@@ -6,8 +6,8 @@
 Read/Write
 **********
 
-Input and output devices support the :c:func:`read()` and
-:c:func:`write()` function, respectively, when the
+Input and output devices support the :ref:`read() <func-read>` and
+:ref:`write() <func-write>` function, respectively, when the
 ``V4L2_CAP_READWRITE`` flag in the ``capabilities`` field of struct
 :ref:`v4l2_capability <v4l2-capability>` returned by the
 :ref:`VIDIOC_QUERYCAP` ioctl is set.
@@ -43,5 +43,5 @@ driver must also support the :ref:`select() <func-select>` and
    capturing still images.
 
 .. [2]
-   At the driver level :c:func:`select()` and :c:func:`poll()` are
-   the same, and :c:func:`select()` is too important to be optional.
+   At the driver level :ref:`select() <func-select>` and :ref:`poll() <func-poll>` are
+   the same, and :ref:`select() <func-select>` is too important to be optional.
diff --git a/Documentation/linux_tv/media/v4l/userp.rst b/Documentation/linux_tv/media/v4l/userp.rst
index 3f4df1fd984d..f372d39512a8 100644
--- a/Documentation/linux_tv/media/v4l/userp.rst
+++ b/Documentation/linux_tv/media/v4l/userp.rst
@@ -94,7 +94,7 @@ outputted buffers.
 Drivers implementing user pointer I/O must support the
 ``VIDIOC_REQBUFS``, ``VIDIOC_QBUF``, ``VIDIOC_DQBUF``,
 ``VIDIOC_STREAMON`` and ``VIDIOC_STREAMOFF`` ioctl, the
-:c:func:`select()` and :c:func:`poll()` function. [2]_
+:ref:`select() <func-select>` and :ref:`poll() <func-poll>` function. [2]_
 
 .. [1]
    We expect that frequently used buffers are typically not swapped out.
@@ -109,6 +109,6 @@ Drivers implementing user pointer I/O must support the
    because an application may share them with other processes.
 
 .. [2]
-   At the driver level :c:func:`select()` and :c:func:`poll()` are
-   the same, and :c:func:`select()` is too important to be optional.
+   At the driver level :ref:`select() <func-select>` and :ref:`poll() <func-poll>` are
+   the same, and :ref:`select() <func-select>` is too important to be optional.
    The rest should be evident.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
index 5f7be4ee8a51..f75698d7caca 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-decoder-cmd.rst
@@ -43,11 +43,11 @@ this structure.
 The ``cmd`` field must contain the command code. Some commands use the
 ``flags`` field for additional information.
 
-A :c:func:`write()`() or :ref:`VIDIOC_STREAMON`
+A :ref:`write() <func-write>` or :ref:`VIDIOC_STREAMON`
 call sends an implicit START command to the decoder if it has not been
 started yet.
 
-A :c:func:`close()`() or :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
+A :ref:`close() <func-close>` or :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
 call of a streaming file descriptor sends an implicit immediate STOP
 command to the decoder, and all buffered data is discarded.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
index cd7cc4bfd756..a5056f829e15 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-encoder-cmd.rst
@@ -48,14 +48,14 @@ currently only used by the STOP command and contains one bit: If the
 until the end of the current *Group Of Pictures*, otherwise it will stop
 immediately.
 
-A :c:func:`read()`() or :ref:`VIDIOC_STREAMON`
+A :ref:`read() <func-read>` or :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
 call sends an implicit START command to the encoder if it has not been
-started yet. After a STOP command, :c:func:`read()`() calls will read
+started yet. After a STOP command, :ref:`read() <func-read>` calls will read
 the remaining data buffered by the driver. When the buffer is empty,
-:c:func:`read()`() will return zero and the next :c:func:`read()`()
+:ref:`read() <func-read>` will return zero and the next :ref:`read() <func-read>`
 call will restart the encoder.
 
-A :c:func:`close()`() or :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
+A :ref:`close() <func-close>` or :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
 call of a streaming file descriptor sends an implicit immediate STOP to
 the encoder, and all buffered data is discarded.
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
index 0f96b95ebc0e..480d2923c982 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-parm.rst
@@ -35,8 +35,8 @@ Description
 The current video standard determines a nominal number of frames per
 second. If less than this number of frames is to be captured or output,
 applications can request frame skipping or duplicating on the driver
-side. This is especially useful when using the :c:func:`read()` or
-:c:func:`write()`, which are not augmented by timestamps or sequence
+side. This is especially useful when using the :ref:`read() <func-read>` or
+:ref:`write() <func-write>`, which are not augmented by timestamps or sequence
 counters, and to avoid unnecessary data copying.
 
 Further these ioctls can be used to determine the number of buffers used
@@ -260,7 +260,7 @@ union holding separate parameters for input and output devices.
        -  ``writebuffers``
 
        -  Applications set this field to the desired number of buffers used
-          internally by the driver in :c:func:`write()` mode. Drivers
+          internally by the driver in :ref:`write() <func-write>` mode. Drivers
           return the actual number of buffers. When an application requests
           zero buffers, drivers should just return the current setting
           rather than the minimum or an error code. For details see
@@ -337,7 +337,7 @@ union holding separate parameters for input and output devices.
 
           -  Moving objects in the image might have excessive motion blur.
 
-          -  Capture might only work through the :c:func:`read()` call.
+          -  Capture might only work through the :ref:`read() <func-read>` call.
 
 
 
-- 
2.7.4

