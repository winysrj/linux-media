Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36668 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbeINTlm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 15:41:42 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 1/2] media: vsp1: Document max_width restriction on SRU
Date: Fri, 14 Sep 2018 15:26:51 +0100
Message-Id: <20180914142652.30484-1-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SRU is currently restricted to 256 pixels as part of the current
partition algorithm. Document that the actual capability of this
component is 288 pixels, but don't increase the implementation.

The extended partition algorithm may later choose to utilise a larger
input to support overlapping partitions which will improve the quality
of the output images.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_sru.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index d216707f64c9..19f91eb81134 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -314,6 +314,11 @@ static unsigned int sru_max_width(struct vsp1_entity *entity,
 	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
 					    SRU_PAD_SOURCE);
 
+	/*
+	 * The maximum input width of the SRU is 288 input pixels, but 32
+	 * pixels are reserved to support overlapping partition windows when
+	 * scaling.
+	 */
 	if (input->width != output->width)
 		return 512;
 	else
-- 
2.17.1
