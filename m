Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:53760 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751095AbcKIIA7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 03:00:59 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-core.rst: improve documentation
Message-ID: <092fe777-9286-a190-3499-1641e2da464c@xs4all.nl>
Date: Wed, 9 Nov 2016 09:00:53 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve the internal CEC documentation. In particular add a section that specifies that
transmit-related interrupts should be processed before receive interrupts.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 88c33b5..8a88dd4 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -106,13 +106,13 @@ your driver:
 		int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
 		int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
 				      u32 signal_free_time, struct cec_msg *msg);
-		void (\*adap_log_status)(struct cec_adapter *adap);
+		void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);

 		/* High-level callbacks */
 		...
 	};

-The three low-level ops deal with various aspects of controlling the CEC adapter
+The five low-level ops deal with various aspects of controlling the CEC adapter
 hardware:


@@ -238,6 +238,18 @@ When a CEC message was received:

 Speaks for itself.

+Implementing the interrupt handler
+----------------------------------
+
+Typically the CEC hardware provides interrupts that signal when a transmit
+finished and whether it was successful or not, and it provides and interrupt
+when a CEC message was received.
+
+The CEC driver should always process the transmit interrupts first before
+handling the receive interrupt. The framework expects to see the cec_transmit_done
+call before the cec_received_msg call, otherwise it can get confused if the
+received message was in reply to the transmitted message.
+
 Implementing the High-Level CEC Adapter
 ---------------------------------------

@@ -247,11 +259,11 @@ CEC protocol driven. The following high-level callbacks are available:
 .. code-block:: none

 	struct cec_adap_ops {
-		/\* Low-level callbacks \*/
+		/* Low-level callbacks */
 		...

-		/\* High-level CEC message callback \*/
-		int (\*received)(struct cec_adapter \*adap, struct cec_msg \*msg);
+		/* High-level CEC message callback */
+		int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
 	};

 The received() callback allows the driver to optionally handle a newly
@@ -263,7 +275,7 @@ received CEC message
 If the driver wants to process a CEC message, then it can implement this
 callback. If it doesn't want to handle this message, then it should return
 -ENOMSG, otherwise the CEC framework assumes it processed this message and
-it will not no anything with it.
+it will not do anything with it.


 CEC framework functions
