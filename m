Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:43748 "EHLO
        relmlie4.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753451AbdEINua (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 09:50:30 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH v5 4/7] media: Add new SDR formats PC16, PC18 & PC20
Date: Tue,  9 May 2017 14:37:35 +0100
Message-Id: <20170509133738.16414-5-ramesh.shanmugasundaram@bp.renesas.com>
In-Reply-To: <20170509133738.16414-1-ramesh.shanmugasundaram@bp.renesas.com>
References: <20170509133738.16414-1-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the three new SDR formats. These formats
were prefixed with "planar" indicating I & Q data are not interleaved
as in other formats. Here, I & Q data constitutes the top half and bottom
half of the received buffer respectively.

V4L2_SDR_FMT_PCU16BE - 14-bit complex (I & Q) unsigned big-endian sample
inside 16-bit. V4L2 FourCC: PC16

V4L2_SDR_FMT_PCU18BE - 16-bit complex (I & Q) unsigned big-endian sample
inside 18-bit. V4L2 FourCC: PC18

V4L2_SDR_FMT_PCU20BE - 18-bit complex (I & Q) unsigned big-endian sample
inside 20-bit. V4L2 FourCC: PC20

Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 3 +++
 include/uapi/linux/videodev2.h       | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e5a2187381db..ca1e920d3e7c 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1229,6 +1229,9 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
 	case V4L2_SDR_FMT_CS14LE:	descr = "Complex S14LE"; break;
 	case V4L2_SDR_FMT_RU12LE:	descr = "Real U12LE"; break;
+	case V4L2_SDR_FMT_PCU16BE:	descr = "Planar Complex U16BE"; break;
+	case V4L2_SDR_FMT_PCU18BE:	descr = "Planar Complex U18BE"; break;
+	case V4L2_SDR_FMT_PCU20BE:	descr = "Planar Complex U20BE"; break;
 	case V4L2_TCH_FMT_DELTA_TD16:	descr = "16-bit signed deltas"; break;
 	case V4L2_TCH_FMT_DELTA_TD08:	descr = "8-bit signed deltas"; break;
 	case V4L2_TCH_FMT_TU16:		descr = "16-bit unsigned touch data"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2b8feb86d09e..45cf7359822c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -669,6 +669,9 @@ struct v4l2_pix_format {
 #define V4L2_SDR_FMT_CS8          v4l2_fourcc('C', 'S', '0', '8') /* complex s8 */
 #define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /* complex s14le */
 #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /* real u12le */
+#define V4L2_SDR_FMT_PCU16BE	  v4l2_fourcc('P', 'C', '1', '6') /* planar complex u16be */
+#define V4L2_SDR_FMT_PCU18BE	  v4l2_fourcc('P', 'C', '1', '8') /* planar complex u18be */
+#define V4L2_SDR_FMT_PCU20BE	  v4l2_fourcc('P', 'C', '2', '0') /* planar complex u20be */
 
 /* Touch formats - used for Touch devices */
 #define V4L2_TCH_FMT_DELTA_TD16	v4l2_fourcc('T', 'D', '1', '6') /* 16-bit signed deltas */
-- 
2.12.2
