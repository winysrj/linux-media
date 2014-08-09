Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63075 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHIGUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 02:20:07 -0400
Received: by mail-pa0-f50.google.com with SMTP id et14so8392606pad.9
        for <linux-media@vger.kernel.org>; Fri, 08 Aug 2014 23:20:06 -0700 (PDT)
Message-ID: <1407565201.5172.5.camel@phoenix>
Subject: [PATCH 2/2] [media] via-camera: Include media/v4l2-image-sizes.h
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
Date: Sat, 09 Aug 2014 14:20:01 +0800
In-Reply-To: <1407565160.5172.4.camel@phoenix>
References: <1407565160.5172.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So we can remove the same defines in the driver code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/media/platform/via-camera.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index b4f9d03..2ac8704 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -18,6 +18,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-image-sizes.h>
 #include <media/ov7670.h>
 #include <media/videobuf-dma-sg.h>
 #include <linux/delay.h>
@@ -49,14 +50,6 @@ MODULE_PARM_DESC(override_serial,
 		"to force-enable the camera.");
 
 /*
- * Basic window sizes.
- */
-#define VGA_WIDTH	640
-#define VGA_HEIGHT	480
-#define QCIF_WIDTH	176
-#define	QCIF_HEIGHT	144
-
-/*
  * The structure describing our camera.
  */
 enum viacam_opstate { S_IDLE = 0, S_RUNNING = 1 };
-- 
1.9.1



