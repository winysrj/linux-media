Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43307 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3KENDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:51 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 20/29] [media] cimax2: Don't use dynamic static allocation
Date: Tue,  5 Nov 2013 08:01:33 -0200
Message-Id: <1383645702-30636-21-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
        drivers/media/pci/cx23885/cimax2.c:149:1: warning: 'netup_write_i2c' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer. Considering that I2C
transfers are generally limited, and that devices used on USB has a
max data length of 64 bytes for the control URBs.

So, it seem safe to use 64 bytes as the hard limit for all those devices.

On most cases, the limit is a way lower than that, but this limit
is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/cx23885/cimax2.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cimax2.c b/drivers/media/pci/cx23885/cimax2.c
index 7344849183a7..16fa7ea4d4aa 100644
--- a/drivers/media/pci/cx23885/cimax2.c
+++ b/drivers/media/pci/cx23885/cimax2.c
@@ -26,6 +26,10 @@
 #include "cx23885.h"
 #include "cimax2.h"
 #include "dvb_ca_en50221.h"
+
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /**** Bit definitions for MC417_RWD and MC417_OEN registers  ***
   bits 31-16
 +-----------+
@@ -125,7 +129,7 @@ static int netup_write_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 						u8 *buf, int len)
 {
 	int ret;
-	u8 buffer[len + 1];
+	u8 buffer[MAX_XFER_SIZE];
 
 	struct i2c_msg msg = {
 		.addr	= addr,
@@ -134,6 +138,13 @@ static int netup_write_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 		.len	= len + 1
 	};
 
+	if (1 + len > sizeof(buffer)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr reg=%04x: len=%d is too big!\n",
+		       KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buffer[0] = reg;
 	memcpy(&buffer[1], buf, len);
 
-- 
1.8.3.1

