Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:57319 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab2LJVho (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 16:37:44 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 7/9] [media] m920x: send the RC init sequence also when rc.core is used
Date: Mon, 10 Dec 2012 22:37:15 +0100
Message-Id: <1355175437-21623-8-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
 <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/usb/dvb-usb/m920x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index bddd763..531a681 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -84,7 +84,7 @@ static int m920x_init(struct dvb_usb_device *d, struct m920x_inits *rc_seq)
 	int adap_enabled[M9206_MAX_ADAPTERS] = { 0 };
 
 	/* Remote controller init. */
-	if (d->props.rc.legacy.rc_query) {
+	if (d->props.rc.legacy.rc_query || d->props.rc.core.rc_query) {
 		deb("Initialising remote control\n");
 		ret = m920x_write_seq(d->udev, M9206_CORE, rc_seq);
 		if (ret != 0) {
-- 
1.7.10.4

