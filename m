Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56340 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752007AbZELPNV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 11:13:21 -0400
Date: Tue, 12 May 2009 17:13:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH 1/3] soc-camera: unify i2c camera device platform data
In-Reply-To: <Pine.LNX.4.64.0905121649420.5087@axis700.grange>
Message-ID: <Pine.LNX.4.64.0905121702510.5087@axis700.grange>
References: <Pine.LNX.4.64.0905121649420.5087@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unify i2c camera device platform data to point to struct soc_camera_link 
for a smooth transition to soc-camera as a platform driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/sh/boards/board-ap325rxa.c   |    2 +-
 arch/sh/boards/mach-migor/setup.c |    4 ++--
 drivers/media/video/ov772x.c      |    6 ++++--
 drivers/media/video/tw9910.c      |    6 ++++--
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index 39e4691..54c5cd1 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -414,7 +414,7 @@ static struct i2c_board_info __initdata ap325rxa_i2c_devices[] = {
 	},
 	{
 		I2C_BOARD_INFO("ov772x", 0x21),
-		.platform_data = &ov7725_info,
+		.platform_data = &ov7725_info.link,
 	},
 };
 
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 1ee1de0..c4b97e1 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -430,11 +430,11 @@ static struct i2c_board_info migor_i2c_devices[] = {
 	},
 	{
 		I2C_BOARD_INFO("ov772x", 0x21),
-		.platform_data = &ov7725_info,
+		.platform_data = &ov7725_info.link,
 	},
 	{
 		I2C_BOARD_INFO("tw9910", 0x45),
-		.platform_data = &tw9910_info,
+		.platform_data = &tw9910_info.link,
 	},
 };
 
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index c0d9112..0bce255 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -1067,10 +1067,12 @@ static int ov772x_probe(struct i2c_client *client,
 	struct i2c_adapter        *adapter = to_i2c_adapter(client->dev.parent);
 	int                        ret;
 
-	info = client->dev.platform_data;
-	if (!info)
+	if (!client->dev.platform_data)
 		return -EINVAL;
 
+	info = container_of(client->dev.platform_data,
+			    struct ov772x_camera_info, link);
+
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&adapter->dev,
 			"I2C-Adapter doesn't support "
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index a399476..aa5065e 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -875,10 +875,12 @@ static int tw9910_probe(struct i2c_client *client,
 	const struct tw9910_scale_ctrl *scale;
 	int                             i, ret;
 
-	info = client->dev.platform_data;
-	if (!info)
+	if (!client->dev.platform_data)
 		return -EINVAL;
 
+	info = container_of(client->dev.platform_data,
+			    struct tw9910_video_info, link);
+
 	if (!i2c_check_functionality(to_i2c_adapter(client->dev.parent),
 				     I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_err(&client->dev,
-- 
1.6.2.4

