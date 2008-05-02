Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42GBkEJ010953
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 12:11:46 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42GBUVD020847
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 12:11:31 -0400
Message-ID: <481B3D2F.80203@hni.uni-paderborn.de>
Date: Fri, 02 May 2008 18:11:27 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <48030F6F.1040007@hni.uni-paderborn.de>	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>	<480477BD.5090900@hni.uni-paderborn.de>	<Pine.LNX.4.64.0804151228370.5159@axis700.grange>	<481ADED1.8050201@hni.uni-paderborn.de>	<Pine.LNX.4.64.0805021143250.4920@axis700.grange>	<481AF6CA.9030505@hni.uni-paderborn.de>	<Pine.LNX.4.64.0805021314510.4920@axis700.grange>
	<481AFB30.5070508@hni.uni-paderborn.de>
In-Reply-To: <481AFB30.5070508@hni.uni-paderborn.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH] Some suggestions for the soc_camera interface
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

some of my soc_camera suggestions as Patch:
+ Moving power and reset function into soc_camera_link
+ Rename SOCAM_HSYNC_* to SOCAM_HREF_* and introduce new
    SOCAM_HSYNC_*
+ Add x_skip_left to soc_camera_device and to pxa_camera driver
+ Change defrect.width and height to icd->width_max in soc_camera_cropcap

