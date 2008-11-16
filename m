Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAGMXNlG029686
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 17:33:23 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAGMXBpE029128
	for <video4linux-list@redhat.com>; Sun, 16 Nov 2008 17:33:11 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: hverkuil@xs4all.nl, g.liakhovetski@gmx.de
Date: Sun, 16 Nov 2008 23:33:05 +0100
Message-Id: <1226874785-29073-1-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <Pine.LNX.4.64.0811162320410.16868@axis700.grange>
References: <Pine.LNX.4.64.0811162320410.16868@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: [PATCH v2] Add new pixel format VYUY 16 bits wide.
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

There were already 3 YUV formats defined :
 - YUYV
 - YVYU
 - UYVY
The only left combination is VYUY, which is added in this
patch.

As suggested by Hans Verkuil, all YUV 4:2:2 packet formats
were grouped together.

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 include/linux/videodev2.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4669d7e..615b05f 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -292,7 +292,9 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_YVU410  v4l2_fourcc('Y', 'V', 'U', '9') /*  9  YVU 4:1:0     */
 #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y', 'V', '1', '2') /* 12  YVU 4:2:0     */
 #define V4L2_PIX_FMT_YUYV    v4l2_fourcc('Y', 'U', 'Y', 'V') /* 16  YUV 4:2:2     */
+#define V4L2_PIX_FMT_YVYU    v4l2_fourcc('Y', 'V', 'Y', 'U') /* 16  YVU 4:2:2     */
 #define V4L2_PIX_FMT_UYVY    v4l2_fourcc('U', 'Y', 'V', 'Y') /* 16  YUV 4:2:2     */
+#define V4L2_PIX_FMT_VYUY    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV 4:2:2     */
 #define V4L2_PIX_FMT_YUV422P v4l2_fourcc('4', '2', '2', 'P') /* 16  YVU422 planar */
 #define V4L2_PIX_FMT_YUV411P v4l2_fourcc('4', '1', '1', 'P') /* 16  YVU411 planar */
 #define V4L2_PIX_FMT_Y41P    v4l2_fourcc('Y', '4', '1', 'P') /* 12  YUV 4:1:1     */
@@ -342,7 +344,6 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S', '5', '6', '1') /* compressed GBRG bayer */
 #define V4L2_PIX_FMT_PAC207   v4l2_fourcc('P', '2', '0', '7') /* compressed BGGR bayer */
 #define V4L2_PIX_FMT_PJPG     v4l2_fourcc('P', 'J', 'P', 'G') /* Pixart 73xx JPEG */
-#define V4L2_PIX_FMT_YVYU    v4l2_fourcc('Y', 'V', 'Y', 'U') /* 16  YVU 4:2:2     */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
