Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:64869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1AaMQe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 07:16:34 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: omap24xxcam: Fix compilation
Date: Mon, 31 Jan 2011 13:16:09 +0100
Message-Id: <1296476169-10862-1-git-send-email-weber@corscience.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add linux/sched.h because of missing declaration of TASK_NORMAL.

This patch fixes the following error:

drivers/media/video/omap24xxcam.c: In function
'omap24xxcam_vbq_complete':
drivers/media/video/omap24xxcam.c:415: error: 'TASK_NORMAL' undeclared
(first use in this function)
drivers/media/video/omap24xxcam.c:415: error: (Each undeclared
identifier is reported only once
drivers/media/video/omap24xxcam.c:415: error: for each function it
appears in.)

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/media/video/omap24xxcam.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 0175527..f6626e8 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -36,6 +36,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-- 
1.7.4.rc3

