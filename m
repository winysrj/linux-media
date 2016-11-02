Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:49486 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754501AbcKBN3n (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 09:29:43 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 19/32] media: rcar-vin: add functions to manipulate Gen3 CHSEL value
Date: Wed,  2 Nov 2016 14:23:16 +0100
Message-Id: <20161102132329.436-20-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Gen3 the CSI routing is controlled by the VnCSI_IFMD register. One
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
 drivers/media/platform/rcar-vin/rcar-dma.c | 43 ++++++++++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h |  3 +++
 2 files changed, 46 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 80958e6..322e4c1 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -16,6 +16,7 @@
 
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 
 #include <media/videobuf2-dma-contig.h>
 
@@ -1247,3 +1248,45 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
 
 	return ret;
 }
+
+/* -----------------------------------------------------------------------------
+ * Gen3 CHSEL manipulation
+ */
+
+int rvin_set_chsel(struct rvin_dev *vin, u8 chsel)
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
+
+	return 0;
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
index b8f5634..a6a49a96 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -184,4 +184,7 @@ void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
 		    u32 width, u32 height);
 void rvin_crop_scale_comp(struct rvin_dev *vin);
 
+int rvin_set_chsel(struct rvin_dev *vin, u8 chsel);
+int rvin_get_chsel(struct rvin_dev *vin);
+
 #endif
-- 
2.10.2

