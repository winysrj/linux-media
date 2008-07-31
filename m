Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6VLqnGg032026
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 17:52:49 -0400
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6VLpDrh001039
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 17:51:14 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0807270155020.29126@axis700.grange>
	<878wvnkd8n.fsf@free.fr>
	<Pine.LNX.4.64.0807271337270.1604@axis700.grange>
	<87tze997uu.fsf@free.fr>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 31 Jul 2008 23:51:12 +0200
In-Reply-To: <87tze997uu.fsf@free.fr> (Robert Jarzmik's message of "Mon\,
	28 Jul 2008 20\:33\:29 +0200")
Message-ID: <87y73h204v.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
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

> So, to sum up :
>  - I finish the mt9m111 driver
>  - I submit it
>  - I cook up a clean suspend/resume (unless you did it first of course :)

All right, I finished the pxa_camera part. The suspend/resume does work with a
opened video stream. The capture begins before the suspend and finished after
the resume.

I post the patch here attached for information. I'll submit later with the
complete suspend/resume serie. This is just for preliminary comments. Of course,
this patch superseeds the origin patch posted in this thread, which didn't work
for an opened video stream.

--
Robert

>From fb38f10c233a5b4e13f5ad42cf1c381ecc4215e9 Mon Sep 17 00:00:00 2001
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 27 Jul 2008 00:52:22 +0200
Subject: [PATCH] Fix suspend/resume of pxa_camera driver

PXA suspend switches off DMA core, which looses all context
of previously assigned descriptors. As pxa_camera driver
relies on DMA transfers, setup the lost descriptors on
resume and retrigger frame acquisition if needed.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   49 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index efb2d19..f00844c 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -128,6 +128,8 @@ struct pxa_camera_dev {
 
 	struct pxa_buffer	*active;
 	struct pxa_dma_desc	*sg_tail[3];
+
+	u32			save_CICR[5];
 };
 
 static const char *pxa_cam_driver_description = "PXA_Camera";
@@ -1017,6 +1019,51 @@ static struct soc_camera_host pxa_soc_camera_host = {
 	.ops			= &pxa_soc_camera_host_ops,
 };
 
+static int pxa_camera_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct pxa_camera_dev *pcdev = platform_get_drvdata(pdev);
+	int i = 0;
+
+	pcdev->save_CICR[i++] = CICR0;
+	pcdev->save_CICR[i++] = CICR1;
+	pcdev->save_CICR[i++] = CICR2;
+	pcdev->save_CICR[i++] = CICR3;
+	pcdev->save_CICR[i++] = CICR4;
+
+	return 0;
+}
+
+static int pxa_camera_resume(struct platform_device *pdev)
+{
+	struct pxa_camera_dev *pcdev = platform_get_drvdata(pdev);
+	int i = 0;
+
+	DRCMR68 = pcdev->dma_chans[0] | DRCMR_MAPVLD;
+	DRCMR69 = pcdev->dma_chans[1] | DRCMR_MAPVLD;
+	DRCMR70 = pcdev->dma_chans[2] | DRCMR_MAPVLD;
+
+	CICR0 = pcdev->save_CICR[i++] & ~CICR0_ENB;
+	CICR1 = pcdev->save_CICR[i++];
+	CICR2 = pcdev->save_CICR[i++];
+	CICR3 = pcdev->save_CICR[i++];
+	CICR4 = pcdev->save_CICR[i++];
+
+	if ((pcdev->icd) && (pcdev->icd->ops->resume))
+		pcdev->icd->ops->resume(pcdev->icd);
+
+	/* Restart frame capture if active buffer exists */
+	if (pcdev->active) {
+		/* Reset the FIFOs */
+		CIFR |= CIFR_RESET_F;
+		/* Enable End-Of-Frame Interrupt */
+		CICR0 &= ~CICR0_EOFM;
+		/* Restart the Capture Interface */
+		CICR0 |= CICR0_ENB;
+	}
+
+	return 0;
+}
+
 static int pxa_camera_probe(struct platform_device *pdev)
 {
 	struct pxa_camera_dev *pcdev;
@@ -1188,6 +1235,8 @@ static struct platform_driver pxa_camera_driver = {
 	},
 	.probe		= pxa_camera_probe,
 	.remove		= __exit_p(pxa_camera_remove),
+	.suspend	= pxa_camera_suspend,
+	.resume		= pxa_camera_resume,
 };
 
 
-- 
1.5.5.3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
