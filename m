Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:57825 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751428AbdBYLwv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 06:52:51 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 19/19] [media] lirc: document LIRC_MODE_SCANCODE
Date: Sat, 25 Feb 2017 11:51:34 +0000
Message-Id: <8b62df1eee63d9b4ef805a70bebabccb0ec27580.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lirc supports a new mode which requires documentation.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/lirc.h.rst.exceptions          | 49 ++++++++++++++++++++++
 Documentation/media/uapi/rc/lirc-dev-intro.rst     | 25 +++++++++++
 Documentation/media/uapi/rc/lirc-get-features.rst  | 15 +++++++
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |  8 ++--
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |  5 ++-
 Documentation/media/uapi/rc/lirc-read.rst          |  6 +++
 Documentation/media/uapi/rc/lirc-write.rst         |  8 ++++
 7 files changed, 110 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index c130617..b29cc8d 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -28,6 +28,55 @@ ignore define LIRC_CAN_SEND_MASK
 ignore define LIRC_CAN_REC_MASK
 ignore define LIRC_CAN_SET_REC_DUTY_CYCLE
 
+# rc protocols
+
+ignore symbol RC_TYPE_UNKNOWN
+ignore symbol RC_TYPE_OTHER
+ignore symbol RC_TYPE_RC5
+ignore symbol RC_TYPE_RC5X_20
+ignore symbol RC_TYPE_RC5_SZ
+ignore symbol RC_TYPE_JVC
+ignore symbol RC_TYPE_SONY12
+ignore symbol RC_TYPE_SONY15
+ignore symbol RC_TYPE_SONY20
+ignore symbol RC_TYPE_NEC
+ignore symbol RC_TYPE_NECX
+ignore symbol RC_TYPE_NEC32
+ignore symbol RC_TYPE_SANYO
+ignore symbol RC_TYPE_MCIR2_KBD
+ignore symbol RC_TYPE_MCIR2_MSE
+ignore symbol RC_TYPE_RC6_0
+ignore symbol RC_TYPE_RC6_6A_20
+ignore symbol RC_TYPE_RC6_6A_24
+ignore symbol RC_TYPE_RC6_6A_32
+ignore symbol RC_TYPE_RC6_MCE
+ignore symbol RC_TYPE_SHARP
+ignore symbol RC_TYPE_XMP
+ignore symbol RC_TYPE_CEC
+ignore symbol RC_TYPE_UNKNOWN
+ignore symbol RC_TYPE_OTHER
+ignore symbol RC_TYPE_RC5
+ignore symbol RC_TYPE_RC5X_20
+ignore symbol RC_TYPE_RC5_SZ
+ignore symbol RC_TYPE_JVC
+ignore symbol RC_TYPE_SONY12
+ignore symbol RC_TYPE_SONY15
+ignore symbol RC_TYPE_SONY20
+ignore symbol RC_TYPE_NEC
+ignore symbol RC_TYPE_NECX
+ignore symbol RC_TYPE_NEC32
+ignore symbol RC_TYPE_SANYO
+ignore symbol RC_TYPE_MCIR2_KBD
+ignore symbol RC_TYPE_MCIR2_MSE
+ignore symbol RC_TYPE_RC6_0
+ignore symbol RC_TYPE_RC6_6A_20
+ignore symbol RC_TYPE_RC6_6A_24
+ignore symbol RC_TYPE_RC6_6A_32
+ignore symbol RC_TYPE_RC6_MCE
+ignore symbol RC_TYPE_SHARP
+ignore symbol RC_TYPE_XMP
+ignore symbol RC_TYPE_CEC
+
 # Undocumented macros
 
 ignore define PULSE_BIT
diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index d1936ee..162fa7c 100644
--- a/Documentation/media/uapi/rc/lirc-dev-intro.rst
+++ b/Documentation/media/uapi/rc/lirc-dev-intro.rst
@@ -36,6 +36,31 @@ LIRC modes
 LIRC supports some modes of receiving and sending IR codes, as shown
 on the following table.
 
