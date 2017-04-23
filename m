Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33918 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163484AbdDWWpX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Apr 2017 18:45:23 -0400
Received: by mail-wr0-f194.google.com with SMTP id 6so4417517wrb.1
        for <linux-media@vger.kernel.org>; Sun, 23 Apr 2017 15:45:22 -0700 (PDT)
From: Bertold Van den Bergh <vandenbergh@bertold.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bertold Van den Bergh <vandenbergh@bertold.org>
Subject: [PATCH] V4L2 SDR: Add Real U8 format (V4L2_SDR_FMT_RU8)
Date: Mon, 24 Apr 2017 00:45:11 +0200
Message-Id: <1492987511-3900-1-git-send-email-vandenbergh@bertold.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the Real U8 format to the V4L2 SDR framework.
This will be used for a piece of hardware we are developing.

Signed-off-by: Bertold Van den Bergh <vandenbergh@bertold.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 1 +
 include/uapi/linux/videodev2.h       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e5a2187..8b6e097 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1229,6 +1229,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
 	case V4L2_SDR_FMT_CS14LE:	descr = "Complex S14LE"; break;
 	case V4L2_SDR_FMT_RU12LE:	descr = "Real U12LE"; break;
+	case V4L2_SDR_FMT_RU8:		descr = "Real U8"; break;
 	case V4L2_TCH_FMT_DELTA_TD16:	descr = "16-bit signed deltas"; break;
 	case V4L2_TCH_FMT_DELTA_TD08:	descr = "8-bit signed deltas"; break;
 	case V4L2_TCH_FMT_TU16:		descr = "16-bit unsigned touch data"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2b8feb8..50c3ef4 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -669,6 +669,7 @@ struct v4l2_pix_format {
 #define V4L2_SDR_FMT_CS8          v4l2_fourcc('C', 'S', '0', '8') /* complex s8 */
 #define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /* complex s14le */
 #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /* real u12le */
+#define V4L2_SDR_FMT_RU8          v4l2_fourcc('R', 'U', '0', '8') /* real u8 */
 
 /* Touch formats - used for Touch devices */
 #define V4L2_TCH_FMT_DELTA_TD16	v4l2_fourcc('T', 'D', '1', '6') /* 16-bit signed deltas */
-- 
1.9.1
