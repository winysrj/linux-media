Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58DCC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 06:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69D34214AF
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 06:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="KCss72o7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfCLG6d (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 02:58:33 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:57138 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfCLG6d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 02:58:33 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id F325BB3D
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 06:58:31 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id d70hPZSd5oLd for <linux-media@vger.kernel.org>;
        Tue, 12 Mar 2019 01:58:31 -0500 (CDT)
Received: from mail-it1-f198.google.com (mail-it1-f198.google.com [209.85.166.198])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id CA318B35
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 01:58:31 -0500 (CDT)
Received: by mail-it1-f198.google.com with SMTP id h3so1398761itb.4
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2019 23:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pCGxvh97NSZwHFmdL9FKNvid27SxhRAxXvSsQeHiTt8=;
        b=KCss72o7pyGTn+BGWoIpd3KWGIlxh/K7G8Jj0QOheao94X0l7w+Ybil9oRJbfS15EE
         QNrqMk6KkgJBa32vu6A5Y0161BclcBzaZ2o7tVUmCFDYIs/MI117ircrygbOcM/qPWX4
         xhyz2GALW9Kju59D1ppjba69kGvVpG+nh8sBdANDYUaRyqijjCGHGmhJNxfQTTzS3OzH
         DhR287E6uJ8wkMIdyUUyW9zK4NHzFYA7nFRvVZxHbXtMGc6b+LAYXFl5irigXzu0mFrm
         mxUDusbesdUgrti7NWEO4MSRs+8qZg5jQ1tQ/5p6BKGfJ6vMBA9e/D8m3mKaSITLBDvc
         Eu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pCGxvh97NSZwHFmdL9FKNvid27SxhRAxXvSsQeHiTt8=;
        b=SB+T9NjaS5zpE8PvkY7qI1cOgzwdkgPK7lkigNb5YQ8ZKxYfpWuv5nukq1YgE6JItk
         hB3uFR2aqbO8LOnTVp3GVfkTrg3jIALlT5tIEGNyfdzh0Z+ERRd+OBtWOOM9hQJ7LjuU
         jz0nkVXsKao5IxH90NFwVQ908B/eDcFyvLKe0d4LHZZzwnSrlo4BNVCpCOQNRSdTZT7p
         xrgXgKl4r/mDco7lT/4RnXhCR7VuENrp1rBJtKMPGqWp6YQfgg8wVEVQhwKWEq4GPoRi
         LCFKhupL6UJa0xOPXmaT8ZHP783pE+YtHIPKGixgomydwIZ+4KMZteWFGUSeT2iZiYgL
         wK6A==
X-Gm-Message-State: APjAAAXNlBbSolj3rIp65iRCBOlvcBvn2J2kVcolcfPpe47or6DLw45O
        pkNVu2Gb65x+uqwyUc3Bwo9OJtPGRsGog0GiNwvTobeiFiJbQ7I34+qqHR2UOe9qMaeFjl4tKEr
        8DRJFx2HI8NIhAyItHA+kc6sy4Kg=
X-Received: by 2002:a5d:8784:: with SMTP id f4mr18377023ion.89.1552373911329;
        Mon, 11 Mar 2019 23:58:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzhMpevobdBNj4mJJN5LIKxaBihe53DqbBLm+lFT55KQhX8iGKvtW+AA0+mBFgBRzYDsT8IjA==
X-Received: by 2002:a5d:8784:: with SMTP id f4mr18377004ion.89.1552373911041;
        Mon, 11 Mar 2019 23:58:31 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id f6sm3386315ioc.51.2019.03.11.23.58.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 23:58:30 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Jacob chen <jacob2.chen@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: rga: fix NULL pointer dereferences and a memory leak
Date:   Tue, 12 Mar 2019 01:58:24 -0500
Message-Id: <20190312065824.19646-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <6fc9f670-a199-b83d-ff0a-d4cdb8cb80d1@arm.com>
References: <6fc9f670-a199-b83d-ff0a-d4cdb8cb80d1@arm.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In case __get_free_pages fails, the fix releases resources and
return -ENOMEM to avoid NULL pointer dereferences.

Also, the fix frees pages when video_register_device fails to
avoid a memory leak.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/platform/rockchip/rga/rga.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 5c653287185f..307b7ab0ab64 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -892,8 +892,17 @@ static int rga_probe(struct platform_device *pdev)
 
 	rga->src_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+	if (!rga->src_mmu_pages) {
+		ret = -ENOMEM;
+		goto rel_vdev;
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
@@ -901,7 +910,7 @@ static int rga_probe(struct platform_device *pdev)
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret) {
 		v4l2_err(&rga->v4l2_dev, "Failed to register video device\n");
-		goto rel_vdev;
+		goto free_pages;
 	}
 
 	v4l2_info(&rga->v4l2_dev, "Registered %s as /dev/%s\n",
@@ -909,6 +918,10 @@ static int rga_probe(struct platform_device *pdev)
 
 	return 0;
 
+free_pages:
+	free_pages((unsigned long)rga->src_mmu_pages, 3);
+free_dst_pages:
+	free_pages((unsigned long)rga->dst_mmu_pages, 3);
 rel_vdev:
 	video_device_release(vfd);
 unreg_video_dev:
-- 
2.17.1

