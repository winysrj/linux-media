Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44656 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbZGRRiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 13:38:08 -0400
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id 522C03BC588
	for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 13:38:08 -0400 (EDT)
Received: from localhost.localdomain (ool-457b4d55.dyn.optonline.net [69.123.77.85])
	by mail.messagingengine.com (Postfix) with ESMTPSA id 130C09C07
	for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 13:38:08 -0400 (EDT)
Received: from acano by localhost.localdomain with local (Exim 4.69)
	(envelope-from <acano@fastmail.fm>)
	id 1MSDrC-0008Vl-Lm
	for linux-media@vger.kernel.org; Sat, 18 Jul 2009 13:37:58 -0400
Date: Sat, 18 Jul 2009 13:37:58 -0400
From: acano@fastmail.fm
To: linux-media@vger.kernel.org
Subject: [PATCH] em28xx: enable usb audio for plextor px-tv100u
Message-ID: <20090718173758.GA32708@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



--tKW2IUtsqtDRztdT
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="2009-07-18-01-plextor.patch"

diff -r 27ddf3fe0ed9 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c	Wed Jun 17 04:38:12 2009 +0000
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c	Sat Jul 18 13:32:04 2009 -0400
@@ -639,10 +639,10 @@ struct em28xx_board em28xx_boards[] = {
 	},
 	[EM2861_BOARD_PLEXTOR_PX_TV100U] = {
 		.name         = "Plextor ConvertX PX-TV100U",
-		.valid        = EM28XX_BOARD_NOT_VALIDATED,
 		.tuner_type   = TUNER_TNF_5335MF,
 		.tda9887_conf = TDA9887_PRESENT,
 		.decoder      = EM28XX_TVP5150,
+		.has_msp34xx  = 1,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
@@ -1950,6 +1950,10 @@ void em28xx_pre_card_setup(struct em28xx
 		/* FIXME guess */
 		/* Turn on analog audio output */
 		em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xfd);
+
+		/* enable audio 12mhz i2s */
+		em28xx_write_reg(dev, EM28XX_R0F_XCLK, 0xa7);
+		dev->i2s_speed = 2048000;
 		break;
 	case EM2861_BOARD_KWORLD_PVRTV_300U:
 	case EM2880_BOARD_KWORLD_DVB_305U:
diff -r 27ddf3fe0ed9 linux/drivers/media/video/em28xx/em28xx-video.c
--- a/linux/drivers/media/video/em28xx/em28xx-video.c	Wed Jun 17 04:38:12 2009 +0000
+++ b/linux/drivers/media/video/em28xx/em28xx-video.c	Sat Jul 18 13:32:04 2009 -0400
@@ -1087,9 +1087,12 @@ static int vidioc_s_ctrl(struct file *fi
 
 	mutex_lock(&dev->lock);
 
-	if (dev->board.has_msp34xx)
+	if (dev->board.has_msp34xx) {
+		/*FIXME hack to unmute usb audio stream */
+		em28xx_set_ctrl(dev, ctrl);
+
 		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);
-	else {
+	} else {
 		rc = 1;
 		for (i = 0; i < ARRAY_SIZE(em28xx_qctrl); i++) {
 			if (ctrl->id == em28xx_qctrl[i].id) {

--tKW2IUtsqtDRztdT--
