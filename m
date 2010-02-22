Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:36081 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547Ab0BVRf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 12:35:56 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 3/3] tm6000: bugfix i2c addr
Date: Mon, 22 Feb 2010 18:35:07 +0100
Message-Id: <1266860107-9065-3-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266860107-9065-2-git-send-email-stefan.ringel@arcor.de>
References: <1266860107-9065-1-git-send-email-stefan.ringel@arcor.de>
 <1266860107-9065-2-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-i2c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 0da40ec..8ae988d 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -126,7 +126,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 
 			i++;
 
-			if (addr == dev->tuner_addr) {
+			if (addr == dev->tuner_addr << 1) {
 				tm6000_set_reg(dev, 0x32, 0,0);
 				tm6000_set_reg(dev, 0x33, 0,0);
 			}
@@ -141,7 +141,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			rc = tm6000_i2c_send_regs(dev, addr, msgs[i].buf[0],
 				msgs[i].buf + 1, msgs[i].len - 1);
 
-			if (addr == dev->tuner_addr) {
+			if (addr == dev->tuner_addr  << 1) {
 				tm6000_set_reg(dev, 0x32, 0,0);
 				tm6000_set_reg(dev, 0x33, 0,0);
 			}
-- 
1.6.6.1

