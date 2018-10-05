Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47784 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727701AbeJETuk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 15:50:40 -0400
Date: Fri, 5 Oct 2018 15:52:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: bingbu.cao@intel.com
Subject: [GIT PULL v2 for 4.20] Unlocked V4L2 control grab, imx{319, 355}
 drivers
Message-ID: <20181005125202.iux6w2niftxzgqxu@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are drivers for Sony imx319 and imx355 sensors and an unlocked version
of v4l2_ctrl_grab() which is used by the driver.

Since v1, I've rebased this on the current master --- with the fwnode
patches.

Please pull.

The diff is here and effectively the same for both drivers:

diff --git a/drivers/media/i2c/imx319.c b/drivers/media/i2c/imx319.c
index 37c31d17ecf0..329049f7e64d 100644
--- a/drivers/media/i2c/imx319.c
+++ b/drivers/media/i2c/imx319.c
@@ -2356,7 +2356,9 @@ static int imx319_init_controls(struct imx319 *imx319)
 static struct imx319_hwcfg *imx319_get_hwcfg(struct device *dev)
 {
 	struct imx319_hwcfg *cfg;
-	struct v4l2_fwnode_endpoint *bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = {
+		.bus_type = V4L2_MBUS_CSI2_DPHY
+	};
 	struct fwnode_handle *ep;
 	struct fwnode_handle *fwnode = dev_fwnode(dev);
 	unsigned int i;
@@ -2369,8 +2371,8 @@ static struct imx319_hwcfg *imx319_get_hwcfg(struct device *dev)
 	if (!ep)
 		return NULL;
 
-	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(ep);
-	if (IS_ERR(bus_cfg))
+	ret = v4l2_fwnode_endpoint_alloc_parse(ep, &bus_cfg);
+	if (ret)
 		goto out_err;
 
 	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
@@ -2391,30 +2393,30 @@ static struct imx319_hwcfg *imx319_get_hwcfg(struct device *dev)
 		goto out_err;
 	}
 
