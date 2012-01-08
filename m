Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:37429 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2AGUgV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 15:36:21 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout0.freenet.de with esmtpa (ID saschasommer@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rjd00-0007KD-5r
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:36:20 +0100
Received: from localhost ([::1]:37675 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID saschasommer@freenet.de) (Exim 4.76 #1)
	id 1Rjd00-0006Lf-28
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:36:20 +0100
Received: from [195.4.92.19] (port=38888 helo=9.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID saschasommer@freenet.de) (Exim 4.76 #1)
	id 1Rjcxc-000677-Tz
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:33:52 +0100
Received: from p5499e75f.dip.t-dialin.net ([84.153.231.95]:41700 helo=madeira.sommer.dynalias.net)
	by 9.mx.freenet.de with esmtpsa (ID saschasommer@freenet.de) (TLSv1:CAMELLIA256-SHA:256) (port 465) (Exim 4.76 #1)
	id 1Rjcxc-0004Vd-J0
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:33:52 +0100
Message-ID: <4F09FD49.2000806@freenet.de>
Date: Sun, 08 Jan 2012 21:32:09 +0100
From: Sascha Sommer <saschasommer@freenet.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] em28xx: Do not modify EM28XX_R06_I2C_CLK for em2800
Content-Type: multipart/mixed;
 boundary="------------070104040309090004090207"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070104040309090004090207
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

writing the EM28XX_R06_I2C_CLK register leads to the problem that the 
i2c bus
on the Terratec Cinergy 200 USB is no longer usable when the system is 
rebooted.
The device needs to be unplugged in order to bring it back to life.
Attached patch conditionally disables the write in 
em28xx_pre_card_setup() like
it is already done in em28xx_card_setup().

Regards

Sascha


--------------070104040309090004090207
Content-Type: text/x-patch;
 name="em28xx_do_not_modify_EM28XX_R06_I2C_CLK_for_em2800.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="em28xx_do_not_modify_EM28XX_R06_I2C_CLK_for_em2800.patch"

Do not modify EM28XX_R06_I2C_CLK for em2800
Modifying this register makes the Terratec Cinergy 200 USB unusable
after reboot.

Signed-off-by: Sascha Sommer <saschasommer@freenet.de>

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 897a432..0b2e6d5 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2287,7 +2287,8 @@ void em28xx_pre_card_setup(struct em28xx *dev)
 	/* Set the initial XCLK and I2C clock values based on the board
 	   definition */
 	em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk & 0x7f);
-	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
+	if (!dev->board.is_em2800)
+		em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
 	msleep(50);
 
 	/* request some modules */

--------------070104040309090004090207--
