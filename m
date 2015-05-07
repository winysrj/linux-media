Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58103 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbbEGGW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2015 02:22:29 -0400
Message-ID: <554B0496.7050902@xs4all.nl>
Date: Thu, 07 May 2015 08:22:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] sta2x11: use monotonic timestamp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 drivers should use MONOTONIC timestamps instead of gettimeofday, which is
affected by daylight savings time.

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index d384a6b..59b3a36 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -813,7 +813,7 @@ static irqreturn_t vip_irq(int irq, struct sta2x11_vip *vip)
 		/* Disable acquisition */
 		reg_write(vip, DVP_CTL, reg_read(vip, DVP_CTL) & ~DVP_CTL_ENA);
 		/* Remove the active buffer from the list */
-		do_gettimeofday(&vip->active->vb.v4l2_buf.timestamp);
+		v4l2_get_timestamp(&vip->active->vb.v4l2_buf.timestamp);
 		vip->active->vb.v4l2_buf.sequence = vip->sequence++;
 		vb2_buffer_done(&vip->active->vb, VB2_BUF_STATE_DONE);
 	}
@@ -864,6 +864,7 @@ static int sta2x11_vip_init_buffer(struct sta2x11_vip *vip)
 	vip->vb_vidq.buf_struct_size = sizeof(struct vip_buffer);
 	vip->vb_vidq.ops = &vip_video_qops;
 	vip->vb_vidq.mem_ops = &vb2_dma_contig_memops;
+	vip->vb_vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	err = vb2_queue_init(&vip->vb_vidq);
 	if (err)
 		return err;
