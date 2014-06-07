Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40271 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaFGV5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:04 -0400
Received: by mail-pb0-f51.google.com with SMTP id ma3so3933241pbc.10
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:03 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Jiada Wang <jiada_wang@mentor.com>
Subject: [PATCH 04/43] imx-drm: ipu-v3: Add solo/dual-lite IPU device type
Date: Sat,  7 Jun 2014 14:56:06 -0700
Message-Id: <1402178205-22697-5-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   18 ++++++++++++++++++
 include/linux/platform_data/imx-ipu-v3.h    |    1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index f8e8c56..2d95a7c 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -829,10 +829,28 @@ static struct ipu_devtype ipu_type_imx6q = {
 	.type = IPUV3H,
 };
 
+static struct ipu_devtype ipu_type_imx6dl = {
+	.name = "IPUv3HDL",
+	.cm_ofs = 0x00200000,
+	.cpmem_ofs = 0x00300000,
+	.srm_ofs = 0x00340000,
+	.tpm_ofs = 0x00360000,
+	.csi0_ofs = 0x00230000,
+	.csi1_ofs = 0x00238000,
+	.disp0_ofs = 0x00240000,
+	.disp1_ofs = 0x00248000,
+	.smfc_ofs =  0x00250000,
+	.ic_ofs = 0x00220000,
+	.vdi_ofs = 0x00268000,
+	.dc_tmpl_ofs = 0x00380000,
+	.type = IPUV3HDL,
+};
+
 static const struct of_device_id imx_ipu_dt_ids[] = {
 	{ .compatible = "fsl,imx51-ipu", .data = &ipu_type_imx51, },
 	{ .compatible = "fsl,imx53-ipu", .data = &ipu_type_imx53, },
 	{ .compatible = "fsl,imx6q-ipu", .data = &ipu_type_imx6q, },
+	{ .compatible = "fsl,imx6dl-ipu", .data = &ipu_type_imx6dl, },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, imx_ipu_dt_ids);
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index ca91dd9..8050277 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -23,6 +23,7 @@ enum ipuv3_type {
 	IPUV3EX,
 	IPUV3M,
 	IPUV3H,
+	IPUV3HDL,
 };
 
 #define IPU_PIX_FMT_GBR24	v4l2_fourcc('G', 'B', 'R', '3')
-- 
1.7.9.5

