Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:65476 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHIGTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 02:19:24 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so8094973pdj.36
        for <linux-media@vger.kernel.org>; Fri, 08 Aug 2014 23:19:24 -0700 (PDT)
Message-ID: <1407565160.5172.4.camel@phoenix>
Subject: [PATCH 1/2] [media] sh_veu: Include media/v4l2-image-sizes.h
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
Date: Sat, 09 Aug 2014 14:19:20 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So we can remove the same defines in the driver code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/media/platform/sh_veu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 8dc279d..be3b3bc 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -26,6 +26,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mem2mem.h>
+#include <media/v4l2-image-sizes.h>
 #include <media/videobuf2-dma-contig.h>
 
 #define VEU_STR 0x00 /* start register */
@@ -135,9 +136,6 @@ enum sh_veu_fmt_idx {
 	SH_VEU_FMT_RGB24,
 };
 
-#define VGA_WIDTH	640
-#define VGA_HEIGHT	480
-
 #define DEFAULT_IN_WIDTH	VGA_WIDTH
 #define DEFAULT_IN_HEIGHT	VGA_HEIGHT
 #define DEFAULT_IN_FMTIDX	SH_VEU_FMT_NV12
-- 
1.9.1



