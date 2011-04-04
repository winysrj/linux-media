Return-path: <mchehab@pedra>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:35115 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450Ab1DDUS7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 16:18:59 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 2/5] tm6000: add dtv78 parameter
Date: Mon,  4 Apr 2011 22:18:41 +0200
Message-Id: <1301948324-27186-2-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

add dtv78 parameter


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index eef58da..cf2e76c 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -65,6 +65,9 @@ static unsigned int xc2028_mts;
 module_param(xc2028_mts, int, 0644);
 MODULE_PARM_DESC(xc2028_mts, "enable mts firmware (xc2028/3028 only)");
 
+static unsigned int xc2028_dtv78;
+module_param(xc2028_dtv78, int, 0644);
+MODULE_PARM_DESC(xc2028_dtv78, "enable dualband config (xc2028/3028 only)");
 
 struct tm6000_board {
 	char            *name;
@@ -687,8 +690,12 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 		ctl.read_not_reliable = 0;
 		ctl.msleep = 10;
 		ctl.demod = XC3028_FE_ZARLINK456;
-		ctl.vhfbw7 = 1;
-		ctl.uhfbw8 = 1;
+
+		if (xc2028_dtv78) {
+			ctl.vhfbw7 = 1;
+			ctl.uhfbw8 = 1;
+		}
+
 		if (xc2028_mts)
 			ctl.mts = 1;
 
-- 
1.7.3.4

