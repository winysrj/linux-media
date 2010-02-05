Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:36907 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933984Ab0BEWs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:48:57 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 8/12] tm6000: add tuner parameter
Date: Fri,  5 Feb 2010 23:48:12 +0100
Message-Id: <1265410096-11788-7-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410096-11788-6-git-send-email-stefan.ringel@arcor.de>
References: <1265410096-11788-1-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-2-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-3-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-5-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-6-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

---
 drivers/staging/tm6000/tm6000-cards.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 4592397..f22f8ad 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -312,7 +312,7 @@ static void tm6000_config_tuner (struct tm6000_core *dev)
 	memset(&tun_setup, 0, sizeof(tun_setup));
 	tun_setup.type   = dev->tuner_type;
 	tun_setup.addr   = dev->tuner_addr;
-	tun_setup.mode_mask = T_ANALOG_TV | T_RADIO;
+	tun_setup.mode_mask = T_ANALOG_TV | T_RADIO | T_DIGITAL_TV;
 	tun_setup.tuner_callback = tm6000_tuner_callback;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr, &tun_setup);
@@ -324,10 +324,12 @@ static void tm6000_config_tuner (struct tm6000_core *dev)
 		memset(&xc2028_cfg, 0, sizeof(xc2028_cfg));
 		memset (&ctl,0,sizeof(ctl));
 
-		ctl.mts   = 1;
-		ctl.read_not_reliable = 1;
+		ctl.input1 = 1;
+		ctl.read_not_reliable = 0;
 		ctl.msleep = 10;
-
+		ctl.demod = XC3028_FE_ZARLINK456;
+		ctl.vhfbw7 = 1;
+		ctl.uhfbw8 = 1;
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
 
-- 
1.6.4.2

