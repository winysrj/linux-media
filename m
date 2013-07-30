Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58283 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864Ab3G3UaI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 16:30:08 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] lme2510: do not use bInterfaceNumber from dvb_usb_v2
Date: Tue, 30 Jul 2013 23:29:00 +0300
Message-Id: <1375216141-25295-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to access bInterfaceNumber via dvb_usb_v2 internals as driver
has it already.

That patch is prepare for dvb_usb_v2 deferred probe hack removal. It was
added due to udev firmware loading problems, but things are fixed after
that and it is not needed anymore.

Cc: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index b3fd0ff..f674dc0 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -1225,7 +1225,7 @@ static int lme2510_identify_state(struct dvb_usb_device *d, const char **name)
 	usb_reset_configuration(d->udev);
 
 	usb_set_interface(d->udev,
-		d->intf->cur_altsetting->desc.bInterfaceNumber, 1);
+		d->props->bInterfaceNumber, 1);
 
 	st->dvb_usb_lme2510_firmware = dvb_usb_lme2510_firmware;
 
-- 
1.7.11.7

