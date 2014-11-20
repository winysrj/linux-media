Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:63539 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaKTKuz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 05:50:55 -0500
Message-ID: <546DC778.8050204@users.sourceforge.net>
Date: Thu, 20 Nov 2014 11:50:32 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: linux-samsung-soc@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] [media] platform: Deletion of unnecessary checks before
 two function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 11:44:20 +0100

The functions i2c_put_adapter() and release_firmware() test whether their
argument is NULL and then return immediately. Thus the test around the call
is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/exynos4-is/fimc-is.c   | 6 ++----
 drivers/media/platform/s3c-camif/camif-core.c | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 5476dce..a1db27b 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -428,8 +428,7 @@ static void fimc_is_load_firmware(const struct firmware *fw, void *context)
 	 * needed around for copying to the IS working memory every
 	 * time before the Cortex-A5 is restarted.
 	 */
-	if (is->fw.f_w)
-		release_firmware(is->fw.f_w);
+	release_firmware(is->fw.f_w);
 	is->fw.f_w = fw;
 done:
 	mutex_unlock(&is->lock);
@@ -937,8 +936,7 @@ static int fimc_is_remove(struct platform_device *pdev)
 	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
 	fimc_is_put_clocks(is);
 	fimc_is_debugfs_remove(is);
-	if (is->fw.f_w)
-		release_firmware(is->fw.f_w);
+	release_firmware(is->fw.f_w);
 	fimc_is_free_cpu_memory(is);
 
 	return 0;
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index b385747..3b09b5b 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -256,8 +256,7 @@ static void camif_unregister_sensor(struct camif_dev *camif)
 	v4l2_device_unregister_subdev(sd);
 	camif->sensor.sd = NULL;
 	i2c_unregister_device(client);
-	if (adapter)
-		i2c_put_adapter(adapter);
+	i2c_put_adapter(adapter);
 }
 
 static int camif_create_media_links(struct camif_dev *camif)
-- 
2.1.3