diff -r dd4685496fb7 linux/drivers/media/video/mt9m001.c
--- a/linux/drivers/media/video/mt9m001.c    Fri May 02 01:48:36 2008 -0300
+++ b/linux/drivers/media/video/mt9m001.c    Fri May 02 16:34:37 2008 +0200
@@ -120,7 +120,19 @@ static int reg_clear(struct soc_camera_d
 
 static int mt9m001_init(struct soc_camera_device *icd)
 {
-    int ret;
+    struct soc_camera_link *icl = icd->client->dev.platform_data;
+    int ret;
+
+    if (icl && icl->power) {
+        dev_dbg(icd->dev, "%s: Power on camera\n", __func__);
+        icl->power(icd->dev, 1);
+    }
+
+    if (icl && icd->reset) {
+        dev_dbg(icd->dev, "%s: Releasing camera reset\n",
+            __func__);
+        icl->reset(icd->dev, 1);
+    }
 
     /* Disable chip, synchronous option update */
     dev_dbg(icd->vdev->dev, "%s\n", __func__);
@@ -136,8 +148,22 @@ static int mt9m001_init(struct soc_camer
 
 static int mt9m001_release(struct soc_camera_device *icd)
 {
+    struct soc_camera_link *icl = icd->client->dev.platform_data;
+
     /* Disable the chip */
     reg_write(icd, MT9M001_OUTPUT_CONTROL, 0);
+
+    if (icl && icl->reset) {
+        dev_dbg(icd->dev, "%s: Asserting camera reset\n",
+            __func__);
+        icl->reset(icd->dev, 0);
+    }
+
+    if (icl && icl->power) {
+        dev_dbg(icd->dev, "%s: Power off camera\n", __func__);
+        icl->power(icd->dev, 0);
+    }
+
     return 0;
 }
 
@@ -255,8 +281,8 @@ static unsigned long mt9m001_query_bus_p
 
     /* MT9M001 has all capture_format parameters fixed */
     return SOCAM_PCLK_SAMPLE_RISING |
-        SOCAM_HSYNC_ACTIVE_HIGH |
-        SOCAM_VSYNC_ACTIVE_HIGH |
+        SOCAM_HREF_ACTIVE_HIGH |
+        SOCAM_VREF_ACTIVE_HIGH |
         SOCAM_MASTER |
         width_flag;
 }
@@ -659,6 +685,7 @@ static int mt9m001_probe(struct i2c_clie
     icd->width_max    = 1280;
     icd->height_min    = 32;
     icd->height_max    = 1024;
+    icd->x_skip_left = 0;
     icd->y_skip_top    = 1;
     icd->iface    = icl->bus_id;
     /* Default datawidth - this is the only width this camera (normally)
diff -r dd4685496fb7 linux/drivers/media/video/mt9v022.c
--- a/linux/drivers/media/video/mt9v022.c    Fri May 02 01:48:36 2008 -0300
+++ b/linux/drivers/media/video/mt9v022.c    Fri May 02 16:39:49 2008 +0200
@@ -137,7 +137,19 @@ static int mt9v022_init(struct soc_camer
 static int mt9v022_init(struct soc_camera_device *icd)
 {
     struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+    struct soc_camera_link *icl = icd->client->dev.platform_data;
     int ret;
+
+    if (icl && icl->power) {
+        dev_dbg(icd->dev, "%s: Power on camera\n", __func__);
+        icl->power(icd->dev, 1);
+    }
+
+    if (icl && icd->reset) {
+        dev_dbg(icd->dev, "%s: Releasing camera reset\n",
+            __func__);
+        icl->reset(icd->dev, 1);
+    }
 
     /* Almost the default mode: master, parallel, simultaneous, and an
      * undocumented bit 0x200, which is present in table 7, but not in 8,
@@ -164,7 +176,21 @@ static int mt9v022_init(struct soc_camer
 
 static int mt9v022_release(struct soc_camera_device *icd)
 {
+    struct soc_camera_link *icl = icd->client->dev.platform_data;
+
     /* Nothing? */
+
+    if (icl && icl->reset) {
+        dev_dbg(icd->dev, "%s: Asserting camera reset\n",
+            __func__);
+        icl->reset(icd->dev, 0);
+    }
+
+    if (icl && icl->power) {
+        dev_dbg(icd->dev, "%s: Power off camera\n", __func__);
+        icl->power(icd->dev, 0);
+    }
+
     return 0;
 }
 
@@ -280,7 +306,7 @@ static int mt9v022_set_bus_param(struct
     if (flags & SOCAM_PCLK_SAMPLE_RISING)
         pixclk |= 0x10;
 
-    if (!(flags & SOCAM_HSYNC_ACTIVE_HIGH))
+    if (!(flags & SOCAM_HREF_ACTIVE_HIGH))
         pixclk |= 0x1;
 
     if (!(flags & SOCAM_VSYNC_ACTIVE_HIGH))
@@ -312,7 +338,7 @@ static unsigned long mt9v022_query_bus_p
         width_flag |= SOCAM_DATAWIDTH_8;
 
     return SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
-        SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW |
+        SOCAM_HREF_ACTIVE_HIGH | SOCAM_HREF_ACTIVE_LOW |
         SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW |
         SOCAM_MASTER | SOCAM_SLAVE |
         width_flag;
@@ -784,6 +810,7 @@ static int mt9v022_probe(struct i2c_clie
     icd->width_max    = 752;
     icd->height_min    = 32;
     icd->height_max    = 480;
+    icd->x_skip_left = 0;
     icd->y_skip_top    = 1;
     icd->iface    = icl->bus_id;
     /* Default datawidth - this is the only width this camera (normally)
diff -r dd4685496fb7 linux/drivers/media/video/pxa_camera.c
--- a/linux/drivers/media/video/pxa_camera.c    Fri May 02 01:48:36 2008 
-0300
+++ b/linux/drivers/media/video/pxa_camera.c    Fri May 02 16:16:36 2008 
+0200
@@ -613,17 +613,6 @@ static void pxa_camera_activate(struct p
         pdata->init(pcdev->dev);
     }
 
-    if (pdata && pdata->power) {
-        dev_dbg(pcdev->dev, "%s: Power on camera\n", __func__);
-        pdata->power(pcdev->dev, 1);
-    }
-
-    if (pdata && pdata->reset) {
-        dev_dbg(pcdev->dev, "%s: Releasing camera reset\n",
-            __func__);
-        pdata->reset(pcdev->dev, 1);
-    }
-
     CICR0 = 0x3FF;   /* disable all interrupts */
 
     if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
@@ -644,20 +633,7 @@ static void pxa_camera_activate(struct p
 
 static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
 {
-    struct pxacamera_platform_data *board = pcdev->pdata;
-
     clk_disable(pcdev->clk);
-
-    if (board && board->reset) {
-        dev_dbg(pcdev->dev, "%s: Asserting camera reset\n",
-            __func__);
-        board->reset(pcdev->dev, 0);
-    }
-
-    if (board && board->power) {
-        dev_dbg(pcdev->dev, "%s: Power off camera\n", __func__);
-        board->power(pcdev->dev, 0);
-    }
 }
 
 static irqreturn_t pxa_camera_irq(int irq, void *data)
@@ -752,6 +728,8 @@ static int test_platform_param(struct px
           SOCAM_MASTER : SOCAM_SLAVE) |
         SOCAM_HSYNC_ACTIVE_HIGH |
         SOCAM_HSYNC_ACTIVE_LOW |
+        SOCAM_HREF_ACTIVE_HIGH |
+        SOCAM_HREF_ACTIVE_LOW |
         SOCAM_VSYNC_ACTIVE_HIGH |
         SOCAM_VSYNC_ACTIVE_LOW |
         SOCAM_PCLK_SAMPLE_RISING |
@@ -799,12 +777,24 @@ static int pxa_camera_set_bus_param(stru
     pcdev->channels = 1;
 
     /* Make choises, based on platform preferences */
+    if ((common_flags & SOCAM_HREF_ACTIVE_HIGH) &&
+        (common_flags & SOCAM_HREF_ACTIVE_LOW)) {
+        if (pcdev->platform_flags & PXA_CAMERA_HSP)
+            common_flags &= ~SOCAM_HREF_ACTIVE_HIGH;
+        else
+            common_flags &= ~SOCAM_HREF_ACTIVE_LOW;
+        common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH &&
+                ~SOCAM_HSYNC_ACTIVE_LOW;
+    }
+
     if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
         (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
         if (pcdev->platform_flags & PXA_CAMERA_HSP)
             common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
         else
             common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
+        common_flags &= ~SOCAM_HREF_ACTIVE_HIGH &&
+                ~SOCAM_HREF_ACTIVE_LOW;
     }
 
     if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
@@ -855,7 +845,8 @@ static int pxa_camera_set_bus_param(stru
         cicr4 |= CICR4_MCLK_EN;
     if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
         cicr4 |= CICR4_PCP;
-    if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
+    if ((common_flags & SOCAM_HSYNC_ACTIVE_LOW) ||
+        (common_flags & SOCAM_HREF_ACTIVE_LOW))
         cicr4 |= CICR4_HSP;
     if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
         cicr4 |= CICR4_VSP;
@@ -883,7 +874,7 @@ static int pxa_camera_set_bus_param(stru
     }
 
     CICR1 = cicr1;
-    CICR2 = 0;
+    CICR2 = CICR2_BLW_VAL(min((unsigned short)255, icd->x_skip_left));
     CICR3 = CICR3_LPF_VAL(icd->height - 1) |
         CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
     CICR4 = mclk_get_divisor(pcdev) | cicr4;
diff -r dd4685496fb7 linux/drivers/media/video/soc_camera.c
--- a/linux/drivers/media/video/soc_camera.c    Fri May 02 01:48:36 2008 
-0300
+++ b/linux/drivers/media/video/soc_camera.c    Mon Apr 28 18:34:49 2008 
+0200
@@ -558,8 +558,8 @@ static int soc_camera_cropcap(struct fil
     a->bounds.height        = icd->height_max;
     a->defrect.left            = icd->x_min;
     a->defrect.top            = icd->y_min;
-    a->defrect.width        = 640;
-    a->defrect.height        = 480;
+    a->defrect.width        = icd->width_max;
+    a->defrect.height        = icd->height_max;
     a->pixelaspect.numerator    = 1;
     a->pixelaspect.denominator    = 1;
 
diff -r dd4685496fb7 linux/include/asm-arm/arch-pxa/camera.h
--- a/linux/include/asm-arm/arch-pxa/camera.h    Fri May 02 01:48:36 
2008 -0300
+++ b/linux/include/asm-arm/arch-pxa/camera.h    Fri May 02 15:53:10 
2008 +0200
@@ -36,8 +36,6 @@
 
 struct pxacamera_platform_data {
     int (*init)(struct device *);
-    int (*power)(struct device *, int);
-    int (*reset)(struct device *, int);
 
     unsigned long flags;
     unsigned long mclk_10khz;
diff -r dd4685496fb7 linux/include/media/soc_camera.h
--- a/linux/include/media/soc_camera.h    Fri May 02 01:48:36 2008 -0300
+++ b/linux/include/media/soc_camera.h    Fri May 02 15:57:06 2008 +0200
@@ -29,6 +29,7 @@ struct soc_camera_device {
     unsigned short width_max;
     unsigned short height_min;
     unsigned short height_max;
+    unsigned short x_skip_left;    /* Pixel to skip at the left */
     unsigned short y_skip_top;    /* Lines to skip at the top */
     unsigned short gain;
     unsigned short exposure;
@@ -79,6 +80,9 @@ struct soc_camera_host_ops {
 };
 
 struct soc_camera_link {
+    int (*power)(struct device *, int);
+    int (*reset)(struct device *, int);
+
     /* Camera bus id, used to match a camera and a bus */
     int bus_id;
     /* GPIO number to switch between 8 and 10 bit modes */
@@ -149,8 +153,8 @@ static inline struct v4l2_queryctrl cons
 
 #define SOCAM_MASTER            (1 << 0)
 #define SOCAM_SLAVE            (1 << 1)
-#define SOCAM_HSYNC_ACTIVE_HIGH        (1 << 2)
-#define SOCAM_HSYNC_ACTIVE_LOW        (1 << 3)
+#define SOCAM_HREF_ACTIVE_HIGH        (1 << 2)
+#define SOCAM_HREF_ACTIVE_LOW        (1 << 3)
 #define SOCAM_VSYNC_ACTIVE_HIGH        (1 << 4)
 #define SOCAM_VSYNC_ACTIVE_LOW        (1 << 5)
 #define SOCAM_DATAWIDTH_8        (1 << 6)
@@ -158,6 +162,8 @@ static inline struct v4l2_queryctrl cons
 #define SOCAM_DATAWIDTH_10        (1 << 8)
 #define SOCAM_PCLK_SAMPLE_RISING    (1 << 9)
 #define SOCAM_PCLK_SAMPLE_FALLING    (1 << 10)
+#define SOCAM_HSYNC_ACTIVE_HIGH        (1 << 11)
+#define SOCAM_HSYNC_ACTIVE_LOW        (1 << 12)
 
 #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_9 | \
                   SOCAM_DATAWIDTH_10)
@@ -165,15 +171,16 @@ static inline unsigned long soc_camera_b
 static inline unsigned long soc_camera_bus_param_compatible(
             unsigned long camera_flags, unsigned long bus_flags)
 {
-    unsigned long common_flags, hsync, vsync, pclk;
+    unsigned long common_flags, hsync, href, vsync, pclk;
 
     common_flags = camera_flags & bus_flags;
 
     hsync = common_flags & (SOCAM_HSYNC_ACTIVE_HIGH | 
SOCAM_HSYNC_ACTIVE_LOW);
+    href = common_flags & (SOCAM_HREF_ACTIVE_HIGH | SOCAM_HREF_ACTIVE_LOW);
     vsync = common_flags & (SOCAM_VSYNC_ACTIVE_HIGH | 
SOCAM_VSYNC_ACTIVE_LOW);
     pclk = common_flags & (SOCAM_PCLK_SAMPLE_RISING | 
SOCAM_PCLK_SAMPLE_FALLING);
 
-    return (!hsync || !vsync || !pclk) ? 0 : common_flags;
+    return ((!hsync && !href) || !vsync || !pclk) ? 0 : common_flags;
 }
 
 #endif

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
