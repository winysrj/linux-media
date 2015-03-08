Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:35774 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbbCHOlS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 10:41:18 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: adi-buildroot-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 12/17] media: blackfin: bfin_capture: add support for vidioc_create_bufs
Date: Sun,  8 Mar 2015 14:40:48 +0000
Message-Id: <1425825653-14768-13-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds support for vidioc_create_bufs.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
Tested-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 2dead84..ec8227f 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -759,6 +759,7 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 	.vidioc_query_dv_timings = bcap_query_dv_timings,
 	.vidioc_enum_dv_timings  = bcap_enum_dv_timings,
 	.vidioc_reqbufs          = vb2_ioctl_reqbufs,
+	.vidioc_create_bufs      = vb2_ioctl_create_bufs,
 	.vidioc_querybuf         = vb2_ioctl_querybuf,
 	.vidioc_qbuf             = vb2_ioctl_qbuf,
 	.vidioc_dqbuf            = vb2_ioctl_dqbuf,
-- 
2.1.0

