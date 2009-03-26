Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2QGkGmc032372
	for <video4linux-list@redhat.com>; Thu, 26 Mar 2009 12:46:16 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2QGjsD8003408
	for <video4linux-list@redhat.com>; Thu, 26 Mar 2009 12:45:55 -0400
Message-ID: <49CBB13F.7090609@hni.uni-paderborn.de>
Date: Thu, 26 Mar 2009 17:45:51 +0100
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Questinons regarding soc_camera / pxa_camera
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

Hi,

I'm working on update my ov9655 driver to the current version of the 
v4l-dvb hg tree to publish it.
My systems run a Linux 2.6.26 kernel.

I have some bugs / questions regarding some soc_camera / pxa_camera changes:

--- a/linux/drivers/media/video/pxa_camera.c    Sun Mar 22 08:53:36 2009 
-0300
+++ b/linux/drivers/media/video/pxa_camera.c    Thu Mar 26 15:35:43 2009 
+0100
@@ -36,7 +36,7 @@
 
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 28)
 #include <mach/dma.h>
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
+#else
 #include <asm/dma.h>
 #endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)

I think this was a type and can be simplify.

@@ -1443,7 +1443,7 @@ static int pxa_camera_probe(struct platf
         goto exit;
     }
 
-    pcdev->clk = clk_get(&pdev->dev, NULL);
+    pcdev->clk = clk_get(&pdev->dev, "CAMCLK");
     if (IS_ERR(pcdev->clk)) {
         err = PTR_ERR(pcdev->clk);
         goto exit_kfree;

If the driver should support kernel lower 2.6.29 "CAMCLK" is needed.

With this two changes the driver compiles again (with some compiler 
warnings) and
works again on my system with kernel 2.6.26.

--- a/linux/drivers/media/video/soc_camera.c    Sun Mar 22 08:53:36 2009 
-0300
+++ b/linux/drivers/media/video/soc_camera.c    Thu Mar 26 15:35:43 2009 
+0100
@@ -238,7 +238,7 @@ static int soc_camera_init_user_formats(
     icd->num_user_formats = fmts;
     fmts = 0;
 
-    dev_dbg(&icd->dev, "Found %d supported formats.\n", fmts);
+    dev_dbg(&icd->dev, "Found %d supported formats.\n", 
icd->num_user_formats);
 
     /* Second pass - actually fill data formats */
     for (i = 0; i < icd->num_formats; i++)

I thing this was wrong or ' fmts = 0;' must be under the output.

@@ -675,8 +675,8 @@ static int soc_camera_cropcap(struct fil
     a->bounds.height        = icd->height_max;
     a->defrect.left            = icd->x_min;
     a->defrect.top            = icd->y_min;
-    a->defrect.width        = DEFAULT_WIDTH;
-    a->defrect.height        = DEFAULT_HEIGHT;
+    a->defrect.width        = icd->width_max;
+    a->defrect.height        = icd->height_max;
     a->pixelaspect.numerator    = 1;
     a->pixelaspect.denominator    = 1;
 
What was the reason to use fix values? Because of the current 
implementation of crop,
the default value can get bigger than the max value.

Is there some ongoing work regarding the crop implementation on soc_camera?
If I understand the documentation [1] right, the crop vales should 
represent the area
of the capture device before scaling. What was the reason for the 
current implementation
combing crop and fmt values?

Regards
    Stefan

[1] http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec/x1707.htm

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
