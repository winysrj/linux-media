Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m71MQK41007130
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 18:26:20 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m71MQ8sr025206
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 18:26:08 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: video4linux-list@redhat.com
Date: Sat,  2 Aug 2008 00:26:06 +0200
Message-Id: <1217629566-26637-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1217629566-26637-1-git-send-email-robert.jarzmik@free.fr>
References: <87tze4cr3g.fsf@free.fr>
	<1217629566-26637-1-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH] Fix suspend/resume of pxa_camera driver
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

PXA suspend switches off DMA core, which loses all context
of previously assigned descriptors. As pxa_camera driver
relies on DMA transfers, setup the lost descriptors on
resume and retrigger frame acquisition if needed.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   56 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 7cc8e9b..1ac8422 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -127,6 +127,8 @@ struct pxa_camera_dev {
 
 	struct pxa_buffer	*active;
 	struct pxa_dma_desc	*sg_tail[3];
+
+	u32			save_cicr[5];
 };
 
 static const char *pxa_cam_driver_description = "PXA_Camera";
@@ -992,10 +994,64 @@ static spinlock_t *pxa_camera_spinlock_alloc(struct soc_camera_file *icf)
 	return &pcdev->lock;
 }
 
+static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
+{
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	int i = 0, ret = 0;
+
+	pcdev->save_cicr[i++] = CICR0;
+	pcdev->save_cicr[i++] = CICR1;
+	pcdev->save_cicr[i++] = CICR2;
+	pcdev->save_cicr[i++] = CICR3;
+	pcdev->save_cicr[i++] = CICR4;
+
+	if ((pcdev->icd) && (pcdev->icd->ops->resume))
+		ret = pcdev->icd->ops->resume(pcdev->icd);
+
+	return ret;
+}
+
+static int pxa_camera_resume(struct soc_camera_device *icd)
+{
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
+	int i = 0, ret = 0;
+
+	DRCMR68 = pcdev->dma_chans[0] | DRCMR_MAPVLD;
+	DRCMR69 = pcdev->dma_chans[1] | DRCMR_MAPVLD;
+	DRCMR70 = pcdev->dma_chans[2] | DRCMR_MAPVLD;
+
+	CICR0 = pcdev->save_cicr[i++] & ~CICR0_ENB;
+	CICR1 = pcdev->save_cicr[i++];
+	CICR2 = pcdev->save_cicr[i++];
+	CICR3 = pcdev->save_cicr[i++];
+	CICR4 = pcdev->save_cicr[i++];
+
+	if ((pcdev->icd) && (pcdev->icd->ops->resume))
+		ret = pcdev->icd->ops->resume(pcdev->icd);
+
+	/* Restart frame capture if active buffer exists */
+	if (!ret && pcdev->active) {
+		/* Reset the FIFOs */
+		CIFR |= CIFR_RESET_F;
+		/* Enable End-Of-Frame Interrupt */
+		CICR0 &= ~CICR0_EOFM;
+		/* Restart the Capture Interface */
+		CICR0 |= CICR0_ENB;
+	}
+
+	return ret;
+}
+
 static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= pxa_camera_add_device,
 	.remove		= pxa_camera_remove_device,
+	.suspend	= pxa_camera_suspend,
+	.resume		= pxa_camera_resume,
 	.set_fmt_cap	= pxa_camera_set_fmt_cap,
 	.try_fmt_cap	= pxa_camera_try_fmt_cap,
 	.reqbufs	= pxa_camera_reqbufs,
-- 
1.5.5.3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
