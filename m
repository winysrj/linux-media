Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:59585 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab3HVQAl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 12:00:41 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-acpi@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, devel@driverdev.osuosl.org,
	alsa-devel@alsa-project.org
Subject: [PATCH V3] i2c: move of helpers into the core
Date: Thu, 22 Aug 2013 18:00:14 +0200
Message-Id: <1377187217-31820-1-git-send-email-wsa@the-dreams.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C of helpers used to live in of_i2c.c but experience (from SPI) shows
that it is much cleaner to have this in the core. This also removes a
circular dependency between the helpers and the core, and so we can
finally register child nodes in the core instead of doing this manually
in each driver. So, fix the drivers and documentation, too.

Acked-by: Rob Herring <rob.herring@calxeda.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---

V2->V3: Was trying to be too smart by only fixing includes needed.
	Took a more general approach this time, converting of_i2c.h
	to i2c.h in case i2c.h was not already there. Otherwise
	remove it. Improved my build scripts and no build failures,
	no complaints from buildbot as well.


 Documentation/acpi/enumeration.txt              |    1 -
 arch/powerpc/platforms/44x/warp.c               |    1 -
 drivers/gpu/drm/tilcdc/tilcdc_slave.c           |    1 -
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c          |    1 -
 drivers/gpu/host1x/drm/output.c                 |    2 +-
 drivers/i2c/busses/i2c-at91.c                   |    3 -
 drivers/i2c/busses/i2c-cpm.c                    |    6 --
 drivers/i2c/busses/i2c-davinci.c                |    2 -
 drivers/i2c/busses/i2c-designware-platdrv.c     |    2 -
 drivers/i2c/busses/i2c-gpio.c                   |    3 -
 drivers/i2c/busses/i2c-i801.c                   |    2 -
 drivers/i2c/busses/i2c-ibm_iic.c                |    4 -
 drivers/i2c/busses/i2c-imx.c                    |    3 -
 drivers/i2c/busses/i2c-mpc.c                    |    2 -
 drivers/i2c/busses/i2c-mv64xxx.c                |    3 -
 drivers/i2c/busses/i2c-mxs.c                    |    3 -
 drivers/i2c/busses/i2c-nomadik.c                |    3 -
 drivers/i2c/busses/i2c-ocores.c                 |    3 -
 drivers/i2c/busses/i2c-octeon.c                 |    3 -
 drivers/i2c/busses/i2c-omap.c                   |    3 -
 drivers/i2c/busses/i2c-pnx.c                    |    3 -
 drivers/i2c/busses/i2c-powermac.c               |    9 +-
 drivers/i2c/busses/i2c-pxa.c                    |    2 -
 drivers/i2c/busses/i2c-s3c2410.c                |    2 -
 drivers/i2c/busses/i2c-sh_mobile.c              |    2 -
 drivers/i2c/busses/i2c-sirf.c                   |    3 -
 drivers/i2c/busses/i2c-stu300.c                 |    2 -
 drivers/i2c/busses/i2c-tegra.c                  |    3 -
 drivers/i2c/busses/i2c-versatile.c              |    2 -
 drivers/i2c/busses/i2c-wmt.c                    |    3 -
 drivers/i2c/busses/i2c-xiic.c                   |    3 -
 drivers/i2c/i2c-core.c                          |  109 +++++++++++++++++++++-
 drivers/i2c/i2c-mux.c                           |    3 -
 drivers/i2c/muxes/i2c-arb-gpio-challenge.c      |    1 -
 drivers/i2c/muxes/i2c-mux-gpio.c                |    1 -
 drivers/i2c/muxes/i2c-mux-pinctrl.c             |    1 -
 drivers/media/platform/exynos4-is/fimc-is-i2c.c |    4 +-
 drivers/media/platform/exynos4-is/fimc-is.c     |    2 +-
 drivers/media/platform/exynos4-is/media-dev.c   |    1 -
 drivers/of/Kconfig                              |    6 --
 drivers/of/Makefile                             |    1 -
 drivers/of/of_i2c.c                             |  114 -----------------------
 drivers/staging/imx-drm/imx-tve.c               |    2 +-
 include/linux/i2c.h                             |   20 ++++
 include/linux/of_i2c.h                          |   46 ---------
 sound/soc/fsl/imx-sgtl5000.c                    |    2 +-
 sound/soc/fsl/imx-wm8962.c                      |    2 +-
 47 files changed, 138 insertions(+), 262 deletions(-)
 delete mode 100644 drivers/of/of_i2c.c
 delete mode 100644 include/linux/of_i2c.h

diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
index d9be7a9..958266e 100644
--- a/Documentation/acpi/enumeration.txt
+++ b/Documentation/acpi/enumeration.txt
@@ -238,7 +238,6 @@ An I2C bus (controller) driver does:
 	if (ret)
 		/* handle error */
 
-	of_i2c_register_devices(adapter);
 	/* Enumerate the slave devices behind this bus via ACPI */
 	acpi_i2c_register_devices(adapter);
 
diff --git a/arch/powerpc/platforms/44x/warp.c b/arch/powerpc/platforms/44x/warp.c
index 4cfa499..534574a 100644
--- a/arch/powerpc/platforms/44x/warp.c
+++ b/arch/powerpc/platforms/44x/warp.c
@@ -16,7 +16,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/of_gpio.h>
-#include <linux/of_i2c.h>
 #include <linux/slab.h>
 #include <linux/export.h>
 
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_slave.c b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
index dfffaf0..a19f657 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/i2c.h>
-#include <linux/of_i2c.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/consumer.h>
 #include <drm/drm_encoder_slave.h>
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index 925c7cd..c38b56b 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/i2c.h>
-#include <linux/of_i2c.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/pinmux.h>
diff --git a/drivers/gpu/host1x/drm/output.c b/drivers/gpu/host1x/drm/output.c
index 8140fc6..137ae81 100644
--- a/drivers/gpu/host1x/drm/output.c
+++ b/drivers/gpu/host1x/drm/output.c
@@ -9,7 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/of_gpio.h>
-#include <linux/of_i2c.h>
+#include <linux/i2c.h>
 
 #include "drm.h"
 
diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 6bb839b..fd05930 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -28,7 +28,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_i2c.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/platform_data/dma-atmel.h>
@@ -775,8 +774,6 @@ static int at91_twi_probe(struct platform_device *pdev)
 		return rc;
 	}
 
-	of_i2c_register_devices(&dev->adapter);
-
 	dev_info(dev->dev, "AT91 i2c bus driver.\n");
 	return 0;
 }
diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index 2e1f7eb..b2b8aa9 100644
--- a/drivers/i2c/busses/i2c-cpm.c
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -42,7 +42,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
-#include <linux/of_i2c.h>
 #include <sysdev/fsl_soc.h>
 #include <asm/cpm.h>
 
@@ -681,11 +680,6 @@ static int cpm_i2c_probe(struct platform_device *ofdev)
 	dev_dbg(&ofdev->dev, "hw routines for %s registered.\n",
 		cpm->adap.name);
 
-	/*
-	 * register OF I2C devices
-	 */
-	of_i2c_register_devices(&cpm->adap);
-
 	return 0;
 out_shut:
 	cpm_i2c_shutdown(cpm);
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index fa55605..62be3b3 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -38,7 +38,6 @@
 #include <linux/slab.h>
 #include <linux/cpufreq.h>
 #include <linux/gpio.h>
-#include <linux/of_i2c.h>
 #include <linux/of_device.h>
 
 #include <mach/hardware.h>
@@ -728,7 +727,6 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failure adding adapter\n");
 		goto err_unuse_clocks;
 	}
-	of_i2c_register_devices(adap);
 
 	return 0;
 
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 4c5fada..27ea436 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -35,7 +35,6 @@
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/of.h>
-#include <linux/of_i2c.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
@@ -172,7 +171,6 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failure adding adapter\n");
 		return r;
 	}
