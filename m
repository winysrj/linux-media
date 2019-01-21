Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43B1C7112F
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 11:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C45D20861
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 11:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfAULOi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 06:14:38 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:60650 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726165AbfAULOh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 06:14:37 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lXXEgXPiOBDyIlXXIgOUAH; Mon, 21 Jan 2019 12:14:36 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH] v4l2-pci-skeleton.c: fix outdated irq code
Message-ID: <d9fd807d-2a58-c2d4-2b51-3bb8b475a3bb@xs4all.nl>
Date:   Mon, 21 Jan 2019 12:14:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFnkTqSZqr9Jy10W4dEoyzuSDNZSMFwUYAOTsmLJhigHu5HgCsrXBBcwMR7v8liaDKLRMHEd8r2tTzghiphn6gWvYH/Wt1pZl/Bvstr8pyfkVusKC1cB
 MeP04QiIq41jUFFkb344uOMfJfn5ci/bgOsGDKiBt3JEOoU0gFwWWIrOfNjiaAbTFuBMqEjvE/WTOw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix the outdated irq example code. It is under an #ifdef TODO
so it is never actually compiled and this code was never compiled.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/samples/v4l/v4l2-pci-skeleton.c b/samples/v4l/v4l2-pci-skeleton.c
index 27ec30952cfa..758ced8c3d06 100644
--- a/samples/v4l/v4l2-pci-skeleton.c
+++ b/samples/v4l/v4l2-pci-skeleton.c
@@ -139,16 +139,16 @@ static irqreturn_t skeleton_irq(int irq, void *dev_id)
 		spin_lock(&skel->qlock);
 		list_del(&new_buf->list);
 		spin_unlock(&skel->qlock);
-		v4l2_get_timestamp(&new_buf->vb.v4l2_buf.timestamp);
-		new_buf->vb.v4l2_buf.sequence = skel->sequence++;
-		new_buf->vb.v4l2_buf.field = skel->field;
+		new_buf->vb.vb2_buf.timestamp = ktime_get_ns();
+		new_buf->vb.sequence = skel->sequence++;
+		new_buf->vb.field = skel->field;
 		if (skel->format.field == V4L2_FIELD_ALTERNATE) {
 			if (skel->field == V4L2_FIELD_BOTTOM)
 				skel->field = V4L2_FIELD_TOP;
 			else if (skel->field == V4L2_FIELD_TOP)
 				skel->field = V4L2_FIELD_BOTTOM;
 		}
-		vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_DONE);
+		vb2_buffer_done(&new_buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
 	}
 #endif
 	return IRQ_HANDLED;
