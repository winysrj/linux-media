Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E76C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 20:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC8BC21738
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 20:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfA1Uzb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 15:55:31 -0500
Received: from mailoutvs17.siol.net ([185.57.226.208]:40987 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728163AbfA1Uz3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 15:55:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Zimbra) with ESMTP id 7A8D9521E32;
        Mon, 28 Jan 2019 21:55:27 +0100 (CET)
X-Virus-Scanned: amavisd-new at psrvmta12.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta12.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id hYpPXAz6FDAz; Mon, 28 Jan 2019 21:55:27 +0100 (CET)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Zimbra) with ESMTPS id 394D1521CC1;
        Mon, 28 Jan 2019 21:55:27 +0100 (CET)
Received: from localhost.localdomain (cpe1-8-82.cable.triera.net [213.161.8.82])
        (Authenticated sender: 031275009)
        by mail.siol.net (Zimbra) with ESMTPSA id DD9CE521E32;
        Mon, 28 Jan 2019 21:55:24 +0100 (CET)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     maxime.ripard@bootlin.com, wens@csie.org
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 5/6] arm64: dts: allwinner: h6: Add support for the SRAM C1 section
Date:   Mon, 28 Jan 2019 21:55:03 +0100
Message-Id: <20190128205504.11225-6-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190128205504.11225-1-jernej.skrabec@siol.net>
References: <20190128205504.11225-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add a node for H6 SRAM C1 section.

Manual calls it VE SRAM, but for consistency with older SoCs, SRAM C1
name is used.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/bo=
ot/dts/allwinner/sun50i-h6.dtsi
index d93a7add67e7..247dc0a5ce89 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -167,6 +167,20 @@
 					reg =3D <0x0000 0x1e000>;
 				};
 			};
+
+			sram_c1: sram@1a00000 {
+				compatible =3D "mmio-sram";
+				reg =3D <0x01a00000 0x200000>;
+				#address-cells =3D <1>;
+				#size-cells =3D <1>;
+				ranges =3D <0 0x01a00000 0x200000>;
+
+				ve_sram: sram-section@0 {
+					compatible =3D "allwinner,sun50i-h6-sram-c1",
+						     "allwinner,sun4i-a10-sram-c1";
+					reg =3D <0x000000 0x200000>;
+				};
+			};
 		};
=20
 		ccu: clock@3001000 {
--=20
2.20.1

