Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2435 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbaITMmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/16] cx88: don't pollute the kernel log
Date: Sat, 20 Sep 2014 14:41:45 +0200
Message-Id: <1411216911-7950-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There is no reason to dump the sram code to the kernel log when you
stop streaming. Remove those calls to cx88_sram_channel_dump.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-vbi.c   | 2 --
 drivers/media/pci/cx88/cx88-video.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index 4e0747a..042f545 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -203,8 +203,6 @@ static void stop_streaming(struct vb2_queue *q)
 	struct cx88_dmaqueue *dmaq = &dev->vbiq;
 	unsigned long flags;
 
-	cx88_sram_channel_dump(core, &cx88_sram_channels[SRAM_CH21]);
-
 	cx_clear(MO_VID_DMACNTRL, 0x11);
 	cx_clear(VID_CAPTURE_CONTROL, 0x06);
 	cx8800_stop_vbi_dma(dev);
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index a74e21d..85c3d0c 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -563,8 +563,6 @@ static void stop_streaming(struct vb2_queue *q)
 	struct cx88_dmaqueue *dmaq = &dev->vidq;
 	unsigned long flags;
 
-	cx88_sram_channel_dump(core, &cx88_sram_channels[SRAM_CH21]);
-
 	cx_clear(MO_VID_DMACNTRL, 0x11);
 	cx_clear(VID_CAPTURE_CONTROL, 0x06);
 	spin_lock_irqsave(&dev->slock, flags);
-- 
2.1.0

