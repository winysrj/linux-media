Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.renesas.com ([202.234.163.13]:56718 "EHLO
	mail02.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751467AbZA3JSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 04:18:54 -0500
Date: Fri, 30 Jan 2009 13:10:14 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: [PATCH] sh_mobile_ceu: SOCAM flags are prepared at itself.
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Message-id: <uvdrxm9sd.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Signed-off-by: Magnus Damm <damm@igel.co.jp>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   27 +++++++++++++++++++++++++--
 include/media/sh_mobile_ceu.h              |    5 +++--
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 9cde91a..07b7b4c 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -101,6 +101,29 @@ struct sh_mobile_ceu_dev {
 	const struct soc_camera_data_format *camera_fmt;
 };
 
+static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
+{
+	unsigned long flags;
+
+	flags = SOCAM_SLAVE |
+		SOCAM_PCLK_SAMPLE_RISING |
+		SOCAM_HSYNC_ACTIVE_HIGH |
+		SOCAM_HSYNC_ACTIVE_LOW |
+		SOCAM_VSYNC_ACTIVE_HIGH |
+		SOCAM_VSYNC_ACTIVE_LOW;
+
+	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_8BIT_BUS)
+		flags |= SOCAM_DATAWIDTH_8;
+
+	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_16BIT_BUS)
+		flags |= SOCAM_DATAWIDTH_16;
+
+	if (flags & SOCAM_DATAWIDTH_MASK)
+		return flags;
+
+	return 0;
+}
+
 static void ceu_write(struct sh_mobile_ceu_dev *priv,
 		      unsigned long reg_offs, u32 data)
 {
@@ -396,7 +419,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 
 	camera_flags = icd->ops->query_bus_param(icd);
 	common_flags = soc_camera_bus_param_compatible(camera_flags,
-						       pcdev->pdata->flags);
+						       make_bus_param(pcdev));
 	if (!common_flags)
 		return -EINVAL;
 
@@ -517,7 +540,7 @@ static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd)
 
 	camera_flags = icd->ops->query_bus_param(icd);
 	common_flags = soc_camera_bus_param_compatible(camera_flags,
-						       pcdev->pdata->flags);
+						       make_bus_param(pcdev));
 	if (!common_flags)
 		return -EINVAL;
 
diff --git a/include/media/sh_mobile_ceu.h b/include/media/sh_mobile_ceu.h
index b5dbefe..0f3524c 100644
--- a/include/media/sh_mobile_ceu.h
+++ b/include/media/sh_mobile_ceu.h
@@ -1,10 +1,11 @@
 #ifndef __ASM_SH_MOBILE_CEU_H__
 #define __ASM_SH_MOBILE_CEU_H__
 
-#include <media/soc_camera.h>
+#define SH_CEU_FLAG_USE_8BIT_BUS	(1 << 0) /* use  8bit bus width */
+#define SH_CEU_FLAG_USE_16BIT_BUS	(1 << 1) /* use 16bit bus width */
 
 struct sh_mobile_ceu_info {
-	unsigned long flags; /* SOCAM_... */
+	unsigned long flags;
 };
 
 #endif /* __ASM_SH_MOBILE_CEU_H__ */
-- 
1.5.6.3

