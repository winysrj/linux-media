Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:23771 "EHLO
        bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932856AbeCJAKx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 19:10:53 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 1/3] rcar-vin: remove duplicated check of state in irq handler
Date: Sat, 10 Mar 2018 01:09:51 +0100
Message-Id: <20180310000953.25366-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an error from when the driver where converted from soc-camera.
There is absolutely no gain to check the state variable two times to be
extra sure if the hardware is stopped.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 23fdff7a7370842e..b4be75d5009080f7 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -916,12 +916,6 @@ static irqreturn_t rvin_irq(int irq, void *data)
 	rvin_ack_interrupt(vin);
 	handled = 1;
 
-	/* Nothing to do if capture status is 'STOPPED' */
-	if (vin->state == STOPPED) {
-		vin_dbg(vin, "IRQ while state stopped\n");
-		goto done;
-	}
-
 	/* Nothing to do if capture status is 'STOPPING' */
 	if (vin->state == STOPPING) {
 		vin_dbg(vin, "IRQ while state stopping\n");
-- 
2.16.2
