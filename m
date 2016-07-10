Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60608 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887AbcGJKsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 06:48:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 4/6] [media] doc-rst: improve LIRC syscall documentation
Date: Sun, 10 Jul 2016 07:47:43 -0300
Message-Id: <1e75405ea3b72b10186d3235d6136203d19cf68b.1468147615.git.mchehab@s-opensource.com>
In-Reply-To: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
References: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
In-Reply-To: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
References: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc syscall documentation uses a very different and
simplified way than the rest of the media book. make it
closer. Still, there's just one page for all ioctls.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc_ioctl.rst | 187 +++++++++++++++++++++++------
 Documentation/media/uapi/rc/lirc_read.rst  |  49 +++++++-
 Documentation/media/uapi/rc/lirc_write.rst |  50 +++++++-
 3 files changed, 240 insertions(+), 46 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index 916d064476f1..c4c34db61a96 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -2,9 +2,35 @@
 
 .. _lirc_ioctl:
 
-**************
-LIRC ioctl fop
-**************
+************
+LIRC ioctl()
+************
+
+
+Name
+====
+
+LIRC ioctl - Sends a I/O control command to a LIRC device
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, struct v4l2_capability *argp )
+
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by ``open()``.
+
+``request``
+    The type of I/O control that will be used. See table :ref:`lirc-request`
+    for details.
+
+``argp``
+    Arguments for the I/O control. They're specific to each request.
+
 
 The LIRC device's ioctl definition is bound by the ioctl function
 definition of struct file_operations, leaving us with an unsigned int
@@ -12,45 +38,79 @@ for the ioctl command and an unsigned long for the arg. For the purposes
 of ioctl portability across 32-bit and 64-bit, these values are capped
 to their 32-bit sizes.
 
-The following ioctls can be used to change specific hardware settings.
+The ioctls can be used to change specific hardware settings.
 In general each driver should have a default set of settings. The driver
 implementation is expected to re-apply the default settings when the
 device is closed by user-space, so that every application opening the
 device can rely on working with the default settings initially.
 
-LIRC_GET_FEATURES
+.. _lirc-request:
+
+I/O control requests
+====================
+
+
+.. _LIRC_GET_FEATURES:
+
+``LIRC_GET_FEATURES``
+
     Obviously, get the underlying hardware device's features. If a
     driver does not announce support of certain features, calling of the
     corresponding ioctls is undefined.
 
-LIRC_GET_SEND_MODE
-    Get supported transmit mode. Only LIRC_MODE_PULSE is supported by
+.. _LIRC_GET_SEND_MODE:
+
+``LIRC_GET_SEND_MODE``
+
+    Get supported transmit mode. Only ``LIRC_MODE_PULSE`` is supported by
     lircd.
 
-LIRC_GET_REC_MODE
-    Get supported receive modes. Only LIRC_MODE_MODE2 and
-    LIRC_MODE_LIRCCODE are supported by lircd.
+.. _LIRC_GET_REC_MODE:
+
+``LIRC_GET_REC_MODE``
+
+    Get supported receive modes. Only ``LIRC_MODE_MODE2`` and
+    ``LIRC_MODE_LIRCCODE`` are supported by lircd.
+
+.. _LIRC_GET_SEND_CARRIER:
+
+``LIRC_GET_SEND_CARRIER``
 
-LIRC_GET_SEND_CARRIER
     Get carrier frequency (in Hz) currently used for transmit.
 
-LIRC_GET_REC_CARRIER
+.. _LIRC_GET_REC_CARRIER:
+
+``LIRC_GET_REC_CARRIER``
+
     Get carrier frequency (in Hz) currently used for IR reception.
 
