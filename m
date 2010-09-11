Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0IKOAV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 10:00:21 -0400
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 2/2] media: cx23885: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 16:59:59 +0300
Message-Id: <48c8f7738e230c2efd3bb4c40be09517db47b08b.1284213506.git.andy.shevchenko@gmail.com>
In-Reply-To: <a548f44961f97f81054fc877aaef068f936c5ca2.1284213506.git.andy.shevchenko@gmail.com>
References: <a548f44961f97f81054fc877aaef068f936c5ca2.1284213506.git.andy.shevchenko@gmail.com>
In-Reply-To: <a548f44961f97f81054fc877aaef068f936c5ca2.1284213506.git.andy.shevchenko@gmail.com>
References: <a548f44961f97f81054fc877aaef068f936c5ca2.1284213506.git.andy.shevchenko@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/media/video/cx23885/cx23885-dvb.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 3d70af2..eca7247 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -1017,10 +1017,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		/* Read entire EEPROM */
 		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
 		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom, sizeof(eeprom));
-		printk(KERN_INFO "TeVii S470 MAC= "
-				"%02X:%02X:%02X:%02X:%02X:%02X\n",
-				eeprom[0xa0], eeprom[0xa1], eeprom[0xa2],
-				eeprom[0xa3], eeprom[0xa4], eeprom[0xa5]);
+		printk(KERN_INFO "TeVii S470 MAC= %pM\n", &eeprom[0xa0]);
 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xa0, 6);
 		break;
 		}
-- 
1.7.2.2

