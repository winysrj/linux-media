Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:27563 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbdJ0DZa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 23:25:30 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v5 3/5] media: atmel-isc: Enable the clocks during probe
Date: Fri, 27 Oct 2017 11:21:30 +0800
Message-ID: <20171027032132.16418-4-wenyou.yang@microchip.com>
In-Reply-To: <20171027032132.16418-1-wenyou.yang@microchip.com>
References: <20171027032132.16418-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To meet the relationship, enable the HCLOCK and ispck during the
device probe, "isc_pck frequency is less than or equal to isc_ispck,
and isc_ispck is greater than or equal to HCLOCK."
Meanwhile, call the pm_runtime_enable() in the right place.

Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
---

Changes in v5:
 - Fix the clock ID to ISC_ISPCK, instead of ISC_MCK for
   isc_clk_is_enabled().

Changes in v4:
 - Move pm_runtime_enable() call from the complete callback to the
   end of probe.
 - Call pm_runtime_get_sync() and pm_runtime_put_sync() in
   ->is_enabled() callbacks.
 - Call clk_disable_unprepare() in ->remove callback.

Changes in v3: None
Changes in v2: None

 drivers/media/platform/atmel/atmel-isc.c | 34 ++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 329ee8f256bb..4431c27dfb09 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -389,8 +389,14 @@ static int isc_clk_is_enabled(struct clk_hw *hw)
 	struct isc_clk *isc_clk = to_isc_clk(hw);
 	u32 status;
 
+	if (isc_clk->id == ISC_ISPCK)
+		pm_runtime_get_sync(isc_clk->dev);
+
 	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
 
+	if (isc_clk->id == ISC_ISPCK)
+		pm_runtime_put_sync(isc_clk->dev);
+
 	return status & ISC_CLK(isc_clk->id) ? 1 : 0;
 }
 
@@ -1866,25 +1872,37 @@ static int atmel_isc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = clk_prepare_enable(isc->hclock);
+	if (ret) {
+		dev_err(dev, "failed to enable hclock: %d\n", ret);
+		return ret;
+	}
+
 	ret = isc_clk_init(isc);
 	if (ret) {
 		dev_err(dev, "failed to init isc clock: %d\n", ret);
-		goto clean_isc_clk;
+		goto unprepare_hclk;
 	}
 
 	isc->ispck = isc->isc_clks[ISC_ISPCK].clk;
 
+	ret = clk_prepare_enable(isc->ispck);
+	if (ret) {
+		dev_err(dev, "failed to enable ispck: %d\n", ret);
+		goto unprepare_hclk;
+	}
+
 	/* ispck should be greater or equal to hclock */
 	ret = clk_set_rate(isc->ispck, clk_get_rate(isc->hclock));
 	if (ret) {
 		dev_err(dev, "failed to set ispck rate: %d\n", ret);
-		goto clean_isc_clk;
+		goto unprepare_clk;
 	}
 
 	ret = v4l2_device_register(dev, &isc->v4l2_dev);
 	if (ret) {
 		dev_err(dev, "unable to register v4l2 device.\n");
-		goto clean_isc_clk;
+		goto unprepare_clk;
 	}
 
 	ret = isc_parse_dt(dev, isc);
@@ -1917,7 +1935,9 @@ static int atmel_isc_probe(struct platform_device *pdev)
 			break;
 	}
 
+	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
+	pm_request_idle(dev);
 
 	return 0;
 
@@ -1927,7 +1947,11 @@ static int atmel_isc_probe(struct platform_device *pdev)
 unregister_v4l2_device:
 	v4l2_device_unregister(&isc->v4l2_dev);
 
-clean_isc_clk:
+unprepare_clk:
+	clk_disable_unprepare(isc->ispck);
+unprepare_hclk:
+	clk_disable_unprepare(isc->hclock);
+
 	isc_clk_cleanup(isc);
 
 	return ret;
@@ -1938,6 +1962,8 @@ static int atmel_isc_remove(struct platform_device *pdev)
 	struct isc_device *isc = platform_get_drvdata(pdev);
 
 	pm_runtime_disable(&pdev->dev);
+	clk_disable_unprepare(isc->ispck);
+	clk_disable_unprepare(isc->hclock);
 
 	isc_subdev_cleanup(isc);
 
-- 
2.13.0
