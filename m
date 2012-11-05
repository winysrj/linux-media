Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:53635 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933309Ab2KEX2j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 18:28:39 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 5/5] [media] m920x: fix a typo in a comment
Date: Tue,  6 Nov 2012 00:28:16 +0100
Message-Id: <1352158096-17737-6-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/usb/dvb-usb/m920x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index ec820ec..c66c78c 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -610,7 +610,7 @@ static struct m920x_inits tvwalkertwin_rc_init [] = {
 };
 
 static struct m920x_inits pinnacle310e_init[] = {
-	/* without these the tuner don't work */
+	/* without these the tuner doesn't work */
 	{ 0xff20,         0x9b },
 	{ 0xff22,         0x70 },
 
-- 
1.7.10.4

