Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n75ALpGA020227
	for <video4linux-list@redhat.com>; Wed, 5 Aug 2009 06:21:51 -0400
Received: from mail01.idc.renesas.com (mail.renesas.com [202.234.163.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n75ALaRg000561
	for <video4linux-list@redhat.com>; Wed, 5 Aug 2009 06:21:37 -0400
Date: Wed, 05 Aug 2009 19:21:31 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-id: <ubpmumuhg.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: [PATCH 1/2] sh_mobile_ceu: add soft reset function
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


Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
---
 drivers/media/video/sh_mobile_ceu_camera.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 0db88a5..896bbf1 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -135,6 +135,26 @@ static u32 ceu_read(struct sh_mobile_ceu_dev *priv, unsigned long reg_offs)
 	return ioread32(priv->base + reg_offs);
 }
 
+static void sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
+{
+	int t;
+
+	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
+	t = 10000;
+	while (t--) {
+		if (!(ceu_read(pcdev, CAPSR) & (1 << 16)))
+			break;
+		cpu_relax();
+	}
+
+	t = 10000;
+	while (t--) {
+		if (!(ceu_read(pcdev, CSTSR) & 1))
+			break;
+		cpu_relax();
+	}
+}
+
 /*
  *  Videobuf operations
  */
@@ -366,9 +386,7 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 
 	clk_enable(pcdev->clk);
 
-	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
-	while (ceu_read(pcdev, CSTSR) & 1)
-		msleep(1);
+	sh_mobile_ceu_soft_reset(pcdev);
 
 	pcdev->icd = icd;
 err:
@@ -386,7 +404,7 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 
 	/* disable capture, disable interrupts */
 	ceu_write(pcdev, CEIER, 0);
-	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
+	sh_mobile_ceu_soft_reset(pcdev);
 
 	/* make sure active buffer is canceled */
 	spin_lock_irqsave(&pcdev->lock, flags);
-- 
1.6.0.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
