Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A477DC43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E1D1208E4
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfANO63 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:58:29 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41339 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726623AbfANO62 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 09:58:28 -0500
Received: from [IPv6:2001:983:e9a7:1:688f:f53a:651c:97b4] ([IPv6:2001:983:e9a7:1:688f:f53a:651c:97b4])
        by smtp-cloud8.xs4all.net with ESMTPA
        id j3h4gCzkKNR5yj3h5gIg96; Mon, 14 Jan 2019 15:58:27 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Helen Koike <helen.koike@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vimc: add USERPTR support
Message-ID: <3f07695e-b441-343d-900f-fce397484915@xs4all.nl>
Date:   Mon, 14 Jan 2019 15:58:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfLe/XnxKXuTk/yTo9qkhpQPTVV+KRwZZ0llMSvhZDlqSHkM92fneq30aavUufuqAYjTaOD49DkCe2aUBrC4pYw6/zDVBF9Gi0j2WXrQltKbT+HitTWgi
 LPOtMpS4+7+UIDmdXMbnS5dliH8w5Bg9QKpxRZMVAz7GZfqiEf2AFEU6YNgYsaAEquhApMcIT4gZ2bG+p7mkNalercIHv4+GtNdjKkFpyq9uGlx+W/jXXYZB
 eWjNtQp+FYYuSEvQ5MrA0Pw4dvDR7WumR2IgeycSwkdULHw4QkvHgo5LrBMa9VKuQzbGRXeJyBfdraGwonJ4LQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add VB2_USERPTR to the vimc capture device.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 3f7e9ed56633..35c730f484a7 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -431,7 +431,7 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 	/* Initialize the vb2 queue */
 	q = &vcap->queue;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	q->io_modes = VB2_MMAP | VB2_DMABUF;
+	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_USERPTR;
 	q->drv_priv = vcap;
 	q->buf_struct_size = sizeof(struct vimc_cap_buffer);
 	q->ops = &vimc_cap_qops;