-	of_i2c_register_devices(adap);
 	acpi_i2c_register_devices(adap);
 
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index bc6e139..e5da9fe 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -16,7 +16,6 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
-#include <linux/of_i2c.h>
 
 struct i2c_gpio_private_data {
 	struct i2c_adapter adap;
@@ -224,8 +223,6 @@ static int i2c_gpio_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_add_bus;
 
-	of_i2c_register_devices(adap);
-
 	platform_set_drvdata(pdev, priv);
 
 	dev_info(&pdev->dev, "using pins %u (SDA) and %u (SCL%s)\n",
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 4ebceed..4296d17 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -87,7 +87,6 @@
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/err.h>
-#include <linux/of_i2c.h>
 
 #if (defined CONFIG_I2C_MUX_GPIO || defined CONFIG_I2C_MUX_GPIO_MODULE) && \
 		defined CONFIG_DMI
@@ -1230,7 +1229,6 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		goto exit_free_irq;
 	}
 
-	of_i2c_register_devices(&priv->adapter);
 	i801_probe_optional_slaves(priv);
 	/* We ignore errors - multiplexing is optional */
 	i801_add_mux(priv);
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index 973f516..ff3caa0 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -42,7 +42,6 @@
 #include <linux/io.h>
 #include <linux/i2c.h>
 #include <linux/of_platform.h>
-#include <linux/of_i2c.h>
 
 #include "i2c-ibm_iic.h"
 
@@ -759,9 +758,6 @@ static int iic_probe(struct platform_device *ofdev)
 	dev_info(&ofdev->dev, "using %s mode\n",
 		 dev->fast_mode ? "fast (400 kHz)" : "standard (100 kHz)");
 
-	/* Now register all the child nodes */
-	of_i2c_register_devices(adap);
-
 	return 0;
 
 error_cleanup:
diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index e242797..bbbea6b 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -50,7 +50,6 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_i2c.h>
 #include <linux/platform_data/i2c-imx.h>
 
 /** Defines ********************************************************************
@@ -570,8 +569,6 @@ static int __init i2c_imx_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	of_i2c_register_devices(&i2c_imx->adapter);
-
 	/* Set up platform driver data */
 	platform_set_drvdata(pdev, i2c_imx);
 
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 7607dc0..9f2513d 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -18,7 +18,6 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/of_platform.h>
-#include <linux/of_i2c.h>
 #include <linux/slab.h>
 
 #include <linux/io.h>
@@ -691,7 +690,6 @@ static int fsl_i2c_probe(struct platform_device *op)
 		dev_err(i2c->dev, "failed to add adapter\n");
 		goto fail_add;
 	}
-	of_i2c_register_devices(&i2c->adap);
 
 	return result;
 
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index b1f42bf..8220322 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -21,7 +21,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
-#include <linux/of_i2c.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 
@@ -689,8 +688,6 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 		goto exit_free_irq;
 	}
 
-	of_i2c_register_devices(&drv_data->adapter);
-
 	return 0;
 
 exit_free_irq:
diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index df8ff5a..62ed07d 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -27,7 +27,6 @@
 #include <linux/stmp_device.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_i2c.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 
@@ -701,8 +700,6 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	of_i2c_register_devices(adap);
-
 	return 0;
 }
 
diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 512dfe6..519df17 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -24,7 +24,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/i2c-nomadik.h>
 #include <linux/of.h>
-#include <linux/of_i2c.h>
 #include <linux/pinctrl/consumer.h>
 
 #define DRIVER_NAME "nmk-i2c"
@@ -1045,8 +1044,6 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 		goto err_add_adap;
 	}
 
-	of_i2c_register_devices(adap);
-
 	pm_runtime_put(&adev->dev);
 
 	return 0;
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 0e1f824..0a52b78 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -24,7 +24,6 @@
 #include <linux/i2c-ocores.h>
 #include <linux/slab.h>
 #include <linux/io.h>
-#include <linux/of_i2c.h>
 #include <linux/log2.h>
 
 struct ocores_i2c {
@@ -435,8 +434,6 @@ static int ocores_i2c_probe(struct platform_device *pdev)
 	if (pdata) {
 		for (i = 0; i < pdata->num_devices; i++)
 			i2c_new_device(&i2c->adap, pdata->devices + i);
-	} else {
-		of_i2c_register_devices(&i2c->adap);
 	}
 
 	return 0;
diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index 956fe32..b929ba2 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -15,7 +15,6 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/of_i2c.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -599,8 +598,6 @@ static int octeon_i2c_probe(struct platform_device *pdev)
 	}
 	dev_info(i2c->dev, "version %s\n", DRV_VERSION);
 
