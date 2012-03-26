Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57400 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab2CZNSA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 09:18:00 -0400
Received: by wejx9 with SMTP id x9so4188209wej.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 06:17:59 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	u.kleine-koenig@pengutronix.de, mchehab@infradead.org,
	kernel@pengutronix.de, baruch@tkos.co.il,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 1/3] media: tvp5150: Fix mbus format.
Date: Mon, 26 Mar 2012 15:17:46 +0200
Message-Id: <1332767868-2531-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1332767868-2531-1-git-send-email-javier.martin@vista-silicon.com>
References: <1332767868-2531-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to p.14 fig 3-3 of the datasheet (SLES098A)
this decoder transmits data in UYVY format.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/tvp5150.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index e292c46..30c88e0 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -821,7 +821,7 @@ static int tvp5150_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
 	if (index)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_YUYV8_2X8;
+	*code = V4L2_MBUS_FMT_UYVY8_2X8;
 	return 0;
 }
 
@@ -845,7 +845,7 @@ static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
 	f->width = decoder->rect.width;
 	f->height = decoder->rect.height;
 
-	f->code = V4L2_MBUS_FMT_YUYV8_2X8;
+	f->code = V4L2_MBUS_FMT_UYVY8_2X8;
 	f->field = V4L2_FIELD_SEQ_TB;
 	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
-- 
1.7.0.4

