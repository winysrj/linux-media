Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:56585 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755890Ab0BORiU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 12:38:20 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 08/11] tm6000: special request for all tuner
Date: Mon, 15 Feb 2010 18:37:21 +0100
Message-Id: <1266255444-7422-8-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266255444-7422-7-git-send-email-stefan.ringel@arcor.de>
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-2-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-3-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-4-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-5-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-6-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-7-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 9d02674..ef11d48 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -112,7 +112,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			}
 			i++;
 
-			if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
+			if (addr == dev->tuner_addr) {
 				tm6000_set_reg(dev, 0x32, 0,0);
 				tm6000_set_reg(dev, 0x33, 0,0);
 			}
@@ -128,7 +128,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			rc = tm6000_i2c_send_byte(dev, addr, msgs[i].buf[0],
 				msgs[i].buf + 1, msgs[i].len - 1);
 
-			if ((dev->dev_type == TM6010) && (addr == 0xc2)) {
+			if (addr == dev->tuner_addr) {
 				tm6000_set_reg(dev, 0x32, 0,0);
 				tm6000_set_reg(dev, 0x33, 0,0);
 			}
-- 
1.6.6.1

