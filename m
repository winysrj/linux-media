Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60483 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757884Ab2HVXmY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 19:42:24 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] dvb_usb_v2: use dvb_usb_dbg_usb_control_msg()
Date: Thu, 23 Aug 2012 02:42:00 +0300
Message-Id: <1345678920-6360-2-git-send-email-crope@iki.fi>
In-Reply-To: <1345678920-6360-1-git-send-email-crope@iki.fi>
References: <1345678920-6360-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert drivers: au6610, ce6230, ec168, rtl28xxu for
dvb_usb_dbg_usb_control_msg() macro.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/au6610.c   |  5 +++++
 drivers/media/usb/dvb-usb-v2/ce6230.c   |  4 ++--
 drivers/media/usb/dvb-usb-v2/ce6230.h   | 11 -----------
 drivers/media/usb/dvb-usb-v2/ec168.c    |  4 ++--
 drivers/media/usb/dvb-usb-v2/ec168.h    | 11 -----------
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |  6 ++++--
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h | 11 -----------
 7 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/au6610.c b/drivers/media/usb/dvb-usb-v2/au6610.c
index c126b70..f309fd8 100644
--- a/drivers/media/usb/dvb-usb-v2/au6610.c
+++ b/drivers/media/usb/dvb-usb-v2/au6610.c
@@ -56,6 +56,11 @@ static int au6610_usb_msg(struct dvb_usb_device *d, u8 operation, u8 addr,
 	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), operation,
 			      USB_TYPE_VENDOR|USB_DIR_IN, addr << 1, index,
 			      usb_buf, 6, AU6610_USB_TIMEOUT);
+
+	dvb_usb_dbg_usb_control_msg(d->udev, operation,
+			(USB_TYPE_VENDOR|USB_DIR_IN), addr << 1, index,
+			usb_buf, 6);
+
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/media/usb/dvb-usb-v2/ce6230.c b/drivers/media/usb/dvb-usb-v2/ce6230.c
index 819db9c..1c4357d 100644
--- a/drivers/media/usb/dvb-usb-v2/ce6230.c
+++ b/drivers/media/usb/dvb-usb-v2/ce6230.c
@@ -74,8 +74,8 @@ static int ce6230_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 	ret = usb_control_msg(d->udev, pipe, request, requesttype, value, index,
 			buf, req->data_len, CE6230_USB_TIMEOUT);
 
-	ce6230_debug_dump(request, requesttype, value, index, buf,
-			req->data_len);
+	dvb_usb_dbg_usb_control_msg(d->udev, request, requesttype, value, index,
+			buf, req->data_len);
 
 	if (ret < 0)
 		pr_err("%s: usb_control_msg() failed=%d\n", KBUILD_MODNAME,
diff --git a/drivers/media/usb/dvb-usb-v2/ce6230.h b/drivers/media/usb/dvb-usb-v2/ce6230.h
index 42d7544..299e57e 100644
--- a/drivers/media/usb/dvb-usb-v2/ce6230.h
+++ b/drivers/media/usb/dvb-usb-v2/ce6230.h
@@ -26,17 +26,6 @@
 #include "zl10353.h"
 #include "mxl5005s.h"
 
-#define ce6230_debug_dump(r, t, v, i, b, l) { \
-	char *direction; \
-	if (t == (USB_TYPE_VENDOR | USB_DIR_OUT)) \
-		direction = ">>>"; \
-	else \
-		direction = "<<<"; \
-	pr_debug("%s: %02x %02x %02x %02x %02x %02x %02x %02x %s [%d bytes]\n", \
-			 __func__, t, r, v & 0xff, v >> 8, i & 0xff, i >> 8, \
-			l & 0xff, l >> 8, direction, l); \
-}
-
 #define CE6230_USB_TIMEOUT 1000
 
 struct usb_req {
diff --git a/drivers/media/usb/dvb-usb-v2/ec168.c b/drivers/media/usb/dvb-usb-v2/ec168.c
index ab77622..b74c810 100644
--- a/drivers/media/usb/dvb-usb-v2/ec168.c
+++ b/drivers/media/usb/dvb-usb-v2/ec168.c
@@ -86,8 +86,8 @@ static int ec168_ctrl_msg(struct dvb_usb_device *d, struct ec168_req *req)
 	ret = usb_control_msg(d->udev, pipe, request, requesttype, req->value,
 		req->index, buf, req->size, EC168_USB_TIMEOUT);
 
-	ec168_debug_dump(request, requesttype, req->value, req->index, buf,
-		req->size);
+	dvb_usb_dbg_usb_control_msg(d->udev, request, requesttype, req->value,
+			req->index, buf, req->size);
 
 	if (ret < 0)
 		goto err_dealloc;
diff --git a/drivers/media/usb/dvb-usb-v2/ec168.h b/drivers/media/usb/dvb-usb-v2/ec168.h
index 9181236..f651808 100644
--- a/drivers/media/usb/dvb-usb-v2/ec168.h
+++ b/drivers/media/usb/dvb-usb-v2/ec168.h
@@ -24,17 +24,6 @@
 
 #include "dvb_usb.h"
 
-#define ec168_debug_dump(r, t, v, i, b, l) { \
-	char *direction; \
-	if (t == (USB_TYPE_VENDOR | USB_DIR_OUT)) \
-		direction = ">>>"; \
-	else \
-		direction = "<<<"; \
-	pr_debug("%s: %02x %02x %02x %02x %02x %02x %02x %02x %s\n", \
-			 __func__, t, r, v & 0xff, v >> 8, i & 0xff, i >> 8, \
-			l & 0xff, l >> 8, direction); \
-}
-
 #define EC168_USB_TIMEOUT 1000
 
 struct ec168_req {
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c246c50..e29fca2 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -59,11 +59,13 @@ static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
 
 	ret = usb_control_msg(d->udev, pipe, 0, requesttype, req->value,
 			req->index, buf, req->size, 1000);
+
+	dvb_usb_dbg_usb_control_msg(d->udev, 0, requesttype, req->value,
+			req->index, buf, req->size);
+
 	if (ret > 0)
 		ret = 0;
 
-	deb_dump(0, requesttype, req->value, req->index, buf, req->size);
-
 	/* read request, copy returned data to return buf */
 	if (!ret && requesttype == (USB_TYPE_VENDOR | USB_DIR_IN))
 		memcpy(req->data, buf, req->size);
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 575edbf..035a9c8 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -24,17 +24,6 @@
 
 #include "dvb_usb.h"
 
-#define deb_dump(r, t, v, i, b, l) { \
-	char *direction; \
-	if (t == (USB_TYPE_VENDOR | USB_DIR_OUT)) \
-		direction = ">>>"; \
-	else \
-		direction = "<<<"; \
-	dev_dbg(&d->udev->dev, "%s: %02x %02x %02x %02x %02x %02x %02x %02x " \
-			"%s [%d bytes]\n",  __func__, t, r, v & 0xff, v >> 8, \
-			i & 0xff, i >> 8, l & 0xff, l >> 8, direction, l); \
-}
-
 /*
  * USB commands
  * (usb_control_msg() index parameter)
-- 
1.7.11.4

