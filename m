Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6F6C43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADB622173C
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 02:49:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Z1kUJweo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbfBQCtE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 21:49:04 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45166 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbfBQCtD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 21:49:03 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id DF565122C;
        Sun, 17 Feb 2019 03:49:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550371741;
        bh=wdYWD2OMIYjKx+iGNcwWlDtIBFCLE9X/j6JjL6Ik/JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1kUJweoBA6J1cVcAKB4fkt+BaLcw5wdgu93/r9oHirkjGTJxCwrpNyQWGyJ38Cy8
         Jx7K66010D73MvpEsCyK/imawD0tTL2W2r+4n6ztsueGRU37v3R/1Va007TXbCp+3G
         Az0QBlKyyoxDD/aldhxtx0d8seQAjsUJsN+IXDkI=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v4 3/7] media: vsp1: Replace leftover occurrence of fragment with body
Date:   Sun, 17 Feb 2019 04:48:48 +0200
Message-Id: <20190217024852.23328-4-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Display list fragments have been renamed to bodies. Replace one last
occurrence of the word fragment in the documentation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
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

