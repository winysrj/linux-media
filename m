Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33028 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaJLKDg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Oct 2014 06:03:36 -0400
Received: by mail-lb0-f169.google.com with SMTP id 10so5145050lbg.0
        for <linux-media@vger.kernel.org>; Sun, 12 Oct 2014 03:03:30 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: nibble.max@gmail.com, Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/4] dvbsky: don't print MAC address from read_mac_address
Date: Sun, 12 Oct 2014 13:03:08 +0300
Message-Id: <1413108191-32510-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb-usb-v2 already prints out the MAC address, no need to print it out also here.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 34688c8..502b52c 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -265,8 +265,6 @@ static int dvbsky_read_mac_addr(struct dvb_usb_adapter *adap, u8 mac[6])
 	if (i2c_transfer(&d->i2c_adap, msg, 2) == 2)
 		memcpy(mac, ibuf, 6);
 
-	dev_info(&d->udev->dev, "dvbsky_usb MAC address=%pM\n", mac);
-
 	return 0;
 }
 
-- 
1.9.1

