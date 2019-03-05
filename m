Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C26BC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29829206DD
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfCEJ6z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 04:58:55 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59281 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727401AbfCEJ6y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 04:58:54 -0500
Received: from test-no.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 16qVhtdVBLMwI16qahrct0; Tue, 05 Mar 2019 10:58:52 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 3/9] vivid: use vzalloc for dev->bitmap_out
Date:   Tue,  5 Mar 2019 10:58:41 +0100
Message-Id: <20190305095847.21428-4-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfP+uY9uGQYe20y5TGuTJqaR1zB8TGzHZINr7yBiK0P7Q/AhAt1T1lYldFKqjWoC51MuN/RZdoEhi8FCg/8rXZV4ZU/kx55IbUacHm5wv8+GFEGt0O0jx
 nDSXLgWi5xm34zC5xkThlbZsuXcyG39PofBCS5yyhiMTEMUktaBe/oEwU7JJN6jV3dfEhuHsQi17yvr9okq7c8fv2P23dIkQns0gvrZS76YvNobC5f0nCCIh
 1B9yKdJG1JxnFnvP1aTSVjV+ty2ih3ViE1YKg9+MBI2xGAbcnSSuh+QmvMZ0m/mvE6nrl7eWbLwPqBYREdVkfQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

When vivid is unloaded it used vfree to free dev->bitmap_out,
but it was actually allocated using kmalloc. Use vzalloc
instead, conform what vivid-vid-cap.c does.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vivid/vivid-vid-out.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index e61b91b414f9..9350ca65dd91 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -798,7 +798,7 @@ int vivid_vid_out_s_selection(struct file *file, void *fh, struct v4l2_selection
 		s->r.height *= factor;
 		if (dev->bitmap_out && (compose->width != s->r.width ||
 					compose->height != s->r.height)) {
-			kfree(dev->bitmap_out);
+			vfree(dev->bitmap_out);
 			dev->bitmap_out = NULL;
 		}
 		*compose = s->r;
@@ -941,15 +941,19 @@ int vidioc_s_fmt_vid_out_overlay(struct file *file, void *priv,
 		return ret;
 
 	if (win->bitmap) {
-		new_bitmap = memdup_user(win->bitmap, bitmap_size);
+		new_bitmap = vzalloc(bitmap_size);
 
-		if (IS_ERR(new_bitmap))
-			return PTR_ERR(new_bitmap);
+		if (!new_bitmap)
+			return -ENOMEM;
+		if (copy_from_user(new_bitmap, win->bitmap, bitmap_size)) {
+			vfree(new_bitmap);
+			return -EFAULT;
+		}
 	}
 
 	dev->overlay_out_top = win->w.top;
 	dev->overlay_out_left = win->w.left;
-	kfree(dev->bitmap_out);
+	vfree(dev->bitmap_out);
 	dev->bitmap_out = new_bitmap;
 	dev->clipcount_out = win->clipcount;
 	if (dev->clipcount_out)
-- 
2.20.1

