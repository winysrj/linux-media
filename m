Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36377 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751824AbdBYLvp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 06:51:45 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 01/19] [media] lirc: document lirc modes better
Date: Sat, 25 Feb 2017 11:51:16 +0000
Message-Id: <2a4d9cb1bdb00e5a22203952d519eff2861ed889.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LIRC_MODE_MODE2 and LIRC_MODE_LIRCCODE were not covered at all.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/lirc.h.rst.exceptions          |  1 -
 Documentation/media/uapi/rc/lirc-dev-intro.rst     | 53 +++++++++++++++++++---
 Documentation/media/uapi/rc/lirc-get-features.rst  | 13 ++++--
 Documentation/media/uapi/rc/lirc-get-length.rst    |  3 +-
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |  4 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |  7 ++-
 Documentation/media/uapi/rc/lirc-read.rst          | 18 ++++----
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |  2 +-
 .../media/uapi/rc/lirc-set-rec-timeout-reports.rst |  2 +
 Documentation/media/uapi/rc/lirc-write.rst         | 19 +++++---
 10 files changed, 86 insertions(+), 36 deletions(-)

diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index 246c850..c130617 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -35,7 +35,6 @@ ignore define PULSE_MASK
 
 ignore define LIRC_MODE2_SPACE
 ignore define LIRC_MODE2_PULSE
-ignore define LIRC_MODE2_TIMEOUT
 
 ignore define LIRC_VALUE_MASK
 ignore define LIRC_MODE2_MASK
diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index ef97e40..d1936ee 100644
--- a/Documentation/media/uapi/rc/lirc-dev-intro.rst
+++ b/Documentation/media/uapi/rc/lirc-dev-intro.rst
@@ -27,6 +27,8 @@ What you should see for a chardev:
     $ ls -l /dev/lirc*
     crw-rw---- 1 root root 248, 0 Jul 2 22:20 /dev/lirc0
 
+.. _lirc_modes:
+
 **********
 LIRC modes
 **********
@@ -38,25 +40,62 @@ on the following table.
 
 ``LIRC_MODE_MODE2``
 
-    The driver returns a sequence of pulse and space codes to userspace.
+    The driver returns a sequence of pulse and space codes to userspace,
+    as a series of u32 values.
 
     This mode is used only for IR receive.
 
+    The upper 8 bits determine the packet type, and the lower 24 bits
+    the payload. Use ``LIRC_VALUE()`` macro to get the payload, and
+    the macro ``LIRC_MODE2()`` will give you the type, which
+    is one of:
+
+    ``LIRC_MODE2_PULSE``
+
+        Signifies the presence of IR in microseconds.
+
+    ``LIRC_MODE2_SPACE``
+
+        Signifies absence of IR in microseconds.
+
+    ``LIRC_MODE2_FREQUENCY``
+
+        If measurement of the carrier frequency was enabled with
+        :ref:`lirc_set_measure_carrier_mode` then this packet gives you
+        the carrier frequency in Hertz.
+
+    ``LIRC_MODE2_TIMEOUT``
+
+        If timeout reports are enabled with
+        :ref:`lirc_set_rec_timeout_reports`, when the timeout set with
+        :ref:`lirc_set_rec_timeout` expires due to no IR being detected,
+        this packet will be sent, with the number of microseconds with
+        no IR.
+
 .. _lirc-mode-lirccode:
 
 ``LIRC_MODE_LIRCCODE``
 
-    The IR signal is decoded internally by the receiver. The LIRC interface
-    returns the scancode as an integer value. This is the usual mode used
-    by several TV media cards.
+    This mode can be used for IR receive and send.
 
-    This mode is used only for IR receive.
+    The IR signal is decoded internally by the receiver, or encoded by the
+    transmitter. The LIRC interface represents the scancode as byte string,
+    which might not be a u32, it can be any length. The value is entirely
+    driver dependent. This mode is used by some older lirc drivers.
+
+    The length of each code depends on the driver, which can be retrieved
+    with :ref:`lirc_get_length`. This length is used both
+    for transmitting and receiving IR.
 
 .. _lirc-mode-pulse:
 
 ``LIRC_MODE_PULSE``
 
-    On puse mode, a sequence of pulse/space integer values are written to the
-    lirc device using :Ref:`lirc-write`.
+    In pulse mode, a sequence of pulse/space integer values are written to the
+    lirc device using :ref:`lirc-write`.
+
+    The values are alternating pulse and space lengths, in microseconds. The
+    first and last entry must be a pulse, so there must be an odd number
+    of entries.
 
     This mode is used only for IR send.
diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index 79e07b4..64f89a4 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -48,8 +48,8 @@ LIRC features
 
 ``LIRC_CAN_REC_PULSE``
 
-    The driver is capable of receiving using
-    :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`.
+    Unused. Kept just to avoid breaking uAPI.
+    :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` can only be used for transmitting.
 
 .. _LIRC-CAN-REC-MODE2:
 
@@ -156,19 +156,22 @@ LIRC features
 
 ``LIRC_CAN_SEND_PULSE``
 
-    The driver supports sending using :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`.
+    The driver supports sending (also called as IR blasting or IR TX) using
+    :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`.
 
 .. _LIRC-CAN-SEND-MODE2:
 
 ``LIRC_CAN_SEND_MODE2``
 
-    The driver supports sending using :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`.
+    Unused. Kept just to avoid breaking uAPI.
+    :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>` can only be used for receiving.
 
 .. _LIRC-CAN-SEND-LIRCCODE:
 
 ``LIRC_CAN_SEND_LIRCCODE``
 
