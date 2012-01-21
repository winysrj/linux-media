Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab2AUQEr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:47 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4k6g017809
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 35/35] [media] az6007: CodingStyle fixes
Date: Sat, 21 Jan 2012 14:04:37 -0200
Message-Id: <1327161877-16784-36-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-35-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
 <1327161877-16784-10-git-send-email-mchehab@redhat.com>
 <1327161877-16784-11-git-send-email-mchehab@redhat.com>
 <1327161877-16784-12-git-send-email-mchehab@redhat.com>
 <1327161877-16784-13-git-send-email-mchehab@redhat.com>
 <1327161877-16784-14-git-send-email-mchehab@redhat.com>
 <1327161877-16784-15-git-send-email-mchehab@redhat.com>
 <1327161877-16784-16-git-send-email-mchehab@redhat.com>
 <1327161877-16784-17-git-send-email-mchehab@redhat.com>
 <1327161877-16784-18-git-send-email-mchehab@redhat.com>
 <1327161877-16784-19-git-send-email-mchehab@redhat.com>
 <1327161877-16784-20-git-send-email-mchehab@redhat.com>
 <1327161877-16784-21-git-send-email-mchehab@redhat.com>
 <1327161877-16784-22-git-send-email-mchehab@redhat.com>
 <1327161877-16784-23-git-send-email-mchehab@redhat.com>
 <1327161877-16784-24-git-send-email-mchehab@redhat.com>
 <1327161877-16784-25-git-send-email-mchehab@redhat.com>
 <1327161877-16784-26-git-send-email-mchehab@redhat.com>
 <1327161877-16784-27-git-send-email-mchehab@redhat.com>
 <1327161877-16784-28-git-send-email-mchehab@redhat.com>
 <1327161877-16784-29-git-send-email-mchehab@redhat.com>
 <1327161877-16784-30-git-send-email-mchehab@redhat.com>
 <1327161877-16784-31-git-send-email-mchehab@redhat.com>
 <1327161877-16784-32-git-send-email-mchehab@redhat.com>
 <1327161877-16784-33-git-send-email-mchehab@redhat.com>
 <1327161877-16784-34-git-send-email-mchehab@redhat.com>
 <1327161877-16784-35-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 14733b8..02efd94 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -211,9 +211,7 @@ static int az6007_rc_query(struct dvb_usb_device *d)
 	if ((st->data[3] ^ st->data[4]) == 0xff)
 		code = code << 8 | st->data[3];
 	else
-		code = code << 16 | st->data[3] << 8| st->data[4];
-
-	printk("remote query key: %04x\n", code);
+		code = code << 16 | st->data[3] << 8 | st->data[4];
 
 	rc_keydown(d->rc_dev, code, st->data[5]);
 
@@ -302,11 +300,11 @@ int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 		ret = az6007_write(d, FX2_SCON1, 0, 3, NULL, 0);
 		if (ret < 0)
 			return ret;
-		msleep (150);
+		msleep(150);
 		ret = az6007_write(d, FX2_SCON1, 1, 3, NULL, 0);
 		if (ret < 0)
 			return ret;
-		msleep (430);
+		msleep(430);
 		ret = az6007_write(d, AZ6007_POWER, 0, 0, NULL, 0);
 		if (ret < 0)
 			return ret;
@@ -362,8 +360,8 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr | (1 << 8);
 			length = 6 + msgs[i + 1].len;
 			len = msgs[i + 1].len;
-			ret = __az6007_read(d->udev, req, value, index, st->data,
-					       length);
+			ret = __az6007_read(d->udev, req, value, index,
+					    st->data, length);
 			if (ret >= len) {
 				for (j = 0; j < len; j++) {
 					msgs[i + 1].buf[j] = st->data[j + 5];
@@ -391,10 +389,11 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			for (j = 0; j < len; j++) {
 				st->data[j] = msgs[i].buf[j + 1];
 				if (dvb_usb_az6007_debug & 2)
-					printk(KERN_CONT "0x%02x ", st->data[j]);
+					printk(KERN_CONT "0x%02x ",
+					       st->data[j]);
 			}
-			ret =  __az6007_write(d->udev, req, value, index, st->data,
-						 length);
+			ret =  __az6007_write(d->udev, req, value, index,
+					      st->data, length);
 		} else {
 			/* read bytes */
 			if (dvb_usb_az6007_debug & 2)
@@ -406,8 +405,8 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr;
 			length = msgs[i].len + 6;
 			len = msgs[i].len;
-			ret = __az6007_read(d->udev, req, value, index, st->data,
-					       length);
+			ret = __az6007_read(d->udev, req, value, index,
+					    st->data, length);
 			for (j = 0; j < len; j++) {
 				msgs[i].buf[j] = st->data[j + 5];
 				if (dvb_usb_az6007_debug & 2)
@@ -466,7 +465,7 @@ int az6007_identify_state(struct usb_device *udev,
 		__az6007_write(udev, 0x00, 0, 0, NULL, 0);
 	}
 
-	deb_info("Device is on %s state\n", *cold? "warm" : "cold");
+	deb_info("Device is on %s state\n", *cold ? "warm" : "cold");
 	return 0;
 }
 
@@ -514,7 +513,7 @@ static struct dvb_usb_device_properties az6007_properties = {
 					}
 				}
 			},
-		}}
+		} }
 	} },
 	.power_ctrl       = az6007_power_ctrl,
 	.read_mac_address = az6007_read_mac_addr,
-- 
1.7.8

