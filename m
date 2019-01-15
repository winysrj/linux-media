Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F119C43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 064AA2085A
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfAOIzL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:55:11 -0500
Received: from shell.v3.sk ([90.176.6.54]:51314 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728485AbfAOIzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 03:55:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 009F54CC77;
        Tue, 15 Jan 2019 09:55:07 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 1KG_Izkue9Y3; Tue, 15 Jan 2019 09:55:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 696C94CA17;
        Tue, 15 Jan 2019 09:54:56 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id b2Og-Jmwq3mc; Tue, 15 Jan 2019 09:54:54 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 98BDC4CC56;
        Tue, 15 Jan 2019 09:54:53 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH v4 5/5] media: ov7670: split register setting from set_framerate() logic
Date:   Tue, 15 Jan 2019 09:54:48 +0100
Message-Id: <20190115085448.1400135-6-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190115085448.1400135-1-lkundrak@v3.sk>
References: <20190115085448.1400135-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This will allow us to restore the last set frame rate after the device
returns from a power off.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/i2c/ov7670.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index d0f40d5f6ca0..6f9a53d4dcfc 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -812,13 +812,24 @@ static void ov7675_get_framerate(struct v4l2_subdev=
 *sd,
 			(4 * clkrc);
 }
=20
+static int ov7675_apply_framerate(struct v4l2_subdev *sd)
+{
+	struct ov7670_info *info =3D to_state(sd);
+	int ret;
+
+	ret =3D ov7670_write(sd, REG_CLKRC, info->clkrc);
+	if (ret < 0)
+		return ret;
+
+	return ov7670_write(sd, REG_DBLV, info->pll_bypass ? DBLV_BYPASS : DBLV=
_X4);
+}
+
 static int ov7675_set_framerate(struct v4l2_subdev *sd,
 				 struct v4l2_fract *tpf)
 {
 	struct ov7670_info *info =3D to_state(sd);
 	u32 clkrc;
 	int pll_factor;
-	int ret;
=20
 	/*
 	 * The formula is fps =3D 5/4*pixclk for YUV/RGB and
@@ -827,19 +838,10 @@ static int ov7675_set_framerate(struct v4l2_subdev =
*sd,
 	 * pixclk =3D clock_speed / (clkrc + 1) * PLLfactor
 	 *
 	 */
-	if (info->pll_bypass) {
-		pll_factor =3D 1;
-		ret =3D ov7670_write(sd, REG_DBLV, DBLV_BYPASS);
-	} else {
-		pll_factor =3D PLL_FACTOR;
-		ret =3D ov7670_write(sd, REG_DBLV, DBLV_X4);
-	}
-	if (ret < 0)
-		return ret;
-
 	if (tpf->numerator =3D=3D 0 || tpf->denominator =3D=3D 0) {
 		clkrc =3D 0;
 	} else {
+		pll_factor =3D info->pll_bypass ? 1 : PLL_FACTOR;
 		clkrc =3D (5 * pll_factor * info->clock_speed * tpf->numerator) /
 			(4 * tpf->denominator);
 		if (info->fmt->mbus_code =3D=3D MEDIA_BUS_FMT_SBGGR8_1X8)
@@ -861,7 +863,7 @@ static int ov7675_set_framerate(struct v4l2_subdev *s=
d,
 	/* Recalculate frame rate */
 	ov7675_get_framerate(sd, tpf);
=20
-	return ov7670_write(sd, REG_CLKRC, info->clkrc);
+	return ov7675_apply_framerate(sd);
 }
=20
 static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,
--=20
2.20.1

