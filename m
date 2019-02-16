Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00ECBC43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 22:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA48C2192D
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 22:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387486AbfBPW6L (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 17:58:11 -0500
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:56737 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727695AbfBPW6L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 17:58:11 -0500
X-Halon-ID: 4eab7ffa-323e-11e9-a58a-005056917f90
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-02.atm.binero.net (Halon) with ESMTPA
        id 4eab7ffa-323e-11e9-a58a-005056917f90;
        Sat, 16 Feb 2019 23:58:07 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-csi2: Allow configuring of video standard
Date:   Sat, 16 Feb 2019 23:57:58 +0100
Message-Id: <20190216225758.7699-1-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Allow the hardware to to do proper field detection for interlaced field
formats by implementing s_std() and g_std(). Depending on which video
standard is selected the driver needs to setup the hardware to correctly
identify fields.

Later versions of the datasheet have also been updated to make it clear
that FLD register should be set to 0 when dealing with none interlaced
field formats.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 33 +++++++++++++++++++--
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index f3099f3e536d808a..664d3784be2b9db9 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -361,6 +361,7 @@ struct rcar_csi2 {
 	struct v4l2_subdev *remote;
 
 	struct v4l2_mbus_framefmt mf;
+	v4l2_std_id std;
 
 	struct mutex lock;
 	int stream_count;
@@ -389,6 +390,22 @@ static void rcsi2_write(struct rcar_csi2 *priv, unsigned int reg, u32 data)
 	iowrite32(data, priv->base + reg);
 }
 
+static int rcsi2_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct rcar_csi2 *priv = sd_to_csi2(sd);
+
+	priv->std = std;
+	return 0;
+}
+
+static int rcsi2_g_std(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	struct rcar_csi2 *priv = sd_to_csi2(sd);
+
+	*std = priv->std;
+	return 0;
+}
+
 static void rcsi2_standby_mode(struct rcar_csi2 *priv, int on)
 {
 	if (!on) {
@@ -475,7 +492,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
 static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 {
 	const struct rcar_csi2_format *format;
-	u32 phycnt, vcdt = 0, vcdt2 = 0;
+	u32 phycnt, vcdt = 0, vcdt2 = 0, fld = 0;
 	unsigned int i;
 	int mbps, ret;
 
@@ -507,6 +524,15 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 			vcdt2 |= vcdt_part << ((i % 2) * 16);
 	}
 
+	if (priv->mf.field != V4L2_FIELD_NONE) {
+		fld =  FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN;
+
+		if (priv->std & V4L2_STD_525_60)
+			fld |= FLD_FLD_NUM(2);
+		else
+			fld |= FLD_FLD_NUM(1);
+	}
+
 	phycnt = PHYCNT_ENABLECLK;
 	phycnt |= (1 << priv->lanes) - 1;
 
@@ -519,8 +545,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 	rcsi2_write(priv, PHTC_REG, 0);
 
 	/* Configure */
-	rcsi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
-		    FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
+	rcsi2_write(priv, FLD_REG, fld);
 	rcsi2_write(priv, VCDT_REG, vcdt);
 	if (vcdt2)
 		rcsi2_write(priv, VCDT2_REG, vcdt2);
@@ -662,6 +687,8 @@ static int rcsi2_get_pad_format(struct v4l2_subdev *sd,
 }
 
 static const struct v4l2_subdev_video_ops rcar_csi2_video_ops = {
+	.s_std = rcsi2_s_std,
+	.g_std = rcsi2_g_std,
 	.s_stream = rcsi2_s_stream,
 };
 
-- 
2.20.1

