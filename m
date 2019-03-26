Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF272C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 12:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE80920823
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 12:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cbqxX8QM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cbqxX8QM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbfCZMSE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:18:04 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfCZMSE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 08:18:04 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DE31460159; Tue, 26 Mar 2019 12:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553602683;
        bh=Mb/6oPEIT5zA9Lgdp3iSOIRwt/HImMYg4LWOdIGiPy8=;
        h=From:To:Cc:Subject:Date:From;
        b=cbqxX8QM7F07zgZCVhg4h7GhkA3tud+eJwfnmfQhiJtMMTmO21rloevH1N22RDM+1
         T31BvZjMGOYQWHMlq5Wo6XAjR6/RqvFd80ELtw0DWhQLlOeQ4DHTWgQyQnqxM1gn8i
         x1ZO8l0Dm3ZQGdVELEAcDMCB9KnH7z6UKhKftAkk=
Received: from mojha-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 38972602BA;
        Tue, 26 Mar 2019 12:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553602683;
        bh=Mb/6oPEIT5zA9Lgdp3iSOIRwt/HImMYg4LWOdIGiPy8=;
        h=From:To:Cc:Subject:Date:From;
        b=cbqxX8QM7F07zgZCVhg4h7GhkA3tud+eJwfnmfQhiJtMMTmO21rloevH1N22RDM+1
         T31BvZjMGOYQWHMlq5Wo6XAjR6/RqvFd80ELtw0DWhQLlOeQ4DHTWgQyQnqxM1gn8i
         x1ZO8l0Dm3ZQGdVELEAcDMCB9KnH7z6UKhKftAkk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 38972602BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
From:   Mukesh Ojha <mojha@codeaurora.org>
To:     prabhakar.csengg@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mukesh Ojha <mojha@codeaurora.org>
Subject: [PATCH] media: vpss: fix the order of resource clean up
Date:   Tue, 26 Mar 2019 17:47:54 +0530
Message-Id: <1553602674-531-1-git-send-email-mojha@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Clean up of resources should be in reverse order of vpss_init().
Fix this inside vpss_exit().

Signed-off-by: Mukesh Ojha <mojha@codeaurora.org>
---
 drivers/media/platform/davinci/vpss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 19cf685..e380fd3 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -507,9 +507,9 @@ static int vpss_resume(struct device *dev)
 
 static void vpss_exit(void)
 {
+	platform_driver_unregister(&vpss_driver);
 	iounmap(oper_cfg.vpss_regs_base2);
 	release_mem_region(VPSS_CLK_CTRL, 4);
-	platform_driver_unregister(&vpss_driver);
 }
 
 static int __init vpss_init(void)
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center,
Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

