Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2380C67872
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 06:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67FF12086D
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 06:19:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67FF12086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ragnatech.se
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbeLNGT0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 01:19:26 -0500
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:2898 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727054AbeLNGT0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 01:19:26 -0500
X-Halon-ID: 2c68c44e-ff68-11e8-911a-0050569116f7
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id 2c68c44e-ff68-11e8-911a-0050569116f7;
        Fri, 14 Dec 2018 07:19:17 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 2/4] rcar-vin: cache the CSI-2 channel selection value
Date:   Fri, 14 Dec 2018 07:18:22 +0100
Message-Id: <20181214061824.10296-3-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214061824.10296-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181214061824.10296-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In preparation of suspend/resume support cache the chsel value when we
write it to the register so it can be restored on resume if needed.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 2 ++
 drivers/media/platform/rcar-vin/rcar-vin.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index beb9248992a48a74..64f7636f94d6a0a3 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1336,6 +1336,8 @@ int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
 
 	vin_dbg(vin, "Set IFMD 0x%x\n", ifmd);
 
+	vin->chsel = chsel;
+
 	/* Restore VNMC. */
 	rvin_write(vin, vnmc, VNMC_REG);
 
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 0b13b34d03e3dce4..d21fc991b7a9da36 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -170,6 +170,7 @@ struct rvin_info {
  * @state:		keeps track of operation state
  *
  * @is_csi:		flag to mark the VIN as using a CSI-2 subdevice
+ * @chsel		Cached value of the current CSI-2 channel selection
  *
  * @mbus_code:		media bus format code
  * @format:		active V4L2 pixel format
@@ -207,6 +208,7 @@ struct rvin_dev {
 	enum rvin_dma_state state;
 
 	bool is_csi;
+	unsigned int chsel;
 
 	u32 mbus_code;
 	struct v4l2_pix_format format;
-- 
2.19.2

