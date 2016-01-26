Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51032 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934483AbcAZMqq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 07:46:46 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v3 1/2] [media] tvp5150: fix tvp5150_fill_fmt()
Date: Tue, 26 Jan 2016 09:46:23 -0300
Message-Id: <1453812384-15512-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1453812384-15512-1-git-send-email-javier@osg.samsung.com>
References: <1453812384-15512-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

The tvp5150 output video is interlaced so mark the format
field as alternate and reduce the height to the half.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
[javier: split patch and write commit message]
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

Changes in v3: None
Changes in v2: None

 drivers/media/i2c/tvp5150.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 9b83fc9ee8d1..37853bc3f0b3 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -852,10 +852,10 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 	tvp5150_reset(sd, 0);
 
 	f->width = decoder->rect.width;
-	f->height = decoder->rect.height;
+	f->height = decoder->rect.height / 2;
 
 	f->code = MEDIA_BUS_FMT_UYVY8_2X8;
-	f->field = V4L2_FIELD_SEQ_TB;
+	f->field = V4L2_FIELD_ALTERNATE;
 	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", f->width,
-- 
2.5.0

