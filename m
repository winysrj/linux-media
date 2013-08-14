Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004Ab3HNU7f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Aug 2013 16:59:35 -0400
From: Christian Volkmann <cv@cv-sv.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	"Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Christian Volkmann <cv@cv-sv.de>
Subject: [PATCH 1/1] cx23885-dvb: fix ds3000 ts2020 split for TEVII S471
Date: Wed, 14 Aug 2013 22:58:47 +0200
Message-Id: <1376513927-6217-1-git-send-email-cv@cv-sv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A split for ds3000/ts2020 code forgot to change the TEVII_S471 code.
Change the TEVII_S471 according the changes to TEVII_S470.

Signed-off-by: Christian Volkmann <cv@cv-sv.de>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 9c5ed10..be98c49 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1038,7 +1038,6 @@ static int dvb_register(struct cx23885_tsport *port)
 				&tevii_ts2020_config, &i2c_bus->i2c_adap);
 			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
 		}
-
 		break;
 	case CX23885_BOARD_DVBWORLD_2005:
 		i2c_bus = &dev->i2c_bus[1];
@@ -1249,6 +1248,11 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(ds3000_attach,
 					&tevii_ds3000_config,
 					&i2c_bus->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(ts2020_attach, fe0->dvb.frontend,
+				&tevii_ts2020_config, &i2c_bus->i2c_adap);
+			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
+		}
 		break;
 	case CX23885_BOARD_PROF_8000:
 		i2c_bus = &dev->i2c_bus[0];
-- 
1.8.1.4