-LIRC_{G,S}ET_{SEND,REC}_DUTY_CYCLE
+.. _LIRC_GET_SEND_DUTY_CYCLE:
+.. _LIRC_GET_REC_DUTY_CYCLE:
+.. _LIRC_SET_SEND_DUTY_CYCLE:
+.. _LIRC_SET_REC_DUTY_CYCLE:
+
+``LIRC_{G,S}ET_{SEND,REC}_DUTY_CYCLE``
+
     Get/set the duty cycle (from 0 to 100) of the carrier signal.
     Currently, no special meaning is defined for 0 or 100, but this
     could be used to switch off carrier generation in the future, so
     these values should be reserved.
 
-LIRC_GET_REC_RESOLUTION
+.. _LIRC_GET_REC_RESOLUTION:
+
+``LIRC_GET_REC_RESOLUTION``
+
     Some receiver have maximum resolution which is defined by internal
     sample rate or data format limitations. E.g. it's common that
     signals can only be reported in 50 microsecond steps. This integer
     value is used by lircd to automatically adjust the aeps tolerance
     value in the lircd config file.
 
-LIRC_GET_M{IN,AX}_TIMEOUT
+.. _LIRC_GET_MIN_TIMEOUT:
+.. _LIRC_GET_MAX_TIMEOUT:
+
+``LIRC_GET_M{IN,AX}_TIMEOUT``
+
     Some devices have internal timers that can be used to detect when
     there's no IR activity for a long time. This can help lircd in
     detecting that a IR signal is finished and can speed up the decoding
@@ -59,7 +119,13 @@ LIRC_GET_M{IN,AX}_TIMEOUT
     both ioctls will return the same value even though the timeout
     cannot be changed.
 
-LIRC_GET_M{IN,AX}_FILTER_{PULSE,SPACE}
+.. _LIRC_GET_MIN_FILTER_PULSE:
+.. _LIRC_GET_MIN_FILTER_PULSE:
+.. _LIRC_GET_MAX_FILTER_SPACE:
+.. _LIRC_GET_MAX_FILTER_SPACE:
+
+``LIRC_GET_M{IN,AX}_FILTER_{PULSE,SPACE}``
+
     Some devices are able to filter out spikes in the incoming signal
     using given filter rules. These ioctls return the hardware
     capabilities that describe the bounds of the possible filters.
@@ -67,72 +133,113 @@ LIRC_GET_M{IN,AX}_FILTER_{PULSE,SPACE}
     derives the settings from all protocols definitions found in its
     config file.
 
-LIRC_GET_LENGTH
-    Retrieves the code length in bits (only for LIRC_MODE_LIRCCODE).
+.. _LIRC_GET_LENGTH:
+
+``LIRC_GET_LENGTH``
+
+    Retrieves the code length in bits (only for ``LIRC_MODE_LIRCCODE).``
     Reads on the device must be done in blocks matching the bit count.
     The bit could should be rounded up so that it matches full bytes.
 
-LIRC_SET_{SEND,REC}_MODE
+.. _LIRC_SET_SEND_MODE:
+.. _LIRC_SET_REC_MODE:
+
+``LIRC_SET_{SEND,REC}_MODE``
+
     Set send/receive mode. Largely obsolete for send, as only
-    LIRC_MODE_PULSE is supported.
+    ``LIRC_MODE_PULSE`` is supported.
+
+.. _LIRC_SET_SEND_CARRIER:
+.. _LIRC_SET_REC_CARRIER:
+
+``LIRC_SET_{SEND,REC}_CARRIER``
 
-LIRC_SET_{SEND,REC}_CARRIER
     Set send/receive carrier (in Hz).
 
-LIRC_SET_TRANSMITTER_MASK
+.. _LIRC_SET_TRANSMITTER_MASK:
+
+``LIRC_SET_TRANSMITTER_MASK``
+
     This enables the given set of transmitters. The first transmitter is
     encoded by the least significant bit, etc. When an invalid bit mask
     is given, i.e. a bit is set, even though the device does not have so
     many transitters, then this ioctl returns the number of available
     transitters and does nothing otherwise.
 
