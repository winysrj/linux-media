Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59435 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaHIGBo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 02:01:44 -0400
Received: by mail-pd0-f171.google.com with SMTP id z10so8116499pdj.30
        for <linux-media@vger.kernel.org>; Fri, 08 Aug 2014 23:01:43 -0700 (PDT)
Message-ID: <1407564099.5172.3.camel@phoenix>
Subject: [PATCH 4/4] [media] soc_camera: ov772x: Include
 media/v4l2-image-sizes.h
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	linux-media@vger.kernel.org
Date: Sat, 09 Aug 2014 14:01:39 +0800
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
 drivers/media/i2c/soc_camera/ov772x.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index 7f2b3c8..970a04e 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -29,6 +29,7 @@
 #include <media/v4l2-clk.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
+#include <media/v4l2-image-sizes.h>
 
 /*
  * register offset
@@ -360,10 +361,6 @@
 #define SCAL0_ACTRL     0x08 /* Auto scaling factor control */
 #define SCAL1_2_ACTRL   0x04 /* Auto scaling factor control */
 
-#define VGA_WIDTH		640
-#define VGA_HEIGHT		480
-#define QVGA_WIDTH		320
-#define QVGA_HEIGHT		240
 #define OV772X_MAX_WIDTH	VGA_WIDTH
 #define OV772X_MAX_HEIGHT	VGA_HEIGHT
 
-- 
1.9.1



