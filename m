Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46540 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933980AbeFVPeI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:34:08 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 16/32] media: camss: Add 8x96 resources
Date: Fri, 22 Jun 2018 18:33:25 +0300
Message-Id: <1529681621-9682-17-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
References: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add structs with 8x96 resources. As the number of CSIPHY, CSID
and VFE hardware modules is different on 8x16 and 8x96 select
the number at runtime and allocate needed structures
dynamically.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c   |  20 +-
 drivers/media/platform/qcom/camss/camss-csid.h   |   3 +-
 drivers/media/platform/qcom/camss/camss-csiphy.c |  19 +-
 drivers/media/platform/qcom/camss/camss-csiphy.h |   4 +-
 drivers/media/platform/qcom/camss/camss-ispif.c  |  35 ++-
 drivers/media/platform/qcom/camss/camss-ispif.h  |   9 +-
 drivers/media/platform/qcom/camss/camss-vfe.c    |  61 ++--
 drivers/media/platform/qcom/camss/camss-vfe.h    |   4 +-
 drivers/media/platform/qcom/camss/camss.c        | 354 ++++++++++++++++++-----
 drivers/media/platform/qcom/camss/camss.h        |  20 +-
 10 files changed, 390 insertions(+), 139 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index 3cde07e..627ef44 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -219,7 +219,7 @@ static irqreturn_t csid_isr(int irq, void *dev)
  */
 static int csid_set_clock_rates(struct csid_device *csid)
 {
-	struct device *dev = to_device_index(csid, csid->id);
+	struct device *dev = csid->camss->dev;
 	u32 pixel_clock;
 	int i, j;
 	int ret;
@@ -232,7 +232,9 @@ static int csid_set_clock_rates(struct csid_device *csid)
 		struct camss_clock *clock = &csid->clock[i];
 
 		if (!strcmp(clock->name, "csi0") ||
-			!strcmp(clock->name, "csi1")) {
+		    !strcmp(clock->name, "csi1") ||
+		    !strcmp(clock->name, "csi2") ||
+		    !strcmp(clock->name, "csi3")) {
 			u8 bpp = csid_get_fmt_entry(
 				csid->fmt[MSM_CSIPHY_PAD_SINK].code)->bpp;
 			u8 num_lanes = csid->phy.lane_cnt;
@@ -291,8 +293,7 @@ static int csid_reset(struct csid_device *csid)
 	time = wait_for_completion_timeout(&csid->reset_complete,
 		msecs_to_jiffies(CSID_RESET_TIMEOUT_MS));
 	if (!time) {
-		dev_err(to_device_index(csid, csid->id),
-			"CSID reset timeout\n");
+		dev_err(csid->camss->dev, "CSID reset timeout\n");
 		return -EIO;
 	}
 
@@ -309,7 +310,7 @@ static int csid_reset(struct csid_device *csid)
 static int csid_set_power(struct v4l2_subdev *sd, int on)
 {
 	struct csid_device *csid = v4l2_get_subdevdata(sd);
-	struct device *dev = to_device_index(csid, csid->id);
+	struct device *dev = csid->camss->dev;
 	int ret;
 
 	if (on) {
@@ -375,7 +376,7 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 
 		ret = v4l2_ctrl_handler_setup(&csid->ctrls);
 		if (ret < 0) {
-			dev_err(to_device_index(csid, csid->id),
+			dev_err(csid->camss->dev,
 				"could not sync v4l2 controls: %d\n", ret);
 			return ret;
 		}
@@ -796,15 +797,16 @@ static const struct v4l2_ctrl_ops csid_ctrl_ops = {
  *
  * Return 0 on success or a negative error code otherwise
  */
-int msm_csid_subdev_init(struct csid_device *csid,
+int msm_csid_subdev_init(struct camss *camss, struct csid_device *csid,
 			 const struct resources *res, u8 id)
 {
-	struct device *dev = to_device_index(csid, id);
+	struct device *dev = camss->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct resource *r;
 	int i, j;
 	int ret;
 
+	csid->camss = camss;
 	csid->id = id;
 
 	/* Memory */
@@ -1018,7 +1020,7 @@ int msm_csid_register_entity(struct csid_device *csid,
 {
 	struct v4l2_subdev *sd = &csid->subdev;
 	struct media_pad *pads = csid->pads;
-	struct device *dev = to_device_index(csid, csid->id);
+	struct device *dev = csid->camss->dev;
 	int ret;
 
 	v4l2_subdev_init(sd, &csid_v4l2_ops);
diff --git a/drivers/media/platform/qcom/camss/camss-csid.h b/drivers/media/platform/qcom/camss/camss-csid.h
index ae1d045..ed605fd 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.h
+++ b/drivers/media/platform/qcom/camss/camss-csid.h
@@ -42,6 +42,7 @@ struct csid_phy_config {
 };
 
 struct csid_device {
+	struct camss *camss;
 	u8 id;
 	struct v4l2_subdev subdev;
 	struct media_pad pads[MSM_CSID_PADS_NUM];
@@ -61,7 +62,7 @@ struct csid_device {
 
 struct resources;
 
-int msm_csid_subdev_init(struct csid_device *csid,
+int msm_csid_subdev_init(struct camss *camss, struct csid_device *csid,
 			 const struct resources *res, u8 id);
 
 int msm_csid_register_entity(struct csid_device *csid,
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index 6158ffd..0383e94 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -155,7 +155,7 @@ static irqreturn_t csiphy_isr(int irq, void *dev)
  */
 static int csiphy_set_clock_rates(struct csiphy_device *csiphy)
 {
-	struct device *dev = to_device_index(csiphy, csiphy->id);
+	struct device *dev = csiphy->camss->dev;
 	u32 pixel_clock;
 	int i, j;
 	int ret;
@@ -168,7 +168,8 @@ static int csiphy_set_clock_rates(struct csiphy_device *csiphy)
 		struct camss_clock *clock = &csiphy->clock[i];
 
 		if (!strcmp(clock->name, "csiphy0_timer") ||
-			!strcmp(clock->name, "csiphy1_timer")) {
+		    !strcmp(clock->name, "csiphy1_timer") ||
+		    !strcmp(clock->name, "csiphy2_timer")) {
 			u8 bpp = csiphy_get_bpp(
 					csiphy->fmt[MSM_CSIPHY_PAD_SINK].code);
 			u8 num_lanes = csiphy->cfg.csi2->lane_cfg.num_data;
@@ -233,7 +234,7 @@ static void csiphy_reset(struct csiphy_device *csiphy)
 static int csiphy_set_power(struct v4l2_subdev *sd, int on)
 {
 	struct csiphy_device *csiphy = v4l2_get_subdevdata(sd);
-	struct device *dev = to_device_index(csiphy, csiphy->id);
+	struct device *dev = csiphy->camss->dev;
 
 	if (on) {
 		u8 hw_version;
@@ -311,12 +312,12 @@ static u8 csiphy_settle_cnt_calc(struct csiphy_device *csiphy)
 
 	ret = camss_get_pixel_clock(&csiphy->subdev.entity, &pixel_clock);
 	if (ret) {
-		dev_err(to_device_index(csiphy, csiphy->id),
+		dev_err(csiphy->camss->dev,
 			"Cannot get CSI2 transmitter's pixel clock\n");
 		return 0;
 	}
 	if (!pixel_clock) {
-		dev_err(to_device_index(csiphy, csiphy->id),
+		dev_err(csiphy->camss->dev,
 			"Got pixel clock == 0, cannot continue\n");
 		return 0;
 	}
@@ -670,15 +671,17 @@ static int csiphy_init_formats(struct v4l2_subdev *sd,
  *
  * Return 0 on success or a negative error code otherwise
  */
-int msm_csiphy_subdev_init(struct csiphy_device *csiphy,
+int msm_csiphy_subdev_init(struct camss *camss,
+			   struct csiphy_device *csiphy,
 			   const struct resources *res, u8 id)
 {
-	struct device *dev = to_device_index(csiphy, id);
+	struct device *dev = camss->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct resource *r;
 	int i, j;
 	int ret;
 
+	csiphy->camss = camss;
 	csiphy->id = id;
 	csiphy->cfg.combo_mode = 0;
 
@@ -839,7 +842,7 @@ int msm_csiphy_register_entity(struct csiphy_device *csiphy,
 {
 	struct v4l2_subdev *sd = &csiphy->subdev;
 	struct media_pad *pads = csiphy->pads;
-	struct device *dev = to_device_index(csiphy, csiphy->id);
+	struct device *dev = csiphy->camss->dev;
 	int ret;
 
 	v4l2_subdev_init(sd, &csiphy_v4l2_ops);
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.h b/drivers/media/platform/qcom/camss/camss-csiphy.h
index 76fa239..728dfef 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.h
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.h
@@ -42,6 +42,7 @@ struct csiphy_config {
 };
 
 struct csiphy_device {
+	struct camss *camss;
 	u8 id;
 	struct v4l2_subdev subdev;
 	struct media_pad pads[MSM_CSIPHY_PADS_NUM];
@@ -58,7 +59,8 @@ struct csiphy_device {
 
 struct resources;
 
-int msm_csiphy_subdev_init(struct csiphy_device *csiphy,
+int msm_csiphy_subdev_init(struct camss *camss,
+			   struct csiphy_device *csiphy,
 			   const struct resources *res, u8 id);
 
 int msm_csiphy_register_entity(struct csiphy_device *csiphy,
diff --git a/drivers/media/platform/qcom/camss/camss-ispif.c b/drivers/media/platform/qcom/camss/camss-ispif.c
index 5ad719d..ed50cc5 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss/camss-ispif.c
@@ -23,12 +23,6 @@
 
 #define MSM_ISPIF_NAME "msm_ispif"
 
-#define ispif_line_array(ptr_line)	\
-	((const struct ispif_line (*)[]) &(ptr_line[-(ptr_line->id)]))
-
-#define to_ispif(ptr_line)	\
-	container_of(ispif_line_array(ptr_line), struct ispif_device, ptr_line)
-
 #define ISPIF_RST_CMD_0			0x008
 #define ISPIF_RST_CMD_0_STROBED_RST_EN		(1 << 0)
 #define ISPIF_RST_CMD_0_MISC_LOGIC_RST		(1 << 1)
@@ -225,7 +219,7 @@ static int ispif_reset(struct ispif_device *ispif)
 static int ispif_set_power(struct v4l2_subdev *sd, int on)
 {
 	struct ispif_line *line = v4l2_get_subdevdata(sd);
-	struct ispif_device *ispif = to_ispif(line);
+	struct ispif_device *ispif = line->ispif;
 	struct device *dev = to_device(ispif);
 	int ret = 0;
 
@@ -611,7 +605,7 @@ static void ispif_set_intf_cmd(struct ispif_device *ispif, u8 cmd,
 static int ispif_set_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct ispif_line *line = v4l2_get_subdevdata(sd);
-	struct ispif_device *ispif = to_ispif(line);
+	struct ispif_device *ispif = line->ispif;
 	enum ispif_intf intf = line->interface;
 	u8 csid = line->csid_id;
 	u8 vfe = line->vfe_id;
@@ -899,6 +893,24 @@ int msm_ispif_subdev_init(struct ispif_device *ispif,
 	int i;
 	int ret;
 
+	/* Number of ISPIF lines - same as number of CSID hardware modules */
+	if (to_camss(ispif)->version == CAMSS_8x16)
+		ispif->line_num = 2;
+	else if (to_camss(ispif)->version == CAMSS_8x96)
+		ispif->line_num = 4;
+	else
+		return -EINVAL;
+
+	ispif->line = kcalloc(ispif->line_num, sizeof(*ispif->line),
+			      GFP_KERNEL);
+	if (!ispif->line)
+		return -ENOMEM;
+
+	for (i = 0; i < ispif->line_num; i++) {
+		ispif->line[i].ispif = ispif;
+		ispif->line[i].id = i;
+	}
+
 	/* Memory */
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, res->reg[0]);
@@ -979,9 +991,6 @@ int msm_ispif_subdev_init(struct ispif_device *ispif,
 		clock->nfreqs = 0;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(ispif->line); i++)
-		ispif->line[i].id = i;
-
 	mutex_init(&ispif->power_lock);
 	ispif->power_count = 0;
 
@@ -1100,7 +1109,7 @@ int msm_ispif_register_entities(struct ispif_device *ispif,
 	int ret;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(ispif->line); i++) {
+	for (i = 0; i < ispif->line_num; i++) {
 		struct v4l2_subdev *sd = &ispif->line[i].subdev;
 		struct media_pad *pads = ispif->line[i].pads;
 
@@ -1161,7 +1170,7 @@ void msm_ispif_unregister_entities(struct ispif_device *ispif)
 	mutex_destroy(&ispif->power_lock);
 	mutex_destroy(&ispif->config_lock);
 
-	for (i = 0; i < ARRAY_SIZE(ispif->line); i++) {
+	for (i = 0; i < ispif->line_num; i++) {
 		struct v4l2_subdev *sd = &ispif->line[i].subdev;
 
 		v4l2_device_unregister_subdev(sd);
diff --git a/drivers/media/platform/qcom/camss/camss-ispif.h b/drivers/media/platform/qcom/camss/camss-ispif.h
index a5dfb4f..5800510 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.h
+++ b/drivers/media/platform/qcom/camss/camss-ispif.h
@@ -15,14 +15,11 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
-/* Number of ISPIF lines - same as number of CSID hardware modules */
-#define MSM_ISPIF_LINE_NUM 2
-
 #define MSM_ISPIF_PAD_SINK 0
 #define MSM_ISPIF_PAD_SRC 1
 #define MSM_ISPIF_PADS_NUM 2
 
-#define MSM_ISPIF_VFE_NUM 1
+#define MSM_ISPIF_VFE_NUM 2
 
 enum ispif_intf {
 	PIX0,
@@ -38,6 +35,7 @@ struct ispif_intf_cmd_reg {
 };
 
 struct ispif_line {
+	struct ispif_device *ispif;
 	u8 id;
 	u8 csid_id;
 	u8 vfe_id;
@@ -61,7 +59,8 @@ struct ispif_device {
 	struct mutex power_lock;
 	struct ispif_intf_cmd_reg intf_cmd[MSM_ISPIF_VFE_NUM];
 	struct mutex config_lock;
-	struct ispif_line line[MSM_ISPIF_LINE_NUM];
+	int line_num;
+	struct ispif_line *line;
 };
 
 struct resources_ispif;
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 15a1a01..3f589c4 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -877,7 +877,7 @@ static int vfe_reset(struct vfe_device *vfe)
 	time = wait_for_completion_timeout(&vfe->reset_complete,
 		msecs_to_jiffies(VFE_RESET_TIMEOUT_MS));
 	if (!time) {
-		dev_err(to_device(vfe), "VFE reset timeout\n");
+		dev_err(vfe->camss->dev, "VFE reset timeout\n");
 		return -EIO;
 	}
 
@@ -902,7 +902,7 @@ static int vfe_halt(struct vfe_device *vfe)
 	time = wait_for_completion_timeout(&vfe->halt_complete,
 		msecs_to_jiffies(VFE_HALT_TIMEOUT_MS));
 	if (!time) {
-		dev_err(to_device(vfe), "VFE halt timeout\n");
+		dev_err(vfe->camss->dev, "VFE halt timeout\n");
 		return -EIO;
 	}
 
@@ -1041,7 +1041,7 @@ static int vfe_camif_wait_for_stop(struct vfe_device *vfe)
 				 CAMIF_TIMEOUT_SLEEP_US,
 				 CAMIF_TIMEOUT_ALL_US);
 	if (ret < 0)
-		dev_err(to_device(vfe), "%s: camif stop timeout\n", __func__);
+		dev_err(vfe->camss->dev, "%s: camif stop timeout\n", __func__);
 
 	return ret;
 }
@@ -1209,7 +1209,7 @@ static void vfe_buf_update_wm_on_next(struct vfe_device *vfe,
 		break;
 	case VFE_OUTPUT_SINGLE:
 	default:
-		dev_err_ratelimited(to_device(vfe),
+		dev_err_ratelimited(vfe->camss->dev,
 				    "Next buf in wrong state! %d\n",
 				    output->state);
 		break;
@@ -1229,7 +1229,7 @@ static void vfe_buf_update_wm_on_last(struct vfe_device *vfe,
 		vfe_output_frame_drop(vfe, output, 0);
 		break;
 	default:
-		dev_err_ratelimited(to_device(vfe),
+		dev_err_ratelimited(vfe->camss->dev,
 				    "Last buff in wrong state! %d\n",
 				    output->state);
 		break;
@@ -1258,7 +1258,7 @@ static void vfe_buf_update_wm_on_new(struct vfe_device *vfe,
 			output->state = VFE_OUTPUT_CONTINUOUS;
 		} else {
 			vfe_buf_add_pending(output, new_buf);
-			dev_err_ratelimited(to_device(vfe),
+			dev_err_ratelimited(vfe->camss->dev,
 					    "Inactive buffer is busy\n");
 		}
 		break;
@@ -1273,7 +1273,7 @@ static void vfe_buf_update_wm_on_new(struct vfe_device *vfe,
 			output->state = VFE_OUTPUT_SINGLE;
 		} else {
 			vfe_buf_add_pending(output, new_buf);
-			dev_err_ratelimited(to_device(vfe),
+			dev_err_ratelimited(vfe->camss->dev,
 					    "Output idle with buffer set!\n");
 		}
 		break;
@@ -1297,7 +1297,7 @@ static int vfe_get_output(struct vfe_line *line)
 
 	output = &line->output;
 	if (output->state != VFE_OUTPUT_OFF) {
-		dev_err(to_device(vfe), "Output is running\n");
+		dev_err(vfe->camss->dev, "Output is running\n");
 		goto error;
 	}
 	output->state = VFE_OUTPUT_RESERVED;
@@ -1307,7 +1307,7 @@ static int vfe_get_output(struct vfe_line *line)
 	for (i = 0; i < output->wm_num; i++) {
 		wm_idx = vfe_reserve_wm(vfe, line->id);
 		if (wm_idx < 0) {
-			dev_err(to_device(vfe), "Can not reserve wm\n");
+			dev_err(vfe->camss->dev, "Can not reserve wm\n");
 			goto error_get_wm;
 		}
 		output->wm_idx[i] = wm_idx;
@@ -1371,7 +1371,7 @@ static int vfe_enable_output(struct vfe_line *line)
 	vfe->reg_update &= ~VFE_0_REG_UPDATE_line_n(line->id);
 
 	if (output->state != VFE_OUTPUT_RESERVED) {
-		dev_err(to_device(vfe), "Output is not in reserved state %d\n",
+		dev_err(vfe->camss->dev, "Output is not in reserved state %d\n",
 			output->state);
 		spin_unlock_irqrestore(&vfe->output_lock, flags);
 		return -EINVAL;
@@ -1471,7 +1471,7 @@ static int vfe_disable_output(struct vfe_line *line)
 	time = wait_for_completion_timeout(&output->sof,
 					   msecs_to_jiffies(VFE_NEXT_SOF_MS));
 	if (!time)
-		dev_err(to_device(vfe), "VFE sof timeout\n");
+		dev_err(vfe->camss->dev, "VFE sof timeout\n");
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 	for (i = 0; i < output->wm_num; i++)
@@ -1484,7 +1484,7 @@ static int vfe_disable_output(struct vfe_line *line)
 	time = wait_for_completion_timeout(&output->reg_update,
 					   msecs_to_jiffies(VFE_NEXT_SOF_MS));
 	if (!time)
-		dev_err(to_device(vfe), "VFE reg update timeout\n");
+		dev_err(vfe->camss->dev, "VFE reg update timeout\n");
 
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
@@ -1698,14 +1698,14 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
 	if (vfe->wm_output_map[wm] == VFE_LINE_NONE) {
-		dev_err_ratelimited(to_device(vfe),
+		dev_err_ratelimited(vfe->camss->dev,
 				    "Received wm done for unmapped index\n");
 		goto out_unlock;
 	}
 	output = &vfe->line[vfe->wm_output_map[wm]].output;
 
 	if (output->active_buf == active_index) {
-		dev_err_ratelimited(to_device(vfe),
+		dev_err_ratelimited(vfe->camss->dev,
 				    "Active buffer mismatch!\n");
 		goto out_unlock;
 	}
@@ -1713,7 +1713,7 @@ static void vfe_isr_wm_done(struct vfe_device *vfe, u8 wm)
 
 	ready_buf = output->buf[!active_index];
 	if (!ready_buf) {
-		dev_err_ratelimited(to_device(vfe),
+		dev_err_ratelimited(vfe->camss->dev,
 				    "Missing ready buf %d %d!\n",
 				    !active_index, output->state);
 		goto out_unlock;
@@ -1799,7 +1799,7 @@ static irqreturn_t vfe_isr(int irq, void *dev)
 
 	if (value1 & VFE_0_IRQ_STATUS_1_VIOLATION) {
 		violation = readl_relaxed(vfe->base + VFE_0_VIOLATION_STATUS);
-		dev_err_ratelimited(to_device(vfe),
+		dev_err_ratelimited(vfe->camss->dev,
 				    "VFE: violation = 0x%08x\n", violation);
 	}
 
@@ -1842,7 +1842,7 @@ static irqreturn_t vfe_isr(int irq, void *dev)
  */
 static int vfe_set_clock_rates(struct vfe_device *vfe)
 {
-	struct device *dev = to_device(vfe);
+	struct device *dev = vfe->camss->dev;
 	u32 pixel_clock[MSM_VFE_LINE_NUM];
 	int i, j;
 	int ret;
@@ -1857,7 +1857,8 @@ static int vfe_set_clock_rates(struct vfe_device *vfe)
 	for (i = 0; i < vfe->nclocks; i++) {
 		struct camss_clock *clock = &vfe->clock[i];
 
-		if (!strcmp(clock->name, "camss_vfe_vfe")) {
+		if (!strcmp(clock->name, "vfe0") ||
+		    !strcmp(clock->name, "vfe1")) {
 			u64 min_rate = 0;
 			long rate;
 
@@ -1935,7 +1936,8 @@ static int vfe_check_clock_rates(struct vfe_device *vfe)
 	for (i = 0; i < vfe->nclocks; i++) {
 		struct camss_clock *clock = &vfe->clock[i];
 
-		if (!strcmp(clock->name, "camss_vfe_vfe")) {
+		if (!strcmp(clock->name, "vfe0") ||
+		    !strcmp(clock->name, "vfe1")) {
 			u64 min_rate = 0;
 			unsigned long rate;
 
@@ -1984,7 +1986,7 @@ static int vfe_get(struct vfe_device *vfe)
 			goto error_clocks;
 
 		ret = camss_enable_clocks(vfe->nclocks, vfe->clock,
-					  to_device(vfe));
+					  vfe->camss->dev);
 		if (ret < 0)
 			goto error_clocks;
 
@@ -2024,7 +2026,7 @@ static void vfe_put(struct vfe_device *vfe)
 	mutex_lock(&vfe->power_lock);
 
 	if (vfe->power_count == 0) {
-		dev_err(to_device(vfe), "vfe power off on power_count == 0\n");
+		dev_err(vfe->camss->dev, "vfe power off on power_count == 0\n");
 		goto exit;
 	} else if (vfe->power_count == 1) {
 		if (vfe->was_streaming) {
@@ -2130,7 +2132,7 @@ static int vfe_set_power(struct v4l2_subdev *sd, int on)
 			return ret;
 
 		hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
-		dev_dbg(to_device(vfe),
+		dev_dbg(vfe->camss->dev,
 			"VFE HW Version = 0x%08x\n", hw_version);
 	} else {
 		vfe_put(vfe);
@@ -2157,12 +2159,12 @@ static int vfe_set_stream(struct v4l2_subdev *sd, int enable)
 	if (enable) {
 		ret = vfe_enable(line);
 		if (ret < 0)
-			dev_err(to_device(vfe),
+			dev_err(vfe->camss->dev,
 				"Failed to enable vfe outputs\n");
 	} else {
 		ret = vfe_disable(line);
 		if (ret < 0)
-			dev_err(to_device(vfe),
+			dev_err(vfe->camss->dev,
 				"Failed to disable vfe outputs\n");
 	}
 
@@ -2716,12 +2718,12 @@ static int vfe_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
  *
  * Return 0 on success or a negative error code otherwise
  */
-int msm_vfe_subdev_init(struct vfe_device *vfe, const struct resources *res)
+int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
+			const struct resources *res, u8 id)
 {
-	struct device *dev = to_device(vfe);
+	struct device *dev = camss->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct resource *r;
-	struct camss *camss = to_camss(vfe);
 	int i, j;
 	int ret;
 
@@ -2801,7 +2803,8 @@ int msm_vfe_subdev_init(struct vfe_device *vfe, const struct resources *res)
 
 	spin_lock_init(&vfe->output_lock);
 
-	vfe->id = 0;
+	vfe->camss = camss;
+	vfe->id = id;
 	vfe->reg_update = 0;
 
 	for (i = VFE_LINE_RDI0; i <= VFE_LINE_PIX; i++) {
@@ -2933,7 +2936,7 @@ void msm_vfe_stop_streaming(struct vfe_device *vfe)
 int msm_vfe_register_entities(struct vfe_device *vfe,
 			      struct v4l2_device *v4l2_dev)
 {
-	struct device *dev = to_device(vfe);
+	struct device *dev = vfe->camss->dev;
 	struct v4l2_subdev *sd;
 	struct media_pad *pads;
 	struct camss_video *video_out;
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
index 6b4258d..17d431e 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss/camss-vfe.h
@@ -79,6 +79,7 @@ struct vfe_line {
 };
 
 struct vfe_device {
+	struct camss *camss;
 	u8 id;
 	void __iomem *base;
 	u32 irq;
@@ -100,7 +101,8 @@ struct vfe_device {
 
 struct resources;
 
-int msm_vfe_subdev_init(struct vfe_device *vfe, const struct resources *res);
+int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
+			const struct resources *res, u8 id);
 
 int msm_vfe_register_entities(struct vfe_device *vfe,
 			      struct v4l2_device *v4l2_dev);
diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 0b663e0..171e2c9 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -28,7 +28,7 @@
 #define CAMSS_CLOCK_MARGIN_NUMERATOR 105
 #define CAMSS_CLOCK_MARGIN_DENOMINATOR 100
 
-static const struct resources csiphy_res[] = {
+static const struct resources csiphy_res_8x16[] = {
 	/* CSIPHY0 */
 	{
 		.regulator = { NULL },
@@ -54,7 +54,7 @@ static const struct resources csiphy_res[] = {
 	}
 };
 
-static const struct resources csid_res[] = {
+static const struct resources csid_res_8x16[] = {
 	/* CSID0 */
 	{
 		.regulator = { "vdda" },
@@ -90,7 +90,7 @@ static const struct resources csid_res[] = {
 	},
 };
 
-static const struct resources_ispif ispif_res = {
+static const struct resources_ispif ispif_res_8x16 = {
 	/* ISPIF */
 	.clock = { "top_ahb", "ahb", "ispif_ahb",
 		   "csi0", "csi0_pix", "csi0_rdi",
@@ -101,24 +101,184 @@ static const struct resources_ispif ispif_res = {
 
 };
 
-static const struct resources vfe_res = {
+static const struct resources vfe_res_8x16[] = {
 	/* VFE0 */
-	.regulator = { NULL },
-	.clock = { "top_ahb", "vfe0", "csi_vfe0",
-		   "vfe_ahb", "vfe_axi", "ahb" },
-	.clock_rate = { { 0 },
-			{ 50000000, 80000000, 100000000, 160000000,
-			  177780000, 200000000, 266670000, 320000000,
-			  400000000, 465000000 },
-			{ 0 },
-			{ 0 },
-			{ 0 },
-			{ 0 },
-			{ 0 },
-			{ 0 },
-			{ 0 } },
-	.reg = { "vfe0" },
-	.interrupt = { "vfe0" }
+	{
+		.regulator = { NULL },
+		.clock = { "top_ahb", "vfe0", "csi_vfe0",
+			   "vfe_ahb", "vfe_axi", "ahb" },
+		.clock_rate = { { 0 },
+				{ 50000000, 80000000, 100000000, 160000000,
+				  177780000, 200000000, 266670000, 320000000,
+				  400000000, 465000000 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 } },
+		.reg = { "vfe0" },
+		.interrupt = { "vfe0" }
+	}
+};
+
+static const struct resources csiphy_res_8x96[] = {
+	/* CSIPHY0 */
+	{
+		.regulator = { NULL },
+		.clock = { "top_ahb", "ispif_ahb", "ahb", "csiphy0_timer" },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000, 266666667 } },
+		.reg = { "csiphy0", "csiphy0_clk_mux" },
+		.interrupt = { "csiphy0" }
+	},
+
+	/* CSIPHY1 */
+	{
+		.regulator = { NULL },
+		.clock = { "top_ahb", "ispif_ahb", "ahb", "csiphy1_timer" },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000, 266666667 } },
+		.reg = { "csiphy1", "csiphy1_clk_mux" },
+		.interrupt = { "csiphy1" }
+	},
+
+	/* CSIPHY2 */
+	{
+		.regulator = { NULL },
+		.clock = { "top_ahb", "ispif_ahb", "ahb", "csiphy2_timer" },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000, 266666667 } },
+		.reg = { "csiphy2", "csiphy2_clk_mux" },
+		.interrupt = { "csiphy2" }
+	}
+};
+
+static const struct resources csid_res_8x96[] = {
+	/* CSID0 */
+	{
+		.regulator = { "vdda" },
+		.clock = { "top_ahb", "ispif_ahb", "csi0_ahb", "ahb",
+			   "csi0", "csi0_phy", "csi0_pix", "csi0_rdi" },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000, 266666667 },
+				{ 0 },
+				{ 0 },
+				{ 0 } },
+		.reg = { "csid0" },
+		.interrupt = { "csid0" }
+	},
+
+	/* CSID1 */
+	{
+		.regulator = { "vdda" },
+		.clock = { "top_ahb", "ispif_ahb", "csi1_ahb", "ahb",
+			   "csi1", "csi1_phy", "csi1_pix", "csi1_rdi" },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000, 266666667 },
+				{ 0 },
+				{ 0 },
+				{ 0 } },
+		.reg = { "csid1" },
+		.interrupt = { "csid1" }
+	},
+
+	/* CSID2 */
+	{
+		.regulator = { "vdda" },
+		.clock = { "top_ahb", "ispif_ahb", "csi2_ahb", "ahb",
+			   "csi2", "csi2_phy", "csi2_pix", "csi2_rdi" },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000, 266666667 },
+				{ 0 },
+				{ 0 },
+				{ 0 } },
+		.reg = { "csid2" },
+		.interrupt = { "csid2" }
+	},
+
+	/* CSID3 */
+	{
+		.regulator = { "vdda" },
+		.clock = { "top_ahb", "ispif_ahb", "csi3_ahb", "ahb",
+			   "csi3", "csi3_phy", "csi3_pix", "csi3_rdi" },
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 100000000, 200000000, 266666667 },
+				{ 0 },
+				{ 0 },
+				{ 0 } },
+		.reg = { "csid3" },
+		.interrupt = { "csid3" }
+	}
+};
+
+static const struct resources_ispif ispif_res_8x96 = {
+	/* ISPIF */
+	.clock = { "top_ahb", "ahb", "ispif_ahb",
+		   "csi0", "csi0_pix", "csi0_rdi",
+		   "csi1", "csi1_pix", "csi1_rdi",
+		   "csi2", "csi2_pix", "csi2_rdi",
+		   "csi3", "csi3_pix", "csi3_rdi" },
+	.clock_for_reset = { "vfe0", "csi_vfe0", "vfe1", "csi_vfe1" },
+	.reg = { "ispif", "csi_clk_mux" },
+	.interrupt = "ispif"
+};
+
+static const struct resources vfe_res_8x96[] = {
+	/* VFE0 */
+	{
+		.regulator = { NULL },
+		.clock = { "top_ahb", "ahb", "vfe0", "csi_vfe0", "vfe_ahb",
+			   "vfe0_ahb", "vfe_axi", "vfe0_stream"},
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 75000000, 100000000, 300000000,
+				  320000000, 480000000, 600000000 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 } },
+		.reg = { "vfe0" },
+		.interrupt = { "vfe0" }
+	},
+
+	/* VFE1 */
+	{
+		.regulator = { NULL },
+		.clock = { "top_ahb", "ahb", "vfe1", "csi_vfe1", "vfe_ahb",
+			   "vfe1_ahb", "vfe_axi", "vfe1_stream"},
+		.clock_rate = { { 0 },
+				{ 0 },
+				{ 75000000, 100000000, 300000000,
+				  320000000, 480000000, 600000000 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 },
+				{ 0 } },
+		.reg = { "vfe1" },
+		.interrupt = { "vfe1" }
+	}
 };
 
 /*
@@ -345,11 +505,29 @@ static int camss_of_parse_ports(struct device *dev,
  */
 static int camss_init_subdevices(struct camss *camss)
 {
+	const struct resources *csiphy_res;
+	const struct resources *csid_res;
+	const struct resources_ispif *ispif_res;
+	const struct resources *vfe_res;
 	unsigned int i;
 	int ret;
 
-	for (i = 0; i < ARRAY_SIZE(camss->csiphy); i++) {
-		ret = msm_csiphy_subdev_init(&camss->csiphy[i],
+	if (camss->version == CAMSS_8x16) {
+		csiphy_res = csiphy_res_8x16;
+		csid_res = csid_res_8x16;
+		ispif_res = &ispif_res_8x16;
+		vfe_res = vfe_res_8x16;
+	} else if (camss->version == CAMSS_8x96) {
+		csiphy_res = csiphy_res_8x96;
+		csid_res = csid_res_8x96;
+		ispif_res = &ispif_res_8x96;
+		vfe_res = vfe_res_8x96;
+	} else {
+		return -EINVAL;
+	}
+
+	for (i = 0; i < camss->csiphy_num; i++) {
+		ret = msm_csiphy_subdev_init(camss, &camss->csiphy[i],
 					     &csiphy_res[i], i);
 		if (ret < 0) {
 			dev_err(camss->dev,
@@ -359,8 +537,8 @@ static int camss_init_subdevices(struct camss *camss)
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(camss->csid); i++) {
-		ret = msm_csid_subdev_init(&camss->csid[i],
+	for (i = 0; i < camss->csid_num; i++) {
+		ret = msm_csid_subdev_init(camss, &camss->csid[i],
 					   &csid_res[i], i);
 		if (ret < 0) {
 			dev_err(camss->dev,
@@ -370,17 +548,21 @@ static int camss_init_subdevices(struct camss *camss)
 		}
 	}
 
-	ret = msm_ispif_subdev_init(&camss->ispif, &ispif_res);
+	ret = msm_ispif_subdev_init(&camss->ispif, ispif_res);
 	if (ret < 0) {
 		dev_err(camss->dev, "Failed to init ispif sub-device: %d\n",
 			ret);
 		return ret;
 	}
 
-	ret = msm_vfe_subdev_init(&camss->vfe, &vfe_res);
-	if (ret < 0) {
-		dev_err(camss->dev, "Fail to init vfe sub-device: %d\n", ret);
-		return ret;
+	for (i = 0; i < camss->vfe_num; i++) {
+		ret = msm_vfe_subdev_init(camss, &camss->vfe[i],
+					  &vfe_res[i], i);
+		if (ret < 0) {
+			dev_err(camss->dev,
+				"Fail to init vfe%d sub-device: %d\n", i, ret);
+			return ret;
+		}
 	}
 
 	return 0;
@@ -394,10 +576,10 @@ static int camss_init_subdevices(struct camss *camss)
  */
 static int camss_register_entities(struct camss *camss)
 {
-	int i, j;
+	int i, j, k;
 	int ret;
 
-	for (i = 0; i < ARRAY_SIZE(camss->csiphy); i++) {
+	for (i = 0; i < camss->csiphy_num; i++) {
 		ret = msm_csiphy_register_entity(&camss->csiphy[i],
 						 &camss->v4l2_dev);
 		if (ret < 0) {
@@ -408,7 +590,7 @@ static int camss_register_entities(struct camss *camss)
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(camss->csid); i++) {
+	for (i = 0; i < camss->csid_num; i++) {
 		ret = msm_csid_register_entity(&camss->csid[i],
 					       &camss->v4l2_dev);
 		if (ret < 0) {
@@ -426,15 +608,19 @@ static int camss_register_entities(struct camss *camss)
 		goto err_reg_ispif;
 	}
 
-	ret = msm_vfe_register_entities(&camss->vfe, &camss->v4l2_dev);
-	if (ret < 0) {
-		dev_err(camss->dev, "Failed to register vfe entities: %d\n",
-			ret);
-		goto err_reg_vfe;
+	for (i = 0; i < camss->vfe_num; i++) {
+		ret = msm_vfe_register_entities(&camss->vfe[i],
+						&camss->v4l2_dev);
+		if (ret < 0) {
+			dev_err(camss->dev,
+				"Failed to register vfe%d entities: %d\n",
+				i, ret);
+			goto err_reg_vfe;
+		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(camss->csiphy); i++) {
-		for (j = 0; j < ARRAY_SIZE(camss->csid); j++) {
+	for (i = 0; i < camss->csiphy_num; i++) {
+		for (j = 0; j < camss->csid_num; j++) {
 			ret = media_create_pad_link(
 				&camss->csiphy[i].subdev.entity,
 				MSM_CSIPHY_PAD_SRC,
@@ -452,8 +638,8 @@ static int camss_register_entities(struct camss *camss)
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(camss->csid); i++) {
-		for (j = 0; j < ARRAY_SIZE(camss->ispif.line); j++) {
+	for (i = 0; i < camss->csid_num; i++) {
+		for (j = 0; j < camss->ispif.line_num; j++) {
 			ret = media_create_pad_link(
 				&camss->csid[i].subdev.entity,
 				MSM_CSID_PAD_SRC,
@@ -471,39 +657,42 @@ static int camss_register_entities(struct camss *camss)
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(camss->ispif.line); i++) {
-		for (j = 0; j < ARRAY_SIZE(camss->vfe.line); j++) {
-			ret = media_create_pad_link(
-				&camss->ispif.line[i].subdev.entity,
-				MSM_ISPIF_PAD_SRC,
-				&camss->vfe.line[j].subdev.entity,
-				MSM_VFE_PAD_SINK,
-				0);
-			if (ret < 0) {
-				dev_err(camss->dev,
-					"Failed to link %s->%s entities: %d\n",
-					camss->ispif.line[i].subdev.entity.name,
-					camss->vfe.line[j].subdev.entity.name,
-					ret);
-				goto err_link;
+	for (i = 0; i < camss->ispif.line_num; i++)
+		for (k = 0; k < camss->vfe_num; k++)
+			for (j = 0; j < ARRAY_SIZE(camss->vfe[k].line); j++) {
+				ret = media_create_pad_link(
+					&camss->ispif.line[i].subdev.entity,
+					MSM_ISPIF_PAD_SRC,
+					&camss->vfe[k].line[j].subdev.entity,
+					MSM_VFE_PAD_SINK,
+					0);
+				if (ret < 0) {
+					dev_err(camss->dev,
+						"Failed to link %s->%s entities: %d\n",
+						camss->ispif.line[i].subdev.entity.name,
+						camss->vfe[k].line[j].subdev.entity.name,
+						ret);
+					goto err_link;
+				}
 			}
-		}
-	}
 
 	return 0;
 
 err_link:
-	msm_vfe_unregister_entities(&camss->vfe);
+	i = camss->vfe_num;
 err_reg_vfe:
+	for (i--; i >= 0; i--)
+		msm_vfe_unregister_entities(&camss->vfe[i]);
+
 	msm_ispif_unregister_entities(&camss->ispif);
 err_reg_ispif:
 
-	i = ARRAY_SIZE(camss->csid);
+	i = camss->csid_num;
 err_reg_csid:
 	for (i--; i >= 0; i--)
 		msm_csid_unregister_entity(&camss->csid[i]);
 
-	i = ARRAY_SIZE(camss->csiphy);
+	i = camss->csiphy_num;
 err_reg_csiphy:
 	for (i--; i >= 0; i--)
 		msm_csiphy_unregister_entity(&camss->csiphy[i]);
@@ -521,14 +710,16 @@ static void camss_unregister_entities(struct camss *camss)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(camss->csiphy); i++)
+	for (i = 0; i < camss->csiphy_num; i++)
 		msm_csiphy_unregister_entity(&camss->csiphy[i]);
 
-	for (i = 0; i < ARRAY_SIZE(camss->csid); i++)
+	for (i = 0; i < camss->csid_num; i++)
 		msm_csid_unregister_entity(&camss->csid[i]);
 
 	msm_ispif_unregister_entities(&camss->ispif);
-	msm_vfe_unregister_entities(&camss->vfe);
+
+	for (i = 0; i < camss->vfe_num; i++)
+		msm_vfe_unregister_entities(&camss->vfe[i]);
 }
 
 static int camss_subdev_notifier_bound(struct v4l2_async_notifier *async,
@@ -620,6 +811,35 @@ static int camss_probe(struct platform_device *pdev)
 	camss->dev = dev;
 	platform_set_drvdata(pdev, camss);
 
+	if (of_device_is_compatible(dev->of_node, "qcom,msm8916-camss")) {
+		camss->version = CAMSS_8x16;
+		camss->csiphy_num = 2;
+		camss->csid_num = 2;
+		camss->vfe_num = 1;
+	} else if (of_device_is_compatible(dev->of_node,
+					   "qcom,msm8996-camss")) {
+		camss->version = CAMSS_8x96;
+		camss->csiphy_num = 3;
+		camss->csid_num = 4;
+		camss->vfe_num = 2;
+	} else {
+		return -EINVAL;
+	}
+
+	camss->csiphy = kcalloc(camss->csiphy_num, sizeof(*camss->csiphy),
+				GFP_KERNEL);
+	if (!camss->csiphy)
+		return -ENOMEM;
+
+	camss->csid = kcalloc(camss->csid_num, sizeof(*camss->csid),
+			      GFP_KERNEL);
+	if (!camss->csid)
+		return -ENOMEM;
+
+	camss->vfe = kcalloc(camss->vfe_num, sizeof(*camss->vfe), GFP_KERNEL);
+	if (!camss->vfe)
+		return -ENOMEM;
+
 	ret = camss_of_parse_ports(dev, &camss->notifier);
 	if (ret < 0)
 		return ret;
@@ -703,9 +923,12 @@ void camss_delete(struct camss *camss)
  */
 static int camss_remove(struct platform_device *pdev)
 {
+	unsigned int i;
+
 	struct camss *camss = platform_get_drvdata(pdev);
 
-	msm_vfe_stop_streaming(&camss->vfe);
+	for (i = 0; i < camss->vfe_num; i++)
+		msm_vfe_stop_streaming(&camss->vfe[i]);
 
 	v4l2_async_notifier_unregister(&camss->notifier);
 	camss_unregister_entities(camss);
@@ -718,6 +941,7 @@ static int camss_remove(struct platform_device *pdev)
 
 static const struct of_device_id camss_dt_match[] = {
 	{ .compatible = "qcom,msm8916-camss" },
+	{ .compatible = "qcom,msm8996-camss" },
 	{ }
 };
 
diff --git a/drivers/media/platform/qcom/camss/camss.h b/drivers/media/platform/qcom/camss/camss.h
index fb1c2f9..dff1045 100644
--- a/drivers/media/platform/qcom/camss/camss.h
+++ b/drivers/media/platform/qcom/camss/camss.h
@@ -23,9 +23,6 @@
 #include "camss-ispif.h"
 #include "camss-vfe.h"
 
-#define CAMSS_CSID_NUM 2
-#define CAMSS_CSIPHY_NUM 2
-
 #define to_camss(ptr_module)	\
 	container_of(ptr_module, struct camss, ptr_module)
 
@@ -42,7 +39,7 @@
 #define to_device_index(ptr_module, index)	\
 	(to_camss_index(ptr_module, index)->dev)
 
-#define CAMSS_RES_MAX 15
+#define CAMSS_RES_MAX 17
 
 struct resources {
 	char *regulator[CAMSS_RES_MAX];
@@ -59,15 +56,24 @@ struct resources_ispif {
 	char *interrupt;
 };
 
+enum camss_version {
+	CAMSS_8x16,
+	CAMSS_8x96,
+};
+
 struct camss {
+	enum camss_version version;
 	struct v4l2_device v4l2_dev;
 	struct v4l2_async_notifier notifier;
 	struct media_device media_dev;
 	struct device *dev;
-	struct csiphy_device csiphy[CAMSS_CSIPHY_NUM];
-	struct csid_device csid[CAMSS_CSID_NUM];
+	int csiphy_num;
+	struct csiphy_device *csiphy;
+	int csid_num;
+	struct csid_device *csid;
 	struct ispif_device ispif;
-	struct vfe_device vfe;
+	int vfe_num;
+	struct vfe_device *vfe;
 	atomic_t ref_count;
 };
 
-- 
2.7.4
