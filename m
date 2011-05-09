Return-path: <mchehab@gaivota>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:51277 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512Ab1EITyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:14 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 08/16] tm6000: remove old tuner params
Date: Mon,  9 May 2011 21:53:56 +0200
Message-Id: <1304970844-20955-8-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

remove old tuner params


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 19120ed..8ca8727 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -922,12 +922,8 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 		memset(&xc2028_cfg, 0, sizeof(xc2028_cfg));
 		memset(&ctl, 0, sizeof(ctl));
 
-		ctl.input1 = 1;
-		ctl.read_not_reliable = 0;
-		ctl.msleep = 10;
 		ctl.demod = XC3028_FE_ZARLINK456;
-		ctl.vhfbw7 = 1;
-		ctl.uhfbw8 = 1;
+
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
 
-- 
1.7.4.2

