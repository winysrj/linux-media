Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36337 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbdIABvU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 21:51:20 -0400
Received: by mail-qt0-f196.google.com with SMTP id e2so1006193qta.3
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 18:51:20 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v2 10/14] [media] vivid: mark vivid queues as ordered
Date: Thu, 31 Aug 2017 22:50:37 -0300
Message-Id: <20170901015041.7757-11-gustavo@padovan.org>
In-Reply-To: <20170901015041.7757-1-gustavo@padovan.org>
References: <20170901015041.7757-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

To enable vivid to be used with explicit synchronization we need
to mark its queues as ordered. vivid queues are already ordered by
default so we no changes are needed.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 608bcceed463..239790e8ccc6 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1063,6 +1063,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
 			V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->ordered = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_cap_qops;
@@ -1083,6 +1084,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
 			V4L2_BUF_TYPE_VIDEO_OUTPUT;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+		q->ordered = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_out_qops;
@@ -1103,6 +1105,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->has_raw_vbi_cap ? V4L2_BUF_TYPE_VBI_CAPTURE :
 					      V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->ordered = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_cap_qops;
@@ -1123,6 +1126,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->has_raw_vbi_out ? V4L2_BUF_TYPE_VBI_OUTPUT :
 					      V4L2_BUF_TYPE_SLICED_VBI_OUTPUT;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+		q->ordered = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_out_qops;
@@ -1142,6 +1146,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q = &dev->vb_sdr_cap_q;
 		q->type = V4L2_BUF_TYPE_SDR_CAPTURE;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->ordered = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_sdr_cap_qops;
-- 
2.13.5
