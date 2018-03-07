Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:32041 "EHLO
        bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934221AbeCGWFv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 17:05:51 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v12 20/33] rcar-vin: add function to manipulate Gen3 chsel value
Date: Wed,  7 Mar 2018 23:04:58 +0100
Message-Id: <20180307220511.9826-21-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
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
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 38 ++++++++++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
 2 files changed, 40 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 483d31f07b934929..75382ee0f3fc1dde 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -16,6 +16,7 @@
 
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 
 #include <media/videobuf2-dma-contig.h>
 
@@ -1224,3 +1225,40 @@ int rvin_dma_register(struct rvin_dev *vin, int irq)
 
 	return ret;
 }
+
+/* -----------------------------------------------------------------------------
+ * Gen3 CHSEL manipulation
+ */
+
+/*
+ * There is no need to have locking around changing the routing
+ * as it's only possible to do so when no VIN in the group is
+ * streaming so nothing can race with the VNMC register.
+ */
+int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
+{
+	u32 ifmd, vnmc;
+	int ret;
+
+	ret = pm_runtime_get_sync(vin->dev);
+	if (ret < 0)
+		return ret;
+
+	/* Make register writes take effect immediately. */
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
+	/* Restore VNMC. */
+	rvin_write(vin, vnmc, VNMC_REG);
+
+	pm_runtime_put(vin->dev);
+
+	return ret;
+}
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 5e3ea8d401d934d1..8e20455927fe5224 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -169,4 +169,6 @@ const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 /* Cropping, composing and scaling */
 void rvin_crop_scale_comp(struct rvin_dev *vin);
 
+int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel);
+
 #endif
-- 
2.16.2
