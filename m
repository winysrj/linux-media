Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17Kktgm020765
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 15:46:55 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m17KkLQ2004335
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 15:46:22 -0500
Date: Thu, 7 Feb 2008 21:46:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802072145020.9064@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Add two new fourcc codes for 16bpp formats
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

From: Steven Whitehouse <steve@chygwyn.com>

This adds two new fourcc codes (as per info at fourcc.org)
for 16bpp mono and 16bpp Bayer formats.

Signed-off-by: Steven Whitehouse <steve@chygwyn.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

Resending with my signed-off-by added.

 include/linux/videodev2.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 1e47f1c..e9c8f1a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -281,6 +281,7 @@ struct v4l2_pix_format
 #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B','G','R','4') /* 32  BGR-8-8-8-8   */
 #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R','G','B','4') /* 32  RGB-8-8-8-8   */
 #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G','R','E','Y') /*  8  Greyscale     */
+#define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y','1','6',' ') /* 16  Greyscale     */
 #define V4L2_PIX_FMT_PAL8    v4l2_fourcc('P','A','L','8') /*  8  8-bit palette */
 #define V4L2_PIX_FMT_YVU410  v4l2_fourcc('Y','V','U','9') /*  9  YVU 4:1:0     */
 #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y','V','1','2') /* 12  YVU 4:2:0     */
@@ -307,6 +308,7 @@ struct v4l2_pix_format
 
 /* see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B','A','8','1') /*  8  BGBG.. GRGR.. */
+#define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B','Y','R','2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */
 #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M','J','P','G') /* Motion-JPEG   */
-- 
1.5.3.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
