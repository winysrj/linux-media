Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B780CC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 20:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 912DA21738
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 20:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbfA1Uzg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 15:55:36 -0500
Received: from mailoutvs31.siol.net ([185.57.226.222]:41002 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728255AbfA1Uzc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 15:55:32 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Zimbra) with ESMTP id D5BF8521849;
        Mon, 28 Jan 2019 21:55:29 +0100 (CET)
X-Virus-Scanned: amavisd-new at psrvmta12.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta12.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id b5cHkZREIr_o; Mon, 28 Jan 2019 21:55:29 +0100 (CET)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Zimbra) with ESMTPS id 91EED5208E6;
        Mon, 28 Jan 2019 21:55:29 +0100 (CET)
Received: from localhost.localdomain (cpe1-8-82.cable.triera.net [213.161.8.82])
        (Authenticated sender: 031275009)
        by mail.siol.net (Zimbra) with ESMTPSA id 3FE04521E3E;
        Mon, 28 Jan 2019 21:55:27 +0100 (CET)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     maxime.ripard@bootlin.com, wens@csie.org
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 6/6] arm64: dts: allwinner: h6: Add Video Engine node
Date:   Mon, 28 Jan 2019 21:55:04 +0100
Message-Id: <20190128205504.11225-7-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190128205504.11225-1-jernej.skrabec@siol.net>
References: <20190128205504.11225-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This adds the Video engine node for H6. It can use whole DRAM range so
there is no need for reserved memory node.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/bo=
ot/dts/allwinner/sun50i-h6.dtsi
index 247dc0a5ce89..de4b7a1f1012 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -146,6 +146,17 @@
 			};
 		};
=20
+		video-codec@1c0e000 {
+			compatible =3D "allwinner,sun50i-h6-video-engine";
+			reg =3D <0x01c0e000 0x2000>;
+			clocks =3D <&ccu CLK_BUS_VE>, <&ccu CLK_VE>,
+				 <&ccu CLK_MBUS_VE>;
+			clock-names =3D "ahb", "mod", "ram";
+			resets =3D <&ccu RST_BUS_VE>;
+			interrupts =3D <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
+			allwinner,sram =3D <&ve_sram 1>;
+		};
+
 		syscon: syscon@3000000 {
 			compatible =3D "allwinner,sun50i-h6-system-control",
 				     "allwinner,sun50i-a64-system-control";
--=20
2.20.1

