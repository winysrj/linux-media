Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:37071 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab0BUULs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 15:11:48 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 3/3] tm6000: bugfix i2c addr
Date: Sun, 21 Feb 2010 21:10:36 +0100
Message-Id: <1266783036-6549-3-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266783036-6549-2-git-send-email-stefan.ringel@arcor.de>
References: <1266783036-6549-1-git-send-email-stefan.ringel@arcor.de>
 <1266783036-6549-2-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-i2c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 6ae02b8..029cf74 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -125,7 +125,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 			i++;
 
-			if (addr == dev->tuner_addr) {
+			if (addr == dev->tuner_addr << 1) {
 				tm6000_set_reg(dev, 0x32, 0,0);
 				tm6000_set_reg(dev, 0x33, 0,0);
 			}
@@ -140,7 +140,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			rc = tm6000_i2c_send_regs(dev, addr, msgs[i].buf[0],
 				msgs[i].buf + 1, msgs[i].len - 1);
 
-			if (addr == dev->tuner_addr) {
+			if (addr == dev->tuner_addr  << 1) {
 				tm6000_set_reg(dev, 0x32, 0,0);
 				tm6000_set_reg(dev, 0x33, 0,0);
 			}
-- 
1.6.6.1

