Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35296C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 16:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FDA420873
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 16:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfANQX4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 11:23:56 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39720 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbfANQX4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 11:23:56 -0500
Received: from [IPv6:2001:983:e9a7:1:688f:f53a:651c:97b4] ([IPv6:2001:983:e9a7:1:688f:f53a:651c:97b4])
        by smtp-cloud9.xs4all.net with ESMTPA
        id j51kgAiodaxzfj51lgbKQF; Mon, 14 Jan 2019 17:23:54 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: take data_offset into account for video output
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <05d2c058-a268-30c2-3f5a-1e897df895d3@xs4all.nl>
Date:   Mon, 14 Jan 2019 17:23:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJa2EP6wsncr4nyNslQfIlQOarQnwxdv1TqtvTlmIKUK6AGdztFm+BcSThokDlXzz+g2PYQ8GzdFpu/kBFj7vLwdk4zYolYElP09HtZte+tDbDYIMUgM
 KanSPb2pZGBKeTGsc4lAsEd/7p8xFNNiJHctHKg+kGLb4C40tC5NpNE6/KNgLPlnzSrbJezp5/ei5rB6g0p+CKAW1flbtoXZ9YiOO24+ieVr6akVzltK8vHi
 v8iJLGExBzJjNv9YWQ6x2Ev00Mf4/FUjJuWy0UT9lyk=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The video output sizeimage calculation did not take data_offset into account.

This can cause problems with video loopback or exporting output buffers for
use as dmabuf import buffers since the output buffer size is now too small.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index e45753a1adde..53b441bdec50 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -28,11 +28,12 @@ static int vid_out_queue_setup(struct vb2_queue *vq,
 	const struct vivid_fmt *vfmt = dev->fmt_out;
 	unsigned planes = vfmt->buffers;
 	unsigned h = dev->fmt_out_rect.height;
-	unsigned size = dev->bytesperline_out[0] * h;
+	unsigned size = dev->bytesperline_out[0] * h + vfmt->data_offset[0];
 	unsigned p;

 	for (p = vfmt->buffers; p < vfmt->planes; p++)
-		size += dev->bytesperline_out[p] * h / vfmt->vdownsampling[p];
+		size += dev->bytesperline_out[p] * h / vfmt->vdownsampling[p] +
+			vfmt->data_offset[p];

 	if (dev->field_out == V4L2_FIELD_ALTERNATE) {
 		/*
@@ -62,12 +63,14 @@ static int vid_out_queue_setup(struct vb2_queue *vq,
 		if (sizes[0] < size)
 			return -EINVAL;
 		for (p = 1; p < planes; p++) {
-			if (sizes[p] < dev->bytesperline_out[p] * h)
+			if (sizes[p] < dev->bytesperline_out[p] * h +
+				       vfmt->data_offset[p])
 				return -EINVAL;
 		}
 	} else {
 		for (p = 0; p < planes; p++)
-			sizes[p] = p ? dev->bytesperline_out[p] * h : size;
+			sizes[p] = p ? dev->bytesperline_out[p] * h +
+				       vfmt->data_offset[p] : size;
 	}

 	if (vq->num_buffers + *nbuffers < 2)
@@ -330,7 +333,8 @@ int vivid_g_fmt_vid_out(struct file *file, void *priv,
 	for (p = 0; p < mp->num_planes; p++) {
 		mp->plane_fmt[p].bytesperline = dev->bytesperline_out[p];
 		mp->plane_fmt[p].sizeimage =
-			mp->plane_fmt[p].bytesperline * mp->height;
+			mp->plane_fmt[p].bytesperline * mp->height +
+			fmt->data_offset[p];
 	}
 	for (p = fmt->buffers; p < fmt->planes; p++) {
 		unsigned stride = dev->bytesperline_out[p];
@@ -408,7 +412,7 @@ int vivid_try_fmt_vid_out(struct file *file, void *priv,
 			pfmt[p].bytesperline = bytesperline;

 		pfmt[p].sizeimage = (pfmt[p].bytesperline * mp->height) /
-					fmt->vdownsampling[p];
+					fmt->vdownsampling[p] + fmt->data_offset[p];

 		memset(pfmt[p].reserved, 0, sizeof(pfmt[p].reserved));
 	}
