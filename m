Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61924 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750927AbeDTTD3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 15:03:29 -0400
Date: Fri, 20 Apr 2018 16:03:21 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fbdev@vger.kernel.org
Subject: [PATCH v2 7/7] media: via-camera: allow build on non-x86 archs with
 COMPILE_TEST
Message-ID: <20180420160321.4ecefa00@vento.lan>
In-Reply-To: <396bfb33e763c31ead093ac1035b2ecf7311b5bc.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com>
        <396bfb33e763c31ead093ac1035b2ecf7311b5bc.1524245455.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver depends on FB_VIA for lots of things. Provide stubs
for the functions it needs, in order to allow building it with
COMPILE_TEST outside x86 architecture.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index e3229f7baed1..abaaed98a044 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -15,7 +15,7 @@ source "drivers/media/platform/marvell-ccic/Kconfig"
 
 config VIDEO_VIA_CAMERA
 	tristate "VIAFB camera controller support"
-	depends on FB_VIA
+	depends on FB_VIA || COMPILE_TEST
 	select VIDEOBUF_DMA_SG
 	select VIDEO_OV7670
 	help
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index e9a02639554b..4ab1695b33af 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -27,7 +27,10 @@
 #include <linux/via-core.h>
 #include <linux/via-gpio.h>
 #include <linux/via_i2c.h>
+
+#ifdef CONFIG_FB_VIA
 #include <asm/olpc.h>
+#endif
 
 #include "via-camera.h"
 
@@ -1283,6 +1286,11 @@ static bool viacam_serial_is_enabled(void)
 	struct pci_bus *pbus = pci_find_bus(0, 0);
 	u8 cbyte;
 
+#ifdef CONFIG_FB_VIA
+	if (!machine_is_olpc())
+		return false;
+#endif
+
 	if (!pbus)
 		return false;
 	pci_bus_read_config_byte(pbus, VIACAM_SERIAL_DEVFN,
@@ -1343,7 +1351,7 @@ static int viacam_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	if (machine_is_olpc() && viacam_serial_is_enabled())
+	if (viacam_serial_is_enabled())
 		return -EBUSY;
 
 	/*
diff --git a/include/linux/via-core.h b/include/linux/via-core.h
index 9c21cdf3e3b3..ced4419baef8 100644
--- a/include/linux/via-core.h
+++ b/include/linux/via-core.h
@@ -70,8 +70,12 @@ struct viafb_pm_hooks {
 	void *private;
 };
 
+#ifdef CONFIG_FB_VIA
 void viafb_pm_register(struct viafb_pm_hooks *hooks);
 void viafb_pm_unregister(struct viafb_pm_hooks *hooks);
+#else
+static inline void viafb_pm_register(struct viafb_pm_hooks *hooks) {}
+#endif /* CONFIG_FB_VIA */
 #endif /* CONFIG_PM */
 
 /*
@@ -113,8 +117,13 @@ struct viafb_dev {
  * Interrupt management.
  */
 
+#ifdef CONFIG_FB_VIA
 void viafb_irq_enable(u32 mask);
 void viafb_irq_disable(u32 mask);
+#else
+static inline void viafb_irq_enable(u32 mask) {}
+static inline void viafb_irq_disable(u32 mask) {}
+#endif
 
 /*
  * The global interrupt control register and its bits.
@@ -157,10 +166,18 @@ void viafb_irq_disable(u32 mask);
 /*
  * DMA management.
  */
+#ifdef CONFIG_FB_VIA
 int viafb_request_dma(void);
 void viafb_release_dma(void);
 /* void viafb_dma_copy_out(unsigned int offset, dma_addr_t paddr, int len); */
 int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg);
+#else
+static inline int viafb_request_dma(void) { return 0; }
+static inline void viafb_release_dma(void) {}
+static inline int viafb_dma_copy_out_sg(unsigned int offset,
+					struct scatterlist *sg, int nsg)
+{ return 0; }
+#endif
 
 /*
  * DMA Controller registers.
diff --git a/include/linux/via-gpio.h b/include/linux/via-gpio.h
index 8281aea3dd6d..b5a96cf7a874 100644
--- a/include/linux/via-gpio.h
+++ b/include/linux/via-gpio.h
@@ -8,7 +8,11 @@
 #ifndef __VIA_GPIO_H__
 #define __VIA_GPIO_H__
 
+#ifdef CONFIG_FB_VIA
 extern int viafb_gpio_lookup(const char *name);
 extern int viafb_gpio_init(void);
 extern void viafb_gpio_exit(void);
+#else
+static inline int viafb_gpio_lookup(const char *name) { return 0; }
+#endif
 #endif
diff --git a/include/linux/via_i2c.h b/include/linux/via_i2c.h
index 44532e468c05..209bff950e22 100644
--- a/include/linux/via_i2c.h
+++ b/include/linux/via_i2c.h
@@ -32,6 +32,7 @@ struct via_i2c_stuff {
 };
 
 
+#ifdef CONFIG_FB_VIA
 int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata);
 int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data);
 int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len);
@@ -39,4 +40,9 @@ struct i2c_adapter *viafb_find_i2c_adapter(enum viafb_i2c_adap which);
 
 extern int viafb_i2c_init(void);
 extern void viafb_i2c_exit(void);
+#else
+static inline
+struct i2c_adapter *viafb_find_i2c_adapter(enum viafb_i2c_adap which)
+{ return NULL; }
+#endif
 #endif /* __VIA_I2C_H__ */
