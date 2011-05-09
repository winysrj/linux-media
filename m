Return-path: <mchehab@gaivota>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:41820 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754476Ab1EITyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:15 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 11/16] tm6000: remove input select
Date: Mon,  9 May 2011 21:53:59 +0200
Message-Id: <1304970844-20955-11-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

remove input select


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-core.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 1ac8409..57fd874 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -299,14 +299,6 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 
 		/* Disables soft reset */
 		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x00);
-
-		/* E3: Select input 0 - TV tuner */
-		tm6000_set_reg(dev, TM6000_REQ07_RE3_VADC_INP_LPF_SEL1, 0x00);
-		tm6000_set_reg(dev, TM6000_REQ07_REB_VADC_AADC_MODE, 0x60);
-
-		/* This controls input */
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_2, 0x0);
-		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_3, 0x01);
 	}
 	msleep(20);
 
-- 
1.7.4.2

