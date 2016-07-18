Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35156 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbcGRMmW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 08:42:22 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v4 01/12] [media] videodev2.h Add HSV formats
Date: Mon, 18 Jul 2016 14:42:05 +0200
Message-Id: <1468845736-19651-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These formats store the color information of the image
in a geometrical representation. The colors are mapped into a
cylinder, where the angle is the HUE, the height is the VALUE
and the distance to the center is the SATURATION. This is a very
useful format for image segmentation algorithms.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 2 ++
 include/uapi/linux/videodev2.h       | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f899bf1c5fc0..54670cd59212 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1238,6 +1238,8 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_TM6000:	descr = "A/V + VBI Mux Packet"; break;
 	case V4L2_PIX_FMT_CIT_YYVYUY:	descr = "GSPCA CIT YYVYUY"; break;
 	case V4L2_PIX_FMT_KONICA420:	descr = "GSPCA KONICA420"; break;
+	case V4L2_PIX_FMT_HSV24:	descr = "24-bit HSV 8-8-8"; break;
+	case V4L2_PIX_FMT_HSV32:	descr = "32-bit XHSV 8-8-8-8"; break;
 	case V4L2_SDR_FMT_CU8:		descr = "Complex U8"; break;
 	case V4L2_SDR_FMT_CU16LE:	descr = "Complex U16LE"; break;
 	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 724f43e69d03..c7fb760386cf 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -580,6 +580,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
 
+/* HSV formats */
+#define V4L2_PIX_FMT_HSV24 v4l2_fourcc('H', 'S', 'V', '3')
+#define V4L2_PIX_FMT_HSV32 v4l2_fourcc('H', 'S', 'V', '4')
+
 /* compressed formats */
 #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M', 'J', 'P', 'G') /* Motion-JPEG   */
 #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF JPEG     */
-- 
2.8.1

