Return-path: <linux-media-owner@vger.kernel.org>
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:52890 "EHLO lnfm1.sai.msu.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbeHUU5I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 16:57:08 -0400
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: matwey.kornilov@gmail.com,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>, tfiga@chromium.org,
        laurent.pinchart@ideasonboard.com, stern@rowland.harvard.edu,
        ezequiel@collabora.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        isely@pobox.com, bhumirks@gmail.com, colin.king@canonical.com,
        kieran.bingham@ideasonboard.com, keiichiw@chromium.org
Subject: [PATCH v5 1/2] media: usb: pwc: Introduce TRACE_EVENTs for pwc_isoc_handler()
Date: Tue, 21 Aug 2018 20:06:28 +0300
Message-Id: <20180821170629.18408-2-matwey@sai.msu.ru>
In-Reply-To: <20180821170629.18408-1-matwey@sai.msu.ru>
References: <20180821170629.18408-1-matwey@sai.msu.ru>
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
 include/trace/events/pwc.h     | 65 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)
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
index 000000000000..a2da764a3b41
--- /dev/null
+++ b/include/trace/events/pwc.h
@@ -0,0 +1,65 @@
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
+		__field(struct pwc_frame_buf*, fbuf)
+		__field(int, urb__status)
+		__field(u32, urb__actual_length)
+		__field(int, fbuf__filled)
+		__string(name, pdev->v4l2_dev.name)
+	),
+	TP_fast_assign(
+		__entry->urb = urb;
+		__entry->fbuf = pdev->fill_buf;
+		__entry->urb__status = urb->status;
+		__entry->urb__actual_length = urb->actual_length;
+		__entry->fbuf__filled = (pdev->fill_buf
+					 ? pdev->fill_buf->filled : 0);
+		__assign_str(name, pdev->v4l2_dev.name);
+	),
+	TP_printk("dev=%s (fbuf=%p filled=%d) urb=%p (status=%d actual_length=%u)",
+		__get_str(name),
+		__entry->fbuf,
+		__entry->fbuf__filled,
+		__entry->urb,
+		__entry->urb__status,
+		__entry->urb__actual_length)
+);
+
+TRACE_EVENT(pwc_handler_exit,
+	TP_PROTO(struct urb *urb, struct pwc_device *pdev),
+	TP_ARGS(urb, pdev),
+	TP_STRUCT__entry(
+		__field(struct urb*, urb)
+		__field(struct pwc_frame_buf*, fbuf)
+		__field(int, fbuf__filled)
+		__string(name, pdev->v4l2_dev.name)
+	),
+	TP_fast_assign(
+		__entry->urb = urb;
+		__entry->fbuf = pdev->fill_buf;
+		__entry->fbuf__filled = pdev->fill_buf->filled;
+		__assign_str(name, pdev->v4l2_dev.name);
+	),
+	TP_printk(" dev=%s (fbuf=%p filled=%d) urb=%p",
+		__get_str(name),
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
