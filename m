Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60619 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbcGJKsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 06:48:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 6/6] [media] doc-rst: do cross-references between header and the doc
Date: Sun, 10 Jul 2016 07:47:45 -0300
Message-Id: <9c1fabd664625d79899b96c2652a9fbcd23af4dc.1468147615.git.mchehab@s-opensource.com>
In-Reply-To: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
References: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
In-Reply-To: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
References: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the LIRC header was added, we can cross-reference it
and identify the documentation gaps.

There are lots of stuff missing there, but at least now we
can avoid the gap to increase.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/lirc.h.rst.exceptions  | 72 ++++++++++++++++++++++++++++++
 Documentation/media/uapi/rc/lirc_ioctl.rst |  9 +++-
 2 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index efdcb59f3002..58439ef3b9d7 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -1,2 +1,74 @@
 # Ignore header name
 ignore define _LINUX_LIRC_H
+
+# Ignore helper macros
+
+ignore define lirc_t
+
+ignore define LIRC_SPACE
+ignore define LIRC_PULSE
+ignore define LIRC_FREQUENCY
+ignore define LIRC_TIMEOUT
+ignore define LIRC_VALUE
+ignore define LIRC_MODE2
+ignore define LIRC_IS_SPACE
+ignore define LIRC_IS_PULSE
+ignore define LIRC_IS_FREQUENCY
+ignore define LIRC_IS_TIMEOUT
+
+ignore define LIRC_MODE2SEND
+ignore define LIRC_SEND2MODE
+ignore define LIRC_MODE2REC
+ignore define LIRC_REC2MODE
+
+ignore define LIRC_CAN_SEND
+ignore define LIRC_CAN_REC
+
+# Undocumented macros
+
+ignore define PULSE_BIT
+ignore define PULSE_MASK
+
+ignore define LIRC_MODE2_SPACE
+ignore define LIRC_MODE2_PULSE
+ignore define LIRC_MODE2_TIMEOUT
+
+ignore define LIRC_VALUE_MASK
+ignore define LIRC_MODE2_MASK
+
+ignore define LIRC_MODE_RAW
+
+ignore define LIRC_CAN_SEND_RAW
+ignore define LIRC_CAN_SEND_PULSE
+ignore define LIRC_CAN_SEND_MODE2
+ignore define LIRC_CAN_SEND_LIRCCODE
+
+ignore define LIRC_CAN_SEND_MASK
+
+ignore define LIRC_CAN_SET_SEND_CARRIER
+ignore define LIRC_CAN_SET_SEND_DUTY_CYCLE
+ignore define LIRC_CAN_SET_TRANSMITTER_MASK
+
+ignore define LIRC_CAN_REC_RAW
+ignore define LIRC_CAN_REC_PULSE
+ignore define LIRC_CAN_REC_MODE2
+ignore define LIRC_CAN_REC_LIRCCODE
+
+ignore define LIRC_CAN_REC_MASK
+
+ignore define LIRC_CAN_SET_REC_CARRIER
+ignore define LIRC_CAN_SET_REC_DUTY_CYCLE
+
+ignore define LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE
+ignore define LIRC_CAN_SET_REC_CARRIER_RANGE
+ignore define LIRC_CAN_GET_REC_RESOLUTION
+ignore define LIRC_CAN_SET_REC_TIMEOUT
+ignore define LIRC_CAN_SET_REC_FILTER
+
+ignore define LIRC_CAN_MEASURE_CARRIER
+ignore define LIRC_CAN_USE_WIDEBAND_RECEIVER
+
+ignore define LIRC_CAN_SEND(x)
+ignore define LIRC_CAN_REC(x)
+
+ignore define LIRC_CAN_NOTIFY_DECODE
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index c4c34db61a96..c1c7163ba2f7 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -59,6 +59,7 @@ I/O control requests
     corresponding ioctls is undefined.
 
 .. _LIRC_GET_SEND_MODE:
+.. _lirc-mode-pulse:
 
 ``LIRC_GET_SEND_MODE``
 
@@ -66,6 +67,8 @@ I/O control requests
     lircd.
 
 .. _LIRC_GET_REC_MODE:
+.. _lirc-mode-mode2:
+.. _lirc-mode-lirccode:
 
 ``LIRC_GET_REC_MODE``
 
@@ -120,8 +123,8 @@ I/O control requests
     cannot be changed.
 
 .. _LIRC_GET_MIN_FILTER_PULSE:
-.. _LIRC_GET_MIN_FILTER_PULSE:
-.. _LIRC_GET_MAX_FILTER_SPACE:
+.. _LIRC_GET_MAX_FILTER_PULSE:
+.. _LIRC_GET_MIN_FILTER_SPACE:
 .. _LIRC_GET_MAX_FILTER_SPACE:
 
 ``LIRC_GET_M{IN,AX}_FILTER_{PULSE,SPACE}``
@@ -186,6 +189,7 @@ I/O control requests
 
 .. _LIRC_SET_REC_FILTER_PULSE:
 .. _LIRC_SET_REC_FILTER_SPACE:
+.. _LIRC_SET_REC_FILTER:
 
 ``LIRC_SET_REC_FILTER_{PULSE,SPACE}``
 
@@ -195,6 +199,7 @@ I/O control requests
     shall be used instead.
 
 .. _LIRC_SET_MEASURE_CARRIER_MODE:
+.. _lirc-mode2-frequency:
 
 ``LIRC_SET_MEASURE_CARRIER_MODE``
 
-- 
2.7.4

