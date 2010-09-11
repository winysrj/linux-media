Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61490 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0IKOAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 10:00:20 -0400
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 1/2] dvb: mantis: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 16:59:58 +0300
Message-Id: <a548f44961f97f81054fc877aaef068f936c5ca2.1284213506.git.andy.shevchenko@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/media/dvb/mantis/mantis_core.c |    5 +----
 drivers/media/dvb/mantis/mantis_ioc.c  |    9 +--------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_core.c b/drivers/media/dvb/mantis/mantis_core.c
index 8113b23..0163e8e 100644
--- a/drivers/media/dvb/mantis/mantis_core.c
+++ b/drivers/media/dvb/mantis/mantis_core.c
@@ -91,10 +91,7 @@ static int get_mac_address(struct mantis_pci *mantis)
 		return err;
 	}
 	dprintk(verbose, MANTIS_ERROR, 0,
-		"    MAC Address=[%02x:%02x:%02x:%02x:%02x:%02x]\n",
-		mantis->mac_address[0], mantis->mac_address[1],
-		mantis->mac_address[2],	mantis->mac_address[3],
-		mantis->mac_address[4], mantis->mac_address[5]);
+		"    MAC Address=[%pM]\n", &mantis->mac_address[0]);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/mantis/mantis_ioc.c b/drivers/media/dvb/mantis/mantis_ioc.c
index de148de..8932f34 100644
--- a/drivers/media/dvb/mantis/mantis_ioc.c
+++ b/drivers/media/dvb/mantis/mantis_ioc.c
@@ -68,14 +68,7 @@ int mantis_get_mac(struct mantis_pci *mantis)
 		return err;
 	}
 
-	dprintk(MANTIS_ERROR, 0,
-		"    MAC Address=[%02x:%02x:%02x:%02x:%02x:%02x]\n",
-		mac_addr[0],
-		mac_addr[1],
-		mac_addr[2],
-		mac_addr[3],
-		mac_addr[4],
-		mac_addr[5]);
+	dprintk(MANTIS_ERROR, 0, "    MAC Address=[%pM]\n", &mac_addr[0]);
 
 	return 0;
 }
-- 
1.7.2.2

