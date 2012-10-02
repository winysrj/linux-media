Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48833 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab2JBAwx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 20:52:53 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH RFC] em28xx: PCTV 520e switch tda18271 to tda18271c2dd
Date: Tue,  2 Oct 2012 03:52:25 +0300
Message-Id: <1349139145-22113-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New drxk firmware download does not work with tda18271. Actual
reason is more drxk driver than tda18271. Anyhow, tda18271c2dd
will work as it does not do as much I/O during attach than tda18271.

Root of cause is tuner I/O during drx-k asynchronous firmware
download. request_firmware_nowait()... :-/

Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 770a5af..fd750d4 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1122,9 +1122,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		if (dvb->fe[0]) {
 			/* attach tuner */
-			if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
-					&dev->i2c_adap,
-					&em28xx_cxd2820r_tda18271_config)) {
+			if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0],
+					&dev->i2c_adap, 0x60)) {
 				dvb_frontend_detach(dvb->fe[0]);
 				result = -EINVAL;
 				goto out_free;
-- 
1.7.11.4

