Return-path: <linux-media-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:54984 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbcE2Rkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2016 13:40:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC] [media] dvb-usb: Initialize ret in dvb_usb_adapter_frontend_init()
Date: Sun, 29 May 2016 12:04:29 +0200
Message-Id: <1464516269-6504-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb/dvb-usb-dvb.c: In function ‘dvb_usb_adapter_frontend_init’:
drivers/media/usb/dvb-usb/dvb-usb-dvb.c:323: warning: ‘ret’ is used uninitialized in this function

If num_frontends is zero, dvb_usb_adapter_frontend_init() will return an
uninitialized value. Initialize ret to -ENODEV to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Can num_frontends ever be zero?

 drivers/media/usb/dvb-usb/dvb-usb-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 6477b04e95c748cc..2ecc7009588a25a2 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -271,7 +271,7 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 
 int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 {
-	int ret, i;
+	int ret = -ENODEV, i;
 
 	/* register all given adapter frontends */
 	for (i = 0; i < adap->props.num_frontends; i++) {
-- 
1.9.1

