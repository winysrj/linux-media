Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34551 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932631AbdCJEzK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 23:55:10 -0500
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
        Russell King <rmk+kernel@armlinux.org.uk>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v5 35/39] media: imx: csi/fim: add support for frame intervals
Date: Thu,  9 Mar 2017 20:53:15 -0800
Message-Id: <1489121599-23206-36-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk+kernel@armlinux.org.uk>

Add support to CSI for negotiation of frame intervals, and use this
information to configure the frame interval monitor.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 46 +++++++++++++++++++++++++++++--
 drivers/staging/media/imx/imx-media-fim.c | 28 +++++++------------
 drivers/staging/media/imx/imx-media.h     |  2 +-
 3 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 6640869..b556fa4 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -63,6 +63,7 @@ struct csi_priv {
 
 	struct v4l2_mbus_framefmt format_mbus[CSI_NUM_PADS];
 	const struct imx_media_pixfmt *cc[CSI_NUM_PADS];
+	struct v4l2_fract frame_interval;
 	struct v4l2_rect crop;
 
 	/* active vb2 buffers to send to video dev sink */
@@ -570,7 +571,8 @@ static int csi_start(struct csi_priv *priv)
 
 	/* start the frame interval monitor */
 	if (priv->fim) {
-		ret = imx_media_fim_set_stream(priv->fim, priv->sensor, true);
+		ret = imx_media_fim_set_stream(priv->fim,
+					       &priv->frame_interval, true);
 		if (ret)
 			goto idmac_stop;
 	}
@@ -585,7 +587,8 @@ static int csi_start(struct csi_priv *priv)
 
 fim_off:
 	if (priv->fim)
-		imx_media_fim_set_stream(priv->fim, priv->sensor, false);
+		imx_media_fim_set_stream(priv->fim,
+					 &priv->frame_interval, false);
 idmac_stop:
 	if (priv->dest == IPU_CSI_DEST_IDMAC)
 		csi_idmac_stop(priv);
@@ -599,7 +602,8 @@ static void csi_stop(struct csi_priv *priv)
 
 	/* stop the frame interval monitor */
 	if (priv->fim)
-		imx_media_fim_set_stream(priv->fim, priv->sensor, false);
+		imx_media_fim_set_stream(priv->fim,
+					 &priv->frame_interval, false);
 
 	ipu_csi_disable(priv->csi);
 }
@@ -608,6 +612,36 @@ static void csi_stop(struct csi_priv *priv)
  * V4L2 subdev operations.
  */
 
+static int csi_g_frame_interval(struct v4l2_subdev *sd,
+				struct v4l2_subdev_frame_interval *fi)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+
+	mutex_lock(&priv->lock);
+	fi->interval = priv->frame_interval;
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
+static int csi_s_frame_interval(struct v4l2_subdev *sd,
+				struct v4l2_subdev_frame_interval *fi)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+
+	mutex_lock(&priv->lock);
+
+	/* Output pads mirror active input pad, no limits on input pads */
+	if (fi->pad == CSI_SRC_PAD_IDMAC || fi->pad == CSI_SRC_PAD_DIRECT)
+		fi->interval = priv->frame_interval;
+
+	priv->frame_interval = fi->interval;
+
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
 static int csi_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
@@ -1204,6 +1238,10 @@ static int csi_registered(struct v4l2_subdev *sd)
 			goto put_csi;
 	}
 
+	/* init default frame interval */
+	priv->frame_interval.numerator = 1;
+	priv->frame_interval.denominator = 30;
+
 	priv->fim = imx_media_fim_init(&priv->sd);
 	if (IS_ERR(priv->fim)) {
 		ret = PTR_ERR(priv->fim);
@@ -1254,6 +1292,8 @@ static struct v4l2_subdev_core_ops csi_core_ops = {
 };
 
 static struct v4l2_subdev_video_ops csi_video_ops = {
+	.g_frame_interval = csi_g_frame_interval,
+	.s_frame_interval = csi_s_frame_interval,
 	.s_stream = csi_s_stream,
 };
 
diff --git a/drivers/staging/media/imx/imx-media-fim.c b/drivers/staging/media/imx/imx-media-fim.c
index 824d257..4fe5ffc 100644
--- a/drivers/staging/media/imx/imx-media-fim.c
+++ b/drivers/staging/media/imx/imx-media-fim.c
@@ -67,26 +67,18 @@ struct imx_media_fim {
 };
 
 static void update_fim_nominal(struct imx_media_fim *fim,
-			       struct imx_media_subdev *sensor)
+			       const struct v4l2_fract *fi)
 {
-	struct v4l2_streamparm parm;
-	struct v4l2_fract tpf;
-	int ret;
-
-	parm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	ret = v4l2_subdev_call(sensor->sd, video, g_parm, &parm);
-	tpf = parm.parm.capture.timeperframe;
-
-	if (ret || tpf.denominator == 0) {
-		dev_dbg(fim->sd->dev, "no tpf from sensor, FIM disabled\n");
+	if (fi->denominator == 0) {
+		dev_dbg(fim->sd->dev, "no frame interval, FIM disabled\n");
 		fim->enabled = false;
 		return;
 	}
 
-	fim->nominal = DIV_ROUND_CLOSEST(1000 * 1000 * tpf.numerator,
-					 tpf.denominator);
+	fim->nominal = DIV_ROUND_CLOSEST_ULL(1000000ULL * (u64)fi->numerator,
+					     fi->denominator);
 
-	dev_dbg(fim->sd->dev, "sensor FI=%lu usec\n", fim->nominal);
+	dev_dbg(fim->sd->dev, "FI=%lu usec\n", fim->nominal);
 }
 
 static void reset_fim(struct imx_media_fim *fim, bool curval)
@@ -130,8 +122,8 @@ static void send_fim_event(struct imx_media_fim *fim, unsigned long error)
 
 /*
  * Monitor an averaged frame interval. If the average deviates too much
- * from the sensor's nominal frame rate, send the frame interval error
- * event. The frame intervals are averaged in order to quiet noise from
+ * from the nominal frame rate, send the frame interval error event. The
+ * frame intervals are averaged in order to quiet noise from
  * (presumably random) interrupt latency.
  */
 static void frame_interval_monitor(struct imx_media_fim *fim,
@@ -422,12 +414,12 @@ EXPORT_SYMBOL_GPL(imx_media_fim_set_power);
 
 /* Called by the subdev in its s_stream callback */
 int imx_media_fim_set_stream(struct imx_media_fim *fim,
-			     struct imx_media_subdev *sensor,
+			     const struct v4l2_fract *fi,
 			     bool on)
 {
 	if (on) {
 		reset_fim(fim, true);
-		update_fim_nominal(fim, sensor);
+		update_fim_nominal(fim, fi);
 
 		if (fim->icap_channel >= 0)
 			fim_acquire_first_ts(fim);
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index 9e865fa..a67ee14 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -262,7 +262,7 @@ struct imx_media_fim;
 void imx_media_fim_eof_monitor(struct imx_media_fim *fim, struct timespec *ts);
 int imx_media_fim_set_power(struct imx_media_fim *fim, bool on);
 int imx_media_fim_set_stream(struct imx_media_fim *fim,
-			     struct imx_media_subdev *sensor,
+			     const struct v4l2_fract *frame_interval,
 			     bool on);
 struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd);
 void imx_media_fim_free(struct imx_media_fim *fim);
-- 
2.7.4
