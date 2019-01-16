Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DB2C43612
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16C75206C2
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391733AbfAPMBU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:01:20 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:39884 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391670AbfAPMBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 07:01:20 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:74b9:e8d0:a90b:6427])
        by smtp-cloud7.xs4all.net with ESMTPA
        id jjsjgM1cgBDyIjjskg25Eq; Wed, 16 Jan 2019 13:01:18 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 5/5] vb2: check that buf_out_validate is present
Date:   Wed, 16 Jan 2019 13:01:17 +0100
Message-Id: <20190116120117.115497-6-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190116120117.115497-1-hverkuil-cisco@xs4all.nl>
References: <20190116120117.115497-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBj8lAB0oiU2KUkh3EW3EDB3KSZYkuyY+QTIamDtCj+ZAvkhTG2KB1Xvp/nnp1waQUxHrhHoSUODVOyzW/u0YuItTYVUZc9RvAiOCvigq6i18+DRjsbd
 fi5SthN7q0hxFo2l3/Hu4v7iQrI9LT6yTXbd3+HNlJbzaD432opb2xOEqOoU31iw+C6CWCIMwCj4xbL0Ea3gVcVvkD52k4JmneCRLiRlko4Qw8e/bWQjPFsr
 xhMEnqGSuutANaT0i7P2oCfbfAmYqw5jUtChmiUg5P6MgN3eupkrFAFZs3VckeeTg+5zVZN9jf7VsFZfUX0lZ9+BZcswpKYwQQn/8xgq1riW1rO3fNDhE8NB
 VV1qYebU6MifyMNtqklWQX/kzZu1iA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The buf_out_validate is required for output queues in combination
with requests. Check this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 75ea90e795d8..653869031b71 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -409,6 +409,13 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 	 */
 	if (WARN_ON(!q->ops->buf_request_complete))
 		return -EINVAL;
+	/*
+	 * Make sure this op is implemented by the driver for the output queue.
+	 * It's easy to forget this callback, but is it important to correctly
+	 * validate the 'field' value at QBUF time.
+	 */
+	if (WARN_ON(q->is_output && !q->ops->buf_out_validate))
+		return -EINVAL;
 
 	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
 		dprintk(1, "%s: buffer is not in dequeued state\n", opname);
-- 
2.20.1

