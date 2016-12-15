Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34218 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757753AbcLOOFg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 09:05:36 -0500
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org, kgene@kernel.org,
        krzk@kernel.org, javier@osg.samsung.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/2] media: s5p-cec: Remove unneeded linux/miscdevice.h include
Date: Thu, 15 Dec 2016 15:03:23 +0100
Message-Id: <20161215140324.28986-1-clabbe.montjoie@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5p-cec: does not use any miscdevice so this patch remove this
unnecessary inclusion.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/staging/media/s5p-cec/exynos_hdmi_cec.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/s5p-cec/exynos_hdmi_cec.h b/drivers/staging/media/s5p-cec/exynos_hdmi_cec.h
index 3e4fc7b..7d94535 100644
--- a/drivers/staging/media/s5p-cec/exynos_hdmi_cec.h
+++ b/drivers/staging/media/s5p-cec/exynos_hdmi_cec.h
@@ -14,7 +14,6 @@
 #define _EXYNOS_HDMI_CEC_H_ __FILE__
 
 #include <linux/regmap.h>
-#include <linux/miscdevice.h>
 #include "s5p_cec.h"
 
 void s5p_cec_set_divider(struct s5p_cec_dev *cec);
-- 
2.10.2

