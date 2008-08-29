Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TNiYPJ028827
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:44:35 -0400
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TNiMZS005858
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:44:22 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7TNiGHs031025
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:44:21 -0500
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7TNiGbG022872
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:44:16 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 29 Aug 2008 18:44:02 -0500
Message-ID: <A24693684029E5489D1D202277BE89441191E346@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/15] OMAP3 camera driver: OMAP34XXCAM: Camera Base Address.
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

From: Sergio Aguirre <saaguirre@ti.com>

ARM: OMAP: OMAP34XXCAM: Camera Base Address.

Adding OMAP 3 Camera registers base address, and Platform Device.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Signed-off-by: Sameer Venkatraman <sameerv@ti.com>
Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 arch/arm/plat-omap/include/mach-omap2/devices.c              |   26 ++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat-omap/include/mach/omap34xx.h |    1 +
 2 files changed, 27 insertions(+)

--- a/arch/arm/plat-omap/include/mach/omap34xx.h
+++ b/arch/arm/plat-omap/include/mach/omap34xx.h
@@ -63,6 +63,7 @@
 #define OMAP2_CM_BASE			OMAP3430_CM_BASE
 #define OMAP2_PRM_BASE			OMAP3430_PRM_BASE
 #define OMAP2_VA_IC_BASE		IO_ADDRESS(OMAP34XX_IC_BASE)
+#define OMAP34XX_CAMERA_BASE		(L4_34XX_BASE + 0xBC000)
 
 #endif
 
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
