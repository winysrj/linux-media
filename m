Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50760 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab1DVJHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2011 05:07:48 -0400
Received: by wya21 with SMTP id 21so319193wya.19
        for <linux-media@vger.kernel.org>; Fri, 22 Apr 2011 02:07:47 -0700 (PDT)
Subject: [PATCH 1/2] [BUG]DM04/QQBOX v1.85 usb_buffer and mutex.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 10:07:40 +0100
Message-ID: <1303463260.2525.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

usb_buffer not inside mutex lock, waiting caller can alter buffer.
 Static added to lme2510_exit and lme2510_exit_int.
 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/media/dvb/dvb-usb/lmedm04.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 4e5c521..aa9a6ff 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -169,14 +169,14 @@ static int lme2510_usb_talk(struct dvb_usb_device *d,
 	}
 	buff = st->usb_buffer;
 
-	/* the read/write capped at 512 */
-	memcpy(buff, wbuf, (wlen > 512) ? 512 : wlen);
-
 	ret = mutex_lock_interruptible(&d->usb_mutex);
 
 	if (ret < 0)
 		return -EAGAIN;
 
+	/* the read/write capped at 512 */
+	memcpy(buff, wbuf, (wlen > 512) ? 512 : wlen);
+
 	ret |= usb_clear_halt(d->udev, usb_sndbulkpipe(d->udev, 0x01));
 
 	ret |= lme2510_bulk_write(d->udev, buff, wlen , 0x01);
@@ -1234,7 +1234,7 @@ static struct dvb_usb_device_properties lme2510c_properties = {
 	}
 };
 
-void *lme2510_exit_int(struct dvb_usb_device *d)
+static void *lme2510_exit_int(struct dvb_usb_device *d)
 {
 	struct lme2510_state *st = d->priv;
 	struct dvb_usb_adapter *adap = &d->adapter[0];
@@ -1261,7 +1261,7 @@ void *lme2510_exit_int(struct dvb_usb_device *d)
 	return buffer;
 }
 
-void lme2510_exit(struct usb_interface *intf)
+static void lme2510_exit(struct usb_interface *intf)
 {
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
 	void *usb_buffer;
@@ -1303,5 +1303,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.84");
+MODULE_VERSION("1.85");
 MODULE_LICENSE("GPL");
-- 
1.7.4.1

