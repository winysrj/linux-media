Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D80FC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4623520989
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:29:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="IESANr2I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4623520989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbeLJM3Q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 07:29:16 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:56732 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbeLJM3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 07:29:16 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 88385549;
        Mon, 10 Dec 2018 13:29:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544444953;
        bh=WofJ7QpiSLn7JGoVzOKVHu2dp4NP/jEUy43ziWaiy+4=;
        h=From:To:Cc:Subject:Date:From;
        b=IESANr2IlPzwt8JR9nXl3BsnGaYtN7NJEZgh3cYI6B3WEsC8j3vb+HTGxkHnA0kW2
         1fB8tKcMKQZ8/CkfbLxulz7K8Myw0hvnZeqvHNk0am7J507CtaaDQXhFFNVMdn9g9+
         Z/vXat7L+ehd0zsDCTdJ5knhgA9r3AVyjzgDuiN0=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc:     Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2] media: i2c: adv748x: Fix video standard selection register setting
Date:   Mon, 10 Dec 2018 12:29:01 +0000
Message-Id: <20181210122901.14600-1-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

The ADV7481 Register Control Manual states that bit 2 in the Video
Standard Selection register is reserved with the value of 1.

The bit is otherwise undocumented, and currently cleared by the driver
when setting the video standard selection.

Define the bit as reserved, and ensure that it is always set when
writing to the SDP_VID_SEL register.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
[Kieran: Updated commit message, utilised BIT macro]
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/i2c/adv748x/adv748x-afe.c | 3 ++-
 drivers/media/i2c/adv748x/adv748x.h     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
index 71714634efb0..c4d9ffc50702 100644
--- a/drivers/media/i2c/adv748x/adv748x-afe.c
+++ b/drivers/media/i2c/adv748x/adv748x-afe.c
@@ -151,7 +151,8 @@ static void adv748x_afe_set_video_standard(struct adv748x_state *state,
 					  int sdpstd)
 {
 	sdp_clrset(state, ADV748X_SDP_VID_SEL, ADV748X_SDP_VID_SEL_MASK,
-		   (sdpstd & 0xf) << ADV748X_SDP_VID_SEL_SHIFT);
+		   (sdpstd & 0xf) << ADV748X_SDP_VID_SEL_SHIFT |
+		   ADV748X_SDP_VID_RESERVED_BIT);
 }
 
 static int adv748x_afe_s_input(struct adv748x_afe *afe, unsigned int input)
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index b482c7fe6957..778aa55a741a 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -265,6 +265,7 @@ struct adv748x_state {
 #define ADV748X_SDP_INSEL		0x00	/* user_map_rw_reg_00 */
 
 #define ADV748X_SDP_VID_SEL		0x02	/* user_map_rw_reg_02 */
+#define ADV748X_SDP_VID_RESERVED_BIT	BIT(2)	/* undocumented reserved bit */
 #define ADV748X_SDP_VID_SEL_MASK	0xf0
 #define ADV748X_SDP_VID_SEL_SHIFT	4
 
-- 
2.17.1

