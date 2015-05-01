Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33814 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbbEAPv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2015 11:51:26 -0400
From: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
Subject: [PATCH 4/4] media: platform: sp5: Constify platform_device_id
Date: Sat,  2 May 2015 00:51:03 +0900
Message-Id: <1430495463-31633-4-git-send-email-k.kozlowski.k@gmail.com>
In-Reply-To: <1430495463-31633-1-git-send-email-k.kozlowski.k@gmail.com>
References: <1430495463-31633-1-git-send-email-k.kozlowski.k@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The platform_device_id is not modified by the driver and core uses it as
const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
---
 drivers/media/platform/s5p-g2d/g2d.c     | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index ec3e1248923d..421a7c3b595b 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -787,7 +787,7 @@ static const struct of_device_id exynos_g2d_match[] = {
 };
 MODULE_DEVICE_TABLE(of, exynos_g2d_match);
 
-static struct platform_device_id g2d_driver_ids[] = {
+static const struct platform_device_id g2d_driver_ids[] = {
 	{
 		.name = "s5p-g2d",
 		.driver_data = (unsigned long)&g2d_drvdata_v3x,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8333fbc2fe96..fa878cb04004 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1463,7 +1463,7 @@ static struct s5p_mfc_variant mfc_drvdata_v8 = {
 	.fw_name[0]     = "s5p-mfc-v8.fw",
 };
 
-static struct platform_device_id mfc_driver_ids[] = {
+static const struct platform_device_id mfc_driver_ids[] = {
 	{
 		.name = "s5p-mfc",
 		.driver_data = (unsigned long)&mfc_drvdata_v5,
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 0e74aabf5f9a..e8c069de6238 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -96,7 +96,7 @@ struct hdmi_device {
 	struct hdmi_resources res;
 };
 
-static struct platform_device_id hdmi_driver_types[] = {
+static const struct platform_device_id hdmi_driver_types[] = {
 	{
 		.name		= "s5pv210-hdmi",
 	}, {
-- 
2.1.4

