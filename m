Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AE5C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 08:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDBC0208E4
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 08:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfBTI7G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 03:59:06 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:51010 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbfBTI7F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 03:59:05 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id wNiWgqI62LMwIwNiZgt6VN; Wed, 20 Feb 2019 09:59:03 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Steve Longerbeam <slongerbeam@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] imx7: fix smatch error
Message-ID: <3958dde6-b934-f2d9-f522-ce2b001496d9@xs4all.nl>
Date:   Wed, 20 Feb 2019 09:59:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfP6PsS4UUm5hmGVxZLmXIWWxB8xmk0rpctAISSXEJ4uRBgYy8AVdMAIj68f4t3f0A7GBAY3xuTH2eLHfRGqOUyK4ypAfX6toNbGPo3KUTB+tv30gdOL8
 mEKgJ5uj8Iq8ZRZ8USz7JYyzddNHD+OHrhZxg754yhEl2QGAGfkpib9CCJM97Lthiz/XysC5g7dTKTusRLsOVVUqSafXTNx+LvcKpczG7CA6S5EFsw2iM3M5
 FhISY2W4C7GKzNh//JgqtQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fixes this smatch error:

drivers/staging/media/imx/imx7-mipi-csis.c:716 mipi_csis_set_fmt() error: we previously assumed 'fmt' could be null (see line 709)

fmt is never NULL, so remove the 'fmt &&' condition.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c b/drivers/staging/media/imx/imx7-mipi-csis.c
index f4674de09e83..a5f7bbc41c61 100644
--- a/drivers/staging/media/imx/imx7-mipi-csis.c
+++ b/drivers/staging/media/imx/imx7-mipi-csis.c
@@ -706,7 +706,7 @@ static int mipi_csis_set_fmt(struct v4l2_subdev *mipi_sd,
 	fmt = mipi_csis_get_format(state, cfg, sdformat->which, sdformat->pad);

 	mutex_lock(&state->lock);
-	if (fmt && sdformat->pad == CSIS_PAD_SOURCE) {
+	if (sdformat->pad == CSIS_PAD_SOURCE) {
 		sdformat->format = *fmt;
 		goto unlock;
 	}
