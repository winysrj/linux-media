Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6143ai6029122
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:03:36 -0400
Received: from soda.ext.ti.com (soda.ext.ti.com [198.47.26.145])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6143AwI013622
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:03:10 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by soda.ext.ti.com (8.13.7/8.13.7) with ESMTP id m61430cP014488
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:03:05 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id m61430i1001189
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:03:00 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m6142xG19464
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:02:59 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m6142x85003735
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:02:59 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m6142xbV003694
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:02:59 -0500
Date: Mon, 30 Jun 2008 23:02:59 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701040259.GA3677@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 4/16] OMAP3 camera driver V4L2 RAW10
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

>From 5059759d433bcdb2a51afeefe8c174e243fd58b1 Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@nokia.com>
Date: Thu, 29 May 2008 13:16:49 +0300
Subject: [PATCH] Adding 10-bit RAW Bayer format.

Signed-off-by: Mohit Jalori <mjalori@ti.com>
---
 include/linux/videodev2.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index c141118..29a3e25 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -309,6 +309,7 @@ struct v4l2_pix_format
 
 /* see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B','A','8','1') /*  8  BGBG.. GRGR.. */
+#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B','A','1','0') /* 10bit raw bayer  */
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B','Y','R','2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */
-- 
1.5.5.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
