Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:43035 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758411Ab1FFWks (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 18:40:48 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5/7] marvell-cam: Move Cafe-specific register definitions to cafe-driver.c
Date: Mon,  6 Jun 2011 16:40:01 -0600
Message-Id: <1307400003-94758-6-git-send-email-corbet@lwn.net>
In-Reply-To: <1307400003-94758-1-git-send-email-corbet@lwn.net>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Nobody else ever needs to see these, so let's hide them.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/cafe-driver.c |   63 ++++++++++++++++++++++++
 drivers/media/video/marvell-ccic/mcam-core.h   |   56 +---------------------
 2 files changed, 64 insertions(+), 55 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/cafe-driver.c b/drivers/media/video/marvell-ccic/cafe-driver.c
index 78b4077..ec9257e 100644
--- a/drivers/media/video/marvell-ccic/cafe-driver.c
+++ b/drivers/media/video/marvell-ccic/cafe-driver.c
@@ -56,6 +56,69 @@ struct cafe_camera {
 };
 
 /*
+ * Most of the camera controller registers are defined in mcam-core.h,
+ * but the Cafe platform has some additional registers of its own;
+ * they are described here.
+ */
+
+/*
+ * "General purpose register" has a couple of GPIOs used for sensor
+ * power and reset on OLPC XO 1.0 systems.
+ */
+#define REG_GPR		0xb4
+#define	  GPR_C1EN	  0x00000020	/* Pad 1 (power down) enable */
+#define	  GPR_C0EN	  0x00000010	/* Pad 0 (reset) enable */
+#define	  GPR_C1	  0x00000002	/* Control 1 value */
+/*
+ * Control 0 is wired to reset on OLPC machines.  For ov7x sensors,
+ * it is active low.
+ */
+#define	  GPR_C0	  0x00000001	/* Control 0 value */
+
+/*
+ * These registers control the SMBUS module for communicating
+ * with the sensor.
+ */
+#define REG_TWSIC0	0xb8	/* TWSI (smbus) control 0 */
+#define	  TWSIC0_EN	  0x00000001	/* TWSI enable */
+#define	  TWSIC0_MODE	  0x00000002	/* 1 = 16-bit, 0 = 8-bit */
+#define	  TWSIC0_SID	  0x000003fc	/* Slave ID */
+#define	  TWSIC0_SID_SHIFT 2
+#define	  TWSIC0_CLKDIV	  0x0007fc00	/* Clock divider */
+#define	  TWSIC0_MASKACK  0x00400000	/* Mask ack from sensor */
+#define	  TWSIC0_OVMAGIC  0x00800000	/* Make it work on OV sensors */
+
+#define REG_TWSIC1	0xbc	/* TWSI control 1 */
+#define	  TWSIC1_DATA	  0x0000ffff	/* Data to/from camchip */
+#define	  TWSIC1_ADDR	  0x00ff0000	/* Address (register) */
+#define	  TWSIC1_ADDR_SHIFT 16
+#define	  TWSIC1_READ	  0x01000000	/* Set for read op */
+#define	  TWSIC1_WSTAT	  0x02000000	/* Write status */
+#define	  TWSIC1_RVALID	  0x04000000	/* Read data valid */
+#define	  TWSIC1_ERROR	  0x08000000	/* Something screwed up */
+
+/*
+ * Here's the weird global control registers
+ */
+#define REG_GL_CSR     0x3004  /* Control/status register */
+#define	  GCSR_SRS	 0x00000001	/* SW Reset set */
+#define	  GCSR_SRC	 0x00000002	/* SW Reset clear */
+#define	  GCSR_MRS	 0x00000004	/* Master reset set */
+#define	  GCSR_MRC	 0x00000008	/* HW Reset clear */
+#define	  GCSR_CCIC_EN	 0x00004000    /* CCIC Clock enable */
+#define REG_GL_IMASK   0x300c  /* Interrupt mask register */
+#define	  GIMSK_CCIC_EN		 0x00000004    /* CCIC Interrupt enable */
+
+#define REG_GL_FCR	0x3038	/* GPIO functional control register */
+#define	  GFCR_GPIO_ON	  0x08		/* Camera GPIO enabled */
+#define REG_GL_GPIOR	0x315c	/* GPIO register */
+#define	  GGPIO_OUT		0x80000	/* GPIO output */
+#define	  GGPIO_VAL		0x00008	/* Output pin value */
+
+#define REG_LEN		       (REG_GL_IMASK + 4)
+
+
+/*
  * Debugging and related.
  */
 #define cam_err(cam, fmt, arg...) \
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index 84dc762..f1f481e 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -256,64 +256,10 @@ int mccic_resume(struct mcam_camera *cam);
 #define REG_CLKCTRL	0x88	/* Clock control */
 #define	  CLK_DIV_MASK	  0x0000ffff	/* Upper bits RW "reserved" */
 