+.. _lirc-mode-scancode:
+.. _lirc-scancode-flag-toggle:
+.. _lirc-scancode-flag-repeat:
+
+``LIRC_MODE_SCANCODE``
+
+    This mode is for both sending and receiving IR.
+
+    For transmitting (aka sending), create a ``struct lirc_scancode`` with
+    the desired scancode set in the ``scancode`` member, ``rc_type`` set
+    the IR protocol, and ``flags`` set to 0. Write this to the lirc device.
+
+    For receiving, you read ``struct lirc_scancode`` from the lirc device,
+    with ``scancode`` set to the received scancode in the IR protocol
+    ``rc_type``. The ``flags`` can have ``LIRC_SCANCODE_FLAG_TOGGLE`` set
+    if the toggle bit is set in protocols that support it (e.g. rc-5 and rc-6),
+    or ``LIRC_SCANCODE_FLAG_REPEAT`` for when a repeat is received for protocols
+    that support it (e.g. nec).
+
+    The ``timestamp`` field is filled with the time nanoseconds
+    (in ``CLOCK_MONOTONIC``) when the scancode was decoded.
+
+    An ``enum rc_type`` in the :ref:`lirc_header` lists all the supported
+    IR protocols.
+
 .. _lirc-mode-mode2:
 
 ``LIRC_MODE_MODE2``
diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index 64f89a4..76bc99a 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -65,6 +65,14 @@ LIRC features
     The driver is capable of receiving using
     :ref:`LIRC_MODE_LIRCCODE <lirc-mode-LIRCCODE>`.
 
+.. _LIRC-CAN-REC-SCANCODE:
+
+``LIRC_CAN_REC_SCANCODE``
+
+    The driver is capable of receiving using
+    :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>`.
+
+
 .. _LIRC-CAN-SET-SEND-CARRIER:
 
 ``LIRC_CAN_SET_SEND_CARRIER``
@@ -173,6 +181,13 @@ LIRC features
     The driver supports sending (also called as IR blasting or IR TX) using
     :ref:`LIRC_MODE_LIRCCODE <lirc-mode-LIRCCODE>`.
 
+.. _LIRC-CAN-SEND-SCANCODE:
+
+``LIRC_CAN_SEND_SCANCODE``
+
+    The driver supports sending (also called as IR blasting or IR TX) using
+    :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>`.
+
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
index a4eb6c0..221f093d 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -33,10 +33,10 @@ Arguments
 Description
 ===========
 
-Get/set supported receive modes. Only :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`
-and :ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` are supported for IR
-receive. Use :ref:`lirc_get_features` to find out which modes the driver
-supports.
+Get/set supported receive modes. Only :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`,
+:ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` and
+:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` are supported for IR
+Use :ref:`lirc_get_features` to find out which modes the driver supports.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index a169b23..be0992e 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -36,8 +36,9 @@ Description
 
 Get/set current transmit mode.
 
-Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` and
-:ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` is supported by for IR send,
+Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`,
+:ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` and
+:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` is supported by for IR send,
 depending on the driver. Use :ref:`lirc_get_features` to find out which
 modes the driver supports.
 
diff --git a/Documentation/media/uapi/rc/lirc-read.rst b/Documentation/media/uapi/rc/lirc-read.rst
index ffa2830..b4e5a56 100644
--- a/Documentation/media/uapi/rc/lirc-read.rst
+++ b/Documentation/media/uapi/rc/lirc-read.rst
@@ -54,6 +54,12 @@ The generally preferred mode for receive is
 in which packets containing an int value describing an IR signal are
 read from the chardev.
 
+Alternatively, :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` might be available.
+Some hardware only produces scancodes so this might be the only available mode.
+In this mode, full decoded scancodes read from the chardev with their protocol
+information.
+
+
 Return Value
 ============
 
diff --git a/Documentation/media/uapi/rc/lirc-write.rst b/Documentation/media/uapi/rc/lirc-write.rst
index 6b44e0d..21e4d19 100644
--- a/Documentation/media/uapi/rc/lirc-write.rst
+++ b/Documentation/media/uapi/rc/lirc-write.rst
@@ -55,6 +55,14 @@ samples. The write function must block until the data has been transmitted
 by the hardware. If more data is provided than the hardware can send, the
 driver returns ``EINVAL``.
 
+When in :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` mode, one
+``struct lirc_scancode`` must be written to the chardev. The ``flags``
+and ``timestamp`` members must be 0, and ``rc_type`` must be set to a
+valid protocol. Set the desired scancode in the ``scancode`` member. If
+there is no protocol encoder for the protocol or the scancode is not
+valid for the specified protocol, ``EINVAL`` is returned.
+
+
 Return Value
 ============
 
-- 
2.9.3
