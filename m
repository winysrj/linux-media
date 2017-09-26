Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:42593 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965980AbdIZUOI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:14:08 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 20/20] media: lirc: document LIRC_MODE_SCANCODE
Date: Tue, 26 Sep 2017 21:13:59 +0100
Message-Id: <873c209c7c3a81b2be76760262aeeef82109af3a.1506455086.git.sean@mess.org>
In-Reply-To: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
References: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
In-Reply-To: <cover.1506455086.git.sean@mess.org>
References: <cover.1506455086.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lirc supports a new mode which requires documentation.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/lirc.h.rst.exceptions          | 49 ++++++++++++++++++++++
 Documentation/media/uapi/rc/lirc-dev-intro.rst     | 25 +++++++++++
 Documentation/media/uapi/rc/lirc-get-features.rst  | 16 +++++++
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |  6 ++-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |  4 +-
 Documentation/media/uapi/rc/lirc-read.rst          |  6 +++
 Documentation/media/uapi/rc/lirc-write.rst         |  8 ++++
 7 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index c130617a9986..d86f5df12f75 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -28,6 +28,55 @@ ignore define LIRC_CAN_SEND_MASK
 ignore define LIRC_CAN_REC_MASK
 ignore define LIRC_CAN_SET_REC_DUTY_CYCLE
 
+# rc protocols
+
+ignore symbol RC_PROTO_UNKNOWN
+ignore symbol RC_PROTO_OTHER
+ignore symbol RC_PROTO_RC5
+ignore symbol RC_PROTO_RC5X_20
+ignore symbol RC_PROTO_RC5_SZ
+ignore symbol RC_PROTO_JVC
+ignore symbol RC_PROTO_SONY12
+ignore symbol RC_PROTO_SONY15
+ignore symbol RC_PROTO_SONY20
+ignore symbol RC_PROTO_NEC
+ignore symbol RC_PROTO_NECX
+ignore symbol RC_PROTO_NEC32
+ignore symbol RC_PROTO_SANYO
+ignore symbol RC_PROTO_MCIR2_KBD
+ignore symbol RC_PROTO_MCIR2_MSE
+ignore symbol RC_PROTO_RC6_0
+ignore symbol RC_PROTO_RC6_6A_20
+ignore symbol RC_PROTO_RC6_6A_24
+ignore symbol RC_PROTO_RC6_6A_32
+ignore symbol RC_PROTO_RC6_MCE
+ignore symbol RC_PROTO_SHARP
+ignore symbol RC_PROTO_XMP
+ignore symbol RC_PROTO_CEC
+ignore symbol RC_PROTO_UNKNOWN
+ignore symbol RC_PROTO_OTHER
+ignore symbol RC_PROTO_RC5
+ignore symbol RC_PROTO_RC5X_20
+ignore symbol RC_PROTO_RC5_SZ
+ignore symbol RC_PROTO_JVC
+ignore symbol RC_PROTO_SONY12
+ignore symbol RC_PROTO_SONY15
+ignore symbol RC_PROTO_SONY20
+ignore symbol RC_PROTO_NEC
+ignore symbol RC_PROTO_NECX
+ignore symbol RC_PROTO_NEC32
+ignore symbol RC_PROTO_SANYO
+ignore symbol RC_PROTO_MCIR2_KBD
+ignore symbol RC_PROTO_MCIR2_MSE
+ignore symbol RC_PROTO_RC6_0
+ignore symbol RC_PROTO_RC6_6A_20
+ignore symbol RC_PROTO_RC6_6A_24
+ignore symbol RC_PROTO_RC6_6A_32
+ignore symbol RC_PROTO_RC6_MCE
+ignore symbol RC_PROTO_SHARP
+ignore symbol RC_PROTO_XMP
+ignore symbol RC_PROTO_CEC
+
 # Undocumented macros
 
 ignore define PULSE_BIT
diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index a3fa3c1ef169..bf05cf6985df 100644
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
+    the desired scancode set in the ``scancode`` member, ``rc_proto`` set
+    the IR protocol, and ``flags`` set to 0. Write this to the lirc device.
+
+    For receiving, you read ``struct lirc_scancode`` from the lirc device,
+    with ``scancode`` set to the received scancode in the IR protocol
+    ``rc_proto``. The ``flags`` can have ``LIRC_SCANCODE_FLAG_TOGGLE`` set
+    if the toggle bit is set in protocols that support it (e.g. rc-5 and rc-6),
+    or ``LIRC_SCANCODE_FLAG_REPEAT`` for when a repeat is received for protocols
+    that support it (e.g. nec).
+
+    The ``timestamp`` field is filled with the time nanoseconds
+    (in ``CLOCK_MONOTONIC``) when the scancode was decoded.
+
+    An ``enum rc_proto`` in the :ref:`lirc_header` lists all the supported
+    IR protocols.
+
 .. _lirc-mode-mode2:
 
 ``LIRC_MODE_MODE2``
diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index 50c2c26d8e89..3ee44067de63 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -64,6 +64,14 @@ LIRC features
 
     Unused. Kept just to avoid breaking uAPI.
 
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
@@ -171,6 +179,14 @@ LIRC features
 
     Unused. Kept just to avoid breaking uAPI.
 
+.. _LIRC-CAN-SEND-SCANCODE:
+
+``LIRC_CAN_SEND_SCANCODE``
+
+    The driver supports sending (also called as IR blasting or IR TX) using
+    :ref:`LIRC_MODE_SCANCODE <lirc-mode-SCANCODE>`.
+
+
 Return Value
 ============
 
diff --git a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
index b89de9add921..221f093db125 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -33,8 +33,10 @@ Arguments
 Description
 ===========
 
-Get/set supported receive modes. Only :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`
-is supported for IR receive.
+Get/set supported receive modes. Only :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`,
+:ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` and
+:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` are supported for IR
+Use :ref:`lirc_get_features` to find out which modes the driver supports.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index e686b21689a0..be0992ebd6f9 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -36,7 +36,9 @@ Description
 
 Get/set current transmit mode.
 
-Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` is supported by for IR send,
+Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`,
+:ref:`LIRC_MODE_LIRCCODE <lirc-mode-lirccode>` and
+:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` is supported by for IR send,
 depending on the driver. Use :ref:`lirc_get_features` to find out which
 modes the driver supports.
 
diff --git a/Documentation/media/uapi/rc/lirc-read.rst b/Documentation/media/uapi/rc/lirc-read.rst
index ff14a69104e5..2577c5aeec6b 100644
--- a/Documentation/media/uapi/rc/lirc-read.rst
+++ b/Documentation/media/uapi/rc/lirc-read.rst
@@ -52,6 +52,12 @@ The generally preferred mode for receive is
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
index 2aad0fef4a5b..fba5ecb811ac 100644
--- a/Documentation/media/uapi/rc/lirc-write.rst
+++ b/Documentation/media/uapi/rc/lirc-write.rst
@@ -53,6 +53,14 @@ samples. The write function must block until the data has been transmitted
 by the hardware. If more data is provided than the hardware can send, the
 driver returns ``EINVAL``.
 
+When in :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` mode, one
+``struct lirc_scancode`` must be written to the chardev. The ``flags``
+and ``timestamp`` members must be 0, and ``rc_proto`` must be set to a
+valid protocol. Set the desired scancode in the ``scancode`` member. If
+there is no protocol encoder for the protocol or the scancode is not
+valid for the specified protocol, ``EINVAL`` is returned.
+
+
 Return Value
 ============
 
-- 
2.13.5
