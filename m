Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:2686
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618Ab1IFOCX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 10:02:23 -0400
From: Joerg Roedel <joerg.roedel@amd.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Joerg Roedel <joerg.roedel@amd.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: omap: Fix build error in ispccdc.c
Date: Tue, 6 Sep 2011 16:02:15 +0200
Message-ID: <1315317735-5255-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following build error occurs with 3.1-rc5:

  CC      drivers/media/video/omap3isp/ispccdc.o
/home/data/repos/linux.trees.git/drivers/media/video/omap3isp/ispccdc.c: In function 'ccdc_lsc_config':
/home/data/repos/linux.trees.git/drivers/media/video/omap3isp/ispccdc.c:427:2: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]
/home/data/repos/linux.trees.git/drivers/media/video/omap3isp/ispccdc.c:427:6: warning: assignment makes pointer from integer without a cast [enabled by default]

This patch adds the missing 'linux/slab.h' include to fix the problem.

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/media/video/omap3isp/ispccdc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index 9d3459d..80796eb 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -31,6 +31,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <media/v4l2-event.h>
 
 #include "isp.h"
-- 
1.7.4.1