-	of_i2c_register_devices(&i2c->adap);
-
 	return 0;
 
 out:
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 142b694d..a9f0f80 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -38,7 +38,6 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/of.h>
-#include <linux/of_i2c.h>
 #include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/i2c-omap.h>
@@ -1245,8 +1244,6 @@ omap_i2c_probe(struct platform_device *pdev)
 	dev_info(dev->dev, "bus %d rev%d.%d at %d kHz\n", adap->nr,
 		 major, minor, dev->speed);
 
-	of_i2c_register_devices(adap);
-
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
 
diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
index 5f39c6d..7b57d67 100644
--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -23,7 +23,6 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
-#include <linux/of_i2c.h>
 
 #define I2C_PNX_TIMEOUT_DEFAULT		10 /* msec */
 #define I2C_PNX_SPEED_KHZ_DEFAULT	100
@@ -741,8 +740,6 @@ static int i2c_pnx_probe(struct platform_device *pdev)
 		goto out_irq;
 	}
 
-	of_i2c_register_devices(&alg_data->adapter);
-
 	dev_dbg(&pdev->dev, "%s: Master at %#8x, irq %d.\n",
 		alg_data->adapter.name, res->start, alg_data->irq);
 
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index 8dc90da..1010f2e 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -440,7 +440,9 @@ static int i2c_powermac_probe(struct platform_device *dev)
 	adapter->algo = &i2c_powermac_algorithm;
 	i2c_set_adapdata(adapter, bus);
 	adapter->dev.parent = &dev->dev;
-	adapter->dev.of_node = dev->dev.of_node;
+
+	/* Clear of_node to skip automatic registration of i2c child nodes */
+	adapter->dev.of_node = NULL;
 	rc = i2c_add_adapter(adapter);
 	if (rc) {
 		printk(KERN_ERR "i2c-powermac: Adapter %s registration "
@@ -450,9 +452,8 @@ static int i2c_powermac_probe(struct platform_device *dev)
 
 	printk(KERN_INFO "PowerMac i2c bus %s registered\n", adapter->name);
 
-	/* Cannot use of_i2c_register_devices() due to Apple device-tree
-	 * funkyness
-	 */
+	/* Use custom child registration due to Apple device-tree funkyness */
+	adapter->dev.of_node = dev->dev.of_node;
 	i2c_powermac_register_devices(adapter, bus);
 
 	return rc;
diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index fbafed2..bc65014 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -31,7 +31,6 @@
 #include <linux/i2c-pxa.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/of_i2c.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
 #include <linux/clk.h>
@@ -1185,7 +1184,6 @@ static int i2c_pxa_probe(struct platform_device *dev)
 		printk(KERN_INFO "I2C: Failed to add bus\n");
 		goto eadapt;
 	}
-	of_i2c_register_devices(&i2c->adap);
 
 	platform_set_drvdata(dev, i2c);
 
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index cab1c91..643426e 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -36,7 +36,6 @@
 #include <linux/cpufreq.h>
 #include <linux/slab.h>
 #include <linux/io.h>
-#include <linux/of_i2c.h>
 #include <linux/of_gpio.h>
 #include <linux/pinctrl/consumer.h>
 
@@ -1154,7 +1153,6 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	of_i2c_register_devices(&i2c->adap);
 	platform_set_drvdata(pdev, i2c);
 
 	pm_runtime_enable(&pdev->dev);
diff --git a/drivers/i2c/busses/i2c-sh_mobile.c b/drivers/i2c/busses/i2c-sh_mobile.c
index debf745..aa1268f 100644
--- a/drivers/i2c/busses/i2c-sh_mobile.c
+++ b/drivers/i2c/busses/i2c-sh_mobile.c
@@ -27,7 +27,6 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
-#include <linux/of_i2c.h>
 #include <linux/err.h>
 #include <linux/pm_runtime.h>
 #include <linux/clk.h>
@@ -758,7 +757,6 @@ static int sh_mobile_i2c_probe(struct platform_device *dev)
 		 "I2C adapter %d with bus speed %lu Hz (L/H=%x/%x)\n",
 		 adap->nr, pd->bus_speed, pd->iccl, pd->icch);
 
