Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9FAIVTw005929
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 06:18:31 -0400
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9FAHpAV003020
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 06:18:21 -0400
Received: by mu-out-0910.google.com with SMTP id g7so2644558muf.1
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 03:18:20 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Wed, 15 Oct 2008 19:17:09 +0900
Message-Id: <20081015101709.22905.30106.sendpatchset@rx1.opensource.se>
Cc: v4l-dvb-maintainer@linuxtv.org, g.liakhovetski@gmx.de,
	mchehab@infradead.org
Subject: [PATCH] video: improve sh_mobile_ceu buffer handling
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Magnus Damm <damm@igel.co.jp>

This patch improves the buffer handling in the sh_mobile_ceu driver.

Instead of marking all queued buffers as VIDEOBUF_ACTIVE the code now
marks queued-but-not-active buffers as VIDEOBUF_QUEUED and buffers
involved in dma as VIDEOBUF_ACTIVE. The code is also updated with
code to cancel active buffers, thanks to Morimoto-san.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Test-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
---

 drivers/media/video/sh_mobile_ceu_camera.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- 0004/drivers/media/video/sh_mobile_ceu_camera.c
+++ work/drivers/media/video/sh_mobile_ceu_camera.c	2008-10-15 18:26:29.000000000 +0900
@@ -165,6 +165,7 @@ static void sh_mobile_ceu_capture(struct
 	ceu_write(pcdev, CETCR, 0x0317f313 ^ 0x10);
 
 	if (pcdev->active) {
+		pcdev->active->state = VIDEOBUF_ACTIVE;
 		ceu_write(pcdev, CDAYR, videobuf_to_dma_contig(pcdev->active));
 		ceu_write(pcdev, CAPSR, 0x1); /* start capture */
 	}
@@ -236,7 +237,7 @@ static void sh_mobile_ceu_videobuf_queue
 	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
-	vb->state = VIDEOBUF_ACTIVE;
+	vb->state = VIDEOBUF_QUEUED;
 	spin_lock_irqsave(&pcdev->lock, flags);
 	list_add_tail(&vb->queue, &pcdev->capture);
 
@@ -323,12 +324,24 @@ static void sh_mobile_ceu_remove_device(
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	unsigned long flags;
 
 	BUG_ON(icd != pcdev->icd);
 
 	/* disable capture, disable interrupts */
 	ceu_write(pcdev, CEIER, 0);
 	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
+
+	/* make sure active buffer is canceled */
+	spin_lock_irqsave(&pcdev->lock, flags);
+	if (pcdev->active) {
+		list_del(&pcdev->active->queue);
+		pcdev->active->state = VIDEOBUF_ERROR;
+		wake_up_all(&pcdev->active->done);
+		pcdev->active = NULL;
+	}
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+
 	icd->ops->release(icd);
 
 	dev_info(&icd->dev,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
