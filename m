Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47145 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdCNTKI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:10:08 -0400
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
Subject: [PATCH 13/16] rcar-vin: refactor and fold in function after stall handling rework
Date: Tue, 14 Mar 2017 19:59:54 +0100
Message-Id: <20170314185957.25253-14-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the driver stopping and starting the stream each time the driver is
stalled rvin_capture_off() can be folded in to the only caller.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index bd1ccb70ae2bc47e..c5fa176ac9d8cc4a 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -396,12 +396,6 @@ static void rvin_capture_on(struct rvin_dev *vin)
 		rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
 }
 
-static void rvin_capture_off(struct rvin_dev *vin)
-{
-	/* Set continuous & single transfer off */
-	rvin_write(vin, 0, VNFC_REG);
-}
-
 static int rvin_capture_start(struct rvin_dev *vin)
 {
 	struct rvin_buffer *buf, *node;
@@ -435,7 +429,8 @@ static int rvin_capture_start(struct rvin_dev *vin)
 
 static void rvin_capture_stop(struct rvin_dev *vin)
 {
-	rvin_capture_off(vin);
+	/* Set continuous & single transfer off */
+	rvin_write(vin, 0, VNFC_REG);
 
 	/* Disable module */
 	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
-- 
2.12.0
