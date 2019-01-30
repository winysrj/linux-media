Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311EAC282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 13:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C55320855
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 13:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731245AbfA3NjW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 08:39:22 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:51720 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729193AbfA3NjW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 08:39:22 -0500
Received: from [IPv6:2001:420:44c1:2579:1135:9e59:3a9c:d4ef] ([IPv6:2001:420:44c1:2579:1135:9e59:3a9c:d4ef])
        by smtp-cloud7.xs4all.net with ESMTPA
        id oq5Fg1JcFBDyIoq5IgvEKb; Wed, 30 Jan 2019 14:39:20 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH] vim2m: fill in bus_info in media_device_info
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <c1dc108c-c958-5032-67ba-1fb7a34730f8@xs4all.nl>
Date:   Wed, 30 Jan 2019 14:39:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIlV/Me0DjCFgRrvuAJPtp6SYJUY/HzCitRnt9VjW3sjEC2cpI9f4ZuW5QTRwLFWS6F6zAfGDjzXwhzB8zt5CihjniiG9wRiv3Ii/LoY4d7quRvMKAJK
 hZtDopUseZzfih7o6+e/iKSRthMf8wVoaxbxquLdgGJp7W3pLROAXbiUrwoiusoMEkuIaeZpfekQOuQWsPT3e/LoTyWO+/KZDQ379xh0ZrNPXgLrF2Vil0Jx
 6zpp2unruOSAm5OuF7rmk8/lfSkZR5My/VeQCuh8X5rQPH4sGzZA2RoA02PbV7Pn
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It is good practice to fill in the bus_info.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 0e7814b2327e..4055aabf2a5e 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1155,6 +1155,7 @@ static int vim2m_probe(struct platform_device *pdev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
 	strscpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
+	strscpy(dev->mdev.bus_info, "platform:vim2m", sizeof(dev->mdev.bus_info));
 	media_device_init(&dev->mdev);
 	dev->mdev.ops = &m2m_media_ops;
 	dev->v4l2_dev.mdev = &dev->mdev;

