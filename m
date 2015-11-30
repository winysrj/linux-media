Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48285 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbbK3U1r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/11] cx23885: video instead of vbi register used
Date: Mon, 30 Nov 2015 21:27:21 +0100
Message-Id: <1448915241-415-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The VID_A_GPCNT register is for video, not vbi. Read from the right
register and don't write to the video register.

Based upon Devin's initial patch made for an older kernel which I
cleaned up and rebased. Thanks to Kernel Labs for that work.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-vbi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index cf3cb13..ab36d12 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -83,7 +83,7 @@ int cx23885_vbi_irq(struct cx23885_dev *dev, u32 status)
 	if (status & VID_BC_MSK_VBI_RISCI1) {
 		dprintk(1, "%s() VID_BC_MSK_VBI_RISCI1\n", __func__);
 		spin_lock(&dev->slock);
-		count = cx_read(VID_A_GPCNT);
+		count = cx_read(VBI_A_GPCNT);
 		cx23885_video_wakeup(dev, &dev->vbiq, count);
 		spin_unlock(&dev->slock);
 		handled++;
@@ -103,7 +103,6 @@ static int cx23885_start_vbi_dma(struct cx23885_dev    *dev,
 				VBI_LINE_LENGTH, buf->risc.dma);
 
 	/* reset counter */
-	cx_write(VID_A_GPCNT_CTL, 3);
 	cx_write(VID_A_VBI_CTRL, 3);
 	cx_write(VBI_A_GPCNT_CTL, 3);
 	q->count = 0;
-- 
2.6.2

