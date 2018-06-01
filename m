Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38896 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbeFAAbI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 20:31:08 -0400
Received: by mail-pg0-f67.google.com with SMTP id c9-v6so7624294pgf.5
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 17:31:08 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 04/10] media: imx: interweave only for sequential input/interlaced output fields
Date: Thu, 31 May 2018 17:30:43 -0700
Message-Id: <1527813049-3231-5-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IDMAC interlaced scan, a.k.a. interweave, should be enabled at the
IDMAC output pads only if the input field type is 'seq-bt' or 'seq-tb',
and the IDMAC output pad field type is 'interlaced*'. Move this
determination to a new macro idmac_interweave().

V4L2_FIELD_HAS_BOTH() macro should not be used on the input to determine
enabling interlaced/interweave scan. That macro includes the 'interlaced'
field types, and in those cases the data is already interweaved with
top/bottom field lines.

The CSI will capture whole frames when the source specifies alternate
field mode. So the CSI also enables interweave at the IDMAC output pad
for alternate input field type.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 22 ++++++++++++++++++----
 drivers/staging/media/imx/imx-media-csi.c   | 22 ++++++++++++++++++----
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index ae453fd..894db21 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -132,6 +132,18 @@ static inline struct prp_priv *sd_to_priv(struct v4l2_subdev *sd)
 	return ic_priv->task_priv;
 }
 
+/*
+ * If the field type at IDMAC output pad is interlaced, and
+ * the input is sequential fields, the IDMAC output channel
+ * can accommodate by interweaving.
+ */
+static inline bool idmac_interweave(enum v4l2_field outfield,
+				    enum v4l2_field infield)
+{
+	return V4L2_FIELD_IS_INTERLACED(outfield) &&
+		V4L2_FIELD_IS_SEQUENTIAL(infield);
+}
+
 static void prp_put_ipu_resources(struct prp_priv *priv)
 {
 	if (priv->ic)
@@ -353,6 +365,7 @@ static int prp_setup_channel(struct prp_priv *priv,
 	struct v4l2_mbus_framefmt *infmt;
 	unsigned int burst_size;
 	struct ipu_image image;
+	bool interweave;
 	int ret;
 
 	infmt = &priv->format_mbus[PRPENCVF_SINK_PAD];
@@ -365,6 +378,9 @@ static int prp_setup_channel(struct prp_priv *priv,
 	image.rect.width = image.pix.width;
 	image.rect.height = image.pix.height;
 
+	interweave = (idmac_interweave(image.pix.field, infmt->field) &&
+		      channel == priv->out_ch);
+
 	if (rot_swap_width_height) {
 		swap(image.pix.width, image.pix.height);
 		swap(image.rect.width, image.rect.height);
@@ -405,9 +421,7 @@ static int prp_setup_channel(struct prp_priv *priv,
 	if (rot_mode)
 		ipu_cpmem_set_rotation(channel, rot_mode);
 
-	if (image.pix.field == V4L2_FIELD_NONE &&
-	    V4L2_FIELD_HAS_BOTH(infmt->field) &&
-	    channel == priv->out_ch)
+	if (interweave)
 		ipu_cpmem_interlaced_scan(channel, image.pix.bytesperline);
 
 	ret = ipu_ic_task_idma_init(priv->ic, channel,
@@ -833,7 +847,7 @@ static void prp_try_fmt(struct prp_priv *priv,
 	infmt = __prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD, sdformat->which);
 
 	if (sdformat->pad == PRPENCVF_SRC_PAD) {
-		if (sdformat->format.field != V4L2_FIELD_NONE)
+		if (!V4L2_FIELD_IS_INTERLACED(sdformat->format.field))
 			sdformat->format.field = infmt->field;
 
 		prp_bound_align_output(&sdformat->format, infmt,
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 9bc555c..2c77ef9 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -128,6 +128,19 @@ static inline bool is_parallel_16bit_bus(struct v4l2_fwnode_endpoint *ep)
 }
 
 /*
+ * If the field type at IDMAC output pad is interlaced, and
+ * the input is sequential or alternating fields, the IDMAC
+ * output channel can accommodate by interweaving.
+ */
+static inline bool idmac_interweave(enum v4l2_field outfield,
+				    enum v4l2_field infield)
+{
+	return V4L2_FIELD_IS_INTERLACED(outfield) &&
+		(V4L2_FIELD_IS_SEQUENTIAL(infield) ||
+		 infield == V4L2_FIELD_ALTERNATE);
+}
+
+/*
  * Parses the fwnode endpoint from the source pad of the entity
  * connected to this CSI. This will either be the entity directly
  * upstream from the CSI-2 receiver, or directly upstream from the
@@ -368,10 +381,10 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 {
 	struct imx_media_video_dev *vdev = priv->vdev;
 	struct v4l2_mbus_framefmt *infmt;
+	bool passthrough, interweave;
 	struct ipu_image image;
 	u32 passthrough_bits;
 	dma_addr_t phys[2];
-	bool passthrough;
 	u32 burst_size;
 	int ret;
 
@@ -389,6 +402,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	image.phys0 = phys[0];
 	image.phys1 = phys[1];
 
+	interweave = idmac_interweave(image.pix.field, infmt->field);
+
 	/*
 	 * Check for conditions that require the IPU to handle the
 	 * data internally as generic data, aka passthrough mode:
@@ -476,8 +491,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 
 	ipu_smfc_set_burstsize(priv->smfc, burst_size);
 
-	if (image.pix.field == V4L2_FIELD_NONE &&
-	    V4L2_FIELD_HAS_BOTH(infmt->field))
+	if (interweave)
 		ipu_cpmem_interlaced_scan(priv->idmac_ch,
 					  image.pix.bytesperline);
 
@@ -1294,7 +1308,7 @@ static void csi_try_fmt(struct csi_priv *priv,
 		}
 
 		if (sdformat->pad == CSI_SRC_PAD_DIRECT ||
-		    sdformat->format.field != V4L2_FIELD_NONE)
+		    !V4L2_FIELD_IS_INTERLACED(sdformat->format.field))
 			sdformat->format.field = infmt->field;
 
 		/*
-- 
2.7.4
