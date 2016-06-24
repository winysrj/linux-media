Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40652 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH 02/19] exynos4-is: remove some unused vars
Date: Fri, 24 Jun 2016 12:31:43 -0300
Message-Id: <21ed20340a789f893d410bd961c206445a333040.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gcc 6.1 warns about some unused vars and functions. Remove them:

drivers/media/platform/exynos4-is/mipi-csis.c:665:46: warning: 's5pcsis_sd_internal_ops' defined but not used [-Wunused-const-variable=]
 static const struct v4l2_subdev_internal_ops s5pcsis_sd_internal_ops = {
                                              ^~~~~~~~~~~~~~~~~~~~~~~

drivers/media/platform/exynos4-is/mipi-csis.c:652:12: warning: 's5pcsis_open' defined but not used [-Wunused-function]
 static int s5pcsis_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
            ^~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/exynos4-is/mipi-csis.c | 17 -----------------
 drivers/media/radio/radio-aztech.c            |  1 -
 2 files changed, 18 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index bf954424e7be..86e681daa89d 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -649,23 +649,6 @@ static int s5pcsis_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int s5pcsis_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
-{
-	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(sd, fh->pad, 0);
-
-	format->colorspace = V4L2_COLORSPACE_JPEG;
-	format->code = s5pcsis_formats[0].code;
-	format->width = S5PCSIS_DEF_PIX_WIDTH;
-	format->height = S5PCSIS_DEF_PIX_HEIGHT;
-	format->field = V4L2_FIELD_NONE;
-
-	return 0;
-}
-
-static const struct v4l2_subdev_internal_ops s5pcsis_sd_internal_ops = {
-	.open = s5pcsis_open,
-};
-
 static struct v4l2_subdev_core_ops s5pcsis_core_ops = {
 	.s_power = s5pcsis_s_power,
 	.log_status = s5pcsis_log_status,
diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index 705dd6f9162c..f445327f282d 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -43,7 +43,6 @@ MODULE_VERSION("1.0.0");
 static int io[AZTECH_MAX] = { [0] = CONFIG_RADIO_AZTECH_PORT,
 			      [1 ... (AZTECH_MAX - 1)] = -1 };
 static int radio_nr[AZTECH_MAX]	= { [0 ... (AZTECH_MAX - 1)] = -1 };
-static const int radio_wait_time = 1000;
 
 module_param_array(io, int, NULL, 0444);
 MODULE_PARM_DESC(io, "I/O addresses of the Aztech card (0x350 or 0x358)");
-- 
2.7.4


