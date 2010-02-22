Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:46257 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522Ab0BVRf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 12:35:58 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 2/3] tm6000: bugfix reading problems with demodulator zl10353
Date: Mon, 22 Feb 2010 18:35:06 +0100
Message-Id: <1266860107-9065-2-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266860107-9065-1-git-send-email-stefan.ringel@arcor.de>
References: <1266860107-9065-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

repairs reading problems zl10353.

for example:

regs  w/o patch  with patch

0x06     0x00        0x7f
0x07     0x33        0x30
0x08     0x00        0x00
0x09     0x58        0x50
0x0f     0x31        0x28
0x10     0x00        0x84



Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-i2c.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 2de92f3..0da40ec 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -54,9 +54,20 @@ int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr, __u8 reg,
 int tm6000_i2c_recv_regs(struct tm6000_core *dev, unsigned char addr, __u8 reg, char *buf, int len)
 {
 	int rc;
+	u8 b[2];
 
+	if ((dev->caps.has_zl10353) && (dev->demod_addr << 1 == addr) && (reg % 2 == 0)) {
+		reg -= 1;
+		len += 1;
+
+		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
+			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, b, len);
+
+		*buf = b[1];
+	} else {
 		rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			REQ_16_SET_GET_I2C_WR1_RDN, addr | reg << 8, 0, buf, len);
+	}
 
 	return rc;
 }
-- 
1.6.6.1

