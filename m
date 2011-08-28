Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hnelson.de ([83.169.43.49]:55522 "EHLO mail.hnelson.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1H1PCw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 11:02:52 -0400
Received: from nova.crius.de (91-67-241-121-dynip.superkabel.de [91.67.241.121])
	by mail.hnelson.de (Postfix) with ESMTPSA id B19551B4186BA
	for <linux-media@vger.kernel.org>; Sun, 28 Aug 2011 16:52:53 +0200 (CEST)
Date: Sun, 28 Aug 2011 16:52:44 +0200 (CEST)
From: Holger Nelson <hnelson@hnelson.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Some success with Terratec Cinergy HTC USB XS
Message-ID: <alpine.DEB.2.02.1108281602520.27340@nova.crius.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I had some success with a Terratec Cinergy HTC USB XS:
I added the usb id as a Terratec H5 to em28xx-cards.c and downloaded
the firmware file for Terratec H5, because I saw on Terratecs linux-site 
that both devices use the same ICs. DVB-C works with this setup.
Watching analog tv didn't work: Xawtv timed out or hang trying to 
access /dev/video0.

Is there anything else I could test?


regards,
Holger

--- linux/drivers/media/video/em28xx/em28xx-cards.c~	2011-07-18 05:45:26.000000000 +0200
+++ linux/drivers/media/video/em28xx/em28xx-cards.c	2011-08-27 21:15:26.564483966 +0200
@@ -1883,6 +1883,8 @@ struct usb_device_id em28xx_id_table[] =
  			.driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
  	{ USB_DEVICE(0x0ccd, 0x0042),
  			.driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
+	{ USB_DEVICE(0x0ccd, 0x008e),
+			.driver_info = EM2884_BOARD_TERRATEC_H5 },
  	{ USB_DEVICE(0x0ccd, 0x0043),
  			.driver_info = EM2884_BOARD_TERRATEC_H5 },
  	{ USB_DEVICE(0x0ccd, 0x10a2),	/* Rev. 1 */
