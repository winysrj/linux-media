Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKVvrX022667
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:57 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVm43027222
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:48 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:41 +0100
Message-Id: <1226521783-19806-11-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-10-git-send-email-robert.jarzmik@free.fr>
References: <1226521783-19806-1-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-2-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-3-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-4-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-5-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-6-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-7-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-8-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-9-git-send-email-robert.jarzmik@free.fr>
	<1226521783-19806-10-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH 10/13] sh_mobile_ceu_camera: (ab)use the translation
	framework
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

Use the newly created translation framework for SuperH
Mobile CEU camera host. This host doesn't use the generic
framework, and implements its own enumeration and format
availability.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/sh_mobile_ceu_camera.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index fdfe04f..9d139d1 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -596,6 +596,10 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.init_videobuf	= sh_mobile_ceu_init_videobuf,
 };
 
+static struct soc_camera_format_translate *sh_mobile_ceu_pixfmt_translations = {
+	LAST_FMT_TRANSLATION,
+};
+
 static int sh_mobile_ceu_probe(struct platform_device *pdev)
 {
 	struct sh_mobile_ceu_dev *pcdev;
@@ -669,8 +673,9 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->ici.priv = pcdev;
 	pcdev->ici.dev.parent = &pdev->dev;
 	pcdev->ici.nr = pdev->id;
-	pcdev->ici.drv_name = pdev->dev.bus_id,
-	pcdev->ici.ops = &sh_mobile_ceu_host_ops,
+	pcdev->ici.drv_name = pdev->dev.bus_id;
+	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
+	pcdev->ici.translate_fmt = sh_mobile_ceu_pixfmt_translations;
 
 	err = soc_camera_host_register(&pcdev->ici);
 	if (err)
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
