Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28252C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 16:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6E0920837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 16:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="wIQdSr3U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6E0920837
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbeLGQbl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 11:31:41 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:53606 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbeLGQbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 11:31:40 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8E168537;
        Fri,  7 Dec 2018 17:31:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544200298;
        bh=jpFyFThJDMRJZSi4LsK1cjKbKiSztbfn67TVFpp8S9M=;
        h=From:To:Cc:Subject:Date:From;
        b=wIQdSr3UQ/Msj2KrMEfO3RLG7VLbS2ezg9G8zXGy9RKBCW3ogJXXGZ26CP9qUtbVy
         9B2r2Y074c8dh2WZnadBgpWRu7AYy4MhA/NQdcVZfkL8X1svnSjpiY1NFWS1NmHo9n
         gya3X8muOpUrSLIRUKGAmWOuebH3oTGwgKm9+I+c=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH] media: vsp1: Fix trivial documentation
Date:   Fri,  7 Dec 2018 16:31:34 +0000
Message-Id: <20181207163134.14279-1-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In the partition sizing the term 'prevents' is inappropriately
pluralized.  Simplify to 'prevent'.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 771dfe1f7c20..7ceaf3222145 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -223,7 +223,7 @@ static void vsp1_video_calculate_partition(struct vsp1_pipeline *pipe,
 	 * If the modulus is less than half of the partition size,
 	 * the penultimate partition is reduced to half, which is added
 	 * to the final partition: |1234|1234|1234|12|341|
-	 * to prevents this:       |1234|1234|1234|1234|1|.
+	 * to prevent this:        |1234|1234|1234|1234|1|.
 	 */
 	if (modulus) {
 		/*
-- 
2.17.1

