Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB334C4360F
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD1920C01
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 12:51:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="d+VIgJUL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfBTMvj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:51:39 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59610 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbfBTMvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 07:51:38 -0500
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 67EF654D;
        Wed, 20 Feb 2019 13:51:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550667095;
        bh=HTVjavVTRAijUeBBvsEtc07EuIS49b+9gUvb2KMvQxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+VIgJULxguifHO9j6+JScFznhA8NnffyMgIrCkOwD/5z+hwNYQ4w7tTgOdUVBfX9
         fM8bLIZOfelqXUqOAAvj1ahOYn8NlDFebdaapc2cu6ICsR3lNsPnq/2lLyo1a1fF7H
         PB3fBpzEwU50ggwLgh1z5o+OLhD3oNXMiKb5StTc=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH yavta 6/7] Support setting control from values stored in a file
Date:   Wed, 20 Feb 2019 14:51:22 +0200
Message-Id: <20190220125123.9410-7-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/yavta.c b/yavta.c
index 1490878c6f7e..2d49131a4271 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1334,6 +1334,31 @@ static int video_parse_control_array(const struct v4l2_query_ext_ctrl *query,
 	__u32 value;
 
 	for ( ; isspace(*val); ++val) { };
+
+	if (*val == '<') {
+		/* Read the control value from the given file. */
+		ssize_t size;
+		int fd;
+
+		val++;
+		fd = open(val, O_RDONLY);
+		if (fd < 0) {
+			printf("unable to open control file `%s'\n", val);
+			return -EINVAL;
+		}
+
+		size = read(fd, ctrl->ptr, ctrl->size);
+		if (size != (ssize_t)ctrl->size) {
+			printf("error reading control file `%s' (%s)\n", val,
+			       strerror(errno));
+			close(fd);
+			return -EINVAL;
+		}
+
+		close(fd);
+		return 0;
+	}
+
 	if (*val++ != '{')
 		return -EINVAL;
 
-- 
Regards,

Laurent Pinchart

