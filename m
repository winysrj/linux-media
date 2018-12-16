Return-Path: <SRS0=vP0A=OZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27723C43387
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 03:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2A21217F9
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 03:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="ZwUA3n5e";
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="ZwUA3n5e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbeLPDsY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 22:48:24 -0500
Received: from fallback14.mail.ru ([94.100.179.44]:52234 "EHLO
        fallback14.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbeLPDsY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 22:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Message-Id:Date:Subject:Cc:To:From; bh=gftsyQ2R+KBDQ+x8jDpD4TH212nxWiU9rRYsoyLKsmU=;
        b=ZwUA3n5emH36HJq85qEe1C+NNso37ONDeokHJds5TCl1whcXstENhR0WMfkClIoUrf0tzqsPMqXoNGzRpOM5kwcSREJyExntfyetHOITryDNRpDfnxXlxbGUUmGwNATqaI2Dz+B7KGlZ/N+CEiOCbsqr16l0qn33ExDKTTqODmc=;
Received: from [10.161.16.37] (port=37138 helo=smtp63.i.mail.ru)
        by fallback14.m.smailru.net with esmtp (envelope-from <shc_work@mail.ru>)
        id 1gYNPh-0004vb-1f; Sun, 16 Dec 2018 06:48:21 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Message-Id:Date:Subject:Cc:To:From; bh=gftsyQ2R+KBDQ+x8jDpD4TH212nxWiU9rRYsoyLKsmU=;
        b=ZwUA3n5emH36HJq85qEe1C+NNso37ONDeokHJds5TCl1whcXstENhR0WMfkClIoUrf0tzqsPMqXoNGzRpOM5kwcSREJyExntfyetHOITryDNRpDfnxXlxbGUUmGwNATqaI2Dz+B7KGlZ/N+CEiOCbsqr16l0qn33ExDKTTqODmc=;
Received: by smtp63.i.mail.ru with esmtpa (envelope-from <shc_work@mail.ru>)
        id 1gYNPc-0002bb-Hf; Sun, 16 Dec 2018 06:48:16 +0300
From:   Alexander Shiyan <shc_work@mail.ru>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 1/3] media: mx2-emmaprp: Allow MX2-EMMA driver support to be selected with i.MX21
Date:   Sun, 16 Dec 2018 06:48:05 +0300
Message-Id: <20181216034806.15725-1-shc_work@mail.ru>
X-Mailer: git-send-email 2.10.2
X-77F55803: 0014004E1F3277295A78504BD2AC294197136A761B282385B9B98E2FD66E92FE1838A96A3A024F2617628D08CC09AA7B
X-7FA49CB5: 0D63561A33F958A55D673F8A961D9B59C3E62CD38D4A5C7D003E038C8C9C277B8941B15DA834481FA18204E546F3947C989FD0BDF65E50FBF6B57BC7E64490618DEB871D839B7333395957E7521B51C2545D4CF71C94A83E9FA2833FD35BB23D27C277FBC8AE2E8B60CDF180582EB8FBA471835C12D1D977C4224003CC8364767815B9869FA544D8D32BA5DBAC0009BE9E8FC8737B5C224999B836357A5F2ED63AA81AA40904B5D9CF19DD082D7633A0E7DDDDC251EA7DABD81D268191BDAD3D78DA827A17800CE769E77FCA7B33833FCD04E86FAF290E2D40A5AABA2AD3711975ECD9A6C639B01B78DA827A17800CE75F16DD24759F3265CE25194983F1B41975ECD9A6C639B01B4E70A05D1297E1BBC6867C52282FAC85D9B7C4F32B44FF57285124B2A10EEC6C00306258E7E6ABB4E4A6367B16DE6309
X-Mailru-Sender: 139A7956A63CACCF2A18077BC60D2445AB65DCF4B2AC7191ACAFD47EC69DDCFB90E94CAB5E3025426B3B2BD4812BFD4DC77752E0C033A69E93554C27080790AB3B25A7FBAAF806F0AE208404248635DF
X-Mras: OK
X-77F55803: E8DB3678F13EF3E07F9F52485CB584D7271FD7DF62800FDC81CE5504FE04EBD5FD3D2D24B84DB68B58DC1D89F078313698F4DF7B516B59E8
X-7FA49CB5: 0D63561A33F958A52A16F943780225FD08AD98B1450FAB782991B2708EF72B708941B15DA834481FA18204E546F3947CB861051D4BA689FCF6B57BC7E64490618DEB871D839B7333395957E7521B51C2545D4CF71C94A83E9FA2833FD35BB23D27C277FBC8AE2E8B3A703B70628EAD7BA471835C12D1D977C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-Mailru-Sender: A5480F10D64C90059D04A353E0DED3E62848BB00D06FED5EFD3D2D24B84DB68BC479C2914A57FB1F3786569BE0651809D50E20E2BC48EF5AFF3C6AF3E48A3A73EAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: OK
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Freescale i.MX21 chip has enhanced Multimedia Accelerator (eMMA)
video Pre-processor (PrP) unit. This patch allows MX2-EMMA support
to be selected for this SoC.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 70c4f6c..fb70d21 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -293,7 +293,7 @@ config VIDEO_SAMSUNG_S5P_MFC
 config VIDEO_MX2_EMMAPRP
 	tristate "MX2 eMMa-PrP support"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on SOC_IMX27 || COMPILE_TEST
+	depends on SOC_IMX21 || SOC_IMX27 || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
-- 
2.10.2

