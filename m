Return-path: <linux-media-owner@vger.kernel.org>
Received: from [31.36.214.240] ([31.36.214.240]:39082 "EHLO
        val.bonstra.fr.eu.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbeDHVVG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 17:21:06 -0400
From: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
Subject: [PATCH v2 1/6] usbtv: Use same decoder sequence as Windows driver
Date: Sun,  8 Apr 2018 23:11:56 +0200
Message-Id: <20180408211201.27452-2-bonstra@bonstra.fr.eu.org>
In-Reply-To: <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
References: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
 <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Re-format the register {address, value} pairs so they follow the same
order as the decoder configuration sequences in the Windows driver's .INF
file.

For instance, for PAL, the "AVPAL" sequence in the .INF file is:
0x04,0x68,0xD3,0x72,0xA2,0xB0,0x15,0x01,0x2C,0x10,0x20,0x2e,0x08,0x02,
0x02,0x59,0x16,0x35,0x17,0x16,0x36

Signed-off-by: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
---
 drivers/media/usb/usbtv/usbtv-video.c | 40 +++++++++++++++++++--------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 3668a04359e8..97f9790954f9 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -124,40 +124,67 @@ static int usbtv_select_input(struct usbtv *usbtv, int input)
 static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
 {
 	int ret;
+	/* These are the series of register values used to configure the
+	 * decoder for a specific standard.
+	 * The first 21 register writes are copied from the
+	 * Settings\DecoderDefaults registry keys present in the Windows driver
+	 * .INF file, and control various image tuning parameters (color
+	 * correction, sharpness, ...).
+	 */
 	static const u16 pal[][2] = {
+		/* "AVPAL" tuning sequence from .INF file */
+		{ USBTV_BASE + 0x0003, 0x0004 },
 		{ USBTV_BASE + 0x001a, 0x0068 },
+		{ USBTV_BASE + 0x0100, 0x00d3 },
 		{ USBTV_BASE + 0x010e, 0x0072 },
 		{ USBTV_BASE + 0x010f, 0x00a2 },
 		{ USBTV_BASE + 0x0112, 0x00b0 },
+		{ USBTV_BASE + 0x0115, 0x0015 },
 		{ USBTV_BASE + 0x0117, 0x0001 },
 		{ USBTV_BASE + 0x0118, 0x002c },
 		{ USBTV_BASE + 0x012d, 0x0010 },
 		{ USBTV_BASE + 0x012f, 0x0020 },
+		{ USBTV_BASE + 0x0220, 0x002e },
+		{ USBTV_BASE + 0x0225, 0x0008 },
+		{ USBTV_BASE + 0x024e, 0x0002 },
 		{ USBTV_BASE + 0x024f, 0x0002 },
 		{ USBTV_BASE + 0x0254, 0x0059 },
 		{ USBTV_BASE + 0x025a, 0x0016 },
 		{ USBTV_BASE + 0x025b, 0x0035 },
 		{ USBTV_BASE + 0x0263, 0x0017 },
 		{ USBTV_BASE + 0x0266, 0x0016 },
-		{ USBTV_BASE + 0x0267, 0x0036 }
+		{ USBTV_BASE + 0x0267, 0x0036 },
+		/* Epilog */
+		{ USBTV_BASE + 0x024e, 0x0002 },
+		{ USBTV_BASE + 0x024f, 0x0002 },
 	};
 
 	static const u16 ntsc[][2] = {
+		/* "AVNTSC" tuning sequence from .INF file */
+		{ USBTV_BASE + 0x0003, 0x0004 },
 		{ USBTV_BASE + 0x001a, 0x0079 },
+		{ USBTV_BASE + 0x0100, 0x00d3 },
 		{ USBTV_BASE + 0x010e, 0x0068 },
 		{ USBTV_BASE + 0x010f, 0x009c },
 		{ USBTV_BASE + 0x0112, 0x00f0 },
+		{ USBTV_BASE + 0x0115, 0x0015 },
 		{ USBTV_BASE + 0x0117, 0x0000 },
 		{ USBTV_BASE + 0x0118, 0x00fc },
 		{ USBTV_BASE + 0x012d, 0x0004 },
 		{ USBTV_BASE + 0x012f, 0x0008 },
+		{ USBTV_BASE + 0x0220, 0x002e },
+		{ USBTV_BASE + 0x0225, 0x0008 },
+		{ USBTV_BASE + 0x024e, 0x0002 },
 		{ USBTV_BASE + 0x024f, 0x0001 },
 		{ USBTV_BASE + 0x0254, 0x005f },
 		{ USBTV_BASE + 0x025a, 0x0012 },
 		{ USBTV_BASE + 0x025b, 0x0001 },
 		{ USBTV_BASE + 0x0263, 0x001c },
 		{ USBTV_BASE + 0x0266, 0x0011 },
-		{ USBTV_BASE + 0x0267, 0x0005 }
+		{ USBTV_BASE + 0x0267, 0x0005 },
+		/* Epilog */
+		{ USBTV_BASE + 0x024e, 0x0002 },
+		{ USBTV_BASE + 0x024f, 0x0002 },
 	};
 
 	ret = usbtv_configure_for_norm(usbtv, norm);
@@ -236,15 +263,6 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
 		{ USBTV_BASE + 0x0158, 0x001f },
 		{ USBTV_BASE + 0x0159, 0x0006 },
 		{ USBTV_BASE + 0x015d, 0x0000 },
-
-		{ USBTV_BASE + 0x0003, 0x0004 },
-		{ USBTV_BASE + 0x0100, 0x00d3 },
-		{ USBTV_BASE + 0x0115, 0x0015 },
-		{ USBTV_BASE + 0x0220, 0x002e },
-		{ USBTV_BASE + 0x0225, 0x0008 },
-		{ USBTV_BASE + 0x024e, 0x0002 },
-		{ USBTV_BASE + 0x024e, 0x0002 },
-		{ USBTV_BASE + 0x024f, 0x0002 },
 	};
 
 	ret = usbtv_set_regs(usbtv, setup, ARRAY_SIZE(setup));
-- 
2.17.0
