Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65493 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbdJ0OZT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 10:25:19 -0400
Date: Fri, 27 Oct 2017 16:25:08 +0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 4.15 v2] Atomisp cleanups, fixes
Message-ID: <20171027162508.131723b2@vela.lan>
In-Reply-To: <20171019152120.j44duddzs665d7vj@valkosipuli.retiisi.org.uk>
References: <20171019152120.j44duddzs665d7vj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Oct 2017 18:21:20 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> Here's the second version of the atomisp pull request. Since v1, I've added
> more patches, including an oops fix from Hans de Goede and move to
> timer_setup from Kees Cook. Also Andy's patches to clean up the driver are
> in, as well as my patches to rename the atomisp specific drivers (modules
> as well as Kconfig options).
> 
> Please pull.

Could you please rebase it on the top of the master branch? This series
conflicts with another series you sent renaming atomisp files.

Thanks!
Mauro

---

diff --cc drivers/staging/media/atomisp/i2c/Kconfig
index 09b1a97ce560,db054d3c7ed6..000000000000
--- a/drivers/staging/media/atomisp/i2c/Kconfig
+++ b/drivers/staging/media/atomisp/i2c/Kconfig
@@@ -59,20 -62,9 +62,24 @@@ config VIDEO_ATOMISP_MT9M11
  
  	 It currently only works with the atomisp driver.
  
++<<<<<<< HEAD
 +config VIDEO_ATOMISP_AP1302
 +       tristate "AP1302 external ISP support"
 +       depends on I2C && VIDEO_V4L2
 +       select REGMAP_I2C
 +       ---help---
 +	 This is a Video4Linux2 sensor-level driver for the external
 +	 ISP AP1302.
 +
 +	 AP1302 is an exteral ISP.
 +
 +	 It currently only works with the atomisp driver.
 +
++=======
++>>>>>>> 5cde6c6d85b7d9fbf05bb34cebb094ab9e4954a0
  config VIDEO_ATOMISP_GC0310
  	tristate "GC0310 sensor support"
+ 	depends on ACPI
  	depends on I2C && VIDEO_V4L2
  	---help---
  	  This is a Video4Linux2 sensor-level driver for the Galaxycore
diff --cc drivers/staging/media/atomisp/i2c/Makefile
index 3d27c75f5fc5,ae43dc84c229..000000000000
--- a/drivers/staging/media/atomisp/i2c/Makefile
+++ b/drivers/staging/media/atomisp/i2c/Makefile
@@@ -2,7 -2,6 +2,10 @@@
  # Makefile for sensor drivers
  #
  
++<<<<<<< HEAD
 +obj-$(CONFIG_VIDEO_ATOMISP_IMX)        += imx/
++=======
++>>>>>>> 5cde6c6d85b7d9fbf05bb34cebb094ab9e4954a0
  obj-$(CONFIG_VIDEO_ATOMISP_OV5693)     += ov5693/
  obj-$(CONFIG_VIDEO_ATOMISP_MT9M114)    += atomisp-mt9m114.o
  obj-$(CONFIG_VIDEO_ATOMISP_GC2235)     += atomisp-gc2235.o
@@@ -11,8 -10,6 +14,11 @@@ obj-$(CONFIG_VIDEO_ATOMISP_OV2680)     
  obj-$(CONFIG_VIDEO_ATOMISP_GC0310)     += atomisp-gc0310.o
  
  obj-$(CONFIG_VIDEO_ATOMISP_MSRLIST_HELPER) += atomisp-libmsrlisthelper.o
++<<<<<<< HEAD
 +
 +obj-$(CONFIG_VIDEO_ATOMISP_AP1302)     += atomisp-ap1302.o
++=======
++>>>>>>> 5cde6c6d85b7d9fbf05bb34cebb094ab9e4954a0
  
  # Makefile for flash drivers
  #
* Unmerged path drivers/staging/media/atomisp/i2c/atomisp-ap1302.c
* Unmerged path drivers/staging/media/atomisp/i2c/imx/Kconfig
* Unmerged path drivers/staging/media/atomisp/i2c/imx/Makefile
