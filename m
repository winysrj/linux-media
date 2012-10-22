Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:39107 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab2JVOFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 10:05:32 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH 1/2] [media] vivi: Kill BUFFER_TIMEOUT macro
Date: Mon, 22 Oct 2012 17:54:43 +0400
Message-Id: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Usage of BUFFER_TIMEOUT has gone in 2008 in 78718e5d (V4L/DVB (7492):
vivi: Simplify the vivi driver and avoid deadlocks), but the macro
remains. Say goodbye to it.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/media/platform/vivi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index b366b05..3e6902a 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -39,7 +39,6 @@
 /* Wake up at about 30 fps */
 #define WAKE_NUMERATOR 30
 #define WAKE_DENOMINATOR 1001
-#define BUFFER_TIMEOUT     msecs_to_jiffies(500)  /* 0.5 seconds */
 
 #define MAX_WIDTH 1920
 #define MAX_HEIGHT 1200
-- 
1.8.0.rc3.331.g5b9a629

