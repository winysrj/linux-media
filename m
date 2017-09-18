Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:59448 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752998AbdIRJYC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 05:24:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-core.rst/cec-ioc-receive.rst: clarify CEC_TX_STATUS_ERROR
Message-ID: <3b92720d-8609-d4bb-7546-f0c7cf18021a@xs4all.nl>
Date: Mon, 18 Sep 2017 11:23:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CEC_TX_STATUS_ERROR can be used if the HW cannot tell LOST_ARB and LOW_DRIVE
apart, or when some other error occurs. It is not a replacement for NACK.

So the hardware must be able to tell the difference between OK, NACK and 'something
else'.

Clarify the documentation (both public and kernel API) on this point.

Also fix two small typos (this messages -> this message).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 28866259998c..d37e107f2fde 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -227,8 +227,8 @@ CEC_TX_STATUS_LOW_DRIVE:
 	retransmission.

 CEC_TX_STATUS_ERROR:
-	some unspecified error occurred: this can be one of
-	the previous two if the hardware cannot differentiate or something
+	some unspecified error occurred: this can be one of ARB_LOST
+	or LOW_DRIVE if the hardware cannot differentiate or something
 	else entirely.

 CEC_TX_STATUS_MAX_RETRIES:
@@ -238,6 +238,9 @@ CEC_TX_STATUS_MAX_RETRIES:
 	doesn't have to make another attempt to transmit the message
 	since the hardware did that already.

+The hardware must be able to differentiate between OK, NACK and 'something
+else'.
+
 The \*_cnt arguments are the number of error conditions that were seen.
 This may be 0 if no information is available. Drivers that do not support
 hardware retry can just set the counter corresponding to the transmit error
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 0f397c535a4c..bdad4b197bcd 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -131,7 +131,7 @@ View On' messages from initiator 0xf ('Unregistered') to destination 0 ('TV').
       - ``tx_status``
       - The status bits of the transmitted message. See
 	:ref:`cec-tx-status` for the possible status values. It is 0 if
-	this messages was received, not transmitted.
+	this message was received, not transmitted.
     * - __u8
       - ``msg[16]``
       - The message payload. For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` this is filled in by the
@@ -168,7 +168,7 @@ View On' messages from initiator 0xf ('Unregistered') to destination 0 ('TV').
       - ``tx_status``
       - The status bits of the transmitted message. See
 	:ref:`cec-tx-status` for the possible status values. It is 0 if
-	this messages was received, not transmitted.
+	this message was received, not transmitted.
     * - __u8
       - ``tx_arb_lost_cnt``
       - A counter of the number of transmit attempts that resulted in the
@@ -256,9 +256,9 @@ View On' messages from initiator 0xf ('Unregistered') to destination 0 ('TV').
       - ``CEC_TX_STATUS_ERROR``
       - 0x10
       - Some error occurred. This is used for any errors that do not fit
-	the previous two, either because the hardware could not tell which
-	error occurred, or because the hardware tested for other
-	conditions besides those two.
+	``CEC_TX_STATUS_ARB_LOST`` or ``CEC_TX_STATUS_LOW_DRIVE``, either because
+	the hardware could not tell which error occurred, or because the hardware
+	tested for other conditions besides those two.
     * .. _`CEC-TX-STATUS-MAX-RETRIES`:

       - ``CEC_TX_STATUS_MAX_RETRIES``
