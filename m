Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6F1C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E65EF205C9
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553712461;
	bh=5ajKLTLFNg5YW71NpkUMr/xOEwbOtIt9ISp001EicTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Q4LftIIy7v10XblknaapXfS5grPIBtUE0vTY3n8xgmkHLobcREH+GjStNO3XrlsV1
	 D4LsPjk/gN2Z3eva9upERP6o/Kgl+QasTgMyw/NY4SU2NCQ/L1J5wWrGuYowPt6KwG
	 RTGykYUxgo1LsilowCERjc9iUCep+Cexcp53X7+I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390766AbfC0STs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390238AbfC0STs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:19:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36B1520449;
        Wed, 27 Mar 2019 18:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710787;
        bh=5ajKLTLFNg5YW71NpkUMr/xOEwbOtIt9ISp001EicTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsEkKZpGA2z8pccXKR+7F56f9QnI6McShQbmm3QaGKsxfKDy/oma+jSfTz7n27Edb
         DiRdjc/vmtmk56s7p133eD3pmklQPe9oth5WWLpNCxGjcEI4t3j5R5fTULqqf3gs0S
         KVjUZZ31JfE0DrEoRlU0bde7pVcGHlt5jUaIG1zo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 100/123] media: mt9m111: set initial frame size other than 0x0
Date:   Wed, 27 Mar 2019 14:16:04 -0400
Message-Id: <20190327181628.15899-100-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181628.15899-1-sashal@kernel.org>
References: <20190327181628.15899-1-sashal@kernel.org>
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
 drivers/media/i2c/mt9m111.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 99b992e46702..5b10f74fcc32 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -974,6 +974,8 @@ static int mt9m111_probe(struct i2c_client *client,
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

