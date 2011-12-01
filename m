Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65336 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab1LAVf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 16:35:56 -0500
Received: by eaak14 with SMTP id k14so2666282eaa.19
        for <linux-media@vger.kernel.org>; Thu, 01 Dec 2011 13:35:55 -0800 (PST)
Message-ID: <1322775348.2261.6.camel@tvbox>
Subject: [PATCH] it913x add retry to USB bulk endpoints and IO.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Thu, 01 Dec 2011 21:35:48 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This a bus repeater for it913x devices. Commands usually fail because of other
activity on the USB bus.

Bulk failures that report -ETIMEDOUT or -EBUSY are repeated.

Enpoints that return actlen not equal len request -EAGAIN.

The retry is set at 10.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   61 +++++++++++++++++++++++++++++------
 1 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index d7c86c2..e847527 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -67,23 +67,43 @@ struct it913x_state {
 
 struct ite_config it913x_config;
 
+#define IT913X_RETRY	10
+#define IT913X_SND_TIMEOUT	100
+#define IT913X_RCV_TIMEOUT	200
+
 static int it913x_bulk_write(struct usb_device *dev,
 				u8 *snd, int len, u8 pipe)
 {
-	int ret, actual_l;
+	int ret, actual_l, i;
+
+	for (i = 0; i < IT913X_RETRY; i++) {
+		ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, pipe),
+				snd, len , &actual_l, IT913X_SND_TIMEOUT);
+		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
+			break;
+	}
+
+	if (len != actual_l && ret == 0)
+		ret = -EAGAIN;
 
-	ret = usb_bulk_msg(dev, usb_sndbulkpipe(dev, pipe),
-				snd, len , &actual_l, 100);
 	return ret;
 }
 
 static int it913x_bulk_read(struct usb_device *dev,
 				u8 *rev, int len, u8 pipe)
 {
-	int ret, actual_l;
+	int ret, actual_l, i;
+
+	for (i = 0; i < IT913X_RETRY; i++) {
+		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, pipe),
+				 rev, len , &actual_l, IT913X_RCV_TIMEOUT);
+		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
+			break;
+	}
+
+	if (len != actual_l && ret == 0)
+		ret = -EAGAIN;
 
-	ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, pipe),
-				 rev, len , &actual_l, 200);
 	return ret;
 }
 
@@ -96,7 +116,7 @@ static u16 check_sum(u8 *p, u8 len)
 	return ~sum;
 }
 
-static int it913x_io(struct usb_device *udev, u8 mode, u8 pro,
+static int it913x_usb_talk(struct usb_device *udev, u8 mode, u8 pro,
 			u8 cmd, u32 reg, u8 addr, u8 *data, u8 len)
 {
 	int ret = 0, i, buf_size = 1;
@@ -155,22 +175,41 @@ static int it913x_io(struct usb_device *udev, u8 mode, u8 pro,
 	buff[buf_size++] = (chk_sum & 0xff);
 
 	ret = it913x_bulk_write(udev, buff, buf_size , 0x02);
+	if (ret < 0)
+		goto error;
 
-	ret |= it913x_bulk_read(udev, buff, (mode & 1) ?
+	ret = it913x_bulk_read(udev, buff, (mode & 1) ?
 			5 : len + 5 , 0x01);
+	if (ret < 0)
+		goto error;
 
 	rlen = (mode & 0x1) ? 0x1 : len;
 
 	if (mode & 1)
-		ret |= buff[2];
+		ret = buff[2];
 	else
 		memcpy(data, &buff[3], rlen);
 
 	cmd_counter++;
 
-	kfree(buff);
+error:	kfree(buff);
 
-	return (ret < 0) ? -ENODEV : 0;
+	return ret;
+}
+
+static int it913x_io(struct usb_device *udev, u8 mode, u8 pro,
+			u8 cmd, u32 reg, u8 addr, u8 *data, u8 len)
+{
+	int ret, i;
+
+	for (i = 0; i < IT913X_RETRY; i++) {
+		ret = it913x_usb_talk(udev, mode, pro,
+			cmd, reg, addr, data, len);
+		if (ret != -EAGAIN)
+			break;
+	}
+
+	return ret;
 }
 
 static int it913x_wr_reg(struct usb_device *udev, u8 pro, u32 reg , u8 data)
-- 
1.7.7.1



