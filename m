Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39871 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab1KJXfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:35:43 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3521161iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:35:43 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 25/25] modified em28xx header for pctv80e support
Date: Thu, 10 Nov 2011 17:31:45 -0600
Message-Id: <1320967905-7932-26-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/video/em28xx/em28xx.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 2a2cb7e..ead2cfe 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -121,6 +121,7 @@
 #define EM28174_BOARD_PCTV_290E                   78
 #define EM2884_BOARD_TERRATEC_H5		  79
 #define EM28174_BOARD_PCTV_460E                   80
+#define EM2874_BOARD_PCTV_HD_MINI_80E		  81
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.5.4

