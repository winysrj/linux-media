Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:46839 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab3DQPSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:18:55 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 08/10] video: Versatile Express MUXFPGA driver
Date: Wed, 17 Apr 2013 16:17:20 +0100
Message-Id: <1366211842-21497-9-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
References: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Versatile Express' DVI video output can be connected to one the three
sources - motherboard's CLCD controller or a video signal generated
by one of the daughterboards.

This driver provides a Common Display Framework driver for the
muxer FPGA, which acts as a switch selecting one of the video data
sources. The default source is selected basing on the priority
list (which itself can be modified via module paramter), but
the user can make his own decision about it using the device's
sysfs "source" attribute.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 .../testing/sysfs-driver-video-vexpress-muxfpga    |    5 +
 drivers/video/Makefile                             |    3 +
 drivers/video/vexpress-muxfpga.c                   |  228 ++++++++++++++++=
++++
 3 files changed, 236 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-video-vexpress-m=
uxfpga
 create mode 100644 drivers/video/vexpress-muxfpga.c

diff --git a/Documentation/ABI/testing/sysfs-driver-video-vexpress-muxfpga =
b/Documentation/ABI/testing/sysfs-driver-video-vexpress-muxfpga
new file mode 100644
index 0000000..bfd568d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-video-vexpress-muxfpga
@@ -0,0 +1,5 @@
+What:=09=09/sys/bus/platform/drivers/vexpress-muxfpga/<muxfpga device>/sou=
rce
+Date:=09=09April 2013
+Contant:=09Pawel Moll <pawel.moll@arm.com>
+Description:=09This file stores the id of the video signal source
+=09=09supposed to be routed to the board's DVI output.
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index b989e8e..84c6083 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -176,3 +176,6 @@ obj-$(CONFIG_DISPLAY_TIMING) +=3D display_timing.o
 obj-$(CONFIG_OF_DISPLAY_TIMING) +=3D of_display_timing.o
 obj-$(CONFIG_VIDEOMODE) +=3D videomode.o
 obj-$(CONFIG_OF_VIDEOMODE) +=3D of_videomode.o
