Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39967 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab3JLBUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Oct 2013 21:20:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] em28xx: MaxMedia UB425-TC switch RF tuner driver to another
Date: Sat, 12 Oct 2013 04:20:00 +0300
Message-Id: <1381540801-23645-2-git-send-email-crope@iki.fi>
In-Reply-To: <1381540801-23645-1-git-send-email-crope@iki.fi>
References: <1381540801-23645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tda18271c2dd => tda18271
tda18271 is more complete than tda18271c2dd.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index f8a2212..0697aad 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1229,8 +1229,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			dvb->fe[0]->ops.i2c_gate_ctrl = NULL;
 
 			/* attach tuner */
-			if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0],
-					&dev->i2c_adap[dev->def_i2c_bus], 0x60)) {
+			if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
+					&dev->i2c_adap[dev->def_i2c_bus],
+					&em28xx_cxd2820r_tda18271_config)) {
 				dvb_frontend_detach(dvb->fe[0]);
 				result = -EINVAL;
 				goto out_free;
-- 
1.8.3.1

