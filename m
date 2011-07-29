Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60937 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab1G2K5K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:10 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 49/59] sh: ap3rxa: remove redundant soc-camera platform data fields
Date: Fri, 29 Jul 2011 12:56:49 +0200
Message-Id: <1311937019-29914-50-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sh_mobile_ceu_camera driver has been converted to use the V4L2
subdevice .[gs]_mbus_config() operations, therefore we don't need
SOCAM_* flags for the soc_camera_platform driver anymore. The ov772x
driver only supports 8 bits per sample pixel codes, hence the
OV772X_FLAG_8BIT flag has no effect. Remove both of them.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/boards/mach-ap325rxa/setup.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index 547928f..f8242f6 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -345,9 +345,6 @@ static struct soc_camera_platform_info camera_info = {
 		.width = 640,
 		.height = 480,
 	},
-	.bus_param = SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
-	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8 |
-	SOCAM_DATA_ACTIVE_HIGH,
 	.mbus_param = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
 	V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
 	V4L2_MBUS_DATA_ACTIVE_HIGH,
@@ -505,8 +502,7 @@ static struct i2c_board_info ap325rxa_i2c_camera[] = {
 };
 
 static struct ov772x_camera_info ov7725_info = {
-	.flags		= OV772X_FLAG_VFLIP | OV772X_FLAG_HFLIP | \
-			  OV772X_FLAG_8BIT,
+	.flags		= OV772X_FLAG_VFLIP | OV772X_FLAG_HFLIP,
 	.edgectrl	= OV772X_AUTO_EDGECTRL(0xf, 0),
 };
 
-- 
1.7.2.5

