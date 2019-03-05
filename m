Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBDDFC00319
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96CF4213A2
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbfCESwP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:52:15 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:49199 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbfCESwM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:52:12 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 6F315200010;
        Tue,  5 Mar 2019 18:52:10 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 31/31] media: rcar-csi2: Implement has_route()
Date:   Tue,  5 Mar 2019 19:51:50 +0100
Message-Id: <20190305185150.20776-32-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now that the rcar-csi2 subdevice supports internal routing, add an
has_route() operation used during graph traversal.

The internal routing between the sink and the source pads depends on the
virtual channel used to transmit the video stream from the remote
subdevice to the R-Car CSI-2 receiver.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 35 +++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index cc7077b40f18..6c46bcc0ee83 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -1028,7 +1028,42 @@ static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
  * Platform Device Driver.
  */
 
+static bool rcar_csi2_has_route(struct media_entity *entity,
+				unsigned int pad0, unsigned int pad1)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct rcar_csi2 *priv = sd_to_csi2(sd);
+	struct v4l2_mbus_frame_desc fd;
+	unsigned int i;
+	int ret;
+
+	/* Support only direct sink->source routes. */
+	if (pad0 != RCAR_CSI2_SINK)
+		return false;
+
+	/* Get the frame description: from CSI-2 VC to source pad number. */
+	ret = rcsi2_get_remote_frame_desc(priv, &fd);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < fd.num_entries; i++) {
+		struct v4l2_mbus_frame_desc_entry *entry = &fd.entry[i];
+		int source_pad = rcsi2_vc_to_pad(entry->bus.csi2.channel);
+		if (source_pad < 0) {
+			dev_err(priv->dev, "Virtual Channel out of range: %u\n",
+				entry->bus.csi2.channel);
+			return -EINVAL;
+		}
+
+		if (source_pad == pad1)
+			return true;
+	}
+
+	return false;
+}
+
 static const struct media_entity_operations rcar_csi2_entity_ops = {
+	.has_route = rcar_csi2_has_route,
 	.link_validate = v4l2_subdev_link_validate,
 };
 
-- 
2.20.1

