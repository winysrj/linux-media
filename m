Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40677C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DAE12087C
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfCEN4G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:56:06 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49496 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727720AbfCEN4F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 08:56:05 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id AD593634C7E;
        Tue,  5 Mar 2019 15:55:04 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     akinobu.mita@gmail.com, robert.jarzmik@free.fr, hverkuil@xs4all.nl,
        bparrot@ti.com
Subject: [PATCH 2/4] v4l2-fwnode: The first default data lane is 0 on C-PHY
Date:   Tue,  5 Mar 2019 15:56:00 +0200
Message-Id: <20190305135602.24199-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190305135602.24199-1-sakari.ailus@linux.intel.com>
References: <20190305135602.24199-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

C-PHY has no clock lanes. Therefore the first data lane is 0 by default.

Fixes: edc6d56c2e7e ("media: v4l: fwnode: Support parsing of CSI-2 C-PHY endpoints")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 93d0547779df..6b990c78c73a 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -229,6 +229,10 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 	if (bus_type == V4L2_MBUS_CSI2_DPHY ||
 	    bus_type == V4L2_MBUS_CSI2_CPHY || lanes_used ||
 	    have_clk_lane || (flags & ~V4L2_MBUS_CSI2_CONTINUOUS_CLOCK)) {
+		/* Only D-PHY has a clock lane. */
+		unsigned int dfl_data_lane_index =
+			bus_type == V4L2_MBUS_CSI2_DPHY;
+
 		bus->flags = flags;
 		if (bus_type == V4L2_MBUS_UNKNOWN)
 			vep->bus_type = V4L2_MBUS_CSI2_DPHY;
@@ -237,7 +241,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		if (use_default_lane_mapping) {
 			bus->clock_lane = 0;
 			for (i = 0; i < num_data_lanes; i++)
-				bus->data_lanes[i] = 1 + i;
+				bus->data_lanes[i] = dfl_data_lane_index + i;
 		} else {
 			bus->clock_lane = clock_lane;
 			for (i = 0; i < num_data_lanes; i++)
-- 
2.11.0

