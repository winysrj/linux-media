Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33318 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754090AbdC1Amu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 20:42:50 -0400
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
Subject: [PATCH v6 33/39] media: imx: csi: Avoid faulty sensor frames at stream start
Date: Mon, 27 Mar 2017 17:40:50 -0700
Message-Id: <1490661656-10318-34-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the attached sensor reports faulty frames at stream start via
g_skip_frames callback, add a delay to avoid them before enabling
the CSI hardware. Especially for sensors with a bt.656 interface,
any shifts in the SAV/EAV sync codes will cause the CSI to lose
vert/horiz sync.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index d9c3a3b..8597d7e 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -9,6 +9,7 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
+#include <linux/delay.h>
 #include <linux/gcd.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
@@ -591,6 +592,7 @@ static int csi_setup(struct csi_priv *priv)
 
 static int csi_start(struct csi_priv *priv)
 {
+	u32 bad_frames = 0;
 	int ret;
 
 	if (!priv->sensor) {
@@ -598,6 +600,25 @@ static int csi_start(struct csi_priv *priv)
 		return -EINVAL;
 	}
 
+	ret = v4l2_subdev_call(priv->sensor->sd, sensor,
+			       g_skip_frames, &bad_frames);
+	if (!ret && bad_frames) {
+		struct v4l2_fract *fi = &priv->frame_interval;
+		u32 delay_usec;
+
+		/*
+		 * This sensor has bad frames when it is turned on,
+		 * add a delay to avoid them before enabling the CSI
+		 * hardware. Especially for sensors with a bt.656 interface,
+		 * any shifts in the SAV/EAV sync codes will cause the CSI
+		 * to lose vert/horiz sync.
+		 */
+		delay_usec = DIV_ROUND_UP_ULL(
+			(u64)USEC_PER_SEC * fi->numerator * bad_frames,
+			fi->denominator);
+		usleep_range(delay_usec, delay_usec + 1000);
+	}
+
 	if (priv->dest == IPU_CSI_DEST_IDMAC) {
 		ret = csi_idmac_start(priv);
 		if (ret)
-- 
2.7.4
