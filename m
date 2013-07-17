Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:37542 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab3GQS2U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 14:28:20 -0400
Date: Wed, 17 Jul 2013 20:28:16 +0200
From: Johannes Koch <johannes@ortsraum.de>
To: linux-media@vger.kernel.org,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: [PATCH] cx23885: Fix TeVii S471 regression since introduction of
 ts2020
Message-ID: <20130717182815.GA22526@Loki.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch to make TeVii S471 cards use the ts2020 tuner, since ds3000 driver no 
longer contains tuning code.

Signed-off-by: Johannes Koch <johannes@ortsraum.de>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 9c5ed10..bb291c6 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1249,6 +1249,10 @@ static int dvb_register(struct cx23885_tsport *port)
 		fe0->dvb.frontend = dvb_attach(ds3000_attach,
 					&tevii_ds3000_config,
 					&i2c_bus->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(ts2020_attach, fe0->dvb.frontend,
+				&tevii_ts2020_config, &i2c_bus->i2c_adap);
+		}
 		break;
 	case CX23885_BOARD_PROF_8000:
 		i2c_bus = &dev->i2c_bus[0];
-- 
1.8.3.3

