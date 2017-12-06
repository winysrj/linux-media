Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5970 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751208AbdLFQiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Dec 2017 11:38:00 -0500
From: Flavio Ceolin <flavio.ceolin@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Flavio Ceolin <flavio.ceolin@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org (open list:ARM/SAMSUNG S5P SERIES
        JPEG CODEC SUPPORT),
        linux-media@vger.kernel.org (open list:ARM/SAMSUNG S5P SERIES JPEG
        CODEC SUPPORT)
Subject: [PATCH] media: s5p-jpeg: Fix off-by-one problem
Date: Wed,  6 Dec 2017 08:37:45 -0800
Message-Id: <20171206163746.8456-1-flavio.ceolin@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5p_jpeg_runtime_resume() does not call clk_disable_unprepare() for
jpeg->clocks[0] when one of the clk_prepare_enable() fails.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Flavio Ceolin <flavio.ceolin@intel.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index faac816..79b63da 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -3086,7 +3086,7 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
 	for (i = 0; i < jpeg->variant->num_clocks; i++) {
 		ret = clk_prepare_enable(jpeg->clocks[i]);
 		if (ret) {
-			while (--i > 0)
+			while (--i >= 0)
 				clk_disable_unprepare(jpeg->clocks[i]);
 			return ret;
 		}
-- 
2.9.5
