Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48441 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab3EYRkT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 May 2013 13:40:19 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH v2 2/4] media: i2c: ths7303: remove init_enable option from pdata
Date: Sat, 25 May 2013 23:09:34 +0530
Message-Id: <1369503576-22271-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369503576-22271-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch removes init_enable option from pdata, the init_enable
was intended that the device should start streaming video immediately
but ideally the bridge drivers should call s_stream explicitly for such
devices to start video.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
---
 drivers/media/i2c/ths7303.c |    4 +---
 include/media/ths7303.h     |    2 --
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 65853ee..8cddcd0 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -356,9 +356,7 @@ static int ths7303_setup(struct v4l2_subdev *sd)
 	int ret;
 	u8 mask;
 
-	state->stream_on = pdata->init_enable;
-
-	mask = state->stream_on ? 0xff : 0xf8;
+	mask = 0xf8;
 
 	ret = ths7303_write(sd, THS7303_CHANNEL_1, pdata->ch_1 & mask);
 	if (ret)
diff --git a/include/media/ths7303.h b/include/media/ths7303.h
index 980ec51..a7b4929 100644
--- a/include/media/ths7303.h
+++ b/include/media/ths7303.h
@@ -30,13 +30,11 @@
  * @ch_1: Bias value for channel one.
  * @ch_2: Bias value for channel two.
  * @ch_3: Bias value for channel three.
- * @init_enable: initalize on init.
  */
 struct ths7303_platform_data {
 	u8 ch_1;
 	u8 ch_2;
 	u8 ch_3;
-	u8 init_enable;
 };
 
 #endif
-- 
1.7.0.4