-	dev_dbg(dev, "num of link freqs: %d", bus_cfg->nr_of_link_frequencies);
-	if (!bus_cfg->nr_of_link_frequencies) {
+	dev_dbg(dev, "num of link freqs: %d", bus_cfg.nr_of_link_frequencies);
+	if (!bus_cfg.nr_of_link_frequencies) {
 		dev_warn(dev, "no link frequencies defined");
 		goto out_err;
 	}
 
-	cfg->nr_of_link_freqs = bus_cfg->nr_of_link_frequencies;
+	cfg->nr_of_link_freqs = bus_cfg.nr_of_link_frequencies;
 	cfg->link_freqs = devm_kcalloc(
-		dev, bus_cfg->nr_of_link_frequencies + 1,
+		dev, bus_cfg.nr_of_link_frequencies + 1,
 		sizeof(*cfg->link_freqs), GFP_KERNEL);
 	if (!cfg->link_freqs)
 		goto out_err;
 
-	for (i = 0; i < bus_cfg->nr_of_link_frequencies; i++) {
-		cfg->link_freqs[i] = bus_cfg->link_frequencies[i];
+	for (i = 0; i < bus_cfg.nr_of_link_frequencies; i++) {
+		cfg->link_freqs[i] = bus_cfg.link_frequencies[i];
 		dev_dbg(dev, "link_freq[%d] = %lld", i, cfg->link_freqs[i]);
 	}
 
-	v4l2_fwnode_endpoint_free(bus_cfg);
+	v4l2_fwnode_endpoint_free(&bus_cfg);
 	fwnode_handle_put(ep);
 	return cfg;
 
 out_err:
-	v4l2_fwnode_endpoint_free(bus_cfg);
+	v4l2_fwnode_endpoint_free(&bus_cfg);
 	fwnode_handle_put(ep);
 	return NULL;
 }
diff --git a/drivers/media/i2c/imx355.c b/drivers/media/i2c/imx355.c
index 3baa0edc57a9..803df2a014bb 100644
--- a/drivers/media/i2c/imx355.c
+++ b/drivers/media/i2c/imx355.c
@@ -1656,7 +1656,9 @@ static int imx355_init_controls(struct imx355 *imx355)
 static struct imx355_hwcfg *imx355_get_hwcfg(struct device *dev)
 {
 	struct imx355_hwcfg *cfg;
-	struct v4l2_fwnode_endpoint *bus_cfg;
+	struct v4l2_fwnode_endpoint bus_cfg = {
+		.bus_type = V4L2_MBUS_CSI2_DPHY
+	};
 	struct fwnode_handle *ep;
 	struct fwnode_handle *fwnode = dev_fwnode(dev);
 	unsigned int i;
@@ -1669,8 +1671,8 @@ static struct imx355_hwcfg *imx355_get_hwcfg(struct device *dev)
 	if (!ep)
 		return NULL;
 
-	bus_cfg = v4l2_fwnode_endpoint_alloc_parse(ep);
-	if (IS_ERR(bus_cfg))
+	ret = v4l2_fwnode_endpoint_alloc_parse(ep, &bus_cfg);
+	if (ret)
 		goto out_err;
 
 	cfg = devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
@@ -1691,30 +1693,30 @@ static struct imx355_hwcfg *imx355_get_hwcfg(struct device *dev)
 		goto out_err;
 	}
 
-	dev_dbg(dev, "num of link freqs: %d", bus_cfg->nr_of_link_frequencies);
-	if (!bus_cfg->nr_of_link_frequencies) {
+	dev_dbg(dev, "num of link freqs: %d", bus_cfg.nr_of_link_frequencies);
+	if (!bus_cfg.nr_of_link_frequencies) {
 		dev_warn(dev, "no link frequencies defined");
 		goto out_err;
 	}
 
-	cfg->nr_of_link_freqs = bus_cfg->nr_of_link_frequencies;
+	cfg->nr_of_link_freqs = bus_cfg.nr_of_link_frequencies;
 	cfg->link_freqs = devm_kcalloc(
-		dev, bus_cfg->nr_of_link_frequencies + 1,
+		dev, bus_cfg.nr_of_link_frequencies + 1,
 		sizeof(*cfg->link_freqs), GFP_KERNEL);
 	if (!cfg->link_freqs)
 		goto out_err;
 
-	for (i = 0; i < bus_cfg->nr_of_link_frequencies; i++) {
-		cfg->link_freqs[i] = bus_cfg->link_frequencies[i];
+	for (i = 0; i < bus_cfg.nr_of_link_frequencies; i++) {
+		cfg->link_freqs[i] = bus_cfg.link_frequencies[i];
 		dev_dbg(dev, "link_freq[%d] = %lld", i, cfg->link_freqs[i]);
 	}
 
-	v4l2_fwnode_endpoint_free(bus_cfg);
+	v4l2_fwnode_endpoint_free(&bus_cfg);
 	fwnode_handle_put(ep);
 	return cfg;
 
 out_err:
-	v4l2_fwnode_endpoint_free(bus_cfg);
+	v4l2_fwnode_endpoint_free(&bus_cfg);
 	fwnode_handle_put(ep);
 	return NULL;
 }


The following changes since commit 158bc148a31ea22a2ef8cbaf4d968476bddefbc0:

  media: rc: mce_kbd: input events via rc-core's input device (2018-10-05 06:56:24 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.20-10-sign-2

for you to fetch changes up to 83da403a4a89dc1990b9d0f99ba16bc6d230eb02:

  media: add imx355 camera sensor driver (2018-10-05 14:46:35 +0300)

----------------------------------------------------------------
unlocked V4L2 ctrl grab; imx319 and imx355 drivers

----------------------------------------------------------------
Bingbu Cao (2):
      media: add imx319 camera sensor driver
      media: add imx355 camera sensor driver

Sakari Ailus (2):
      v4l: ctrl: Remove old documentation from v4l2_ctrl_grab
      v4l: ctrl: Provide unlocked variant of v4l2_ctrl_grab

 MAINTAINERS                          |   14 +
 drivers/media/i2c/Kconfig            |   22 +
 drivers/media/i2c/Makefile           |    2 +
 drivers/media/i2c/imx319.c           | 2560 ++++++++++++++++++++++++++++++++++
 drivers/media/i2c/imx355.c           | 1860 ++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c |   14 +-
 include/media/v4l2-ctrls.h           |   26 +-
 7 files changed, 4487 insertions(+), 11 deletions(-)
 create mode 100644 drivers/media/i2c/imx319.c
 create mode 100644 drivers/media/i2c/imx355.c


-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
