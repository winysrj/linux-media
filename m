Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:36932 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab2AGUXs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 15:23:48 -0500
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout0.freenet.de with esmtpa (ID saschasommer@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rjcnp-0003fh-J7
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:23:45 +0100
Received: from localhost ([::1]:47295 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID saschasommer@freenet.de) (Exim 4.76 #1)
	id 1Rjcnp-0000cR-FO
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:23:45 +0100
Received: from [195.4.92.13] (port=42050 helo=3.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID saschasommer@freenet.de) (Exim 4.76 #1)
	id 1RjclN-0000EI-TQ
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:21:13 +0100
Received: from p5499e75f.dip.t-dialin.net ([84.153.231.95]:60263 helo=madeira.sommer.dynalias.net)
	by 3.mx.freenet.de with esmtpsa (ID saschasommer@freenet.de) (TLSv1:CAMELLIA256-SHA:256) (port 465) (Exim 4.76 #1)
	id 1RjclN-0007JQ-Kg
	for linux-media@vger.kernel.org; Sat, 07 Jan 2012 21:21:13 +0100
Message-ID: <4F09FA52.7020606@freenet.de>
Date: Sun, 08 Jan 2012 21:19:30 +0100
From: Sascha Sommer <saschasommer@freenet.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] em28xx: Fix: I2C_CLK write error message checks wrong return
 code
Content-Type: multipart/mixed;
 boundary="------------000209020504010903030507"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000209020504010903030507
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

it looks like the return value check that is done after setting the I2C 
speed checks the wrong return code.
Attached patch fixes this problem.

Regards

Sascha


--------------000209020504010903030507
Content-Type: text/x-patch;
 name="em28xx_check_correct_return_code_after_register_write.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="em28xx_check_correct_return_code_after_register_write.patch"

Fix: I2C_CLK write error message checks wrong return code

Signed-off-by: Sascha Sommer <saschasommer@freenet.de>

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 897a432..349e674 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -3015,7 +3015,7 @@ static int em28xx_init_dev(struct em28xx **devhandle, struct usb_device *udev,
 
 	if (!dev->board.is_em2800) {
 		/* Resets I2C speed */
-		em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
+		retval = em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
 		if (retval < 0) {
 			em28xx_errdev("%s: em28xx_write_reg failed!"
 				      " retval [%d]\n",

--------------000209020504010903030507--
