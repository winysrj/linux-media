Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E78BC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 17:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1446C20848
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 17:09:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="lm/xPAwS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389404AbfCARJD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:09:03 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45358 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389342AbfCARJB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 12:09:01 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7BB3F59E;
        Fri,  1 Mar 2019 18:08:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551460138;
        bh=nGwZ72S5X7FAh8E3bE5dQ9wYzUGwVftumClN2wP0YZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lm/xPAwSH657ZJSL2atWD2IzJIoANwVYKT3p+zfjPsSXHrtLljMREow7yhfjVcio2
         feXl+ZWaDZ7pHSbp+45Y6pDC0NCmqjwa0we14FCiWqQ4PaeL7O/VRVotjn0RstRA/L
         gKkvXP6OqIK5ZOvx8RfvOEOlLGOPYmkDKGBHV6ag=
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v2 3/5] media: vsp1: Document partition algorithm in code header
Date:   Fri,  1 Mar 2019 17:08:46 +0000
Message-Id: <20190301170848.6598-4-kieran.bingham@ideasonboard.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190301170848.6598-1-kieran.bingham@ideasonboard.com>
References: <20190301170848.6598-1-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The image partition algorithm operates on the image dimensions as input
into the WPF entity. Document this in the code block header.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 563f9a02c373..d1ecc3d91290 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -173,6 +173,14 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 
 /* -----------------------------------------------------------------------------
  * VSP1 Partition Algorithm support
+ *
+ * VSP hardware can have restrictions on image width dependent on the hardware
+ * configuration of the pipeline. Adapting for these restrictions is implemented
+ * via the partition algorithm.
+ *
+ * The partition windows and sizes are based on the output size of the WPF
+ * before rotation, which is represented by the input parameters to the WPF
+ * entity in our pipeline.
  */
 
 /**
-- 
2.19.1

