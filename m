Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59629 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbeJSX5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 19:57:22 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com
Cc: akinobu.mita@gmail.com, enrico.scholz@sigma-chemnitz.de,
        linux-media@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de
Subject: [PATCH 2/4] media: mt9m111: add streaming check to set_fmt
Date: Fri, 19 Oct 2018 17:50:25 +0200
Message-Id: <20181019155027.28682-3-m.felsch@pengutronix.de>
In-Reply-To: <20181019155027.28682-1-m.felsch@pengutronix.de>
References: <20181019155027.28682-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

Currently set_fmt don't care about the streaming status, so the format
can be changed during streaming. This can lead into wrong behaviours.

Check if the device is already streaming and return -EBUSY to avoid
wrong behaviours.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/mt9m111.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 78d08a81e0e2..d060075a670b 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -561,6 +561,9 @@ static int mt9m111_set_fmt(struct v4l2_subdev *sd,
 	bool bayer;
 	int ret;
 
+	if (mt9m111->is_streaming)
+		return -EBUSY;
+
 	if (format->pad)
 		return -EINVAL;
 
-- 
2.19.0
