Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:39596 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbeFVMEh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 08:04:37 -0400
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: hverkuil@xs4all.nl, mchehab@kernel.org
Cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>, rostedt@goodmis.org,
        mingo@redhat.com, isely@pobox.com, bhumirks@gmail.com,
        colin.king@canonical.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ezequiel@collabora.com,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 1/2] media: usb: pwc: Introduce TRACE_EVENTs for pwc_isoc_handler()
Date: Fri, 22 Jun 2018 15:04:18 +0300
Message-Id: <20180622120419.7675-2-matwey@sai.msu.ru>
In-Reply-To: <20180622120419.7675-1-matwey@sai.msu.ru>
References: <20180622120419.7675-1-matwey@sai.msu.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There were reports that PWC-based webcams don't work at some
embedded ARM platforms. [1] Isochronous transfer handler seems to
work too long leading to the issues in MUSB USB host subsystem.
Also note, that urb->giveback() handlers are still called with
disabled interrupts. In order to be able to measure performance of
PWC driver, traces are introduced in URB handler section.

[1] https://www.spinics.net/lists/linux-usb/msg165735.html

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 drivers/media/usb/pwc/pwc-if.c |  7 +++++
 include/trace/events/pwc.h     | 64 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)
 create mode 100644 include/trace/events/pwc.h

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 54b036d39c5b..72d2897a4b9f 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -76,6 +76,9 @@
 #include "pwc-dec23.h"
 #include "pwc-dec1.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/pwc.h>
+
 /* Function prototypes and driver templates */
 
 /* hotplug device table support */
@@ -260,6 +263,8 @@ static void pwc_isoc_handler(struct urb *urb)
 	int i, fst, flen;
 	unsigned char *iso_buf = NULL;
 
+	trace_pwc_handler_enter(urb, pdev);
+
 	if (urb->status == -ENOENT || urb->status == -ECONNRESET ||
 	    urb->status == -ESHUTDOWN) {
 		PWC_DEBUG_OPEN("URB (%p) unlinked %ssynchronously.\n",
@@ -348,6 +353,8 @@ static void pwc_isoc_handler(struct urb *urb)
 	}
 
 handler_end:
+	trace_pwc_handler_exit(urb, pdev);
+
 	i = usb_submit_urb(urb, GFP_ATOMIC);
 	if (i != 0)
 		PWC_ERROR("Error (%d) re-submitting urb in pwc_isoc_handler.\n", i);
diff --git a/include/trace/events/pwc.h b/include/trace/events/pwc.h
new file mode 100644
index 000000000000..d5bcb1314d0e
--- /dev/null
+++ b/include/trace/events/pwc.h
@@ -0,0 +1,64 @@
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
+	TP_PROTO(struct urb *urb, struct pwc_device *pdev),
+	TP_ARGS(urb, pdev),
+	TP_STRUCT__entry(
+		__field(struct urb*, urb)
+		__field(int, urb__status)
+		__field(u32, urb__actual_length)
+		__field(char*, devpath)
+		__field(struct pwc_frame_buf*, fbuf)
+		__field(int, fbuf__filled)
+	),
+	TP_fast_assign(
+		__entry->urb = urb;
+		__entry->urb__status = urb->status;
+		__entry->urb__actual_length = urb->actual_length;
+		__entry->devpath = pdev->udev->devpath;
+		__entry->fbuf = pdev->fill_buf;
+		__entry->fbuf__filled = pdev->fill_buf->filled;
+	),
+	TP_printk("devpath=%s (fbuf=%p filled=%d) urb=%p (status=%d actual_length=%u)",
+		__entry->devpath,
+		__entry->fbuf,
+		__entry->fbuf__filled,
+		__entry->urb,
+		__entry->urb__status,
+		__entry->urb__actual_length)
+);
+
+TRACE_EVENT(pwc_handler_exit,
+	TP_PROTO(struct urb *urb, struct pwc_device* pdev),
+	TP_ARGS(urb, pdev),
+	TP_STRUCT__entry(
+		__field(struct urb*, urb)
+		__field(char*, devpath)
+		__field(struct pwc_frame_buf*, fbuf)
+		__field(int, fbuf__filled)
+	),
+	TP_fast_assign(
+		__entry->urb = urb;
+		__entry->devpath = pdev->udev->devpath;
+		__entry->fbuf = pdev->fill_buf;
+		__entry->fbuf__filled = pdev->fill_buf->filled;
+	),
+	TP_printk("devpath=%s (fbuf=%p filled=%d) urb=%p",
+		__entry->devpath,
+		__entry->fbuf,
+		__entry->fbuf__filled,
+		__entry->urb)
+);
+
+#endif /* _TRACE_PWC_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.16.4
