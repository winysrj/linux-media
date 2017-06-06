Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35669 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751474AbdFFXhp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 19:37:45 -0400
Received: by mail-pf0-f175.google.com with SMTP id l89so28698696pfi.2
        for <linux-media@vger.kernel.org>; Tue, 06 Jun 2017 16:37:45 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/4] [media] davinci: vpif_capture: get subdevs from DT when available
Date: Tue,  6 Jun 2017 16:37:39 -0700
Message-Id: <20170606233741.26718-3-khilman@baylibre.com>
In-Reply-To: <20170606233741.26718-1-khilman@baylibre.com>
References: <20170606233741.26718-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable  getting of subdevs from DT ports and endpoints.

The _get_pdata() function was larely inspired by (i.e. stolen from)
am437x-vpfe.c

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 126 +++++++++++++++++++++++++-
 drivers/media/platform/davinci/vpif_display.c |   5 +
 include/media/davinci/vpif_types.h            |   9 +-
 3 files changed, 134 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index fc5c7622660c..b9d927d1e5a8 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -22,6 +22,8 @@
 #include <linux/slab.h>
 
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-of.h>
+#include <media/i2c/tvp514x.h>
 
 #include "vpif.h"
 #include "vpif_capture.h"
@@ -655,7 +657,7 @@ static int vpif_input_to_subdev(
 	/* loop through the sub device list to get the sub device info */
 	for (i = 0; i < vpif_cfg->subdev_count; i++) {
 		subdev_info = &vpif_cfg->subdev_info[i];
-		if (!strcmp(subdev_info->name, subdev_name))
+		if (subdev_info && !strcmp(subdev_info->name, subdev_name))
 			return i;
 	}
 	return -1;
@@ -1308,6 +1310,21 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 {
 	int i;
 
+	for (i = 0; i < vpif_obj.config->asd_sizes[0]; i++) {
+		struct v4l2_async_subdev *_asd = vpif_obj.config->asd[i];
+		const struct device_node *node = _asd->match.of.node;
+
+		if (node == subdev->of_node) {
+			vpif_obj.sd[i] = subdev;
+			vpif_obj.config->chan_config->inputs[i].subdev_name =
+				(char *)subdev->of_node->full_name;
+			vpif_dbg(2, debug,
+				 "%s: setting input %d subdev_name = %s\n",
+				 __func__, i, subdev->of_node->full_name);
+			return 0;
+		}
+	}
+
 	for (i = 0; i < vpif_obj.config->subdev_count; i++)
 		if (!strcmp(vpif_obj.config->subdev_info[i].name,
 			    subdev->name)) {
@@ -1403,6 +1420,105 @@ static int vpif_async_complete(struct v4l2_async_notifier *notifier)
 	return vpif_probe_complete();
 }
 
+static struct vpif_capture_config *
+vpif_capture_get_pdata(struct platform_device *pdev)
+{
+	struct device_node *endpoint = NULL;
+	struct v4l2_of_endpoint bus_cfg;
+	struct vpif_capture_config *pdata;
+	struct vpif_subdev_info *sdinfo;
+	struct vpif_capture_chan_config *chan;
+	unsigned int i;
+
+	/*
+	 * DT boot: OF node from parent device contains
+	 * video ports & endpoints data.
+	 */
+	if (pdev->dev.parent && pdev->dev.parent->of_node)
+		pdev->dev.of_node = pdev->dev.parent->of_node;
+	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
+		return pdev->dev.platform_data;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+	pdata->subdev_info =
+		devm_kzalloc(&pdev->dev, sizeof(*pdata->subdev_info) *
+			     VPIF_CAPTURE_NUM_CHANNELS, GFP_KERNEL);
+
+	if (!pdata->subdev_info)
+		return NULL;
+
+	for (i = 0; i < VPIF_CAPTURE_NUM_CHANNELS; i++) {
+		struct device_node *rem;
+		unsigned int flags;
+		int err;
+
+		endpoint = of_graph_get_next_endpoint(pdev->dev.of_node,
+						      endpoint);
+		if (!endpoint)
+			break;
+
+		sdinfo = &pdata->subdev_info[i];
+		chan = &pdata->chan_config[i];
+		chan->inputs = devm_kzalloc(&pdev->dev,
+					    sizeof(*chan->inputs) *
+					    VPIF_CAPTURE_NUM_CHANNELS,
+					    GFP_KERNEL);
+
+		chan->input_count++;
+		chan->inputs[i].input.type = V4L2_INPUT_TYPE_CAMERA;
+		chan->inputs[i].input.std = V4L2_STD_ALL;
+		chan->inputs[i].input.capabilities = V4L2_IN_CAP_STD;
+
+		err = v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+		if (err) {
+			dev_err(&pdev->dev, "Could not parse the endpoint\n");
+			goto done;
+		}
+		dev_dbg(&pdev->dev, "Endpoint %s, bus_width = %d\n",
+			endpoint->full_name, bus_cfg.bus.parallel.bus_width);
+		flags = bus_cfg.bus.parallel.flags;
+
+		if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+			chan->vpif_if.hd_pol = 1;
+
+		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+			chan->vpif_if.vd_pol = 1;
+
+		rem = of_graph_get_remote_port_parent(endpoint);
+		if (!rem) {
+			dev_dbg(&pdev->dev, "Remote device at %s not found\n",
+				endpoint->full_name);
+			goto done;
+		}
+
+		dev_dbg(&pdev->dev, "Remote device %s, %s found\n",
+			rem->name, rem->full_name);
+		sdinfo->name = rem->full_name;
+
+		pdata->asd[i] = devm_kzalloc(&pdev->dev,
+					     sizeof(struct v4l2_async_subdev),
+					     GFP_KERNEL);
+		if (!pdata->asd[i]) {
+			of_node_put(rem);
+			pdata = NULL;
+			goto done;
+		}
+
+		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_OF;
+		pdata->asd[i]->match.of.node = rem;
+		of_node_put(rem);
+	}
+
+done:
+	pdata->asd_sizes[0] = i;
+	pdata->subdev_count = i;
+	pdata->card_name = "DA850/OMAP-L138 Video Capture";
+
+	return pdata;
+}
+
 /**
  * vpif_probe : This function probes the vpif capture driver
  * @pdev: platform device pointer
@@ -1419,6 +1535,12 @@ static __init int vpif_probe(struct platform_device *pdev)
 	int res_idx = 0;
 	int i, err;
 
+	pdev->dev.platform_data = vpif_capture_get_pdata(pdev);
+	if (!pdev->dev.platform_data) {
+		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
+		return -EINVAL;
+	}
+
 	if (!pdev->dev.platform_data) {
 		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
 		return -EINVAL;
@@ -1459,7 +1581,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		goto vpif_unregister;
 	}
 
-	if (!vpif_obj.config->asd_sizes) {
+	if (!vpif_obj.config->asd_sizes[0]) {
 		int i2c_id = vpif_obj.config->i2c_adapter_id;
 
 		i2c_adap = i2c_get_adapter(i2c_id);
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 7e5cf9923c8d..b5ac6ce626b3 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1250,6 +1250,11 @@ static __init int vpif_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	if (!pdev->dev.platform_data) {
+		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
+		return -EINVAL;
+	}
+
 	vpif_dev = &pdev->dev;
 	err = initialize_vpif();
 
diff --git a/include/media/davinci/vpif_types.h b/include/media/davinci/vpif_types.h
index 385597da20dc..eae23e4e9b93 100644
--- a/include/media/davinci/vpif_types.h
+++ b/include/media/davinci/vpif_types.h
@@ -62,14 +62,14 @@ struct vpif_display_config {
 
 struct vpif_input {
 	struct v4l2_input input;
-	const char *subdev_name;
+	char *subdev_name;
 	u32 input_route;
 	u32 output_route;
 };
 
 struct vpif_capture_chan_config {
 	struct vpif_interface vpif_if;
-	const struct vpif_input *inputs;
+	struct vpif_input *inputs;
 	int input_count;
 };
 
@@ -81,7 +81,8 @@ struct vpif_capture_config {
 	int subdev_count;
 	int i2c_adapter_id;
 	const char *card_name;
-	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
-	int *asd_sizes;		/* 0-terminated array of asd group sizes */
+
+	struct v4l2_async_subdev *asd[VPIF_CAPTURE_MAX_CHANNELS];
+	int asd_sizes[VPIF_CAPTURE_MAX_CHANNELS];
 };
 #endif /* _VPIF_TYPES_H */
-- 
2.9.3
