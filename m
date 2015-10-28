Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp02.atmel.com ([204.2.163.16]:13979 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751319AbbJ1Jmn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2015 05:42:43 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] soc_camera: get the clock name by using macro: v4l2_clk_name_i2c()
Date: Wed, 28 Oct 2015 17:48:52 +0800
Message-ID: <1446025735-26849-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1446025735-26849-1-git-send-email-josh.wu@atmel.com>
References: <1446025735-26849-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since v4l2_clk_name_i2c() is defined, so just reuse it.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/platform/soc_camera/soc_camera.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 9d24d44..d165bff 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1393,8 +1393,8 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
 	ssdd->sd_pdata.regulators = NULL;
 	shd->board_info->platform_data = ssdd;
 
-	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
-		 shd->i2c_adapter_id, shd->board_info->addr);
+	v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
+			  shd->i2c_adapter_id, shd->board_info->addr);
 
 	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
 	if (IS_ERR(icd->clk)) {
@@ -1574,8 +1574,9 @@ static int scan_async_group(struct soc_camera_host *ici,
 	icd->sasc = sasc;
 	icd->parent = ici->v4l2_dev.dev;
 
-	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
-		 sasd->asd.match.i2c.adapter_id, sasd->asd.match.i2c.address);
+	v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
+			  sasd->asd.match.i2c.adapter_id,
+			  sasd->asd.match.i2c.address);
 
 	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
 	if (IS_ERR(icd->clk)) {
@@ -1676,8 +1677,8 @@ static int soc_of_bind(struct soc_camera_host *ici,
 	client = of_find_i2c_device_by_node(remote);
 
 	if (client)
-		snprintf(clk_name, sizeof(clk_name), "%d-%04x",
-			 client->adapter->nr, client->addr);
+		v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
+				  client->adapter->nr, client->addr);
 	else
 		snprintf(clk_name, sizeof(clk_name), "of-%s",
 			 of_node_full_name(remote));
-- 
1.9.1

