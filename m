Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CD7C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 15:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A26820880
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 15:20:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="SQYNwT02"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfBTPUC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 10:20:02 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:42016 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfBTPUC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 10:20:02 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 18A4C54D;
        Wed, 20 Feb 2019 16:20:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550676000;
        bh=iYzxWQHKDmXxLNd/GO8RynFD8P1ejrYyA4Z6Vj0oVUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQYNwT02WNno+wvtKr3yQPMfBJFXbcbJmLXVYTB5TX5rU85IhlJjhXGzC8V2FlDAH
         eCIUkwKuAiIFfDLqJDUlM8ViEbrgfyChbAXLxaP+LqtlTPxNWUCsxNrXCMOaJo2Ha9
         xie8CfsEEzbVdzTSL5N0fOK/Y6SKqXuO5Z2ec5p0=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH yavta 1/3] Fix emulation of old API for string controls
Date:   Wed, 20 Feb 2019 17:19:50 +0200
Message-Id: <20190220151952.15376-2-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190220151952.15376-1-laurent.pinchart@ideasonboard.com>
References: <20190220151952.15376-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

For kernel versions that didn't define the V4L2_CTRL_FLAG_HAS_PAYLOAD
flag, commits 2f146567186f ("Implement compound control get support")
and 4480b561404f ("Implement compound control set support") broke string
control support. Fix this by emulating the V4L2_CTRL_FLAG_HAS_PAYLOAD
and compound control API for the older API.

Fixes: 2f146567186f ("Implement compound control get support")
Fixes: 4480b561404f ("Implement compound control set support")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/yavta.c b/yavta.c
index 0efa7d73e432..7d9c40c9f9be 100644
--- a/yavta.c
+++ b/yavta.c
@@ -637,6 +637,12 @@ static int query_control(struct device *dev, unsigned int id,
 	query->default_value = q.default_value;
 	query->flags = q.flags;
 
+	if (q.type == V4L2_CTRL_TYPE_STRING &&
+	    !(q.flags & V4L2_CTRL_FLAG_HAS_PAYLOAD)) {
+		query->elem_size = q.maximum + 1;
+		query->elems = 1;
+	}
+
 	return 0;
 }
 
-- 
Regards,

Laurent Pinchart

