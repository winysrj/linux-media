Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F863C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 19:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECAC220859
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 19:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfAQTco (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 14:32:44 -0500
Received: from lns-bzn-25-82-254-177-192.adsl.proxad.net ([82.254.177.192]:38725
        "EHLO maze.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726821AbfAQTco (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 14:32:44 -0500
Received: from over.fork.zz (over.fork.zz [192.168.0.155])
        by maze.fork.zz (8.15.2/8.15.2) with ESMTPS id x0HJWgn1020436
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jan 2019 20:32:42 +0100
Received: from over.fork.zz (localhost [127.0.0.1])
        by over.fork.zz (8.15.2/8.15.2) with ESMTPS id x0HJWfuk018478
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 17 Jan 2019 20:32:41 +0100
Received: (from patrick@localhost)
        by over.fork.zz (8.15.2/8.15.2/Submit) id x0HJWfQq018477;
        Thu, 17 Jan 2019 20:32:41 +0100
From:   Patrick Lerda <patrick9876@free.fr>
To:     linux-media@vger.kernel.org
Cc:     Patrick Lerda <patrick9876@free.fr>, sean@mess.org,
        linux-media-owner@vger.kernel.org
Subject: [PATCH 1/1] description update
Date:   Thu, 17 Jan 2019 20:32:22 +0100
Message-Id: <29102a49c63eef8c6c1e2ffdd60378f5f4b2d630.1547753149.git.patrick9876@free.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1547753149.git.patrick9876@free.fr>
References: <cover.1547738495.git.sean@mess.org> <cover.1547753149.git.patrick9876@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

---
 drivers/media/rc/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 2c468fa0299f..4486e1940196 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -139,9 +139,7 @@ config IR_RCMM_DECODER
 	help
 	   Enable this option when you have IR with RC-MM protocol, and
 	   you need the software decoder. The driver supports 32,
-	   24 and 12 bits RC-MM variants. You can enable or disable the
-	   different modes using the following RC protocol keywords:
-	   'rcmm-32', 'rcmm-24' and 'rcmm-12'.
+	   24 and 12 bits RC-MM variants.
 
 	   To compile this driver as a module, choose M here: the module
 	   will be called ir-rcmm-decoder.
-- 
2.20.1

