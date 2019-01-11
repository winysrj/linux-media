Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D13C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9798E20700
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="whyKA9Wu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbfAKPoe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:44:34 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59998 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730891AbfAKPoe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 10:44:34 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id EAFC3547;
        Fri, 11 Jan 2019 16:44:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547221472;
        bh=VdSpkWvBGePH7GodXkaYOKi1FH9cMGsH7ZJ1VvznOV0=;
        h=From:To:Cc:Subject:Date:From;
        b=whyKA9WukzjNULT7oDAkwF8jubUGDMHNPxg0RjLyaBoDuoo3WW9StWai8rkEuW+PR
         Kk4GtN/wfAtzen0SoT53aPG9Mqei0h/p7bpQ05jgO4GYHLIJlnl6GzWvL2lxwt81M7
         RdBoONRQAdxPkV4fE9cBqGILUamPlqsC4luQHTig=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 2/2] media: i2c: adv748x: Use devm to allocate the device struct
Date:   Fri, 11 Jan 2019 15:43:45 +0000
Message-Id: <20190111154345.29145-2-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Steve Longerbeam <steve_longerbeam@mentor.com>

Switch to devm_kzalloc() when allocating the adv748x device struct.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 097e5c3a8e7e..4af2ae8fcc0a 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -774,7 +774,8 @@ static int adv748x_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	state = kzalloc(sizeof(struct adv748x_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(struct adv748x_state),
+			     GFP_KERNEL);
 	if (!state)
 		return -ENOMEM;
 
@@ -861,7 +862,6 @@ static int adv748x_probe(struct i2c_client *client,
 	adv748x_dt_cleanup(state);
 err_free_mutex:
 	mutex_destroy(&state->mutex);
-	kfree(state);
 
 	return ret;
 }
@@ -880,8 +880,6 @@ static int adv748x_remove(struct i2c_client *client)
 	adv748x_dt_cleanup(state);
 	mutex_destroy(&state->mutex);
 
-	kfree(state);
-
 	return 0;
 }
 
-- 
2.19.2

