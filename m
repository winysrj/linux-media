Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:51665 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752102AbeEOHVG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:21:06 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Neil Armstrong <narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: improve cec status documentation
Message-ID: <31f2a3ae-aaa3-633f-6327-2b884dd59898@xs4all.nl>
Date: Tue, 15 May 2018 09:21:01 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clarify the description of status bits, particularly w.r.t. ERROR and NACK.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index a9f53f069a2d..1d989c544370 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -246,7 +246,10 @@ CEC_TX_STATUS_LOW_DRIVE:
 CEC_TX_STATUS_ERROR:
 	some unspecified error occurred: this can be one of ARB_LOST
 	or LOW_DRIVE if the hardware cannot differentiate or something
-	else entirely.
+	else entirely. Some hardware only supports OK and FAIL as the
+	result of a transmit, i.e. there is no way to differentiate
+	between the different possible errors. In that case map FAIL
+	to CEC_TX_STATUS_NACK and not to CEC_TX_STATUS_ERROR.

 CEC_TX_STATUS_MAX_RETRIES:
 	could not transmit the message after trying multiple times.
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index bdad4b197bcd..e964074cd15b 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -231,26 +231,32 @@ View On' messages from initiator 0xf ('Unregistered') to destination 0 ('TV').
       - ``CEC_TX_STATUS_OK``
       - 0x01
       - The message was transmitted successfully. This is mutually
-	exclusive with :ref:`CEC_TX_STATUS_MAX_RETRIES <CEC-TX-STATUS-MAX-RETRIES>`. Other bits can still
-	be set if earlier attempts met with failure before the transmit
-	was eventually successful.
+	exclusive with :ref:`CEC_TX_STATUS_MAX_RETRIES <CEC-TX-STATUS-MAX-RETRIES>`.
+	Other bits can still be set if earlier attempts met with failure before
+	the transmit was eventually successful.
     * .. _`CEC-TX-STATUS-ARB-LOST`:

       - ``CEC_TX_STATUS_ARB_LOST``
       - 0x02
-      - CEC line arbitration was lost.
+      - CEC line arbitration was lost, i.e. another transmit started at the
+        same time with a higher priority. Optional status, not all hardware
+	can detect this error condition.
     * .. _`CEC-TX-STATUS-NACK`:

       - ``CEC_TX_STATUS_NACK``
       - 0x04
-      - Message was not acknowledged.
+      - Message was not acknowledged. Note that some hardware cannot tell apart
+        a 'Not Acknowledged' status from other error conditions, i.e. the result
+	of a transmit is just OK or FAIL. In that case this status will be
+	returned when the transmit failed.
     * .. _`CEC-TX-STATUS-LOW-DRIVE`:

       - ``CEC_TX_STATUS_LOW_DRIVE``
       - 0x08
       - Low drive was detected on the CEC bus. This indicates that a
 	follower detected an error on the bus and requests a
-	retransmission.
+	retransmission. Optional status, not all hardware can detect this
+	error condition.
     * .. _`CEC-TX-STATUS-ERROR`:

       - ``CEC_TX_STATUS_ERROR``
@@ -258,14 +264,14 @@ View On' messages from initiator 0xf ('Unregistered') to destination 0 ('TV').
       - Some error occurred. This is used for any errors that do not fit
 	``CEC_TX_STATUS_ARB_LOST`` or ``CEC_TX_STATUS_LOW_DRIVE``, either because
 	the hardware could not tell which error occurred, or because the hardware
-	tested for other conditions besides those two.
+	tested for other conditions besides those two. Optional status.
     * .. _`CEC-TX-STATUS-MAX-RETRIES`:

       - ``CEC_TX_STATUS_MAX_RETRIES``
       - 0x20
       - The transmit failed after one or more retries. This status bit is
-	mutually exclusive with :ref:`CEC_TX_STATUS_OK <CEC-TX-STATUS-OK>`. Other bits can still
-	be set to explain which failures were seen.
+	mutually exclusive with :ref:`CEC_TX_STATUS_OK <CEC-TX-STATUS-OK>`.
+	Other bits can still be set to explain which failures were seen.


 .. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
