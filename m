Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE42AC10F0C
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9786218E0
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 15:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfCPPri (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 11:47:38 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:48871 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfCPPrh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 11:47:37 -0400
X-Originating-IP: 2.224.242.101
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 899351BF209;
        Sat, 16 Mar 2019 15:47:34 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dave.stevenson@raspberrypi.org
Subject: [RFC 1/5] v4l: subdev: Add MIPI CSI-2 PHY to frame desc
Date:   Sat, 16 Mar 2019 16:47:57 +0100
Message-Id: <20190316154801.20460-2-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
References: <20190316154801.20460-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add PHY-specific parameters to MIPI CSI-2 frame descriptor.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 include/media/v4l2-subdev.h | 42 +++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 6311f670de3c..eca9633c83bf 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -317,11 +317,33 @@ struct v4l2_subdev_audio_ops {
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
 };
 
+#define V4L2_FRAME_DESC_ENTRY_DPHY_DATA_LANES	4
+
+/**
+ * struct v4l2_mbus_frame_desc_entry_csi2_dphy - MIPI D-PHY bus configuration
+ *
+ * @clock_lane:		physical lane index of the clock lane
+ * @data_lanes:		an array of physical data lane indexes
+ * @num_data_lanes:	number of data lanes
+ */
+struct v4l2_mbus_frame_desc_entry_csi2_dphy {
+	u8 clock_lane;
+	u8 data_lanes[V4L2_FRAME_DESC_ENTRY_DPHY_DATA_LANES];
+	u8 num_data_lanes;
+};
+
+/**
+ * struct v4l2_mbus_frame_desc_entry_csi2_cphy - MIPI C-PHY bus configuration
+ */
+struct v4l2_mbus_frame_desc_entry_csi2_cphy {
+	/* TODO */
+};
+
 /**
  * struct v4l2_mbus_frame_desc_entry_csi2
  *
- * @channel: CSI-2 virtual channel
- * @data_type: CSI-2 data type ID
+ * @channel:	CSI-2 virtual channel
+ * @data_type:	CSI-2 data type ID
  */
 struct v4l2_mbus_frame_desc_entry_csi2 {
 	u8 channel;
@@ -371,18 +393,26 @@ enum v4l2_mbus_frame_desc_type {
 	V4L2_MBUS_FRAME_DESC_TYPE_PLATFORM,
 	V4L2_MBUS_FRAME_DESC_TYPE_PARALLEL,
 	V4L2_MBUS_FRAME_DESC_TYPE_CCP2,
-	V4L2_MBUS_FRAME_DESC_TYPE_CSI2,
+	V4L2_MBUS_FRAME_DESC_TYPE_CSI2_DPHY,
+	V4L2_MBUS_FRAME_DESC_TYPE_CSI2_CPHY,
 };
 
 /**
  * struct v4l2_mbus_frame_desc - media bus data frame description
- * @type: type of the bus (enum v4l2_mbus_frame_desc_type)
- * @entry: frame descriptors array
- * @num_entries: number of entries in @entry array
+ * @type:		type of the bus (enum v4l2_mbus_frame_desc_type)
+ * @entry:		frame descriptors array
+ * @phy:		PHY specific parameters
+ * @phy.dphy:		MIPI D-PHY specific bus configurations
+ * @phy.cphy:		MIPI C-PHY specific bus configurations
+ * @num_entries:	number of entries in @entry array
  */
 struct v4l2_mbus_frame_desc {
 	enum v4l2_mbus_frame_desc_type type;
 	struct v4l2_mbus_frame_desc_entry entry[V4L2_FRAME_DESC_ENTRY_MAX];
+	union {
+		struct v4l2_mbus_frame_desc_entry_csi2_dphy csi2_dphy;
+		struct v4l2_mbus_frame_desc_entry_csi2_cphy csi2_cphy;
+	} phy;
 	unsigned short num_entries;
 };
 
-- 
2.21.0

