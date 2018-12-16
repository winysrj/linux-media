Return-Path: <SRS0=vP0A=OZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26AFC43387
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 04:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7840217F9
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 04:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="BYDDdl+d";
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="BYDDdl+d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbeLPEcX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 23:32:23 -0500
Received: from fallback17.m.smailru.net ([94.100.176.130]:58456 "EHLO
        fallback17.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbeLPEcX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 23:32:23 -0500
X-Greylist: delayed 2579 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Dec 2018 23:32:22 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Message-Id:Date:Subject:Cc:To:From; bh=JwF9oNt0tIcgp145Hbopre5PxQkOawsFzA2WtGbsA5c=;
        b=BYDDdl+dzmTqXuzjoJNleNtTsnJuL56599zvD5eubYBgd2boPRihHgVfapq5CUF32/uVMWIdVyEWWkfIo+QJqVOX3hg9275YCyMW9NYIMjh1ocTT7bHFGVwGCjUUwoLetvkOuPEVifvGPL5haXGwJgoWLSgHr/hIzm0phEzvYlY=;
Received: from [10.161.22.24] (port=36796 helo=smtp54.i.mail.ru)
        by fallback17.m.smailru.net with esmtp (envelope-from <shc_work@mail.ru>)
        id 1gYNQd-0002Ov-QT; Sun, 16 Dec 2018 06:49:20 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Message-Id:Date:Subject:Cc:To:From; bh=JwF9oNt0tIcgp145Hbopre5PxQkOawsFzA2WtGbsA5c=;
        b=BYDDdl+dzmTqXuzjoJNleNtTsnJuL56599zvD5eubYBgd2boPRihHgVfapq5CUF32/uVMWIdVyEWWkfIo+QJqVOX3hg9275YCyMW9NYIMjh1ocTT7bHFGVwGCjUUwoLetvkOuPEVifvGPL5haXGwJgoWLSgHr/hIzm0phEzvYlY=;
Received: by smtp54.i.mail.ru with esmtpa (envelope-from <shc_work@mail.ru>)
        id 1gYNQZ-0001mN-PE; Sun, 16 Dec 2018 06:49:16 +0300
From:   Alexander Shiyan <shc_work@mail.ru>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 3/3] media: mx2-emmaprp: Add DT bindings documentation
Date:   Sun, 16 Dec 2018 06:49:07 +0300
Message-Id: <20181216034907.15787-1-shc_work@mail.ru>
X-Mailer: git-send-email 2.10.2
X-77F55803: 2D1AD755E866B1545A78504BD2AC294197136A761B2823858900181220C4C6DDD69EF584598C1FC98D91412A78A14693
X-7FA49CB5: 0D63561A33F958A5E7F2183B623A7E522651FD9C75AC420D2821199907ED42138941B15DA834481FA18204E546F3947CEDCF5861DED71B2F389733CBF5DBD5E9C8A9BA7A39EFB7666BA297DBC24807EA117882F44604297287769387670735209ECD01F8117BC8BEA471835C12D1D977C4224003CC8364767815B9869FA544D8D32BA5DBAC0009BE9E8FC8737B5C2249E20791DD86E535D73AA81AA40904B5D9CF19DD082D7633A0E7DDDDC251EA7DABD81D268191BDAD3D78DA827A17800CE74AAC223A686B1DECB3661434B16C20ACE7DDDDC251EA7DABAAAE862A0553A39223F8577A6DFFEA7C63AF77305B58AFCD1AD211411A6604EBEFF80C71ABB335746BA297DBC24807EA27F269C8F02392CD20465B3A5AADEC6827F269C8F02392CD5571747095F342E88FB05168BE4CE3AF
X-Mailru-Sender: 139A7956A63CACCF2A18077BC60D2445A07EE83930BFAC2D506D53D2021EB14FA3B68E5AF1B865DF6B3B2BD4812BFD4DC77752E0C033A69E93554C27080790AB3B25A7FBAAF806F0AE208404248635DF
X-Mras: OK
X-77F55803: 5241C2F38277A35D7F9F52485CB584D7271FD7DF62800FDCDF93EE293AD62B9E5D531FBA079A769EA6C9F34278F46BAD6E0ADEE3AC03EF4C
X-7FA49CB5: 0D63561A33F958A585C7B294205859029167B76749033032E67D6E8D2054FDB58941B15DA834481FA18204E546F3947CEDCF5861DED71B2F389733CBF5DBD5E9C8A9BA7A39EFB7666BA297DBC24807EA117882F44604297287769387670735209ECD01F8117BC8BEA471835C12D1D977C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-Mailru-Sender: A5480F10D64C90054EBC784E05B222902C827E82E9A17CDE5D531FBA079A769ED38A1BEA64D5C64A3786569BE0651809D50E20E2BC48EF5AFF3C6AF3E48A3A73EAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: OK
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds DT binding documentation for the Freescale enhanced
Multimedia Accelerator (eMMA) video Pre-processor (PrP).

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 .../devicetree/bindings/media/fsl-emmaprp.txt        | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-emmaprp.txt

diff --git a/Documentation/devicetree/bindings/media/fsl-emmaprp.txt b/Documentation/devicetree/bindings/media/fsl-emmaprp.txt
new file mode 100644
index 0000000..9dd7cc6
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/fsl-emmaprp.txt
@@ -0,0 +1,20 @@
+* Freescale enhanced Multimedia Accelerator (eMMA) video Pre-processor (PrP)
+  for i.MX21 & i.MX27 SoCs.
+
+Required properties:
+- compatible : Shall contain "fsl,imx21-emmaprp" for compatible with
+               the one integrated on i.MX21 SoC.
+- reg        : Offset and length of the register set for the device.
+- interrupts : Should contain eMMA PrP interrupt number.
+- clocks     : Should contain the ahb and ipg clocks, in the order
+               determined by the clock-names property.
+- clock-names: Should be "ahb", "ipg".
+
+Example:
+	emmaprp: emmaprp@10026400 {
+		compatible = "fsl,imx21-emmaprp";
+		reg = <0x10026400 0x100>;
+		interrupts = <51>;
+		clocks = <&clks 49>, <&clks 68>;
+		clock-names = "ipg", "ahb";
+	};
-- 
2.10.2

