Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53547 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1L3PdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:33:13 -0500
Received: by wgbdr13 with SMTP id dr13so24437921wgb.1
        for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 07:33:12 -0800 (PST)
Message-ID: <1325259183.10828.1.camel@tvbox>
Subject: [PATCH] lmedm04 DM04/QQBOX ver 1.91 turn pid filter off by caps
 option only
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Fri, 30 Dec 2011 15:33:03 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Turn the pid filter off by caps option only.

This is so the full stream is passed to demuxer and not limited
by pid count.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index b922824..767c87f 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -388,8 +388,7 @@ static int lme2510_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 	deb_info(3, "%s PID=%04x Index=%04x onoff=%02x", __func__,
 		pid, index, onoff);
 
-	if (onoff)
-		if (!pid_filter) {
+	if (onoff) {
 			ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
 			if (ret < 0)
 				return -EAGAIN;
@@ -654,6 +653,9 @@ static int lme2510_identify_state(struct usb_device *udev,
 		struct dvb_usb_device_description **desc,
 		int *cold)
 {
+	if (pid_filter > 0)
+		props->adapter[0].fe[0].caps &=
+			~DVB_USB_ADAP_NEED_PID_FILTERING;
 	*cold = 0;
 	return 0;
 }
@@ -1312,5 +1314,5 @@ module_exit(lme2510_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
-MODULE_VERSION("1.90");
+MODULE_VERSION("1.91");
 MODULE_LICENSE("GPL");
-- 
1.7.7.3


