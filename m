Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n75ALsBJ020341
	for <video4linux-list@redhat.com>; Wed, 5 Aug 2009 06:21:54 -0400
Received: from mail03.idc.renesas.com (mail.renesas.com [202.234.163.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n75ALepD000592
	for <video4linux-list@redhat.com>; Wed, 5 Aug 2009 06:21:40 -0400
Date: Wed, 05 Aug 2009 19:21:35 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-id: <uab2emuhc.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: [PATCH 2/2 v2] sh_mobile_ceu_camera: add VBP error support
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

If CEU driver can not receive data from camera,
CETCR has VBP error state.
Then, CEU is stopped and cure operation is needed.
This patch add VBP error cure operation.

Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
---
v1 -> v2

o add explain for sh_mobile_ceu_capture
o use sh_mobile_ceu_soft_reset
o use -EIO in sh_mobile_ceu_capture
o add small explain to sh_mobile_ceu_videobuf_queue

 drivers/media/video/sh_mobile_ceu_camera.c |   37 ++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 896bbf1..4281325 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -202,26 +202,42 @@ static void free_buffer(struct videobuf_queue *vq,
 #define CEU_CETCR_MAGIC 0x0317f313 /* acknowledge magical interrupt sources */
 #define CEU_CETCR_IGRW (1 << 4) /* prohibited register access interrupt bit */
 #define CEU_CEIER_CPEIE (1 << 0) /* one-frame capture end interrupt */
+#define CEU_CEIER_VBP   (1 << 20) /* vbp error */
 #define CEU_CAPCR_CTNCP (1 << 16) /* continuous capture mode (if set) */
+#define CEU_CEIER_MASK (CEU_CEIER_CPEIE | CEU_CEIER_VBP)
 
 
-static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
+/* return value doesn't reflex the success/failure to queue the new buffer.
+ * but rather the status of the previous buffer */
+static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 {
 	struct soc_camera_device *icd = pcdev->icd;
 	dma_addr_t phys_addr_top, phys_addr_bottom;
+	u32 status;
+	int ret = 0;
 
 	/* The hardware is _very_ picky about this sequence. Especially
 	 * the CEU_CETCR_MAGIC value. It seems like we need to acknowledge
 	 * several not-so-well documented interrupt sources in CETCR.
 	 */
-	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~CEU_CEIER_CPEIE);
-	ceu_write(pcdev, CETCR, ~ceu_read(pcdev, CETCR) & CEU_CETCR_MAGIC);
-	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | CEU_CEIER_CPEIE);
+	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~CEU_CEIER_MASK);
+	status = ceu_read(pcdev, CETCR);
+	ceu_write(pcdev, CETCR, ~status & CEU_CETCR_MAGIC);
+	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | CEU_CEIER_MASK);
 	ceu_write(pcdev, CAPCR, ceu_read(pcdev, CAPCR) & ~CEU_CAPCR_CTNCP);
 	ceu_write(pcdev, CETCR, CEU_CETCR_MAGIC ^ CEU_CETCR_IGRW);
 
+	/* When a VBP interrupt occurs, a capture end interrupt
+	 * does not occur and the image of that frame is not captured correctly.
+	 * So, soft reset is needed here.
+	 */
+	if (status & CEU_CEIER_VBP) {
+		sh_mobile_ceu_soft_reset(pcdev);
+		ret = -EIO;
+	}
+
 	if (!pcdev->active)
-		return;
+		return ret;
 
 	phys_addr_top = videobuf_to_dma_contig(pcdev->active);
 	ceu_write(pcdev, CDAYR, phys_addr_top);
@@ -245,6 +261,8 @@ static void sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 
 	pcdev->active->state = VIDEOBUF_ACTIVE;
 	ceu_write(pcdev, CAPSR, 0x1); /* start capture */
+
+	return ret;
 }
 
 static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
@@ -318,6 +336,10 @@ static void sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
 	list_add_tail(&vb->queue, &pcdev->capture);
 
 	if (!pcdev->active) {
+		/* Because there were no active buffer at this moment,
+		 * we are not interested in the return value of
+		 * sh_mobile_ceu_capture here.
+		 */
 		pcdev->active = vb;
 		sh_mobile_ceu_capture(pcdev);
 	}
@@ -355,9 +377,8 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 	else
 		pcdev->active = NULL;
 
-	sh_mobile_ceu_capture(pcdev);
-
-	vb->state = VIDEOBUF_DONE;
+	vb->state = (sh_mobile_ceu_capture(pcdev) < 0) ?
+		VIDEOBUF_ERROR : VIDEOBUF_DONE;
 	do_gettimeofday(&vb->ts);
 	vb->field_count++;
 	wake_up(&vb->done);
-- 
1.6.0.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