-#define REG_GPR		0xb4	/* General purpose register.  This
-				   controls inputs to the power and reset
-				   pins on the OV7670 used with OLPC;
-				   other deployments could differ.  */
-#define	  GPR_C1EN	  0x00000020	/* Pad 1 (power down) enable */
-#define	  GPR_C0EN	  0x00000010	/* Pad 0 (reset) enable */
-#define	  GPR_C1	  0x00000002	/* Control 1 value */
-/*
- * Control 0 is wired to reset on OLPC machines.  For ov7x sensors,
- * it is active low, for 0v6x, instead, it's active high.  What
- * fun.
- */
-#define	  GPR_C0	  0x00000001	/* Control 0 value */
-
-#define REG_TWSIC0	0xb8	/* TWSI (smbus) control 0 */
-#define	  TWSIC0_EN	  0x00000001	/* TWSI enable */
-#define	  TWSIC0_MODE	  0x00000002	/* 1 = 16-bit, 0 = 8-bit */
-#define	  TWSIC0_SID	  0x000003fc	/* Slave ID */
-#define	  TWSIC0_SID_SHIFT 2
-#define	  TWSIC0_CLKDIV	  0x0007fc00	/* Clock divider */
-#define	  TWSIC0_MASKACK  0x00400000	/* Mask ack from sensor */
-#define	  TWSIC0_OVMAGIC  0x00800000	/* Make it work on OV sensors */
-
-#define REG_TWSIC1	0xbc	/* TWSI control 1 */
-#define	  TWSIC1_DATA	  0x0000ffff	/* Data to/from camchip */
-#define	  TWSIC1_ADDR	  0x00ff0000	/* Address (register) */
-#define	  TWSIC1_ADDR_SHIFT 16
-#define	  TWSIC1_READ	  0x01000000	/* Set for read op */
-#define	  TWSIC1_WSTAT	  0x02000000	/* Write status */
-#define	  TWSIC1_RVALID	  0x04000000	/* Read data valid */
-#define	  TWSIC1_ERROR	  0x08000000	/* Something screwed up */
-
-
+/* This appears to be a Cafe-only register */
 #define REG_UBAR	0xc4	/* Upper base address register */
 
 /*
- * Here's the weird global control registers which are said to live
- * way up here.
- */
-#define REG_GL_CSR     0x3004  /* Control/status register */
-#define	  GCSR_SRS	 0x00000001	/* SW Reset set */
-#define	  GCSR_SRC	 0x00000002	/* SW Reset clear */
-#define	  GCSR_MRS	 0x00000004	/* Master reset set */
-#define	  GCSR_MRC	 0x00000008	/* HW Reset clear */
-#define	  GCSR_CCIC_EN	 0x00004000    /* CCIC Clock enable */
-#define REG_GL_IMASK   0x300c  /* Interrupt mask register */
-#define	  GIMSK_CCIC_EN		 0x00000004    /* CCIC Interrupt enable */
-
-#define REG_GL_FCR	0x3038	/* GPIO functional control register */
-#define	  GFCR_GPIO_ON	  0x08		/* Camera GPIO enabled */
-#define REG_GL_GPIOR	0x315c	/* GPIO register */
-#define	  GGPIO_OUT		0x80000	/* GPIO output */
-#define	  GGPIO_VAL		0x00008	/* Output pin value */
-
-#define REG_LEN		       (REG_GL_IMASK + 4)
-
-
-/*
  * Useful stuff that probably belongs somewhere global.
  */
 #define VGA_WIDTH	640
-- 
1.7.5.2

