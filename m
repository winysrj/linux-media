Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309AbcGLMme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 13/20] [media] doc-rst: document LIRC set carrier ioctls
Date: Tue, 12 Jul 2016 09:42:07 -0300
Message-Id: <2b517b049637357352df94ba455618047006e6c3.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put each ioctl on its own page and improve documentation, adding
cross-references for LIRC_SET_REC_CARRIER_RANGE and LIRC_SET_REC_CARRIER,
with can be used together to set a carrier frequency range.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   | 49 ++++++++++++++++++++++
 .../media/uapi/rc/lirc-set-rec-carrier.rst         | 48 +++++++++++++++++++++
 .../media/uapi/rc/lirc-set-send-carrier.rst        | 43 +++++++++++++++++++
 .../media/uapi/rc/lirc_device_interface.rst        |  3 ++
 Documentation/media/uapi/rc/lirc_ioctl.rst         | 18 --------
 5 files changed, 143 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
 create mode 100644 Documentation/media/uapi/rc/lirc-set-send-carrier.rst

diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst b/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
new file mode 100644
index 000000000000..7cce9c8ba361
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-rec-carrier-range.rst
@@ -0,0 +1,49 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_rec_carrier_range:
+
+********************************
+ioctl LIRC_SET_REC_CARRIER_RANGE
+********************************
+
+Name
+====
+
+LIRC_SET_REC_CARRIER_RANGE - Set lower bond of the carrier used to modulate
+IR receive.
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *frequency )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_SET_REC_CARRIER_RANGE
+
+``frequency``
+    Frequency of the carrier that modulates PWM data, in Hz.
+
+Description
+===========
+
+This ioctl sets the upper range of carrier frequency that will be recognized
+by the IR receiver.
+
+.. note::
+
+   To set a range use :ref:`LIRC_SET_REC_CARRIER_RANGE
+   <LIRC_SET_REC_CARRIER_RANGE>` with the lower bound first and later call
+   :ref:`LIRC_SET_REC_CARRIER <LIRC_SET_REC_CARRIER>` with the upper bound.
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst b/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
new file mode 100644
index 000000000000..17ddb4723caa
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-rec-carrier.rst
@@ -0,0 +1,48 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_rec_carrier:
+
+**************************
+ioctl LIRC_SET_REC_CARRIER
+**************************
+
+Name
+====
+
+LIRC_SET_REC_CARRIER - Set carrier used to modulate IR receive.
+
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *frequency )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_SET_REC_CARRIER
+
+``frequency``
+    Frequency of the carrier that modulates PWM data, in Hz.
+
+Description
+===========
+
+Set receive carrier used to modulate IR PWM pulses and spaces.
+
+.. note::
+
+   If called together with :ref:`LIRC_SET_REC_CARRIER_RANGE`, this ioctl
+   sets the upper bound frequency that will be recognized by the device.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc-set-send-carrier.rst b/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
new file mode 100644
index 000000000000..4314d4c86ced
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-send-carrier.rst
@@ -0,0 +1,43 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_send_carrier:
+
+***************************
+ioctl LIRC_SET_SEND_CARRIER
+***************************
+
+Name
+====
+
+LIRC_SET_SEND_CARRIER - Set send carrier used to modulate IR TX.
+
+
+Synopsis
+========
+
+.. cpp:function:: int ioctl( int fd, int request, __u32 *frequency )
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``request``
+    LIRC_SET_SEND_CARRIER
+
+``frequency``
+    Frequency of the carrier to be modulated, in Hz.
+
+Description
+===========
+
+Set send carrier used to modulate IR PWM pulses and spaces.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc_device_interface.rst b/Documentation/media/uapi/rc/lirc_device_interface.rst
index f8a619e233c0..06257caa82db 100644
--- a/Documentation/media/uapi/rc/lirc_device_interface.rst
+++ b/Documentation/media/uapi/rc/lirc_device_interface.rst
@@ -19,4 +19,7 @@ LIRC Device Interface
     lirc-set-send-duty-cycle
     lirc-get-timeout
     lirc-get-length
+    lirc-set-rec-carrier
+    lirc-set-rec-carrier-range
+    lirc-set-send-carrier
     lirc_ioctl
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index 93531c37fd27..b1cca1465997 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -54,13 +54,6 @@ device can rely on working with the default settings initially.
     Set send/receive mode. Largely obsolete for send, as only
     ``LIRC_MODE_PULSE`` is supported.
 
-.. _LIRC_SET_SEND_CARRIER:
-.. _LIRC_SET_REC_CARRIER:
-
-``LIRC_SET_{SEND,REC}_CARRIER``
-
-    Set send/receive carrier (in Hz).
-
 .. _LIRC_SET_TRANSMITTER_MASK:
 
 ``LIRC_SET_TRANSMITTER_MASK``
@@ -99,17 +92,6 @@ device can rely on working with the default settings initially.
     press on, the driver will send ``LIRC_MODE2_FREQUENCY`` packets. By
     default this should be turned off.
 
-
-.. _LIRC_SET_REC_CARRIER_RANGE:
-
-``LIRC_SET_REC_CARRIER_RANGE``
-
-    To set a range use
-    ``LIRC_SET_REC_CARRIER_RANGE``
-    with the lower bound first and later
-    ``LIRC_SET_REC_CARRIER`` with the upper
-    bound.
-
 .. _LIRC_SET_WIDEBAND_RECEIVER:
 
 ``LIRC_SET_WIDEBAND_RECEIVER``
-- 
2.7.4


