Return-path: <linux-media-owner@vger.kernel.org>
Received: from 84-245-11-97.dsl.cambrium.nl ([84.245.11.97]:37227 "EHLO
	grubby.stderr.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753358Ab2KBNOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2012 09:14:34 -0400
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stephan Raue <stephan@openelec.tv>,
	Luis Henriques <luis.henriques@canonical.com>,
	Matthijs Kooijman <matthijs@stdin.nl>,
	Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/3] [media] rc: Set rdev before irq setup
Date: Fri,  2 Nov 2012 14:13:55 +0100
Message-Id: <1351862036-20384-3-git-send-email-matthijs@stdin.nl>
In-Reply-To: <1351862036-20384-1-git-send-email-matthijs@stdin.nl>
References: <20121015110111.GD17159@login.drsnuggles.stderr.nl>
 <1351862036-20384-1-git-send-email-matthijs@stdin.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a problem in fintek-cir and nuvoton-cir where the
irq handler would trigger during module load before the rdev member was
set, causing a NULL pointer crash.

It seems this crash is very reproducible (just bombard the receiver with
IR signals during module load), probably because when request_irq is
called, any pending intterupt is handled immediately, before
request_irq returns and rdev can be set.

This same crash was supposed to be fixed by commit
9ef449c6b31bb6a8e6dedc24de475a3b8c79be20 ("[media] rc: Postpone ISR
registration"), but the crash was still observed on the nuvoton-cir
driver.

This commit was tested on nuvoton-cir only.

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
Cc: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/fintek-cir.c  |    4 +++-
 drivers/media/rc/nuvoton-cir.c |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 3d5e57c..5eefe65 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -557,6 +557,8 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	/* rx resolution is hardwired to 50us atm, 1, 25, 100 also possible */
 	rdev->rx_resolution = US_TO_NS(CIR_SAMPLE_PERIOD);
 
+	fintek->rdev = rdev;
+
 	ret = -EBUSY;
 	/* now claim resources */
 	if (!request_region(fintek->cir_addr,
@@ -572,7 +574,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 		goto exit_free_irq;
 
 	device_init_wakeup(&pdev->dev, true);
-	fintek->rdev = rdev;
+
 	fit_pr(KERN_NOTICE, "driver has been successfully loaded\n");
 	if (debug)
 		cir_dump_regs(fintek);
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 3477e23..c6441e6 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1065,6 +1065,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 	/* tx bits */
 	rdev->tx_resolution = XYZ;
 #endif
+	nvt->rdev = rdev;
 
 	ret = -EBUSY;
 	/* now claim resources */
@@ -1089,7 +1090,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 		goto exit_free_wake_irq;
 
 	device_init_wakeup(&pdev->dev, true);
-	nvt->rdev = rdev;
+
 	nvt_pr(KERN_NOTICE, "driver has been successfully loaded\n");
 	if (debug) {
 		cir_dump_regs(nvt);
-- 
1.7.10

