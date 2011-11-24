Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:48740 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab1KXXS7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 18:18:59 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH] V4L: omap1_camera: fix missing <linux/module.h> include
Date: Fri, 25 Nov 2011 00:16:35 +0100
Message-Id: <1322176595-31837-1-git-send-email-jkrzyszt@tis.icnet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise compilation breaks with:

drivers/media/video/omap1_camera.c:1535: error: 'THIS_MODULE' undeclared here (not in a function)
...

after apparently no longer included recursively from other header files.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 drivers/media/video/omap1_camera.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index e87ae2f..6a6cf38 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -24,6 +24,7 @@
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
-- 
1.7.3.4

