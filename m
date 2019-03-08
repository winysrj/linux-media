Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FDFC10F0C
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FAF720857
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfCHXtl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 18:49:41 -0500
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:33157 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbfCHXtl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 18:49:41 -0500
X-Halon-ID: d458cdf2-41fc-11e9-846a-005056917a89
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-01.atm.binero.net (Halon) with ESMTPA
        id d458cdf2-41fc-11e9-846a-005056917a89;
        Sat, 09 Mar 2019 00:49:37 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 2/2] rcar-csi2: Use standby mode instead of resetting
Date:   Sat,  9 Mar 2019 00:47:22 +0100
Message-Id: <20190308234722.25775-3-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190308234722.25775-1-niklas.soderlund+renesas@ragnatech.se>
References: <20190308234722.25775-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Later versions of the datasheet updates the reset procedure to more
closely resemble the standby mode. Update the driver to enter and exit
the standby mode instead of resetting the hardware before and after
streaming is started and stopped.

While at it break out the full start and stop procedures from
rcsi2_s_stream() into the existing helper functions.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/Kconfig     |  1 +
 drivers/media/platform/rcar-vin/rcar-csi2.c | 69 +++++++++++++--------
 2 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index e3eb8fee253658da..f26f47e3bcf44825 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_RCAR_CSI2
 	tristate "R-Car MIPI CSI-2 Receiver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
 	depends on ARCH_RENESAS || COMPILE_TEST
+	select RESET_CONTROLLER
 	select V4L2_FWNODE
 	help
 	  Support for Renesas R-Car MIPI CSI-2 receiver.
diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index f64528d2be3c95dd..7a1c9b549e0fffc6 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -14,6 +14,7 @@
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/reset.h>
 #include <linux/sys_soc.h>
 
 #include <media/v4l2-ctrls.h>
@@ -350,6 +351,7 @@ struct rcar_csi2 {
 	struct device *dev;
 	void __iomem *base;
 	const struct rcar_csi2_info *info;
+	struct reset_control *rstc;
 
 	struct v4l2_subdev subdev;
 	struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
@@ -387,11 +389,19 @@ static void rcsi2_write(struct rcar_csi2 *priv, unsigned int reg, u32 data)
 	iowrite32(data, priv->base + reg);
 }
 
-static void rcsi2_reset(struct rcar_csi2 *priv)
+static void rcsi2_enter_standby(struct rcar_csi2 *priv)
 {
-	rcsi2_write(priv, SRST_REG, SRST_SRST);
+	rcsi2_write(priv, PHYCNT_REG, 0);
+	rcsi2_write(priv, PHTC_REG, PHTC_TESTCLR);
+	reset_control_assert(priv->rstc);
 	usleep_range(100, 150);
-	rcsi2_write(priv, SRST_REG, 0);
+	pm_runtime_put(priv->dev);
+}
+
+static void rcsi2_exit_standby(struct rcar_csi2 *priv)
+{
+	pm_runtime_get_sync(priv->dev);
+	reset_control_deassert(priv->rstc);
 }
 
 static int rcsi2_wait_phy_start(struct rcar_csi2 *priv)
@@ -462,7 +472,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
 	return mbps;
 }
 
-static int rcsi2_start(struct rcar_csi2 *priv)
+static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 {
 	const struct rcar_csi2_format *format;
 	u32 phycnt, vcdt = 0, vcdt2 = 0;
@@ -506,7 +516,6 @@ static int rcsi2_start(struct rcar_csi2 *priv)
 
 	/* Init */
 	rcsi2_write(priv, TREF_REG, TREF_TREF);
-	rcsi2_reset(priv);
 	rcsi2_write(priv, PHTC_REG, 0);
 
 	/* Configure */
@@ -564,19 +573,36 @@ static int rcsi2_start(struct rcar_csi2 *priv)
 	return 0;
 }
 
+static int rcsi2_start(struct rcar_csi2 *priv)
+{
+	int ret;
+
+	rcsi2_exit_standby(priv);
+
+	ret = rcsi2_start_receiver(priv);
+	if (ret) {
+		rcsi2_enter_standby(priv);
+		return ret;
+	}
+
+	ret = v4l2_subdev_call(priv->remote, video, s_stream, 1);
+	if (ret) {
+		rcsi2_enter_standby(priv);
+		return ret;
+	}
+
+	return 0;
+}
+
 static void rcsi2_stop(struct rcar_csi2 *priv)
 {
-	rcsi2_write(priv, PHYCNT_REG, 0);
-
-	rcsi2_reset(priv);
-
-	rcsi2_write(priv, PHTC_REG, PHTC_TESTCLR);
+	v4l2_subdev_call(priv->remote, video, s_stream, 0);
+	rcsi2_enter_standby(priv);
 }
 
 static int rcsi2_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct rcar_csi2 *priv = sd_to_csi2(sd);
-	struct v4l2_subdev *nextsd;
 	int ret = 0;
 
 	mutex_lock(&priv->lock);
@@ -586,27 +612,12 @@ static int rcsi2_s_stream(struct v4l2_subdev *sd, int enable)
 		goto out;
 	}
 
-	nextsd = priv->remote;
-
 	if (enable && priv->stream_count == 0) {
-		pm_runtime_get_sync(priv->dev);
-
 		ret = rcsi2_start(priv);
-		if (ret) {
-			pm_runtime_put(priv->dev);
+		if (ret)
 			goto out;
-		}
-
-		ret = v4l2_subdev_call(nextsd, video, s_stream, 1);
-		if (ret) {
-			rcsi2_stop(priv);
-			pm_runtime_put(priv->dev);
-			goto out;
-		}
 	} else if (!enable && priv->stream_count == 1) {
 		rcsi2_stop(priv);
-		v4l2_subdev_call(nextsd, video, s_stream, 0);
-		pm_runtime_put(priv->dev);
 	}
 
 	priv->stream_count += enable ? 1 : -1;
@@ -936,6 +947,10 @@ static int rcsi2_probe_resources(struct rcar_csi2 *priv,
 	if (irq < 0)
 		return irq;
 
+	priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
+	if (IS_ERR(priv->rstc))
+		return PTR_ERR(priv->rstc);
+
 	return 0;
 }
 
-- 
2.21.0

