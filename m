Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41829 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbeEUOio (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 10:38:44 -0400
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: <linux-media@vger.kernel.org>
CC: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
        Jarod Wilson <jarod@redhat.com>, Sean Young <sean@mess.org>
Subject: [PATCH 3/3] media: rc: nuvoton: Keep device enabled during reg init
Date: Mon, 21 May 2018 16:38:03 +0200
Message-ID: <20180521143803.25664-3-michal.winiarski@intel.com>
In-Reply-To: <20180521143803.25664-1-michal.winiarski@intel.com>
References: <20180521143803.25664-1-michal.winiarski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Doing writes when the device is disabled seems to be a NOOP.
Let's enable the device, write the values, and then disable it on init.
This changes the behavior for wake device, which is now being disabled
after init.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: Sean Young <sean@mess.org>
---
 drivers/media/rc/nuvoton-cir.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index eebd6fef5602..61b68cde35f1 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -535,6 +535,8 @@ static void nvt_set_cir_iren(struct nvt_dev *nvt)
 
 static void nvt_cir_regs_init(struct nvt_dev *nvt)
 {
+	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR);
+
 	/* set sample limit count (PE interrupt raised when reached) */
 	nvt_cir_reg_write(nvt, CIR_RX_LIMIT_COUNT >> 8, CIR_SLCH);
 	nvt_cir_reg_write(nvt, CIR_RX_LIMIT_COUNT & 0xff, CIR_SLCL);
@@ -546,10 +548,14 @@ static void nvt_cir_regs_init(struct nvt_dev *nvt)
 	/* clear hardware rx and tx fifos */
 	nvt_clear_cir_fifo(nvt);
 	nvt_clear_tx_fifo(nvt);
+
+	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
 }
 
 static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
 {
+	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
+
 	/*
 	 * Disable RX, set specific carrier on = low, off = high,
 	 * and sample period (currently 50us)
@@ -562,8 +568,7 @@ static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
 	/* clear any and all stray interrupts */
 	nvt_cir_wake_reg_write(nvt, 0xff, CIR_WAKE_IRSTS);
 
-	/* enable the CIR WAKE logical device */
-	nvt_enable_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
+	nvt_disable_logical_dev(nvt, LOGICAL_DEV_CIR);
 }
 
 static void nvt_enable_wake(struct nvt_dev *nvt)
-- 
2.17.0
