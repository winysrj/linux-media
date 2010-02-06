Return-path: <linux-media-owner@vger.kernel.org>
Received: from atlantis.8hz.com ([212.129.237.78]:57455 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab0BFOFD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Feb 2010 09:05:03 -0500
Date: Sat, 6 Feb 2010 13:58:41 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] saa7134 can capture 720x480 when capturing NTSC
Message-ID: <20100206135841.GA10725@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When capturing NTSC, the saa7134 can capture 720x480.

While doing Laserdisc captures using this card, I noticed that right side 
was truncated/cropped. The highest geometry the driver allows is 704x480,
even though in Windows XP it is 720x480. This results in no cropping
and the same results as in Windows.

Tested on an AverMedia GO 007 FM Plus.

Signed-off-by: Sean Young <sean@mess.org>
-- 
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index cb73264..31138d3 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -205,7 +205,7 @@ static struct saa7134_format formats[] = {
 
 #define NORM_525_60			\
 		.h_start       = 0,	\
-		.h_stop        = 703,	\
+		.h_stop        = 719,	\
 		.video_v_start = 23,	\
 		.video_v_stop  = 262,	\
 		.vbi_v_start_0 = 10,	\
