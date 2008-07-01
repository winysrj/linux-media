Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6146YON030423
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:06:34 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6146MVw015164
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:06:22 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id m6146CDW012478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:06:17 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id m6146BCh013841
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:06:12 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m6146BG19864
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:06:11 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m6146BO4020607
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:06:11 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m6146BQu020551
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:06:11 -0500
Date: Mon, 30 Jun 2008 23:06:11 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701040611.GA20533@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 9/16] OMAP3 camera driver platform device
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

From: Sameer Venkatraman <sameerv@ti.com>

ARM: OMAP: OMAP34XXCAM: Camera Plataform Device.

Adding OMAP 3 Camera Platform Device.

Signed-off-by: Sameer Venkatraman <sameerv@ti.com>
Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 devices.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+)

--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -50,6 +50,32 @@
 {
 	platform_device_register(&omap_cam_device);
 }
+
+#elif defined(CONFIG_VIDEO_OMAP3) || defined(CONFIG_VIDEO_OMAP3_MODULE)
+
+static struct resource cam_resources[] = {
+	{
+		.start		= OMAP34XX_CAMERA_BASE,
+		.end		= OMAP34XX_CAMERA_BASE + 0x1B70,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= INT_34XX_CAM_IRQ,
+		.flags		= IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device omap_cam_device = {
+	.name		= "omap34xxcam",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(cam_resources),
+	.resource	= cam_resources,
+};
+
+static inline void omap_init_camera(void)
+{
+	platform_device_register(&omap_cam_device);
+}
 #else
 static inline void omap_init_camera(void)
 {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
