Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbbHWUSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Mahati Chamarthy <mahati.chamarthy@gmail.com>,
	Jiayi Ye <yejiayily@gmail.com>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	devel@driverdev.osuosl.org
Subject: [PATCH v7 29/44] [media] omap3/omap4/davinci: get rid of MEDIA_ENT_T_V4L2_SUBDEV abuse
Date: Sun, 23 Aug 2015 17:17:46 -0300
Message-Id: <a7a61c319c89810f09d01dee9ed7bf2d38a31b4d.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On omap3/omap4/davinci drivers, MEDIA_ENT_T_V4L2_SUBDEV macro is
abused in order to "simplify" the pad checks.

Basically, it does a logical or of this macro, in order to check
for a local index and if the entity is either a subdev or not.

As we'll get rid of MEDIA_ENT_T_V4L2_SUBDEV macro, replace it by
2 << 16 where it occurs, and add a note saying that the code
there is actually a hack.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 27555e4f4aa8..6b5c52b7f755 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2513,9 +2513,14 @@ static int ccdc_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
 	struct isp_device *isp = to_isp_device(ccdc);
+	int index = local->index;
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case CCDC_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	/* FIXME: this is actually a hack! */
+	if (is_media_entity_v4l2_subdev(remote->entity))
+		index |= 2 << 16;
+
+	switch (index) {
+	case CCDC_PAD_SINK | 2 << 16:
 		/* Read from the sensor (parallel interface), CCP2, CSI2a or
 		 * CSI2c.
 		 */
@@ -2543,7 +2548,7 @@ static int ccdc_link_setup(struct media_entity *entity,
 	 * Revisit this when it will be implemented, and return -EBUSY for now.
 	 */
 
-	case CCDC_PAD_SOURCE_VP | MEDIA_ENT_T_V4L2_SUBDEV:
+	case CCDC_PAD_SOURCE_VP | 2 << 16:
 		/* Write to preview engine, histogram and H3A. When none of
 		 * those links are active, the video port can be disabled.
 		 */
@@ -2556,7 +2561,7 @@ static int ccdc_link_setup(struct media_entity *entity,
 		}
 		break;
 
-	case CCDC_PAD_SOURCE_OF | MEDIA_ENT_T_DEVNODE:
+	case CCDC_PAD_SOURCE_OF:
 		/* Write to memory */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (ccdc->output & ~CCDC_OUTPUT_MEMORY)
@@ -2567,7 +2572,7 @@ static int ccdc_link_setup(struct media_entity *entity,
 		}
 		break;
 
-	case CCDC_PAD_SOURCE_OF | MEDIA_ENT_T_V4L2_SUBDEV:
+	case CCDC_PAD_SOURCE_OF | 2 << 16:
 		/* Write to resizer */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (ccdc->output & ~CCDC_OUTPUT_RESIZER)
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index b215eb5049d6..ba9e90aec36c 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -956,9 +956,14 @@ static int ccp2_link_setup(struct media_entity *entity,
 {
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
+	int index = local_index;
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case CCP2_PAD_SINK | MEDIA_ENT_T_DEVNODE:
+	/* FIXME: this is actually a hack! */
+	if (is_media_entity_v4l2_subdev(remote->entity))
+		index |= 2 << 16;
+
+	switch (index) {
+	case CCP2_PAD_SINK:
 		/* read from memory */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (ccp2->input == CCP2_INPUT_SENSOR)
@@ -970,7 +975,7 @@ static int ccp2_link_setup(struct media_entity *entity,
 		}
 		break;
 
-	case CCP2_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	case CCP2_PAD_SINK | 2 << 16:
 		/* read from sensor/phy */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (ccp2->input == CCP2_INPUT_MEMORY)
@@ -981,7 +986,7 @@ static int ccp2_link_setup(struct media_entity *entity,
 				ccp2->input = CCP2_INPUT_NONE;
 		} break;
 
-	case CCP2_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+	case CCP2_PAD_SOURCE | 2 << 16:
 		/* write to video port/ccdc */
 		if (flags & MEDIA_LNK_FL_ENABLED)
 			ccp2->output = CCP2_OUTPUT_CCDC;
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index fcefc1e74881..054e25e1f2ec 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1144,14 +1144,19 @@ static int csi2_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct isp_csi2_ctrl_cfg *ctrl = &csi2->ctrl;
+	int index = local->index;
 
 	/*
 	 * The ISP core doesn't support pipelines with multiple video outputs.
 	 * Revisit this when it will be implemented, and return -EBUSY for now.
 	 */
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case CSI2_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+	/* FIXME: this is actually a hack! */
+	if (is_media_entity_v4l2_subdev(remote->entity))
+		index |= 2 << 16;
+
+	switch (index) {
+	case CSI2_PAD_SOURCE:
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (csi2->output & ~CSI2_OUTPUT_MEMORY)
 				return -EBUSY;
@@ -1161,7 +1166,7 @@ static int csi2_link_setup(struct media_entity *entity,
 		}
 		break;
 
-	case CSI2_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+	case CSI2_PAD_SOURCE | 2 << 16:
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (csi2->output & ~CSI2_OUTPUT_CCDC)
 				return -EBUSY;
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index ad38d20c7770..4e16feb0e929 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2144,9 +2144,14 @@ static int preview_link_setup(struct media_entity *entity,
 {
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
+	int index = local->index;
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case PREV_PAD_SINK | MEDIA_ENT_T_DEVNODE:
+	/* FIXME: this is actually a hack! */
+	if (is_media_entity_v4l2_subdev(remote->entity))
+		index |= 2 << 16;
+
+	switch (index) {
+	case PREV_PAD_SINK:
 		/* read from memory */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (prev->input == PREVIEW_INPUT_CCDC)
@@ -2158,7 +2163,7 @@ static int preview_link_setup(struct media_entity *entity,
 		}
 		break;
 
-	case PREV_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	case PREV_PAD_SINK | 2 << 16:
 		/* read from ccdc */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (prev->input == PREVIEW_INPUT_MEMORY)
@@ -2175,7 +2180,7 @@ static int preview_link_setup(struct media_entity *entity,
 	 * Revisit this when it will be implemented, and return -EBUSY for now.
 	 */
 
-	case PREV_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+	case PREV_PAD_SOURCE:
 		/* write to memory */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (prev->output & ~PREVIEW_OUTPUT_MEMORY)
@@ -2186,7 +2191,7 @@ static int preview_link_setup(struct media_entity *entity,
 		}
 		break;
 
-	case PREV_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+	case PREV_PAD_SOURCE | 2 << 16:
 		/* write to resizer */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (prev->output & ~PREVIEW_OUTPUT_RESIZER)
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index b48ad4d4b834..a05975d90153 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1623,9 +1623,14 @@ static int resizer_link_setup(struct media_entity *entity,
 {
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+	int index = local->index;
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case RESZ_PAD_SINK | MEDIA_ENT_T_DEVNODE:
+	/* FIXME: this is actually a hack! */
+	if (is_media_entity_v4l2_subdev(remote->entity))
+		index |= 2 << 16;
+
+	switch (index) {
+	case RESZ_PAD_SINK:
 		/* read from memory */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (res->input == RESIZER_INPUT_VP)
@@ -1637,7 +1642,7 @@ static int resizer_link_setup(struct media_entity *entity,
 		}
 		break;
 
-	case RESZ_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	case RESZ_PAD_SINK | 2 << 16:
 		/* read from ccdc or previewer */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (res->input == RESIZER_INPUT_MEMORY)
@@ -1649,7 +1654,7 @@ static int resizer_link_setup(struct media_entity *entity,
 		}
 		break;
 
-	case RESZ_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+	case RESZ_PAD_SOURCE:
 		/* resizer always write to memory */
 		break;
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index d96bdaaae50e..b66584ecb693 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -885,9 +885,14 @@ ipipeif_link_setup(struct media_entity *entity, const struct media_pad *local,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct vpfe_device *vpfe = to_vpfe_device(ipipeif);
+	int index = local->index;
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case IPIPEIF_PAD_SINK | MEDIA_ENT_T_DEVNODE:
+	/* FIXME: this is actually a hack! */
+	if (is_media_entity_v4l2_subdev(remote->entity))
+		index |= 2 << 16;
+
+	switch (index) {
+	case IPIPEIF_PAD_SINK:
 		/* Single shot mode */
 		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 			ipipeif->input = IPIPEIF_INPUT_NONE;
@@ -896,7 +901,7 @@ ipipeif_link_setup(struct media_entity *entity, const struct media_pad *local,
 		ipipeif->input = IPIPEIF_INPUT_MEMORY;
 		break;
 
-	case IPIPEIF_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	case IPIPEIF_PAD_SINK | 2 << 16:
 		/* read from isif */
 		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 			ipipeif->input = IPIPEIF_INPUT_NONE;
@@ -908,7 +913,7 @@ ipipeif_link_setup(struct media_entity *entity, const struct media_pad *local,
 		ipipeif->input = IPIPEIF_INPUT_ISIF;
 		break;
 
-	case IPIPEIF_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+	case IPIPEIF_PAD_SOURCE | 2 << 16:
 		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 			ipipeif->output = IPIPEIF_OUTPUT_NONE;
 			break;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index df77288b0ec0..8ca0c1297ec8 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -1707,9 +1707,14 @@ isif_link_setup(struct media_entity *entity, const struct media_pad *local,
 {
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct vpfe_isif_device *isif = v4l2_get_subdevdata(sd);
+	int index = local->index;
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case ISIF_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	/* FIXME: this is actually a hack! */
+	if (is_media_entity_v4l2_subdev(remote->entity))
+		index |= 2 << 16;
+
+	switch (index) {
+	case ISIF_PAD_SINK | 2 << 16:
 		/* read from decoder/sensor */
 		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 			isif->input = ISIF_INPUT_NONE;
@@ -1720,7 +1725,7 @@ isif_link_setup(struct media_entity *entity, const struct media_pad *local,
 		isif->input = ISIF_INPUT_PARALLEL;
 		break;
 
-	case ISIF_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+	case ISIF_PAD_SOURCE:
 		/* write to memory */
 		if (flags & MEDIA_LNK_FL_ENABLED)
 			isif->output = ISIF_OUTPUT_MEMORY;
@@ -1728,7 +1733,7 @@ isif_link_setup(struct media_entity *entity, const struct media_pad *local,
 			isif->output = ISIF_OUTPUT_NONE;
 		break;
 
-	case ISIF_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+	case ISIF_PAD_SOURCE | 2 << 16:
 		if (flags & MEDIA_LNK_FL_ENABLED)
 			isif->output = ISIF_OUTPUT_IPIPEIF;
 		else
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index ae942de3a23d..5cfe26daa19c 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1655,8 +1655,14 @@ static int resizer_link_setup(struct media_entity *entity,
 	u16 ipipe_source = vpfe_dev->vpfe_ipipe.output;
 
 	if (&resizer->crop_resizer.subdev == sd) {
-		switch (local->index | media_entity_type(remote->entity)) {
-		case RESIZER_CROP_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		int index = local->index;
+
+		/* FIXME: this is actually a hack! */
+		if (is_media_entity_v4l2_subdev(remote->entity))
+			index |= 2 << 16;
+
+		switch (index) {
+		case RESIZER_CROP_PAD_SINK | 2 << 16:
 			if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 				resizer->crop_resizer.input =
 					RESIZER_CROP_INPUT_NONE;
@@ -1676,7 +1682,7 @@ static int resizer_link_setup(struct media_entity *entity,
 				return -EINVAL;
 			break;
 
-		case RESIZER_CROP_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+		case RESIZER_CROP_PAD_SOURCE | 2 << 16:
 			if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 				resizer->crop_resizer.output =
 				RESIZER_CROP_OUTPUT_NONE;
@@ -1688,7 +1694,7 @@ static int resizer_link_setup(struct media_entity *entity,
 			resizer->crop_resizer.output = RESIZER_A;
 			break;
 
-		case RESIZER_CROP_PAD_SOURCE2 | MEDIA_ENT_T_V4L2_SUBDEV:
+		case RESIZER_CROP_PAD_SOURCE2 | 2 << 16:
 			if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 				resizer->crop_resizer.output2 =
 					RESIZER_CROP_OUTPUT_NONE;
@@ -1705,7 +1711,7 @@ static int resizer_link_setup(struct media_entity *entity,
 		}
 	} else if (&resizer->resizer_a.subdev == sd) {
 		switch (local->index | media_entity_type(remote->entity)) {
-		case RESIZER_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		case RESIZER_PAD_SINK | 2 << 16:
 			if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 				resizer->resizer_a.input = RESIZER_INPUT_NONE;
 				break;
@@ -1715,7 +1721,7 @@ static int resizer_link_setup(struct media_entity *entity,
 			resizer->resizer_a.input = RESIZER_INPUT_CROP_RESIZER;
 			break;
 
-		case RESIZER_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+		case RESIZER_PAD_SOURCE:
 			if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 				resizer->resizer_a.output = RESIZER_OUTPUT_NONE;
 				break;
@@ -1730,7 +1736,7 @@ static int resizer_link_setup(struct media_entity *entity,
 		}
 	} else if (&resizer->resizer_b.subdev == sd) {
 		switch (local->index | media_entity_type(remote->entity)) {
-		case RESIZER_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		case RESIZER_PAD_SINK | 2 << 16:
 			if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 				resizer->resizer_b.input = RESIZER_INPUT_NONE;
 				break;
@@ -1740,7 +1746,7 @@ static int resizer_link_setup(struct media_entity *entity,
 			resizer->resizer_b.input = RESIZER_INPUT_CROP_RESIZER;
 			break;
 
-		case RESIZER_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+		case RESIZER_PAD_SOURCE:
 			if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 				resizer->resizer_b.output = RESIZER_OUTPUT_NONE;
 				break;
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 6b4dcbfa9425..50a24e8e8129 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1170,14 +1170,19 @@ static int csi2_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct iss_csi2_ctrl_cfg *ctrl = &csi2->ctrl;
+	int index = local->index;
+
+	/* FIXME: this is actually a hack! */
+	if (is_media_entity_v4l2_subdev(remote->entity))
+		index |= 2 << 16;
 
 	/*
 	 * The ISS core doesn't support pipelines with multiple video outputs.
 	 * Revisit this when it will be implemented, and return -EBUSY for now.
 	 */
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case CSI2_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+	switch (index) {
+	case CSI2_PAD_SOURCE:
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (csi2->output & ~CSI2_OUTPUT_MEMORY)
 				return -EBUSY;
@@ -1187,7 +1192,7 @@ static int csi2_link_setup(struct media_entity *entity,
 		}
 		break;
 
-	case CSI2_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+	case CSI2_PAD_SOURCE | 2 << 16:
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (csi2->output & ~CSI2_OUTPUT_IPIPEIF)
 				return -EBUSY;
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 44c432ef2ac5..e46b2c07bd5d 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -662,9 +662,14 @@ static int ipipeif_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = to_iss_device(ipipeif);
+	int index = local->index;
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case IPIPEIF_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	/* FIXME: this is actually a hack! */
+	if (is_media_entity_v4l2_subdev(remote->entity))
+		index |= 2 << 16;
+
+	switch (index) {
+	case IPIPEIF_PAD_SINK | 2 << 16:
 		/* Read from the sensor CSI2a or CSI2b. */
 		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 			ipipeif->input = IPIPEIF_INPUT_NONE;
@@ -681,7 +686,7 @@ static int ipipeif_link_setup(struct media_entity *entity,
 
 		break;
 
-	case IPIPEIF_PAD_SOURCE_ISIF_SF | MEDIA_ENT_T_DEVNODE:
+	case IPIPEIF_PAD_SOURCE_ISIF_SF:
 		/* Write to memory */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (ipipeif->output & ~IPIPEIF_OUTPUT_MEMORY)
@@ -692,7 +697,7 @@ static int ipipeif_link_setup(struct media_entity *entity,
 		}
 		break;
 
-	case IPIPEIF_PAD_SOURCE_VP | MEDIA_ENT_T_V4L2_SUBDEV:
+	case IPIPEIF_PAD_SOURCE_VP | 2 << 16:
 		/* Send to IPIPE/RESIZER */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (ipipeif->output & ~IPIPEIF_OUTPUT_VP)
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index b659e465cb56..bc5001002cc5 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -717,9 +717,14 @@ static int resizer_link_setup(struct media_entity *entity,
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct iss_resizer_device *resizer = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = to_iss_device(resizer);
+	int index = local->index;
 
-	switch (local->index | media_entity_type(remote->entity)) {
-	case RESIZER_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+	/* FIXME: this is actually a hack! */
+	if (is_media_entity_v4l2_subdev(remote->entity))
+		index |= 2 << 16;
+
+	switch (index) {
+	case RESIZER_PAD_SINK | 2 << 16:
 		/* Read from IPIPE or IPIPEIF. */
 		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 			resizer->input = RESIZER_INPUT_NONE;
@@ -737,7 +742,7 @@ static int resizer_link_setup(struct media_entity *entity,
 
 		break;
 
-	case RESIZER_PAD_SOURCE_MEM | MEDIA_ENT_T_DEVNODE:
+	case RESIZER_PAD_SOURCE_MEM :
 		/* Write to memory */
 		if (flags & MEDIA_LNK_FL_ENABLED) {
 			if (resizer->output & ~RESIZER_OUTPUT_MEMORY)
-- 
2.4.3

