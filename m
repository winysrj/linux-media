Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62145 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaHIGAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 02:00:49 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so8252864pab.26
        for <linux-media@vger.kernel.org>; Fri, 08 Aug 2014 23:00:49 -0700 (PDT)
Message-ID: <1407564044.5172.2.camel@phoenix>
Subject: [PATCH 3/4] [media] soc_camera: mt9t112: Include
 media/v4l2-image-sizes.h
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	linux-media@vger.kernel.org
Date: Sat, 09 Aug 2014 14:00:44 +0800
In-Reply-To: <1407563920.5172.0.camel@phoenix>
References: <1407563920.5172.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So we can remove the same defines in the driver code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/media/i2c/soc_camera/mt9t112.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 46f431a..996d7b4 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -29,6 +29,7 @@
 #include <media/soc_camera.h>
 #include <media/v4l2-clk.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-image-sizes.h>
 
 /* you can check PLL/clock info */
 /* #define EXT_CLOCK 24000000 */
@@ -42,9 +43,6 @@
 #define MAX_WIDTH   2048
 #define MAX_HEIGHT  1536
 
-#define VGA_WIDTH   640
-#define VGA_HEIGHT  480
-
 /*
  * macro of read/write
  */
-- 
1.9.1



