Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48053 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2BLLbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Feb 2012 06:31:50 -0500
Received: by werb13 with SMTP id b13so2918306wer.19
        for <linux-media@vger.kernel.org>; Sun, 12 Feb 2012 03:31:49 -0800 (PST)
Message-ID: <1329046301.2773.10.camel@tvbox>
Subject: [PATCH] it913x ver 1.27 Allow PID 8192 to turn PID filter off
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 12 Feb 2012 11:31:41 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow PID 8192 to turn PID filter off in USB high speed.

The PID number is still written to the PID index and will only
turn on again if that index is set to 0.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index bfadf12..cfa415b 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -64,6 +64,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 struct it913x_state {
 	u8 id;
 	struct ite_config it913x_config;
+	u8 pid_filter_onoff;
 };
 
 struct ite_config it913x_config;
@@ -259,6 +260,7 @@ static u32 it913x_query(struct usb_device *udev, u8 pro)
 
 static int it913x_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
+	struct it913x_state *st = adap->dev->priv;
 	struct usb_device *udev = adap->dev->udev;
 	int ret;
 	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
@@ -267,7 +269,7 @@ static int it913x_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 	deb_info(1, "PID_C  (%02x)", onoff);
 
-	ret = it913x_wr_reg(udev, pro, PID_EN, onoff);
+	ret = it913x_wr_reg(udev, pro, PID_EN, st->pid_filter_onoff);
 
 	mutex_unlock(&adap->dev->i2c_mutex);
 	return ret;
@@ -276,6 +278,7 @@ static int it913x_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 static int it913x_pid_filter(struct dvb_usb_adapter *adap,
 		int index, u16 pid, int onoff)
 {
+	struct it913x_state *st = adap->dev->priv;
 	struct usb_device *udev = adap->dev->udev;
 	int ret;
 	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
@@ -292,6 +295,13 @@ static int it913x_pid_filter(struct dvb_usb_adapter *adap,
 
 	ret |= it913x_wr_reg(udev, pro, PID_INX, (u8)(index & 0x1f));
 
+	if (udev->speed == USB_SPEED_HIGH && pid == 0x2000) {
+			ret |= it913x_wr_reg(udev, pro, PID_EN, !onoff);
+			st->pid_filter_onoff = !onoff;
+	} else
+		st->pid_filter_onoff =
+			adap->fe_adap[adap->active_fe].pid_filtering;
+
 	mutex_unlock(&adap->dev->i2c_mutex);
 	return 0;
 }
@@ -599,6 +609,7 @@ static int it913x_identify_state(struct usb_device *udev,
 
 static int it913x_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
+	struct it913x_state *st = adap->dev->priv;
 	int ret = 0;
 	u8 pro = (adap->id == 0) ? DEV_0_DMOD : DEV_1_DMOD;
 
@@ -610,6 +621,9 @@ static int it913x_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 		ret = it913x_wr_reg(adap->dev->udev, pro, PID_RST, 0x1);
 
 		mutex_unlock(&adap->dev->i2c_mutex);
+		st->pid_filter_onoff =
+			adap->fe_adap[adap->active_fe].pid_filtering;
+
 	}
 
 	return ret;
@@ -884,5 +898,5 @@ module_usb_driver(it913x_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.26");
+MODULE_VERSION("1.27");
 MODULE_LICENSE("GPL");
-- 
1.7.8.3



