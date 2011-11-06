Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41347 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab1KFOYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 09:24:37 -0500
Received: by wyh15 with SMTP id 15so3652249wyh.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 06:24:36 -0800 (PST)
Message-ID: <4eb698a3.4dc6e30a.54d4.fffff6e9@mx.google.com>
Subject: [PATCH] it913x ver 1.09 support for USB 1 devices (IT9135)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 06 Nov 2011 14:24:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IT9135 devices do support USB 1.
Support added with restricton on pid count to 5.
IT9137 devices wil not connect in USB 1 mode.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index a541904..d4739d1 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -350,6 +350,19 @@ static int it913x_identify_state(struct usb_device *udev,
 	/* checnk for dual mode */
 	it913x_config.dual_mode =  it913x_read_reg(udev, 0x49c5);
 
+	if (udev->speed != USB_SPEED_HIGH) {
+		props->adapter[0].fe[0].pid_filter_count = 5;
+		info("USB 1 low speed mode - connect to USB 2 port");
+		if (pid_filter > 0)
+			pid_filter = 0;
+		if (it913x_config.dual_mode) {
+			it913x_config.dual_mode = 0;
+			info("Dual mode not supported in USB 1");
+		}
+	} else /* For replugging */
+		if(props->adapter[0].fe[0].pid_filter_count == 5)
+			props->adapter[0].fe[0].pid_filter_count = 31;
+
 	/* TODO different remotes */
 	remote = it913x_read_reg(udev, 0x49ac); /* Remote */
 	if (remote == 0)
@@ -499,6 +512,10 @@ static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
 	int ret = 0;
 	u8 adap_addr = I2C_BASE_ADDR + (adap->id << 5);
 	u16 ep_size = adap->props.fe[0].stream.u.bulk.buffersize;
+	u8 pkt_size = 0x80;
+
+	if (adap->dev->udev->speed != USB_SPEED_HIGH)
+		pkt_size = 0x10;
 
 	it913x_config.adf = it913x_read_reg(udev, IO_MUX_POWER_CLK);
 
@@ -514,13 +531,13 @@ static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
 		ret = it913x_wr_reg(udev, DEV_0, EP4_TX_LEN_LSB,
 					ep_size & 0xff);
 		ret = it913x_wr_reg(udev, DEV_0, EP4_TX_LEN_MSB, ep_size >> 8);
-		ret = it913x_wr_reg(udev, DEV_0, EP4_MAX_PKT, 0x80);
+		ret = it913x_wr_reg(udev, DEV_0, EP4_MAX_PKT, pkt_size);
 	} else if (adap->id == 1 && adap->fe_adap[0].fe) {
 		ret = it913x_wr_reg(udev, DEV_0, EP0_TX_EN, 0x6f);
 		ret = it913x_wr_reg(udev, DEV_0, EP5_TX_LEN_LSB,
 					ep_size & 0xff);
 		ret = it913x_wr_reg(udev, DEV_0, EP5_TX_LEN_MSB, ep_size >> 8);
-		ret = it913x_wr_reg(udev, DEV_0, EP5_MAX_PKT, 0x80);
+		ret = it913x_wr_reg(udev, DEV_0, EP5_MAX_PKT, pkt_size);
 		ret = it913x_wr_reg(udev, DEV_0_DMOD, MP2IF2_EN, 0x1);
 		ret = it913x_wr_reg(udev, DEV_1_DMOD, MP2IF_SERIAL, 0x1);
 		ret = it913x_wr_reg(udev, DEV_1, TOP_HOSTB_SER_MODE, 0x1);
@@ -676,5 +693,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.08");
+MODULE_VERSION("1.09");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4


