Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37396 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdCNTGi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:38 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 11/27] rcar-vin: do not allow changing scaling and composing while streaming
Date: Tue, 14 Mar 2017 20:02:52 +0100
Message-Id: <20170314190308.25790-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
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
index 286aafab533cda9d..ef029e4c7882322e 100644
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
index e14f0aff8ceecc68..919040e40aec60f6 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -442,9 +442,6 @@ static int rvin_s_selection(struct file *file, void *fh,
 		return -EINVAL;
 	}
 
-	/* HW supports modifying configuration while running */
-	rvin_crop_scale_comp(vin);
-
 	return 0;
 }
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 6bf2e4ff8f6076c7..f1251c013d1d2d80 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -175,7 +175,4 @@ void rvin_v4l2_remove(struct rvin_dev *vin);
 
 const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 
-/* Cropping, composing and scaling */
-void rvin_crop_scale_comp(struct rvin_dev *vin);
-
 #endif
-- 
2.12.0
