Return-Path: <SRS0=vP0A=OZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759D4C43444
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 03:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4391B217F9
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 03:48:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="reqyMBzI";
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="reqyMBzI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbeLPDs0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 22:48:26 -0500
Received: from fallback16.mail.ru ([94.100.177.128]:42602 "EHLO
        fallback16.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbeLPDs0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 22:48:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=A3UYitkxOc1AeXnoKMOt7vLqS514kPmFwy+OewZP5AQ=;
        b=reqyMBzIuQA4ShuNTDl8BRXi9BP7todTHQVwLIUDMht8H9o8DYMcd7IZVBO1+8w/4e8qxl51hVgl78U0KfTIJx+OCjM6pQ/sy/KI61CHC+VQC/K/KUc9Du3pndgf5gkWyh4MX2qBxrjWBNHoZ8VE1AMMdyfLKIZb8QPZ2HMw+OU=;
Received: from [10.161.16.37] (port=38540 helo=smtp63.i.mail.ru)
        by fallback16.i with esmtp (envelope-from <shc_work@mail.ru>)
        id 1gYNPi-0001sK-F6; Sun, 16 Dec 2018 06:48:22 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=A3UYitkxOc1AeXnoKMOt7vLqS514kPmFwy+OewZP5AQ=;
        b=reqyMBzIuQA4ShuNTDl8BRXi9BP7todTHQVwLIUDMht8H9o8DYMcd7IZVBO1+8w/4e8qxl51hVgl78U0KfTIJx+OCjM6pQ/sy/KI61CHC+VQC/K/KUc9Du3pndgf5gkWyh4MX2qBxrjWBNHoZ8VE1AMMdyfLKIZb8QPZ2HMw+OU=;
Received: by smtp63.i.mail.ru with esmtpa (envelope-from <shc_work@mail.ru>)
        id 1gYNPf-0002bb-HM; Sun, 16 Dec 2018 06:48:19 +0300
From:   Alexander Shiyan <shc_work@mail.ru>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/3] media: mx2-emmaprp: Add devicetree support
Date:   Sun, 16 Dec 2018 06:48:06 +0300
Message-Id: <20181216034806.15725-2-shc_work@mail.ru>
X-Mailer: git-send-email 2.10.2
In-Reply-To: <20181216034806.15725-1-shc_work@mail.ru>
References: <20181216034806.15725-1-shc_work@mail.ru>
X-77F55803: BBE463BEF7A60BD05A78504BD2AC294197136A761B2823856E4FD8BE5E17644F324961CE449CE3D17E75EA35ECFC3A55
X-7FA49CB5: 0D63561A33F958A5B33EE40F71AB94CAC3E62CD38D4A5C7D0DFEAFD5598ED5568941B15DA834481FA18204E546F3947C062BEEFFB5F8EA3EF6B57BC7E64490618DEB871D839B7333395957E7521B51C2545D4CF71C94A83E9FA2833FD35BB23D27C277FBC8AE2E8B2EE5AD8F952D28FBA471835C12D1D977C4224003CC8364767815B9869FA544D8D32BA5DBAC0009BE9E8FC8737B5C22498B372E35CF5A2D2DD32BA5DBAC0009BE395957E7521B51C24DA2F55E57A558BE49FD398EE364050F902A1BE408319B29AD7EC71F1DB88427C4224003CC836476C0CAF46E325F83A522CA9DD8327EE4930A3850AC1BE2E735950005270F12D55F747589E6AAA3516243847C11F186F3C5E7DDDDC251EA7DABCC89B49CDF41148FA8EF81845B15A4842623479134186CDE6BA297DBC24807EABDAD6C7F3747799A
X-Mailru-Sender: 139A7956A63CACCF2A18077BC60D2445AB65DCF4B2AC719125BB5AAB9A18F46B9E6F65F9A82B05AC6B3B2BD4812BFD4DC77752E0C033A69E93554C27080790AB3B25A7FBAAF806F0AE208404248635DF
X-Mras: OK
X-77F55803: 5241C2F38277A35D7F9F52485CB584D7271FD7DF62800FDCA6507021FCE8C27A917600E06F1E0F107B055DA6B3A980655235B1227FBA9399
X-Mras: OK
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds devicetree support for the Freescale enhanced Multimedia
Accelerator (eMMA) video Pre-processor (PrP).

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/mx2_emmaprp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 27b078c..f64c244 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -18,6 +18,7 @@
  */
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -978,11 +979,18 @@ static int emmaprp_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id __maybe_unused emmaprp_dt_ids[] = {
+	{ .compatible = "fsl,imx21-emmaprp", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, emmaprp_dt_ids);
+
 static struct platform_driver emmaprp_pdrv = {
 	.probe		= emmaprp_probe,
 	.remove		= emmaprp_remove,
 	.driver		= {
 		.name	= MEM2MEM_NAME,
+		.of_match_table = of_match_ptr(emmaprp_dt_ids),
 	},
 };
 module_platform_driver(emmaprp_pdrv);
-- 
2.10.2

