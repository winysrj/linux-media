Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508E0C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17AD42147C
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="FM9iXW0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfBTMvl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:51:41 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59610 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728100AbfBTMvk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 07:51:40 -0500
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id E3DE8BB9;
        Wed, 20 Feb 2019 13:51:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550667096;
        bh=B1rt82Ju5SaYMOB1MUb7oUO+ojTRE3gxGjORe86jbkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FM9iXW0nw/K3jpGqDi943MhdU4eeBjiVHGRJDqZErp7JBQPoQ0QeSLR8POjv9BHep
         MNqEFAd6GO6nzBJP4y5+KqNa+GGeSXfWlR/W1STGe9G40rbOGvZb6y5MfzMsP2YF/3
         d2W2W/gxP0sW5suJtIMainG5JBAfEPf8nj+L6e+E=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH yavta 7/7] Remove unneeded conditional compilation for old V4L2 API versions
Date:   Wed, 20 Feb 2019 14:51:23 +0200
Message-Id: <20190220125123.9410-8-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As we include a copy of the V4L2 kernel headers, there's no need for
conditional compilation to support old versions of the API.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/yavta.c b/yavta.c
index 2d49131a4271..741df82a8db0 100644
--- a/yavta.c
+++ b/yavta.c
@@ -40,10 +40,6 @@
 
 #include <linux/videodev2.h>
 
-#ifndef V4L2_BUF_FLAG_ERROR
-#define V4L2_BUF_FLAG_ERROR	0x0040
-#endif
-
 #define ARRAY_SIZE(a)	(sizeof(a)/sizeof((a)[0]))
 
 enum buffer_fill_mode
@@ -1142,16 +1138,9 @@ static int video_for_each_control(struct device *dev,
 	unsigned int id;
 	int ret;
 
-#ifndef V4L2_CTRL_FLAG_NEXT_CTRL
-	unsigned int i;
-
-	for (i = V4L2_CID_BASE; i <= V4L2_CID_LASTP1; ++i) {
-		id = i;
-#else
 	id = 0;
 	while (1) {
 		id |= V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
-#endif
 
 		ret = query_control(dev, id, &query);
 		if (ret == -EINVAL)
-- 
Regards,

Laurent Pinchart

