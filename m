Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44495 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbcGLSIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 14:08:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] doc-rst: update CEC_RECEIVE
Date: Tue, 12 Jul 2016 20:07:44 +0200
Message-Id: <1468346865-36465-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468346865-36465-1-git-send-email-hverkuil@xs4all.nl>
References: <1468346865-36465-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The timestamp field was split into rx_ts and tx_ts, and the rx/tx_status
fields were moved. Update the doc accordingly.

Also fix a bug that stated that a non-zero tx_status field signaled an
error. That's not true, since TX_STATUS_OK is 1, not 0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-ioc-receive.rst | 76 +++++++++++++-----------
 1 file changed, 41 insertions(+), 35 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 47aadcd..34382af 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -64,14 +64,20 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  __u64
 
-       -  ``ts``
+       -  ``tx_ts``
 
-       -  Timestamp of when the message was transmitted in ns in the case of
-	  :ref:`CEC_TRANSMIT` with ``reply`` set to 0, or the timestamp of the
-	  received message in all other cases.
+       -  Timestamp in ns of when the last byte of the message was transmitted.
 
     -  .. row 2
 
+       -  __u64
+
+       -  ``rx_ts``
+
+       -  Timestamp in ns of when the last byte of the message was received.
+
+    -  .. row 3
+
        -  __u32
 
        -  ``len``
@@ -81,7 +87,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 	  :ref:`CEC_RECEIVE` and for :ref:`CEC_TRANSMIT` it will be filled in with
 	  the length of the reply message if ``reply`` was set.
 
-    -  .. row 3
+    -  .. row 4
 
        -  __u32
 
@@ -94,7 +100,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 	  then it will be replaced by 1000 if the ``reply`` is non-zero or
 	  ignored if ``reply`` is 0.
 
-    -  .. row 4
+    -  .. row 5
 
        -  __u32
 
@@ -105,7 +111,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 	  framework to generate an event if a reply for a message was
 	  requested and the message was transmitted in a non-blocking mode.
 
-    -  .. row 5
+    -  .. row 6
 
        -  __u32
 
@@ -113,32 +119,10 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  Flags. No flags are defined yet, so set this to 0.
 
-    -  .. row 6
-
-       -  __u8
-
-       -  ``rx_status``
-
-       -  The status bits of the received message. See
-	  :ref:`cec-rx-status` for the possible status values. It is 0 if
-	  this message was transmitted, not received, unless this is the
-	  reply to a transmitted message. In that case both ``rx_status``
-	  and ``tx_status`` are set.
-
     -  .. row 7
 
        -  __u8
 
-       -  ``tx_status``
-
-       -  The status bits of the transmitted message. See
-	  :ref:`cec-tx-status` for the possible status values. It is 0 if
-	  this messages was received, not transmitted.
-
-    -  .. row 8
-
-       -  __u8
-
        -  ``msg``\ [16]
 
        -  The message payload. For :ref:`CEC_TRANSMIT` this is filled in by the
@@ -146,7 +130,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 	  for :ref:`CEC_TRANSMIT` it will be filled in with the payload of the
 	  reply message if ``reply`` was set.
 
-    -  .. row 9
+    -  .. row 8
 
        -  __u8
 
@@ -154,8 +138,8 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  Wait until this message is replied. If ``reply`` is 0 and the
 	  ``timeout`` is 0, then don't wait for a reply but return after
-	  transmitting the message. If there was an error as indicated by a
-	  non-zero ``tx_status`` field, then ``reply`` and ``timeout`` are
+	  transmitting the message. If there was an error as indicated by the
+	  ``tx_status`` field, then ``reply`` and ``timeout`` are
 	  both set to 0 by the driver. Ignored by :ref:`CEC_RECEIVE`. The case
 	  where ``reply`` is 0 (this is the opcode for the Feature Abort
 	  message) and ``timeout`` is non-zero is specifically allowed to
@@ -163,10 +147,32 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 	  Feature Abort reply. In this case ``rx_status`` will either be set
 	  to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or :ref:`CEC_RX_STATUS-FEATURE-ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
 
+    -  .. row 9
+
+       -  __u8
+
+       -  ``rx_status``
+
+       -  The status bits of the received message. See
+	  :ref:`cec-rx-status` for the possible status values. It is 0 if
+	  this message was transmitted, not received, unless this is the
+	  reply to a transmitted message. In that case both ``rx_status``
+	  and ``tx_status`` are set.
+
     -  .. row 10
 
        -  __u8
 
+       -  ``tx_status``
+
+       -  The status bits of the transmitted message. See
+	  :ref:`cec-tx-status` for the possible status values. It is 0 if
+	  this messages was received, not transmitted.
+
+    -  .. row 11
+
+       -  __u8
+
        -  ``tx_arb_lost_cnt``
 
        -  A counter of the number of transmit attempts that resulted in the
@@ -174,7 +180,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 	  this, otherwise it is always 0. This counter is only valid if the
 	  :ref:`CEC_TX_STATUS_ARB_LOST <CEC-TX-STATUS-ARB-LOST>` status bit is set.
 
-    -  .. row 11
+    -  .. row 12
 
        -  __u8
 
@@ -185,7 +191,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 	  this, otherwise it is always 0. This counter is only valid if the
 	  :ref:`CEC_TX_STATUS_NACK <CEC-TX-STATUS-NACK>` status bit is set.
 
-    -  .. row 12
+    -  .. row 13
 
        -  __u8
 
@@ -196,7 +202,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 	  this, otherwise it is always 0. This counter is only valid if the
 	  :ref:`CEC_TX_STATUS_LOW_DRIVE <CEC-TX-STATUS-LOW-DRIVE>` status bit is set.
 
-    -  .. row 13
+    -  .. row 14
 
        -  __u8
 
-- 
2.8.1

