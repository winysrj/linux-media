Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42JrciF026913
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 15:53:38 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m42JrQVI001529
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 15:53:26 -0400
Date: Fri, 2 May 2008 21:53:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <481B3D2F.80203@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0805022059090.31894@axis700.grange>
References: <48030F6F.1040007@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804142224570.5332@axis700.grange>
	<480477BD.5090900@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0804151228370.5159@axis700.grange>
	<481ADED1.8050201@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021143250.4920@axis700.grange>
	<481AF6CA.9030505@hni.uni-paderborn.de>
	<Pine.LNX.4.64.0805021314510.4920@axis700.grange>
	<481AFB30.5070508@hni.uni-paderborn.de>
	<481B3D2F.80203@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Some suggestions for the soc_camera interface
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

Hi, and thanks for the patch.

Now, the first thing you want to do is read 
Documentation/SubmittingPatches in your Linux kernel tree. Having read 
that, you should realise, that this your patch should in fact be 4 
separate patches, that you must not replace TABs with spaces, and that 
added code should be formattet exactly like the rest - according to 
Documentation/CodingStyle. I am not sure how you created those diffs, 
but, I think, your mailer further corrupted your patch - it removed 
leading spaces from unmodified, including empty lines. This too makes 
patches unusable. To verify your patch-mail machinery is working 
correctly, you can create patches, then revert them, preserving backups 
per

patch -b -p1 -R < my.patch

mail the patch to yourself, extract it from the mail, apply it again per

patch -p1 < my-received.patch

(this time without backup) and compare with backuped versions. After this 
worked you may be somewhat sure your patches will arrive to the recepients 
undamaged. And, of course, you should compile- and run-test your patches, 
which you haven't done either.

Now, I split your patch into 4 pices to make commenting easier, and this 
is also how you should submit them after fixing all problems, but in 
separate emails, and adding Signed-off-by lines:

****************************************************************************
Patch 1
****************************************************************************


On Fri, 2 May 2008, Stefan Herbrechtsmeier wrote:

> Hi,
> 
> some of my soc_camera suggestions as Patch:

+ Moving power and reset function into soc_camera_link

---

