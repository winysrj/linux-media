Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FD1C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E9A321019
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfCESv7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:51:59 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:51673 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfCESv7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:51:59 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 2F35F20000D;
        Tue,  5 Mar 2019 18:51:57 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 21/31] v4l: subdev: Improve link format validation debug messages
Date:   Tue,  5 Mar 2019 19:51:40 +0100
Message-Id: <20190305185150.20776-22-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The existing link format validation failure debug message in media-entity.c
helped to poinpoint the point of failure but provided no additional
information what's wrong. Tell the user exactly why the validation failed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 40 ++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 9b4f3528a4da..6c96d6f4bdfc 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -629,21 +629,47 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
 				      struct v4l2_subdev_format *source_fmt,
 				      struct v4l2_subdev_format *sink_fmt)
 {
+	bool pass = true;
+
 	/* The width, height and code must match. */
-	if (source_fmt->format.width != sink_fmt->format.width
-	    || source_fmt->format.height != sink_fmt->format.height
-	    || source_fmt->format.code != sink_fmt->format.code)
-		return -EPIPE;
+	if (source_fmt->format.width != sink_fmt->format.width) {
+		dev_dbg(sd->entity.graph_obj.mdev->dev,
+			"%s: width does not match (source %u, sink %u)\n",
+			__func__,
+			source_fmt->format.width, sink_fmt->format.width);
+		pass = false;
+	}
+
+	if (source_fmt->format.height != sink_fmt->format.height) {
+		dev_dbg(sd->entity.graph_obj.mdev->dev,
+			"%s: height does not match (source %u, sink %u)\n",
+			__func__,
+			source_fmt->format.height, sink_fmt->format.height);
+		pass = false;
+	}
+
+	if (source_fmt->format.code != sink_fmt->format.code) {
+		dev_dbg(sd->entity.graph_obj.mdev->dev,
+			"%s: media bus code does not match (source 0x%8.8x, sink 0x%8.8x)\n",
+			__func__,
+			source_fmt->format.code, sink_fmt->format.code);
+		pass = false;
+	}
 
 	/* The field order must match, or the sink field order must be NONE
 	 * to support interlaced hardware connected to bridges that support
 	 * progressive formats only.
 	 */
 	if (source_fmt->format.field != sink_fmt->format.field &&
-	    sink_fmt->format.field != V4L2_FIELD_NONE)
-		return -EPIPE;
+	    sink_fmt->format.field != V4L2_FIELD_NONE) {
+		dev_dbg(sd->entity.graph_obj.mdev->dev,
+			"%s: field does not match (source %u, sink %u)\n",
+			__func__,
+			source_fmt->format.field, sink_fmt->format.field);
+		pass = false;
+	}
 
-	return 0;
+	return pass ? 0 : -EPIPE;
 }
 EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate_default);
 
-- 
2.20.1

