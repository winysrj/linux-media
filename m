Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:45742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1E0Pwz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 11:52:55 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4RFqtPT013444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 27 May 2011 11:52:55 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] nuvoton-cir: in_use isn't actually in use, remove it
Date: Fri, 27 May 2011 11:52:51 -0400
Message-Id: <1306511571-342-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/nuvoton-cir.c |    2 --
 drivers/media/rc/nuvoton-cir.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index bf3060e..565f24c 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -991,7 +991,6 @@ static int nvt_open(struct rc_dev *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&nvt->nvt_lock, flags);
-	nvt->in_use = true;
 	nvt_enable_cir(nvt);
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
@@ -1004,7 +1003,6 @@ static void nvt_close(struct rc_dev *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&nvt->nvt_lock, flags);
-	nvt->in_use = false;
 	nvt_disable_cir(nvt);
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 }
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 379795d..1241fc8 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -70,7 +70,6 @@ struct nvt_dev {
 	struct ir_raw_event rawir;
 
 	spinlock_t nvt_lock;
-	bool in_use;
 
 	/* for rx */
 	u8 buf[RX_BUF_LEN];
-- 
1.7.1

