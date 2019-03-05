Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B3DC00319
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1132B208E4
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfCEN4G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:56:06 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49484 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727573AbfCEN4F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 08:56:05 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 94FA9634C7D;
        Tue,  5 Mar 2019 15:55:04 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     akinobu.mita@gmail.com, robert.jarzmik@free.fr, hverkuil@xs4all.nl,
        bparrot@ti.com
Subject: [PATCH 1/4] v4l2-fwnode: Defaults may not override endpoint configuration in firmware
Date:   Tue,  5 Mar 2019 15:55:59 +0200
Message-Id: <20190305135602.24199-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190305135602.24199-1-sakari.ailus@linux.intel.com>
References: <20190305135602.24199-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The lack of defaults provided by the caller to
v4l2_fwnode_endpoint_parse() signals the use of the default lane mapping.
The default lane mapping must not be used however if the firmmare contains
the lane mapping. Disable the default lane mapping in that case, and
improve the debug messages telling of the use of the defaults.

This was missed previously since the default mapping will only unsed in
this case if the bus type is set, and no driver did both while still
needing the lane mapping configuration.

Fixes: b4357d21d674 ("media: v4l: fwnode: Support default CSI-2 lane mapping for drivers")

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 9bfedd7596a1..93d0547779df 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -163,7 +163,7 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 		}
 
 		if (use_default_lane_mapping)
-			pr_debug("using default lane mapping\n");
+			pr_debug("no lane mapping given, using defaults\n");
 	}
 
 	rval = fwnode_property_read_u32_array(fwnode, "data-lanes", NULL, 0);
@@ -175,6 +175,10 @@ static int v4l2_fwnode_endpoint_parse_csi2_bus(struct fwnode_handle *fwnode,
 					       num_data_lanes);
 
 		have_data_lanes = true;
+		if (use_default_lane_mapping) {
+			pr_debug("data-lanes property exists; disabling default mapping\n");
+			use_default_lane_mapping = false;
+		}
 	}
 
 	for (i = 0; i < num_data_lanes; i++) {
-- 
2.11.0

