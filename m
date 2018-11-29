Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbeK2RF0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 12:05:26 -0500
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/35] media: omap3isp: Unregister media device as first
Date: Thu, 29 Nov 2018 01:00:35 -0500
Message-Id: <20181129060110.159878-1-sashal@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 30efae3d789cd0714ef795545a46749236e29558 ]

While there are issues related to object lifetime management, unregister the
media device first when the driver is being unbound. This is slightly
safer.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/omap3isp/isp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 6e6e978263b0..c834fea5f9b0 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1592,6 +1592,8 @@ static void isp_pm_complete(struct device *dev)
 
 static void isp_unregister_entities(struct isp_device *isp)
 {
+	media_device_unregister(&isp->media_dev);
+
 	omap3isp_csi2_unregister_entities(&isp->isp_csi2a);
 	omap3isp_ccp2_unregister_entities(&isp->isp_ccp2);
 	omap3isp_ccdc_unregister_entities(&isp->isp_ccdc);
@@ -1602,7 +1604,6 @@ static void isp_unregister_entities(struct isp_device *isp)
 	omap3isp_stat_unregister_entities(&isp->isp_hist);
 
 	v4l2_device_unregister(&isp->v4l2_dev);
-	media_device_unregister(&isp->media_dev);
 	media_device_cleanup(&isp->media_dev);
 }
 
-- 
2.17.1
