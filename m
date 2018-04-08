Return-path: <linux-media-owner@vger.kernel.org>
Received: from [31.36.214.240] ([31.36.214.240]:39096 "EHLO
        val.bonstra.fr.eu.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752295AbeDHVVI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 17:21:08 -0400
From: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
Subject: [PATCH v2 5/6] usbtv: Enforce standard for color decoding
Date: Sun,  8 Apr 2018 23:12:00 +0200
Message-Id: <20180408211201.27452-6-bonstra@bonstra.fr.eu.org>
In-Reply-To: <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
References: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
 <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Depending on the chosen standard, configure the decoder to use the
appropriate color encoding standard (PAL-like, NTSC-like or SECAM).

Until now, the decoder was not configured for a specific color standard,
making it autodetect the color encoding.

While this may sound fine, it potentially causes the wrong image tuning
parameters to be applied (e.g. tuning parameters for NTSC are applied to
a PAL source), and may confuse users about what the actual standard is
in use.

This commit explicitly configures the color standard the decoder will
use, making it visually obvious if a wrong standard was chosen.

Signed-off-by: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
---
 drivers/media/usb/usbtv/usbtv-video.c | 45 ++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 6cad50d1e5f8..d0bf5eb217b1 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -121,6 +121,25 @@ static int usbtv_select_input(struct usbtv *usbtv, int input)
 	return ret;
 }
 
+static uint16_t usbtv_norm_to_16f_reg(v4l2_std_id norm)
+{
+	/* NTSC M/M-JP/M-KR */
+	if (norm & V4L2_STD_NTSC)
+		return 0x00b8;
+	/* PAL BG/DK/H/I */
+	if (norm & V4L2_STD_PAL)
+		return 0x00ee;
+	/* SECAM B/D/G/H/K/K1/L/Lc */
+	if (norm & V4L2_STD_SECAM)
+		return 0x00ff;
+	if (norm & V4L2_STD_NTSC_443)
+		return 0x00a8;
+	if (norm & (V4L2_STD_PAL_M | V4L2_STD_PAL_60))
+		return 0x00bc;
+	/* Fallback to automatic detection for other standards */
+	return 0x0000;
+}
+
 static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
 {
 	int ret;
@@ -154,7 +173,7 @@ static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
 		{ USBTV_BASE + 0x0263, 0x0017 },
 		{ USBTV_BASE + 0x0266, 0x0016 },
 		{ USBTV_BASE + 0x0267, 0x0036 },
-		/* Epilog */
+		/* End image tuning */
 		{ USBTV_BASE + 0x024e, 0x0002 },
 		{ USBTV_BASE + 0x024f, 0x0002 },
 	};
@@ -182,7 +201,7 @@ static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
 		{ USBTV_BASE + 0x0263, 0x001c },
 		{ USBTV_BASE + 0x0266, 0x0011 },
 		{ USBTV_BASE + 0x0267, 0x0005 },
-		/* Epilog */
+		/* End image tuning */
 		{ USBTV_BASE + 0x024e, 0x0002 },
 		{ USBTV_BASE + 0x024f, 0x0002 },
 	};
@@ -210,7 +229,7 @@ static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
 		{ USBTV_BASE + 0x0263, 0x0021 },
 		{ USBTV_BASE + 0x0266, 0x0016 },
 		{ USBTV_BASE + 0x0267, 0x0036 },
-		/* Epilog */
+		/* End image tuning */
 		{ USBTV_BASE + 0x024e, 0x0002 },
 		{ USBTV_BASE + 0x024f, 0x0002 },
 	};
@@ -218,12 +237,28 @@ static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
 	ret = usbtv_configure_for_norm(usbtv, norm);
 
 	if (!ret) {
-		if (norm & V4L2_STD_525_60)
+		/* Masks for norms using a NTSC or PAL color encoding. */
+		static const v4l2_std_id ntsc_mask =
+			V4L2_STD_NTSC | V4L2_STD_NTSC_443;
+		static const v4l2_std_id pal_mask =
+			V4L2_STD_PAL | V4L2_STD_PAL_60 | V4L2_STD_PAL_M;
+
+		if (norm & ntsc_mask)
 			ret = usbtv_set_regs(usbtv, ntsc, ARRAY_SIZE(ntsc));
-		else if (norm & V4L2_STD_PAL)
+		else if (norm & pal_mask)
 			ret = usbtv_set_regs(usbtv, pal, ARRAY_SIZE(pal));
 		else if (norm & V4L2_STD_SECAM)
 			ret = usbtv_set_regs(usbtv, secam, ARRAY_SIZE(secam));
+		else
+			ret = -EINVAL;
+	}
+
+	if (!ret) {
+		/* Configure the decoder for the color standard */
+		u16 cfg[][2] = {
+			{ USBTV_BASE + 0x016f, usbtv_norm_to_16f_reg(norm) }
+		};
+		ret = usbtv_set_regs(usbtv, cfg, ARRAY_SIZE(cfg));
 	}
 
 	return ret;
-- 
2.17.0
