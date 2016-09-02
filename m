Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:32890 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932911AbcIBQqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 12:46:55 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, hans.verkuil@cisco.com
Cc: slongerbeam@gmail.com, lars@metafoo.de, mchehab@kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 2/6] media: rcar-vin: make V4L2_FIELD_INTERLACED standard dependent
Date: Fri,  2 Sep 2016 18:44:57 +0200
Message-Id: <20160902164501.19535-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160902164501.19535-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160902164501.19535-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field V4L2_FIELD_INTERLACED is standard dependent and should not
unconditionally be equivalent to V4L2_FIELD_INTERLACED_TB.

This patch adds a check to see if the video standard can be obtained and
if it's a 60 Hz format. If the condition is met V4L2_FIELD_INTERLACED
is treated as V4L2_FIELD_INTERLACED_BT if not as
V4L2_FIELD_INTERLACED_TB.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 46abdb0..d57801b 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -131,6 +131,7 @@ static u32 rvin_read(struct rvin_dev *vin, u32 offset)
 static int rvin_setup(struct rvin_dev *vin)
 {
 	u32 vnmc, dmr, dmr2, interrupts;
+	v4l2_std_id std;
 	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
 
 	switch (vin->format.field) {
@@ -141,6 +142,14 @@ static int rvin_setup(struct rvin_dev *vin)
 		vnmc = VNMC_IM_EVEN;
 		break;
 	case V4L2_FIELD_INTERLACED:
+		/* Default to TB */
+		vnmc = VNMC_IM_FULL;
+		/* Use BT if video standard can be read and is 60 Hz format */
+		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
+			if (std & V4L2_STD_525_60)
+				vnmc = VNMC_IM_FULL | VNMC_FOC;
+		}
+		break;
 	case V4L2_FIELD_INTERLACED_TB:
 		vnmc = VNMC_IM_FULL;
 		break;
-- 
2.9.3

