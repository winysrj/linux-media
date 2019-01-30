Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BDDC282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 13:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F0EF20989
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 13:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfA3Nid (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 08:38:33 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:36489 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbfA3Nic (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 08:38:32 -0500
Received: from [IPv6:2001:420:44c1:2579:1135:9e59:3a9c:d4ef] ([IPv6:2001:420:44c1:2579:1135:9e59:3a9c:d4ef])
        by smtp-cloud7.xs4all.net with ESMTPA
        id oq4Rg1JJEBDyIoq4VgvE9u; Wed, 30 Jan 2019 14:38:31 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH] vicodec: fill in bus_info in media_device_info
Message-ID: <38bcf20e-7156-1052-d3a2-cc8f2803e464@xs4all.nl>
Date:   Wed, 30 Jan 2019 14:38:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfC5IG9gyjVtRxQh7odyZpUwC2p2Bf90YXxr+ILG75pv2790bPRYab1couRaz/kREO0DFMSLaBiIN4nDnFJP5Ppc2oVma3Acd8q8MtAd2dHMQzuX8N9T/
 o3VHA41oN7eRqsWgp1D50cATpUBorlATtrB6Xs9PBhAaYWeP48bUSUSdHFByejmp2J6DONqsKIc4wfmvZJejYBKgZFX3Y9ha8W4KCCP8w72AyrLc+wZCa6ma
 MPSTjcOhsdaVLba6rHmZAlXHLcc5zRzriLygqP22+JbCCy/KtXQ9GNoQ5iRqxQJt
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It is good practice to fill in bus_info.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 3703b587e25e..27746ed12411 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1664,6 +1664,8 @@ static int vicodec_probe(struct platform_device *pdev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
 	strscpy(dev->mdev.model, "vicodec", sizeof(dev->mdev.model));
+	strscpy(dev->mdev.bus_info, "platform:vicodec",
+		sizeof(dev->mdev.bus_info));
 	media_device_init(&dev->mdev);
 	dev->v4l2_dev.mdev = &dev->mdev;
 #endif
