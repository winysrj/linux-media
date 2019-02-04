Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A294DC282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 17:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 767CF2080F
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 17:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfBDRiv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 12:38:51 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35484 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbfBDRiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2019 12:38:50 -0500
Received: from collabora-tonyk.home (unknown [IPv6:2804:431:d719:283a:b343:652b:e214:3dca])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tonyk)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 46ADC27FD1F;
        Mon,  4 Feb 2019 17:38:47 +0000 (GMT)
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andre.almeida@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, kernel@collabora.com
Subject: [PATCH] vivid: add vertical down sampling to imagesize calc
Date:   Mon,  4 Feb 2019 15:37:33 -0200
Message-Id: <20190204173733.602-1-andre.almeida@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

To correctly set the size of the image in a plane, it's needed
to divide the height of image by the vertical down sampling factor.
This was only happening in vivid_try_fmt_vid_cap(), but now it
applied in others sizeimage calculations as well.

Signed-off-by: André Almeida <andre.almeida@collabora.com>
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index c059fc12668a..52eeda624d7e 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -124,7 +124,8 @@ static int vid_cap_queue_setup(struct vb2_queue *vq,
 		}
 	} else {
 		for (p = 0; p < buffers; p++)
-			sizes[p] = tpg_g_line_width(&dev->tpg, p) * h +
+			sizes[p] = (tpg_g_line_width(&dev->tpg, p) * h) /
+					dev->fmt_cap->vdownsampling[p] +
 					dev->fmt_cap->data_offset[p];
 	}
 
@@ -161,7 +162,9 @@ static int vid_cap_buf_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 	for (p = 0; p < buffers; p++) {
-		size = tpg_g_line_width(&dev->tpg, p) * dev->fmt_cap_rect.height +
+		size = (tpg_g_line_width(&dev->tpg, p) *
+			dev->fmt_cap_rect.height) /
+			dev->fmt_cap->vdownsampling[p] +
 			dev->fmt_cap->data_offset[p];
 
 		if (vb2_plane_size(vb, p) < size) {
@@ -545,7 +548,8 @@ int vivid_g_fmt_vid_cap(struct file *file, void *priv,
 	for (p = 0; p < mp->num_planes; p++) {
 		mp->plane_fmt[p].bytesperline = tpg_g_bytesperline(&dev->tpg, p);
 		mp->plane_fmt[p].sizeimage =
-			tpg_g_line_width(&dev->tpg, p) * mp->height +
+			(tpg_g_line_width(&dev->tpg, p) * mp->height) /
+			dev->fmt_cap->vdownsampling[p] +
 			dev->fmt_cap->data_offset[p];
 	}
 	return 0;
-- 
2.20.1

