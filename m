Return-path: <linux-media-owner@vger.kernel.org>
Received: from [31.36.214.240] ([31.36.214.240]:39098 "EHLO
        val.bonstra.fr.eu.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752907AbeDHVVI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 17:21:08 -0400
From: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
Subject: [PATCH v2 2/6] usbtv: Add SECAM support
Date: Sun,  8 Apr 2018 23:11:57 +0200
Message-Id: <20180408211201.27452-3-bonstra@bonstra.fr.eu.org>
In-Reply-To: <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
References: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
 <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the SECAM norm, using the "AVSECAM" decoder configuration
sequence found in Windows driver's .INF file.

For reference, the "AVSECAM" sequence in the .INF file is:
0x04,0x73,0xDC,0x72,0xA2,0x90,0x35,0x01,0x30,0x04,0x08,0x2D,0x28,0x08,
0x02,0x69,0x16,0x35,0x21,0x16,0x36

Signed-off-by: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
---
 drivers/media/usb/usbtv/usbtv-video.c | 38 ++++++++++++++++++++++++++-
 drivers/media/usb/usbtv/usbtv.h       |  2 +-
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 97f9790954f9..6b0a10173388 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -57,6 +57,11 @@ static struct usbtv_norm_params norm_params[] = {
 		.norm = V4L2_STD_PAL,
 		.cap_width = 720,
 		.cap_height = 576,
+	},
+	{
+		.norm = V4L2_STD_SECAM,
+		.cap_width = 720,
+		.cap_height = 576,
 	}
 };
 
@@ -187,6 +192,34 @@ static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
 		{ USBTV_BASE + 0x024f, 0x0002 },
 	};
 
+	static const u16 secam[][2] = {
+		/* "AVSECAM" tuning sequence from .INF file */
+		{ USBTV_BASE + 0x0003, 0x0004 },
+		{ USBTV_BASE + 0x001a, 0x0073 },
+		{ USBTV_BASE + 0x0100, 0x00dc },
+		{ USBTV_BASE + 0x010e, 0x0072 },
+		{ USBTV_BASE + 0x010f, 0x00a2 },
+		{ USBTV_BASE + 0x0112, 0x0090 },
+		{ USBTV_BASE + 0x0115, 0x0035 },
+		{ USBTV_BASE + 0x0117, 0x0001 },
+		{ USBTV_BASE + 0x0118, 0x0030 },
+		{ USBTV_BASE + 0x012d, 0x0004 },
+		{ USBTV_BASE + 0x012f, 0x0008 },
+		{ USBTV_BASE + 0x0220, 0x002d },
+		{ USBTV_BASE + 0x0225, 0x0028 },
+		{ USBTV_BASE + 0x024e, 0x0008 },
+		{ USBTV_BASE + 0x024f, 0x0002 },
+		{ USBTV_BASE + 0x0254, 0x0069 },
+		{ USBTV_BASE + 0x025a, 0x0016 },
+		{ USBTV_BASE + 0x025b, 0x0035 },
+		{ USBTV_BASE + 0x0263, 0x0021 },
+		{ USBTV_BASE + 0x0266, 0x0016 },
+		{ USBTV_BASE + 0x0267, 0x0036 },
+		/* Epilog */
+		{ USBTV_BASE + 0x024e, 0x0002 },
+		{ USBTV_BASE + 0x024f, 0x0002 },
+	};
+
 	ret = usbtv_configure_for_norm(usbtv, norm);
 
 	if (!ret) {
@@ -194,6 +227,8 @@ static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
 			ret = usbtv_set_regs(usbtv, ntsc, ARRAY_SIZE(ntsc));
 		else if (norm & V4L2_STD_PAL)
 			ret = usbtv_set_regs(usbtv, pal, ARRAY_SIZE(pal));
+		else if (norm & V4L2_STD_SECAM)
+			ret = usbtv_set_regs(usbtv, secam, ARRAY_SIZE(secam));
 	}
 
 	return ret;
@@ -605,7 +640,8 @@ static int usbtv_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	int ret = -EINVAL;
 	struct usbtv *usbtv = video_drvdata(file);
 
-	if ((norm & V4L2_STD_525_60) || (norm & V4L2_STD_PAL))
+	if ((norm & V4L2_STD_525_60) || (norm & V4L2_STD_PAL) ||
+			(norm & V4L2_STD_SECAM))
 		ret = usbtv_select_norm(usbtv, norm);
 
 	return ret;
diff --git a/drivers/media/usb/usbtv/usbtv.h b/drivers/media/usb/usbtv/usbtv.h
index 0231e449877e..77a368e90fd0 100644
--- a/drivers/media/usb/usbtv/usbtv.h
+++ b/drivers/media/usb/usbtv/usbtv.h
@@ -68,7 +68,7 @@
 #define USBTV_ODD(chunk)	((be32_to_cpu(chunk[0]) & 0x0000f000) >> 15)
 #define USBTV_CHUNK_NO(chunk)	(be32_to_cpu(chunk[0]) & 0x00000fff)
 
-#define USBTV_TV_STD  (V4L2_STD_525_60 | V4L2_STD_PAL)
+#define USBTV_TV_STD  (V4L2_STD_525_60 | V4L2_STD_PAL | V4L2_STD_SECAM)
 
 /* parameters for supported TV norms */
 struct usbtv_norm_params {
-- 
2.17.0
