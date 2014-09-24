Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:37346 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbaIXDHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 23:07:03 -0400
Received: by mail-la0-f50.google.com with SMTP id ty20so10011877lab.9
        for <linux-media@vger.kernel.org>; Tue, 23 Sep 2014 20:07:01 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] cx23885: initialize config structs for T9580
Date: Wed, 24 Sep 2014 06:06:54 +0300
Message-Id: <1411528014-14650-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The config structs used for DVBSky T9580 were not initialized. This patch fixes that.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 13734b8..4cb9031 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1600,6 +1600,7 @@ static int dvb_register(struct cx23885_tsport *port)
 				break;
 
 			/* attach tuner */
+			memset(&m88ts2022_config, 0, sizeof(m88ts2022_config));
 			m88ts2022_config.fe = fe0->dvb.frontend;
 			m88ts2022_config.clock = 27000000;
 			memset(&info, 0, sizeof(struct i2c_board_info));
@@ -1635,6 +1636,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		/* port c - terrestrial/cable */
 		case 2:
 			/* attach frontend */
+			memset(&si2168_config, 0, sizeof(si2168_config));
 			si2168_config.i2c_adapter = &adapter;
 			si2168_config.fe = &fe0->dvb.frontend;
 			si2168_config.ts_mode = SI2168_TS_SERIAL;
@@ -1654,6 +1656,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			port->i2c_client_demod = client_demod;
 
 			/* attach tuner */
+			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = fe0->dvb.frontend;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-- 
1.7.0.4

