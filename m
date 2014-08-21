Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47381 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbaHUO1T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 10:27:19 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] dvb-usb-v2: remove dvb_usb_device NULL check
Date: Thu, 21 Aug 2014 17:27:03 +0300
Message-Id: <1408631223-24697-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported by Dan Carpenter:

The patch d10d1b9ac97b: "[media] dvb_usb_v2: use dev_* logging
macros" from Jun 26, 2012, leads to the following Smatch complaint:

drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c:31 dvb_usb_v2_generic_io()
	 error: we previously assumed 'd' could be null (see line 29)

...
Remove whole check as it must not happen in any case. Driver is
totally broken if it does not have valid pointer to device.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
index 33ff97e..22bdce1 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
@@ -26,7 +26,7 @@ static int dvb_usb_v2_generic_io(struct dvb_usb_device *d,
 {
 	int ret, actual_length;
 
-	if (!d || !wbuf || !wlen || !d->props->generic_bulk_ctrl_endpoint ||
+	if (!wbuf || !wlen || !d->props->generic_bulk_ctrl_endpoint ||
 			!d->props->generic_bulk_ctrl_endpoint_response) {
 		dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, -EINVAL);
 		return -EINVAL;
-- 
http://palosaari.fi/

