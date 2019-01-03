Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D03C43387
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66AB320815
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ao2.it header.i=@ao2.it header.b="IIrzbMTx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfACSk5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 13:40:57 -0500
Received: from mail.ao2.it ([92.243.12.208]:58431 "EHLO ao2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfACSk5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Jan 2019 13:40:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ao2.it; s=20180927;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=inL732P2ibVLjJvlYjE4QZS7vVZw5X1z6O6He+ahaoo=;
        b=IIrzbMTxXh6xbeRWQGxV1IJ5tafk9y3+3twXnrtXbP9ie2symCHwwocA2unbgsKuXX76BMyrzG/G8eiSjsczl+jef+/6NQMU6kpPWQO1DST2se4mI0mKSuK1eR2zG0wHM469jfNdFUyC4JYjveqYcbdRNODre79G3rPgXjD5aP0MYLjTjrlGrccJP0+kYUprYZ3AVmucJsUh5dZxXhI1lKv3K58gQ4vE3JxhM7ih7NXL4vNYjDpcA4p7EPLmSN4rc6qf9FRGgiu3LBrmcS4emIh68P2ELsWGd49/kZmdDgcIxCy6mCDpUBSRh57vHdjBYtRn5T9eQTWlg+cK6tRiww==;
Received: from localhost ([::1] helo=jcn)
        by ao2.it with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Hq-0002wM-39; Thu, 03 Jan 2019 19:00:06 +0100
Received: from ao2 by jcn with local (Exim 4.92-RC3)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Io-0003D0-PU; Thu, 03 Jan 2019 19:01:06 +0100
From:   Antonio Ospite <ao2@ao2.it>
To:     linux-media@vger.kernel.org
Cc:     Antonio Ospite <ao2@ao2.it>
Subject: [RFC PATCH 2/5] v4l2-ctl: list once when both OptListCtrls and OptListCtrlsMenus are there
Date:   Thu,  3 Jan 2019 19:00:59 +0100
Message-Id: <20190103180102.12282-3-ao2@ao2.it>
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

When both --list-ctrls and --list-ctrls-menus are passed, controls are
listed twice which is accurate but can be confusing.

Treat --list-ctrls-menus as an option modifier when also --list-ctrls is
passed, in order to have the controls listed only once.

Signed-off-by: Antonio Ospite <ao2@ao2.it>
---
 utils/v4l2-ctl/v4l2-ctl-common.cpp | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
index 8256cbd9..e2710335 100644
--- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
@@ -1091,11 +1091,7 @@ void common_get(cv4l_fd &_fd)
 
 void common_list(cv4l_fd &fd)
 {
-	if (options[OptListCtrlsMenus]) {
-		list_controls(fd.g_fd(), 1);
-	}
-
-	if (options[OptListCtrls]) {
-		list_controls(fd.g_fd(), 0);
+	if (options[OptListCtrls] || options[OptListCtrlsMenus]) {
+		list_controls(fd.g_fd(), options[OptListCtrlsMenus]);
 	}
 }
-- 
2.20.1

