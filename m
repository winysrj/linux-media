Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:22645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab1EIT7U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:59:20 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	=?UTF-8?q?Juan=20Jes=C3=BAs=20Garc=C3=ADa=20de=20Soria?=
	<skandalfo@gmail.com>
Subject: [PATCH] [media] ite-cir: finish tx before suspending
Date: Mon,  9 May 2011 15:59:16 -0400
Message-Id: <1304971156-26650-1-git-send-email-jarod@redhat.com>
In-Reply-To: <4DC84470.7060603@redhat.com>
References: <4DC84470.7060603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Continuing with IR transmit after resuming from suspend seems fairly
useless, given that the only place we can actually end up suspending is
after IR has been send and we're simply mdelay'ing. Lets simplify the
resume path by just waiting on tx to complete in the suspend path, then
we know we can't be transmitting on resume, and reinitialization of the
hardware registers becomes more straight-forward.

CC: Juan Jesús García de Soria <skandalfo@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
Nb: this patch relies upon my earlier patch to add the init_hardware
calls to the resume path in the first place.

 drivers/media/rc/ite-cir.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index d1dec5c..e716b93 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1650,6 +1650,9 @@ static int ite_suspend(struct pnp_dev *pdev, pm_message_t state)
 
 	ite_dbg("%s called", __func__);
 
+	/* wait for any transmission to end */
+	wait_event_interruptible(dev->tx_ended, !dev->transmitting);
+
 	spin_lock_irqsave(&dev->lock, flags);
 
 	/* disable all interrupts */
@@ -1670,15 +1673,10 @@ static int ite_resume(struct pnp_dev *pdev)
 
 	spin_lock_irqsave(&dev->lock, flags);
 
-	if (dev->transmitting) {
-		/* wake up the transmitter */
-		wake_up_interruptible(&dev->tx_queue);
-	} else {
-		/* reinitialize hardware config registers */
-		dev->params.init_hardware(dev);
-		/* enable the receiver */
-		dev->params.enable_rx(dev);
-	}
+	/* reinitialize hardware config registers */
+	dev->params.init_hardware(dev);
+	/* enable the receiver */
+	dev->params.enable_rx(dev);
 
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-- 
1.7.1

