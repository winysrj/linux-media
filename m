Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:46823 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752720AbdKTU4e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 15:56:34 -0500
From: Jesse Chan <jc@linux.com>
Cc: Jesse Chan <jc@linux.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] soc_camera: soc_scale_crop: add missing MODULE_DESCRIPTION/AUTHOR/LICENSE
Date: Mon, 20 Nov 2017 12:56:28 -0800
Message-Id: <20171120205628.85855-1-jc@linux.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change resolves a new compile-time warning
when built as a loadable module:

WARNING: modpost: missing MODULE_LICENSE() in drivers/media/platform/soc_camera/soc_scale_crop.o
see include/linux/module.h for more information

This adds the license as "GPL", which matches the header of the file.

MODULE_DESCRIPTION and MODULE_AUTHOR are also added.

Signed-off-by: Jesse Chan <jc@linux.com>
---
 drivers/media/platform/soc_camera/soc_scale_crop.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index 0116097c0c0f..092c73f24589 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -419,3 +419,7 @@ void soc_camera_calc_client_output(struct soc_camera_device *icd,
 	mf->height = soc_camera_shift_scale(rect->height, shift, scale_v);
 }
 EXPORT_SYMBOL(soc_camera_calc_client_output);
+
+MODULE_DESCRIPTION("soc-camera scaling-cropping functions");
+MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
+MODULE_LICENSE("GPL");
-- 
2.14.1
