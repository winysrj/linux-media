Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:56050 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752376AbdHVX2o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 19:28:44 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v6 09/25] rcar-vin: do not allow changing scaling and composing while streaming
Date: Wed, 23 Aug 2017 01:26:24 +0200
Message-Id: <20170822232640.26147-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is possible on Gen2 to change the registers controlling composing and
scaling while the stream is running. Is however not a good idea to do so
and could result in trouble. There are also no good reason to allow
this, remove immediate reflection in hardware registers from
vidioc_s_selection and only configure scaling and composing when the
stream starts.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  | 2 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ---
 drivers/media/platform/rcar-vin/rcar-vin.h  | 3 ---
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 5f9674dc898305ba..6cc880e5ef7e0718 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -514,7 +514,7 @@ static void rvin_set_coeff(struct rvin_dev *vin, unsigned short xs)
 	rvin_write(vin, p_set->coeff_set[23], VNC8C_REG);
 }
 
-void rvin_crop_scale_comp(struct rvin_dev *vin)
+static void rvin_crop_scale_comp(struct rvin_dev *vin)
 {
 	u32 xs, ys;
 
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 421820caf275b066..305a74d033b2d9c5 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -436,9 +436,6 @@ static int rvin_s_selection(struct file *file, void *fh,
 		return -EINVAL;
 	}
 
-	/* HW supports modifying configuration while running */
-	rvin_crop_scale_comp(vin);
-
 	return 0;
 }
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index b2bac06c0a3cfcb7..fc70ded462ed3244 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -176,7 +176,4 @@ int rvin_reset_format(struct rvin_dev *vin);
 
 const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 
-/* Cropping, composing and scaling */
-void rvin_crop_scale_comp(struct rvin_dev *vin);
-
 #endif
-- 
2.14.0
