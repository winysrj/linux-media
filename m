Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D413FC282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 13:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9AA21473
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 13:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfA3Nn4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 08:43:56 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:46071 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725859AbfA3Nn4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 08:43:56 -0500
Received: from [IPv6:2001:420:44c1:2579:1135:9e59:3a9c:d4ef] ([IPv6:2001:420:44c1:2579:1135:9e59:3a9c:d4ef])
        by smtp-cloud7.xs4all.net with ESMTPA
        id oq9fg1LUDBDyIoq9igvFPd; Wed, 30 Jan 2019 14:43:54 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Helen Koike <helen.koike@collabora.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH] vimc: fill in bus_info in media_device_info
Message-ID: <37987a95-dc03-aee7-57d3-d7a85cc2fc59@xs4all.nl>
Date:   Wed, 30 Jan 2019 14:43:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEPTC93jqGRdA/ntVzNvtoDZHyNQhAYxztwZ/zGXnxb4Q0wPn6YHVT1GQCqV54WY6uRz71gQ8Hss9naKHqqCDpyJEsGWDoU87WYfm2swkKulcGHuoUnl
 UGR676kxMmj6nMUlBBPlm2I/bYLSjOv3IEQ2oILQ8PPXKMDEPnM+Q8EjayxgSHP19eCKn1Dop+2S2+Af+Xd7OAoLGgAV+caK3S4fngJk5CG3qeQZg5qJvABb
 hceUDS3N0xdgqV7aD1GL+Ungg2TblDBe8ORyxQKlXN30sCZpk4/B4GYK7Ri72Zav3lrJ20SXS3343X10zhnnWpCrDvgJfqZ2+utTUSYE03g=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It is good practice to fill in bus_info.

Also just use 'platform:vimc' when filling in the bus_info in querycap:
the bus_info has nothing to do with the video device name.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index aaeddf24b042..550aa426ae5e 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -69,12 +69,10 @@ struct vimc_cap_buffer {
 static int vimc_cap_querycap(struct file *file, void *priv,
 			     struct v4l2_capability *cap)
 {
-	struct vimc_cap_device *vcap = video_drvdata(file);
-
 	strscpy(cap->driver, VIMC_PDEV_NAME, sizeof(cap->driver));
 	strscpy(cap->card, KBUILD_MODNAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
-		 "platform:%s", vcap->vdev.v4l2_dev->name);
+		 "platform:%s", VIMC_PDEV_NAME);

 	return 0;
 }
diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index bf19f1f9795e..c2fdf3ea67ed 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -318,6 +318,8 @@ static int vimc_probe(struct platform_device *pdev)
 	/* Initialize media device */
 	strscpy(vimc->mdev.model, VIMC_MDEV_MODEL_NAME,
 		sizeof(vimc->mdev.model));
+	snprintf(vimc->mdev.bus_info, sizeof(vimc->mdev.bus_info),
+		 "platform:%s", VIMC_PDEV_NAME);
 	vimc->mdev.dev = &pdev->dev;
 	media_device_init(&vimc->mdev);

