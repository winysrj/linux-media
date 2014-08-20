Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4564 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaHTW7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/29] dibusb: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:02 +0200
Message-Id: <1408575568-20562-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/dvb-usb/dibusb-common.c:261:40: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dibusb-common.c:262:52: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dibusb-common.c:300:40: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dibusb-common.c:301:44: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dibusb-common.c:313:47: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dibusb-common.c:314:47: warning: restricted __le16 degrades to integer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/dvb-usb/dibusb-common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index 6d68af0..ef3a8f7 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -258,8 +258,8 @@ static struct dib3000mc_config mod3000p_dib3000p_config = {
 
 int dibusb_dib3000mc_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	if (adap->dev->udev->descriptor.idVendor  == USB_VID_LITEON &&
-			adap->dev->udev->descriptor.idProduct ==
+	if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_LITEON &&
+	    le16_to_cpu(adap->dev->udev->descriptor.idProduct) ==
 			USB_PID_LITEON_DVB_T_WARM) {
 		msleep(1000);
 	}
@@ -297,8 +297,8 @@ int dibusb_dib3000mc_tuner_attach(struct dvb_usb_adapter *adap)
 	struct i2c_adapter *tun_i2c;
 
 	// First IF calibration for Liteon Sticks
-	if (adap->dev->udev->descriptor.idVendor  == USB_VID_LITEON &&
-		adap->dev->udev->descriptor.idProduct == USB_PID_LITEON_DVB_T_WARM) {
+	if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_LITEON &&
+	    le16_to_cpu(adap->dev->udev->descriptor.idProduct) == USB_PID_LITEON_DVB_T_WARM) {
 
 		dibusb_read_eeprom_byte(adap->dev,0x7E,&a);
 		dibusb_read_eeprom_byte(adap->dev,0x7F,&b);
@@ -310,8 +310,8 @@ int dibusb_dib3000mc_tuner_attach(struct dvb_usb_adapter *adap)
 		else
 			warn("LITE-ON DVB-T: Strange IF1 calibration :%2X %2X\n", a, b);
 
-	} else if (adap->dev->udev->descriptor.idVendor  == USB_VID_DIBCOM &&
-		   adap->dev->udev->descriptor.idProduct == USB_PID_DIBCOM_MOD3001_WARM) {
+	} else if (le16_to_cpu(adap->dev->udev->descriptor.idVendor) == USB_VID_DIBCOM &&
+		   le16_to_cpu(adap->dev->udev->descriptor.idProduct) == USB_PID_DIBCOM_MOD3001_WARM) {
 		u8 desc;
 		dibusb_read_eeprom_byte(adap->dev, 7, &desc);
 		if (desc == 2) {
-- 
2.1.0.rc1

