Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29F4C43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 07:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B591A20866
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 07:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="fZIlvJG+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfCIHFh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Mar 2019 02:05:37 -0500
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:38234 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfCIHFg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2019 02:05:36 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 08935D3F
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 07:05:35 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wol19pAoYKPa for <linux-media@vger.kernel.org>;
        Sat,  9 Mar 2019 01:05:34 -0600 (CST)
Received: from mail-it1-f200.google.com (mail-it1-f200.google.com [209.85.166.200])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id CD947D36
        for <linux-media@vger.kernel.org>; Sat,  9 Mar 2019 01:05:34 -0600 (CST)
Received: by mail-it1-f200.google.com with SMTP id q141so14048390itc.2
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2019 23:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=j2BKY+t1WAx9ChzDFZSzJABdJ0WWzcfwEgCZ2b2oFVg=;
        b=fZIlvJG+uDNfwDB+zAhg423IF86ug76/U9+M72573kaXtQO+JkKp98AEL0YIUuPaFy
         SahkL2dXOfvvk+71b8gF1/RzUpbzsyYe9yfvehYAQ4MHr2WSeHzdsNQdz06zx7yXnWcm
         JTBOXlcuo8iD3Vv51g1xgNIu83O0pY+UZBnXi5FYf1u3R4cEtlhVtHnO8u1qXhxcgtgp
         LZd7zaEtcSmFfUCEHS5G5RotHrOqCZEPoRQ5BVK6iH9jEuECuJNqbq+nFjI72As9DMge
         JlYjYGBv7b7n1iEyFu9OYY+9ZCAIlZtOQh9ktV35IjCAdTrH2ccnuT8+xbeh/9G2K4OZ
         hAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j2BKY+t1WAx9ChzDFZSzJABdJ0WWzcfwEgCZ2b2oFVg=;
        b=DnBaz/m81cwBWtmZEIESjQWG+pbX/OiDmnEQsomtt9SKIL4EXOI1C/71rNMaXLlpBl
         GXQ+eWAmfNZAp1Cns148ZIWTXmlyjI8pIKo9oEsyI99HuIM4clWTE+rasa8jaB5qZKVC
         gvmyLkaowBVN4cSesmF0lB0PDdDYyRE639jXOu3RzF1VTtStvTHVYjr6faI0NqWM7bQk
         LZKlyi8FvvnQ3s8UillxiRS2Cwi0Kpf6v+weQlx6m4mnBtXj36qPpQ0EGgqCusXTAXBR
         fWQw3O0SQ4Glg4vw+P1jJ5dzbGkt1HDKL9WopETWcXb7gDmGVGUZn+u8slKfZqwAyyJP
         R8sA==
X-Gm-Message-State: APjAAAW09yRp/npzqmNKLkuNSVc5JnlM3B32m226VvkxRPW0BtBYeVfH
        pjjTRP1yOCLE/UFbGlzyWs7RFyvld3i+jk5gEqLfkFmdrbiNqx2bsGdIqyWZbHbF2oGjp7eYqOe
        xjbbRVFFhGX3lrb8Z478sjyg/gWg=
X-Received: by 2002:a5e:c249:: with SMTP id w9mr1297612iop.284.1552115134429;
        Fri, 08 Mar 2019 23:05:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqwg55ygPTsg3BkASjoAYH5DwjCDqyrRjwTCxCzz+mXbR0O8CUaIR4HoHTyQEB9BD1enImXCvA==
X-Received: by 2002:a5e:c249:: with SMTP id w9mr1297596iop.284.1552115134176;
        Fri, 08 Mar 2019 23:05:34 -0800 (PST)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id z24sm3977671ioh.57.2019.03.08.23.05.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 23:05:33 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: rcar-vin: fix a potential NULL pointer dereference
Date:   Sat,  9 Mar 2019 01:05:27 -0600
Message-Id: <20190309070527.2657-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In case of_match_node cannot find a match, the fix returns
-EINVAL to avoid NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f0719ce24b97..a058e2023ca8 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -266,6 +266,8 @@ static int rvin_group_init(struct rvin_group *group, struct rvin_dev *vin)
 
 	match = of_match_node(vin->dev->driver->of_match_table,
 			      vin->dev->of_node);
+	if (unlikely(!match))
+		return -EINVAL;
 
 	strscpy(mdev->driver_name, KBUILD_MODNAME, sizeof(mdev->driver_name));
 	strscpy(mdev->model, match->compatible, sizeof(mdev->model));
-- 
2.17.1

