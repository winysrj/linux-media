Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3KENDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:51 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 27/29] [media] mxl111sf: Don't use dynamic static allocation
Date: Tue,  5 Nov 2013 08:01:40 -0200
Message-Id: <1383645702-30636-28-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb-v2/mxl111sf.c:74:1: warning: 'mxl111sf_ctrl_msg' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (64 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index e97964ef7f56..2627553f7de1 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -23,6 +23,9 @@
 #include "lgdt3305.h"
 #include "lg2160.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 int dvb_usb_mxl111sf_debug;
 module_param_named(debug, dvb_usb_mxl111sf_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level "
@@ -57,7 +60,12 @@ int mxl111sf_ctrl_msg(struct dvb_usb_device *d,
 {
 	int wo = (rbuf == NULL || rlen == 0); /* write-only */
 	int ret;
-	u8 sndbuf[1+wlen];
+	u8 sndbuf[MAX_XFER_SIZE];
+
+	if (1 + wlen > sizeof(sndbuf)) {
+		pr_warn("%s: len=%d is too big!\n", __func__, wlen);
+		return -EOPNOTSUPP;
+	}
 
 	pr_debug("%s(wlen = %d, rlen = %d)\n", __func__, wlen, rlen);
 
-- 
1.8.3.1

