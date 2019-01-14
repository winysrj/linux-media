Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CD8C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FA03214AE
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfANNu5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:50:57 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39723 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726554AbfANNu5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 08:50:57 -0500
Received: from [IPv6:2001:983:e9a7:1:688f:f53a:651c:97b4] ([IPv6:2001:983:e9a7:1:688f:f53a:651c:97b4])
        by smtp-cloud8.xs4all.net with ESMTPA
        id j2djgCLr0NR5yj2dkgIKgn; Mon, 14 Jan 2019 14:50:56 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: disable VB2_USERPTR if dma_contig was configured
Message-ID: <e47d5235-59bf-ca8f-1409-eeb4f147d5d2@xs4all.nl>
Date:   Mon, 14 Jan 2019 14:50:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIAy8EeH3kCURMdILc8UbpkfvY1pvxbdErkfuKMosUNKol2Gs2rq4Lm6dB7+AOdA/SqFPlk0Z1zRacnMV5/GBwo2SkGl9JX6dOqK6kv9gyyxLuFh5dXn
 PhzjfWBO+NVvT4THejuimLqa+RcCG7jY02OS9p3kie+f5dglp1LSOepxS8AbnKT8igOB7yAUyud2ZhSqWC0SA5LFAuw7qkorOjKHYGOdIgufVHnveEAC0NG1
 k+CINx0mmgQIMiJYYXOPi0K3kPRpTcpc64iPuja4Wac=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It makes no sense to support the USERPTR memory model if the vivid instance was
configured as dma_contig. Disable it if this is the case.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 7da5720b47a2..29e7b14fa704 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1094,7 +1094,9 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q = &dev->vb_vid_cap_q;
 		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
 			V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
+		if (!allocator)
+			q->io_modes |= VB2_USERPTR;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_cap_qops;
@@ -1115,7 +1117,9 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q = &dev->vb_vid_out_q;
 		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
 			V4L2_BUF_TYPE_VIDEO_OUTPUT;
-		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+		q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_WRITE;
+		if (!allocator)
+			q->io_modes |= VB2_USERPTR;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_out_qops;
@@ -1136,7 +1140,9 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q = &dev->vb_vbi_cap_q;
 		q->type = dev->has_raw_vbi_cap ? V4L2_BUF_TYPE_VBI_CAPTURE :
 					      V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
-		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
+		if (!allocator)
+			q->io_modes |= VB2_USERPTR;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_cap_qops;
@@ -1157,7 +1163,9 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q = &dev->vb_vbi_out_q;
 		q->type = dev->has_raw_vbi_out ? V4L2_BUF_TYPE_VBI_OUTPUT :
 					      V4L2_BUF_TYPE_SLICED_VBI_OUTPUT;
-		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+		q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_WRITE;
+		if (!allocator)
+			q->io_modes |= VB2_USERPTR;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_out_qops;
@@ -1177,7 +1185,9 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		/* initialize sdr_cap queue */
 		q = &dev->vb_sdr_cap_q;
 		q->type = V4L2_BUF_TYPE_SDR_CAPTURE;
-		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
+		if (!allocator)
+			q->io_modes |= VB2_USERPTR;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_sdr_cap_qops;
