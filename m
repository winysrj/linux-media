Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA54EC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 08:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACA9D2229F
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 08:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390200AbfBNIif (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:38:35 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44143 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388545AbfBNIif (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 03:38:35 -0500
X-Originating-IP: 90.88.30.68
Received: from localhost.localdomain (aaubervilliers-681-1-89-68.w90-88.abo.wanadoo.fr [90.88.30.68])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 6F28CC0003;
        Thu, 14 Feb 2019 08:38:22 +0000 (UTC)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH] media: cedrus: Forbid setting new formats on busy queues
Date:   Thu, 14 Feb 2019 09:37:31 +0100
Message-Id: <20190214083731.16230-1-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Check that our queues are not busy before setting the format or return
EBUSY if that's the case. This ensures that our format can't change
once buffers are allocated for the queue.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index b5cc79389d67..3420a938a613 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -282,8 +282,15 @@ static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
 	struct cedrus_dev *dev = ctx->dev;
+	struct vb2_queue *vq;
 	int ret;
 
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+	else if (vb2_is_busy(vq))
+		return -EBUSY;
+
 	ret = cedrus_try_fmt_vid_cap(file, priv, f);
 	if (ret)
 		return ret;
@@ -299,8 +306,15 @@ static int cedrus_s_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
+	struct vb2_queue *vq;
 	int ret;
 
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+	else if (vb2_is_busy(vq))
+		return -EBUSY;
+
 	ret = cedrus_try_fmt_vid_out(file, priv, f);
 	if (ret)
 		return ret;
-- 
2.20.1

