Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:56038 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752814AbdHVX2q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 19:28:46 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v6 14/25] rcar-vin: add functions to manipulate Gen3 CHSEL value
Date: Wed, 23 Aug 2017 01:26:29 +0200
Message-Id: <20170822232640.26147-15-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Gen3 the CSI-2 routing is controlled by the VnCSI_IFMD register. One
feature of this register is that it's only present in the VIN0 and VIN4
instances. The register in VIN0 controls the routing for VIN0-3 and the
register in VIN4 controls routing for VIN4-7.

To be able to control routing from a media device these functions need
to control runtime PM for the subgroup master (VIN0 and VIN4). The
subgroup master must be switched on before the register is manipulated,
once the operation is complete it's safe to switch the master off and
the new routing will still be in effect.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 41 ++++++++++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h |  3 +++
 2 files changed, 44 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index c4f8e81e88c99e28..6206fab7b6cdc55a 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -16,6 +16,7 @@
 
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 
 #include <media/videobuf2-dma-contig.h>
 
@@ -1228,3 +1229,43 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
 
 	return ret;
 }
+
+/* -----------------------------------------------------------------------------
+ * Gen3 CHSEL manipulation
+ */
+
+void rvin_set_chsel(struct rvin_dev *vin, u8 chsel)
+{
+	u32 ifmd;
+
+	pm_runtime_get_sync(vin->dev);
+
+	/*
+	 * Undocumented feature: Writing to VNCSI_IFMD_REG will go
+	 * through and on read back look correct but won't have
+	 * any effect if VNMC_REG is not first set to 0.
+	 */
+	rvin_write(vin, 0, VNMC_REG);
+
+	ifmd = VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
+		VNCSI_IFMD_CSI_CHSEL(chsel);
+
+	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
+
+	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
+
+	pm_runtime_put(vin->dev);
+}
+
+int rvin_get_chsel(struct rvin_dev *vin)
+{
+	int chsel;
+
+	pm_runtime_get_sync(vin->dev);
+
+	chsel = rvin_read(vin, VNCSI_IFMD_REG) & VNCSI_IFMD_CSI_CHSEL_MASK;
+
+	pm_runtime_put(vin->dev);
+
+	return chsel;
+}
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index c4608686666d2d81..94c606f2b8f2f246 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -164,4 +164,7 @@ int rvin_reset_format(struct rvin_dev *vin);
 
 const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 
+void rvin_set_chsel(struct rvin_dev *vin, u8 chsel);
+int rvin_get_chsel(struct rvin_dev *vin);
+
 #endif
-- 
2.14.0
