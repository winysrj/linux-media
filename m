Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34870 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbcGFXHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:35 -0400
Received: by mail-pa0-f68.google.com with SMTP id dx3so93670pab.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:35 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Suresh Dhandapani <Suresh.Dhandapani@in.bosch.com>
Subject: [PATCH 12/28] gpu: ipu-v3: Fix CSI0 blur in NTSC format
Date: Wed,  6 Jul 2016 16:06:42 -0700
Message-Id: <1467846418-12913-13-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Suresh Dhandapani <Suresh.Dhandapani@in.bosch.com>

This patch will change the register IPU_CSI0_CCIR_CODE_2 value from
0x40596 to 0x405A6. The change is related to the Start of field 1
first blanking line command bit[5-3] for NTSC format only. This
change is dependent with ADV chip where the NEWAVMODE is set to 0
in register 0x31. Setting NEWAVMODE to "0" in ADV means "EAV/SAV
codes generated to suit analog devices encoders".

Signed-off-by: Suresh Dhandapani <Suresh.Dhandapani@in.bosch.com>
---
 drivers/gpu/ipu-v3/ipu-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index 0eac28c..ec81958 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -422,7 +422,7 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
 
 			ipu_csi_write(csi, 0xD07DF | CSI_CCIR_ERR_DET_EN,
 					  CSI_CCIR_CODE_1);
-			ipu_csi_write(csi, 0x40596, CSI_CCIR_CODE_2);
+			ipu_csi_write(csi, 0x405A6, CSI_CCIR_CODE_2);
 			ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
 		} else {
 			dev_err(csi->ipu->dev,
-- 
1.9.1

