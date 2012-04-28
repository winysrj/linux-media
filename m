Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54378 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab2D1PKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 11:10:00 -0400
Received: by yenl12 with SMTP id l12so934821yen.19
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2012 08:10:00 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org
Cc: crope@iki.fi, gennarone@gmail.com, linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] em28xx: Remove unused enum em28xx_io_method
Date: Sat, 28 Apr 2012 12:09:49 -0300
Message-Id: <1335625789-8422-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1335625789-8422-1-git-send-email-elezegarcia@gmail.com>
References: <1335625789-8422-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index b004dd8..b5bac9c 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -275,13 +275,6 @@ struct em28xx_dmaqueue {
 	int                        pos;
 };
 
-/* io methods */
-enum em28xx_io_method {
-	IO_NONE,
-	IO_READ,
-	IO_MMAP,
-};
-
 /* inputs */
 
 #define MAX_EM28XX_INPUT 4
@@ -575,7 +568,6 @@ struct em28xx {
 
 	/* states */
 	enum em28xx_dev_state state;
-	enum em28xx_io_method io;
 
 	/* vbi related state tracking */
 	int capture_type;
-- 
1.7.3.4

