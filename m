Return-path: <mchehab@pedra>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:55378 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450Ab1DDUS5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 16:18:57 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 1/5] tm6000: add mts parameter
Date: Mon,  4 Apr 2011 22:18:40 +0200
Message-Id: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

add mts parameter


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 146c7e8..eef58da 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -61,6 +61,10 @@ module_param_array(card,  int, NULL, 0444);
 
 static unsigned long tm6000_devused;
 
+static unsigned int xc2028_mts;
+module_param(xc2028_mts, int, 0644);
+MODULE_PARM_DESC(xc2028_mts, "enable mts firmware (xc2028/3028 only)");
+
 
 struct tm6000_board {
 	char            *name;
@@ -685,6 +689,9 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 		ctl.demod = XC3028_FE_ZARLINK456;
 		ctl.vhfbw7 = 1;
 		ctl.uhfbw8 = 1;
+		if (xc2028_mts)
+			ctl.mts = 1;
+
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
 
-- 
1.7.3.4

