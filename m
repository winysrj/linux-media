Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E089C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 19:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B72820859
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 19:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfAQTbF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 14:31:05 -0500
Received: from lns-bzn-25-82-254-177-192.adsl.proxad.net ([82.254.177.192]:38137
        "EHLO maze.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727704AbfAQTbF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 14:31:05 -0500
Received: from over.fork.zz (over.fork.zz [192.168.0.155])
        by maze.fork.zz (8.15.2/8.15.2) with ESMTPS id x0HJV1ew020428
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jan 2019 20:31:02 +0100
Received: from over.fork.zz (localhost [127.0.0.1])
        by over.fork.zz (8.15.2/8.15.2) with ESMTPS id x0HJV1hD018413
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 17 Jan 2019 20:31:01 +0100
Received: (from patrick@localhost)
        by over.fork.zz (8.15.2/8.15.2/Submit) id x0HJV0Z0018411;
        Thu, 17 Jan 2019 20:31:00 +0100
From:   Patrick Lerda <patrick9876@free.fr>
To:     linux-media@vger.kernel.org
Cc:     Patrick Lerda <patrick9876@free.fr>, sean@mess.org,
        linux-media-owner@vger.kernel.org
Subject: [PATCH 0/1] description update
Date:   Thu, 17 Jan 2019 20:30:13 +0100
Message-Id: <cover.1547753149.git.patrick9876@free.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1547738495.git.sean@mess.org>
References: <cover.1547738495.git.sean@mess.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sean,

Your update is fine, and everything is working perfectly on my machine. We need just now
to update the description; 'rcmm' is now the global keyword. The warning triggered by the v5
was just: 'if' badly interpreted as a keyword by the perl script.

Best Regards,
Patric Lerda.

Patrick Lerda (1):
  description update.

 drivers/media/rc/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

-- 
2.20.1

