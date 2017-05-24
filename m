Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:46802 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765683AbdEXARE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:17:04 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 12/17] rcar-vin: allow switch between capturing modes when stalling
Date: Wed, 24 May 2017 02:15:35 +0200
Message-Id: <20170524001540.13613-13-niklas.soderlund@ragnatech.se>
In-Reply-To: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

If userspace can't feed the driver with buffers as fast as the driver
consumes them the driver will stop video capturing and wait for more
buffers from userspace, the driver is stalled. Once it have been feed
one or more free buffers it will recover from the stall and resume
capturing.

Instead of continue to capture using the same capture mode as before the
stall allow the driver to choose between single and continuous mode
based on free buffer availability. Do this by stopping capturing when
the driver becomes stalled and restart capturing once it continues. By
doing
this the capture mode will be evaluated each time the driver is
recovering from a stall.

This behavior is needed to fix a bug where continuous capturing mode is
used, userspace is about to stop the stream and is waiting for the last
buffers to be returned from the driver and is not queuing any new
buffers. In this case the driver becomes stalled when there are only 3
buffers remaining streaming will never resume since the driver is
waiting for userspace to feed it more buffers before it can continue
streaming.  With this fix the driver will then switch to single capture
mode for the last 3 buffers and a deadlock is avoided. The issue can be
demonstrated using yavta.

$ yavta -f RGB565 -s 640x480 -n 4 --capture=10  /dev/video22
Device /dev/video22 opened.
Device `R_Car_VIN' on `platform:e6ef1000.video' (driver 'rcar_vin') supports video, capture, without mplanes.
Video format set: RGB565 (50424752) 640x480 (stride 1280) field interlaced buffer size 614400
Video format: RGB565 (50424752) 640x480 (stride 1280) field interlaced buffer size 614400
4 buffers requested.
length: 614400 offset: 0 timestamp type/source: mono/EoF
Buffer 0/0 mapped at address 0xb6cc7000.
length: 614400 offset: 614400 timestamp type/source: mono/EoF
Buffer 1/0 mapped at address 0xb6c31000.
length: 614400 offset: 1228800 timestamp type/source: mono/EoF
Buffer 2/0 mapped at address 0xb6b9b000.
length: 614400 offset: 1843200 timestamp type/source: mono/EoF
Buffer 3/0 mapped at address 0xb6b05000.
0 (0) [-] interlaced 0 614400 B 38.240285 38.240303 12.421 fps ts mono/EoF
1 (1) [-] interlaced 1 614400 B 38.282329 38.282346 23.785 fps ts mono/EoF
2 (2) [-] interlaced 2 614400 B 38.322324 38.322338 25.003 fps ts mono/EoF
3 (3) [-] interlaced 3 614400 B 38.362318 38.362333 25.004 fps ts mono/EoF
4 (0) [-] interlaced 4 614400 B 38.402313 38.402328 25.003 fps ts mono/EoF
5 (1) [-] interlaced 5 614400 B 38.442307 38.442321 25.004 fps ts mono/EoF
6 (2) [-] interlaced 6 614400 B 38.482301 38.482316 25.004 fps ts mono/EoF
7 (3) [-] interlaced 7 614400 B 38.522295 38.522312 25.004 fps ts mono/EoF
8 (0) [-] interlaced 8 614400 B 38.562290 38.562306 25.003 fps ts mono/EoF
<blocks forever, waiting for the last buffer>

This fix also allow the driver to switch to single capture mode if
userspace doesn't feed it buffers fast enough. Or the other way around,
if userspace suddenly feeds the driver buffers faster it can switch to
continues capturing mode.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 47d78f68d715d945..ae4febede5f79f28 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -429,6 +429,8 @@ static int rvin_capture_start(struct rvin_dev *vin)
 
 	rvin_capture_on(vin);
 
+	vin->state = RUNNING;
+
 	return 0;
 }
 
@@ -907,7 +909,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
 	struct rvin_dev *vin = data;
 	u32 int_status, vnms;
 	int slot;
-	unsigned int sequence, handled = 0;
+	unsigned int i, sequence, handled = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vin->qlock, flags);
@@ -969,8 +971,20 @@ static irqreturn_t rvin_irq(int irq, void *data)
 		 * the VnMBm registers.
 		 */
 		if (vin->continuous) {
-			rvin_capture_off(vin);
+			rvin_capture_stop(vin);
 			vin_dbg(vin, "IRQ %02d: hw not ready stop\n", sequence);
+
+			/* Maybe we can continue in single capture mode */
+			for (i = 0; i < HW_BUFFER_NUM; i++) {
+				if (vin->queue_buf[i]) {
+					list_add(to_buf_list(vin->queue_buf[i]),
+						 &vin->buf_list);
+					vin->queue_buf[i] = NULL;
+				}
+			}
+
+			if (!list_empty(&vin->buf_list))
+				rvin_capture_start(vin);
 		}
 	} else {
 		/*
@@ -1055,8 +1069,7 @@ static void rvin_buffer_queue(struct vb2_buffer *vb)
 	 * capturing if HW is ready to continue.
 	 */
 	if (vin->state == STALLED)
-		if (rvin_fill_hw(vin))
-			rvin_capture_on(vin);
+		rvin_capture_start(vin);
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
 }
@@ -1073,7 +1086,6 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	spin_lock_irqsave(&vin->qlock, flags);
 
-	vin->state = RUNNING;
 	vin->sequence = 0;
 
 	ret = rvin_capture_start(vin);
-- 
2.13.0
