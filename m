Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294AbcGLMmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 05/20] [media] doc-rst: Fix LIRC_GET_FEATURES references
Date: Tue, 12 Jul 2016 09:41:59 -0300
Message-Id: <1a2e50a4df07427f1d2196bc09c9dceedd77ed7b.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The references pointed by LIRC_GET_FEATURES ioctl are broken.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/lirc.h.rst.exceptions         |  4 +
 Documentation/media/uapi/rc/lirc-get-features.rst | 95 +++++++++++++----------
 2 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index 17f6e7e9550d..246c850151d7 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -24,6 +24,10 @@ ignore define LIRC_REC2MODE
 ignore define LIRC_CAN_SEND
 ignore define LIRC_CAN_REC
 
+ignore define LIRC_CAN_SEND_MASK
+ignore define LIRC_CAN_REC_MASK
+ignore define LIRC_CAN_SET_REC_DUTY_CYCLE
+
 # Undocumented macros
 
 ignore define PULSE_BIT
diff --git a/Documentation/media/uapi/rc/lirc-get-features.rst b/Documentation/media/uapi/rc/lirc-get-features.rst
index 04ba9567053a..d89712190d43 100644
--- a/Documentation/media/uapi/rc/lirc-get-features.rst
+++ b/Documentation/media/uapi/rc/lirc-get-features.rst
@@ -40,120 +40,137 @@ is undefined.
 LIRC features
 =============
 
-.. _LIRC_CAN_REC_RAW:
+.. _LIRC-CAN-REC-RAW:
 
 ``LIRC_CAN_REC_RAW``
+
     The driver is capable of receiving using
-    :ref:`LIRC_MODE_RAW.`
+    :ref:`LIRC_MODE_RAW <lirc-mode-raw>`.
 
-.. _LIRC_CAN_REC_PULSE:
+.. _LIRC-CAN-REC-PULSE:
 
 ``LIRC_CAN_REC_PULSE``
+
     The driver is capable of receiving using
