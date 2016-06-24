Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33995 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbcFXFk2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 01:40:28 -0400
Received: by mail-wm0-f65.google.com with SMTP id 187so2193140wmz.1
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2016 22:40:28 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 9/9] media: rc: nuvoton: remove two unused elements in struct
 nvt_dev
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <f176b83d-75ce-ed7e-a167-d6c661c2f672@gmail.com>
Date: Fri, 24 Jun 2016 07:40:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two fields are not used and can be removed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 65324ef..acf735f 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -111,12 +111,8 @@ struct nvt_dev {
 	u8 chip_minor;
 
 	/* hardware features */
-	bool hw_learning_capable;
 	bool hw_tx_capable;
 
-	/* rx settings */
-	bool learning_enabled;
-
 	/* carrier period = 1 / frequency */
 	u32 carrier;
 };
-- 
2.9.0

