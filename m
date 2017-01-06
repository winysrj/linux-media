Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:58605 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033701AbdAFMte (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jan 2017 07:49:34 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 9/9] [media] lirc: LIRC_MODE_SCANCODE documentation
Date: Fri,  6 Jan 2017 12:49:12 +0000
Message-Id: <77561b43d51e6146bab5aafc5cb8ff2e8316ebd1.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the interface we've just implemented.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-dev-intro.rst    | 21 +++++++++++++++++----
 Documentation/media/uapi/rc/lirc-get-features.rst | 14 ++++++++++++++
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index ef97e40..a0b3794 100644
--- a/Documentation/media/uapi/rc/lirc-dev-intro.rst
+++ b/Documentation/media/uapi/rc/lirc-dev-intro.rst
@@ -42,15 +42,28 @@ on the following table.
 
     This mode is used only for IR receive.
 
+.. _lirc-mode-scancode:
+
+``LIRC_MODE_SCANCODE``
+
+    For receiving, the IR signal is decoded internally by the receiver or
+    in the kernel IR decoders. A struct lirc_scancode is returned. The
+    flags will specify the message was a repeat ``LIRC_SCANCODE_FLAG_REPEAT``
+    or the toggle was set ``LIRC_SCANCODE_FLAG_TOGGLE``.
+
+    When using from transmit, either the IR hardware encodes the signal,
+    or the in-kernel encoders. The flags parameter must be 0.
+
+    The ``scancode`` member contains the scancode received or to be sent,
+    and ``rc_type`` the protocol.
+
 .. _lirc-mode-lirccode:
 
 ``LIRC_MODE_LIRCCODE``
 
     The IR signal is decoded internally by the receiver. The LIRC interface
-    returns the scancode as an integer value. This is the usual mode used
-    by several TV media cards.
-
-    This mode is used only for IR receive.
+    returns the scancode as an integer value. This is a method used by
+    some lirc staging drivers.
 
 .. _lirc-mode-pulse:
 
diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index 79e07b4..477c622 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -58,6 +58,13 @@ LIRC features
     The driver is capable of receiving using
     :ref:`LIRC_MODE_MODE2 <lirc-mode-MODE2>`.
 
+.. _LIRC-CAN-REC-SCANCODE:
+
+``LIRC_CAN_REC_SCANCODE``
+
+    The driver is capable of receiving using
+    :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>`.
+
 .. _LIRC-CAN-REC-LIRCCODE:
 
 ``LIRC_CAN_REC_LIRCCODE``
@@ -164,6 +171,13 @@ LIRC features
 
     The driver supports sending using :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`.
 
+.. _LIRC-CAN-SEND-SCANCODE:
+
+``LIRC_CAN_SEND_SCANCODE``
+
+    The driver supports sending using
+    :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>`.
+
 .. _LIRC-CAN-SEND-LIRCCODE:
 
 ``LIRC_CAN_SEND_LIRCCODE``
-- 
2.9.3

