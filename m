Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57571 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3D3JmC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 05:42:02 -0400
Received: by mail-pa0-f53.google.com with SMTP id kx1so255786pab.26
        for <linux-media@vger.kernel.org>; Tue, 30 Apr 2013 02:42:00 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/2] [media] soc_camera: Fix checkpatch warning in ov9640.c
Date: Tue, 30 Apr 2013 14:59:09 +0530
Message-Id: <1367314149-16448-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1367314149-16448-1-git-send-email-sachin.kamat@linaro.org>
References: <1367314149-16448-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following warning:
WARNING: please, no space before tabs

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/soc_camera/ov9640.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 20ca62d..f4eba1b 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -61,7 +61,7 @@ static const struct ov9640_reg ov9640_regs_dflt[] = {
 
 /* Configurations
  * NOTE: for YUV, alter the following registers:
- * 		COM12 |= OV9640_COM12_YUV_AVG
+ *		COM12 |= OV9640_COM12_YUV_AVG
  *
  *	 for RGB, alter the following registers:
  *		COM7  |= OV9640_COM7_RGB
-- 
1.7.9.5

