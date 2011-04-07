Return-path: <mchehab@pedra>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13443 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab1DGTqK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 15:46:10 -0400
Date: Thu, 7 Apr 2011 21:46:27 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Malcolm Priestley <tvboxspy@gmail.com>,
	=?ISO-8859-15?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH][media] DVB, USB, lmedm04: Fix firmware mem leak in
 lme_firmware_switch()
Message-ID: <alpine.LNX.2.00.1104072142540.1538@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Don't leak 'fw' in 
drivers/media/dvb/dvb-usb/lmedm04.c::lme_firmware_switch() by failing to 
call release_firmware().

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 lmedm04.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

 compile tested only

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index cd26e7c..d7cc625 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -799,7 +799,7 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
 	if (cold) {
 		info("FRM Changing to %s firmware", fw_lme);
 		lme_coldreset(udev);
-		return -ENODEV;
+		ret = -ENODEV;
 	}
 
 	release_firmware(fw);


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