-    :ref:`LIRC_MODE_PULSE.`
+    :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`.
 
-.. _LIRC_CAN_REC_MODE2:
+.. _LIRC-CAN-REC-MODE2:
 
 ``LIRC_CAN_REC_MODE2``
+
     The driver is capable of receiving using
-    :ref:`LIRC_MODE_MODE2.`
+    :ref:`LIRC_MODE_MODE2 <lirc-mode-MODE2>`.
 
-.. _LIRC_CAN_REC_LIRCCODE:
+.. _LIRC-CAN-REC-LIRCCODE:
 
 ``LIRC_CAN_REC_LIRCCODE``
+
     The driver is capable of receiving using
-    :ref:`LIRC_MODE_LIRCCODE.`
+    :ref:`LIRC_MODE_LIRCCODE <lirc-mode-LIRCCODE>`.
 
-.. _LIRC_CAN_SET_SEND_CARRIER:
+.. _LIRC-CAN-SET-SEND-CARRIER:
 
 ``LIRC_CAN_SET_SEND_CARRIER``
+
     The driver supports changing the modulation frequency via
-    :ref:`LIRC_SET_SEND_CARRIER.`
+    :ref:`ioctl LIRC_SET_SEND_CARRIER <LIRC_SET_SEND_CARRIER>`.
 
-.. _LIRC_CAN_SET_SEND_DUTY_CYCLE:
+.. _LIRC-CAN-SET-SEND-DUTY-CYCLE:
 
 ``LIRC_CAN_SET_SEND_DUTY_CYCLE``
+
     The driver supports changing the duty cycle using
-    :ref:`LIRC_SET_SEND_DUTY_CYCLE`.
+    :ref:`ioctl LIRC_SET_SEND_DUTY_CYCLE <LIRC_SET_SEND_DUTY_CYCLE>`.
 
-.. _LIRC_CAN_SET_TRANSMITTER_MASK:
+.. _LIRC-CAN-SET-TRANSMITTER-MASK:
 
 ``LIRC_CAN_SET_TRANSMITTER_MASK``
+
     The driver supports changing the active transmitter(s) using
-    :ref:`LIRC_SET_TRANSMITTER_MASK.`
+    :ref:`ioctl LIRC_SET_TRANSMITTER_MASK <LIRC_SET_TRANSMITTER_MASK>`.
 
-.. _LIRC_CAN_SET_REC_CARRIER:
+.. _LIRC-CAN-SET-REC-CARRIER:
 
 ``LIRC_CAN_SET_REC_CARRIER``
+
     The driver supports setting the receive carrier frequency using
-    :ref:`LIRC_SET_REC_CARRIER.`
+    :ref:`ioctl LIRC_SET_REC_CARRIER <LIRC_SET_REC_CARRIER>`.
 
-.. _LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE:
+.. _LIRC-CAN-SET-REC-DUTY-CYCLE-RANGE:
 
 ``LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE``
+
     Unused. Kept just to avoid breaking uAPI.
 
-.. _LIRC_CAN_SET_REC_CARRIER_RANGE:
+.. _LIRC-CAN-SET-REC-CARRIER-RANGE:
 
 ``LIRC_CAN_SET_REC_CARRIER_RANGE``
+
     The driver supports
-    :ref:`LIRC_SET_REC_CARRIER_RANGE.`
+    :ref:`ioctl LIRC_SET_REC_CARRIER_RANGE <LIRC_SET_REC_CARRIER_RANGE>`.
 
-.. _LIRC_CAN_GET_REC_RESOLUTION:
+.. _LIRC-CAN-GET-REC-RESOLUTION:
 
 ``LIRC_CAN_GET_REC_RESOLUTION``
+
     The driver supports
-    :ref:`LIRC_GET_REC_RESOLUTION.`
+    :ref:`ioctl LIRC_GET_REC_RESOLUTION <LIRC_GET_REC_RESOLUTION>`.
 
-.. _LIRC_CAN_SET_REC_TIMEOUT:
+.. _LIRC-CAN-SET-REC-TIMEOUT:
 
 ``LIRC_CAN_SET_REC_TIMEOUT``
+
     The driver supports
-    :ref:`LIRC_SET_REC_TIMEOUT.`
+    :ref:`ioctl LIRC_SET_REC_TIMEOUT <LIRC_SET_REC_TIMEOUT>`.
 
-.. _LIRC_CAN_SET_REC_FILTER:
+.. _LIRC-CAN-SET-REC-FILTER:
 
 ``LIRC_CAN_SET_REC_FILTER``
+
     Unused. Kept just to avoid breaking uAPI.
 
-.. _LIRC_CAN_MEASURE_CARRIER:
+.. _LIRC-CAN-MEASURE-CARRIER:
 
 ``LIRC_CAN_MEASURE_CARRIER``
+
     The driver supports measuring of the modulation frequency using
-    :ref:`LIRC_SET_MEASURE_CARRIER_MODE`.
+    :ref:`ioctl LIRC_SET_MEASURE_CARRIER_MODE <LIRC_SET_MEASURE_CARRIER_MODE>`.
 
-.. _LIRC_CAN_USE_WIDEBAND_RECEIVER:
+.. _LIRC-CAN-USE-WIDEBAND-RECEIVER:
 
 ``LIRC_CAN_USE_WIDEBAND_RECEIVER``
+
     The driver supports learning mode using
-    :ref:`LIRC_SET_WIDEBAND_RECEIVER.`
+    :ref:`ioctl LIRC_SET_WIDEBAND_RECEIVER <LIRC_SET_WIDEBAND_RECEIVER>`.
 
-.. _LIRC_CAN_NOTIFY_DECODE:
+.. _LIRC-CAN-NOTIFY-DECODE:
 
 ``LIRC_CAN_NOTIFY_DECODE``
+
     Unused. Kept just to avoid breaking uAPI.
 
-.. _LIRC_CAN_SEND_RAW:
+.. _LIRC-CAN-SEND-RAW:
 
 ``LIRC_CAN_SEND_RAW``
-    The driver supports sending using
-    :ref:`LIRC_MODE_RAW.`
 
-.. _LIRC_CAN_SEND_PULSE:
+    The driver supports sending using :ref:`LIRC_MODE_RAW <lirc-mode-raw>`.
+
+.. _LIRC-CAN-SEND-PULSE:
 
 ``LIRC_CAN_SEND_PULSE``
-    The driver supports sending using
-    :ref:`LIRC_MODE_PULSE.`
 
-.. _LIRC_CAN_SEND_MODE2:
+    The driver supports sending using :ref:`LIRC_MODE_PULSE <lirc-mode-pulse>`.
+
+.. _LIRC-CAN-SEND-MODE2:
 
 ``LIRC_CAN_SEND_MODE2``
-    The driver supports sending using
-    :ref:`LIRC_MODE_MODE2.`
 
-.. _LIRC_CAN_SEND_LIRCCODE:
+    The driver supports sending using :ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>`.
+
+.. _LIRC-CAN-SEND-LIRCCODE:
 
 ``LIRC_CAN_SEND_LIRCCODE``
+
     The driver supports sending codes (also called as IR blasting or IR TX).
 
 
-- 
2.7.4


