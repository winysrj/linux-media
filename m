Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916DCC169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 14:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6765A20869
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 14:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfAaOJh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 09:09:37 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59137 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbfAaOJh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 09:09:37 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id pD24gDRJGNR5ypD27gQXu6; Thu, 31 Jan 2019 15:09:35 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] videobuf2: remove unused variable
Message-ID: <bee3b3cf-a125-0e80-688a-351b442f142c@xs4all.nl>
Date:   Thu, 31 Jan 2019 15:09:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJrOZM3ELaoRFcOxhk7BgrG5Mk03lv7IjukFTbYoxuDFMDQXm8sP9ijej4LhiVUsRS4FwWAD/w2soCPhw16Cg+OIYbfBrhxJ2OMxYc/QRcOAT8SwVG/J
 iAJheSfMNtfLHor90CFk+Cbzufcny2rdsEo/2eRtzIUGbOnd/XmBrfmTuldGsvQ353gr96Am8jG48Q==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Commit 2cc1802f62e5 ("media: vb2: Keep dma-buf buffers mapped until
they are freed") removed code leaving a local variable unused.

Remove it to avoid a compiler warning.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 2cc1802f62e5 ("media: vb2: Keep dma-buf buffers mapped until they are freed")
---
 drivers/media/common/videobuf2/videobuf2-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index e07b6bdb6982..34cc87ca8d59 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1769,7 +1769,6 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
 static void __vb2_dqbuf(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int i;

 	/* nothing to do if the buffer is already dequeued */
 	if (vb->state == VB2_BUF_STATE_DEQUEUED)
-- 
2.20.1

