Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDE8C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DABC218D0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfAYPXv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:23:51 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:56803 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbfAYPXv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 10:23:51 -0500
Received: from [IPv6:2001:420:44c1:2579:d4cf:253b:d711:6098] ([IPv6:2001:420:44c1:2579:d4cf:253b:d711:6098])
        by smtp-cloud8.xs4all.net with ESMTPA
        id n3Kbgk8sxNR5yn3Kfgw6FK; Fri, 25 Jan 2019 16:23:49 +0100
Subject: [PATCHv4.1 5/5] vb2: check that buf_out_validate is present
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
References: <20190116120117.115497-1-hverkuil-cisco@xs4all.nl>
 <20190116120117.115497-6-hverkuil-cisco@xs4all.nl>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <b7debbf9-bd3d-580e-67a1-878946357e58@xs4all.nl>
Date:   Fri, 25 Jan 2019 16:23:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190116120117.115497-6-hverkuil-cisco@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEpXf7j2CzUR3LUm1DuPZr3dgJkywvtGpDpOyYxuWv6XFYUqA0k0dN9zil9hd5hKOIqRA9YGYPBXG41C4CjSPn6j0IYoViJwVjs6QmEyhZjV3boh/33N
 AhV/61FI7NaPU3dluxm5W6d5t5+HT5MbwilGLQH5faJI7RRKyxJXKVqw+EXpF3Ze0SR67qVjscHE9H3sFrE36rY1HS1/JO14lfJRYO0p4KrirPbmAAgAGwoD
 0cA1x1kE/pRI9Pu3BrUonmL3K0W1DCKE29aRYnACpDS9tpEosoCFMoJ3dtUCtK28Q45TRGZPeMTq2m1+cmLf8/cBo8ME/iszHcxKvhbxTsWtsnfRvhUH71Zn
 y1Al5ncnHrazfznI/tRGaIWzSyYAfg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The buf_out_validate is required for output queues in combination
with requests. Check this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Changes since v4:

- Check for VIDEO_OUTPUT types instead of q->is_output since this is not
  relevant for e.g. VBI outputs.
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 2f3b3ca5bde6..3aeaea3af42a 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -409,6 +409,15 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 	 */
 	if (WARN_ON(!q->ops->buf_request_complete))
 		return -EINVAL;
+	/*
+	 * Make sure this op is implemented by the driver for the output queue.
+	 * It's easy to forget this callback, but is it important to correctly
+	 * validate the 'field' value at QBUF time.
+	 */
+	if (WARN_ON((q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+		     q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
+		    !q->ops->buf_out_validate))
+		return -EINVAL;

 	if (vb->state != VB2_BUF_STATE_DEQUEUED) {
 		dprintk(1, "%s: buffer is not in dequeued state\n", opname);
-- 
2.20.1
