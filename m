Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:46166 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862Ab0G0G3d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 02:29:33 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: bugfix bad marge
Date: Tue, 27 Jul 2010 08:29:10 +0200
Message-Id: <1280212150-4879-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-core.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 9f60ad5..1fea5a0 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -341,12 +341,6 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 			dev->gpio.dvb_led, 0x01);
 	}
 
-	/* switch dvb led off */
-	if (dev->gpio.dvb_led) {
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-			dev->gpio.dvb_led, 0x01);
-	}
-
 	return 0;
 }
 
-- 
1.7.1

