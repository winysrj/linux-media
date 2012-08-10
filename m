Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49782 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab2HJOQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 10:16:13 -0400
Received: by mail-ey0-f174.google.com with SMTP id c11so519125eaa.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 07:16:12 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH v4 1/2] v4l: Add factory register values form S5K4ECGX sensor
Date: Fri, 10 Aug 2012 15:14:55 +0100
Message-Id: <1344608096-22059-2-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1344608096-22059-1-git-send-email-sangwook.lee@linaro.org>
References: <1344608096-22059-1-git-send-email-sangwook.lee@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add preview default settings for S5K4ECGX sensor registers,
which was copied from the reference code of Samsung S.LSI.

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---
 drivers/media/video/s5k4ecgx_regs.h |  138 +++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100644 drivers/media/video/s5k4ecgx_regs.h

diff --git a/drivers/media/video/s5k4ecgx_regs.h b/drivers/media/video/s5k4ecgx_regs.h
new file mode 100644
index 0000000..e99b0e6
--- /dev/null
+++ b/drivers/media/video/s5k4ecgx_regs.h
@@ -0,0 +1,138 @@
+/*
+ * Samsung S5K4ECGX register tables for default values
+ *
+ * Copyright (C) 2012 Linaro
+ * Copyright (C) 2012 Insignal Co,. Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __DRIVERS_MEDIA_VIDEO_S5K4ECGX_H__
+#define __DRIVERS_MEDIA_VIDEO_S5K4ECGX_H__
+
+struct regval_list {
+	u32	addr;
+	u16	val;
+};
+
+/* Configure 720x480 preview size */
+static const struct regval_list s5k4ecgx_720_prev[] = {
+	{ 0x70000250, 0x0a00 },
+	{ 0x70000252, 0x06a8 },
+	{ 0x70000254, 0x0010 },
+	{ 0x70000256, 0x0078 },
+	{ 0x70000258, 0x0a00 },
+	{ 0x7000025a, 0x06a8 },
+	{ 0x7000025c, 0x0010 },
+	{ 0x7000025e, 0x0078 },
+	{ 0x70000494, 0x0a00 },
+
+	/*
+	 * FIXME: according to the datasheet,
+	 * 0x70000496~ 0x7000049c seems to be only for capture mode,
+	 * but without these value, it doesn't work with preview mode.
+	 */
+	{ 0x70000496, 0x06a8 },
+	{ 0x70000498, 0x0000 },
+	{ 0x7000049a, 0x0000 },
+	{ 0x7000049c, 0x0a00 },
+
+	{ 0x7000049e, 0x06a8 },
+	{ 0x700002a6, 0x02d0 },
+	{ 0x700002a8, 0x01e0 },
+	{ 0xffffffff, 0x0000 },	/* End token */
+};
+
+/* Configure 640x480 preview size */
+static const struct regval_list s5k4ecgx_640_prev[] = {
+	{ 0x70000250, 0x0a00 },
+	{ 0x70000252, 0x0780 },
+	{ 0x70000254, 0x0010 },
+	{ 0x70000256, 0x000c },
+	{ 0x70000258, 0x0a00 },
+	{ 0x7000025a, 0x0780 },
+	{ 0x7000025c, 0x0010 },
+	{ 0x7000025e, 0x000c },
+	{ 0x70000494, 0x0a00 },
+	{ 0x70000496, 0x0780 },
+	{ 0x70000498, 0x0000 },
+	{ 0x7000049a, 0x0000 },
+	{ 0x7000049c, 0x0a00 },
+	{ 0x7000049e, 0x0780 },
+	{ 0x700002a6, 0x0280 },
+	{ 0x700002a8, 0x01e0 },
+	{ 0xffffffff, 0x0000 }, /* End token */
+};
+
+/* Configure 352x288 preview size */
+static const struct regval_list s5k4ecgx_352_prev[] = {
+	{ 0x70000250, 0x0928 },
+	{ 0x70000252, 0x0780 },
+	{ 0x70000254, 0x007c },
+	{ 0x70000256, 0x000c },
+	{ 0x70000258, 0x0928 },
+	{ 0x7000025a, 0x0780 },
+	{ 0x7000025c, 0x007c },
+	{ 0x7000025e, 0x000c },
+	{ 0x70000494, 0x0928 },
+	{ 0x70000496, 0x0780 },
+	{ 0x70000498, 0x0000 },
+	{ 0x7000049a, 0x0000 },
+	{ 0x7000049c, 0x0928 },
+	{ 0x7000049e, 0x0780 },
+	{ 0x700002a6, 0x0160 },
+	{ 0x700002a8, 0x0120 },
+	{ 0xffffffff, 0x0000 }, /* End token */
+};
+
+/* Configure 176x144 preview size */
+static const struct regval_list s5k4ecgx_176_prev[] = {
+	{ 0x70000250, 0x0928 },
+	{ 0x70000252, 0x0780 },
+	{ 0x70000254, 0x007c },
+	{ 0x70000256, 0x000c },
+	{ 0x70000258, 0x0928 },
+	{ 0x7000025a, 0x0780 },
+	{ 0x7000025c, 0x007c },
+	{ 0x7000025e, 0x000c },
+	{ 0x70000494, 0x0928 },
+	{ 0x70000496, 0x0780 },
+	{ 0x70000498, 0x0000 },
+	{ 0x7000049a, 0x0000 },
+	{ 0x7000049c, 0x0928 },
+	{ 0x7000049e, 0x0780 },
+	{ 0x700002a6, 0x00b0 },
+	{ 0x700002a8, 0x0090 },
+	{ 0xffffffff, 0x0000 }, /* End token */
+};
+
+/* Common setting 1 for preview */
+static const struct regval_list s5k4ecgx_com1_prev[] = {
+	{ 0x700004a0, 0x0000 },
+	{ 0x700004a2, 0x0000 },
+	{ 0x70000262, 0x0001 },
+	{ 0x70000a1e, 0x0028 },
+	{ 0x70000ad4, 0x003c },
+	{ 0xffffffff, 0x0000 }, /* End token */
+};
+
+/* Common setting 2 for preview */
+static const struct regval_list s5k4ecgx_com2_prev[] = {
+	{ 0x700002aa, 0x0005 },
+	{ 0x700002b4, 0x0052 },
+	{ 0x700002be, 0x0000 },
+	{ 0x700002c0, 0x0001 },
+	{ 0x700002c2, 0x029a },
+	{ 0x700002c4, 0x014d },
+	{ 0x700002d0, 0x0000 },
+	{ 0x700002d2, 0x0000 },
+	{ 0x70000266, 0x0000 },
+	{ 0x7000026a, 0x0001 },
+	{ 0x7000024e, 0x0001 },
+	{ 0x70000268, 0x0001 },
+	{ 0xffffffff, 0x0000 }, /* End token */
+};
+
+#endif	/* __DRIVERS_MEDIA_VIDEO_S5K4ECGX_H__ */
-- 
1.7.9.5

