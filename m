Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2990C00319
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BB4121019
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfCESwN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:52:13 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:41293 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbfCESwL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:52:11 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 29791200007;
        Tue,  5 Mar 2019 18:52:08 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 30/31] rcar-csi2: expose the subdevice internal routing
Date:   Tue,  5 Mar 2019 19:51:49 +0100
Message-Id: <20190305185150.20776-31-jacopo+renesas@jmondi.org>
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

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Expose the subdevice internal routing from the single multiplexed sink
pad to its source pads by implementing .get_routing(). This information
is used to do link validation at stream start and allows user-space to
view the route configuration.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 53 +++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index f9cc99ba00bc..cc7077b40f18 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -341,6 +341,14 @@ static int rcsi2_pad_to_vc(unsigned int pad)
 	return pad - RCAR_CSI2_SOURCE_VC0;
 }
 
+static int rcsi2_vc_to_pad(unsigned int vc)
+{
+	if (vc > 3)
+		return -EINVAL;
+
+	return vc + RCAR_CSI2_SOURCE_VC0;
+}
+
 struct rcar_csi2_info {
 	int (*init_phtw)(struct rcar_csi2 *priv, unsigned int mbps);
 	int (*confirm_start)(struct rcar_csi2 *priv);
@@ -705,9 +713,54 @@ static const struct v4l2_subdev_video_ops rcar_csi2_video_ops = {
 	.s_stream = rcsi2_s_stream,
 };
 
+static int rcsi2_get_routing(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_krouting *routing)
+{
+	struct v4l2_subdev_route *r = routing->routes;
+	struct rcar_csi2 *priv = sd_to_csi2(sd);
+	struct v4l2_mbus_frame_desc fd;
+	unsigned int i;
+	int ret;
+
+	/* Get information about multiplexed link */
+	ret = rcsi2_get_remote_frame_desc(priv, &fd);
+	if (ret)
+		return ret;
+
+	if (routing->num_routes < fd.num_entries) {
+		routing->num_routes = fd.num_entries;
+		return -ENOSPC;
+	}
+
+	routing->num_routes = fd.num_entries;
+
+	for (i = 0; i < fd.num_entries; i++) {
+		struct v4l2_mbus_frame_desc_entry *entry = &fd.entry[i];
+		int source_pad;
+
+		source_pad = rcsi2_vc_to_pad(entry->bus.csi2.channel);
+		if (source_pad < 0) {
+			dev_err(priv->dev, "Virtual Channel out of range: %u\n",
+				entry->bus.csi2.channel);
+			return -EINVAL;
+		}
+
+		r->sink_pad = RCAR_CSI2_SINK;
+		r->sink_stream = entry->stream;
+		r->source_pad = source_pad;
+		r->source_stream = 0;
+		r->flags = V4L2_SUBDEV_ROUTE_FL_ACTIVE |
+			   V4L2_SUBDEV_ROUTE_FL_IMMUTABLE;
+		r++;
+	}
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops rcar_csi2_pad_ops = {
 	.set_fmt = rcsi2_set_pad_format,
 	.get_fmt = rcsi2_get_pad_format,
+	.get_routing = rcsi2_get_routing,
 };
 
 static const struct v4l2_subdev_ops rcar_csi2_subdev_ops = {
-- 
2.20.1

