Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57991 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751209AbaBGUYN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Feb 2014 15:24:13 -0500
Date: Fri, 7 Feb 2014 20:23:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org, Takashi Iwai <tiwai@suse.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH RFC 0/2] drivers/base: simplify simple DT-based
	components
Message-ID: <20140207202351.GH26684@n2100.arm.linux.org.uk>
References: <cover.1391793068.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1391793068.git.moinejf@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 07, 2014 at 06:11:08PM +0100, Jean-Francois Moine wrote:
> This patch series tries to simplify the code of simple devices in case
> they are part of componentised subsystems, are declared in a DT, and
> are not using the component bin/unbind functions.

Here's my changes to the TDA998x driver to add support for the component
helper.  The TDA998x driver retains support for the old way so that
drivers can be transitioned.  For any one DRM "card" the transition to
using the component layer must be all-in or all-out - partial transitions
are not permitted with the simple locking implementation currently in
the component helper due to the possibility of deadlock.  (Master
binds, holding the component lock, master declares i2c device, i2c
device is bound to tda998x, which tries to register with the component
layer, trying to take the held lock.)

http://ftp.arm.linux.org.uk/cgit/linux-cubox.git/log/?h=unstable/tda998x-devel

It's marked unstable because the two "drivers/base" commits in there are
_not_ the upstream commits.  You'll notice that I just sent one of those
to Gregkh in patch form.

Now, the bits which aren't in that branch but which update the Armada
driver is the below, which needs some clean up and removal of some local
differences I have in my cubox tree, but nicely illustrates why /your/
patches to the component stuff is the wrong approach.

Not only does the patch below add support for using the componentised
TDA998x driver in the above link, but it allows that componentised support
to be specified not only via platform data but also via DT.  The DT
stuff is untested, but it works exactly the same way as imx-drm does
which has been tested.

And yes, I'm thinking that maybe moving compare_of() into the component
support so that drivers can share this generic function may be a good
idea.

So... as I've been saying, no changes to component.c are required here.

diff --git a/drivers/gpu/drm/armada/armada_drv.c b/drivers/gpu/drm/armada/armada_drv.c
index 6f6554bac93f..1f2b7c60bff9 100644
--- a/drivers/gpu/drm/armada/armada_drv.c
+++ b/drivers/gpu/drm/armada/armada_drv.c
@@ -6,7 +6,9 @@
  * published by the Free Software Foundation.
  */
 #include <linux/clk.h>
+#include <linux/component.h>
 #include <linux/module.h>
+#include <linux/platform_data/armada_drm.h>
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
 #include "armada_crtc.h"
@@ -53,6 +55,11 @@ static const struct armada_drm_slave_config tda19988_config = {
 };
 #endif
 
+static bool is_componentized(struct device *dev)
+{
+	return dev->of_node || dev->platform_data;
+}
+
 static void armada_drm_unref_work(struct work_struct *work)
 {
 	struct armada_private *priv =
@@ -171,16 +178,22 @@ static int armada_drm_load(struct drm_device *dev, unsigned long flags)
 			goto err_kms;
 	}
 
+	if (is_componentized(dev->dev)) {
+		ret = component_bind_all(dev->dev, dev);
+		if (ret)
+			goto err_kms;
+	} else {
 #ifdef CONFIG_DRM_ARMADA_TDA1998X
-	ret = armada_drm_connector_slave_create(dev, &tda19988_config);
-	if (ret)
-		goto err_kms;
+		ret = armada_drm_connector_slave_create(dev, &tda19988_config);
+		if (ret)
+			goto err_kms;
 #endif
 #ifdef CONFIG_DRM_ARMADA_TDA1998X_NXP
-	ret = armada_drm_tda19988_nxp_create(dev);
-	if (ret)
-		goto err_kms;
+		ret = armada_drm_tda19988_nxp_create(dev);
+		if (ret)
+			goto err_kms;
 #endif
+	}
 
 	ret = drm_vblank_init(dev, n);
 	if (ret)
@@ -204,6 +217,10 @@ static int armada_drm_load(struct drm_device *dev, unsigned long flags)
 	drm_irq_uninstall(dev);
  err_kms:
 	drm_mode_config_cleanup(dev);
+
+	if (is_componentized(dev->dev))
+		component_unbind_all(dev->dev, dev);
+
 	drm_mm_takedown(&priv->linear);
 	flush_work(&priv->fb_unref_work);
 
@@ -218,6 +235,10 @@ static int armada_drm_unload(struct drm_device *dev)
 	armada_fbdev_fini(dev);
 	drm_irq_uninstall(dev);
 	drm_mode_config_cleanup(dev);
+
+	if (is_componentized(dev->dev))
+		component_unbind_all(dev->dev, dev);
+
 	drm_mm_takedown(&priv->linear);
 	flush_work(&priv->fb_unref_work);
 	dev->dev_private = NULL;
@@ -380,14 +401,82 @@ static struct drm_driver armada_drm_driver = {
 	.fops			= &armada_drm_fops,
 };
 
+static int armada_drm_bind(struct device *dev)
+{
+	return drm_platform_init(&armada_drm_driver, to_platform_device(dev));
+}
+
+static void armada_drm_unbind(struct device *dev)
+{
+	drm_platform_exit(&armada_drm_driver, to_platform_device(dev));
+}
+
+static int compare_of(struct device *dev, void *data)
+{
+	return dev->of_node == data;
+}
+
+static int armada_drm_compare_name(struct device *dev, void *data)
+{
+	const char *name = data;
+	return !strcmp(dev_name(dev), name);
+}
+
+static int armada_drm_add_components(struct device *dev, struct master *master)
+{
+	int i, ret = -ENXIO;
+
+	if (dev->of_node) {
+		struct device_node *np = dev->of_node;
+
+		for (i = 0; ; i++) {
+			struct device_node *node;
+
+			node = of_parse_phandle(np, "connectors", i);
+			if (!node)
+				break;
+
+			ret = component_master_add_child(master, compare_of,
+							 node);
+			of_node_put(node);
+			if (ret)
+				break;
+		}
+	} else if (dev->platform_data) {
+		struct armada_drm_platform_data *data = dev->platform_data;
+
+		for (i = 0; i < data->num_devices; i++) {
+			ret = component_master_add_child(master,
+					armada_drm_compare_name,
+					(void *)data->devices[i]);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static const struct component_master_ops armada_master_ops = {
+	.add_components = armada_drm_add_components,
+	.bind = armada_drm_bind,
+	.unbind = armada_drm_unbind,
+};
+
 static int armada_drm_probe(struct platform_device *pdev)
 {
-	return drm_platform_init(&armada_drm_driver, pdev);
+	if (is_componentized(&pdev->dev))
+		return component_master_add(&pdev->dev, &armada_master_ops);
+	else
+		return drm_platform_init(&armada_drm_driver, pdev);
 }
 
 static int armada_drm_remove(struct platform_device *pdev)
 {
-	drm_platform_exit(&armada_drm_driver, pdev);
+	if (is_componentized(&pdev->dev))
+		component_master_del(&pdev->dev, &armada_master_ops);
+	else
+		drm_platform_exit(&armada_drm_driver, pdev);
 	return 0;
 }
 


-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
