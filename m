Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f176.google.com ([209.85.216.176]:37781 "EHLO
	mail-px0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413AbZIPNGg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 09:06:36 -0400
Received: by pxi6 with SMTP id 6so3978840pxi.21
        for <linux-media@vger.kernel.org>; Wed, 16 Sep 2009 06:06:40 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 2/9] V4L/DVB: si4713: remove unused #include <linux/version.h>
Date: Wed, 16 Sep 2009 21:06:15 +0800
Message-Id: <1253106375-2636-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <linux/version.h>('s) in
  drivers/media/radio/radio-si4713.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/radio/radio-si4713.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 65c14b7..170bbe5 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -24,7 +24,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/version.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
-- 
1.6.1.3

