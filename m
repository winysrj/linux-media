Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47500 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3D3EmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 00:42:21 -0400
Received: by mail-pa0-f46.google.com with SMTP id ld11so131436pab.5
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 21:42:21 -0700 (PDT)
Message-ID: <1367296936.5772.2.camel@phoenix>
Subject: [PATCH] [media] s5c73m3: Fix off-by-one valid range checking for
 fie->index
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	linux-media@vger.kernel.org
Date: Tue, 30 Apr 2013 12:42:16 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current code uses fie->index as array subscript, thus the valid value range
is 0 ... ARRAY_SIZE(s5c73m3_intervals) - 1.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index b353c50..cd365bb 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -956,7 +956,7 @@ static int s5c73m3_oif_enum_frame_interval(struct v4l2_subdev *sd,
 
 	if (fie->pad != OIF_SOURCE_PAD)
 		return -EINVAL;
-	if (fie->index > ARRAY_SIZE(s5c73m3_intervals))
+	if (fie->index >= ARRAY_SIZE(s5c73m3_intervals))
 		return -EINVAL;
 
 	mutex_lock(&state->lock);
-- 
1.8.1.2



