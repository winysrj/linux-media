Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 03/41] Documentation: dmx_fcalls.rst: improve man-like format
Date: Mon,  4 Jul 2016 22:30:38 -0300
Message-Id: <b7151f9401d31d7cd9a412d0f5e1788c9d596153.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parsing this file were causing lots of warnings with sphinx,
due to the c function prototypes.

Fix that by prepending them with .. cpp:function::

While here, use the same way we document man-like pages,
at the V4L side of the book and add escapes to asterisks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/dmx_fcalls.rst | 262 +++++++++++++++---------
 1 file changed, 161 insertions(+), 101 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/dmx_fcalls.rst b/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
index 4612364fb2d8..7016a822f817 100644
--- a/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
+++ b/Documentation/linux_tv/media/dvb/dmx_fcalls.rst
@@ -9,10 +9,11 @@ Demux Function Calls
 
 .. _dmx_fopen:
 
-open()
-======
+DVB demux open()
+================
 
-DESCRIPTION
+Description
+-----------
 
 This system call, used with a device name of /dev/dvb/adapter0/demux0,
 allocates a new filter and returns a handle which can be used for
@@ -31,11 +32,13 @@ affect the semantics of the open() call itself. A device opened in
 blocking mode can later be put into non-blocking mode (and vice versa)
 using the F_SETFL command of the fcntl system call.
 
-SYNOPSIS
+Synopsis
+--------
 
-int open(const char *deviceName, int flags);
+.. c:function:: int open(const char *deviceName, int flags)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -46,7 +49,7 @@ PARAMETERS
 
     -  .. row 1
 
-       -  const char *deviceName
+       -  const char \*deviceName
 
        -  Name of demux device.
 
@@ -72,7 +75,8 @@ PARAMETERS
        -  (blocking mode is the default)
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -109,19 +113,22 @@ RETURN VALUE
 
 .. _dmx_fclose:
 
-close()
-=======
+DVB demux close()
+=================
 
-DESCRIPTION
+Description
+-----------
 
 This system call deactivates and deallocates a filter that was
 previously allocated via the open() call.
 
-SYNOPSIS
+Synopsis
+--------
 
-int close(int fd);
+.. c:function:: int close(int fd)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -137,7 +144,8 @@ PARAMETERS
        -  File descriptor returned by a previous call to open().
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -156,21 +164,24 @@ RETURN VALUE
 
 .. _dmx_fread:
 
-read()
-======
+DVB demux read()
+================
 
-DESCRIPTION
+Description
+-----------
 
 This system call returns filtered data, which might be section or PES
 data. The filtered data is transferred from the driver’s internal
 circular buffer to buf. The maximum amount of data to be transferred is
 implied by count.
 
-SYNOPSIS
+Synopsis
+--------
 
-size_t read(int fd, void *buf, size_t count);
+.. c:function:: size_t read(int fd, void *buf, size_t count)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -187,7 +198,7 @@ PARAMETERS
 
     -  .. row 2
 
-       -  void *buf
+       -  void \*buf
 
        -  Pointer to the buffer to be used for returned filtered data.
 
@@ -198,7 +209,8 @@ PARAMETERS
        -  Size of buf.
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -250,16 +262,17 @@ RETURN VALUE
        -  ``EFAULT``
 
        -  The driver failed to write to the callers buffer due to an invalid
-          *buf pointer.
+          \*buf pointer.
 
 
 
 .. _dmx_fwrite:
 
-write()
-=======
+DVB demux write()
+=================
 
-DESCRIPTION
+Description
+-----------
 
 This system call is only provided by the logical device
 /dev/dvb/adapter0/dvr0, associated with the physical demux device that
@@ -268,11 +281,13 @@ digitally recorded Transport Stream. Matching filters have to be defined
 in the corresponding physical demux device, /dev/dvb/adapter0/demux0.
 The amount of data to be transferred is implied by count.
 
-SYNOPSIS
+Synopsis
+--------
 
-ssize_t write(int fd, const void *buf, size_t count);
+.. c:function:: ssize_t write(int fd, const void *buf, size_t count)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -289,7 +304,7 @@ PARAMETERS
 
     -  .. row 2
 
-       -  void *buf
+       -  void \*buf
 
        -  Pointer to the buffer containing the Transport Stream.
 
@@ -300,7 +315,8 @@ PARAMETERS
        -  Size of buf.
 
 
-RETURN VALUE
+Return Value
+------------
 
 
 
@@ -340,16 +356,19 @@ RETURN VALUE
 DMX_START
 =========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call is used to start the actual filtering operation defined
 via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl( int fd, int request = DMX_START);
+.. c:function:: int ioctl( int fd, int request = DMX_START)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -371,7 +390,8 @@ PARAMETERS
        -  Equals DMX_START for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -407,17 +427,20 @@ appropriately. The generic error codes are described at the
 DMX_STOP
 ========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call is used to stop the actual filtering operation defined
 via the ioctl calls DMX_SET_FILTER or DMX_SET_PES_FILTER and
 started via the DMX_START command.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl( int fd, int request = DMX_STOP);
+.. c:function:: int ioctl( int fd, int request = DMX_STOP)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -439,7 +462,8 @@ PARAMETERS
        -  Equals DMX_STOP for this command.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -451,7 +475,8 @@ appropriately. The generic error codes are described at the
 DMX_SET_FILTER
 ==============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call sets up a filter according to the filter and mask
 parameters provided. A timeout may be defined stating number of seconds
