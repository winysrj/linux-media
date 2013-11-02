Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60759 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab3KBQdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:42 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 21/29] cimax2: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:29 -0200
Message-Id: <1383399097-11615-22-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/pci/cx23885/cimax2.c

Instead, let's enforce a limit for the buffer. Considering that I2C
transfers are generally limited, and that devices used on USB has a
max data length of 80, it seem safe to use 80 as the hard limit for all
those devices. On most cases, the limit is a way lower than that, but
80 is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/cx23885/cimax2.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cimax2.c b/drivers/media/pci/cx23885/cimax2.c
index 7344849183a7..e6515f48aa8d 100644
--- a/drivers/media/pci/cx23885/cimax2.c
+++ b/drivers/media/pci/cx23885/cimax2.c
@@ -125,7 +125,7 @@ static int netup_write_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 						u8 *buf, int len)
 {
 	int ret;
-	u8 buffer[len + 1];
+	u8 buffer[80];
 
 	struct i2c_msg msg = {
 		.addr	= addr,
@@ -134,6 +134,13 @@ static int netup_write_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 		.len	= len + 1
 	};
 
+	if (1 + len > sizeof(buffer)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr reg=%04x: len=%d is too big!\n",
+		       KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	buffer[0] = reg;
 	memcpy(&buffer[1], buf, len);
 
-- 
1.8.3.1

