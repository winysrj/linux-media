Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42967 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbeHFTGa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 15:06:30 -0400
Received: by mail-lf1-f68.google.com with SMTP id u202-v6so9561380lff.9
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 09:56:31 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH] rcar-csi2: add R8A77980 support
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Message-ID: <f6edfd44-7b08-e467-3486-795251816187@cogentembedded.com>
Date: Mon, 6 Aug 2018 19:56:27 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the R-Car V3H (AKA R8A77980) SoC support to the R-Car CSI2 driver.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is against the 'media_tree.git' repo's 'master' branch.

 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt |    1 
 drivers/media/platform/rcar-vin/rcar-csi2.c                   |   11 ++++++++++
 2 files changed, 12 insertions(+)

Index: media_tree/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
===================================================================
--- media_tree.orig/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
+++ media_tree/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
@@ -12,6 +12,7 @@ Mandatory properties
    - "renesas,r8a7796-csi2" for the R8A7796 device.
    - "renesas,r8a77965-csi2" for the R8A77965 device.
    - "renesas,r8a77970-csi2" for the R8A77970 device.
+   - "renesas,r8a77980-csi2" for the R8A77980 device.
 
  - reg: the register base and size for the device registers
  - interrupts: the interrupt for the device
Index: media_tree/drivers/media/platform/rcar-vin/rcar-csi2.c
===================================================================
--- media_tree.orig/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ media_tree/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -959,6 +959,13 @@ static const struct rcar_csi2_info rcar_
 	.confirm_start = rcsi2_confirm_start_v3m_e3,
 };
 
+static const struct rcar_csi2_info rcar_csi2_info_r8a77980 = {
+	.init_phtw = rcsi2_init_phtw_h3_v3h_m3n,
+	.hsfreqrange = hsfreqrange_h3_v3h_m3n,
+	.csi0clkfreqrange = 0x20,
+	.clear_ulps = true,
+};
+
 static const struct of_device_id rcar_csi2_of_table[] = {
 	{
 		.compatible = "renesas,r8a7795-csi2",
@@ -976,6 +983,10 @@ static const struct of_device_id rcar_cs
 		.compatible = "renesas,r8a77970-csi2",
 		.data = &rcar_csi2_info_r8a77970,
 	},
+	{
+		.compatible = "renesas,r8a77980-csi2",
+		.data = &rcar_csi2_info_r8a77980,
+	},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, rcar_csi2_of_table);
