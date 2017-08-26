Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33139 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754657AbdHZKVS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 06:21:18 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org, hverkuil@xs4all.nl,
        corbet@lwn.net, kyungmin.park@samsung.com, kamil@wypas.org,
        a.hajda@samsung.com, bparrot@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 06/10] [media]: ti-vpe:  make video_device const
Date: Sat, 26 Aug 2017 15:50:08 +0530
Message-Id: <1503742812-16139-7-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503742812-16139-1-git-send-email-bhumirks@gmail.com>
References: <1503742812-16139-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/ti-vpe/cal.c | 2 +-
 drivers/media/platform/ti-vpe/vpe.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 0c7ddf8..42e383a 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1420,7 +1420,7 @@ static void cal_stop_streaming(struct vb2_queue *vq)
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-static struct video_device cal_videodev = {
+static const struct video_device cal_videodev = {
 	.name		= CAL_MODULE_NAME,
 	.fops		= &cal_fops,
 	.ioctl_ops	= &cal_ioctl_ops,
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 2873c22..45bd105 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2421,7 +2421,7 @@ static int vpe_release(struct file *file)
 	.mmap		= v4l2_m2m_fop_mmap,
 };
 
-static struct video_device vpe_videodev = {
+static const struct video_device vpe_videodev = {
 	.name		= VPE_MODULE_NAME,
 	.fops		= &vpe_fops,
 	.ioctl_ops	= &vpe_ioctl_ops,
-- 
1.9.1
