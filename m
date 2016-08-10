Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:6029 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbcHJSMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:12:23 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id u7A90rfb025557
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 10 Aug 2016 09:00:53 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] cec: improve dqevent documentation
Message-ID: <57AAED45.8000003@cisco.com>
Date: Wed, 10 Aug 2016 11:00:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation for the cec_event_state_change struct was incomplete.
This patch documents what happens in the corner cases.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 7a6d6d0..2e1e739 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -64,7 +64,8 @@ it is guaranteed that the state did change in between the two events.

        -  ``phys_addr``

-       -  The current physical address.
+       -  The current physical address. This is ``CEC_PHYS_ADDR_INVALID`` if no
+          valid physical address is set.

     -  .. row 2

@@ -72,7 +73,10 @@ it is guaranteed that the state did change in between the two events.

        -  ``log_addr_mask``

-       -  The current set of claimed logical addresses.
+       -  The current set of claimed logical addresses. This is 0 if no logical
+          addresses are claimed or if ``phys_addr`` is ``CEC_PHYS_ADDR_INVALID``.
+	  If bit 15 is set (``1 << CEC_LOG_ADDR_UNREGISTERED``) then this device
+	  has the unregistered logical address. In that case all other bits are 0.