@@ -464,12 +489,13 @@ operation should be started immediately (without waiting for a
 DMX_START ioctl call). If a filter was previously set-up, this filter
 will be canceled, and the receive buffer will be flushed.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl( int fd, int request = DMX_SET_FILTER, struct
-dmx_sct_filter_params *params);
+.. c:function:: int ioctl( int fd, int request = DMX_SET_FILTER, struct dmx_sct_filter_params *params)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -492,12 +518,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct dmx_sct_filter_params *params
+       -  struct dmx_sct_filter_params \*params
 
        -  Pointer to structure containing filter parameters.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -509,19 +536,21 @@ appropriately. The generic error codes are described at the
 DMX_SET_PES_FILTER
 ==================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call sets up a PES filter according to the parameters
 provided. By a PES filter is meant a filter that is based just on the
 packet identifier (PID), i.e. no PES header or payload filtering
 capability is supported.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct
-dmx_pes_filter_params *params);
+.. c:function:: int ioctl( int fd, int request = DMX_SET_PES_FILTER, struct dmx_pes_filter_params *params)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -544,12 +573,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct dmx_pes_filter_params *params
+       -  struct dmx_pes_filter_params \*params
 
        -  Pointer to structure containing filter parameters.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -578,19 +608,21 @@ appropriately. The generic error codes are described at the
 DMX_SET_BUFFER_SIZE
 ===================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call is used to set the size of the circular buffer used for
 filtered data. The default size is two maximum sized sections, i.e. if
-this function is not called a buffer size of 2 * 4096 bytes will be
+this function is not called a buffer size of 2 \* 4096 bytes will be
 used.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long
-size);
+.. c:function:: int ioctl( int fd, int request = DMX_SET_BUFFER_SIZE, unsigned long size)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -618,7 +650,8 @@ PARAMETERS
        -  Size of circular buffer.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -630,7 +663,8 @@ appropriately. The generic error codes are described at the
 DMX_GET_EVENT
 =============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call returns an event if available. If an event is not
 available, the behavior depends on whether the device is in blocking or
@@ -638,12 +672,13 @@ non-blocking mode. In the latter case, the call fails immediately with
 errno set to ``EWOULDBLOCK``. In the former case, the call blocks until an
 event becomes available.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event
-*ev);
+.. c:function:: int ioctl( int fd, int request = DMX_GET_EVENT, struct dmx_event *ev)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -666,12 +701,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct dmx_event *ev
+       -  struct dmx_event \*ev
 
        -  Pointer to the location where the event is to be stored.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -697,7 +733,8 @@ appropriately. The generic error codes are described at the
 DMX_GET_STC
 ===========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call returns the current value of the system time counter
 (which is driven by a PES filter of type DMX_PES_PCR). Some hardware
@@ -706,11 +743,13 @@ num field of stc before the ioctl (range 0...n). The result is returned
 in form of a ratio with a 64 bit numerator and a 32 bit denominator, so
 the real 90kHz STC value is stc->stc / stc->base .
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc);
+.. c:function:: int ioctl( int fd, int request = DMX_GET_STC, struct dmx_stc *stc)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -733,12 +772,13 @@ PARAMETERS
 
     -  .. row 3
 
-       -  struct dmx_stc *stc
+       -  struct dmx_stc \*stc
 
        -  Pointer to the location where the stc is to be stored.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -764,15 +804,18 @@ appropriately. The generic error codes are described at the
 DMX_GET_PES_PIDS
 ================
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5]);
+.. c:function:: int ioctl(fd, int request = DMX_GET_PES_PIDS, __u16[5])
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -800,7 +843,8 @@ PARAMETERS
        -  Undocumented.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -812,15 +856,18 @@ appropriately. The generic error codes are described at the
 DMX_GET_CAPS
 ============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *);
+.. c:function:: int ioctl(fd, int request = DMX_GET_CAPS, dmx_caps_t *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -848,7 +895,8 @@ PARAMETERS
        -  Undocumented.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -860,15 +908,18 @@ appropriately. The generic error codes are described at the
 DMX_SET_SOURCE
 ==============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl is undocumented. Documentation is welcome.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *);
+.. c:function:: int ioctl(fd, int request = DMX_SET_SOURCE, dmx_source_t *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -896,7 +947,8 @@ PARAMETERS
        -  Undocumented.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -908,17 +960,20 @@ appropriately. The generic error codes are described at the
 DMX_ADD_PID
 ===========
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call allows to add multiple PIDs to a transport stream filter
 previously set up with DMX_SET_PES_FILTER and output equal to
 DMX_OUT_TSDEMUX_TAP.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = DMX_ADD_PID, __u16 *);
+.. c:function:: int ioctl(fd, int request = DMX_ADD_PID, __u16 *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -946,7 +1001,8 @@ PARAMETERS
        -  PID number to be filtered.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
@@ -958,18 +1014,21 @@ appropriately. The generic error codes are described at the
 DMX_REMOVE_PID
 ==============
 
-DESCRIPTION
+Description
+-----------
 
 This ioctl call allows to remove a PID when multiple PIDs are set on a
 transport stream filter, e. g. a filter previously set up with output
 equal to DMX_OUT_TSDEMUX_TAP, created via either
 DMX_SET_PES_FILTER or DMX_ADD_PID.
 
-SYNOPSIS
+Synopsis
+--------
 
-int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *);
+.. c:function:: int ioctl(fd, int request = DMX_REMOVE_PID, __u16 *)
 
-PARAMETERS
+Arguments
+----------
 
 
 
@@ -997,7 +1056,8 @@ PARAMETERS
        -  PID of the PES filter to be removed.
 
 
-RETURN VALUE
+Return Value
+------------
 
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
-- 
2.7.4

