Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47716 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754822AbdKKAjF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 19:39:05 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v7 09/25] rcar-vin: do not allow changing scaling and composing while streaming
Date: Sat, 11 Nov 2017 01:38:19 +0100
Message-Id: <20171111003835.4909-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is possible on Gen2 to change the registers controlling composing and
scaling while the stream is running. It is however not a good idea to do
so and could result in trouble. There are also no good reasons to allow
this, remove immediate reflection in hardware registers from
vidioc_s_selection and only configure scaling and composing when the
stream starts.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  | 2 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ---
 drivers/media/platform/rcar-vin/rcar-vin.h  | 3 ---
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index daf01bb32b5fc3c2..b478eda84a27bf09 100644
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
index 25f2386cb67447f2..b3c23634e9dbe095 100644
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
index 80f38b89ed8d9992..111dd8a1974253af 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -176,7 +176,4 @@ int rvin_reset_format(struct rvin_dev *vin);
 
 const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
 
-/* Cropping, composing and scaling */
-void rvin_crop_scale_comp(struct rvin_dev *vin);
-
 #endif
-- 
2.15.0
