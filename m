Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:53992 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751386AbdHaPYk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 11:24:40 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: cec-ioc-receive.rst: fix typo: two -> three
Message-ID: <94ee846a-098e-c7bd-6bc1-acc61c970b3a@xs4all.nl>
Date: Thu, 31 Aug 2017 17:24:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The description of CEC_TX_STATUS_ERROR referred to two previous statuses, but
there are three. Update the documentation accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 267044f7ac30..887487d63403 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -254,9 +254,9 @@ View On' messages from initiator 0xf ('Unregistered') to destination 0 ('TV').
       - ``CEC_TX_STATUS_ERROR``
       - 0x10
       - Some error occurred. This is used for any errors that do not fit
-	the previous two, either because the hardware could not tell which
+	the previous three, either because the hardware could not tell which
 	error occurred, or because the hardware tested for other
-	conditions besides those two.
+	conditions besides those three.
     * .. _`CEC-TX-STATUS-MAX-RETRIES`:

       - ``CEC_TX_STATUS_MAX_RETRIES``
