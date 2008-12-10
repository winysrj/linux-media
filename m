Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBA4vgKr022439
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 23:57:42 -0500
Received: from yx-out-2324.google.com (yx-out-2324.google.com [74.125.44.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBA4vSEv012398
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 23:57:28 -0500
Received: by yx-out-2324.google.com with SMTP id 31so150727yxl.81
	for <video4linux-list@redhat.com>; Tue, 09 Dec 2008 20:57:28 -0800 (PST)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Wed, 10 Dec 2008 13:55:40 +0900
Message-Id: <20081210045540.3813.82504.sendpatchset@rx1.opensource.se>
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org
Subject: [PATCH] video: add NV16 and NV61 pixel formats
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

From: Magnus Damm <damm@igel.co.jp>

This patch adds support for NV16 and NV61 pixel formats.

These pixel formats use two planes; one for 8-bit Y values and
one for interleaved 8-bit U and V values. NV16/NV61 formats are
very similar to NV12/NV21 with the exception that NV16/NV61 are
using the same number of lines for both planes. The difference
between NV16 and NV61 is the U and V byte order.

The fourcc values are extrapolated from the NV12/NV21 case.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 include/linux/videodev2.h |    2 ++
 1 file changed, 2 insertions(+)

--- 0011/include/linux/videodev2.h
+++ work/include/linux/videodev2.h	2008-12-10 00:09:00.000000000 +0900
@@ -305,6 +305,8 @@ struct v4l2_pix_format {
 /* two planes -- one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr 4:2:0  */
 #define V4L2_PIX_FMT_NV21    v4l2_fourcc('N', 'V', '2', '1') /* 12  Y/CrCb 4:2:0  */
+#define V4L2_PIX_FMT_NV16    v4l2_fourcc('N', 'V', '1', '6') /* 16  Y/CbCr 4:2:2  */
+#define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
 
 /*  The following formats are not defined in the V4L2 specification */
 #define V4L2_PIX_FMT_YUV410  v4l2_fourcc('Y', 'U', 'V', '9') /*  9  YUV 4:1:0     */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
