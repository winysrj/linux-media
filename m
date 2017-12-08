Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:44896 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbdLHBJB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 20:09:01 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v9 16/28] rcar-vin: add function to manipulate Gen3 chsel value
Date: Fri,  8 Dec 2017 02:08:30 +0100
Message-Id: <20171208010842.20047-17-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
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
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 25 +++++++++++++++++++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index ace95d5b543a17e3..d2788d8bb9565aaa 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -16,6 +16,7 @@
 
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
 
 #include <media/videobuf2-dma-contig.h>
 
@@ -1228,3 +1229,27 @@ int rvin_dma_register(struct rvin_dev *vin, int irq)
 
 	return ret;
 }
+
+/* -----------------------------------------------------------------------------
+ * Gen3 CHSEL manipulation
+ */
+
+void rvin_set_chsel(struct rvin_dev *vin, u8 chsel)
+{
+	u32 ifmd, vnmc;
+
+	pm_runtime_get_sync(vin->dev);
+
+	/* Make register writes take effect immediately */
+	vnmc = rvin_read(vin, VNMC_REG) & ~VNMC_VUP;
+	rvin_write(vin, vnmc, VNMC_REG);
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
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index a440effe4b86af31..7819c760c2c13422 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -163,4 +163,6 @@ void rvin_v4l2_unregister(struct rvin_dev *vin);
 
 const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 
+void rvin_set_chsel(struct rvin_dev *vin, u8 chsel);
+
 #endif
-- 
2.15.0