diff -r dd4685496fb7 linux/drivers/media/video/mt9m001.c
--- a/linux/drivers/media/video/mt9m001.c    Fri May 02 01:48:36 2008 -0300
+++ b/linux/drivers/media/video/mt9m001.c    Fri May 02 16:34:37 2008 +0200
@@ -120,0 +120,0 @@ static int reg_clear(struct soc_camera_d

static int mt9m001_init(struct soc_camera_device *icd)

^--- Here you see how the leading space has been dropped.
****************************************************************************

{
-    int ret;

 ^--- Even in original code you replaced TABs with spaces...
****************************************************************************

+    struct soc_camera_link *icl = icd->client->dev.platform_data;
+    int ret;
+
+    if (icl && icl->power) {

         ^--- icl is guaranteed to be non-NULL in both mt9m001 and mt9v022
****************************************************************************

+        dev_dbg(icd->dev, "%s: Power on camera\n", __func__);
+        icl->power(icd->dev, 1);
+    }
+
+    if (icl && icd->reset) {

                ^--- Haven't compile-tested
****************************************************************************

+        dev_dbg(icd->dev, "%s: Releasing camera reset\n",
+            __func__);
+        icl->reset(icd->dev, 1);
+    }

    /* Disable chip, synchronous option update */
    dev_dbg(icd->vdev->dev, "%s\n", __func__);
@@ -136,0 +148,0 @@ static int mt9m001_init(struct soc_camer

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

I know the original code does this too, but I don't understand why you 
have to reset a camera when releasing it...
****************************************************************************

+    }
+
+    if (icl && icl->power) {
+        dev_dbg(icd->dev, "%s: Power off camera\n", __func__);
+        icl->power(icd->dev, 0);
+    }
+
    return 0;
}

diff -r dd4685496fb7 linux/drivers/media/video/mt9v022.c
--- a/linux/drivers/media/video/mt9v022.c    Fri May 02 01:48:36 2008 -0300
+++ b/linux/drivers/media/video/mt9v022.c    Fri May 02 16:39:49 2008 +0200
@@ -137,0 +137,0 @@ static int mt9v022_init(struct soc_camer
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
@@ -164,0 +176,0 @@ static int mt9v022_init(struct soc_camer

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

diff -r dd4685496fb7 linux/drivers/media/video/pxa_camera.c
--- a/linux/drivers/media/video/pxa_camera.c    Fri May 02 01:48:36 2008 -0300
+++ b/linux/drivers/media/video/pxa_camera.c    Fri May 02 16:16:36 2008 +0200
@@ -613,2 +613,2 @@ static void pxa_camera_activate(struct p
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
@@ -644,0 +633,0 @@ static void pxa_camera_activate(struct p

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
diff -r dd4685496fb7 linux/include/asm-arm/arch-pxa/camera.h
--- a/linux/include/asm-arm/arch-pxa/camera.h    Fri May 02 01:48:36 2008 -0300
+++ b/linux/include/asm-arm/arch-pxa/camera.h    Fri May 02 15:53:10 2008 +0200
@@ -36,0 +36,0 @@

struct pxacamera_platform_data {
    int (*init)(struct device *);
-    int (*power)(struct device *, int);
-    int (*reset)(struct device *, int);

    unsigned long flags;
    unsigned long mclk_10khz;
diff -r dd4685496fb7 linux/include/media/soc_camera.h
--- a/linux/include/media/soc_camera.h    Fri May 02 01:48:36 2008 -0300
+++ b/linux/include/media/soc_camera.h    Fri May 02 15:57:06 2008 +0200
@@ -79,0 +80,0 @@ struct soc_camera_host_ops {
};

struct soc_camera_link {
+    int (*power)(struct device *, int);
+    int (*reset)(struct device *, int);
+
    /* Camera bus id, used to match a camera and a bus */
    int bus_id;
    /* GPIO number to switch between 8 and 10 bit modes */

****************************************************************************
Patch 2
****************************************************************************

+ Rename SOCAM_HSYNC_* to SOCAM_HREF_* and introduce new
   SOCAM_HSYNC_*

This is what you've written in your earlier email:

> > 1. Renaming SOCAM_HSYNC_* to SOCAM_HREF_*
> > I think the current used Signal is HREF and not HSYNC.
> > - HREF is active during valid pixels
> > - HSYNC is a impulse at the start of each line before valid pixels and need
> > some pixel skipping.

and the signal used on PXA270 _is_ HSYNC - also according to your 
definition, it's only that wait counts have been set to 0, so, the signal 
has become equivalent to HREF. And now that you support wait count != 0, 
it _is_ becoming HSYNC and not HREF. Further, the macros are used to set 
signal polarity, regardless of whether waits are used or not. So, if we 
ever get a SoC, where HSYNC and HREF polarity can be controlled separately 
and we will want to support that - _then_ we'll need these new macros. For 
now, I think, you just need to support non-zero wait counts and don't need 
to change names / introduce new ones. So, I'm dropping this one for now.

****************************************************************************
Patch 3
****************************************************************************

+ Add x_skip_left to soc_camera_device and to pxa_camera driver

Right, this is all you need to correctly read out line data from your 
camera, no HSYNC / HREF renaming or adding.

---

diff -r dd4685496fb7 linux/drivers/media/video/mt9m001.c
--- a/linux/drivers/media/video/mt9m001.c    Fri May 02 01:48:36 2008 -0300
+++ b/linux/drivers/media/video/mt9m001.c    Fri May 02 16:34:37 2008 +0200
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
@@ -784,6 +810,7 @@ static int mt9v022_probe(struct i2c_clie
    icd->width_max    = 752;
    icd->height_min    = 32;
    icd->height_max    = 480;
+    icd->x_skip_left = 0;
    icd->y_skip_top    = 1;
    icd->iface    = icl->bus_id;
    /* Default datawidth - this is the only width this camera (normally)
diff -r dd4685496fb7 linux/drivers/media/video/pxa_camera.c
--- a/linux/drivers/media/video/pxa_camera.c    Fri May 02 01:48:36 2008 -0300
+++ b/linux/drivers/media/video/pxa_camera.c    Fri May 02 16:16:36 2008 +0200
@@ -883,1 +874,1 @@ static int pxa_camera_set_bus_param(stru
    }

    CICR1 = cicr1;
-    CICR2 = 0;
+    CICR2 = CICR2_BLW_VAL(min((unsigned short)255, icd->x_skip_left));
    CICR3 = CICR3_LPF_VAL(icd->height - 1) |
        CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
    CICR4 = mclk_get_divisor(pcdev) | cicr4;
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

****************************************************************************
Patch 4
****************************************************************************

+ Change defrect.width and height to icd->width_max in soc_camera_cropcap

Hm, I'm not convinced. this is the _default rectangle_, max and min are 
set in "bounds", and I think the VGA 640x480 size is a reasonable default.

---

diff -r dd4685496fb7 linux/drivers/media/video/soc_camera.c
--- a/linux/drivers/media/video/soc_camera.c    Fri May 02 01:48:36 2008 -0300
+++ b/linux/drivers/media/video/soc_camera.c    Mon Apr 28 18:34:49 2008 +0200
@@ -558,7 +558,7 @@ static int soc_camera_cropcap(struct fil
    a->bounds.height        = icd->height_max;
    a->defrect.left            = icd->x_min;
    a->defrect.top            = icd->y_min;
-    a->defrect.width        = 640;
-    a->defrect.height        = 480;
+    a->defrect.width        = icd->width_max;
+    a->defrect.height        = icd->height_max;
    a->pixelaspect.numerator    = 1;
    a->pixelaspect.denominator    = 1;

So, I would say, patches 1 and 3 look useful to me. Please fix formatting 
issues, add your Signed-off-by and submit in two separate emails.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
