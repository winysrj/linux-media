Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:32931 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965364Ab3DRDSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 23:18:20 -0400
Received: by mail-wi0-f175.google.com with SMTP id h11so1156374wiv.2
        for <linux-media@vger.kernel.org>; Wed, 17 Apr 2013 20:18:19 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Apr 2013 11:18:19 +0800
Message-ID: <CAPgLHd_TwmtoaE7T7e3fRKh4NTGhOYjQZv0G7nt-iSVMLz3XEQ@mail.gmail.com>
Subject: [PATCH -next] [media] s5p-mfc: fix error return code in s5p_mfc_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@redhat.com, grant.likely@linaro.org,
	rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index e810b1a..a5853fa 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1110,7 +1110,8 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	}
 
 	if (pdev->dev.of_node) {
-		if (s5p_mfc_alloc_memdevs(dev) < 0)
+		ret = s5p_mfc_alloc_memdevs(dev);
+		if (ret < 0)
 			goto err_res;
 	} else {
 		dev->mem_dev_l = device_find_child(&dev->plat_dev->dev,

