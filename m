Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1B7C43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 06:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DCFA2081B
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 06:36:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="PaLWuZiN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfCIGgI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Mar 2019 01:36:08 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:41064 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfCIGgI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2019 01:36:08 -0500
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Mar 2019 01:36:07 EST
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id CB220BCE
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 06:36:06 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nqaxG8GnCs1X for <linux-media@vger.kernel.org>;
        Sat,  9 Mar 2019 00:36:06 -0600 (CST)
Received: from mail-it1-f200.google.com (mail-it1-f200.google.com [209.85.166.200])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 9E621B9F
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 00:36:06 -0600 (CST)
Received: by mail-it1-f200.google.com with SMTP id z131so13709887itb.2
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2019 22:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=QibFjWkhVa0if5Gddi16qagm9dnKdfLT5eOW+qU9df8=;
        b=PaLWuZiNjbA1zJ2RrTdXhua6u8w2Qq28lzKOqX9iHbN8RyVFQkknp0r25/smrmgm2K
         xsZL3IGPdgJnRtadDX8dvTDklh1Op+p5wHlWvq+0nIBLR94bTCd/TODf86mROq1Ov/hx
         Splo+pAEjdV0H6T/kiW6sHQmvL7nydZ/gohW+NHCOtULkOAu6iOJ+jFHN2Fg53+oDd78
         qnuv9ZQtCNx+T7ZNdVsICbifEbRbjBKwBqj1RP1vR/3Maf22jeQeMq98ikp2GBAmKIoB
         lBItF7DjHg6g4sLFnJ3t+GrfO5MkRl4AWvKaMXpFpejlts9dElPhwUlnMkxzqXvgGq0B
         gvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QibFjWkhVa0if5Gddi16qagm9dnKdfLT5eOW+qU9df8=;
        b=ug6VEpGIr7svMHUIjgRMmDFi8Ll799fURP4IxMzXwsqzhY7GhaB+BIIz123AUXvhPo
         d263OszeMbfc8hHYJonyXe1c215d3LO6NhSsuXYj8wD3GecgAtiOJkO2+uYnRu0YDQnV
         KO/t56b7Z9cCVrh3j06aGxVTbVM9hJQgW2ul08+b2GLLk+8ecEFMnNykPab0eo2YITZn
         kMo2pCA/rlRx9TNy7fbJkefUzGhTEx/GgaWcOm/OzxeqOZ/kaDkQaPGEfuvUBlPNczX7
         wBL1SUhaFg4yGwc5zlQpyATPFZBB6jj+X2GtD7nP98ouw0804kpNCI3T/GRgs8rtB4XB
         ltoQ==
X-Gm-Message-State: APjAAAUCYc2O4OoO8KQSIootfT2J5ex20RTieu5RX9ErV3KpChIcr4FG
        Hwl5DcMdON6Fg7mB/SVKItfxVA1maPGS9P2LJ1nobN2P72r+1vScbcumTKFKqFu6PFl9pFCOEXy
        HEikFpIJeCp1GvXfGeP8ZcYWZV6I=
X-Received: by 2002:a6b:f81a:: with SMTP id o26mr10109574ioh.156.1552113366226;
        Fri, 08 Mar 2019 22:36:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjCRG95mYlXzX+zNuZBX50IZP57NwGC3iNPWZxoa8C97MsBYf4OqqyBdTlLfARE0agl9er0g==
X-Received: by 2002:a6b:f81a:: with SMTP id o26mr10109567ioh.156.1552113366010;
        Fri, 08 Mar 2019 22:36:06 -0800 (PST)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id c19sm3810033ioh.4.2019.03.08.22.36.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 22:36:05 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Jacob chen <jacob2.chen@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: rga: fix NULL pointer dereferences
Date:   Sat,  9 Mar 2019 00:35:56 -0600
Message-Id: <20190309063556.32487-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In case __get_free_pages fails, return -ENOMEM to avoid NULL
pointer dereferences.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/platform/rockchip/rga/rga.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 5c653287185f..d42b214977a9 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -892,8 +892,13 @@ static int rga_probe(struct platform_device *pdev)
 
 	rga->src_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+	if (!rga->src_mmu_pages)
+		return -ENOMEM;
+
 	rga->dst_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+	if (!rga->dst_mmu_pages)
+		return -ENOMEM;
 
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
 	def_frame.size = def_frame.stride * def_frame.height;
-- 
2.17.1

