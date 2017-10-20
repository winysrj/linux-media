Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:55578 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753184AbdJTVu5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:50:57 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v4 10/17] [media] vivid: mark vivid queues as ordered_in_driver
Date: Fri, 20 Oct 2017 19:50:05 -0200
Message-Id: <20171020215012.20646-11-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

To enable vivid to be used with explicit synchronization we need
to mark its queues as ordered. vivid queues are already ordered by
default so we no changes are needed.

v2: rename 'ordered' to 'ordered_in_driver' to avoid confusion.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com> (v1)
---
 drivers/media/platform/vivid/vivid-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 608bcceed463..1f7702faea7d 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1063,6 +1063,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
 			V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->ordered_in_driver = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_cap_qops;
@@ -1083,6 +1084,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
 			V4L2_BUF_TYPE_VIDEO_OUTPUT;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+		q->ordered_in_driver = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_out_qops;
@@ -1103,6 +1105,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->has_raw_vbi_cap ? V4L2_BUF_TYPE_VBI_CAPTURE :
 					      V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->ordered_in_driver = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_cap_qops;
@@ -1123,6 +1126,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->type = dev->has_raw_vbi_out ? V4L2_BUF_TYPE_VBI_OUTPUT :
 					      V4L2_BUF_TYPE_SLICED_VBI_OUTPUT;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+		q->ordered_in_driver = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_out_qops;
@@ -1142,6 +1146,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q = &dev->vb_sdr_cap_q;
 		q->type = V4L2_BUF_TYPE_SDR_CAPTURE;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->ordered_in_driver = 1;
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_sdr_cap_qops;
-- 
2.13.6
