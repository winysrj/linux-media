Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:38577 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZGXKnU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 06:43:20 -0400
Received: by ewy26 with SMTP id 26so1638687ewy.37
        for <linux-media@vger.kernel.org>; Fri, 24 Jul 2009 03:43:19 -0700 (PDT)
Message-ID: <4A6990DA.3070002@gmail.com>
Date: Fri, 24 Jul 2009 12:45:46 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mchehab@infradead.org, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] stk-webcam: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It tested the value of stk_sizes[i].m before checking whether i was in range.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 4d6785e..b154bd9 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1050,8 +1050,8 @@ static int stk_setup_format(struct stk_camera *dev)
 		depth = 1;
 	else
 		depth = 2;
-	while (stk_sizes[i].m != dev->vsettings.mode
-			&& i < ARRAY_SIZE(stk_sizes))
+	while (i < ARRAY_SIZE(stk_sizes) &&
+			stk_sizes[i].m != dev->vsettings.mode)
 		i++;
 	if (i == ARRAY_SIZE(stk_sizes)) {
 		STK_ERROR("Something is broken in %s\n", __func__);
