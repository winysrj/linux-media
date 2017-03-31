Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:50075 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932836AbdCaNdh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 09:33:37 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] [media] tvp5150: allow get/set_fmt on the video source pad
Date: Fri, 31 Mar 2017 15:33:25 +0200
Message-Id: <20170331133326.31159-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To let userspace propagate formats downstream in a media controller
scenario, the video source pad (now pad 1, DEMOD_PAD_VID_OUT) must allow
setting and getting the format. Incidentally, tvp5150_fill_fmt was
implemented for this pad, not for the new analog input pad (now pad 0,
DEMOD_PAD_IF_INPUT).

Fixes: 55606310e77f ("[media] tvp5150: create the expected number of pads")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index d8487d97617ec..9390662453b0f 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -870,7 +870,7 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *f;
 	struct tvp5150 *decoder = to_tvp5150(sd);
 
-	if (!format || format->pad)
+	if (!format || (format->pad != DEMOD_PAD_VID_OUT))
 		return -EINVAL;
 
 	f = &format->format;
-- 
2.11.0
