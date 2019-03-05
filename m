Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29388C4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04DE4208E4
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfCESwL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:52:11 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:60353 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbfCESwI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:52:08 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 8CB21200013;
        Tue,  5 Mar 2019 18:52:06 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 28/31] adv748x: afe: Implement has_route()
Date:   Tue,  5 Mar 2019 19:51:47 +0100
Message-Id: <20190305185150.20776-29-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now that the adv748x subdevice supports internal routing, add an
has_route() operation used during media graph traversal.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/adv748x/adv748x-afe.c | 26 +++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
index 3f770f71413f..39ac55f0adbb 100644
--- a/drivers/media/i2c/adv748x/adv748x-afe.c
+++ b/drivers/media/i2c/adv748x/adv748x-afe.c
@@ -463,6 +463,30 @@ static const struct v4l2_subdev_ops adv748x_afe_ops = {
 	.pad = &adv748x_afe_pad_ops,
 };
 
+/* -----------------------------------------------------------------------------
+ * media_entity_operations
+ */
+
+static bool adv748x_afe_has_route(struct media_entity *entity,
+				  unsigned int pad0, unsigned int pad1)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
+
+	/* Only consider direct sink->source routes. */
+	if (pad0 > ADV748X_AFE_SINK_AIN7 ||
+	    pad1 != ADV748X_AFE_SOURCE)
+		return false;
+
+	if (pad0 != afe->input)
+		return false;
+
+	return true;
+}
+
+static const struct media_entity_operations adv748x_afe_entity_ops = {
+	.has_route = adv748x_afe_has_route,
+};
 /* -----------------------------------------------------------------------------
  * Controls
  */
@@ -595,6 +619,8 @@ int adv748x_afe_init(struct adv748x_afe *afe)
 
 	afe->pads[ADV748X_AFE_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
 
+	afe->sd.entity.ops = &adv748x_afe_entity_ops;
+
 	ret = media_entity_pads_init(&afe->sd.entity, ADV748X_AFE_NR_PADS,
 			afe->pads);
 	if (ret)
-- 
2.20.1

