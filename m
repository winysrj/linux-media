Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:51944 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760420AbcLPLr5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 06:47:57 -0500
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kyungmin.park@samsung.com, jtp.park@samsung.com,
        mchehab@kernel.org, mchehab@osg.samsung.com,
        hans.verkuil@cisco.com, krzk@kernel.org, kgene@kernel.org,
        javier@osg.samsung.com, Smitha T Murthy <smitha.t@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 1/2] media: s5p-mfc: convert drivers to use the new vb2_queue
 dev field
Date: Fri, 16 Dec 2016 17:18:34 +0530
Message-id: <1481888915-19624-2-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1481888915-19624-1-git-send-email-pankaj.dubey@samsung.com>
References: <1481888915-19624-1-git-send-email-pankaj.dubey@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Smitha T Murthy <smitha.t@samsung.com>

commit 2548fee63d9e ("[media] media/platform: convert drivers to use the new
vb2_queue dev field") has missed to set dev pointer of vb2_queue which will be
used in reqbufs of mfc driver. Without this change following error is observed:

---------------------------------------------------------------
V4L2 Codec decoding example application
Kamil Debski <k.debski@samsung.com>
Copyright 2012 Samsung Electronics Co., Ltd.

Opening MFC.
(mfc.c:mfc_open:58): MFC Info (/dev/video0): driver="s5p-mfc" \
bus_info="platform:12c30000.mfc0" card="s5p-mfc-dec" fd=0x4[
42.339165] Remapping memory failed, error: -6

MFC Open Success.
(main.c:main:711): Successfully opened all necessary files and devices
(mfc.c:mfc_dec_setup_output:103): Setup MFC decoding OUTPUT buffer \
size=4194304 (requested=4194304)
(mfc.c:mfc_dec_setup_output:120): Number of MFC OUTPUT buffers is 2 \
(requested 2)

[App] Out buf phy : 0x00000000, virt : 0xffffffff
Output Length is = 0x300000
Error (mfc.c:mfc_dec_setup_output:145): Failed to MMAP MFC OUTPUT buffer
-------------------------------------------------------

Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
[pankaj.dubey: debugging issue and formatting commit message]
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 0a5b8f5..6ea8246 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -838,6 +838,7 @@ static int s5p_mfc_open(struct file *file)
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	q->drv_priv = &ctx->fh;
 	q->lock = &dev->mfc_mutex;
+	q->dev = &dev->plat_dev->dev;
 	if (vdev == dev->vfd_dec) {
 		q->io_modes = VB2_MMAP;
 		q->ops = get_dec_queue_ops();
@@ -861,6 +862,7 @@ static int s5p_mfc_open(struct file *file)
 	q->io_modes = VB2_MMAP;
 	q->drv_priv = &ctx->fh;
 	q->lock = &dev->mfc_mutex;
+	q->dev = &dev->plat_dev->dev;
 	if (vdev == dev->vfd_dec) {
 		q->io_modes = VB2_MMAP;
 		q->ops = get_dec_queue_ops();
-- 
2.7.4

