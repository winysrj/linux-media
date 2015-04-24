Return-path: <linux-media-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:38873 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbbDYGxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 02:53:30 -0400
Received: from mailnull by bh-25.webhostbox.net with sa-checked (Exim 4.85)
	(envelope-from <linux@roeck-us.net>)
	id 1YljDU-003j53-A1
	for linux-media@vger.kernel.org; Fri, 24 Apr 2015 19:24:48 +0000
From: Guenter Roeck <linux@roeck-us.net>
To: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
	Kedareswara rao Appana <appana.durga.rao@xilinx.com>
Subject: [PATCH] [media] xilinx: Reflect dma header file move
Date: Fri, 24 Apr 2015 12:24:36 -0700
Message-Id: <1429903476-24161-1-git-send-email-linux@roeck-us.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 937abe88aea3 ("dmaengine: xilinx-dma: move header file to common
location") moved xilinx_dma.h to a common location but neglected to reflect
this move in all its users.

This causes compile errors for several builds.

drivers/media/platform/xilinx/xilinx-dma.c:15:35:
	fatal error: linux/amba/xilinx_dma.h: No such file or directory

Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
Fixes: 937abe88aea3 ("dmaengine: xilinx-dma: move header file to common
	location")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/media/platform/xilinx/xilinx-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 10209c294168..efde88adf624 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -12,7 +12,7 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/amba/xilinx_dma.h>
+#include <linux/dma/xilinx_dma.h>
 #include <linux/lcm.h>
 #include <linux/list.h>
 #include <linux/module.h>
-- 
2.1.0