-	of_i2c_register_devices(adap);
 	return 0;
 
  err_all:
diff --git a/drivers/i2c/busses/i2c-sirf.c b/drivers/i2c/busses/i2c-sirf.c
index a63c7d5..0ff22e2 100644
--- a/drivers/i2c/busses/i2c-sirf.c
+++ b/drivers/i2c/busses/i2c-sirf.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
-#include <linux/of_i2c.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
@@ -366,8 +365,6 @@ static int i2c_sirfsoc_probe(struct platform_device *pdev)
 
 	clk_disable(clk);
 
-	of_i2c_register_devices(adap);
-
 	dev_info(&pdev->dev, " I2C adapter ready to operate\n");
 
 	return 0;
diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
index d1a6b20..047546c 100644
--- a/drivers/i2c/busses/i2c-stu300.c
+++ b/drivers/i2c/busses/i2c-stu300.c
@@ -17,7 +17,6 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include <linux/of_i2c.h>
 
 /* the name of this kernel module */
 #define NAME "stu300"
@@ -936,7 +935,6 @@ stu300_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dev);
 	dev_info(&pdev->dev, "ST DDC I2C @ %p, irq %d\n",
 		 dev->virtbase, dev->irq);
-	of_i2c_register_devices(adap);
 
 	return 0;
 }
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 9aa1b60..c457cb4 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -25,7 +25,6 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/of_i2c.h>
 #include <linux/of_device.h>
 #include <linux/module.h>
 #include <linux/clk/tegra.h>
@@ -802,8 +801,6 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	of_i2c_register_devices(&i2c_dev->adapter);
-
 	return 0;
 }
 
diff --git a/drivers/i2c/busses/i2c-versatile.c b/drivers/i2c/busses/i2c-versatile.c
index f3a8790..6bb3a89 100644
--- a/drivers/i2c/busses/i2c-versatile.c
+++ b/drivers/i2c/busses/i2c-versatile.c
@@ -16,7 +16,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/io.h>
-#include <linux/of_i2c.h>
 
 #define I2C_CONTROL	0x00
 #define I2C_CONTROLS	0x00
@@ -108,7 +107,6 @@ static int i2c_versatile_probe(struct platform_device *dev)
 	ret = i2c_bit_add_numbered_bus(&i2c->adap);
 	if (ret >= 0) {
 		platform_set_drvdata(dev, i2c);
-		of_i2c_register_devices(&i2c->adap);
 		return 0;
 	}
 
diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index baaa7d1..c65da3d 100644
--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -21,7 +21,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/of_i2c.h>
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 
@@ -439,8 +438,6 @@ static int wmt_i2c_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, i2c_dev);
 
-	of_i2c_register_devices(adap);
-
 	return 0;
 }
 
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 3d0f052..8823db7 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -40,7 +40,6 @@
 #include <linux/i2c-xiic.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include <linux/of_i2c.h>
 
 #define DRIVER_NAME "xiic-i2c"
 
@@ -752,8 +751,6 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 			i2c_new_device(&i2c->adap, pdata->devices + i);
 	}
 
-	of_i2c_register_devices(&i2c->adap);
-
 	return 0;
 
 add_adapter_failed:
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index f32ca29..08ebd78 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -23,7 +23,11 @@
    SMBus 2.0 support by Mark Studebaker <mdsxyz123@yahoo.com> and
    Jean Delvare <khali@linux-fr.org>
    Mux support by Rodolfo Giometti <giometti@enneenne.com> and
-   Michael Lawnick <michael.lawnick.ext@nsn.com> */
+   Michael Lawnick <michael.lawnick.ext@nsn.com>
+   OF support is copyright (c) 2008 Jochen Friedrich <jochen@scram.de>
+   (based on a previous patch from Jon Smirl <jonsmirl@gmail.com>) and
+   (c) 2013  Wolfram Sang <wsa@the-dreams.de>
+ */
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -35,7 +39,9 @@
 #include <linux/init.h>
 #include <linux/idr.h>
 #include <linux/mutex.h>
