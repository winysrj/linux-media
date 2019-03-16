Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C84C4360F
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB94A21903
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfCPPrm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 11:47:42 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:49297 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfCPPrm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 11:47:42 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 807761BF207;
        Sat, 16 Mar 2019 15:47:39 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dave.stevenson@raspberrypi.org
Subject: [RFC 4/5] media: adv748x: Report D-PHY configuration
Date:   Sat, 16 Mar 2019 16:48:00 +0100
Message-Id: <20190316154801.20460-5-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Extend the media bus frame description to report the D-PHY bus
configuration.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-csi2.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
index 13454af72c6e..c733c7ab8247 100644
--- a/drivers/media/i2c/adv748x/adv748x-csi2.c
+++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
@@ -231,8 +231,12 @@ static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
 static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
 				       struct v4l2_mbus_frame_desc *fd)
 {
+	struct v4l2_mbus_frame_desc_entry_csi2_dphy *dphy;
 	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
+	struct v4l2_mbus_frame_desc_entry_csi2 *csi2;
 	struct v4l2_mbus_framefmt *mbusformat;
+	unsigned int i;
+
 
 	memset(fd, 0, sizeof(*fd));
 
@@ -244,13 +248,20 @@ static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
 	if (!mbusformat)
 		return -EINVAL;
 
+	fd->type = V4L2_MBUS_FRAME_DESC_TYPE_CSI2_DPHY;
+	fd->num_entries = 1;
+
 	fd->entry->stream = tx->vc;
-	fd->entry->bus.csi2.channel = tx->vc;
-	fd->entry->bus.csi2.data_type =
-		adv748x_csi2_code_to_datatype(mbusformat->code);
 
-	fd->type = V4L2_MBUS_FRAME_DESC_TYPE_CSI2;
-	fd->num_entries = 1;
+	csi2 = &fd->entry->bus.csi2;
+	csi2->channel = tx->vc;
+	csi2->data_type = adv748x_csi2_code_to_datatype(mbusformat->code);
+
+	dphy = &fd->phy.csi2_dphy;
+	dphy->clock_lane = 0;
+	for (i = 0; i < tx->num_lanes; ++i)
+		dphy->data_lanes[i] = i + 1;
+	dphy->num_data_lanes = tx->num_lanes;
 
 	return 0;
 }
-- 
2.21.0

