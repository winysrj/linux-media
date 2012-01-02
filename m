Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62106 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2ABSqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 13:46:46 -0500
Received: by wgbdr13 with SMTP id dr13so26886108wgb.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 10:46:45 -0800 (PST)
Message-ID: <1325529992.32180.8.camel@tvbox>
Subject: [PATCH] [BUG] it913x ver 1.20. PID filter problems.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 02 Jan 2012 18:46:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes issues with PID filter
Stalling of some channels when PID is on.
PID filter not turning off fully.
PID filter can now turn on and off each index.

Removed PID_RST from it913x_pid_filter_ctrl.
Replaced with PID_EN removed from it913x_pid_filter

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 8d1cfac..ad7013c 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -259,15 +259,15 @@ static u32 it913x_query(struct usb_device *udev, u8 pro)
 
 static int it913x_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
-	int ret = 0;
+	struct usb_device *udev = adap->dev->udev;
+	int ret;
 	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
 
 	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
 			return -EAGAIN;
 	deb_info(1, "PID_C  (%02x)", onoff);
 
-	if (!onoff)
-		ret = it913x_wr_reg(adap->dev->udev, pro, PID_RST, 0x1);
+	ret = it913x_wr_reg(udev, pro, PID_EN, onoff);
 
 	mutex_unlock(&adap->dev->i2c_mutex);
 	return ret;
@@ -277,24 +277,20 @@ static int it913x_pid_filter(struct dvb_usb_adapter *adap,
 		int index, u16 pid, int onoff)
 {
 	struct usb_device *udev = adap->dev->udev;
-	int ret = 0;
+	int ret;
 	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
 
 	if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
 			return -EAGAIN;
 	deb_info(1, "PID_F  (%02x)", onoff);
-	if (onoff) {
-		ret = it913x_wr_reg(udev, pro, PID_EN, 0x1);
 
-		ret |= it913x_wr_reg(udev, pro, PID_LSB, (u8)(pid & 0xff));
+	ret = it913x_wr_reg(udev, pro, PID_LSB, (u8)(pid & 0xff));
 
-		ret |= it913x_wr_reg(udev, pro, PID_MSB, (u8)(pid >> 8));
+	ret |= it913x_wr_reg(udev, pro, PID_MSB, (u8)(pid >> 8));
 
-		ret |= it913x_wr_reg(udev, pro, PID_INX_EN, (u8)onoff);
+	ret |= it913x_wr_reg(udev, pro, PID_INX_EN, (u8)onoff);
 
-		ret |= it913x_wr_reg(udev, pro, PID_INX, (u8)(index & 0x1f));
-
-	}
+	ret |= it913x_wr_reg(udev, pro, PID_INX, (u8)(index & 0x1f));
 
 	mutex_unlock(&adap->dev->i2c_mutex);
 	return 0;
@@ -844,5 +840,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.18");
+MODULE_VERSION("1.20");
 MODULE_LICENSE("GPL");
-- 
1.7.7.3



