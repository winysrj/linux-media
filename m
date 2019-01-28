Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93F4C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 20:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FD6721738
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 20:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfA1Uz0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 15:55:26 -0500
Received: from mailoutvs7.siol.net ([185.57.226.198]:40955 "EHLO mail.siol.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726719AbfA1Uz0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 15:55:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Zimbra) with ESMTP id C5AE4521E2D;
        Mon, 28 Jan 2019 21:55:22 +0100 (CET)
X-Virus-Scanned: amavisd-new at psrvmta12.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta12.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 5t8Gu2vJ5f1b; Mon, 28 Jan 2019 21:55:22 +0100 (CET)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Zimbra) with ESMTPS id 7E87F521CC1;
        Mon, 28 Jan 2019 21:55:22 +0100 (CET)
Received: from localhost.localdomain (cpe1-8-82.cable.triera.net [213.161.8.82])
        (Authenticated sender: 031275009)
        by mail.siol.net (Zimbra) with ESMTPSA id 27402521E2D;
        Mon, 28 Jan 2019 21:55:20 +0100 (CET)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     maxime.ripard@bootlin.com, wens@csie.org
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 3/6] media: cedrus: Add support for H6
Date:   Mon, 28 Jan 2019 21:55:01 +0100
Message-Id: <20190128205504.11225-4-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190128205504.11225-1-jernej.skrabec@siol.net>
References: <20190128205504.11225-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

H6 has improved VPU. It supports 10-bit HEVC decoding and AFBC output
format for HEVC.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/stagin=
g/media/sunxi/cedrus/cedrus.c
index ff11cbeba205..b98add3cdedd 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -396,6 +396,11 @@ static const struct cedrus_variant sun50i_h5_cedrus_=
variant =3D {
 	.capabilities	=3D CEDRUS_CAPABILITY_UNTILED,
 };
=20
+static const struct cedrus_variant sun50i_h6_cedrus_variant =3D {
+	.capabilities	=3D CEDRUS_CAPABILITY_UNTILED,
+	.quirks		=3D CEDRUS_QUIRK_NO_DMA_OFFSET,
+};
+
 static const struct of_device_id cedrus_dt_match[] =3D {
 	{
 		.compatible =3D "allwinner,sun4i-a10-video-engine",
@@ -425,6 +430,10 @@ static const struct of_device_id cedrus_dt_match[] =3D=
 {
 		.compatible =3D "allwinner,sun50i-h5-video-engine",
 		.data =3D &sun50i_h5_cedrus_variant,
 	},
+	{
+		.compatible =3D "allwinner,sun50i-h6-video-engine",
+		.data =3D &sun50i_h6_cedrus_variant,
+	},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, cedrus_dt_match);
--=20
2.20.1

