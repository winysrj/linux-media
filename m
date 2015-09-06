Return-path: <linux-media-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:56217 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbbIFKIr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 06:08:47 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Josh Wu <josh.wu@atmel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] atmel-isi: Protect PM-only functions to kill warning
Date: Sun,  6 Sep 2015 12:08:49 +0200
Message-Id: <1441534129-24413-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CONFIG_PM=n:

    drivers/media/platform/soc_camera/atmel-isi.c:1044: warning: ‘atmel_isi_runtime_suspend’ defined but not used
    drivers/media/platform/soc_camera/atmel-isi.c:1054: warning: ‘atmel_isi_runtime_resume’ defined but not used

Protect the unused functions by #ifdef CONFIG_PM to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Resend with correct suject
---
 drivers/media/platform/soc_camera/atmel-isi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 90701726a06a2e5c..ccf30ccbe389233f 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -1040,6 +1040,7 @@ err_alloc_ctx:
 	return ret;
 }
 
+#ifdef CONFIG_PM
 static int atmel_isi_runtime_suspend(struct device *dev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(dev);
@@ -1058,6 +1059,7 @@ static int atmel_isi_runtime_resume(struct device *dev)
 
 	return clk_prepare_enable(isi->pclk);
 }
+#endif /* CONFIG_PM */
 
 static const struct dev_pm_ops atmel_isi_dev_pm_ops = {
 	SET_RUNTIME_PM_OPS(atmel_isi_runtime_suspend,
-- 
1.9.1

