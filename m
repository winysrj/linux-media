Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C5DC43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 18:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 779D221917
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 18:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbeLVScN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 13:32:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42517 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391852AbeLVSbG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 13:31:06 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gai0w-0003yb-Hk; Sat, 22 Dec 2018 14:12:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] media: cxd2880-spi: fix two memory leaks of dvb_spi
Date:   Sat, 22 Dec 2018 14:12:26 +0000
Message-Id: <20181222141226.15775-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two return paths that do not kfree dvb_spi. Fix the memory
leaks by returning via the exit label fail_adapter that will free
dvi_spi.

Detected by CoverityScan, CID#1475991 ("Resource Leak")

Fixes: cb496cd472af ("media: cxd2880-spi: Add optional vcc regulator")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/spi/cxd2880-spi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
index d5c433e20d4a..3499c90dc695 100644
--- a/drivers/media/spi/cxd2880-spi.c
+++ b/drivers/media/spi/cxd2880-spi.c
@@ -522,13 +522,15 @@ cxd2880_spi_probe(struct spi_device *spi)
 
 	dvb_spi->vcc_supply = devm_regulator_get_optional(&spi->dev, "vcc");
 	if (IS_ERR(dvb_spi->vcc_supply)) {
-		if (PTR_ERR(dvb_spi->vcc_supply) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
+		if (PTR_ERR(dvb_spi->vcc_supply) == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto fail_adapter;
+		}
 		dvb_spi->vcc_supply = NULL;
 	} else {
 		ret = regulator_enable(dvb_spi->vcc_supply);
-		if (ret)
-			return ret;
+		if (ret)
+			goto fail_adapter;
 	}
 
 	dvb_spi->spi = spi;
-- 
2.19.1

