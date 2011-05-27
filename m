Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab1E0UQ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 16:16:56 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4RKGthF002760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 27 May 2011 16:16:56 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] fintek-cir: make suspend with active IR more reliable
Date: Fri, 27 May 2011 16:16:54 -0400
Message-Id: <1306527414-19015-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There was a missing lock in fintek_suspend. Without the lock, its
possible the system will be in the middle of receiving IR (draining the
RX buffer) when we try to disable CIR interrupts.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/fintek-cir.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 8fa539d..7f7079b 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -597,12 +597,17 @@ static void __devexit fintek_remove(struct pnp_dev *pdev)
 static int fintek_suspend(struct pnp_dev *pdev, pm_message_t state)
 {
 	struct fintek_dev *fintek = pnp_get_drvdata(pdev);
+	unsigned long flags;
 
 	fit_dbg("%s called", __func__);
 
+	spin_lock_irqsave(&fintek->fintek_lock, flags);
+
 	/* disable all CIR interrupts */
 	fintek_cir_reg_write(fintek, CIR_STATUS_IRQ_MASK, CIR_STATUS);
 
+	spin_unlock_irqrestore(&fintek->fintek_lock, flags);
+
 	fintek_config_mode_enable(fintek);
 
 	/* disable cir logical dev */
-- 
1.7.1

