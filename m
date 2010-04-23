Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:59246 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757712Ab0DWPpW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 11:45:22 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: renaming firmware
Date: Fri, 23 Apr 2010 17:43:42 +0200
Message-Id: <1272037422-4905-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

renaming tm6000-xc3028.fw to xc3028-v24.fw

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index f795a3e..d5edc78 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -533,7 +533,7 @@ static void tm6000_config_tuner (struct tm6000_core *dev)
 			if (dev->dev_type == TM6010)
 				ctl.fname = "xc3028-v27.fw";
 			else
-				ctl.fname = "tm6000-xc3028.fw";
+				ctl.fname = "xc3028-v24.fw";
 		}
 
 		printk(KERN_INFO "Setting firmware parameters for xc2028\n");
-- 
1.6.6.1

