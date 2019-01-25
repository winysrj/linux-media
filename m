Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9D7C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BDAA218F0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 15:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfAYPkJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:40:09 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:58702 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbfAYPkJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 10:40:09 -0500
Received: from [IPv6:2001:420:44c1:2579:d4cf:253b:d711:6098] ([IPv6:2001:420:44c1:2579:d4cf:253b:d711:6098])
        by smtp-cloud8.xs4all.net with ESMTPA
        id n3aOgkMKbNR5yn3aRgwCB5; Fri, 25 Jan 2019 16:40:08 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fix vid_out_buf_prepare()
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <edacd7c9-a651-901f-ac41-3bda20b7e642@xs4all.nl>
Date:   Fri, 25 Jan 2019 16:40:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAiMRPpgq7wEGQvrGXBV+/BSwfpRSnphnS1u33OCWdKtR8y+o0ZfEQxmsmn9krHVhDFntjcrgooFfv2Iw6iytlPr8s7FNzYUX9D7y0OuC4dMW624ayt+
 EGTBFFIq6ZN7OmrDL6dha8wiw6VJbyipFJH9ycbuBr+jEEOSHKlqfFKQWhzGlYObN+9hr6Mdo2850yjfxUJb9aoqetjOCnzBVvnKDMJOcBhzMUl6vhv3fsDx
 b+iVyqGVL7D2HYQxQv+yI8m3LsXap3jM7+FA30PdhhxR+MIHb7qBtiS5ozy35OeQ
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The wrong size check was performed for output formats like NV24 which
set vfmt->buffers to 1, but vfmt->planes is 2. It was incorrectly
checking the payload size for plane 1, which doesn't exist.

Note: vfmt->buffers refers to the number of per-plane-buffers that
should be allocated. vfmt->planes refers to the number of planes
that make up an image. vfmt->planes may be > vfmt->buffers.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index e45753a1adde..54e8fb23e336 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -99,17 +99,20 @@ static int vid_out_buf_out_validate(struct vb2_buffer *vb)
 static int vid_out_buf_prepare(struct vb2_buffer *vb)
 {
 	struct vivid_dev *dev = vb2_get_drv_priv(vb->vb2_queue);
-	unsigned long size;
-	unsigned planes;
+	const struct vivid_fmt *vfmt = dev->fmt_out;
+	unsigned planes = vfmt->buffers;
+	unsigned h = dev->fmt_out_rect.height;
+	unsigned size = dev->bytesperline_out[0] * h;
 	unsigned p;

+	for (p = vfmt->buffers; p < vfmt->planes; p++)
+		size += dev->bytesperline_out[p] * h / vfmt->vdownsampling[p];
+
 	dprintk(dev, 1, "%s\n", __func__);

 	if (WARN_ON(NULL == dev->fmt_out))
 		return -EINVAL;

-	planes = dev->fmt_out->planes;
-
 	if (dev->buf_prepare_error) {
 		/*
 		 * Error injection: test what happens if buf_prepare() returns
@@ -120,11 +123,12 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 	}

 	for (p = 0; p < planes; p++) {
-		size = dev->bytesperline_out[p] * dev->fmt_out_rect.height +
-			vb->planes[p].data_offset;
+		if (p)
+			size = dev->bytesperline_out[p] * h;
+		size += vb->planes[p].data_offset;

 		if (vb2_get_plane_payload(vb, p) < size) {
-			dprintk(dev, 1, "%s the payload is too small for plane %u (%lu < %lu)\n",
+			dprintk(dev, 1, "%s the payload is too small for plane %u (%lu < %u)\n",
 					__func__, p, vb2_get_plane_payload(vb, p), size);
 			return -EINVAL;
 		}
