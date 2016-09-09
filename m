Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:22026 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753192AbcIIPsQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 11:48:16 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <Tiffany.lin@mediatek.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v2 1/4] v4l: add Mediatek compressed video block format
Date: Fri, 9 Sep 2016 23:48:04 +0800
Message-ID: <1473436087-21943-2-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1473436087-21943-1-git-send-email-tiffany.lin@mediatek.com>
References: <1473436087-21943-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_PIX_FMT_MT21C format used on MT8173 driver.
It is compressed format and need MT8173 MDP driver to transfer to other
standard format.

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |    1 +
 include/uapi/linux/videodev2.h       |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 2bd1581..1d45c58 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1288,6 +1288,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_JPGL:		descr = "JPEG Lite"; break;
 		case V4L2_PIX_FMT_SE401:	descr = "GSPCA SE401"; break;
 		case V4L2_PIX_FMT_S5C_UYVY_JPG:	descr = "S5C73MX interleaved UYVY/JPEG"; break;
+		case V4L2_PIX_FMT_MT21C:	descr = "Mediatek Compressed Format"; break;
 		default:
 			WARN(1, "Unknown pixelformat 0x%08x\n", fmt->pixelformat);
 			if (fmt->description[0])
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 43326c3..ddd0083 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -635,6 +635,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y8I      v4l2_fourcc('Y', '8', 'I', ' ') /* Greyscale 8-bit L/R interleaved */
 #define V4L2_PIX_FMT_Y12I     v4l2_fourcc('Y', '1', '2', 'I') /* Greyscale 12-bit L/R interleaved */
 #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
+#define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
 
 /* SDR formats - used only for Software Defined Radio devices */
 #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
-- 
1.7.9.5

