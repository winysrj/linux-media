Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33860 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753206AbeFQOgw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Jun 2018 10:36:52 -0400
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: hverkuil@xs4all.nl, mchehab@kernel.org
Cc: rostedt@goodmis.org, mingo@redhat.com, isely@pobox.com,
        bhumirks@gmail.com, colin.king@canonical.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCH 1/2] Add TRACE_EVENTs in pwc_isoc_handler()
Date: Sun, 17 Jun 2018 17:36:24 +0300
Message-Id: <20180617143625.32133-1-matwey@sai.msu.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 drivers/media/usb/pwc/pwc-if.c |  7 +++++++
 include/trace/events/pwc.h     | 45 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)
 create mode 100644 include/trace/events/pwc.h

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 54b036d39c5b..5775d1f60668 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -57,6 +57,9 @@
    - Pham Thanh Nam: webcam snapshot button as an event input device
 */
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/pwc.h>
+
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/mm.h>
@@ -260,6 +263,8 @@ static void pwc_isoc_handler(struct urb *urb)
 	int i, fst, flen;
 	unsigned char *iso_buf = NULL;
 
+	trace_pwc_handler_enter(urb);
+
 	if (urb->status == -ENOENT || urb->status == -ECONNRESET ||
 	    urb->status == -ESHUTDOWN) {
 		PWC_DEBUG_OPEN("URB (%p) unlinked %ssynchronously.\n",
@@ -347,6 +352,8 @@ static void pwc_isoc_handler(struct urb *urb)
 		pdev->vlast_packet_size = flen;
 	}
 
+	trace_pwc_handler_exit(urb);
+
 handler_end:
 	i = usb_submit_urb(urb, GFP_ATOMIC);
 	if (i != 0)
diff --git a/include/trace/events/pwc.h b/include/trace/events/pwc.h
new file mode 100644
index 000000000000..b13d2118bb7a
--- /dev/null
+++ b/include/trace/events/pwc.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(_TRACE_PWC_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PWC_H
+
+#include <linux/usb.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM pwc
+
+TRACE_EVENT(pwc_handler_enter,
+	TP_PROTO(struct urb *urb),
+	TP_ARGS(urb),
+	TP_STRUCT__entry(
+		__field(struct urb*, urb)
+		__field(int, urb__status)
+		__field(u32, urb__actual_length)
+	),
+	TP_fast_assign(
+		__entry->urb = urb;
+		__entry->urb__status = urb->status;
+		__entry->urb__actual_length = urb->actual_length;
+	),
+	TP_printk("urb=%p (status=%d actual_length=%u)",
+		__entry->urb,
+		__entry->urb__status,
+		__entry->urb__actual_length)
+);
+
+TRACE_EVENT(pwc_handler_exit,
+	TP_PROTO(struct urb *urb),
+	TP_ARGS(urb),
+	TP_STRUCT__entry(
+		__field(struct urb*, urb)
+	),
+	TP_fast_assign(
+		__entry->urb = urb;
+	),
+	TP_printk("urb=%p", __entry->urb)
+);
+
+#endif /* _TRACE_PWC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.16.0-rc1
