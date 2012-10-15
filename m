Return-path: <linux-media-owner@vger.kernel.org>
Received: from 84-245-11-97.dsl.cambrium.nl ([84.245.11.97]:40506 "EHLO
	grubby.stderr.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752388Ab2JOL4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 07:56:30 -0400
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-media@vger.kernel.org
Cc: Luis Henriques <luis.henriques@canonical.com>,
	Jarod Wilson <jarod@redhat.com>,
	Stephan Raue <stephan@openelec.tv>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthijs Kooijman <matthijs@stdin.nl>
Subject: [PATCH 3/4] [media] rc: Set rdev before irq setup
Date: Mon, 15 Oct 2012 13:13:46 +0200
Message-Id: <1350299627-14339-3-git-send-email-matthijs@stdin.nl>
In-Reply-To: <1350299627-14339-1-git-send-email-matthijs@stdin.nl>
References: <20121015110111.GD17159@login.drsnuggles.stderr.nl>
 <1350299627-14339-1-git-send-email-matthijs@stdin.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a problem in fintek-cir, ite-cir and nuvoton-cir where the
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
---
 drivers/media/rc/fintek-cir.c  |    4 +++-
 drivers/media/rc/ite-cir.c     |    3 ++-
 drivers/media/rc/nuvoton-cir.c |    3 ++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 8284d28..54809b8 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -552,6 +552,8 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 	/* rx resolution is hardwired to 50us atm, 1, 25, 100 also possible */
 	rdev->rx_resolution = US_TO_NS(CIR_SAMPLE_PERIOD);
 
+	fintek->rdev = rdev;
+
 	ret = -EBUSY;
 	/* now claim resources */
 	if (!request_region(fintek->cir_addr,
@@ -567,7 +569,7 @@ static int fintek_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id
 		goto exit_free_irq;
 
 	device_init_wakeup(&pdev->dev, true);
-	fintek->rdev = rdev;
+
 	fit_pr(KERN_NOTICE, "driver has been successfully loaded\n");
 	if (debug)
 		cir_dump_regs(fintek);
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 77cb21f..158bd0a 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1590,6 +1590,8 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	rdev->driver_name = ITE_DRIVER_NAME;
 	rdev->map_name = RC_MAP_RC6_MCE;
 
+	itdev->rdev = rdev;
+
 	ret = -EBUSY;
 	/* now claim resources */
 	if (!request_region(itdev->cir_addr,
@@ -1604,7 +1606,6 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
 	if (ret)
 		goto exit_free_irq;
 
-	itdev->rdev = rdev;
 	ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
 
 	return 0;
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 8ab6843..a1b6be6 100644
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

