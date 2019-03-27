Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D7BC10F00
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 965CA21738
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 19:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553714698;
	bh=zuvBSIuz23CI0czPNPfY7zqWKOEeMKbbX79+///fBqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yCt/yKsBkTJb/z32fHObylkO1EIsC9i6L83ehxV7slkOGjmaipCK1BpGrDT4oJdlk
	 2W7Ou1l3jXU3qpA6/iczTTThjALQZanPxW6oKgNiyHA2USPUBOfukj1iL5hsrF2d8N
	 bsqPaX7NBnKGmgjb0KaNwOmqThFhDpvt95avxFbw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387841AbfC0TYw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 15:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732477AbfC0SFd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:05:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEF7021734;
        Wed, 27 Mar 2019 18:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709932;
        bh=zuvBSIuz23CI0czPNPfY7zqWKOEeMKbbX79+///fBqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKglGU5DaJTYfjbJSPzZk0yT1SDHXriHOU5r0a0/opn9zSRB54umvHc5hCq4Zu0RP
         QTDvjoagbMJHnWexZBqbHqaBSaOn56XhiKx+c97egdYb8L+wu//yhF4wIk0Mqbz6iA
         3zXcQSRtItJTzxp5JoImHLtmZSBtSaC5ItZkqC4Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 119/262] media: ov7740: fix runtime pm initialization
Date:   Wed, 27 Mar 2019 13:59:34 -0400
Message-Id: <20190327180158.10245-119-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit 12aceee1f412c3ddc7750155fec06c906f14ab51 ]

The runtime PM of this device is enabled after v4l2_ctrl_handler_setup(),
and this makes this device's runtime PM usage count a negative value.

The ov7740_set_ctrl() tries to do something only if the device's runtime
PM usage counter is nonzero.

ov7740_set_ctrl()
{
	if (!pm_runtime_get_if_in_use(&client->dev))
		return 0;

	<do something>;

	pm_runtime_put(&client->dev);

	return ret;
}

However, the ov7740_set_ctrl() is called by v4l2_ctrl_handler_setup()
while the runtime PM of this device is not yet enabled.  In this case,
the pm_runtime_get_if_in_use() returns -EINVAL (!= 0).

Therefore we can't bail out of this function and the usage count is
decreased by pm_runtime_put() without increment.

This fixes this problem by enabling the runtime PM of this device before
v4l2_ctrl_handler_setup() so that the ov7740_set_ctrl() is always called
when the runtime PM is enabled.

Cc: Wenyou Yang <wenyou.yang@microchip.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Tested-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov7740.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 177688afd9a6..8835b831cdc0 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -1101,6 +1101,9 @@ static int ov7740_probe(struct i2c_client *client,
 	if (ret)
 		return ret;
 
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+
 	ret = ov7740_detect(ov7740);
 	if (ret)
 		goto error_detect;
@@ -1123,8 +1126,6 @@ static int ov7740_probe(struct i2c_client *client,
 	if (ret)
 		goto error_async_register;
 
-	pm_runtime_set_active(&client->dev);
-	pm_runtime_enable(&client->dev);
 	pm_runtime_idle(&client->dev);
 
 	return 0;
@@ -1134,6 +1135,8 @@ static int ov7740_probe(struct i2c_client *client,
 error_init_controls:
 	ov7740_free_controls(ov7740);
 error_detect:
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 	ov7740_set_power(ov7740, 0);
 	media_entity_cleanup(&ov7740->subdev.entity);
 
-- 
2.19.1

