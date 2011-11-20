Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback8.mail.ru ([94.100.176.136]:51546 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab1KTRFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Nov 2011 12:05:07 -0500
Received: from smtp24.mail.ru (smtp24.mail.ru [94.100.176.177])
	by fallback8.mail.ru (mPOP.Fallback_MX) with ESMTP id 7F69930CE7F6
	for <linux-media@vger.kernel.org>; Sun, 20 Nov 2011 20:54:53 +0400 (MSK)
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] omap3isp: fix compilation of ispvideo.c
Date: Sun, 20 Nov 2011 20:54:26 +0400
Message-Id: <1321808066-1791-1-git-send-email-mad_soft@inbox.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix following build error by explicitely including <linux/module.h>
header file.

  CC      drivers/media/video/omap3isp/ispvideo.o
drivers/media/video/omap3isp/ispvideo.c:1267: error: 'THIS_MODULE' undeclared here (not in a function)
make[4]: *** [drivers/media/video/omap3isp/ispvideo.o] Error 1
make[3]: *** [drivers/media/video/omap3isp] Error 2
make[2]: *** [drivers/media/video] Error 2
make[1]: *** [drivers/media] Error 2
make: *** [drivers] Error 2

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 drivers/media/video/omap3isp/ispvideo.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index d100072..f229057 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -26,6 +26,7 @@
 #include <asm/cacheflush.h>
 #include <linux/clk.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
-- 
1.7.4.rc3

