Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39177 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbeIZMYF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 08:24:05 -0400
Received: by mail-lf1-f66.google.com with SMTP id w21-v6so8168346lff.6
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2018 23:12:47 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] media: smiapp: Remove unused loop
Date: Wed, 26 Sep 2018 08:12:42 +0200
Message-Id: <20180926061242.8130-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The loop seemed to be made to calculate max, but max is not used in that
function.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 99f3b295ae3c..bccbf4c841d6 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -624,7 +624,7 @@ static int smiapp_init_late_controls(struct smiapp_sensor *sensor)
 {
 	unsigned long *valid_link_freqs = &sensor->valid_link_freqs[
 		sensor->csi_format->compressed - sensor->compressed_min_bpp];
-	unsigned int max, i;
+	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++) {
 		int max_value = (1 << sensor->csi_format->width) - 1;
@@ -635,8 +635,6 @@ static int smiapp_init_late_controls(struct smiapp_sensor *sensor)
 				0, max_value, 1, max_value);
 	}
 
-	for (max = 0; sensor->hwcfg->op_sys_clock[max + 1]; max++);
-
 	sensor->link_freq = v4l2_ctrl_new_int_menu(
 		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
 		V4L2_CID_LINK_FREQ, __fls(*valid_link_freqs),
-- 
2.19.0
