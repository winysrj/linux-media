Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m652rtv6001099
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 22:53:55 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m652rOOC024013
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 22:53:43 -0400
Received: by wf-out-1314.google.com with SMTP id 25so1337595wfc.6
	for <video4linux-list@redhat.com>; Fri, 04 Jul 2008 19:53:43 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Sat, 05 Jul 2008 11:53:55 +0900
Message-Id: <20080705025355.27137.84493.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
References: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
Cc: paulius.zaleckas@teltonika.lt, linux-sh@vger.kernel.org,
	mchehab@infradead.org, lethal@linux-sh.org,
	akpm@linux-foundation.org, g.liakhovetski@gmx.de
Subject: [PATCH 02/04] soc_camera: Add 16-bit bus width support
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

The SuperH Mobile CEU hardware supports 16-bit width bus,
so extend the soc_camera code with SOCAM_DATAWIDTH_16.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 include/media/soc_camera.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- 0008/include/media/soc_camera.h
+++ work/include/media/soc_camera.h	2008-07-01 14:38:34.000000000 +0900
@@ -153,11 +153,12 @@ static inline struct v4l2_queryctrl cons
 #define SOCAM_DATAWIDTH_8		(1 << 6)
 #define SOCAM_DATAWIDTH_9		(1 << 7)
 #define SOCAM_DATAWIDTH_10		(1 << 8)
-#define SOCAM_PCLK_SAMPLE_RISING	(1 << 9)
-#define SOCAM_PCLK_SAMPLE_FALLING	(1 << 10)
+#define SOCAM_DATAWIDTH_16		(1 << 9)
+#define SOCAM_PCLK_SAMPLE_RISING	(1 << 10)
+#define SOCAM_PCLK_SAMPLE_FALLING	(1 << 11)
 
 #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_9 | \
-			      SOCAM_DATAWIDTH_10)
+			      SOCAM_DATAWIDTH_10 | SOCAM_DATAWIDTH_16)
 
 static inline unsigned long soc_camera_bus_param_compatible(
 			unsigned long camera_flags, unsigned long bus_flags)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
