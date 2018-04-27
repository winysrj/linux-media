Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:42767 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751416AbeD0LoT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 07:44:19 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, hans.verkuil@cisco.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] platform: Use gpio_is_valid()
Date: Fri, 27 Apr 2018 17:14:00 +0530
Message-Id: <93444a65ca7853d27c724aeb50d16c5afd59fa08.1524828993.git.arvind.yadav.cs@gmail.com>
In-Reply-To: <cover.1524828993.git.arvind.yadav.cs@gmail.com>
References: <cover.1524828993.git.arvind.yadav.cs@gmail.com>
In-Reply-To: <cover.1524828993.git.arvind.yadav.cs@gmail.com>
References: <cover.1524828993.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the manual validity checks for the GPIO with the
gpio_is_valid().

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/platform/via-camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index e9a0263..f01c3e8 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -178,7 +178,7 @@ static int via_sensor_power_setup(struct via_camera *cam)
 
 	cam->power_gpio = viafb_gpio_lookup("VGPIO3");
 	cam->reset_gpio = viafb_gpio_lookup("VGPIO2");
-	if (cam->power_gpio < 0 || cam->reset_gpio < 0) {
+	if (!gpio_is_valid(cam->power_gpio) || !gpio_is_valid(cam->reset_gpio)) {
 		dev_err(&cam->platdev->dev, "Unable to find GPIO lines\n");
 		return -EINVAL;
 	}
-- 
1.9.1