+#include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/completion.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
@@ -954,6 +960,104 @@ static void i2c_scan_static_board_info(struct i2c_adapter *adapter)
 	up_read(&__i2c_board_lock);
 }
 
+/* OF support code */
+
+#if IS_ENABLED(CONFIG_OF)
+static void of_i2c_register_devices(struct i2c_adapter *adap)
+{
+	void *result;
+	struct device_node *node;
+
+	/* Only register child devices if the adapter has a node pointer set */
+	if (!adap->dev.of_node)
+		return;
+
+	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
+
+	for_each_available_child_of_node(adap->dev.of_node, node) {
+		struct i2c_board_info info = {};
+		struct dev_archdata dev_ad = {};
+		const __be32 *addr;
+		int len;
+
+		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
+
+		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
+			dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
+				node->full_name);
+			continue;
+		}
+
+		addr = of_get_property(node, "reg", &len);
+		if (!addr || (len < sizeof(int))) {
+			dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
+				node->full_name);
+			continue;
+		}
+
+		info.addr = be32_to_cpup(addr);
+		if (info.addr > (1 << 10) - 1) {
+			dev_err(&adap->dev, "of_i2c: invalid addr=%x on %s\n",
+				info.addr, node->full_name);
+			continue;
+		}
+
+		info.irq = irq_of_parse_and_map(node, 0);
+		info.of_node = of_node_get(node);
+		info.archdata = &dev_ad;
+
+		if (of_get_property(node, "wakeup-source", NULL))
+			info.flags |= I2C_CLIENT_WAKE;
+
+		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
+
+		result = i2c_new_device(adap, &info);
+		if (result == NULL) {
+			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
+				node->full_name);
+			of_node_put(node);
+			irq_dispose_mapping(info.irq);
+			continue;
+		}
+	}
+}
+
+static int of_dev_node_match(struct device *dev, void *data)
+{
+	return dev->of_node == data;
+}
+
+/* must call put_device() when done with returned i2c_client device */
+struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
+{
+	struct device *dev;
+
+	dev = bus_find_device(&i2c_bus_type, NULL, node,
+					 of_dev_node_match);
+	if (!dev)
+		return NULL;
+
+	return i2c_verify_client(dev);
+}
+EXPORT_SYMBOL(of_find_i2c_device_by_node);
+
+/* must call put_device() when done with returned i2c_adapter device */
+struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
+{
+	struct device *dev;
+
+	dev = bus_find_device(&i2c_bus_type, NULL, node,
+					 of_dev_node_match);
+	if (!dev)
+		return NULL;
+
+	return i2c_verify_adapter(dev);
+}
+EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
+#else
+static void of_i2c_register_devices(struct i2c_adapter *adap) { }
+#endif /* CONFIG_OF */
+
 static int i2c_do_add_adapter(struct i2c_driver *driver,
 			      struct i2c_adapter *adap)
 {
@@ -1058,6 +1162,8 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
 
 exit_recovery:
 	/* create pre-declared device nodes */
+	of_i2c_register_devices(adap);
+
 	if (adap->nr < __i2c_first_dynamic_bus_num)
 		i2c_scan_static_board_info(adap);
 
@@ -1282,7 +1388,6 @@ void i2c_del_adapter(struct i2c_adapter *adap)
 }
 EXPORT_SYMBOL(i2c_del_adapter);
 
-
 /* ------------------------------------------------------------------------- */
 
 int i2c_for_each_dev(void *data, int (*fn)(struct device *, void *))
diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index 7409ebb..797e311 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -25,7 +25,6 @@
 #include <linux/i2c.h>
 #include <linux/i2c-mux.h>
 #include <linux/of.h>
