Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133B8C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 15:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1F3C2147A
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 15:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548690573;
	bh=JwVKGIIUqqF4B3yc+9c0UvQLqdZqH2Lasggm9SGi/e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JF8ZdTh/2HqlCrXbw2Z1p0Nrr9vn3qqRqCjwYeh9Rpt3MTqvyXZGZ5jurPJ57CPlr
	 1NhgstgHNONCbEmeXWVcbP2copOsp2A5P5Dl85w3GdGfsPFUtrKnw+BhsyPZMyH3Qw
	 Mppg9ctoTlw2duFVvMl443QygE0YhmeA77rYaWk0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbfA1Pt1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:49:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbfA1PtY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 10:49:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DD9B21783;
        Mon, 28 Jan 2019 15:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690564;
        bh=JwVKGIIUqqF4B3yc+9c0UvQLqdZqH2Lasggm9SGi/e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XT1UsiX+uBO2k8q7yZd2qbrIFlRXZUbPR9PG4WZdEpQft+WDNoHcTSVQekrzOgwUp
         yIzwkqK7RXpvuIN9oZm08RVAzmdIjj8d3VaoJuC/fOWVYNP4pCY3eDA9hGtTeSsGg1
         rTaw8PwY6Lwq+QDuRDFpfWwr0W9b+ThfUKWM5X6U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 126/304] media: imx274: select REGMAP_I2C
Date:   Mon, 28 Jan 2019 10:40:43 -0500
Message-Id: <20190128154341.47195-126-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Luca Ceresoli <luca@lucaceresoli.net>

[ Upstream commit 4f9d7225c70dd9d3f406b79e60f8dbd2cd5ae743 ]

The imx274 driver uses regmap and the build will fail without it.

Fixes:

  drivers/media/i2c/imx274.c:142:21: error: variable ‘imx274_regmap_config’ has initializer but incomplete type
   static const struct regmap_config imx274_regmap_config = {
                       ^~~~~~~~~~~~~
  drivers/media/i2c/imx274.c:1869:19: error: implicit declaration of function ‘devm_regmap_init_i2c’ [-Werror=implicit-function-declaration]
    imx274->regmap = devm_regmap_init_i2c(client, &imx274_regmap_config);
                     ^~~~~~~~~~~~~~~~~~~~

and others.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index f4714bd6fef0..421e2fd2481d 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -611,6 +611,7 @@ config VIDEO_IMX274
 	tristate "Sony IMX274 sensor support"
 	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
+	select REGMAP_I2C
 	---help---
 	  This is a V4L2 sensor driver for the Sony IMX274
 	  CMOS image sensor.
-- 
2.19.1

