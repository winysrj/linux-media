Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE94C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 12:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ADBC20659
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 12:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfANM1s (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 07:27:48 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53635 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726542AbfANM1s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 07:27:48 -0500
Received: from [IPv6:2001:983:e9a7:1:688f:f53a:651c:97b4] ([IPv6:2001:983:e9a7:1:688f:f53a:651c:97b4])
        by smtp-cloud8.xs4all.net with ESMTPA
        id j1LFgBVH2NR5yj1LGgHsXp; Mon, 14 Jan 2019 13:27:46 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Helen Koike <helen.koike@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vimc: fill in correct driver name in querycap
Message-ID: <d599ea28-58b2-5c9f-d980-0213060fb27e@xs4all.nl>
Date:   Mon, 14 Jan 2019 13:27:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfGE1T5IIbCXR7H464V/+jC+z42aOJRZHG/ZYq8lR96aIpjg8SESA+eCrvvCJAX2UFTR20nrdejP64oum84dAmMmJ2VNjjFT6nY8u9iOP0/bON8/gENeF
 kv5RarVqIcE44PqUES8EdBxVl4bZy301Pnxc5SoBLmnyTu1hNs85Hv4m0rXtcv2RD8UfHK5YtSY7NVv04gb+lqxCllhkg5cEJOq0eBgy2yycp5MP8r/a+v53
 rfiLpyDdOzq980OBaWCZ2A9Hzyq4A/V8ncMrDbkLsj4p6xMMPWYjXWGt01wj0BnrK+lKKxYwBVqrqQWknNGbPw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The driver name as returned in v4l2_capabilities must be vimc, not vimc_capture.

Fix this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 3f7e9ed56633..aaeddf24b042 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -71,7 +71,7 @@ static int vimc_cap_querycap(struct file *file, void *priv,
 {
 	struct vimc_cap_device *vcap = video_drvdata(file);

-	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->driver, VIMC_PDEV_NAME, sizeof(cap->driver));
 	strscpy(cap->card, KBUILD_MODNAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "platform:%s", vcap->vdev.v4l2_dev->name);
diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
index 2e9981b18166..f491c33c7c14 100644
--- a/drivers/media/platform/vimc/vimc-common.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -22,6 +22,8 @@
 #include <media/media-device.h>
 #include <media/v4l2-device.h>

+#define VIMC_PDEV_NAME "vimc"
+
 /* VIMC-specific controls */
 #define VIMC_CID_VIMC_BASE		(0x00f00000 | 0xf000)
 #define VIMC_CID_VIMC_CLASS		(0x00f00000 | 1)
diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index ce809d2e3d53..bf19f1f9795e 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -24,7 +24,6 @@

 #include "vimc-common.h"

-#define VIMC_PDEV_NAME "vimc"
 #define VIMC_MDEV_MODEL_NAME "VIMC MDEV"

 #define VIMC_ENT_LINK(src, srcpad, sink, sinkpad, link_flags) {	\
