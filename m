Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38743 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752951AbdK3NVB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 08:21:01 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>
Subject: [PATCH 1/2] media: RC docs: add enum rc_proto description at the docs
Date: Thu, 30 Nov 2017 08:20:55 -0500
Message-Id: <44530601e2f49433690aeec1c76e425907ae6842.1512048047.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is part of the uAPI. Add it to the documentation again,
and fix cross-references.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc-dev-intro.rst | 19 +++++++++++++------
 Documentation/media/uapi/rc/lirc-read.rst      |  2 +-
 Documentation/media/uapi/rc/lirc-write.rst     |  4 ++--
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index 47c6c218e72a..3a74fec66d69 100644
--- a/Documentation/media/uapi/rc/lirc-dev-intro.rst
+++ b/Documentation/media/uapi/rc/lirc-dev-intro.rst
@@ -46,13 +46,13 @@ on the following table.
     This mode is for both sending and receiving IR.
 
     For transmitting (aka sending), create a ``struct lirc_scancode`` with
-    the desired scancode set in the ``scancode`` member, ``rc_proto`` set
-    the IR protocol, and all other members set to 0. Write this struct to
+    the desired scancode set in the ``scancode`` member, :c:type:`rc_proto`
+    set the IR protocol, and all other members set to 0. Write this struct to
     the lirc device.
 
     For receiving, you read ``struct lirc_scancode`` from the lirc device,
     with ``scancode`` set to the received scancode and the IR protocol
-    ``rc_proto``. If the scancode maps to a valid key code, this is set
+    :c:type:`rc_proto`. If the scancode maps to a valid key code, this is set
     in the ``keycode`` field, else it is set to ``KEY_RESERVED``.
 
     The ``flags`` can have ``LIRC_SCANCODE_FLAG_TOGGLE`` set if the toggle
@@ -74,9 +74,6 @@ on the following table.
     The ``timestamp`` field is filled with the time nanoseconds
     (in ``CLOCK_MONOTONIC``) when the scancode was decoded.
 
-    An ``enum rc_proto`` in the :ref:`lirc_header` lists all the supported
-    IR protocols.
-
 .. _lirc-mode-mode2:
 
 ``LIRC_MODE_MODE2``
@@ -125,3 +122,13 @@ on the following table.
     of entries.
 
     This mode is used only for IR send.
+
+
+**************************
+Remote Controller protocol
+**************************
+
+An enum :c:type:`rc_proto` in the :ref:`lirc_header` lists all the
+supported IR protocols:
+
+.. kernel-doc:: include/uapi/linux/lirc.h
diff --git a/Documentation/media/uapi/rc/lirc-read.rst b/Documentation/media/uapi/rc/lirc-read.rst
index 51d37ed10194..c024aaffb8ad 100644
--- a/Documentation/media/uapi/rc/lirc-read.rst
+++ b/Documentation/media/uapi/rc/lirc-read.rst
@@ -54,7 +54,7 @@ read from the chardev.
 
 Alternatively, :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` can be available,
 in this mode scancodes which are either decoded by software decoders, or
-by hardware decoders. The ``rc_proto`` member is set to the
+by hardware decoders. The :c:type:`rc_proto` member is set to the
 protocol used for transmission, and ``scancode`` to the decoded scancode,
 and the ``keycode`` set to the keycode or ``KEY_RESERVED``.
 
diff --git a/Documentation/media/uapi/rc/lirc-write.rst b/Documentation/media/uapi/rc/lirc-write.rst
index 3d7541bad8b9..dd3d1fe807a6 100644
--- a/Documentation/media/uapi/rc/lirc-write.rst
+++ b/Documentation/media/uapi/rc/lirc-write.rst
@@ -57,8 +57,8 @@ driver returns ``EINVAL``.
 When in :ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` mode, one
 ``struct lirc_scancode`` must be written to the chardev at a time, else
 ``EINVAL`` is returned. Set the desired scancode in the ``scancode`` member,
-and the protocol in the ``rc_proto`` member. All other members must be set
-to 0, else ``EINVAL`` is returned. If there is no protocol encoder
+and the protocol in the :c:type:`rc_proto`: member. All other members must be
+set to 0, else ``EINVAL`` is returned. If there is no protocol encoder
 for the protocol or the scancode is not valid for the specified protocol,
 ``EINVAL`` is returned. The write function may not wait until the scancode
 is transmitted.
-- 
2.14.3
