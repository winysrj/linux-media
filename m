Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:47957 "EHLO
        bin-vsp-out-03.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751592AbeA2Qfd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 11:35:33 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v10 13/30] rcar-vin: add function to manipulate Gen3 chsel value
Date: Mon, 29 Jan 2018 17:34:18 +0100
Message-Id: <20180129163435.24936-14-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Gen3 the CSI-2 routing is controlled by the VnCSI_IFMD register. One
feature of this register is that it's only present in the VIN0 and VIN4
instances. The register in VIN0 controls the routing for VIN0-3 and the
register in VIN4 controls routing for VIN4-7.

To be able to control routing from a media device this function is need
to control runtime PM for the subgroup master (VIN0 and VIN4). The
subgroup master must be switched on before the register is manipulated,
once the operation is complete it's safe to switch the master off and
the new routing will still be in effect.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 28 ++++++++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
 2 files changed, 30 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 2f9ad1bec1c8a92f..ae286742f15a3ab5 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -16,6 +16,7 @@
 
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 
 #include <media/videobuf2-dma-contig.h>
 
@@ -1228,3 +1229,30 @@ int rvin_dma_register(struct rvin_dev *vin, int irq)
 
 	return ret;
 }
+
+/* -----------------------------------------------------------------------------
+ * Gen3 CHSEL manipulation
+ */
+
+void rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
+{
+	u32 ifmd, vnmc;
+
+	pm_runtime_get_sync(vin->dev);
+
+	/* Make register writes take effect immediately */
+	vnmc = rvin_read(vin, VNMC_REG);
+	rvin_write(vin, vnmc & ~VNMC_VUP, VNMC_REG);
+
+	ifmd = VNCSI_IFMD_DES2 | VNCSI_IFMD_DES1 | VNCSI_IFMD_DES0 |
+		VNCSI_IFMD_CSI_CHSEL(chsel);
+
+	rvin_write(vin, ifmd, VNCSI_IFMD_REG);
+
+	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
+
+	/* Restore VNMC */
+	rvin_write(vin, vnmc, VNMC_REG);
+
+	pm_runtime_put(vin->dev);
+}
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 146683142e6533fa..a5dae5b5e9cb704b 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -165,4 +165,6 @@ const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 /* Cropping, composing and scaling */
 void rvin_crop_scale_comp(struct rvin_dev *vin);
 
+void rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel);
+
 #endif
-- 
2.16.1