-#include <linux/of_i2c.h>
 
 /* multiplexer per channel data */
 struct i2c_mux_priv {
@@ -185,8 +184,6 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
 	dev_info(&parent->dev, "Added multiplexed i2c bus %d\n",
 		 i2c_adapter_id(&priv->adap));
 
-	of_i2c_register_devices(&priv->adap);
-
 	return &priv->adap;
 }
 EXPORT_SYMBOL_GPL(i2c_add_mux_adapter);
diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
index 210b6f7..b901638 100644
--- a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
+++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
@@ -21,7 +21,6 @@
 #include <linux/i2c-mux.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/of_i2c.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 5a0ce00..128a981 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
-#include <linux/of_i2c.h>
 #include <linux/of_gpio.h>
 
 struct gpiomux {
diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
index a43c0ce..859a6d2 100644
--- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
@@ -20,7 +20,6 @@
 #include <linux/i2c-mux.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/of_i2c.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/i2c-mux-pinctrl.h>
 #include <linux/platform_device.h>
diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
index 617a798..9930556 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
@@ -12,7 +12,7 @@
 
 #include <linux/clk.h>
 #include <linux/module.h>
-#include <linux/of_i2c.h>
+#include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
@@ -67,8 +67,6 @@ static int fimc_is_i2c_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_enable(&i2c_adap->dev);
 
-	of_i2c_register_devices(i2c_adap);
-
 	return 0;
 }
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 967f6a9..2276fdc 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -21,7 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/of_i2c.h>
+#include <linux/i2c.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 19f556c..f8c66b4 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -20,7 +20,6 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
-#include <linux/of_i2c.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 80e5c13..78cc760 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -48,12 +48,6 @@ config OF_IRQ
 	def_bool y
 	depends on !SPARC
 
-config OF_I2C
-	def_tristate I2C
-	depends on I2C
-	help
-	  OpenFirmware I2C accessors
-
 config OF_NET
 	depends on NETDEVICES
 	def_bool y
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index 1f9c0c4..efd0510 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -3,7 +3,6 @@ obj-$(CONFIG_OF_FLATTREE) += fdt.o
 obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
-obj-$(CONFIG_OF_I2C)	+= of_i2c.o
 obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_SELFTEST) += selftest.o
 obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
deleted file mode 100644
index b667264..0000000
--- a/drivers/of/of_i2c.c
+++ /dev/null
@@ -1,114 +0,0 @@
-/*
- * OF helpers for the I2C API
- *
- * Copyright (c) 2008 Jochen Friedrich <jochen@scram.de>
- *
- * Based on a previous patch from Jon Smirl <jonsmirl@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/i2c.h>
-#include <linux/irq.h>
-#include <linux/of.h>
-#include <linux/of_i2c.h>
-#include <linux/of_irq.h>
-#include <linux/module.h>
-
-void of_i2c_register_devices(struct i2c_adapter *adap)
-{
-	void *result;
-	struct device_node *node;
-
-	/* Only register child devices if the adapter has a node pointer set */
-	if (!adap->dev.of_node)
-		return;
-
-	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
-
-	for_each_available_child_of_node(adap->dev.of_node, node) {
-		struct i2c_board_info info = {};
-		struct dev_archdata dev_ad = {};
-		const __be32 *addr;
-		int len;
-
-		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
-
-		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
-			dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
-				node->full_name);
-			continue;
-		}
-
-		addr = of_get_property(node, "reg", &len);
-		if (!addr || (len < sizeof(int))) {
-			dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
-				node->full_name);
-			continue;
-		}
-
-		info.addr = be32_to_cpup(addr);
-		if (info.addr > (1 << 10) - 1) {
-			dev_err(&adap->dev, "of_i2c: invalid addr=%x on %s\n",
-				info.addr, node->full_name);
-			continue;
-		}
-
-		info.irq = irq_of_parse_and_map(node, 0);
-		info.of_node = of_node_get(node);
-		info.archdata = &dev_ad;
-
-		if (of_get_property(node, "wakeup-source", NULL))
-			info.flags |= I2C_CLIENT_WAKE;
-
-		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
-
-		result = i2c_new_device(adap, &info);
-		if (result == NULL) {
-			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
-			        node->full_name);
-			of_node_put(node);
-			irq_dispose_mapping(info.irq);
-			continue;
-		}
-	}
-}
-EXPORT_SYMBOL(of_i2c_register_devices);
-
-static int of_dev_node_match(struct device *dev, void *data)
-{
-        return dev->of_node == data;
-}
-
-/* must call put_device() when done with returned i2c_client device */
-struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
-{
-	struct device *dev;
-
-	dev = bus_find_device(&i2c_bus_type, NULL, node,
-					 of_dev_node_match);
-	if (!dev)
-		return NULL;
-
-	return i2c_verify_client(dev);
-}
-EXPORT_SYMBOL(of_find_i2c_device_by_node);
-
-/* must call put_device() when done with returned i2c_adapter device */
-struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
-{
-	struct device *dev;
-
-	dev = bus_find_device(&i2c_bus_type, NULL, node,
-					 of_dev_node_match);
-	if (!dev)
-		return NULL;
-
-	return i2c_verify_adapter(dev);
-}
-EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index a56797d..2d76fd4 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -21,7 +21,7 @@
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/module.h>
-#include <linux/of_i2c.h>
+#include <linux/i2c.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/spinlock.h>
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index e988fa9..2189189 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -542,6 +542,26 @@ static inline int i2c_adapter_id(struct i2c_adapter *adap)
 
 #endif /* I2C */
 
