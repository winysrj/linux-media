Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B93C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 10:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8F1B21736
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 10:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbfBRKZv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:25:51 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39024 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbfBRKZv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 05:25:51 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 35B38268AF6
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] media: v4l: ioctl: Sanitize num_planes before using it
Date:   Mon, 18 Feb 2019 07:25:42 -0300
Message-Id: <20190218102542.21776-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The linked commit changed s_fmt/try_fmt to fail if num_planes is bogus.
This, however, is against the spec, which mandates drivers
to return a proper num_planes value, without an error.

Replace the num_planes check and instead clamp it to a sane value,
so we still make sure we don't overflow the planes array by accident.

Fixes: 9048b2e15b11c5 ("media: v4l: ioctl: Validate num_planes before using it")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 90aad465f9ed..206b7348797e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1017,6 +1017,12 @@ static void v4l_sanitize_format(struct v4l2_format *fmt)
 {
 	unsigned int offset;
 
+	/* Make sure num_planes is not bogus */
+	if (fmt->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ||
+	    fmt->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		fmt->fmt.pix_mp.num_planes = min_t(u32, fmt->fmt.pix_mp.num_planes,
+					       VIDEO_MAX_PLANES);
+
 	/*
 	 * The v4l2_pix_format structure has been extended with fields that were
 	 * not previously required to be set to zero by applications. The priv
@@ -1553,8 +1559,6 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
-		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
-			break;
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
 			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i],
 					  bytesperline);
@@ -1586,8 +1590,6 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
-		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
-			break;
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
 			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i],
 					  bytesperline);
@@ -1656,8 +1658,6 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
-		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
-			break;
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
 			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i],
 					  bytesperline);
@@ -1689,8 +1689,6 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
-		if (p->fmt.pix_mp.num_planes > VIDEO_MAX_PLANES)
-			break;
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
 			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i],
 					  bytesperline);
-- 
2.20.1