+
+# platform specific output drivers
+obj-$(CONFIG_VEXPRESS_CONFIG)=09  +=3D vexpress-muxfpga.o
diff --git a/drivers/video/vexpress-muxfpga.c b/drivers/video/vexpress-muxf=
pga.c
new file mode 100644
index 0000000..1731ad0
--- /dev/null
+++ b/drivers/video/vexpress-muxfpga.c
@@ -0,0 +1,228 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Copyright (C) 2013 ARM Limited
+ */
+
+#define pr_fmt(fmt) "vexpress-muxfpga: " fmt
+
+#include <linux/fb.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/vexpress.h>
+#include <video/display.h>
+#include <video/videomode.h>
+
+
+static struct vexpress_config_func *vexpress_muxfpga_func;
+static struct display_entity *vexpress_muxfpga_output;
+
+
+static struct vexpress_muxfpga_source {
+=09struct display_entity display;
+=09struct videomode mode;
+=09bool updated;
+} vexpress_muxfpga_sources[__VEXPRESS_SITE_LAST];
+static u32 vexpress_muxfpga_source_site =3D VEXPRESS_SITE_MB;
+static bool vexpress_muxfpga_source_stored;
+
+
+static int vexpress_muxfpga_set_site(u32 site)
+{
+=09int err;
+
+=09if (site >=3D ARRAY_SIZE(vexpress_muxfpga_sources))
+=09=09return -EINVAL;
+
+=09err =3D vexpress_config_write(vexpress_muxfpga_func, 0, site);
+=09if (!err) {
+=09=09pr_debug("Selected site %d as source\n", site);
+=09=09vexpress_muxfpga_source_site =3D site;
+=09} else {
+=09=09pr_warn("Failed to select site %d as source! (%d)\n",
+=09=09=09=09site, err);
+=09}
+
+=09return err;
+}
+
+static unsigned int vexpress_muxfpga_preferred_sites[] =3D {
+=09VEXPRESS_SITE_MASTER,
+=09VEXPRESS_SITE_DB1,
+=09VEXPRESS_SITE_DB2,
+=09VEXPRESS_SITE_MB,
+};
+static unsigned int vexpress_muxfpga_preferred_sites_num =3D
+=09=09ARRAY_SIZE(vexpress_muxfpga_preferred_sites);
+module_param_array_named(preferred_sites, vexpress_muxfpga_preferred_sites=
,
+=09=09uint, &vexpress_muxfpga_preferred_sites_num, S_IRUGO);
+MODULE_PARM_DESC(preferred_sites, "Preferred order of MUXFPGA (DVI output)=
 "
+=09=09"sources; values can be a daughterboard site ID (1-2), the "
+=09=09"motherboard ID (0) or a value describing the master site "
+=09=09"(0xf).");
+
+static int vexpress_muxfpga_get_priority(u32 site)
+{
+=09int i;
+
+=09for (i =3D 0; i < vexpress_muxfpga_preferred_sites_num; i++) {
+=09=09u32 preference =3D vexpress_muxfpga_preferred_sites[i];
+
+=09=09if (site =3D=3D vexpress_get_site(preference))
+=09=09=09return i;
+=09}
+
+=09return INT_MAX;
+}
+
+static void vexpress_muxfpga_set_preffered_site(u32 site)
+{
+=09int current_priority =3D vexpress_muxfpga_get_priority(
+=09=09=09vexpress_muxfpga_source_site);
+=09int new_priority =3D vexpress_muxfpga_get_priority(site);
+
+=09if (new_priority <=3D current_priority)
+=09=09vexpress_muxfpga_set_site(site);
+}
+
+
+static int vexpress_muxfpga_display_update(struct display_entity *display,
+=09=09const struct videomode *mode)
+{
+=09int err =3D display_entity_update(vexpress_muxfpga_output, mode);
+
+=09if (!err) {
+=09=09struct vexpress_muxfpga_source *source =3D container_of(display,
+=09=09=09=09struct vexpress_muxfpga_source, display);
+
+=09=09source->updated =3D true;
+=09=09source->mode =3D *mode;
+=09}
+
+=09return err;
+}
+
+static int vexpress_muxfpga_display_get_modes(struct display_entity *displ=
ay,
+=09=09const struct videomode **modes)
+{
+=09return display_entity_get_modes(vexpress_muxfpga_output, modes);
+}
+
+static int vexpress_muxfpga_display_get_params(struct display_entity *disp=
lay,
+=09=09struct display_entity_interface_params *params)
+{
+=09return display_entity_get_params(vexpress_muxfpga_output, params);
+}
+
+static const struct display_entity_control_ops vexpress_muxfpga_display_op=
s =3D {
+=09.update =3D vexpress_muxfpga_display_update,
+=09.get_modes =3D vexpress_muxfpga_display_get_modes,
+=09.get_params =3D vexpress_muxfpga_display_get_params,
+};
+
+
+static ssize_t vexpress_muxfpga_show_source(struct device *dev,
+=09=09struct device_attribute *attr, char *buf)
+{
+
+=09return sprintf(buf, "%u\n", vexpress_muxfpga_source_site);
+}
+
+static ssize_t vexpress_muxfpga_store_source(struct device *dev,
+=09=09struct device_attribute *attr, const char *buf, size_t count)
+{
+=09u32 site;
+=09int err =3D kstrtou32(buf, 0, &site);
+
+=09if (!err) {
+=09=09site =3D vexpress_get_site(site);
+=09=09err =3D vexpress_muxfpga_set_site(site);
+=09}
+
+=09if (!err)
+=09=09vexpress_muxfpga_source_stored =3D true;
+
+=09if (!err && vexpress_muxfpga_sources[site].updated)
+=09=09vexpress_muxfpga_display_update(
+=09=09=09=09&vexpress_muxfpga_sources[site].display,
+=09=09=09=09&vexpress_muxfpga_sources[site].mode);
+
+=09return err ? err : count;
+}
+
+DEVICE_ATTR(source, S_IRUGO | S_IWUSR, vexpress_muxfpga_show_source,
+=09=09vexpress_muxfpga_store_source);
+
+static struct display_entity *vexpress_muxfpga_display_get(
+=09=09struct of_phandle_args *spec, void *data)
+{
+=09u32 site =3D vexpress_get_site(spec->args[0]);
+
+=09if (WARN_ON(spec->args_count !=3D 1 ||
+=09=09=09site >=3D ARRAY_SIZE(vexpress_muxfpga_sources)))
+=09=09return NULL;
+
+=09/* Skip source selection if the user made his choice */
+=09if (!vexpress_muxfpga_source_stored)
+=09=09vexpress_muxfpga_set_preffered_site(site);
+
+=09return &vexpress_muxfpga_sources[site].display;
+}
+
+
+static struct of_device_id vexpress_muxfpga_of_match[] =3D {
+=09{ .compatible =3D "arm,vexpress-muxfpga", },
+=09{}
+};
+
+static int vexpress_muxfpga_probe(struct platform_device *pdev)
+{
+=09struct display_entity_interface_params params;
+=09int i;
+
+=09vexpress_muxfpga_output =3D of_display_entity_get(pdev->dev.of_node, 0)=
;
+=09if (!vexpress_muxfpga_output)
+=09=09return -EPROBE_DEFER;
+
+=09if (display_entity_get_params(vexpress_muxfpga_output, &params) !=3D 0 =
||
+=09=09=09params.type !=3D DISPLAY_ENTITY_INTERFACE_TFT_PARALLEL)
+=09=09return -EINVAL;
+
+=09vexpress_muxfpga_func =3D vexpress_config_func_get_by_dev(&pdev->dev);
+
+=09for (i =3D 0; i < ARRAY_SIZE(vexpress_muxfpga_sources); i++) {
+=09=09struct vexpress_muxfpga_source *source =3D
+=09=09=09&vexpress_muxfpga_sources[i];
+
+=09=09source->display.dev =3D &pdev->dev;
+=09=09source->display.ops.ctrl =3D &vexpress_muxfpga_display_ops;
+=09=09WARN_ON(display_entity_register(&source->display));
+=09=09of_display_entity_add_provider(pdev->dev.of_node,
+=09=09=09=09vexpress_muxfpga_display_get, NULL);
+=09}
+
+=09device_create_file(&pdev->dev, &dev_attr_source);
+
+=09return 0;
+}
+
+static struct platform_driver vexpress_muxfpga_driver =3D {
+=09.probe =3D vexpress_muxfpga_probe,
+=09.driver =3D {
+=09=09.name =3D "vexpress-muxfpga",
+=09=09.of_match_table =3D vexpress_muxfpga_of_match,
+=09},
+};
+
+static int __init vexpress_muxfpga_init(void)
+{
+=09return platform_driver_register(&vexpress_muxfpga_driver);
+}
+device_initcall(vexpress_muxfpga_init);
--=20
1.7.10.4


