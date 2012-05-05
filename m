Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37270 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2EEUN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 16:13:27 -0400
Received: by yenm10 with SMTP id m10so3073646yen.19
        for <linux-media@vger.kernel.org>; Sat, 05 May 2012 13:13:27 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org
Cc: crope@iki.fi, gennarone@gmail.com, linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] em28xx: Fix memory leak on driver defered resource release
Date: Sat,  5 May 2012 17:13:22 -0300
Message-Id: <1336248802-3494-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the device is physically unplugged but there are still
open file handles, resource release is defered until last
opened handle is closed.
This patch fixes a missing em28xx_fh struct release.
Tested by compilation only.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-video.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 8404ec4..0a19071 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2262,6 +2262,7 @@ static int em28xx_v4l2_close(struct file *filp)
 			em28xx_release_resources(dev);
 			kfree(dev->alt_max_pkt_size);
 			kfree(dev);
+			kfree(fh);
 			return 0;
 		}
 
-- 
1.7.3.4

