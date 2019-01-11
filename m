Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73C5C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 11:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78D3D20578
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 11:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfAKLnO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 06:43:14 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:54286 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729295AbfAKLnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 06:43:14 -0500
Received: from [IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a] ([IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id hvDUgsRHrNR5yhvDVg9zHg; Fri, 11 Jan 2019 12:43:13 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vim2m: the v4l2_m2m_buf_copy_data args were swapped
Message-ID: <a56725d6-c072-3cc5-5cd3-2a1de4021566@xs4all.nl>
Date:   Fri, 11 Jan 2019 12:43:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFurFdDder2d3F5RWKgS+ghf/quchv1hZ/9Ea6oayMTWAGHi9Oi73TxbwDML19bUKJxzvIAgxickcx8eZ8m0kWgaesF9ACX58un/ld5ddpsS95Uq4O+h
 0NHEDSqrtAAIxIPxWXLxYxvH66UMB5xtwyDGYGh9QvgYa8B4jyZ5MAT6wB76s+a2DoR82CTwqPHF9fEWHRHGjIzQ5Hw4h9ZFxrPVRrRMan1bmX1Evfhf9IBH
 i8qdOyo9FOSUQxrVg//QuUI9W5EW75EmhVZ0CaXYgTE=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The buffer arguments to v4l2_m2m_buf_copy_data args were swapped.

The reason is confusing naming conventions in vim2m. It certainly
could be improved.

Fixes: 7aca565ee3d0 ("media: vim2m: use v4l2_m2m_buf_copy_data")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 33397d4a1402..a7a152fb3075 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -241,7 +241,7 @@ static int device_process(struct vim2m_ctx *ctx,
 	out_vb->sequence =
 		get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
 	in_vb->sequence = q_data->sequence++;
-	v4l2_m2m_buf_copy_data(out_vb, in_vb, true);
+	v4l2_m2m_buf_copy_data(in_vb, out_vb, true);

 	switch (ctx->mode) {
 	case MEM2MEM_HFLIP | MEM2MEM_VFLIP:
