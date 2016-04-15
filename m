Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34047 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbcDOBA3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 21:00:29 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media] tvp5150: propagate I2C write error in .s_register callback
Date: Thu, 14 Apr 2016 21:00:08 -0400
Message-Id: <1460682008-17168-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1460682008-17168-1-git-send-email-javier@osg.samsung.com>
References: <1460682008-17168-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tvp5150_write() function can fail so don't return 0 unconditionally
in tvp5150_s_register() but propagate what's returned by tvp5150_write().

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/i2c/tvp5150.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 4a2e851b6a3b..7be456d1b071 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1161,8 +1161,7 @@ static int tvp5150_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 static int tvp5150_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
 {
-	tvp5150_write(sd, reg->reg & 0xff, reg->val & 0xff);
-	return 0;
+	return tvp5150_write(sd, reg->reg & 0xff, reg->val & 0xff);
 }
 #endif
 
-- 
2.5.5

