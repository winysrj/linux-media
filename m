Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57867 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747Ab2ATVj2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 16:39:28 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] anysee: fix CI init
Date: Fri, 20 Jan 2012 23:39:17 +0200
Message-Id: <1327095557-15014-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No more error that error seen when device is plugged:
dvb_ca adapter 0: Invalid PC card inserted :(

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/anysee.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index 7b77c7b..fdee856 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -1188,6 +1188,14 @@ static int anysee_ci_init(struct dvb_usb_device *d)
 	if (ret)
 		return ret;
 
+	ret = anysee_wr_reg_mask(d, REG_IOD, (0 << 2)|(0 << 1)|(0 << 0), 0x07);
+	if (ret)
+		return ret;
+
+	ret = anysee_wr_reg_mask(d, REG_IOD, (1 << 2)|(1 << 1)|(1 << 0), 0x07);
+	if (ret)
+		return ret;
+
 	ret = dvb_ca_en50221_init(&d->adapter[0].dvb_adap, &state->ci, 0, 1);
 	if (ret)
 		return ret;
-- 
1.7.4.4