-LIRC_SET_REC_TIMEOUT
+.. _LIRC_SET_REC_TIMEOUT:
+
+``LIRC_SET_REC_TIMEOUT``
+
     Sets the integer value for IR inactivity timeout (cf.
-    LIRC_GET_MIN_TIMEOUT and LIRC_GET_MAX_TIMEOUT). A value of 0
+    ``LIRC_GET_MIN_TIMEOUT`` and ``LIRC_GET_MAX_TIMEOUT).`` A value of 0
     (if supported by the hardware) disables all hardware timeouts and
     data should be reported as soon as possible. If the exact value
     cannot be set, then the next possible value _greater_ than the
     given value should be set.
 
-LIRC_SET_REC_TIMEOUT_REPORTS
-    Enable (1) or disable (0) timeout reports in LIRC_MODE_MODE2. By
+.. _LIRC_SET_REC_TIMEOUT_REPORTS:
+
+``LIRC_SET_REC_TIMEOUT_REPORTS``
+
+    Enable (1) or disable (0) timeout reports in ``LIRC_MODE_MODE2.`` By
     default, timeout reports should be turned off.
 
-LIRC_SET_REC_FILTER_{,PULSE,SPACE}
+.. _LIRC_SET_REC_FILTER_PULSE:
+.. _LIRC_SET_REC_FILTER_SPACE:
+
+``LIRC_SET_REC_FILTER_{PULSE,SPACE}``
+
     Pulses/spaces shorter than this are filtered out by hardware. If
     filters cannot be set independently for pulse/space, the
-    corresponding ioctls must return an error and LIRC_SET_REC_FILTER
+    corresponding ioctls must return an error and ``LIRC_SET_REC_FILTER``
     shall be used instead.
 
-LIRC_SET_MEASURE_CARRIER_MODE
+.. _LIRC_SET_MEASURE_CARRIER_MODE:
+
+``LIRC_SET_MEASURE_CARRIER_MODE``
+
     Enable (1)/disable (0) measure mode. If enabled, from the next key
-    press on, the driver will send LIRC_MODE2_FREQUENCY packets. By
+    press on, the driver will send ``LIRC_MODE2_FREQUENCY`` packets. By
     default this should be turned off.
 
-LIRC_SET_REC_{DUTY_CYCLE,CARRIER}_RANGE
+.. _LIRC_SET_REC_DUTY_CYCLE_RANGE:
+.. _LIRC_SET_REC_CARRIER_RANGE:
+
+``LIRC_SET_REC_{DUTY_CYCLE,CARRIER}_RANGE``
+
     To set a range use
-    LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE
+    ``LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE``
     with the lower bound first and later
-    LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER with the upper
+    ``LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER`` with the upper
     bound.
 
-LIRC_NOTIFY_DECODE
+.. _LIRC_NOTIFY_DECODE:
+
+``LIRC_NOTIFY_DECODE``
+
     This ioctl is called by lircd whenever a successful decoding of an
     incoming IR signal could be done. This can be used by supporting
     hardware to give visual feedback to the user e.g. by flashing a LED.
 
-LIRC_SETUP_{START,END}
+.. _LIRC_SETUP_START:
+.. _LIRC_SETUP_END:
+
+``LIRC_SETUP_{START,END}``
+
     Setting of several driver parameters can be optimized by
     encapsulating the according ioctl calls with
-    LIRC_SETUP_START/LIRC_SETUP_END. When a driver receives a
-    LIRC_SETUP_START ioctl it can choose to not commit further setting
-    changes to the hardware until a LIRC_SETUP_END is received. But
+    ``LIRC_SETUP_START/LIRC_SETUP_END.`` When a driver receives a
+    ``LIRC_SETUP_START`` ioctl it can choose to not commit further setting
+    changes to the hardware until a ``LIRC_SETUP_END`` is received. But
     this is open to the driver implementation and every driver must also
     handle parameter changes which are not encapsulated by
