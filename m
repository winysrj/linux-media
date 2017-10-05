Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60999 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751419AbdJEIpk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 04:45:40 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 20/25] media: lirc: document LIRC_MODE_SCANCODE
Date: Thu,  5 Oct 2017 09:45:22 +0100
Message-Id: <7fbf36ca8c052b1eae866859127e65038f223023.1507192752.git.sean@mess.org>
In-Reply-To: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
In-Reply-To: <cover.1507192751.git.sean@mess.org>
References: <cover.1507192751.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lirc supports a new mode which requires documentation.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/lirc.h.rst.exceptions          | 26 ++++++++++++++++++++++
 Documentation/media/uapi/rc/lirc-dev-intro.rst     | 26 ++++++++++++++++++++++
 Documentation/media/uapi/rc/lirc-get-features.rst  | 16 +++++++++++++
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |  5 +++--
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |  3 ++-
 Documentation/media/uapi/rc/lirc-read.rst          | 14 ++++++++----
 Documentation/media/uapi/rc/lirc-write.rst         | 16 ++++++++++---
 7 files changed, 96 insertions(+), 10 deletions(-)

diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index 63ba1d341905..c6e3a35d2c4e 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -32,6 +32,32 @@ ignore define LIRC_CAN_SET_REC_DUTY_CYCLE
 
 ignore ioctl LIRC_GET_LENGTH
 
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
+
 # Undocumented macros
 
 ignore define PULSE_BIT
diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index a3fa3c1ef169..70c82b2879ff 100644
--- a/Documentation/media/uapi/rc/lirc-dev-intro.rst
+++ b/Documentation/media/uapi/rc/lirc-dev-intro.rst
@@ -36,6 +36,32 @@ LIRC modes
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
+    the IR protocol, and all other members set to 0. Write this struct to
+    the lirc device.
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
index b89de9add921..92c543e1815e 100644
--- a/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-rec-mode.rst
@@ -33,8 +33,9 @@ Arguments
 Description
 ===========
 
-Get/set supported receive modes. Only :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`
-is supported for IR receive.
+Get/set supported receive modes. Only :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`,
+:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` are supported.
+Use :ref:`lirc_get_features` to find out which modes the driver supports.
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/rc/lirc-get-send-mode.rst b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
index e686b21689a0..c3c830f9b08e 100644
--- a/Documentation/media/uapi/rc/lirc-get-send-mode.rst
+++ b/Documentation/media/uapi/rc/lirc-get-send-mode.rst
@@ -36,7 +36,8 @@ Description
 
 Get/set current transmit mode.
 
-Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>` is supported by for IR send,
+Only :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`,
+:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` is supported by for IR send,
 depending on the driver. Use :ref:`lirc_get_features` to find out which
 modes the driver supports.
 
diff --git a/Documentation/media/uapi/rc/lirc-read.rst b/Documentation/media/uapi/rc/lirc-read.rst
index ff14a69104e5..cb868ac9fa95 100644
--- a/Documentation/media/uapi/rc/lirc-read.rst
+++ b/Documentation/media/uapi/rc/lirc-read.rst
@@ -45,13 +45,19 @@ descriptor ``fd`` into the buffer starting at ``buf``.  If ``count`` is zero,
 is greater than ``SSIZE_MAX``, the result is unspecified.
 
 The exact format of the data depends on what :ref:`lirc_modes` a driver
-uses. Use :ref:`lirc_get_features` to get the supported mode.
+uses. Use :ref:`lirc_get_features` to get the supported mode, and use
+:ref:`lirc_set_rec_mode` set the current active mode.
 
-The generally preferred mode for receive is
-:ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`,
-in which packets containing an int value describing an IR signal are
+The mode :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>` is for raw IR,
+in which packets containing an unsigned int value describing an IR signal are
 read from the chardev.
 
+Alternatively, :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` can be available,
+in this mode scancodes which are either decoded by software decoders, or
+my hardware decoders are available. The ``rc_proto`` member is set to the
+protocol used for transmission, and ``scancode`` to the decoded scancode.
+
+
 Return Value
 ============
 
diff --git a/Documentation/media/uapi/rc/lirc-write.rst b/Documentation/media/uapi/rc/lirc-write.rst
index 2aad0fef4a5b..b28c268739bb 100644
--- a/Documentation/media/uapi/rc/lirc-write.rst
+++ b/Documentation/media/uapi/rc/lirc-write.rst
@@ -42,17 +42,27 @@ Description
 referenced by the file descriptor ``fd`` from the buffer starting at
 ``buf``.
 
-The exact format of the data depends on what mode a driver uses, use
-:ref:`lirc_get_features` to get the supported mode.
+The exact format of the data depends on what mode a driver is in, use
+:ref:`lirc_get_features` to get the supported modes and use
+:ref:`lirc_set_send_mode` set to the mode.
 
 When in :ref:`LIRC_MODE_PULSE <lirc-mode-PULSE>` mode, the data written to
 the chardev is a pulse/space sequence of integer values. Pulses and spaces
 are only marked implicitly by their position. The data must start and end
 with a pulse, therefore, the data must always include an uneven number of
-samples. The write function must block until the data has been transmitted
+samples. The write function blocks until the data has been transmitted
 by the hardware. If more data is provided than the hardware can send, the
 driver returns ``EINVAL``.
 
+When in :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` mode, one
+``struct lirc_scancode`` must be written to the chardev.  Set the desired
+scancode in the ``scancode`` member, and the protocol in the ``rc_proto``
+member. All other members must be set to 0. If there is no protocol encoder
+for the protocol or the scancode is not valid for the specified protocol,
+``EINVAL`` is returned. The write function may not wait until the scancode
+is transmitted.
+
+
 Return Value
 ============
 
-- 
2.13.6
