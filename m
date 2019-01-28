Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DD3C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A89820989
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548695994;
	bh=7Fc9PSBhWRE5g5NbFR+al31QKQ+KVPSXWmeFL1QFPPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1Y/kapIYRLNYSWD67K0neW5NxpRvb+Eyut9o/V2rluwnwcgnS9FQrv7r9AuroxJHg
	 1mZ/WGnCYUbkCN/6KLezbGRT6uP4r52Ie+KJ/ufiINCSIHWtA65cd2EkoXH0qqXNO+
	 I+Iz7PYET2u/r1QtR8rHk3tGwAtpO4Y//HUvac3U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731814AbfA1RTt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 12:19:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731647AbfA1QEl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 11:04:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 278062175B;
        Mon, 28 Jan 2019 16:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691481;
        bh=7Fc9PSBhWRE5g5NbFR+al31QKQ+KVPSXWmeFL1QFPPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRgmzTiUOfGucID0M6GlClJ00xVED/VWfJHarmdCvp4w5yCy6L9n/4nidQbWmg2Cd
         HC/l/mcCMX+b7yli9iAek0UdkbvSBV//mxYA+jPwSQj3yMnj7wd5AM/fv0h+uDSNSE
         gJAF3jRxugrMabQ43xUGNZO4TaMyYK7dOmkVoC1Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 108/258] media: imx274: select REGMAP_I2C
Date:   Mon, 28 Jan 2019 10:56:54 -0500
Message-Id: <20190128155924.51521-108-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
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
index 041a777dfdee..63c9ac2c6a5f 100644
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

