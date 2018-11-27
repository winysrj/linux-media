Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57089 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730433AbeK0VAr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:00:47 -0500
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: enrico.scholz@sigma-chemnitz.de, devicetree@vger.kernel.org,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        graphics@pengutronix.de,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH v3 2/6] media: mt9m111: add streaming check to set_fmt
Date: Tue, 27 Nov 2018 11:02:49 +0100
Message-Id: <20181127100253.30845-3-m.felsch@pengutronix.de>
In-Reply-To: <20181127100253.30845-1-m.felsch@pengutronix.de>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
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
index 03559669de9f..9b0a3689fa98 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -563,6 +563,9 @@ static int mt9m111_set_fmt(struct v4l2_subdev *sd,
 	bool bayer;
 	int ret;
 
+	if (mt9m111->is_streaming)
+		return -EBUSY;
+
 	if (format->pad)
 		return -EINVAL;
 
-- 
2.19.1
