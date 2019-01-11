Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50C8C43444
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 16:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76EF62133F
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 16:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="rxgVx/HV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387835AbfAKQRJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 11:17:09 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:60312 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfAKQRJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 11:17:09 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7778C53E;
        Fri, 11 Jan 2019 17:17:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547223427;
        bh=3pJga9R1B/FIA8pcX8vkk2nYCtc3WjgRr7I+PJZ0rO8=;
        h=From:To:Cc:Subject:Date:From;
        b=rxgVx/HV8b+G1nXzPkV3z7qj7pJTFNtnldgOl9xhPHYuNK82tGeW/6ZgtGwiEsxhK
         3M78pxTAbfQY+cqrylJ/xy82VpHwF9yPu8vJ6OdEeFKs1zAsoSQQlGqM51e2vxORUh
         OedHzGuGyM1Xr+99tt2OvTUDYZhvJ635KOcN+FyA=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2] media: i2c: adv748x: Use devm to allocate the device struct
Date:   Fri, 11 Jan 2019 16:17:03 +0000
Message-Id: <20190111161703.7972-1-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Steve Longerbeam <steve_longerbeam@mentor.com>

Switch to devm_kzalloc() when allocating the adv748x device struct.

The sizeof() is updated to determine the correct allocation size from
the dereferenced pointer type rather than hardcoding the struct type.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
[Kieran: Change sizeof() to dereference the pointer type]
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 060d0c5b4989..1e5c7bbcf6b2 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -674,7 +674,7 @@ static int adv748x_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	state = kzalloc(sizeof(struct adv748x_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (!state)
 		return -ENOMEM;
 
@@ -772,7 +772,6 @@ static int adv748x_probe(struct i2c_client *client,
 	adv748x_dt_cleanup(state);
 err_free_mutex:
 	mutex_destroy(&state->mutex);
-	kfree(state);
 
 	return ret;
 }
@@ -791,8 +790,6 @@ static int adv748x_remove(struct i2c_client *client)
 	adv748x_dt_cleanup(state);
 	mutex_destroy(&state->mutex);
 
-	kfree(state);
-
 	return 0;
 }
 
-- 
2.17.1

