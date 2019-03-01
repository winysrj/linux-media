Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDEDDC10F06
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 17:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF88520857
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 17:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="o+S2TUhL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389406AbfCARJE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:09:04 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45352 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389399AbfCARJD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 12:09:03 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D56785A4;
        Fri,  1 Mar 2019 18:08:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551460139;
        bh=MDHScMFfNpcYuCtsV0n+wPvDmA8WhqnAjfjirAnlxlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+S2TUhLHN7kuVGOiEmgY7m+3lbJjVlI+m60Y6vcNV7S82ApjKGKPI9cBTdNd2q8G
         svBeYLVBJNtdLyIubJLnrZIxzhK+87WzR4dZiREN0aWvmWrqPI0B/kfmZGImWwtHS6
         oDkNUvZ8tfjG23c8lYkTMFRyv16wbPADogPjZEeI=
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v2 4/5] media: vsp1: Split out pre-filter multiplier
Date:   Fri,  1 Mar 2019 17:08:47 +0000
Message-Id: <20190301170848.6598-5-kieran.bingham@ideasonboard.com>
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

The 'mp' value is used through many calculations in determining the scaling
factors of the UDS. Factor this out so that it can be reused in further
calculations, and also ensure that if the BLADV control is ever changed only a
single function needs to be modified.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_uds.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 27012af973b2..c71c24363d54 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -46,6 +46,18 @@ void vsp1_uds_set_alpha(struct vsp1_entity *entity, struct vsp1_dl_body *dlb,
 		       alpha << VI6_UDS_ALPVAL_VAL0_SHIFT);
 }
 
+/*
+ * Determine the pre-filter multiplication value.
+ *
+ * This calculation assumes that the BLADV control is unset.
+ */
+static unsigned int uds_multiplier(int ratio)
+{
+	unsigned int mp = ratio / 4096;
+
+	return mp < 4 ? 1 : (mp < 8 ? 2 : 4);
+}
+
 /*
  * uds_output_size - Return the output size for an input size and scaling ratio
  * @input: input size in pixels
@@ -55,10 +67,7 @@ static unsigned int uds_output_size(unsigned int input, unsigned int ratio)
 {
 	if (ratio > 4096) {
 		/* Down-scaling */
-		unsigned int mp;
-
-		mp = ratio / 4096;
-		mp = mp < 4 ? 1 : (mp < 8 ? 2 : 4);
+		unsigned int mp = uds_multiplier(ratio);
 
 		return (input - 1) / mp * mp * 4096 / ratio + 1;
 	} else {
@@ -88,10 +97,7 @@ static unsigned int uds_passband_width(unsigned int ratio)
 {
 	if (ratio >= 4096) {
 		/* Down-scaling */
-		unsigned int mp;
-
-		mp = ratio / 4096;
-		mp = mp < 4 ? 1 : (mp < 8 ? 2 : 4);
+		unsigned int mp = uds_multiplier(ratio);
 
 		return 64 * 4096 * mp / ratio;
 	} else {
-- 
2.19.1

