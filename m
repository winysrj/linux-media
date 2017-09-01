Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:35304 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbdIADOu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 23:14:50 -0400
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
Subject: [PATCH 3/4] media: atmel-isc: Enable the clocks during probe
Date: Fri, 1 Sep 2017 11:09:34 +0800
Message-ID: <20170901030935.29717-4-wenyou.yang@microchip.com>
In-Reply-To: <20170901030935.29717-1-wenyou.yang@microchip.com>
References: <20170901030935.29717-1-wenyou.yang@microchip.com>
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

 drivers/media/platform/atmel/atmel-isc.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 80968f7d79f2..bc3098982d12 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1595,6 +1595,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	struct isc_subdev_entity *sd_entity;
 	struct video_device *vdev = &isc->video_dev;
 	struct vb2_queue *q = &isc->vb2_vidq;
+	struct device *dev = isc->dev;
 	int ret;
 
 	ret = v4l2_device_register_subdev_nodes(&isc->v4l2_dev);
@@ -1678,6 +1679,10 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}
 
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+	pm_request_idle(dev);
+
 	return 0;
 }
 
@@ -1857,25 +1862,37 @@ static int atmel_isc_probe(struct platform_device *pdev)
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
@@ -1908,8 +1925,6 @@ static int atmel_isc_probe(struct platform_device *pdev)
 			break;
 	}
 
-	pm_runtime_enable(dev);
-
 	return 0;
 
 cleanup_subdev:
@@ -1918,7 +1933,11 @@ static int atmel_isc_probe(struct platform_device *pdev)
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
-- 
2.13.0
