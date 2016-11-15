Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33397 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932211AbcKOMGa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 07:06:30 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/2] v4l2-tpg: Init hv_enc field with a valid value
Date: Tue, 15 Nov 2016 13:06:24 +0100
Message-Id: <20161115120625.3015-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Zero is not a valid value for hsv_enc. Set the field to a valid
initial value.

This is not a problem for vivid, because it sets the field to 180 via
tpg_s_hsv_enc() on the control initialization, but it might be a source
of errors for other drivers that use this code.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 28d7b072d867..e47b46e2d26c 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -117,6 +117,7 @@ void tpg_init(struct tpg_data *tpg, unsigned w, unsigned h)
 	tpg_s_fourcc(tpg, V4L2_PIX_FMT_RGB24);
 	tpg->colorspace = V4L2_COLORSPACE_SRGB;
 	tpg->perc_fill = 100;
+	tpg->hsv_enc = V4L2_HSV_ENC_180;
 }
 EXPORT_SYMBOL_GPL(tpg_init);
 
-- 
2.10.2

