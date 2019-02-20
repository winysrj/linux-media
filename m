Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845EBC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 15:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B6312086A
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 15:20:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="AawEqdfi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfBTPUD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 10:20:03 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:42026 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbfBTPUD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 10:20:03 -0500
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 75221993;
        Wed, 20 Feb 2019 16:20:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550676000;
        bh=CKK4NyuJblKsysN2HbhGBSSSKbdCww4umulGJLzXbhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AawEqdfiDYIIJrvSKD6jRfGoXHvdo7QggDcJqBTrxHZmScxtZzvx6wS+qOEiqKxBd
         kYwB7mH/z+p2puPgwk4sIfJv/R/NQzm55skLlHGZa8seX8r891RFchWrBdlBO6pLW/
         SN6UEpS1py+EfaL5iWLj3zB5/0xy1PTNWwylmJ/4=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH yavta 2/3] Print numerical control type for unsupported types
Date:   Wed, 20 Feb 2019 17:19:51 +0200
Message-Id: <20190220151952.15376-3-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190220151952.15376-1-laurent.pinchart@ideasonboard.com>
References: <20190220151952.15376-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Help diagnosing problems by reporting the type of unsupported control
types instead of just printing "unsupported".

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/yavta.c b/yavta.c
index 7d9c40c9f9be..86447f3f057d 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1368,7 +1368,7 @@ static void video_print_control_value(const struct v4l2_query_ext_ctrl *query,
 		video_print_control_array(query, ctrl);
 		break;
 	default:
-		printf("unsupported");
+		printf("unsupported type %u", query->type);
 		break;
 	}
 }
-- 
Regards,

Laurent Pinchart

