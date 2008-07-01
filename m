Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6145uKL030259
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:05:56 -0400
Received: from calf.ext.ti.com (calf.ext.ti.com [198.47.26.144])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6145jUu014847
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:05:46 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by calf.ext.ti.com (8.13.7/8.13.7) with ESMTP id m6145Zm3006372
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:05:40 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id m6145ZYT004554
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:05:35 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m6145ZG19779
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:05:35 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m6145YHQ010963
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:05:34 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m6145Yxl010960
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:05:34 -0500
Date: Mon, 30 Jun 2008 23:05:34 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701040534.GA10955@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 8/16] OMAP3 camera driver base address
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

ARM: OMAP: OMAP34XXCAM: Camera Base Address.

Adding OMAP 3 Camera registers base address.

Signed-off-by: Sameer Venkatraman <sameerv@ti.com>
Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 include/asm-arm/arch-omap/omap34xx.h |    1 +
 1 files changed, 1 insertion(+)

--- a/include/asm-arm/arch-omap/omap34xx.h
+++ b/include/asm-arm/arch-omap/omap34xx.h
@@ -61,6 +61,7 @@
 #define OMAP2_CM_BASE			OMAP3430_CM_BASE
 #define OMAP2_PRM_BASE			OMAP3430_PRM_BASE
 #define OMAP2_VA_IC_BASE		IO_ADDRESS(OMAP34XX_IC_BASE)
+#define OMAP34XX_CAMERA_BASE		(L4_34XX_BASE + 0xBC000)
 
 #endif
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
