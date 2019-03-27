Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAEEC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8796D20651
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553711378;
	bh=zgF9y1tCoypZ14Izrz5omj96l3Gbnl0d2io8qPD82bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jFX+vK1nc9JwjgvrXdQqRRIA1pTboKub68esvoZ3VUPYbeheDy6+uMHqML36VwP2C
	 3YAK3MgUhs7eAVtfePRVAEGBsqrwU7JLHdWBVultZXQQcRwGjY45XpydGFx5OXcQWF
	 ZYYfrgAhLXFLFZszOrcJs9WXGrdxluLWrHKI8/w4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391801AbfC0S3P (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404291AbfC0S0U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:26:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B45492063F;
        Wed, 27 Mar 2019 18:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553711179;
        bh=zgF9y1tCoypZ14Izrz5omj96l3Gbnl0d2io8qPD82bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nb38B1AxNjdLCDPiTAX+iuO+7HgjB9lIqEPIuc+iI2MfOSHDE4jg9DzbtouKHxSlQ
         NC9kNvJ/QZx/O6/ULTWFEBhLrOyO0sLXhBfLJGKm97CcWY1DRpdIRmWVN+8/eXSFrq
         MG6zBnviETA+DDIb6ypV1wKhjDZlqmpKkcsQJwlo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 3.18 32/41] media: mt9m111: set initial frame size other than 0x0
Date:   Wed, 27 Mar 2019 14:25:09 -0400
Message-Id: <20190327182518.19394-32-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327182518.19394-1-sashal@kernel.org>
References: <20190327182518.19394-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit 29856308137de1c21eda89411695f4fc6e9780ff ]

This driver sets initial frame width and height to 0x0, which is invalid.
So set it to selection rectangle bounds instead.

This is detected by v4l2-compliance detected.

Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/soc_camera/mt9m111.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index b51e8562e775..1ee437e9cfcb 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -983,6 +983,8 @@ static int mt9m111_probe(struct i2c_client *client,
 	mt9m111->rect.top	= MT9M111_MIN_DARK_ROWS;
 	mt9m111->rect.width	= MT9M111_MAX_WIDTH;
 	mt9m111->rect.height	= MT9M111_MAX_HEIGHT;
+	mt9m111->width		= mt9m111->rect.width;
+	mt9m111->height		= mt9m111->rect.height;
 	mt9m111->fmt		= &mt9m111_colour_fmts[0];
 	mt9m111->lastpage	= -1;
 	mutex_init(&mt9m111->power_lock);
-- 
2.19.1

