Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:35590 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbeGYRv1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 13:51:27 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 18/34] media: camss: Add basic runtime PM support
Date: Wed, 25 Jul 2018 19:38:27 +0300
Message-Id: <1532536723-19062-19-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
References: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a PM domain for each of the VFE hardware modules. Add
support for basic runtime PM support to be able to control the
PM domains. When a PM domain needs to be powered on - a device
link is created. When a PM domain needs to be powered off -
its device link is removed. This allows separate and
independent control of the PM domains.

Suspend/Resume is still not supported.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c   | 13 ++++-
 drivers/media/platform/qcom/camss/camss-csiphy.c | 15 +++++-
 drivers/media/platform/qcom/camss/camss-ispif.c  | 26 ++++++++--
 drivers/media/platform/qcom/camss/camss-vfe.c    | 17 +++++++
 drivers/media/platform/qcom/camss/camss.c        | 63 ++++++++++++++++++++++++
 drivers/media/platform/qcom/camss/camss.h        | 11 +++++
 6 files changed, 139 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index 627ef44..3ba087f 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
@@ -316,19 +317,27 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 	if (on) {
 		u32 hw_version;
 
-		ret = regulator_enable(csid->vdda);
+		ret = pm_runtime_get_sync(dev);
 		if (ret < 0)
 			return ret;
 
+		ret = regulator_enable(csid->vdda);
+		if (ret < 0) {
+			pm_runtime_put_sync(dev);
+			return ret;
+		}
+
 		ret = csid_set_clock_rates(csid);
 		if (ret < 0) {
 			regulator_disable(csid->vdda);
+			pm_runtime_put_sync(dev);
 			return ret;
 		}
 
 		ret = camss_enable_clocks(csid->nclocks, csid->clock, dev);
 		if (ret < 0) {
 			regulator_disable(csid->vdda);
+			pm_runtime_put_sync(dev);
 			return ret;
 		}
 
@@ -339,6 +348,7 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 			disable_irq(csid->irq);
 			camss_disable_clocks(csid->nclocks, csid->clock);
 			regulator_disable(csid->vdda);
+			pm_runtime_put_sync(dev);
 			return ret;
 		}
 
@@ -348,6 +358,7 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 		disable_irq(csid->irq);
 		camss_disable_clocks(csid->nclocks, csid->clock);
 		ret = regulator_disable(csid->vdda);
+		pm_runtime_put_sync(dev);
 	}
 
 	return ret;
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index 0383e94..4aeaedb 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
@@ -240,13 +241,21 @@ static int csiphy_set_power(struct v4l2_subdev *sd, int on)
 		u8 hw_version;
 		int ret;
 
-		ret = csiphy_set_clock_rates(csiphy);
+		ret = pm_runtime_get_sync(dev);
 		if (ret < 0)
 			return ret;
 
+		ret = csiphy_set_clock_rates(csiphy);
+		if (ret < 0) {
+			pm_runtime_put_sync(dev);
+			return ret;
+		}
+
 		ret = camss_enable_clocks(csiphy->nclocks, csiphy->clock, dev);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put_sync(dev);
 			return ret;
+		}
 
 		enable_irq(csiphy->irq);
 
@@ -259,6 +268,8 @@ static int csiphy_set_power(struct v4l2_subdev *sd, int on)
 		disable_irq(csiphy->irq);
 
 		camss_disable_clocks(csiphy->nclocks, csiphy->clock);
+
+		pm_runtime_put_sync(dev);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/qcom/camss/camss-ispif.c b/drivers/media/platform/qcom/camss/camss-ispif.c
index ed50cc5..2c6c0d2 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss/camss-ispif.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <media/media-entity.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
@@ -169,6 +170,14 @@ static int ispif_reset(struct ispif_device *ispif)
 	u32 val;
 	int ret;
 
+	ret = camss_pm_domain_on(to_camss(ispif), PM_DOMAIN_VFE0);
+	if (ret < 0)
+		return ret;
+
+	ret = camss_pm_domain_on(to_camss(ispif), PM_DOMAIN_VFE1);
+	if (ret < 0)
+		return ret;
+
 	ret = camss_enable_clocks(ispif->nclocks_for_reset,
 				  ispif->clock_for_reset,
 				  to_device(ispif));
