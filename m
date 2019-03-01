Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8439EC4360F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 17:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 527CD20848
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 17:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="COmVsVzZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389403AbfCARJC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:09:02 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45352 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389295AbfCARJB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 12:09:01 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 22C6659C;
        Fri,  1 Mar 2019 18:08:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551460138;
        bh=Lj8MiOeSxnyhVXNGo8K0194m7JqC2t/IVsVXNItdHLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COmVsVzZ0MiKpqGgRnIN7cKelHv6mefe7dXC1NkHuhxHojfbtoblQywhRhFuaPhXn
         dhdNgziC27r9284Bpn4YCtq4/6IwMsOtEjgtIoUtJcRfRHTzJNBvpy1hAzt4CPPtyw
         bkZ1GfUrqpIVv326x1Z2zzKMxB8c7v+ugEpj040w=
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v2 2/5] media: vsp1: Initialise partition windows
Date:   Fri,  1 Mar 2019 17:08:45 +0000
Message-Id: <20190301170848.6598-3-kieran.bingham@ideasonboard.com>
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

Ensure that the partition window is correctly initialised before being
utilised.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index ee2fb8261a6a..563f9a02c373 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -189,7 +189,7 @@ static void vsp1_video_calculate_partition(struct vsp1_pipeline *pipe,
 					   unsigned int index)
 {
 	const struct v4l2_mbus_framefmt *format;
-	struct vsp1_partition_window window;
+	struct vsp1_partition_window window = { 0, };
 	unsigned int modulus;
 
 	/*
-- 
2.19.1

