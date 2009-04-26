Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:50397 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbZDZPpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 11:45:09 -0400
Received: by ewy24 with SMTP id 24so1755256ewy.37
        for <linux-media@vger.kernel.org>; Sun, 26 Apr 2009 08:45:06 -0700 (PDT)
Message-ID: <49F48183.50302@gmail.com>
Date: Sun, 26 Apr 2009 17:45:07 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] zoran: invalid test on unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fmt->index is unsigned. test doesn't work

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is there another test required?

diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index 092333b..0db5d0f 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -1871,7 +1871,7 @@ static int zoran_enum_fmt(struct zoran *zr, struct v4l2_fmtdesc *fmt, int flag)
 		if (num == fmt->index)
 			break;
 	}
-	if (fmt->index < 0 /* late, but not too late */  || i == NUM_FORMATS)
+	if (i == NUM_FORMATS)
 		return -EINVAL;
 
 	strncpy(fmt->description, zoran_formats[i].name, sizeof(fmt->description)-1);
