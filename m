Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42562 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751359AbdHaPBm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 11:01:42 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: cec-ioc-receive.rst: fix typo: messages -> message
Message-ID: <2796f09b-f5a1-a8b3-c0f9-26d324d4ff48@xs4all.nl>
Date: Thu, 31 Aug 2017 17:01:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's 'this message', not 'this messages'.

Fix the typo.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 267044f7ac30..2a9b09676add 100644
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
