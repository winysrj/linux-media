Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44534 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbeHaSsm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 14:48:42 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 5/6] media: vsp1: Document max_width restriction on UDS
Date: Fri, 31 Aug 2018 15:40:43 +0100
Message-Id: <20180831144044.31713-6-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com>
References: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UDS is currently restricted based on a partition size of 256 pixels.
Document the actual restrictions, but don't increase the implementation.

The extended partition algorithm may later choose to utilise a larger
partition size to support overlapping partitions.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_uds.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index c20c84b54936..7c11651db5d4 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -342,6 +342,14 @@ static unsigned int uds_max_width(struct vsp1_entity *entity,
 					    UDS_PAD_SOURCE);
 	hscale = output->width / input->width;
 
+	/*
+	 * The maximum width of the UDS is 304 pixels. These are input pixels
+	 * in the event of up-scaling, and output pixels in the event of
+	 * downscaling.
+	 *
+	 * To support the current parition algorithm, we clamp at units of 256.
+	 */
+
 	if (hscale <= 2)
 		return 256;
 	else if (hscale <= 4)
-- 
2.17.1
