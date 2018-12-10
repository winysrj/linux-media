Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD70C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35592084E
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="ZRmFIxV5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B35592084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbeLJMIB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 07:08:01 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:56582 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbeLJMIA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 07:08:00 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D1949549;
        Mon, 10 Dec 2018 13:07:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544443679;
        bh=02pr3itSrQsvApq6bGtA8eGY/Erzwjc27W/UCBSVX5c=;
        h=From:To:Cc:Subject:Date:From;
        b=ZRmFIxV5rgP6/p2owgUorbQ/pqjG6lWgpn2eCCP8JLdmhR5G5uGWnJiioU3obwlSh
         crc2iXZLunmLVAATJoSOSYTtrEV8UUqO+ArnnNSpQK/tEeE/SAIG8HA4t4cbyDjnRE
         rxYkxiKyAa/sLqyXWR/D5d5gGnGDvfMmr3xTGWJM=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Subject: [PATCH] media: i2c: adv748x: Fix video standard selection register setting
Date:   Mon, 10 Dec 2018 12:07:55 +0000
Message-Id: <20181210120755.12966-1-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

By video decoder user's manual, the bit 2 in Video Standard
Selection register must be reserved with the value of 1.
This driver cleared it with 0 when writing back.
This patch corrects it.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
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
index b482c7fe6957..f1f513f4327b 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -265,6 +265,7 @@ struct adv748x_state {
 #define ADV748X_SDP_INSEL		0x00	/* user_map_rw_reg_00 */
 
 #define ADV748X_SDP_VID_SEL		0x02	/* user_map_rw_reg_02 */
+#define ADV748X_SDP_VID_RESERVED_BIT	0x04
 #define ADV748X_SDP_VID_SEL_MASK	0xf0
 #define ADV748X_SDP_VID_SEL_SHIFT	4
 
-- 
2.17.1

