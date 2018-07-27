Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36288 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbeG0EmF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 00:42:05 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: mchehab@kernel.org, hans.verkuil@cisco.com, bhumirks@gmail.com,
        colin.king@canonical.com, viro@zeniv.linux.org.uk,
        gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] media: pci: cx25821: Replace mdelay() with msleep()
Date: Fri, 27 Jul 2018 11:22:09 +0800
Message-Id: <20180727032209.3320-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx25821_gpio_init(), cx25821_initialize() and cx25821_registers_init() 
are never called in atomic context.
They call mdelay() to busily wait, which is not necessary.
mdelay() can be replaced with msleep().

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/pci/cx25821/cx25821-core.c | 4 ++--
 drivers/media/pci/cx25821/cx25821-gpio.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 040c6c251d3a..2f0171134f7e 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -428,7 +428,7 @@ static void cx25821_registers_init(struct cx25821_dev *dev)
 	tmp |= FLD_USE_ALT_PLL_REF;
 	cx_write(CLK_RST, tmp & ~(FLD_VID_I_CLK_NOE | FLD_VID_J_CLK_NOE));
 
-	mdelay(100);
+	msleep(100);
 }
 
 int cx25821_sram_channel_setup(struct cx25821_dev *dev,
@@ -803,7 +803,7 @@ static void cx25821_initialize(struct cx25821_dev *dev)
 	cx_write(CLK_DELAY, cx_read(CLK_DELAY) & 0x80000000);
 	cx_write(PAD_CTRL, 0x12);	/* for I2C */
 	cx25821_registers_init(dev);	/* init Pecos registers */
-	mdelay(100);
+	msleep(100);
 
 	for (i = 0; i < VID_CHANNEL_NUM; i++) {
 		cx25821_set_vip_mode(dev, dev->channels[i].sram_channels);
diff --git a/drivers/media/pci/cx25821/cx25821-gpio.c b/drivers/media/pci/cx25821/cx25821-gpio.c
index 76b8f619e55a..f5ffaf880e5f 100644
--- a/drivers/media/pci/cx25821/cx25821-gpio.c
+++ b/drivers/media/pci/cx25821/cx25821-gpio.c
@@ -88,7 +88,7 @@ void cx25821_gpio_init(struct cx25821_dev *dev)
 	default:
 		/* set GPIO 5 to select the path for Medusa/Athena */
 		cx25821_set_gpiopin_logicvalue(dev, 5, 1);
-		mdelay(20);
+		msleep(20);
 		break;
 	}
 
-- 
2.17.0
