Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34688 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbaJVKED (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:04:03 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/5] [media] vivid: remove unused videobuf2-vmalloc headers
Date: Wed, 22 Oct 2014 12:03:38 +0200
Message-Id: <1413972221-13669-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de>
References: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The videobuf2-vmalloc header is not used by the changed files, so remove it.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/vivid/vivid-kthread-cap.c | 1 -
 drivers/media/platform/vivid/vivid-kthread-out.c | 1 -
 drivers/media/platform/vivid/vivid-osd.c         | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 39a67cf..65e5f76 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -31,7 +31,6 @@
 #include <linux/random.h>
 #include <linux/v4l2-dv-timings.h>
 #include <asm/div64.h>
-#include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
index d9f36cc..6da0e01 100644
--- a/drivers/media/platform/vivid/vivid-kthread-out.c
+++ b/drivers/media/platform/vivid/vivid-kthread-out.c
@@ -31,7 +31,6 @@
 #include <linux/random.h>
 #include <linux/v4l2-dv-timings.h>
 #include <asm/div64.h>
-#include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
diff --git a/drivers/media/platform/vivid/vivid-osd.c b/drivers/media/platform/vivid/vivid-osd.c
index 084d346..c90cf13 100644
--- a/drivers/media/platform/vivid/vivid-osd.c
+++ b/drivers/media/platform/vivid/vivid-osd.c
@@ -29,7 +29,6 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/fb.h>
-#include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
-- 
2.1.1

