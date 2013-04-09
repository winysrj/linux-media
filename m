Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53403 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763199Ab3DIXyX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 19:54:23 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/5] af9015: fix I2C adapter read (without REPEATED STOP)
Date: Wed, 10 Apr 2013 02:53:17 +0300
Message-Id: <1365551600-3394-3-git-send-email-crope@iki.fi>
In-Reply-To: <1365551600-3394-1-git-send-email-crope@iki.fi>
References: <1365551600-3394-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index b943304..a523a25 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -282,7 +282,7 @@ Due to that the only way to select correct tuner is use demodulator I2C-gate.
 			req.i2c_addr = msg[i].addr;
 			req.addr = addr;
 			req.mbox = mbox;
-			req.addr_len = addr_len;
+			req.addr_len = 0;
 			req.data_len = msg[i].len;
 			req.data = &msg[i].buf[0];
 			ret = af9015_ctrl_msg(d, &req);
-- 
1.7.11.7

