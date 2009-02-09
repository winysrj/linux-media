Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46580 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbZBIV5L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2009 16:57:11 -0500
Received: by ewy14 with SMTP id 14so2811216ewy.13
        for <linux-media@vger.kernel.org>; Mon, 09 Feb 2009 13:57:09 -0800 (PST)
Message-ID: <4990A6B2.1080902@gmail.com>
Date: Mon, 09 Feb 2009 22:57:06 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: hvaibhav@ti.com, mchehab@redhat.com
CC: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] v4l/tvp514x: try_count reaches 0, not -1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

with while (try_count-- > 0) { ... } try_count reaches 0, not -1.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 8e23aa5..5f4cbc2 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -686,7 +686,7 @@ static int ioctl_s_routing(struct v4l2_int_device *s,
 			break;	/* Input detected */
 	}
 
-	if ((current_std == STD_INVALID) || (try_count < 0))
+	if ((current_std == STD_INVALID) || (try_count <= 0))
 		return -EINVAL;
 
 	decoder->current_std = current_std;
