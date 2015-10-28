Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:24888 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965336AbbJ1Jmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2015 05:42:51 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] v4l2-clk: add new macro for v4l2_clk_name_of()
Date: Wed, 28 Oct 2015 17:48:53 +0800
Message-ID: <1446025735-26849-3-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1446025735-26849-1-git-send-email-josh.wu@atmel.com>
References: <1446025735-26849-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This macro is used to generate a OF string for a v4l2 clock.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/platform/soc_camera/soc_camera.c | 4 ++--
 include/media/v4l2-clk.h                       | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index d165bff..673f1d4 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1680,8 +1680,8 @@ static int soc_of_bind(struct soc_camera_host *ici,
 		v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
 				  client->adapter->nr, client->addr);
 	else
-		snprintf(clk_name, sizeof(clk_name), "of-%s",
-			 of_node_full_name(remote));
+		v4l2_clk_name_of(clk_name, sizeof(clk_name),
+				 of_node_full_name(remote));
 
 	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
 	if (IS_ERR(icd->clk)) {
diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
index 3ef6e3d..34891ea 100644
--- a/include/media/v4l2-clk.h
+++ b/include/media/v4l2-clk.h
@@ -68,4 +68,7 @@ static inline struct v4l2_clk *v4l2_clk_register_fixed(const char *dev_id,
 #define v4l2_clk_name_i2c(name, size, adap, client) snprintf(name, size, \
 			  "%d-%04x", adap, client)
 
+#define v4l2_clk_name_of(name, size, of_full_name) snprintf(name, size, \
+			  "of-%s", of_full_name)
+
 #endif
-- 
1.9.1