+#if IS_ENABLED(CONFIG_OF)
+/* must call put_device() when done with returned i2c_client device */
+extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
+
+/* must call put_device() when done with returned i2c_adapter device */
+extern struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node);
+
+#else
+
+static inline struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
+{
+	return NULL;
+}
+
+static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
+{
+	return NULL;
+}
+#endif /* CONFIG_OF */
+
 #if IS_ENABLED(CONFIG_ACPI_I2C)
 extern void acpi_i2c_register_devices(struct i2c_adapter *adap);
 #else
diff --git a/include/linux/of_i2c.h b/include/linux/of_i2c.h
deleted file mode 100644
index cfb545c..0000000
--- a/include/linux/of_i2c.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * Generic I2C API implementation for PowerPC.
- *
- * Copyright (c) 2008 Jochen Friedrich <jochen@scram.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __LINUX_OF_I2C_H
-#define __LINUX_OF_I2C_H
-
-#if defined(CONFIG_OF_I2C) || defined(CONFIG_OF_I2C_MODULE)
-#include <linux/i2c.h>
-
-extern void of_i2c_register_devices(struct i2c_adapter *adap);
-
-/* must call put_device() when done with returned i2c_client device */
-extern struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
-
-/* must call put_device() when done with returned i2c_adapter device */
-extern struct i2c_adapter *of_find_i2c_adapter_by_node(
-						struct device_node *node);
-
-#else
-static inline void of_i2c_register_devices(struct i2c_adapter *adap)
-{
-	return;
-}
-
-static inline struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
-{
-	return NULL;
-}
-
-/* must call put_device() when done with returned i2c_adapter device */
-static inline struct i2c_adapter *of_find_i2c_adapter_by_node(
-						struct device_node *node)
-{
-	return NULL;
-}
-#endif /* CONFIG_OF_I2C */
-
-#endif /* __LINUX_OF_I2C_H */
diff --git a/sound/soc/fsl/imx-sgtl5000.c b/sound/soc/fsl/imx-sgtl5000.c
index 3f726e4..f2fbde9 100644
--- a/sound/soc/fsl/imx-sgtl5000.c
+++ b/sound/soc/fsl/imx-sgtl5000.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
-#include <linux/of_i2c.h>
+#include <linux/i2c.h>
 #include <linux/clk.h>
 #include <sound/soc.h>
 
diff --git a/sound/soc/fsl/imx-wm8962.c b/sound/soc/fsl/imx-wm8962.c
index 52a36a9..9fd7a65 100644
--- a/sound/soc/fsl/imx-wm8962.c
+++ b/sound/soc/fsl/imx-wm8962.c
@@ -15,7 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/of_platform.h>
-#include <linux/of_i2c.h>
+#include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
 #include <sound/soc.h>
-- 
1.7.10.4

