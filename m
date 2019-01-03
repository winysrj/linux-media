Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA2DC43387
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95D4920815
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ao2.it header.i=@ao2.it header.b="q8xAfoYd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfACSlD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 13:41:03 -0500
Received: from mail.ao2.it ([92.243.12.208]:58434 "EHLO ao2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfACSlC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Jan 2019 13:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ao2.it; s=20180927;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=FA1bQexyPoAn/vJg/TbwdBpgeZJJFuRc5mq1L8pu8EA=;
        b=q8xAfoYdwfHPXyVlYwihVxv5EDNj7v4T6skxhJyAMR967lemIXLbKMypFaYTFlF4rZlm0gGhrdERiiGp8rVQtanZnafZ/rk/+xsbPH9WxaFY/v+2vDOM1+7D3gB69Y4k9w2dah0OzAdpSCw/hFLRD1Igjkne1KWHovK+SWFRbGBszReSiTVjlUBBwvUDFJ3y6bWcgX4AQl6sqXEipNWEWhFA6fFJMaeb5tKaAON9hjmb8FEx7nZbMP1MTAolwOi9TnwKUrdsfx9+KNwniFZeM5pz1lchhwUH+95dEiBabDOHqsgtzm9YD5fmyoRBNCh69PT4438XoxcHwMcF2bnJpw==;
Received: from localhost ([::1] helo=jcn)
        by ao2.it with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Hq-0002wN-5q; Thu, 03 Jan 2019 19:00:06 +0100
Received: from ao2 by jcn with local (Exim 4.92-RC3)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Io-0003D2-Re; Thu, 03 Jan 2019 19:01:06 +0100
From:   Antonio Ospite <ao2@ao2.it>
To:     linux-media@vger.kernel.org
Cc:     Antonio Ospite <ao2@ao2.it>
Subject: [RFC PATCH 3/5] v4l2-ctl: use a dedicated function to print the control class name
Date:   Thu,  3 Jan 2019 19:01:00 +0100
Message-Id: <20190103180102.12282-4-ao2@ao2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190103180102.12282-1-ao2@ao2.it>
References: <20181124185256.74dc969bdb8f7ab79cf03d5d@ao2.it>
 <20190103180102.12282-1-ao2@ao2.it>
MIME-Version: 1.0
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

All the details about the controls are printed in the dedicated function
print_qctrl(), use a new dedicated function named print_class_name() to
print the control class name as well, this is for symmetry but it is
also in preparation for a change which aims to abstract how the controls
are printed.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 utils/v4l2-ctl/v4l2-ctl-common.cpp | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
index e2710335..5d41d720 100644
--- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
@@ -403,6 +403,11 @@ static void print_qctrl(int fd, struct v4l2_query_ext_ctrl *queryctrl,
 	}
 }
 
+static void print_class_name(const char *name)
+{
+	printf("\n%s\n\n", name);
+}
+
 static int print_control(int fd, struct v4l2_query_ext_ctrl &qctrl, int show_menus)
 {
 	struct v4l2_control ctrl;
@@ -415,7 +420,7 @@ static int print_control(int fd, struct v4l2_query_ext_ctrl &qctrl, int show_men
 	if (qctrl.flags & V4L2_CTRL_FLAG_DISABLED)
 		return 1;
 	if (qctrl.type == V4L2_CTRL_TYPE_CTRL_CLASS) {
-		printf("\n%s\n\n", qctrl.name);
+		print_class_name(qctrl.name);
 		return 1;
 	}
 	ext_ctrl.id = qctrl.id;
-- 
2.20.1

