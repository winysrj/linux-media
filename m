Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:39013 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab3DQPSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:18:20 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 09/10] video: Versatile Express DVI mode driver
Date: Wed, 17 Apr 2013 16:17:21 +0100
Message-Id: <1366211842-21497-10-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
References: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Versatile Express DVI output is driven by a Sii9022 chip. It can be
controller to a limited extend by the Motherboard Config Controller,
and that's what the driver is doing now. It is a temporary measure
till there's a full I2C driver for the chip.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/video/Makefile           |    1 +
 drivers/video/vexpress-dvimode.c |  158 ++++++++++++++++++++++++++++++++++=
++++
 2 files changed, 159 insertions(+)
 create mode 100644 drivers/video/vexpress-dvimode.c

diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 84c6083..9347e00 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -179,3 +179,4 @@ obj-$(CONFIG_OF_VIDEOMODE) +=3D of_videomode.o
=20
 # platform specific output drivers
 obj-$(CONFIG_VEXPRESS_CONFIG)=09  +=3D vexpress-muxfpga.o
+obj-$(CONFIG_VEXPRESS_CONFIG)=09  +=3D vexpress-dvimode.o
diff --git a/drivers/video/vexpress-dvimode.c b/drivers/video/vexpress-dvim=
ode.c
new file mode 100644
index 0000000..85d5608
--- /dev/null
+++ b/drivers/video/vexpress-dvimode.c
@@ -0,0 +1,158 @@
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
+#define pr_fmt(fmt) "vexpress-dvimode: " fmt
+
+#include <linux/fb.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/vexpress.h>
+#include <video/display.h>
+#include <video/videomode.h>
+
+
+static struct vexpress_config_func *vexpress_dvimode_func;
+
+
+static int vexpress_dvimode_display_update(struct display_entity *display,
+=09=09const struct videomode *mode)
+{
+=09static const struct {
+=09=09u32 hactive, vactive, dvimode;
+=09} dvimodes[] =3D {
+=09=09{ 640, 480, 0 }, /* VGA */
+=09=09{ 800, 600, 1 }, /* SVGA */
+=09=09{ 1024, 768, 2 }, /* XGA */
+=09=09{ 1280, 1024, 3 }, /* SXGA */
+=09=09{ 1600, 1200, 4 }, /* UXGA */
+=09=09{ 1920, 1080, 5 }, /* HD1080 */
+=09};
+=09int err =3D -ENOENT;
+=09int i;
+
+=09for (i =3D 0; i < ARRAY_SIZE(dvimodes); i++) {
+=09=09if (dvimodes[i].hactive =3D=3D mode->hactive &&
+=09=09=09=09dvimodes[i].vactive =3D=3D mode->vactive) {
+=09=09=09pr_debug("mode: %ux%u =3D %d\n", mode->hactive,
+=09=09=09=09=09mode->vactive, dvimodes[i].dvimode);
+=09=09=09err =3D vexpress_config_write(vexpress_dvimode_func, 0,
+=09=09=09=09=09dvimodes[i].dvimode);
+=09=09=09break;
+=09=09}
+=09}
+
+=09if (err)
+=09=09pr_warn("Failed to set %ux%u mode! (%d)\n", mode->hactive,
+=09=09=09=09mode->vactive, err);
+
+=09return err;
+}
+
+static int vexpress_dvimode_display_get_modes(struct display_entity *displ=
ay,
+=09=09const struct videomode **modes)
+{
+=09static const struct videomode m[] =3D {
+=09=09{
+=09=09=09/* VGA */
+=09=09=09.pixelclock=09=3D 25175000,
+=09=09=09.hactive=09=3D 640,
+=09=09=09.hback_porch=09=3D 40,
+=09=09=09.hfront_porch=09=3D 24,
+=09=09=09.vfront_porch=09=3D 11,
+=09=09=09.hsync_len=09=3D 96,
+=09=09=09.vactive=09=3D 480,
+=09=09=09.vback_porch=09=3D 32,
+=09=09=09.vsync_len=09=3D 2,
+=09=09}, {
+=09=09=09/* XGA */
+=09=09=09.pixelclock=09=3D 63500127,
+=09=09=09.hactive=09=3D 1024,
+=09=09=09.hback_porch=09=3D 152,
+=09=09=09.hfront_porch=09=3D 48,
+=09=09=09.hsync_len=09=3D 104,
+=09=09=09.vactive=09=3D 768,
+=09=09=09.vback_porch=09=3D 23,
+=09=09=09.vfront_porch=09=3D 3,
+=09=09=09.vsync_len=09=3D 4,
+=09=09}, {
+=09=09=09/* SXGA */
+=09=09=09.pixelclock=09=3D 108000000,
+=09=09=09.hactive=09=3D 1280,
+=09=09=09.hback_porch=09=3D 248,
+=09=09=09.hfront_porch=09=3D 48,
+=09=09=09.hsync_len=09=3D 112,
+=09=09=09.vactive=09=3D 1024,
+=09=09=09.vback_porch=09=3D 38,
+=09=09=09.vfront_porch=09=3D 1,
+=09=09=09.vsync_len=09=3D 3,
+=09=09},
+=09};
+
+=09*modes =3D m;
+
+=09return ARRAY_SIZE(m);
+}
+
+static int vexpress_dvimode_display_get_params(struct display_entity *disp=
lay,
+=09=09struct display_entity_interface_params *params)
+{
+=09params->type =3D DISPLAY_ENTITY_INTERFACE_TFT_PARALLEL;
+=09params->p.tft_parallel.r_bits =3D 8;
+=09params->p.tft_parallel.g_bits =3D 8;
+=09params->p.tft_parallel.b_bits =3D 8;
+=09params->p.tft_parallel.r_b_swapped =3D 0;
+
+=09return 0;
+}
+
+static const struct display_entity_control_ops vexpress_dvimode_display_op=
s =3D {
+=09.update =3D vexpress_dvimode_display_update,
+=09.get_modes =3D vexpress_dvimode_display_get_modes,
+=09.get_params =3D vexpress_dvimode_display_get_params,
+};
+
+static struct display_entity vexpress_dvimode_display =3D {
+=09.ops.ctrl =3D &vexpress_dvimode_display_ops,
+};
+
+static struct of_device_id vexpress_dvimode_of_match[] =3D {
+=09{ .compatible =3D "arm,vexpress-dvimode", },
+=09{}
+};
+
+static int vexpress_dvimode_probe(struct platform_device *pdev)
+{
+=09vexpress_dvimode_func =3D vexpress_config_func_get_by_dev(&pdev->dev);
+
+=09vexpress_dvimode_display.dev =3D &pdev->dev;
+=09display_entity_register(&vexpress_dvimode_display);
+=09of_display_entity_add_provider(pdev->dev.of_node,
+=09=09=09of_display_entity_provider_simple_get,
+=09=09=09&vexpress_dvimode_display);
+
+=09return 0;
+}
+
+static struct platform_driver vexpress_dvimode_driver =3D {
+=09.probe =3D vexpress_dvimode_probe,
+=09.driver =3D {
+=09=09.name =3D "vexpress-dvimode",
+=09=09.of_match_table =3D vexpress_dvimode_of_match,
+=09},
+};
+
+static int __init vexpress_dvimode_init(void)
+{
+=09return platform_driver_register(&vexpress_dvimode_driver);
+}
+device_initcall(vexpress_dvimode_init);
--=20
1.7.10.4


