Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A604DC10F0B
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 15:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7955F2183F
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 15:20:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="lcxt4a/m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfBTPUE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 10:20:04 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:42028 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfBTPUD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 10:20:03 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D25989A9;
        Wed, 20 Feb 2019 16:20:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550676001;
        bh=oVhFnpjlvrVtV5f2AZ21qILQKpdSJVtNa9oglgOlBv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcxt4a/meB14SPOuqa2e7l+t/Bc8v8Jtl6MQZWiCVZrLvcSkjQrzlWF1dG4eDMPEv
         kpZkNPnJayJhj9SPsooi5MrtCT0t7fBwLW8uzD5C10wQy6Zf73QFIYWCpbKeSOtbS9
         Trq45uh6ffj8j8HEEPd/Qzt4V7u9A/ltMUBZNdYc=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH yavta 3/3] Fix control array parsing
Date:   Wed, 20 Feb 2019 17:19:52 +0200
Message-Id: <20190220151952.15376-4-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190220151952.15376-1-laurent.pinchart@ideasonboard.com>
References: <20190220151952.15376-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Commit 4480b561404f ("Implement compound control set support") didn't
properly parse control array values. Fix it.

Fixes: 4480b561404f ("Implement compound control set support")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/yavta.c b/yavta.c
index 86447f3f057d..bcdcddb1a8c5 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1505,9 +1505,10 @@ static int video_parse_control_array(const struct v4l2_query_ext_ctrl *query,
 
 		val = endptr;
 		for ( ; isspace(*val); ++val) { };
-		if (*val++ != ',')
+		if (*val != ',')
 			break;
-	} 
+		val++;
+	}
 
 	if (i < query->elems - 1)
 		return -EINVAL;
-- 
Regards,

Laurent Pinchart

