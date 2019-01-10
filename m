Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723BFC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 10:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 451F621773
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 10:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THAXlg2C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfAJKsn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 05:48:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51095 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfAJKsn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 05:48:43 -0500
Received: by mail-wm1-f68.google.com with SMTP id n190so10773459wmd.0
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 02:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SEqzYj0HB5CCYj1hAeZ1b/ZtOohJt6dXgaMmXseqrMw=;
        b=THAXlg2CucIYlPCCDv74+Ayp82cvD4zyKgP/P4FYISvsC8lHXN7c8S9r1vZjHeqUeg
         cdVZ5Ev+3N1GsWJMKDe8rCX48cL0mIEWHVM3upFssbiO88vXQAzNNmN7W5OEDHc+kWpM
         fk7L7TROCeLm4KJhPax+jMxjRJI7YlfjvzqcKEEyhHEm77+SNWYYan76EDHluzpauExm
         9wwKMphuk7i7+tkjSINbtsw/eAR+ot08AS3QQvQ8XRau+rYXCY2/Wy3aLb25k+/xspea
         oen7B8FhoKdNQ+Xh1uhzEhEYj3xDu3GzbrEOKiRfg1En41d+36YMPM0Mn38Dif8YmAMX
         +8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SEqzYj0HB5CCYj1hAeZ1b/ZtOohJt6dXgaMmXseqrMw=;
        b=dyZSrrUeynYhe6AH6o4yNq3CmH8W7ZI7CHCm3WBd8R0BAW6CFmj8q9Wgj+CjJtPCPW
         O5ZnwTZ8GK/Tey1JFDa6rWBhyxQauRKvXOy5jPy9o9+opkEFmQRun6TUk3EGSSnfKUrR
         BrBYjdMzalaE2hKhDVwWjnRxZmEJIwW8y6PapRQrttW/1HAmIrvtnbL0u79aMhq5HSmp
         bF9kfWR2wPU3twSX7xY04YMPQWcV9CKgN+enwnRswbaoL09AkBlYXmYT9nVL8rz7MwgX
         NzYBUdUt6vnZ3lDDBBiRXm5YW3AEsS+PVE0NU+2cxgrIbSLiknl1j5CnKYbN/Y9ze9G2
         /66Q==
X-Gm-Message-State: AJcUukfCK2lz52fhKI8vaLkdx24bShTx+qD5EyhL6iXPXvx10G7RE+pM
        OWrggRUSC/1CD2ztMiOnhU0=
X-Google-Smtp-Source: ALg8bN7nvGYhLKrs5y+jLVyNL7INR8aY1k7qvKiQYzQhojcF/OhRdv5NKRohRJGfX82Nv+o1NSRqTw==
X-Received: by 2002:a1c:43:: with SMTP id 64mr9886378wma.72.1547117321662;
        Thu, 10 Jan 2019 02:48:41 -0800 (PST)
Received: from localhost (pD9E51040.dip0.t-ipconnect.de. [217.229.16.64])
        by smtp.gmail.com with ESMTPSA id c13sm62887415wrb.38.2019.01.10.02.48.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Jan 2019 02:48:41 -0800 (PST)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: v4l2-ioctl: Clear only per-plane reserved fields
Date:   Thu, 10 Jan 2019 11:48:39 +0100
Message-Id: <20190110104839.31822-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Currently the IOCTL code clears everything after the per-plane
bytesperline field in struct v4l2_format. The intent was to only clear
the per-plane reserved fields since there is data in struct v4l2_format
after the per-plane format data that userspace may have filled in.

Fixes: 4e1e0eb0e074 ("media: v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields")
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index df4259802756..e00aa2fe3e8f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1553,7 +1553,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
-			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
+			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
 		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
@@ -1583,7 +1583,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
-			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
+			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
 		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
@@ -1650,7 +1650,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
-			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
+			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
 		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
@@ -1680,7 +1680,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
-			CLEAR_AFTER_FIELD(p, fmt.pix_mp.plane_fmt[i].bytesperline);
+			CLEAR_AFTER_FIELD(&p->fmt.pix_mp.plane_fmt[i], bytesperline);
 		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!ops->vidioc_try_fmt_vid_out_overlay))
-- 
2.19.1

