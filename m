Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:53979 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751303AbdKWOFM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 09:05:12 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-core.rst: document the new adap_monitor_pin_enable op
Message-ID: <e71c9720-1dae-b2e5-8c4d-12223431d230@xs4all.nl>
Date: Thu, 23 Nov 2017 15:05:06 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document what this op does.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/kapi/cec-core.rst | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index d37e107f2fde..62b9a1448177 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -103,6 +103,7 @@ your driver:
 		/* Low-level callbacks */
 		int (*adap_enable)(struct cec_adapter *adap, bool enable);
 		int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
+		int (*adap_monitor_pin_enable)(struct cec_adapter *adap, bool enable);
 		int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
 		int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
 				      u32 signal_free_time, struct cec_msg *msg);
@@ -144,6 +145,19 @@ called if the CEC_CAP_MONITOR_ALL capability is set. This callback is optional
 Note that adap_monitor_all_enable must return 0 if enable is false.


+To enable/disable the 'monitor pin' mode:
+
+.. c:function::
+	int (*adap_monitor_pin_enable)(struct cec_adapter *adap, bool enable);
+
+If enabled, then the adapter should be put in a mode to also monitor CEC pin
+changes. Not all hardware supports this and this function is only called if
+the CEC_CAP_MONITOR_PIN capability is set. This callback is optional
+(some hardware may always be in 'monitor pin' mode).
+
+Note that adap_monitor_pin_enable must return 0 if enable is false.
+
+
 To program a new logical address:

 .. c:function::
-- 
2.14.1
