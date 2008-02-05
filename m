Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m152CvKN014084
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 21:12:57 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m152CObE019210
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 21:12:24 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <0810f250d078bf6159de.1202176996@localhost>
In-Reply-To: <patchbomb.1202176995@localhost>
Date: Mon, 04 Feb 2008 18:03:16 -0800
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org, laurent.pinchart@skynet.be
Cc: v4l-dvb-maintainer@linuxtv.org,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	video4linux-list@redhat.com
Subject: [PATCH 1 of 3] Backed out changeset d002378ff8c2
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

# HG changeset patch
# User Brandon Philips <brandon@ifup.org>
# Date 1202175426 28800
# Node ID 0810f250d078bf6159de69569828c07cb54f4389
# Parent  d002378ff8c2d8e8bf3842d8f05469dd68398fc6
Backed out changeset d002378ff8c2

This change had a number of issues:
 - Adding an undiscussed control
 - Adding an unrelated mailimport change
 - Adding an unrelated kconfig change

diff --git a/linux/drivers/media/video/Kconfig b/linux/drivers/media/video/Kconfig
--- a/linux/drivers/media/video/Kconfig
+++ b/linux/drivers/media/video/Kconfig
@@ -836,13 +836,4 @@ config USB_STKWEBCAM
 
 endif # V4L_USB_DRIVERS
 
-config SOC_CAMERA
-	tristate "SoC camera support"
-	depends on VIDEO_V4L2
-	select VIDEOBUF_DMA_SG
-	help
-	  SoC Camera is a common API to several cameras, not connecting
-	  over a bus like PCI or USB. For example some i2c camera connected
-	  directly to the data bus of an SoC.
-
 endif # VIDEO_CAPTURE_DRIVERS
diff --git a/linux/include/linux/videodev2.h b/linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h
+++ b/linux/include/linux/videodev2.h
@@ -281,7 +281,6 @@ struct v4l2_pix_format
 #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B','G','R','4') /* 32  BGR-8-8-8-8   */
 #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R','G','B','4') /* 32  RGB-8-8-8-8   */
 #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G','R','E','Y') /*  8  Greyscale     */
-#define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y','1','6',' ') /* 16  Greyscale     */
 #define V4L2_PIX_FMT_PAL8    v4l2_fourcc('P','A','L','8') /*  8  8-bit palette */
 #define V4L2_PIX_FMT_YVU410  v4l2_fourcc('Y','V','U','9') /*  9  YVU 4:1:0     */
 #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y','V','1','2') /* 12  YVU 4:2:0     */
@@ -308,7 +307,6 @@ struct v4l2_pix_format
 
 /* see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B','A','8','1') /*  8  BGBG.. GRGR.. */
-#define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B','Y','R','2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */
 #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M','J','P','G') /* Motion-JPEG   */
@@ -864,8 +862,7 @@ struct v4l2_querymenu
 #define V4L2_CID_VFLIP			(V4L2_CID_BASE+21)
 #define V4L2_CID_HCENTER		(V4L2_CID_BASE+22)
 #define V4L2_CID_VCENTER		(V4L2_CID_BASE+23)
-#define V4L2_CID_AUTOEXPOSURE		(V4L2_CID_BASE+24)
-#define V4L2_CID_LASTP1			(V4L2_CID_BASE+25) /* last CID + 1 */
+#define V4L2_CID_LASTP1			(V4L2_CID_BASE+24) /* last CID + 1 */
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
diff --git a/mailimport b/mailimport
--- a/mailimport
+++ b/mailimport
@@ -224,10 +224,6 @@ if [ -d "$NAME" ]; then
 	else
 		echo "Processing patches from tree $NAME"
 		for i in $NAME/*; do
-			if [ ! -r $i ]; then
-				sudo chmod og+r $i
-			fi
-
 			echo "$i"
 			proccess_patch "$i"
 		done

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