-    The driver supports sending codes (also called as IR blasting or IR TX).
+    The driver supports sending (also called as IR blasting or IR TX) using
+    :ref:`LIRC_MODE_LIRCCODE <lirc-mode-LIRCCODE>`.
 
 
 Return Value
diff --git a/Documentation/media/uapi/rc/lirc-get-length.rst b/Documentation/media/uapi/rc/lirc-get-length.rst
index 8c2747c..3990af5 100644
--- a/Documentation/media/uapi/rc/lirc-get-length.rst
+++ b/Documentation/media/uapi/rc/lirc-get-length.rst
@@ -30,7 +30,8 @@ Arguments
 Description
 ===========
 
-Retrieves the code length in bits (only for ``LIRC-MODE-LIRCCODE``).
+Retrieves the code length in bits (only for
+:ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>`).
 Reads on the device must be done in blocks matching the bit count.
 The bit could should be rounded up so that it matches full bytes.
 
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
index a5023e0..a4eb6c0 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -35,8 +35,8 @@ Description
 
 Get/set supported receive modes. Only :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`
 and :ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` are supported for IR
-receive.
-
+receive. Use :ref:`lirc_get_features` to find out which modes the driver
+supports.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index 51ac134..a169b23 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -34,9 +34,12 @@ Arguments
 Description
 ===========
 
-Get/set supported transmit mode.
+Get/set current transmit mode.
 
-Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` is supported by for IR send.
+Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` and
+:ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` is supported by for IR send,
+depending on the driver. Use :ref:`lirc_get_features` to find out which
+modes the driver supports.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc-read.rst b/Documentation/media/uapi/rc/lirc-read.rst
index 4c678f6..ffa2830 100644
--- a/Documentation/media/uapi/rc/lirc-read.rst
+++ b/Documentation/media/uapi/rc/lirc-read.rst
@@ -44,17 +44,15 @@ descriptor ``fd`` into the buffer starting at ``buf``.  If ``count`` is zero,
 :ref:`read() <lirc-read>` returns zero and has no other results. If ``count``
 is greater than ``SSIZE_MAX``, the result is unspecified.
 
-The lircd userspace daemon reads raw IR data from the LIRC chardev. The
-exact format of the data depends on what modes a driver supports, and
-what mode has been selected. lircd obtains supported modes and sets the
-active mode via the ioctl interface, detailed at :ref:`lirc_func`.
-The generally preferred mode for receive is
-:ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`, in which packets containing an
-int value describing an IR signal are read from the chardev.
+The exact format of the data depends on what :ref:`lirc_modes` a driver
+supports, and which mode has been selected. Use :ref:`lirc_get_features` to
+get a list of supported modes, and :ref:`lirc_get_rec_mode` to get or set the
+recording mode if multiple modes are available.
 
-See also
-`http://www.lirc.org/html/technical.html <http://www.lirc.org/html/technical.html>`__
-for more info.
+The generally preferred mode for receive is
+:ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`,
+in which packets containing an int value describing an IR signal are
+read from the chardev.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst b/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
index a83fbbf..a892468 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
@@ -9,7 +9,7 @@ ioctl LIRC_SET_REC_CARRIER_RANGE
 Name
 ====
 
-LIRC_SET_REC_CARRIER_RANGE - Set lower bond of the carrier used to modulate
+LIRC_SET_REC_CARRIER_RANGE - Set lower bound of the carrier used to modulate
 IR receive.
 
 Synopsis
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst b/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
index 9c501bb..86353e6 100644
--- a/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
+++ b/Documentation/media/uapi/rc/lirc-set-rec-timeout-reports.rst
@@ -31,6 +31,8 @@ Arguments
 Description
 ===========
 
+.. _lirc-mode2-timeout:
+
 Enable or disable timeout reports for IR receive. By default, timeout reports
 should be turned off.
 
diff --git a/Documentation/media/uapi/rc/lirc-write.rst b/Documentation/media/uapi/rc/lirc-write.rst
index 3b035c6..6b44e0d 100644
--- a/Documentation/media/uapi/rc/lirc-write.rst
+++ b/Documentation/media/uapi/rc/lirc-write.rst
@@ -42,13 +42,18 @@ Description
 referenced by the file descriptor ``fd`` from the buffer starting at
 ``buf``.
 
-The data written to the chardev is a pulse/space sequence of integer
-values. Pulses and spaces are only marked implicitly by their position.
-The data must start and end with a pulse, therefore, the data must
-always include an uneven number of samples. The write function must
-block until the data has been transmitted by the hardware. If more data
-is provided than the hardware can send, the driver returns ``EINVAL``.
-
+The exact format of the data depends on what modes a driver supports,
+and what mode has been selected. Use :ref:`lirc_get_features` to get a
+list of supported modes, and :ref:`lirc_get_send_mode` to get or set
+the sending mode if multiple modes are available.
+
+When in :ref:`LIRC_MODE_PULSE <lirc-mode-PULSE>` mode, the data written to
+the chardev is a pulse/space sequence of integer values. Pulses and spaces
+are only marked implicitly by their position. The data must start and end
+with a pulse, therefore, the data must always include an uneven number of
+samples. The write function must block until the data has been transmitted
+by the hardware. If more data is provided than the hardware can send, the
+driver returns ``EINVAL``.
 
 Return Value
 ============
-- 
2.9.3
