Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:37065 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751218AbdH0F4x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 01:56:53 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        hdegoede@redhat.com, alan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: atomisp: constify v4l2_subdev_sensor_ops
Date: Sun, 27 Aug 2017 11:26:39 +0530
Message-Id: <cc864898af00fc9e3e0e84246848b235aeb85aca.1503813075.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_sensor_ops are not supposed to change at runtime.
v4l2_subdev_sensor_ops are working with const 'sensor' field of
sturct v4l2_subdev_ops. So mark the non-const v4l2_subdev_sensor_ops
structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/staging/media/atomisp/i2c/mt9m114.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 3fa9153..2c9b752 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -1806,7 +1806,7 @@ static const struct v4l2_subdev_video_ops mt9m114_video_ops = {
 	.g_frame_interval = mt9m114_g_frame_interval,
 };
 
-static struct v4l2_subdev_sensor_ops mt9m114_sensor_ops = {
+static const struct v4l2_subdev_sensor_ops mt9m114_sensor_ops = {
 	.g_skip_frames	= mt9m114_g_skip_frames,
 };
 
-- 
2.7.4
