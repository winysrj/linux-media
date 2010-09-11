Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40561 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab0IKRdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 13:33:47 -0400
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Joe Perches <joe@perches.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 2/2] media: cx23885: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 20:33:28 +0300
Message-Id: <28b7342272db43227dcb3a06931e2ab4dd866fe3.1284226282.git.andy.shevchenko@gmail.com>
In-Reply-To: <0ffd3b30fbaa2168656dd17fbdb290cf2e0a867e.1284226281.git.andy.shevchenko@gmail.com>
References: <0ffd3b30fbaa2168656dd17fbdb290cf2e0a867e.1284226281.git.andy.shevchenko@gmail.com>
In-Reply-To: <0ffd3b30fbaa2168656dd17fbdb290cf2e0a867e.1284226281.git.andy.shevchenko@gmail.com>
References: <0ffd3b30fbaa2168656dd17fbdb290cf2e0a867e.1284226281.git.andy.shevchenko@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/media/video/cx23885/cx23885-dvb.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 3d70af2..0674ea1 100644
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
+		printk(KERN_INFO "TeVii S470 MAC= %pM\n", eeprom + 0xa0);
 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xa0, 6);
 		break;
 		}
-- 
1.7.2.2

