Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57888 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2BLL3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Feb 2012 06:29:48 -0500
Received: by wgbdt10 with SMTP id dt10so4046608wgb.1
        for <linux-media@vger.kernel.org>; Sun, 12 Feb 2012 03:29:47 -0800 (PST)
Message-ID: <1329046178.2773.9.camel@tvbox>
Subject: [PATCH] it913x ver 1.26 change to remove interruptible mutex locks.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 12 Feb 2012 11:29:38 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some virtual I2C commands are missed along some PID filtering
commands resulting complete stall of driver.

Since dvb-usb cannot handle the -EAGAIN error and commands
generally should not be missed mutex_lock is used instead.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 2560652..bfadf12 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -263,8 +263,8 @@ static int it913x_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	int ret;
 	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
 
-	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
-			return -EAGAIN;
+	mutex_lock(&adap->dev->i2c_mutex);
+
 	deb_info(1, "PID_C  (%02x)", onoff);
 
 	ret = it913x_wr_reg(udev, pro, PID_EN, onoff);
@@ -280,8 +280,8 @@ static int it913x_pid_filter(struct dvb_usb_adapter *adap,
 	int ret;
 	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
 
-	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
-			return -EAGAIN;
+	mutex_lock(&adap->dev->i2c_mutex);
+
 	deb_info(1, "PID_F  (%02x)", onoff);
 
 	ret = it913x_wr_reg(udev, pro, PID_LSB, (u8)(pid & 0xff));
@@ -316,8 +316,8 @@ static int it913x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	int ret;
 	u32 reg;
 	u8 pro;
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-			return -EAGAIN;
+
+	mutex_lock(&d->i2c_mutex);
 
 	debug_data_snipet(1, "Message out", msg[0].buf);
 	deb_info(2, "num of messages %d address %02x", num, msg[0].addr);
@@ -358,8 +358,7 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 	int ret;
 	u32 key;
 	/* Avoid conflict with frontends*/
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-			return -EAGAIN;
+	mutex_lock(&d->i2c_mutex);
 
 	ret = it913x_io(d->udev, READ_LONG, PRO_LINK, CMD_IR_GET,
 		0, 0, &ibuf[0], sizeof(ibuf));
@@ -603,15 +602,15 @@ static int it913x_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	int ret = 0;
 	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
 
-	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
-			return -EAGAIN;
 	deb_info(1, "STM  (%02x)", onoff);
 
-	if (!onoff)
-		ret = it913x_wr_reg(adap->dev->udev, pro, PID_RST, 0x1);
+	if (!onoff) {
+		mutex_lock(&adap->dev->i2c_mutex);
 
+		ret = it913x_wr_reg(adap->dev->udev, pro, PID_RST, 0x1);
 
-	mutex_unlock(&adap->dev->i2c_mutex);
+		mutex_unlock(&adap->dev->i2c_mutex);
+	}
 
 	return ret;
 }
@@ -885,5 +884,5 @@ module_usb_driver(it913x_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.25");
+MODULE_VERSION("1.26");
 MODULE_LICENSE("GPL");
-- 
1.7.8.3



