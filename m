Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38771 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754674Ab0GHMRO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Jul 2010 08:17:14 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1OWq2g-0001kC-Cg
	for linux-media@vger.kernel.org; Thu, 08 Jul 2010 14:17:26 +0200
Date: Thu, 8 Jul 2010 14:17:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L2: fix sh_vou.c compile breakage: #include <slab.h>
Message-ID: <Pine.LNX.4.64.1007081414590.32100@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

There have been a bunch of these slab.h patches floating around, I 
thought, there also was one for sh_vou, but I cannot find it atm. So, if 
an equivalent patch has been submitted earlier, sorry to the original 
author and ignore this one. Otherwise, I'll add it to the 2.6.36 queue.

 drivers/media/video/sh_vou.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index f5b892a..5f73a01 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
 #include <linux/version.h>
 #include <linux/videodev2.h>
 
-- 
1.6.2.4

