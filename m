Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:30726 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaDHOim (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 10:38:42 -0400
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Cc: kishon@ti.com, t.figa@samsung.com, kyungmin.park@samsung.com,
	sylvester.nawrocki@gmail.com, robh+dt@kernel.org,
	inki.dae@samsung.com, rahul.sharma@samsung.com,
	grant.likely@linaro.org, kgene.kim@samsung.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 3/3] s5p-tv: hdmi: use hdmiphy as PHY
Date: Tue, 08 Apr 2014 16:37:36 +0200
Message-id: <1396967856-27470-4-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HDMIPHY (physical interface) is controlled by a single
bit in a power controller's regiter. It was implemented
as clock. It was a simple but effective hack.

This patch makes S5P-HDMI driver to control HDMIPHY via PHY interface.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 534722c..8013e52 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -32,6 +32,7 @@
 #include <linux/clk.h>
 #include <linux/regulator/consumer.h>
 #include <linux/v4l2-dv-timings.h>
+#include <linux/phy/phy.h>
 
 #include <media/s5p_hdmi.h>
 #include <media/v4l2-common.h>
@@ -66,7 +67,7 @@ struct hdmi_resources {
 	struct clk *sclk_hdmi;
 	struct clk *sclk_pixel;
 	struct clk *sclk_hdmiphy;
-	struct clk *hdmiphy;
+	struct phy *hdmiphy;
 	struct regulator_bulk_data *regul_bulk;
 	int regul_count;
 };
@@ -586,7 +587,7 @@ static int hdmi_resource_poweron(struct hdmi_resources *res)
 	if (ret < 0)
 		return ret;
 	/* power-on hdmi physical interface */
-	clk_enable(res->hdmiphy);
+	phy_power_on(res->hdmiphy);
 	/* use VPP as parent clock; HDMIPHY is not working yet */
 	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
 	/* turn clocks on */
@@ -600,7 +601,7 @@ static void hdmi_resource_poweroff(struct hdmi_resources *res)
 	/* turn clocks off */
 	clk_disable(res->sclk_hdmi);
 	/* power-off hdmiphy */
-	clk_disable(res->hdmiphy);
+	phy_power_off(res->hdmiphy);
 	/* turn HDMI power off */
 	regulator_bulk_disable(res->regul_count, res->regul_bulk);
 }
@@ -784,7 +785,7 @@ static void hdmi_resources_cleanup(struct hdmi_device *hdev)
 	/* kfree is NULL-safe */
 	kfree(res->regul_bulk);
 	if (!IS_ERR(res->hdmiphy))
-		clk_put(res->hdmiphy);
+		phy_put(res->hdmiphy);
 	if (!IS_ERR(res->sclk_hdmiphy))
 		clk_put(res->sclk_hdmiphy);
 	if (!IS_ERR(res->sclk_pixel))
@@ -835,7 +836,7 @@ static int hdmi_resources_init(struct hdmi_device *hdev)
 		dev_err(dev, "failed to get clock 'sclk_hdmiphy'\n");
 		goto fail;
 	}
-	res->hdmiphy = clk_get(dev, "hdmiphy");
+	res->hdmiphy = phy_get(dev, "hdmiphy");
 	if (IS_ERR(res->hdmiphy)) {
 		dev_err(dev, "failed to get clock 'hdmiphy'\n");
 		goto fail;
-- 
1.7.9.5

