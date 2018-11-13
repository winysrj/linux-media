Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:33660 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728943AbeKNAJ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 19:09:58 -0500
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH] media: camss: Take in account sensor skip frames
Date: Tue, 13 Nov 2018 16:03:07 +0200
Message-Id: <1542117787-24155-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When streaming is starting ask the sensor for its skip frames value.
Max supported frame skip is 29 frames, so clip it if it is higher.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 23 ++++++++++++++++++-----
 drivers/media/platform/qcom/camss/camss.c     |  2 +-
 drivers/media/platform/qcom/camss/camss.h     |  1 +
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index ed6a557..a8c542fa 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -37,9 +37,9 @@
 /* VFE halt timeout */
 #define VFE_HALT_TIMEOUT_MS 100
 /* Max number of frame drop updates per frame */
-#define VFE_FRAME_DROP_UPDATES 5
-/* Frame drop value. NOTE: VAL + UPDATES should not exceed 31 */
-#define VFE_FRAME_DROP_VAL 20
+#define VFE_FRAME_DROP_UPDATES 2
+/* Frame drop value. VAL + UPDATES - 1 should not exceed 31 */
+#define VFE_FRAME_DROP_VAL 30
 
 #define VFE_NEXT_SOF_MS 500
 
@@ -659,7 +659,9 @@ static int vfe_enable_output(struct vfe_line *line)
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
 	const struct vfe_hw_ops *ops = vfe->ops;
+	struct media_entity *sensor;
 	unsigned long flags;
+	unsigned int frame_skip = 0;
 	unsigned int i;
 	u16 ub_size;
 
@@ -667,6 +669,17 @@ static int vfe_enable_output(struct vfe_line *line)
 	if (!ub_size)
 		return -EINVAL;
 
+	sensor = camss_find_sensor(&line->subdev.entity);
+	if (sensor) {
+		struct v4l2_subdev *subdev =
+					media_entity_to_v4l2_subdev(sensor);
+
+		v4l2_subdev_call(subdev, sensor, g_skip_frames, &frame_skip);
+		/* Max frame skip is 29 frames */
+		if (frame_skip > VFE_FRAME_DROP_VAL - 1)
+			frame_skip = VFE_FRAME_DROP_VAL - 1;
+	}
+
 	spin_lock_irqsave(&vfe->output_lock, flags);
 
 	ops->reg_update_clear(vfe, line->id);
@@ -695,10 +708,10 @@ static int vfe_enable_output(struct vfe_line *line)
 
 	switch (output->state) {
 	case VFE_OUTPUT_SINGLE:
-		vfe_output_frame_drop(vfe, output, 1);
+		vfe_output_frame_drop(vfe, output, 1 << frame_skip);
 		break;
 	case VFE_OUTPUT_CONTINUOUS:
-		vfe_output_frame_drop(vfe, output, 3);
+		vfe_output_frame_drop(vfe, output, 3 << frame_skip);
 		break;
 	default:
 		vfe_output_frame_drop(vfe, output, 0);
diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 669615f..b307f6e 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -346,7 +346,7 @@ void camss_disable_clocks(int nclocks, struct camss_clock *clock)
  *
  * Return a pointer to sensor media entity or NULL if not found
  */
-static struct media_entity *camss_find_sensor(struct media_entity *entity)
+struct media_entity *camss_find_sensor(struct media_entity *entity)
 {
 	struct media_pad *pad;
 
diff --git a/drivers/media/platform/qcom/camss/camss.h b/drivers/media/platform/qcom/camss/camss.h
index 418996d..c488f63 100644
--- a/drivers/media/platform/qcom/camss/camss.h
+++ b/drivers/media/platform/qcom/camss/camss.h
@@ -107,6 +107,7 @@ void camss_add_clock_margin(u64 *rate);
 int camss_enable_clocks(int nclocks, struct camss_clock *clock,
 			struct device *dev);
 void camss_disable_clocks(int nclocks, struct camss_clock *clock);
+struct media_entity *camss_find_sensor(struct media_entity *entity);
 int camss_get_pixel_clock(struct media_entity *entity, u32 *pixel_clock);
 int camss_pm_domain_on(struct camss *camss, int id);
 void camss_pm_domain_off(struct camss *camss, int id);
-- 
2.7.4
