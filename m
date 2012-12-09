Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53571 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758888Ab2LIT5N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 17/17] af9035: print warning when firmware is bad
Date: Sun,  9 Dec 2012 21:56:28 +0200
Message-Id: <1355082988-6211-17-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 68e0e804..ea37b5c 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -437,6 +437,10 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 				__func__, fw->size - i);
 	}
 
+	/* print warn if firmware is bad, continue and see what happens */
+	if (i)
+		dev_warn(&d->udev->dev, "%s: bad firmware\n", KBUILD_MODNAME);
+
 	/* firmware loaded, request boot */
 	req.cmd = CMD_FW_BOOT;
 	ret = af9035_ctrl_msg(d, &req);
-- 
1.7.11.7

