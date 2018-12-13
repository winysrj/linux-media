Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C28C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 20:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 990082086D
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 20:32:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 990082086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbeLMUcL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 15:32:11 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36644 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726764AbeLMUcL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 15:32:11 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id E759F634C7D;
        Thu, 13 Dec 2018 22:31:53 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     petrcvekcz@gmail.com
Cc:     linux-media@vger.kernel.org
Subject: [PATCH 1/1] ov9640: Wrap long and unwrap short lines, align wrapped lines correctly
Date:   Thu, 13 Dec 2018 22:32:09 +0200
Message-Id: <20181213203209.17876-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some little style fixup work.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov9640.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
index c183273fd332..295dcc5992c9 100644
--- a/drivers/media/i2c/ov9640.c
+++ b/drivers/media/i2c/ov9640.c
@@ -271,19 +271,20 @@ static int ov9640_s_stream(struct v4l2_subdev *sd, int enable)
 /* Set status of additional camera capabilities */
 static int ov9640_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct ov9640_priv *priv = container_of(ctrl->handler, struct ov9640_priv, hdl);
+	struct ov9640_priv *priv = container_of(ctrl->handler,
+						struct ov9640_priv, hdl);
 	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
 		if (ctrl->val)
 			return ov9640_reg_rmw(client, OV9640_MVFP,
-							OV9640_MVFP_V, 0);
+					      OV9640_MVFP_V, 0);
 		return ov9640_reg_rmw(client, OV9640_MVFP, 0, OV9640_MVFP_V);
 	case V4L2_CID_HFLIP:
 		if (ctrl->val)
 			return ov9640_reg_rmw(client, OV9640_MVFP,
-							OV9640_MVFP_H, 0);
+					      OV9640_MVFP_H, 0);
 		return ov9640_reg_rmw(client, OV9640_MVFP, 0, OV9640_MVFP_H);
 	}
 
@@ -471,7 +472,7 @@ static int ov9640_write_regs(struct i2c_client *client, u32 width,
 	/* write color matrix configuration into the module */
 	for (i = 0; i < matrix_regs_len; i++) {
 		ret = ov9640_reg_write(client, matrix_regs[i].reg,
-						matrix_regs[i].val);
+				       matrix_regs[i].val);
 		if (ret)
 			return ret;
 	}
@@ -487,7 +488,7 @@ static int ov9640_prog_dflt(struct i2c_client *client)
 
 	for (i = 0; i < ARRAY_SIZE(ov9640_regs_dflt); i++) {
 		ret = ov9640_reg_write(client, ov9640_regs_dflt[i].reg,
-						ov9640_regs_dflt[i].val);
+				       ov9640_regs_dflt[i].val);
 		if (ret)
 			return ret;
 	}
-- 
2.11.0

