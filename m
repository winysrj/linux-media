Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE866C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 05:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFB71217F5
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 05:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="EMRxK/nh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfCNFDy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 01:03:54 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:56130 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfCNFDx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 01:03:53 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 0FF7FD03
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2019 05:03:52 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fu1Dpnz_nY2k for <linux-media@vger.kernel.org>;
        Thu, 14 Mar 2019 00:03:51 -0500 (CDT)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id CFE71B39
        for <linux-media@vger.kernel.org>; Thu, 14 Mar 2019 00:03:51 -0500 (CDT)
Received: by mail-io1-f69.google.com with SMTP id l10so3335310iob.22
        for <linux-media@vger.kernel.org>; Wed, 13 Mar 2019 22:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6wTZ28phD5H5Nm9ztxpdzsm6xuR9rHIlsvJgNcIGMFQ=;
        b=EMRxK/nhAXuWpYA3J/OuPmeHwja9NtuHrdrIwZi0lqCj/txu4A4S1qMCqOLhT7G8nU
         g8jzKgaYRO4OFVfsnCjjB8XH+Q9MYFfV0IkuNnmZ5nL6PVAjIa3PETidRoYOuZYAhIxv
         P+n+8+ndbbIWmCIOWT4a1Kd15P9Ry4FMbyeQ/taYWCYjXNRn3m8bdv7ujOjghxV2Pkl6
         ZDhZrA0YwG1qgqL9lY1IIdTRZ7ElUEsswOcibLGPTV+HxR2gNrFgmXQF02DOmA3EmGZY
         fnI6rFOZ4cMdDJb4uMx/gyRfuuqkaTkYcIl83rwokQymdEsUUWuMIliVilfngwwlSIVs
         vcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6wTZ28phD5H5Nm9ztxpdzsm6xuR9rHIlsvJgNcIGMFQ=;
        b=K5nHpMXzqa2F22l3a6bNvuX+bphCFe14n4VmWGeNqgI3g27fNUyw4e0CLqEBFo903u
         2peZrFRJgwKctedokH0JtZ9t156vfm36Jutz0r+vgq1BMgxKM6KWux8dolsMP5uYp6/0
         4COay9p6ycTCeobhOl1Dk16xpdESPz6LBGY7Yp9XcaiiNuoXqiVGf5QBdUHy0gsr8ngq
         CShU/gOUbZhbyBrfhUwMudosU9qZQ7o1YwVzFl44CsrYZR9ekVzmqPYJInPq/4ndtpBu
         I69moHe8tyEM6xP2Vx8ZK/LJFSMMU6SXKd1yDLeeERYZZ6B5L9zpzQ0yIROLeDZtuAZ7
         Eo0Q==
X-Gm-Message-State: APjAAAU39m0F1QcQ87BVuVZnShzfB95Ch/mxCEVrqV5TredQ39qHrTjc
        Q0FeNup0YRMkq/AGhMXHouV1y8FjaWgWRx/kDNUsnn+9nYa/oymrTgZwfnQK648Mq/mWCIKE5Sx
        o7izRxcjmibv6RDgVOLE3uqx7ixE=
X-Received: by 2002:a24:4650:: with SMTP id j77mr994444itb.6.1552539831606;
        Wed, 13 Mar 2019 22:03:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxdE/kGCSXJXdCdl99ka4Ci9GdEmTkYJkI3muOhy0yHBSp6TjUeum+o2ZBJAVPyc0riinNmTA==
X-Received: by 2002:a24:4650:: with SMTP id j77mr994432itb.6.1552539831282;
        Wed, 13 Mar 2019 22:03:51 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id f26sm4593802ioh.55.2019.03.13.22.03.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 22:03:50 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Jacob chen <jacob2.chen@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] media: rga: fix NULL pointer dereferences, use-after-free, memory leak
Date:   Thu, 14 Mar 2019 00:03:44 -0500
Message-Id: <20190314050344.29790-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <ff11d704-489f-836e-6c9d-1b2fb5e963b6@arm.com>
References: <ff11d704-489f-836e-6c9d-1b2fb5e963b6@arm.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

1. dma_alloc_attrs, __get_free_pages can fail and return NULL.
Further uses of their return values lead to NULL pointer
dereferences

2. In the error-handling path, video_unregister_device uses
"rga->vfd" which has been freed by video_device_release

3. The error handling for v4l2_m2m_init and video_register_device
has memory-leak issues

The patch fixes the above issues.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/platform/rockchip/rga/rga.c | 26 ++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 5c653287185f..468365ceb99d 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -889,11 +889,24 @@ static int rga_probe(struct platform_device *pdev)
 	rga->cmdbuf_virt = dma_alloc_attrs(rga->dev, RGA_CMDBUF_SIZE,
 					   &rga->cmdbuf_phy, GFP_KERNEL,
 					   DMA_ATTR_WRITE_COMBINE);
+	if (!rga->cmdbuf_virt) {
+		ret = -ENOMEM;
+		goto unreg_video_dev;
+	}
 
 	rga->src_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+	if (!rga->src_mmu_pages) {
+		ret = -ENOMEM;
+		goto free_dma_attrs;
+	}
+
 	rga->dst_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+	if (!rga->dst_mmu_pages) {
+		ret = -ENOMEM;
+		goto free_dst_pages;
+	}
 
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
 	def_frame.size = def_frame.stride * def_frame.height;
@@ -901,7 +914,7 @@ static int rga_probe(struct platform_device *pdev)
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		v4l2_err(&rga->v4l2_dev, "Failed to register video device\n");
-		goto rel_vdev;
+		goto free_pages;
 	}
 
 	v4l2_info(&rga->v4l2_dev, "Registered %s as /dev/%s\n",
@@ -909,10 +922,17 @@ static int rga_probe(struct platform_device *pdev)
 
 	return 0;
 
-rel_vdev:
-	video_device_release(vfd);
+free_pages:
+	free_pages((unsigned long)rga->src_mmu_pages, 3);
+free_dst_pages:
+	free_pages((unsigned long)rga->dst_mmu_pages, 3);
+free_dma_attrs:
+	dma_free_attrs(rga->dev, RGA_CMDBUF_SIZE, rga->cmdbuf_virt,
+		       rga->cmdbuf_phy,
+		       DMA_ATTR_WRITE_COMBINE);
 unreg_video_dev:
 	video_unregister_device(rga->vfd);
+	video_device_release(vfd);
 unreg_v4l2_dev:
 	v4l2_device_unregister(&rga->v4l2_dev);
 err_put_clk:
-- 
2.17.1

