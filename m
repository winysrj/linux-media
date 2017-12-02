Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:42725 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdLBGaA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Dec 2017 01:30:00 -0500
Received: by mail-pl0-f68.google.com with SMTP id bd8so7508844plb.9
        for <linux-media@vger.kernel.org>; Fri, 01 Dec 2017 22:30:00 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: g.liakhovetski@gmx.de, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: trivial@kernel.org, Daniel Axtens <dja@axtens.net>
Subject: [PATCH] [media] soc_camera: add MODULE_LICENSE to soc_scale_crop.c
Date: Sat,  2 Dec 2017 17:29:46 +1100
Message-Id: <20171202062946.19527-1-dja@axtens.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the following warning on an allmodconfig build:
WARNING: modpost: missing MODULE_LICENSE() in drivers/media/platform/soc_camera/soc_scale_crop.o

Use license "GPL" to match the GPLv2+ license from the header at
the top of the file.

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 drivers/media/platform/soc_camera/soc_scale_crop.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index 270ec613c27c..095753951888 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -420,3 +420,5 @@ void soc_camera_calc_client_output(struct soc_camera_device *icd,
 	mf->height = soc_camera_shift_scale(rect->height, shift, scale_v);
 }
 EXPORT_SYMBOL(soc_camera_calc_client_output);
+
+MODULE_LICENSE("GPL");
-- 
2.11.0
