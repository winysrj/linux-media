Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25801C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 16:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF85020892
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 16:14:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF85020892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbeLEQOZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 11:14:25 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59103 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727679AbeLEQOZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 11:14:25 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7] helo=dude.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gUZoe-0004HI-7H; Wed, 05 Dec 2018 17:14:24 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v3 2/2] media: imx: ask source subdevice for number of active data lanes
Date:   Wed,  5 Dec 2018 17:14:14 +0100
Message-Id: <20181205161414.29812-2-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181205161414.29812-1-p.zabel@pengutronix.de>
References: <20181205161414.29812-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Temporarily use g_mbus_config() to determine the number of active data
lanes used by the transmitter. If g_mbus_config is not supported or
does not return the number of active lines, default to using all
connected data lines.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
Changes since v2 [1]:
 - Rebased onto media/master

[1] https://patchwork.kernel.org/patch/9964151/
---
 drivers/staging/media/imx/imx6-mipi-csi2.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index 6a1cee55a49b..ae91f0d138f3 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -135,10 +135,8 @@ static void csi2_enable(struct csi2_dev *csi2, bool enable)
 	}
 }
 
-static void csi2_set_lanes(struct csi2_dev *csi2)
+static void csi2_set_lanes(struct csi2_dev *csi2, int lanes)
 {
-	int lanes = csi2->bus.num_data_lanes;
-
 	writel(lanes - 1, csi2->base + CSI2_N_LANES);
 }
 
@@ -301,6 +299,9 @@ static void csi2ipu_gasket_init(struct csi2_dev *csi2)
 
 static int csi2_start(struct csi2_dev *csi2)
 {
+	const u32 mask = V4L2_MBUS_CSI2_LANE_MASK;
+	struct v4l2_mbus_config cfg;
+	int lanes = 0;
 	int ret;
 
 	ret = clk_prepare_enable(csi2->pix_clk);
@@ -316,7 +317,10 @@ static int csi2_start(struct csi2_dev *csi2)
 		goto err_disable_clk;
 
 	/* Step 4 */
-	csi2_set_lanes(csi2);
+	ret = v4l2_subdev_call(csi2->src_sd, video, g_mbus_config, &cfg);
+	if (ret == 0)
+		lanes = (cfg.flags & mask) >> __ffs(mask);
+	csi2_set_lanes(csi2, lanes ?: csi2->bus.num_data_lanes);
 	csi2_enable(csi2, true);
 
 	/* Step 5 */
-- 
2.19.1

