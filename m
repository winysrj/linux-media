Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44327 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1L3WsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 17:48:08 -0500
Received: by wibhm6 with SMTP id hm6so7241435wib.19
        for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 14:48:07 -0800 (PST)
Message-ID: <1325285280.3682.1.camel@tvbox>
Subject: [PATCH] it913x ver 1.18 Turn pid filter off by caps option only.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Fri, 30 Dec 2011 22:48:00 +0000
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
 drivers/media/dvb/dvb-usb/it913x.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 9290bd8..8d1cfac 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -280,9 +280,6 @@ static int it913x_pid_filter(struct dvb_usb_adapter *adap,
 	int ret = 0;
 	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
 
-	if (pid_filter > 0)
-		return 0;
-
 	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
 			return -EAGAIN;
 	deb_info(1, "PID_F  (%02x)", onoff);
@@ -475,17 +472,23 @@ static int it913x_identify_state(struct usb_device *udev,
 	info("Dual mode=%x Remote=%x Tuner Type=%x", it913x_config.dual_mode
 		, remote, it913x_config.tuner_id_0);
 
-	/* Select Stream Buffer Size */
-	if (pid_filter)
+	/* Select Stream Buffer Size and pid filter option*/
+	if (pid_filter) {
 		props->adapter[0].fe[0].stream.u.bulk.buffersize =
 			TS_BUFFER_SIZE_MAX;
-	else
+		props->adapter[0].fe[0].caps &=
+			~DVB_USB_ADAP_NEED_PID_FILTERING;
+	} else
 		props->adapter[0].fe[0].stream.u.bulk.buffersize =
 			TS_BUFFER_SIZE_PID;
+
 	if (it913x_config.dual_mode) {
 		props->adapter[1].fe[0].stream.u.bulk.buffersize =
 			props->adapter[0].fe[0].stream.u.bulk.buffersize;
 		props->num_adapters = 2;
+		if (pid_filter)
+			props->adapter[1].fe[0].caps =
+				props->adapter[0].fe[0].caps;
 	} else
 		props->num_adapters = 1;
 
@@ -841,5 +844,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.17");
+MODULE_VERSION("1.18");
 MODULE_LICENSE("GPL");
-- 
1.7.7.3


