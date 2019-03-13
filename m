Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB7FC10F00
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92783217F4
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="jUUO0DGD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfCMAFr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:05:47 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42062 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfCMAFr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:05:47 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A2AC39A7;
        Wed, 13 Mar 2019 01:05:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435545;
        bh=9F8xPqGBr3eYuJwthTqhzwEMjEZc/2TxLIq63grdw+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUUO0DGDUr6pDEK7xqa50YTL2vmAjTLCfndDDLf46/JUtV4VuIPrNf1BKdWvSKZ3q
         4oJb/jaSpUAaYHmRQd8l7ceT4bjIjYJL60PQcCgxeG7pyRiffdmWAB1k+uhEZ3pbUm
         UsiSZ3cBxdqkQjosjLpojSB8b5nD7kRyFC2Sxpv8=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 03/18] media: vsp1: Replace leftover occurrence of fragment with body
Date:   Wed, 13 Mar 2019 02:05:17 +0200
Message-Id: <20190313000532.7087-4-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Display list fragments have been renamed to bodies. Replace one last
occurrence of the word fragment in the documentation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 26289adaf658..64af449791b0 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -699,8 +699,8 @@ struct vsp1_dl_body *vsp1_dl_list_get_body0(struct vsp1_dl_list *dl)
  * which bodies are added.
  *
  * Adding a body to a display list passes ownership of the body to the list. The
- * caller retains its reference to the fragment when adding it to the display
- * list, but is not allowed to add new entries to the body.
+ * caller retains its reference to the body when adding it to the display list,
+ * but is not allowed to add new entries to the body.
  *
  * The reference must be explicitly released by a call to vsp1_dl_body_put()
  * when the body isn't needed anymore.
-- 
Regards,

Laurent Pinchart

