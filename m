Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6145V0Q030170
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:05:31 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6145G7g014680
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:05:17 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id m61456Lr011912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:05:11 -0500
Received: from legion.dal.design.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id m61456wN004401
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:05:06 -0500 (CDT)
Received: from dirac.dal.design.ti.com (dirac.dal.design.ti.com
	[128.247.25.123])
	by legion.dal.design.ti.com (8.11.7p1+Sun/8.11.7) with ESMTP id
	m61455G19715
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:05:06 -0500 (CDT)
Received: from dirac.dal.design.ti.com (localhost.localdomain [127.0.0.1])
	by dirac.dal.design.ti.com (8.12.11/8.12.11) with ESMTP id
	m61455i5001736
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 23:05:05 -0500
Received: (from a0270762@localhost)
	by dirac.dal.design.ti.com (8.12.11/8.12.11/Submit) id m61455np001697
	for video4linux-list@redhat.com; Mon, 30 Jun 2008 23:05:05 -0500
Date: Mon, 30 Jun 2008 23:05:05 -0500
From: Mohit Jalori <mjalori@ti.com>
To: video4linux-list@redhat.com
Message-ID: <20080701040505.GA1683@dirac.dal.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Patch 7/16] OMAP3 camera driver RAW 10 dpcm
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

From: Sakari Ailus [sakari.ailus@nokia.com]

V4L2: Add V4L2_PIX_FMT_SGRBG10DPCM8 to videodev2.h

Adding definition for 10-bit RAW bayer compressed to 8 bits.

Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
---
 include/linux/videodev2.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 15c0f2b..7a6131c 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -310,6 +310,7 @@ struct v4l2_pix_format
 /* see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B','A','8','1') /*  8  BGBG.. GRGR.. */
 #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B','A','1','0') /* 10bit raw bayer  */
+#define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B','D','1','0') /* 10bit raw bayer DPCM compressed to 8 bits */
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B','Y','R','2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */
-- 
1.5.5.1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
