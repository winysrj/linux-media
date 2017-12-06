Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:36490 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752166AbdLFQwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Dec 2017 11:52:10 -0500
From: Pravin Shedge <pravin.shedge4linux@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: linux-kernel@vger.kernel.org, pravin.shedge4linux@gmail.com
Subject: [PATCH 09/45] drivers: media: remove duplicate includes
Date: Wed,  6 Dec 2017 22:22:02 +0530
Message-Id: <1512579122-5215-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
---
 drivers/media/platform/pxa_camera.c | 1 -
 drivers/media/platform/ti-vpe/cal.c | 3 ---
 drivers/media/v4l2-core/v4l2-mc.c   | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 9d3f0cb..2a9f02e 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -32,7 +32,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/dmaengine.h>
-#include <linux/dma-mapping.h>
 #include <linux/dma/pxa-dma.h>
 
 #include <media/v4l2-async.h>
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 8b586c8..719ed1d 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -28,10 +28,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
-#include <media/v4l2-event.h>
-#include <media/v4l2-common.h>
 #include <media/videobuf2-core.h>
 #include <media/videobuf2-dma-contig.h>
 #include "cal_regs.h"
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 303980b..1d550af 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -25,8 +25,6 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-mc.h>
 #include <media/v4l2-subdev.h>
-#include <media/media-device.h>
-#include <media/v4l2-mc.h>
 #include <media/videobuf2-core.h>
 
 int v4l2_mc_create_media_graph(struct media_device *mdev)
-- 
2.7.4
