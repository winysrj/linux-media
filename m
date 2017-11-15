Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:54299 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933281AbdKORLW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 12:11:22 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v5 04/11] [media] vivid: mark vivid queues as ordered_in_driver
Date: Wed, 15 Nov 2017 15:10:50 -0200
Message-Id: <20171115171057.17340-5-gustavo@padovan.org>
In-Reply-To: <20171115171057.17340-1-gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

ordered_in_driver is used to optimize the use of explicit synchronization
when the driver guarantees ordering we can use the same fence context for
out-fences. In this case userspace will know that the buffers won't be
signaling out of order. vivid queues are already ordered by default so no
changes are needed.

v2: rename 'ordered' to 'ordered_in_driver' to avoid confusion.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/platform/vivid/vivid-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index f19391fa2d6a..1b830ebe1cd8 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1068,6 +1068,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
 			V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->ordered_in_driver = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_cap_qops;
@@ -1088,6 +1089,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
 			V4L2_BUF_TYPE_VIDEO_OUTPUT;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+		q->ordered_in_driver = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_out_qops;
@@ -1108,6 +1110,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->has_raw_vbi_cap ? V4L2_BUF_TYPE_VBI_CAPTURE :
 					      V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->ordered_in_driver = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_cap_qops;
@@ -1128,6 +1131,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->has_raw_vbi_out ? V4L2_BUF_TYPE_VBI_OUTPUT :
 					      V4L2_BUF_TYPE_SLICED_VBI_OUTPUT;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+		q->ordered_in_driver = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_out_qops;
@@ -1147,6 +1151,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q = &dev->vb_sdr_cap_q;
 		q->type = V4L2_BUF_TYPE_SDR_CAPTURE;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->ordered_in_driver = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_sdr_cap_qops;
-- 
2.13.6
