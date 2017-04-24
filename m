Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34731 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1173715AbdDXR5i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 13:57:38 -0400
Received: by mail-wr0-f194.google.com with SMTP id 6so7758219wrb.1
        for <linux-media@vger.kernel.org>; Mon, 24 Apr 2017 10:57:38 -0700 (PDT)
From: Bertold Van den Bergh <vandenbergh@bertold.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        vandenbergh@bertold.org
Subject: [PATCH v2] V4L2 SDR: Add Real U8 format (V4L2_SDR_FMT_RU8)
Date: Mon, 24 Apr 2017 19:57:12 +0200
Message-Id: <1493056632-18516-1-git-send-email-vandenbergh@bertold.org>
In-Reply-To: <1493044118.2446.40.camel@pengutronix.de>
References: <1493044118.2446.40.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the Real U8 format to the V4L2 SDR framework.

Signed-off-by: Bertold Van den Bergh <vandenbergh@bertold.org>
---
Thanks for your comments. I was not aware of the V4L format documentation.
I don't think there is a clear natural ordering for these types of formats,
but I agree it looks more consistent in this way.

Changes in v2:
  - Added documentation files
  - Changed order of formats

 Documentation/media/uapi/v4l/pixfmt-sdr-ru08.rst | 17 +++++++++++++++++
 Documentation/media/uapi/v4l/sdr-formats.rst     |  1 +
 drivers/media/v4l2-core/v4l2-ioctl.c             |  1 +
 include/uapi/linux/videodev2.h                   |  1 +
 4 files changed, 20 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-ru08.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-ru08.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-ru08.rst
new file mode 100644
index 0000000..ddd56e1
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-ru08.rst
@@ -0,0 +1,17 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-SDR-FMT-RU8:
+
+****************************
+V4L2_SDR_FMT_RU8 ('RU08')
+****************************
+
+
+Real unsigned 8-bit sample
+
+
+Description
+===========
+
+This format contains a sequence of real number samples. Each sample is
+represented as a 8 bit unsigned number.
diff --git a/Documentation/media/uapi/v4l/sdr-formats.rst b/Documentation/media/uapi/v4l/sdr-formats.rst
index f863c08..a08b5c2 100644
--- a/Documentation/media/uapi/v4l/sdr-formats.rst
+++ b/Documentation/media/uapi/v4l/sdr-formats.rst
@@ -16,4 +16,5 @@ These formats are used for :ref:`SDR <sdr>` interface only.
     pixfmt-sdr-cu16le
     pixfmt-sdr-cs08
     pixfmt-sdr-cs14le
+    pixfmt-sdr-ru08
     pixfmt-sdr-ru12le
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e5a2187..79140cc 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1228,6 +1228,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_SDR_FMT_CU16LE:	descr = "Complex U16LE"; break;
 	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
 	case V4L2_SDR_FMT_CS14LE:	descr = "Complex S14LE"; break;
+	case V4L2_SDR_FMT_RU8:		descr = "Real U8"; break;
 	case V4L2_SDR_FMT_RU12LE:	descr = "Real U12LE"; break;
 	case V4L2_TCH_FMT_DELTA_TD16:	descr = "16-bit signed deltas"; break;
 	case V4L2_TCH_FMT_DELTA_TD08:	descr = "8-bit signed deltas"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 2b8feb8..21e9ae3 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -668,6 +668,7 @@ struct v4l2_pix_format {
 #define V4L2_SDR_FMT_CU16LE       v4l2_fourcc('C', 'U', '1', '6') /* IQ u16le */
 #define V4L2_SDR_FMT_CS8          v4l2_fourcc('C', 'S', '0', '8') /* complex s8 */
 #define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /* complex s14le */
+#define V4L2_SDR_FMT_RU8          v4l2_fourcc('R', 'U', '0', '8') /* real u8 */
 #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /* real u12le */
 
 /* Touch formats - used for Touch devices */
-- 
1.9.1
