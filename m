Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:60764 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZFDKeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 06:34:07 -0400
Received: by ewy6 with SMTP id 6so968142ewy.37
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2009 03:34:07 -0700 (PDT)
Message-ID: <4A27BDFB.403@gmail.com>
Date: Thu, 04 Jun 2009 14:28:43 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mchehab@infradead.org
CC: linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tvp514x: try_count off by one.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

with `while (try_count-- > 0)' try_count reaches -1 after the loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 4262e60..3750f7f 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -692,7 +692,7 @@ static int ioctl_s_routing(struct v4l2_int_device *s,
 			break;	/* Input detected */
 	}
 
-	if ((current_std == STD_INVALID) || (try_count <= 0))
+	if ((current_std == STD_INVALID) || (try_count < 0))
 		return -EINVAL;
 
 	decoder->current_std = current_std;
