Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51331 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbaLSI5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 03:57:43 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] cx23885: fix I2C scan printout
Date: Fri, 19 Dec 2014 10:56:42 +0200
Message-Id: <1418979403-28225-3-git-send-email-crope@iki.fi>
In-Reply-To: <1418979403-28225-1-git-send-email-crope@iki.fi>
References: <1418979403-28225-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

1) I2C slave addresses were printed so called 8-bit format. Use
standard 7-bit notation.

2) I2C slave address was printed with hex formatted without leading
zeros, which makes output one digit shorter in a case of address
fit to one hex digit. Use 4 char wide hex number with leading zeros
as usually used for I2C slave addresses.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index fd71306..1135ea3 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -300,8 +300,8 @@ static void do_i2c_scan(char *name, struct i2c_client *c)
 		rc = i2c_master_recv(c, &buf, 0);
 		if (rc < 0)
 			continue;
-		printk(KERN_INFO "%s: i2c scan: found device @ 0x%x  [%s]\n",
-		       name, i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
+		printk(KERN_INFO "%s: i2c scan: found device @ 0x%04x  [%s]\n",
+		       name, i, i2c_devs[i] ? i2c_devs[i] : "???");
 	}
 }
 
-- 
http://palosaari.fi/

