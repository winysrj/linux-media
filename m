Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:42623 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbeHNL60 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:58:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Todor Tomov <todor.tomov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Hans Verkuil <hansverk@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: camss: add missing includes
Date: Tue, 14 Aug 2018 11:11:30 +0200
Message-Id: <20180814091200.1851395-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Multiple files in this driver fail to build because of missing
header inclusions:

drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c: In function 'csiphy_hw_version_read':
drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c:31:18: error: implicit declaration of function 'readl_relaxed'; did you mean 'xchg_relaxed'? [-Werror=implicit-function-declaration]
drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c: In function 'csiphy_hw_version_read':
drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c:52:2: error: implicit declaration of function 'writel' [-Werror=implicit-function-declaration]
drivers/media/platform/qcom/camss/camss-ispif.c: In function 'msm_ispif_subdev_init':
drivers/media/platform/qcom/camss/camss-ispif.c:1079:16: error: implicit declaration of function 'kcalloc'; did you mean 'kvcalloc'? [-Werror=implicit-function-declaration]

Add the ones that I observed, plus linux/io.h in all other files that
call readl/writel and related interfaces.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c | 1 +
 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c | 1 +
 drivers/media/platform/qcom/camss/camss-ispif.c          | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c b/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
index c832539397d7..12bce391d71f 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
@@ -12,6 +12,7 @@
 
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 
 #define CAMSS_CSI_PHY_LNn_CFG2(n)		(0x004 + 0x40 * (n))
 #define CAMSS_CSI_PHY_LNn_CFG3(n)		(0x008 + 0x40 * (n))
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
index bcd0dfd33618..2e65caf1ecae 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
@@ -12,6 +12,7 @@
 
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 
 #define CSIPHY_3PH_LNn_CFG1(n)			(0x000 + 0x100 * (n))
 #define CSIPHY_3PH_LNn_CFG1_SWI_REC_DLY_PRG	(BIT(7) | BIT(6))
diff --git a/drivers/media/platform/qcom/camss/camss-ispif.c b/drivers/media/platform/qcom/camss/camss-ispif.c
index 7f269021d08c..fa5f9373879e 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss/camss-ispif.c
@@ -15,6 +15,7 @@
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
-- 
2.18.0
