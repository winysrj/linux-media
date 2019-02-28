Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949E3C10F00
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 12:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 609EB2083D
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 12:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbfB1Mft (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 07:35:49 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:49475 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725918AbfB1Mft (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 07:35:49 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id zKuggBTbGLMwIzKuhgcTAJ; Thu, 28 Feb 2019 13:35:47 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 1/2] cobalt: replace VB2_BUF_STATE_REQUEUEING by _ERROR
Date:   Thu, 28 Feb 2019 13:35:45 +0100
Message-Id: <20190228123546.76270-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190228123546.76270-1-hverkuil-cisco@xs4all.nl>
References: <20190228123546.76270-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfGDv3lcSAipOMnayQFgYMK638BjNGZdIQd+bZqjuP6AHmgsbUC3VOc9VrS5P5yDMoF2q/N2DOutNH3mN4VMPGA8spYfXmtg7hVr45lDuUipg8K7KU332
 YlpaY/kfvFMymu61xX1L6Sm8eRL/ScnJmYoFlSrOiroK49krdR1KxXcBSFWXSvHtvUAhimywX7NavCz6SI32hoxcRivdwIEhCkdo59a8h181w6aLyvF/Nc0b
 CwrpSj7VKXtDqLn7oxjDoy2LYY4c1wkqSd9IonEp4bEfU9grL2i1qG4eD0VUlWqo
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The cobalt driver is the only driver that uses VB2_BUF_STATE_REQUEUEING.
Replace it by VB2_BUF_STATE_ERROR so we can drop support for the
REQUEUEING state.

The requeueing state was used in the cobalt driver to optimize
buffer handling while waiting for a valid signal: by requeueing
buffers internally there was no need for userspace to handle and
requeue buffers with the ERROR flag set.

However, requeueing also makes the buffer handling unordered, which
is generally a bad idea. Requeueing also does not work with requests
and any future fence support.

Since it is really a minor optimization in the cobalt driver it is
best to just return the buffer in an ERROR state. With this change
support for requeueing can now be removed in vb2.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/pci/cobalt/cobalt-irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
index 04783e78cc12..a518927abae1 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.c
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -128,7 +128,7 @@ static void cobalt_dma_stream_queue_handler(struct cobalt_stream *s)
 	cb->vb.sequence = s->sequence++;
 	vb2_buffer_done(&cb->vb.vb2_buf,
 			(skip || s->unstable_frame) ?
-			VB2_BUF_STATE_REQUEUEING : VB2_BUF_STATE_DONE);
+			VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 }
 
 irqreturn_t cobalt_irq_handler(int irq, void *dev_id)
-- 
2.20.1

