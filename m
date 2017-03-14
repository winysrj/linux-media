Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47158 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdCNTKJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:10:09 -0400
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
Subject: [PATCH 11/16] rcar-vin: select capture mode based on free buffers
Date: Tue, 14 Mar 2017 19:59:52 +0100
Message-Id: <20170314185957.25253-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of selecting single or continuous capture mode based on how many
buffers userspace intends to give us select capture mode based on number
of free buffers we can allocate to hardware when the stream is started.

This change is a prerequisite to enable the driver to switch from
continuous to single capture mode (or the other way around) when the
driver is stalled by userspace not feeding it buffers as fast as it
consumes it.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 31 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index c10d75aa7e71d665..f7776592b9a13d41 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -404,7 +404,21 @@ static void rvin_capture_off(struct rvin_dev *vin)
 
 static int rvin_capture_start(struct rvin_dev *vin)
 {
-	int ret;
+	struct rvin_buffer *buf, *node;
+	int bufs, ret;
+
+	/* Count number of free buffers */
+	bufs = 0;
+	list_for_each_entry_safe(buf, node, &vin->buf_list, list)
+		bufs++;
+
+	/* Continuous capture requires more buffers then there are HW slots */
+	vin->continuous = bufs > HW_BUFFER_NUM;
+
+	if (!rvin_fill_hw(vin)) {
+		vin_err(vin, "HW not ready to start, not enough buffers available\n");
+		return -EINVAL;
+	}
 
 	rvin_crop_scale_comp(vin);
 
@@ -1061,22 +1075,7 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 	vin->state = RUNNING;
 	vin->sequence = 0;
 
-	/* Continuous capture requires more buffers then there are HW slots */
-	vin->continuous = count > HW_BUFFER_NUM;
-
-	/*
-	 * This should never happen but if we don't have enough
-	 * buffers for HW bail out
-	 */
-	if (!rvin_fill_hw(vin)) {
-		vin_err(vin, "HW not ready to start, not enough buffers available\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
 	ret = rvin_capture_start(vin);
-out:
-	/* Return all buffers if something went wrong */
 	if (ret) {
 		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
 		v4l2_subdev_call(sd, video, s_stream, 0);
-- 
2.12.0
