Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49361 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab0FBOE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jun 2010 10:04:26 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 2 Jun 2010 09:04:15 -0500
Subject: RE: [PATCH 1/2] Davinci: Create seperate Kconfig file for davinci
 devices
Message-ID: <A69FA2915331DC488A831521EAE36FE4016B18570B@dlee06.ent.ti.com>
References: <hvaibhav@ti.com>
 <1274965876-21845-2-git-send-email-hvaibhav@ti.com>,<A69FA2915331DC488A831521EAE36FE4016B1856F1@dlee06.ent.ti.com>
 <19F8576C6E063C45BE387C64729E7394044DA71054@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044DA71054@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>>> Vaibhav,
>
>>> Could you also list DM365 here? This was somehow missed.
>
>I believe you are referring to
>
>Instruments:- DM6446, DM365  & DM355

yes. Thanks.
>
>Submitting this patch alone with this change.
>
>Thanks,
>Vaibhav
>
>>-        To compile this driver as a module, choose M here: the
>>-        module will be called vpfe-capture.
>>-
>>-config VIDEO_DM6446_CCDC
>>-      tristate "DM6446 CCDC HW module"
>>-      depends on ARCH_DAVINCI_DM644x && VIDEO_VPFE_CAPTURE
>>-      select VIDEO_VPSS_SYSTEM
>>-      default y
>>-      help
>>-         Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
>>-         with decoder modules such as TVP5146 over BT656 or
>>-         sensor module such as MT9T001 over a raw interface. This
>>-         module configures the interface and CCDC/ISIF to do
>>-         video frame capture from slave decoders.
>>-
>>-         To compile this driver as a module, choose M here: the
>>-         module will be called vpfe.
>>-
>>-config VIDEO_DM355_CCDC
>>-      tristate "DM355 CCDC HW module"
>>-      depends on ARCH_DAVINCI_DM355 && VIDEO_VPFE_CAPTURE
>>-      select VIDEO_VPSS_SYSTEM
>>-      default y
>>-      help
>>-         Enables DM355 CCD hw module. DM355 CCDC hw interfaces
>>-         with decoder modules such as TVP5146 over BT656 or
>>-         sensor module such as MT9T001 over a raw interface. This
>>-         module configures the interface and CCDC/ISIF to do
>>-         video frame capture from a slave decoders
>>-
>>-         To compile this driver as a module, choose M here: the
>>-         module will be called vpfe.
>>-
>>-config VIDEO_ISIF
>>-      tristate "ISIF HW module"
>>-      depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
>>-      select VIDEO_VPSS_SYSTEM
>>-      default y
>>-      help
>>-         Enables ISIF hw module. This is the hardware module for
>>-         configuring ISIF in VPFE to capture Raw Bayer RGB data  from
>>-         a image sensor or YUV data from a YUV source.
>>-
>>-         To compile this driver as a module, choose M here: the
>>-         module will be called vpfe.
>>+source "drivers/media/video/davinci/Kconfig"
>>
>> source "drivers/media/video/omap/Kconfig"
>>
>>diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
>>index cc93859..aa1ea2f 100644
>>--- a/drivers/media/video/Makefile
>>+++ b/drivers/media/video/Makefile
>>@@ -177,7 +177,7 @@ obj-$(CONFIG_VIDEO_SAA7164)     += saa7164/
>>
>> obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>>
>>-obj-$(CONFIG_ARCH_DAVINCI)    += davinci/
>>+obj-y += davinci/
>>
>> obj-$(CONFIG_ARCH_OMAP)       += omap/
>>
>>diff --git a/drivers/media/video/davinci/Kconfig
>>b/drivers/media/video/davinci/Kconfig
>>new file mode 100644
>>index 0000000..97f889d
>>--- /dev/null
>>+++ b/drivers/media/video/davinci/Kconfig
>>@@ -0,0 +1,93 @@
>>+config DISPLAY_DAVINCI_DM646X_EVM
>>+      tristate "DM646x EVM Video Display"
>>+      depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
>>+      select VIDEOBUF_DMA_CONTIG
>>+      select VIDEO_DAVINCI_VPIF
>>+      select VIDEO_ADV7343
>>+      select VIDEO_THS7303
>>+      help
>>+        Support for DM6467 based display device.
>>+
>>+        To compile this driver as a module, choose M here: the
>>+        module will be called vpif_display.
>>+
>>+config CAPTURE_DAVINCI_DM646X_EVM
>>+      tristate "DM646x EVM Video Capture"
>>+      depends on VIDEO_DEV && MACH_DAVINCI_DM6467_EVM
>>+      select VIDEOBUF_DMA_CONTIG
>>+      select VIDEO_DAVINCI_VPIF
>>+      help
>>+        Support for DM6467 based capture device.
>>+
>>+        To compile this driver as a module, choose M here: the
>>+        module will be called vpif_capture.
>>+
>>+config VIDEO_DAVINCI_VPIF
>>+      tristate "DaVinci VPIF Driver"
>>+      depends on DISPLAY_DAVINCI_DM646X_EVM
>>+      help
>>+        Support for DaVinci VPIF Driver.
>>+
>>+        To compile this driver as a module, choose M here: the
>>+        module will be called vpif.
>>+
>>+config VIDEO_VPSS_SYSTEM
>>+      tristate "VPSS System module driver"
>>+      depends on ARCH_DAVINCI
>>+      help
>>+        Support for vpss system module for video driver
>>+
>>+config VIDEO_VPFE_CAPTURE
>>+      tristate "VPFE Video Capture Driver"
>>+      depends on VIDEO_V4L2 && (ARCH_DAVINCI || ARCH_OMAP3)
>>+      select VIDEOBUF_DMA_CONTIG
>>+      help
>>+        Support for DMx/AMx VPFE based frame grabber. This is the
>>+        common V4L2 module for following DMx/AMx SoCs from Texas
>>+        Instruments:- DM6446, DM355 & AM3517/05.
>>+
>>+        To compile this driver as a module, choose M here: the
>>+        module will be called vpfe-capture.
>>+
>>+config VIDEO_DM6446_CCDC
>>+      tristate "DM6446 CCDC HW module"
>>+      depends on VIDEO_VPFE_CAPTURE
>>+      select VIDEO_VPSS_SYSTEM
>>+      default y
>>+      help
>>+         Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
>>+         with decoder modules such as TVP5146 over BT656 or
>>+         sensor module such as MT9T001 over a raw interface. This
>>+         module configures the interface and CCDC/ISIF to do
>>+         video frame capture from slave decoders.
>>+
>>+         To compile this driver as a module, choose M here: the
>>+         module will be called vpfe.
>>+
>>+config VIDEO_DM355_CCDC
>>+      tristate "DM355 CCDC HW module"
>>+      depends on ARCH_DAVINCI_DM355 && VIDEO_VPFE_CAPTURE
>>+      select VIDEO_VPSS_SYSTEM
>>+      default y
>>+      help
>>+         Enables DM355 CCD hw module. DM355 CCDC hw interfaces
>>+         with decoder modules such as TVP5146 over BT656 or
>>+         sensor module such as MT9T001 over a raw interface. This
>>+         module configures the interface and CCDC/ISIF to do
>>+         video frame capture from a slave decoders
>>+
>>+         To compile this driver as a module, choose M here: the
>>+         module will be called vpfe.
>>+
>>+config VIDEO_ISIF
>>+      tristate "ISIF HW module"
>>+      depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
>>+      select VIDEO_VPSS_SYSTEM
>>+      default y
>>+      help
>>+         Enables ISIF hw module. This is the hardware module for
>>+         configuring ISIF in VPFE to capture Raw Bayer RGB data  from
>>+         a image sensor or YUV data from a YUV source.
>>+
>>+         To compile this driver as a module, choose M here: the
>>+         module will be called vpfe.
>>--
>>1.6.2.4

