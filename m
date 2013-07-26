Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42342 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3GZJdK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 05:33:10 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq8so1833626pbb.19
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 02:33:09 -0700 (PDT)
From: Katsuya Matsubara <matsu@igel.co.jp>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH 6/7] [media] vsp1: Move the DPR_WPF_FPORCH register settings into the device initialization
Date: Fri, 26 Jul 2013 18:32:16 +0900
Message-Id: <1374831137-9219-7-git-send-email-matsu@igel.co.jp>
In-Reply-To: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
References: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DPR_WPR_FPORCH registers must be set once with a constant value
and they are never varied at runtime.
So it can be moved into the vsp1_device_init function that will be
invoked just one time.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 drivers/media/platform/vsp1/vsp1_drv.c  |    9 +++++++++
 drivers/media/platform/vsp1/vsp1_regs.h |    2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c  |    3 ---
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index ca05431..c24f43f 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -241,6 +241,12 @@ static void vsp1_device_init(struct vsp1_device *vsp1)
 	u32 status;
 	u32 route_unused = vsp1->routes[VI6_DPR_NODE_UNUSED].id;
 	u32 val;
+	const u32 fporch_fp[VPS1_MAX_WPF] = {
+		(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
+		(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
+		(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
+		(VI6_DPR_WPF_FPORCH_FP_WPFN << 8),
+	};
 
 	/* Reset any channel that might be running. */
 	status = vsp1_read(vsp1, VI6_STATUS);
@@ -305,6 +311,9 @@ static void vsp1_device_init(struct vsp1_device *vsp1)
 	val |= route_unused << vsp1->routes[VI6_DPR_NODE_BRU_OUT].shift;
 	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, val);
 
+	for (i = 0; i < VPS1_MAX_WPF; ++i)
+		vsp1_write(vsp1, VI6_DPR_WPF_FPORCH0 + i, fporch_fp[i]);
+
 	vsp1_write(vsp1, VI6_DPR_HGO_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
 		   (route_unused << VI6_DPR_SMPPT_PT_SHIFT));
 	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index b201202..bd9f72e 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -507,7 +507,7 @@ enum {
  * Macros for DPR Control Registers
  */
 
-#define VI6_DPR_WPF_FPORCH_FP_WPFN	(5 << 8)
+#define VI6_DPR_WPF_FPORCH_FP_WPFN	5
 
 #define VI6_DPR_ROUTE_FXA_MASK		(0xff << 8)
 #define VI6_DPR_ROUTE_FXA_SHIFT		16
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 37779ef..af1f1b8 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -104,9 +104,6 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, outfmt);
 
-	vsp1_write(vsp1, VI6_DPR_WPF_FPORCH0 + wpf->entity.index,
-		   VI6_DPR_WPF_FPORCH_FP_WPFN);
-
 	vsp1_write(vsp1, VI6_WPF_WRBCK_CTRL, 0);
 
 	/* Enable interrupts */
-- 
1.7.9.5

