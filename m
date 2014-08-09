Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63667 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaHIF7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 01:59:48 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so8384570pab.12
        for <linux-media@vger.kernel.org>; Fri, 08 Aug 2014 22:59:48 -0700 (PDT)
Message-ID: <1407563984.5172.1.camel@phoenix>
Subject: [PATCH 2/4] [media] vs6624: Include media/v4l2-image-sizes.h
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>,
	adi-buildroot-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Date: Sat, 09 Aug 2014 13:59:44 +0800
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
 drivers/media/i2c/vs6624.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 23f4f65..373f2df 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -30,22 +30,10 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mediabus.h>
+#include <media/v4l2-image-sizes.h>
 
 #include "vs6624_regs.h"
 
-#define VGA_WIDTH       640
-#define VGA_HEIGHT      480
-#define QVGA_WIDTH      320
-#define QVGA_HEIGHT     240
-#define QQVGA_WIDTH     160
-#define QQVGA_HEIGHT    120
-#define CIF_WIDTH       352
-#define CIF_HEIGHT      288
-#define QCIF_WIDTH      176
-#define QCIF_HEIGHT     144
-#define QQCIF_WIDTH     88
-#define QQCIF_HEIGHT    72
-
 #define MAX_FRAME_RATE  30
 
 struct vs6624 {
-- 
1.9.1



