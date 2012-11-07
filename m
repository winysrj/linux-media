Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43603 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2KGXRN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Nov 2012 18:17:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] dvb_usb_v2: switch interruptible mutex to normal
Date: Thu,  8 Nov 2012 01:16:40 +0200
Message-Id: <1352330200-4850-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes error: dvb_usb_v2: pid_filter() failed=-4

error code -4 is EINTR, Interrupted system call

That error blocks I/O in some cases as -EINTR error was returned
by the mutex which was protecting USB control messages. We want
configure hardware to sleep mode on every case after tuning is
stopped. That kind of behavior is blocks it, leaving hardware some
unwanted state in worst case.

That error was seen every time when af9015 was plugged to USB1.1
which leads use of hardware PID filters. Stop tuning (tzap) with
ctrl+c failed as driver tries to remove hardware PID filters.

Tested with every hardware which uses routine in question.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
index 0431bee..5716662 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
@@ -32,9 +32,7 @@ int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
 		return -EINVAL;
 	}
 
-	ret = mutex_lock_interruptible(&d->usb_mutex);
-	if (ret < 0)
-		return ret;
+	mutex_lock(&d->usb_mutex);
 
 	dev_dbg(&d->udev->dev, "%s: >>> %*ph\n", __func__, wlen, wbuf);
 
-- 
1.7.11.7

