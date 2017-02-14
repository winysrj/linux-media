Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59135 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754005AbdBNNkV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:40:21 -0500
Date: Tue, 14 Feb 2017 14:40:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [RFC 11/13] gpio-switch is for some reason neccessary for camera to
 work.
Message-ID: <20170214134019.GA8631@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Probably something fun happening in userspace.
---
 arch/arm/mach-omap2/Makefile                 |  1 +
 arch/arm/mach-omap2/board-rx51-peripherals.c | 51 ++++++++++++++++++++++++=
++++
 2 files changed, 52 insertions(+)
 create mode 100644 arch/arm/mach-omap2/board-rx51-peripherals.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 4698940..d536b1a 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -229,6 +229,7 @@ obj-$(CONFIG_SOC_OMAP2420)		+=3D msdi.o
 # Specific board support
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+=3D board-generic.o pdata-quirks.o
 obj-$(CONFIG_MACH_NOKIA_N8X0)		+=3D board-n8x0.o
+obj-y					+=3D board-rx51-peripherals.o
=20
 # Platform specific device init code
=20
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-o=
map2/board-rx51-peripherals.c
new file mode 100644
index 0000000..641c2be
--- /dev/null
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -0,0 +1,51 @@
+/*
+ * linux/arch/arm/mach-omap2/board-rx51-peripherals.c
+ *
+ * Copyright (C) 2008-2009 Nokia
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+#include <linux/gpio/machine.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/timer.h>
+
+static struct platform_driver gpio_sw_driver =3D {
+	.driver		=3D {
+		.name	=3D "gpio-switch",
+	},
+};
+
+static int __init gpio_sw_init(void)
+{
+	int r;
+
+	printk(KERN_INFO "OMAP GPIO switch handler initializing\n");
+
+	r =3D platform_driver_register(&gpio_sw_driver);
+	if (r)
+		return r;
+
+	platform_device_register_simple("gpio-switch",
+							       -1, NULL, 0);
+	return 0;
+}
+
+static void __exit gpio_sw_exit(void)
+{
+}
+
+#ifndef MODULE
+late_initcall(gpio_sw_init);
+#else
+module_init(gpio_sw_init);
+#endif
+module_exit(gpio_sw_exit);
--=20
2.1.4


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijCMMACgkQMOfwapXb+vKbxwCgjUAFtKVnv25aODHmFsuN/Gp8
rJoAn03BQOmngPFaATGM2U2XeJoqkCkj
=UAMs
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
