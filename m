Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36676 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727628AbeINTln (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 15:41:43 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 2/2] media: vsp1: Document max_width restriction on UDS
Date: Fri, 14 Sep 2018 15:26:52 +0100
Message-Id: <20180914142652.30484-2-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <20180914142652.30484-1-kieran.bingham+renesas@ideasonboard.com>
References: <20180914142652.30484-1-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UDS is currently restricted based on a partition size of 256 pixels.
Document the actual restrictions, but don't increase the implementation.

The extended partition algorithm may later choose to utilise a larger
partition size to support overlapping partitions which will improve the
quality of the output images.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_uds.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 75c613050151..e8340de85813 100644
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
+	 * To support overlapping parition windows we clamp at units of 256 and
+	 * the remaining pixels are reserved.
+	 */
 	if (hscale <= 2)
 		return 256;
 	else if (hscale <= 4)
-- 
2.17.1
