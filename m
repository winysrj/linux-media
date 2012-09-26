Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48212 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2IZKZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 06:25:17 -0400
Received: by yenm12 with SMTP id m12so76575yen.19
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 03:25:16 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] em28xx: Replace memcpy with struct assignment
Date: Wed, 26 Sep 2012 07:25:12 -0300
Message-Id: <1348655112-13601-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This kind of memcpy() is error-prone and its
replacement with a struct assignment is prefered.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index ca62b99..1a07857 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2203,7 +2203,7 @@ EXPORT_SYMBOL_GPL(em28xx_tuner_callback);
 
 static inline void em28xx_set_model(struct em28xx *dev)
 {
-	memcpy(&dev->board, &em28xx_boards[dev->model], sizeof(dev->board));
+	dev->board = em28xx_boards[dev->model];
 
 	/* Those are the default values for the majority of boards
 	   Use those values if not specified otherwise at boards entry
-- 
1.7.8.6

