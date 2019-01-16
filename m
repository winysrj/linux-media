Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB99AC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97015206C2
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391712AbfAPMBU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:01:20 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:43562 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391660AbfAPMBT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 07:01:19 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:74b9:e8d0:a90b:6427])
        by smtp-cloud7.xs4all.net with ESMTPA
        id jjsjgM1cgBDyIjjskg25Ek; Wed, 16 Jan 2019 13:01:18 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv4 4/5] cedrus: add buf_out_validate callback
Date:   Wed, 16 Jan 2019 13:01:16 +0100
Message-Id: <20190116120117.115497-5-hverkuil-cisco@xs4all.nl>
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

Validate the field for an output buffer. This ensures that the
field is validated when the buffer is queued to a request, and
not when the request itself is queued, which is too late.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index 8721b4a7d496..b5cc79389d67 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -416,6 +416,14 @@ static void cedrus_buf_cleanup(struct vb2_buffer *vb)
 		ctx->dst_bufs[vb->index] = NULL;
 }
 
+static int cedrus_buf_out_validate(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	vbuf->field = V4L2_FIELD_NONE;
+	return 0;
+}
+
 static int cedrus_buf_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
@@ -493,6 +501,7 @@ static struct vb2_ops cedrus_qops = {
 	.buf_init		= cedrus_buf_init,
 	.buf_cleanup		= cedrus_buf_cleanup,
 	.buf_queue		= cedrus_buf_queue,
+	.buf_out_validate	= cedrus_buf_out_validate,
 	.buf_request_complete	= cedrus_buf_request_complete,
 	.start_streaming	= cedrus_start_streaming,
 	.stop_streaming		= cedrus_stop_streaming,
-- 
2.20.1

