Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44067 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab2CPWtp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 18:49:45 -0400
Received: by mail-gx0-f174.google.com with SMTP id e5so4722853ggh.19
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 15:49:45 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org
Cc: rankincj@yahoo.com, dheitmueller@kernellabs.com, crope@iki.fi,
	saschasommer@freenet.de, linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] media: em28xx: Unused macro cleanup
Date: Fri, 16 Mar 2012 19:49:34 -0300
Message-Id: <1331938174-2266-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-i2c.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
index 36f5a9b..a88e169 100644
--- a/drivers/media/video/em28xx/em28xx-i2c.c
+++ b/drivers/media/video/em28xx/em28xx-i2c.c
@@ -41,14 +41,6 @@ static unsigned int i2c_debug;
 module_param(i2c_debug, int, 0644);
 MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 
-
-#define dprintk1(lvl, fmt, args...)			\
-do {							\
-	if (i2c_debug >= lvl) {				\
-	printk(fmt, ##args);				\
-      }							\
-} while (0)
-
 #define dprintk2(lvl, fmt, args...)			\
 do {							\
 	if (i2c_debug >= lvl) {				\
-- 
1.7.3.4

