Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51315 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3EYL1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 07:27:34 -0400
Received: by mail-bk0-f46.google.com with SMTP id my13so2941580bkb.5
        for <linux-media@vger.kernel.org>; Sat, 25 May 2013 04:27:33 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	t.stanislaws@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH 4/5] s5p-tv: Don't ignore return value of regulator_bulk_enable() in hdmi_drv.c
Date: Sat, 25 May 2013 13:25:54 +0200
Message-Id: <1369481155-30446-5-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1369481155-30446-1-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes following compilation warning:
 CC [M]  drivers/media/platform/s5p-tv/hdmi_drv.o
drivers/media/platform/s5p-tv/hdmi_drv.c: In function ‘hdmi_resource_poweron’:
drivers/media/platform/s5p-tv/hdmi_drv.c:583:23: warning: ignoring return value
 of ‘regulator_bulk_enable’, declared with attribute warn_unused_result

Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 4e86626..cca83f5 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -576,16 +576,22 @@ static int hdmi_s_stream(struct v4l2_subdev *sd, int enable)
 	return hdmi_streamoff(hdev);
 }
 
-static void hdmi_resource_poweron(struct hdmi_resources *res)
+static int hdmi_resource_poweron(struct hdmi_resources *res)
 {
+	int ret;
+
 	/* turn HDMI power on */
-	regulator_bulk_enable(res->regul_count, res->regul_bulk);
+	ret = regulator_bulk_enable(res->regul_count, res->regul_bulk);
+	if (ret < 0)
+		return ret;
 	/* power-on hdmi physical interface */
 	clk_enable(res->hdmiphy);
 	/* use VPP as parent clock; HDMIPHY is not working yet */
 	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
 	/* turn clocks on */
 	clk_enable(res->sclk_hdmi);
+
+	return 0;
 }
 
 static void hdmi_resource_poweroff(struct hdmi_resources *res)
@@ -728,11 +734,13 @@ static int hdmi_runtime_resume(struct device *dev)
 {
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
 	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
-	int ret = 0;
+	int ret;
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	hdmi_resource_poweron(&hdev->res);
+	ret = hdmi_resource_poweron(&hdev->res);
+	if (ret < 0)
+		return ret;
 
 	/* starting MHL */
 	ret = v4l2_subdev_call(hdev->mhl_sd, core, s_power, 1);
-- 
1.7.4.1

