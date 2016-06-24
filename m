Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33916 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbcFXFkV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 01:40:21 -0400
Received: by mail-wm0-f67.google.com with SMTP id 187so2192668wmz.1
        for <linux-media@vger.kernel.org>; Thu, 23 Jun 2016 22:40:21 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 3/9] media: rc: nuvoton: remove wake states
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <bd19d0a2-fbb0-00cc-c0e2-5b41dc4ae85d@gmail.com>
Date: Fri, 24 Jun 2016 07:39:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wake states have never been in use and now that we can set the
wakeup sequence via sysfs there's in general no need for them.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 1 -
 drivers/media/rc/nuvoton-cir.h | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index c8999cc..c405c83 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1207,7 +1207,6 @@ static int nvt_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 	/* zero out misc state tracking */
 	nvt->study_state = ST_STUDY_NONE;
-	nvt->wake_state = ST_WAKE_NONE;
 
 	/* disable all CIR interrupts */
 	nvt_cir_reg_write(nvt, 0, CIR_IREN);
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 68431f0..8bd35bd 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -117,8 +117,6 @@ struct nvt_dev {
 	/* rx settings */
 	bool learning_enabled;
 
-	/* track cir wake state */
-	u8 wake_state;
 	/* for study */
 	u8 study_state;
 	/* carrier period = 1 / frequency */
@@ -131,11 +129,6 @@ struct nvt_dev {
 #define ST_STUDY_CARRIER   0x2
 #define ST_STUDY_ALL_RECV  0x4
 
-/* wake states */
-#define ST_WAKE_NONE	0x0
-#define ST_WAKE_START	0x1
-#define ST_WAKE_FINISH	0x2
-
 /* receive states */
 #define ST_RX_WAIT_7F		0x1
 #define ST_RX_WAIT_HEAD		0x2
-- 
2.9.0

