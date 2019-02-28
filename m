Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B478EC43381
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 22:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B69A206DD
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 22:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbfB1WyV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 17:54:21 -0500
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:35045 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfB1WyV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 17:54:21 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail-svr1.cs.utah.edu (Postfix) with ESMTP id 8FA5E6500B9;
        Thu, 28 Feb 2019 15:54:20 -0700 (MST)
Received: from mail-svr1.cs.utah.edu ([127.0.0.1])
        by localhost (mail-svr1.cs.utah.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id reTY4-MvHOdr; Thu, 28 Feb 2019 15:54:20 -0700 (MST)
Received: from node-10.av-cluster.smack.emulab.net (pc845.emulab.net [155.98.36.145])
        by smtps.cs.utah.edu (Postfix) with ESMTPSA id 1F57B6500AA;
        Thu, 28 Feb 2019 15:54:20 -0700 (MST)
From:   Shaobo He <shaobo@cs.utah.edu>
To:     linux-media@vger.kernel.org
Cc:     shaobo@cs.utah.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] platform/sh_veu.c: remove redundant NULL pointer checks
Date:   Thu, 28 Feb 2019 15:54:06 -0700
Message-Id: <1551394449-122395-1-git-send-email-shaobo@cs.utah.edu>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Function `sh_veu_find_fmt` returns an address that is an addition of a
base pointer `sh_veu_fmt` and an offset. The base pointer refers to a
global variable of which address cannot be NULL. Therefore, this commit
removes the NULL pointer checks on the return values of function
`sh_veu_find_fmt`.

Signed-off-by: Shaobo He <shaobo@cs.utah.edu>
---
 drivers/media/platform/sh_veu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 09ae64a..3069015 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -493,9 +493,6 @@ static int sh_veu_try_fmt_vid_cap(struct file *file, void *priv,
 	const struct sh_veu_format *fmt;
 
 	fmt = sh_veu_find_fmt(f);
-	if (!fmt)
-		/* wrong buffer type */
-		return -EINVAL;
 
 	return sh_veu_try_fmt(f, fmt);
 }
@@ -506,9 +503,6 @@ static int sh_veu_try_fmt_vid_out(struct file *file, void *priv,
 	const struct sh_veu_format *fmt;
 
 	fmt = sh_veu_find_fmt(f);
-	if (!fmt)
-		/* wrong buffer type */
-		return -EINVAL;
 
 	return sh_veu_try_fmt(f, fmt);
 }
-- 
2.7.4

