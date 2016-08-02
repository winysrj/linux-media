Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:52960 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964968AbcHBOvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 10:51:33 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 1/7] media: rcar-vin: make V4L2_FIELD_INTERLACED standard dependent
Date: Tue,  2 Aug 2016 16:51:01 +0200
Message-Id: <20160802145107.24829-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field V4L2_FIELD_INTERLACED is standard dependent and should not
unconditionally be equivalent to V4L2_FIELD_INTERLACED_TB.

This patch adds a check to see if the video standard can be obtained and
if it's a 60 Hz format. If the condition is meet V4L2_FIELD_INTERLACED
is treated as V4L2_FIELD_INTERLACED_BT if not as
V4L2_FIELD_INTERLACED_TB.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 496aa97..4063775 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -131,6 +131,7 @@ static u32 rvin_read(struct rvin_dev *vin, u32 offset)
 static int rvin_setup(struct rvin_dev *vin)
 {
 	u32 vnmc, dmr, dmr2, interrupts;
+	v4l2_std_id std;
 	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
 
 	switch (vin->format.field) {
@@ -141,6 +142,13 @@ static int rvin_setup(struct rvin_dev *vin)
 		vnmc = VNMC_IM_EVEN;
 		break;
 	case V4L2_FIELD_INTERLACED:
+		/* Default to TB */
+		vnmc = VNMC_IM_FULL;
+		/* Use BT if video standard can be read and is 60 Hz format */
+		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std))
+			if (std & V4L2_STD_525_60)
+				vnmc = VNMC_IM_FULL | VNMC_FOC;
+		break;
 	case V4L2_FIELD_INTERLACED_TB:
 		vnmc = VNMC_IM_FULL;
 		break;
-- 
2.9.0

