Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6QN7gZY009977
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 19:07:42 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6QN7VYl025281
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 19:07:31 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: video4linux-list@redhat.com
Date: Sun, 27 Jul 2008 01:07:27 +0200
Message-Id: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr>
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

PXA suspend switches off DMA core, which looses all context
of previously assigned descriptors. As pxa_camera driver
relies on DMA transfers, setup the lost descriptors on
resume.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index efb2d19..0cacf16 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1017,6 +1017,16 @@ static struct soc_camera_host pxa_soc_camera_host = {
 	.ops			= &pxa_soc_camera_host_ops,
 };
 
+static int pxa_camera_resume(struct platform_device *pdev)
+{
+	struct pxa_camera_dev *pcdev = platform_get_drvdata(pdev);
+
+	DRCMR68 = pcdev->dma_chans[0] | DRCMR_MAPVLD;
+	DRCMR69 = pcdev->dma_chans[1] | DRCMR_MAPVLD;
+	DRCMR70 = pcdev->dma_chans[2] | DRCMR_MAPVLD;
+	return 0;
+}
+
 static int pxa_camera_probe(struct platform_device *pdev)
 {
 	struct pxa_camera_dev *pcdev;
@@ -1188,6 +1198,7 @@ static struct platform_driver pxa_camera_driver = {
 	},
 	.probe		= pxa_camera_probe,
 	.remove		= __exit_p(pxa_camera_remove),
+	.resume		= pxa_camera_resume,
 };
 
 
-- 
1.5.5.3

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
