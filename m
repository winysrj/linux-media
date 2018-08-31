Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44524 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728760AbeHaSsl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 14:48:41 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 4/6] media: vsp1: Document max_width restriction on SRU
Date: Fri, 31 Aug 2018 15:40:42 +0100
Message-Id: <20180831144044.31713-5-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com>
References: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SRU is currently restricted to 256 pixels as part of the current
partition algorithm. Document that the actual capability of this
component is 288 pixels, but don't increase the implementation.

The extended partition algorithm may later choose to utilise a larger
input to support overlapping partitions.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_sru.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index f277700e5cc2..2a40e09b9aa7 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -314,6 +314,10 @@ static unsigned int sru_max_width(struct vsp1_entity *entity,
 	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
 					    SRU_PAD_SOURCE);
 
+	/*
+	 * The maximum width of the SRU is 288 input pixels, but to support the
+	 * partition algorithm, this is currently kept at 256.
+	 */
 	if (input->width != output->width)
 		return 512;
 	else
-- 
2.17.1