-    LIRC_SETUP_START and LIRC_SETUP_END. Drivers can also choose to
+    ``LIRC_SETUP_START`` and ``LIRC_SETUP_END.`` Drivers can also choose to
     ignore these ioctls.
 
-LIRC_SET_WIDEBAND_RECEIVER
+.. _LIRC_SET_WIDEBAND_RECEIVER:
+
+``LIRC_SET_WIDEBAND_RECEIVER``
+
     Some receivers are equipped with special wide band receiver which is
     intended to be used to learn output of existing remote. Calling that
     ioctl with (1) will enable it, and with (0) disable it. This might
diff --git a/Documentation/media/uapi/rc/lirc_read.rst b/Documentation/media/uapi/rc/lirc_read.rst
index b0b76c3d1d9a..37f164f7526a 100644
--- a/Documentation/media/uapi/rc/lirc_read.rst
+++ b/Documentation/media/uapi/rc/lirc_read.rst
@@ -2,9 +2,44 @@
 
 .. _lirc_read:
 
-*************
-LIRC read fop
-*************
+***********
+LIRC read()
+***********
+
+Name
+====
+
+lirc-read - Read from a LIRC device
+
+
+Synopsis
+========
+
+.. code-block:: c
+
+    #include <unistd.h>
+
+
+.. cpp:function:: ssize_t read( int fd, void *buf, size_t count )
+
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by ``open()``.
+
+``buf``
+``count``
+
+
+Description
+===========
+
+:ref:`read() <lirc-read>` attempts to read up to ``count`` bytes from file
+descriptor ``fd`` into the buffer starting at ``buf``.  If ``count`` is zero,
+:ref:`read() <lirc-read>` returns zero and has no other results. If ``count``
+is greater than ``SSIZE_MAX``, the result is unspecified.
 
 The lircd userspace daemon reads raw IR data from the LIRC chardev. The
 exact format of the data depends on what modes a driver supports, and
@@ -17,3 +52,11 @@ chardev.
 See also
 `http://www.lirc.org/html/technical.html <http://www.lirc.org/html/technical.html>`__
 for more info.
+
+Return Value
+============
+
+On success, the number of bytes read is returned. It is not an error if
+this number is smaller than the number of bytes requested, or the amount
+of data required for one frame.  On error, -1 is returned, and the ``errno``
+variable is set appropriately.
diff --git a/Documentation/media/uapi/rc/lirc_write.rst b/Documentation/media/uapi/rc/lirc_write.rst
index d19cb486ecc9..e27bda30afcc 100644
--- a/Documentation/media/uapi/rc/lirc_write.rst
+++ b/Documentation/media/uapi/rc/lirc_write.rst
@@ -2,9 +2,43 @@
 
 .. _lirc_write:
 
-**************
-LIRC write fop
-**************
+************
+LIRC write()
+************
+
+Name
+====
+
+lirc-write - Write to a LIRC device
+
+
+Synopsis
+========
+
+.. code-block:: c
+
+    #include <unistd.h>
+
+
+.. cpp:function:: ssize_t write( int fd, void *buf, size_t count )
+
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by ``open()``.
+
+``buf``
+``count``
+
+
+Description
+===========
+
+:ref:`write() <func-write>` writes up to ``count`` bytes to the device
+referenced by the file descriptor ``fd`` from the buffer starting at
+``buf``.
 
 The data written to the chardev is a pulse/space sequence of integer
 values. Pulses and spaces are only marked implicitly by their position.
@@ -12,3 +46,13 @@ The data must start and end with a pulse, therefore, the data must
 always include an uneven number of samples. The write function must
 block until the data has been transmitted by the hardware. If more data
 is provided than the hardware can send, the driver returns ``EINVAL``.
+
+
+Return Value
+============
+
+On success, the number of bytes read is returned. It is not an error if
+this number is smaller than the number of bytes requested, or the amount
+of data required for one frame.  On error, -1 is returned, and the ``errno``
+variable is set appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
-- 
2.7.4

