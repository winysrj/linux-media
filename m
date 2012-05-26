Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60091 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195Ab2EZTV4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 15:21:56 -0400
Received: by lahd3 with SMTP id d3so1262605lah.19
        for <linux-media@vger.kernel.org>; Sat, 26 May 2012 12:21:55 -0700 (PDT)
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 3/3] I don`t know for what, but there`s dublicate item.
Date: Sat, 26 May 2012 23:18:43 +0400
Message-Id: <1338059923-4989-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/media/video/bt8xx/bttv-driver.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index e581b37..b4ee7de 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -558,12 +558,6 @@ static const struct bttv_format formats[] = {
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
 	},{
-		.name     = "4:2:2, packed, YUYV",
-		.fourcc   = V4L2_PIX_FMT_YUYV,
-		.btformat = BT848_COLOR_FMT_YUY2,
-		.depth    = 16,
-		.flags    = FORMAT_FLAGS_PACKED,
-	},{
 		.name     = "4:2:2, packed, UYVY",
 		.fourcc   = V4L2_PIX_FMT_UYVY,
 		.btformat = BT848_COLOR_FMT_YUY2,
-- 
1.7.7.6

