Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36297 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423242AbdEYAbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 20:31:40 -0400
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
        devel@driverdev.osuosl.org, Marek Vasut <marex@denx.de>
Subject: [PATCH v7 34/34] media: imx: Drop warning upon multiple S_STREAM disable calls
Date: Wed, 24 May 2017 17:29:49 -0700
Message-Id: <1495672189-29164-35-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Vasut <marex@denx.de>

Calling S_STREAM OFF multiple times on a video device is valid, although
dubious, practice. Instead of warning about it and setting stream count
lower than zero, just ignore the subsequent S_STREAM calls and correct
the stream count to zero.

Signed-off-by: Marek Vasut <marex@denx.de>
---
 drivers/staging/media/imx/imx-ic-prp.c      | 3 ++-
 drivers/staging/media/imx/imx-ic-prpencvf.c | 3 ++-
 drivers/staging/media/imx/imx-media-csi.c   | 3 ++-
 drivers/staging/media/imx/imx-media-vdic.c  | 3 ++-
 drivers/staging/media/imx/imx6-mipi-csi2.c  | 3 ++-
 5 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index 7bc293a..c34367e 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -387,7 +387,8 @@ static int prp_s_stream(struct v4l2_subdev *sd, int enable)
 
 update_count:
 	priv->stream_count += enable ? 1 : -1;
-	WARN_ON(priv->stream_count < 0);
+	if (priv->stream_count < 0)
+		priv->stream_count = 0;
 out:
 	mutex_unlock(&priv->lock);
 	return ret;
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 5e9c817..ed363fe 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -1140,7 +1140,8 @@ static int prp_s_stream(struct v4l2_subdev *sd, int enable)
 
 update_count:
 	priv->stream_count += enable ? 1 : -1;
-	WARN_ON(priv->stream_count < 0);
+	if (priv->stream_count < 0)
+		priv->stream_count = 0;
 out:
 	mutex_unlock(&priv->lock);
 	return ret;
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 4ab401d..0ec3176 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -861,7 +861,8 @@ static int csi_s_stream(struct v4l2_subdev *sd, int enable)
 
 update_count:
 	priv->stream_count += enable ? 1 : -1;
-	WARN_ON(priv->stream_count < 0);
+	if (priv->stream_count < 0)
+		priv->stream_count = 0;
 out:
 	mutex_unlock(&priv->lock);
 	return ret;
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index c0b6d7f..7eabdc4 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -536,7 +536,8 @@ static int vdic_s_stream(struct v4l2_subdev *sd, int enable)
 
 update_count:
 	priv->stream_count += enable ? 1 : -1;
-	WARN_ON(priv->stream_count < 0);
+	if (priv->stream_count < 0)
+		priv->stream_count = 0;
 out:
 	mutex_unlock(&priv->lock);
 	return ret;
diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index 49bc2c2..cfaf34a 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -396,7 +396,8 @@ static int csi2_s_stream(struct v4l2_subdev *sd, int enable)
 
 update_count:
 	csi2->stream_count += enable ? 1 : -1;
-	WARN_ON(csi2->stream_count < 0);
+	if (csi2->stream_count < 0)
+		csi2->stream_count = 0;
 out:
 	mutex_unlock(&csi2->lock);
 	return ret;
-- 
2.7.4
