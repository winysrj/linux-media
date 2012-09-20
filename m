Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43052 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab2ITQGb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 12:06:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] em28xx: PCTV 520e workaround for DRX-K fw loading
Date: Thu, 20 Sep 2012 19:06:04 +0300
Message-Id: <1348157164-2912-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is hack to make device working again.
Looks like we need to wait DRX-K fw loading is ready until tuner
is attached as tuner is behind demod I2C bus.

For some reason it still crash when device is re-plugged without
module unloading...

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 5b7f2b3..4e46fef 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1128,6 +1128,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		dvb->fe[0] = dvb_attach(drxk_attach, &pctv_520e_drxk,
 				&dev->i2c_adap);
 
+		/* FIXME: wait demod fw is loaded, up and running */
+		msleep(2000);
+
 		if (dvb->fe[0]) {
 			/* attach tuner */
 			if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
-- 
1.7.11.4

