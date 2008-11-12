Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACKVxU8022727
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:59 -0500
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACKVZtj027066
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 15:31:49 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, video4linux-list@redhat.com
Date: Wed, 12 Nov 2008 21:29:42 +0100
Message-Id: <1226521783-19806-12-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1226521783-19806-11-git-send-email-robert.jarzmik@free.fr>
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
	<1226521783-19806-11-git-send-email-robert.jarzmik@free.fr>
Cc: 
Subject: [PATCH 11/13] pxa_camera: check that YUV formats are always 8 bit
	wide
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

The pxa only accepts YUV formats only when 8 bit bus mode is
selected. Add a check to ensure the right bus mode was
selected when trying to use 8 bit mode.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 3e7ce6f..cd9d09e 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -781,12 +781,34 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
 	return 0;
 }
 
+static int is_yuv_format(__u32 pixfmt)
+{
+	switch (pixfmt) {
+	case V4L2_PIX_FMT_YVYU:
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_VYUY:
+	case V4L2_PIX_FMT_YUV422P:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
 static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	unsigned long dw, bpp, bus_flags, camera_flags, common_flags;
 	u32 cicr0, cicr1, cicr4 = 0;
+
+	/*
+	 * As stated in PXA developer's manual, YUV formats only accept 8 bit
+	 * wide buswidth.
+	 */
+	if (is_yuv_format(pixfmt))
+		icd->buswidth = 8;
+
 	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
 
 	if (ret < 0)
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