@@ -201,12 +210,15 @@ static int ispif_reset(struct ispif_device *ispif)
 		msecs_to_jiffies(ISPIF_RESET_TIMEOUT_MS));
 	if (!time) {
 		dev_err(to_device(ispif), "ISPIF reset timeout\n");
-		return -EIO;
+		ret = -EIO;
 	}
 
 	camss_disable_clocks(ispif->nclocks_for_reset, ispif->clock_for_reset);
 
-	return 0;
+	camss_pm_domain_off(to_camss(ispif), PM_DOMAIN_VFE0);
+	camss_pm_domain_off(to_camss(ispif), PM_DOMAIN_VFE1);
+
+	return ret;
 }
 
 /*
@@ -232,12 +244,19 @@ static int ispif_set_power(struct v4l2_subdev *sd, int on)
 			goto exit;
 		}
 
-		ret = camss_enable_clocks(ispif->nclocks, ispif->clock, dev);
+		ret = pm_runtime_get_sync(dev);
 		if (ret < 0)
 			goto exit;
 
+		ret = camss_enable_clocks(ispif->nclocks, ispif->clock, dev);
+		if (ret < 0) {
+			pm_runtime_put_sync(dev);
+			goto exit;
+		}
+
 		ret = ispif_reset(ispif);
 		if (ret < 0) {
+			pm_runtime_put_sync(dev);
 			camss_disable_clocks(ispif->nclocks, ispif->clock);
 			goto exit;
 		}
@@ -252,6 +271,7 @@ static int ispif_set_power(struct v4l2_subdev *sd, int on)
 			goto exit;
 		} else if (ispif->power_count == 1) {
 			camss_disable_clocks(ispif->nclocks, ispif->clock);
+			pm_runtime_put_sync(dev);
 		}
 
 		ispif->power_count--;
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 3f589c4..474e1dd 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -15,6 +15,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/spinlock_types.h>
 #include <linux/spinlock.h>
 #include <media/media-entity.h>
@@ -1981,6 +1982,14 @@ static int vfe_get(struct vfe_device *vfe)
 	mutex_lock(&vfe->power_lock);
 
 	if (vfe->power_count == 0) {
+		ret = camss_pm_domain_on(vfe->camss, vfe->id);
+		if (ret < 0)
+			goto error_pm_domain;
+
+		ret = pm_runtime_get_sync(vfe->camss->dev);
+		if (ret < 0)
+			goto error_pm_runtime_get;
+
 		ret = vfe_set_clock_rates(vfe);
 		if (ret < 0)
 			goto error_clocks;
@@ -2012,6 +2021,12 @@ static int vfe_get(struct vfe_device *vfe)
 	camss_disable_clocks(vfe->nclocks, vfe->clock);
 
 error_clocks:
+	pm_runtime_put_sync(vfe->camss->dev);
+
+error_pm_runtime_get:
+	camss_pm_domain_off(vfe->camss, vfe->id);
+
+error_pm_domain:
 	mutex_unlock(&vfe->power_lock);
 
 	return ret;
@@ -2034,6 +2049,8 @@ static void vfe_put(struct vfe_device *vfe)
 			vfe_halt(vfe);
 		}
 		camss_disable_clocks(vfe->nclocks, vfe->clock);
+		pm_runtime_put_sync(vfe->camss->dev);
+		camss_pm_domain_off(vfe->camss, vfe->id);
 	}
 
 	vfe->power_count--;
diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 171e2c9..dcc0c30 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -14,6 +14,8 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_graph.h>
+#include <linux/pm_runtime.h>
+#include <linux/pm_domain.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
@@ -393,6 +395,26 @@ int camss_get_pixel_clock(struct media_entity *entity, u32 *pixel_clock)
 	return 0;
 }
 
+int camss_pm_domain_on(struct camss *camss, int id)
+{
+	if (camss->version == CAMSS_8x96) {
+		camss->genpd_link[id] = device_link_add(camss->dev,
+				camss->genpd[id], DL_FLAG_STATELESS |
+				DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
+
+		if (!camss->genpd_link[id])
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+void camss_pm_domain_off(struct camss *camss, int id)
+{
+	if (camss->version == CAMSS_8x96)
+		device_link_del(camss->genpd_link[id]);
+}
+
 /*
  * camss_of_parse_endpoint_node - Parse port endpoint node
  * @dev: Device
@@ -896,6 +918,23 @@ static int camss_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (camss->version == CAMSS_8x96) {
+		camss->genpd[PM_DOMAIN_VFE0] = dev_pm_domain_attach_by_id(
+						camss->dev, PM_DOMAIN_VFE0);
+		if (IS_ERR(camss->genpd[PM_DOMAIN_VFE0]))
+			return PTR_ERR(camss->genpd[PM_DOMAIN_VFE0]);
+
+		camss->genpd[PM_DOMAIN_VFE1] = dev_pm_domain_attach_by_id(
+						camss->dev, PM_DOMAIN_VFE1);
+		if (IS_ERR(camss->genpd[PM_DOMAIN_VFE1])) {
+			dev_pm_domain_detach(camss->genpd[PM_DOMAIN_VFE0],
+					     true);
+			return PTR_ERR(camss->genpd[PM_DOMAIN_VFE1]);
+		}
+	}
+
+	pm_runtime_enable(dev);
+
 	return 0;
 
 err_register_subdevs:
@@ -912,6 +951,13 @@ void camss_delete(struct camss *camss)
 	media_device_unregister(&camss->media_dev);
 	media_device_cleanup(&camss->media_dev);
 
+	pm_runtime_disable(camss->dev);
+
+	if (camss->version == CAMSS_8x96) {
+		dev_pm_domain_detach(camss->genpd[PM_DOMAIN_VFE0], true);
+		dev_pm_domain_detach(camss->genpd[PM_DOMAIN_VFE1], true);
+	}
+
 	kfree(camss);
 }
 
@@ -947,12 +993,29 @@ static const struct of_device_id camss_dt_match[] = {
 
 MODULE_DEVICE_TABLE(of, camss_dt_match);
 
+static int camss_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int camss_runtime_resume(struct device *dev)
+{
+	return 0;
+}
+
+static const struct dev_pm_ops camss_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+	SET_RUNTIME_PM_OPS(camss_runtime_suspend, camss_runtime_resume, NULL)
+};
+
 static struct platform_driver qcom_camss_driver = {
 	.probe = camss_probe,
 	.remove = camss_remove,
 	.driver = {
 		.name = "qcom-camss",
 		.of_match_table = camss_dt_match,
+		.pm = &camss_pm_ops,
 	},
 };
 
diff --git a/drivers/media/platform/qcom/camss/camss.h b/drivers/media/platform/qcom/camss/camss.h
index dff1045..418996d 100644
--- a/drivers/media/platform/qcom/camss/camss.h
+++ b/drivers/media/platform/qcom/camss/camss.h
@@ -10,6 +10,7 @@
 #ifndef QC_MSM_CAMSS_H
 #define QC_MSM_CAMSS_H
 
+#include <linux/device.h>
 #include <linux/types.h>
 #include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
@@ -56,6 +57,12 @@ struct resources_ispif {
 	char *interrupt;
 };
 
+enum pm_domain {
+	PM_DOMAIN_VFE0,
+	PM_DOMAIN_VFE1,
+	PM_DOMAIN_COUNT
+};
+
 enum camss_version {
 	CAMSS_8x16,
 	CAMSS_8x96,
@@ -75,6 +82,8 @@ struct camss {
 	int vfe_num;
 	struct vfe_device *vfe;
 	atomic_t ref_count;
+	struct device *genpd[PM_DOMAIN_COUNT];
+	struct device_link *genpd_link[PM_DOMAIN_COUNT];
 };
 
 struct camss_camera_interface {
@@ -99,6 +108,8 @@ int camss_enable_clocks(int nclocks, struct camss_clock *clock,
 			struct device *dev);
 void camss_disable_clocks(int nclocks, struct camss_clock *clock);
 int camss_get_pixel_clock(struct media_entity *entity, u32 *pixel_clock);
+int camss_pm_domain_on(struct camss *camss, int id);
+void camss_pm_domain_off(struct camss *camss, int id);
 void camss_delete(struct camss *camss);
 
 #endif /* QC_MSM_CAMSS_H */
-- 
2.7.4
