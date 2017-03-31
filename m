Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:50363 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754661AbdCaNdu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 09:33:50 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] [media] tvp5150: fix pad format frame height
Date: Fri, 31 Mar 2017 15:33:26 +0200
Message-Id: <20170331133326.31159-2-p.zabel@pengutronix.de>
In-Reply-To: <20170331133326.31159-1-p.zabel@pengutronix.de>
References: <20170331133326.31159-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even if field order is set to V4L2_FIELD_ALTERNATE, the width and height
values in struct v4l2_mbus_framefmt still refer to frame size, not field
size.

Fixes: 4f57d27be2a5 ("[media] tvp5150: fix tvp5150_fill_fmt()")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 9390662453b0f..b05a578aef983 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -876,7 +876,7 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 	f = &format->format;
 
 	f->width = decoder->rect.width;
-	f->height = decoder->rect.height / 2;
+	f->height = decoder->rect.height;
 
 	f->code = MEDIA_BUS_FMT_UYVY8_2X8;
 	f->field = V4L2_FIELD_ALTERNATE;
-- 
2.11.0
