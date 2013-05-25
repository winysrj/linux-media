Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:37649 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3EYL1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 07:27:30 -0400
Received: by mail-bk0-f47.google.com with SMTP id jg1so2892621bkc.20
        for <linux-media@vger.kernel.org>; Sat, 25 May 2013 04:27:29 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	t.stanislaws@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH 3/5] s5p-tv: Do not ignore regulator/clk API return values in sdo_drv.c
Date: Sat, 25 May 2013 13:25:53 +0200
Message-Id: <1369481155-30446-4-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes following compilation warning:

drivers/media/platform/s5p-tv/sdo_drv.c: In function ‘sdo_runtime_resume’:
drivers/media/platform/s5p-tv/sdo_drv.c:268:18: warning: ignoring return value of ‘regulator_enable’,
  declared with attribute warn_unused_result
drivers/media/platform/s5p-tv/sdo_drv.c:269:18: warning: ignoring return value of ‘regulator_enable’,
  declared with attribute warn_unused_result

Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/platform/s5p-tv/sdo_drv.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index ab6f9ef..0afa90f 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -262,11 +262,21 @@ static int sdo_runtime_resume(struct device *dev)
 {
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct sdo_device *sdev = sd_to_sdev(sd);
+	int ret;
 
 	dev_info(dev, "resume\n");
-	clk_enable(sdev->sclk_dac);
-	regulator_enable(sdev->vdac);
-	regulator_enable(sdev->vdet);
+
+	ret = clk_enable(sdev->sclk_dac);
+	if (ret < 0)
+		return ret;
+
+	ret = regulator_enable(sdev->vdac);
+	if (ret < 0)
+		goto dac_clk_dis;
+
+	ret = regulator_enable(sdev->vdet);
+	if (ret < 0)
+		goto vdac_r_dis;
 
 	/* software reset */
 	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_SW_RESET);
@@ -285,6 +295,12 @@ static int sdo_runtime_resume(struct device *dev)
 		SDO_COMPENSATION_CVBS_COMP_OFF);
 	sdo_reg_debug(sdev);
 	return 0;
+
+vdac_r_dis:
+	regulator_disable(sdev->vdac);
+dac_clk_dis:
+	clk_disable(sdev->sclk_dac);
+	return ret;
 }
 
 static const struct dev_pm_ops sdo_pm_ops = {
-- 
1.7.4.1

