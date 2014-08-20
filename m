Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3127 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaHTW7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/29] dw2102: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:05 +0200
Message-Id: <1408575568-20562-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/dvb-usb/dw2102.c:670:65: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dw2102.c:1601:32: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dw2102.c:1644:40: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dw2102.c:1644:40: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dw2102.c:1644:40: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dw2102.c:1644:40: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dw2102.c:1644:40: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dw2102.c:1644:40: warning: restricted __le16 degrades to integer
drivers/media/usb/dvb-usb/dw2102.c:1904:34: warning: symbol 'p1100' was not declared. Should it be static?
drivers/media/usb/dvb-usb/dw2102.c:1911:34: warning: symbol 's660' was not declared. Should it be static?
drivers/media/usb/dvb-usb/dw2102.c:1930:34: warning: symbol 'p7500' was not declared. Should it be static?
drivers/media/usb/dvb-usb/dw2102.c:1937:34: warning: symbol 's421' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/dvb-usb/dw2102.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 2add8c5..1a3df10 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -667,7 +667,7 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				obuf[1] = (msg[j].addr << 1);
 				memcpy(obuf + 2, msg[j].buf, msg[j].len);
 				dw210x_op_rw(d->udev,
-						udev->descriptor.idProduct ==
+						le16_to_cpu(udev->descriptor.idProduct) ==
 						0x7500 ? 0x92 : 0x90, 0, 0,
 						obuf, msg[j].len + 2,
 						DW210X_WRITE_MSG);
@@ -1598,7 +1598,7 @@ static int dw2102_load_firmware(struct usb_device *dev,
 	u8 reset16[] = {0, 0, 0, 0, 0, 0, 0};
 	const struct firmware *fw;
 
-	switch (dev->descriptor.idProduct) {
+	switch (le16_to_cpu(dev->descriptor.idProduct)) {
 	case 0x2101:
 		ret = request_firmware(&fw, DW2101_FIRMWARE, &dev->dev);
 		if (ret != 0) {
@@ -1641,7 +1641,7 @@ static int dw2102_load_firmware(struct usb_device *dev,
 			ret = -EINVAL;
 		}
 		/* init registers */
-		switch (dev->descriptor.idProduct) {
+		switch (le16_to_cpu(dev->descriptor.idProduct)) {
 		case USB_PID_TEVII_S650:
 			dw2104_properties.rc.core.rc_codes = RC_MAP_TEVII_NEC;
 		case USB_PID_DW2104:
@@ -1901,14 +1901,14 @@ static struct dvb_usb_device_properties s6x0_properties = {
 	}
 };
 
-struct dvb_usb_device_properties *p1100;
+static struct dvb_usb_device_properties *p1100;
 static struct dvb_usb_device_description d1100 = {
 	"Prof 1100 USB ",
 	{&dw2102_table[PROF_1100], NULL},
 	{NULL},
 };
 
-struct dvb_usb_device_properties *s660;
+static struct dvb_usb_device_properties *s660;
 static struct dvb_usb_device_description d660 = {
 	"TeVii S660 USB",
 	{&dw2102_table[TEVII_S660], NULL},
@@ -1927,14 +1927,14 @@ static struct dvb_usb_device_description d480_2 = {
 	{NULL},
 };
 
-struct dvb_usb_device_properties *p7500;
+static struct dvb_usb_device_properties *p7500;
 static struct dvb_usb_device_description d7500 = {
 	"Prof 7500 USB DVB-S2",
 	{&dw2102_table[PROF_7500], NULL},
 	{NULL},
 };
 
-struct dvb_usb_device_properties *s421;
+static struct dvb_usb_device_properties *s421;
 static struct dvb_usb_device_description d421 = {
 	"TeVii S421 PCI",
 	{&dw2102_table[TEVII_S421], NULL},
-- 
2.1.0.rc1

