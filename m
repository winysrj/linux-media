Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1HDHOY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:24 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 06/21] [staging] tm6000: Increase maximum I2C packet size.
Date: Thu,  4 Aug 2011 09:14:04 +0200
Message-Id: <1312442059-23935-7-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TM6010 supports much larger I2C transfers than currently specified.
In fact the Windows driver seems to use 81 bytes per packet by default.
This commit improves the speed of firmware loading a bit.
---
 drivers/staging/tm6000/tm6000-cards.c |    1 +
 drivers/staging/tm6000/tm6000-i2c.c   |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index c3b84c9..a5d2a71 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -929,6 +929,7 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 		memset(&ctl, 0, sizeof(ctl));
 
 		ctl.demod = XC3028_FE_ZARLINK456;
+		ctl.max_len = 81;
 
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 21cd9f8..2cb7573 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -50,7 +50,7 @@ static int tm6000_i2c_send_regs(struct tm6000_core *dev, unsigned char addr,
 	unsigned int i2c_packet_limit = 16;
 
 	if (dev->dev_type == TM6010)
-		i2c_packet_limit = 64;
+		i2c_packet_limit = 256;
 
 	if (!buf)
 		return -1;
-- 
1.7.6

