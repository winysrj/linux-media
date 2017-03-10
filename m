Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33018 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754823AbdCJEyp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 23:54:45 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v5 22/39] media: Add userspace header file for i.MX
Date: Thu,  9 Mar 2017 20:53:02 -0800
Message-Id: <1489121599-23206-23-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a header file for use by userspace programs wanting to interact
with the i.MX media driver. It defines custom v4l2 controls for the
i.MX v4l2 subdevices.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 include/uapi/media/Kbuild |  1 +
 include/uapi/media/imx.h  | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)
 create mode 100644 include/uapi/media/imx.h

diff --git a/include/uapi/media/Kbuild b/include/uapi/media/Kbuild
index aafaa5a..fa78958 100644
--- a/include/uapi/media/Kbuild
+++ b/include/uapi/media/Kbuild
@@ -1 +1,2 @@
 # UAPI Header export list
+header-y += imx.h
diff --git a/include/uapi/media/imx.h b/include/uapi/media/imx.h
new file mode 100644
index 0000000..f573de4
--- /dev/null
+++ b/include/uapi/media/imx.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (c) 2014-2015 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef __UAPI_MEDIA_IMX_H__
+#define __UAPI_MEDIA_IMX_H__
+
+enum imx_ctrl_id {
+	V4L2_CID_IMX_FIM_ENABLE = (V4L2_CID_USER_IMX_BASE + 0),
+	V4L2_CID_IMX_FIM_NUM,
+	V4L2_CID_IMX_FIM_TOLERANCE_MIN,
+	V4L2_CID_IMX_FIM_TOLERANCE_MAX,
+	V4L2_CID_IMX_FIM_NUM_SKIP,
+};
+
+#endif
-- 
2.7.4
