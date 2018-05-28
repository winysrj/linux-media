Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:48167 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935509AbeE1X0z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 19:26:55 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2] rcar-vin: sync which hardware buffer to start capture from
Date: Tue, 29 May 2018 01:26:37 +0200
Message-Id: <20180528232637.14905-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When starting the VIN capture procedure we are not guaranteed that the
first buffer written to is VnMB1 to which we assigned the first buffer
queued. This is problematic for two reasons. Buffers might not be
dequeued in the same order they where queued for capture. Future
features planed for the VIN driver is support for outputting frames in
SEQ_TB/BT format and to do that it's important that capture starts from
the first buffer slot, VnMB1.

We are guaranteed that capturing always happens in sequence (VnMB1 ->
VnMB2 -> VnMB3 -> VnMB1). So drop up to two frames when starting
capturing so that the driver always returns buffers in the same order
they are queued and prepare for SEQ_TB/BT output.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---

* Changes since v1
- Fix spelling in commit message pointed out by Sergei.
  s/writing/written/ and s/outputing/outputting/.
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 16 +++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-vin.h |  2 ++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index ac07f99e3516a620..cfe5d7a9d44ee0e1 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -856,7 +856,7 @@ static int rvin_capture_start(struct rvin_dev *vin)
 	/* Continuous Frame Capture Mode */
 	rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
 
-	vin->state = RUNNING;
+	vin->state = STARTING;
 
 	return 0;
 }
@@ -910,6 +910,20 @@ static irqreturn_t rvin_irq(int irq, void *data)
 	vnms = rvin_read(vin, VNMS_REG);
 	slot = (vnms & VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
 
+	/*
+	 * To hand buffers back in a known order to userspace start
+	 * to capture first from slot 0.
+	 */
+	if (vin->state == STARTING) {
+		if (slot != 0) {
+			vin_dbg(vin, "Starting sync slot: %d\n", slot);
+			goto done;
+		}
+
+		vin_dbg(vin, "Capture start synced!\n");
+		vin->state = RUNNING;
+	}
+
 	/* Capture frame */
 	if (vin->queue_buf[slot]) {
 		vin->queue_buf[slot]->field = vin->format.field;
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index c2aef789b491ab31..ff747e22d8cfb643 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -53,11 +53,13 @@ enum rvin_csi_id {
 
 /**
  * STOPPED  - No operation in progress
+ * STARTING - Capture starting up
  * RUNNING  - Operation in progress have buffers
  * STOPPING - Stopping operation
  */
 enum rvin_dma_state {
 	STOPPED = 0,
+	STARTING,
 	RUNNING,
 	STOPPING,
 };
-- 
2.17.0
