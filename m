Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44205
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752665AbdCHQiD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Mar 2017 11:38:03 -0500
Date: Wed, 8 Mar 2017 13:37:26 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alan Cox <alan@linux.intel.com>
Cc: greg@kroah.com, mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging/atomisp: Add support for the Intel IPU v2
Message-ID: <20170308133726.05a12c0d@vento.lan>
In-Reply-To: <148735051279.12479.11445229229552101143.stgit@acox1-desk1.ger.corp.intel.com>
References: <148735051279.12479.11445229229552101143.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

Em Fri, 17 Feb 2017 16:55:17 +0000
Alan Cox <alan@linux.intel.com> escreveu:

Thanks for the driver. Unfortunately, we missed the initial post at linux-media,
because VGER doesn't accept too big posts :-(

> This patch adds support for the Intel IPU v2 as found on Android and IoT
> Baytrail-T and Baytrail-CR platforms (those with the IPU PCI mapped). You
> will also need the firmware files from your device (Android usually puts
> them into /etc) - or you can find them in the downloadable restore/upgrade
> kits if you blew them away for some reason.

Before moving firmware-dependent drivers out of staging, please send the
firmware files to linux-firmware ML.

> It may be possible to extend the driver to handle the BYT/T windows
> platforms such as the ASUS T100TA. These platforms don't expose the IPU via
> the PCI interface but via ACPI buried in the GPU description and with the
> camera information somewhere unknown so would need a platform driver
> interface adding to the codebase *IFF* the firmware works on such devices.
> 
> To get good results you also need a suitable support library such as
> libxcam. The camera is intended to be driven from Android so it has a lot of
> features that many desktop apps don't fully spport.
> 
> In theory all the pieces are there to build it with -DISP2401 and some
> differing files to get CherryTrail/T support, but unifying the drivers
> properlly is a work in progress.
> 
> The IPU driver represents the work of a lot of people within Intel over many
> years. It's historical goal was portability rather than Linux upstream. Any
> queries about the upstream aimed driver should be sent to me not to the
> original authors.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

...

>  920 files changed, 204645 insertions(+)

Wow! that's huge!

> diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
> index abd0e2d..5fe5d8f 100644
> --- a/drivers/staging/media/Kconfig
> +++ b/drivers/staging/media/Kconfig
> @@ -36,4 +36,5 @@ source "drivers/staging/media/lirc/Kconfig"
>  
>  source "drivers/staging/media/st-cec/Kconfig"
>  
> +source "drivers/staging/media/atomisp/Kconfig"
>  endif
> diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
> index dc89325..88d5db9 100644
> --- a/drivers/staging/media/Makefile
> +++ b/drivers/staging/media/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_VIDEO_BCM2835)	+= platform/bcm2835/
>  obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
>  obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
>  obj-$(CONFIG_VIDEO_STI_HDMI_CEC) += st-cec/
> +obj-$(CONFIG_INTEL_ATOMISP)     += atomisp/
> diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
> new file mode 100644
> index 0000000..f7d8a84
> --- /dev/null
> +++ b/drivers/staging/media/atomisp/Kconfig
> @@ -0,0 +1,11 @@
> +menuconfig INTEL_ATOMISP
> +        bool "Enable support to Intel MIPI camera drivers"
> +        depends on X86
> +        help
> +          Enable support for the Intel ISP2 camera interfaces and MIPI
> +          sensor drivers.
> +
> +if INTEL_ATOMISP
> +source "drivers/staging/media/atomisp/pci/Kconfig"
> +source "drivers/staging/media/atomisp/i2c/Kconfig"
> +endif
> diff --git a/drivers/staging/media/atomisp/Makefile b/drivers/staging/media/atomisp/Makefile
> new file mode 100644
> index 0000000..e16752e
> --- /dev/null
> +++ b/drivers/staging/media/atomisp/Makefile
> @@ -0,0 +1,8 @@
> +#
> +# Makefile for camera drivers.
> +#
> +
> +obj-$(CONFIG_INTEL_ATOMISP) += pci/
> +obj-$(CONFIG_INTEL_ATOMISP) += i2c/
> +obj-$(CONFIG_INTEL_ATOMISP) += platform/
> +LINUXINCLUDE        += -I drivers/staging/media/atomisp/include/
> diff --git a/drivers/staging/media/atomisp/TODO b/drivers/staging/media/atomisp/TODO
> new file mode 100644
> index 0000000..737452c
> --- /dev/null
> +++ b/drivers/staging/media/atomisp/TODO
> @@ -0,0 +1,64 @@
> +1. A single AtomISP driver needs to be implemented to support both BYT and
> +   CHT platforms. The current driver is a mechanical and hand combined merge
> +   of the two using an ifdef ISP2401 to select the CHT version, which at the
> +   moment is not enabled. Eventually this should become a runtime if check,
> +   but there are some quite tricky things that need sorting out before that
> +   will be possible.
> +
> +2. The file structure needs to get tidied up to resemble a normal Linux
> +   driver.
> +
> +3. Lots of the midlayer glue. unused code and abstraction needs removing.
> +
> +3. The sensor drivers read MIPI settings from EFI variables or default to the
> +   settings hard-coded in the platform data file for different platforms.
> +   This isn't ideal but may be hard to improve as this is how existing
> +   platforms work.
> +
> +4. The sensor drivers use the regulator framework API. In the ideal world it
> +   would be using ACPI but that's not how the existing devices work.
> +
> +5. The AtomISP driver includes some special IOCTLS (ATOMISP_IOC_XXXX_XXXX)
> +   that may need some cleaning up.

Those likely require upstream discussions, in order to identify if are 
there any already existing ioctl set that does the same thing and/or
if it makes sense to add new ioctls to do what's needed there.

> +
> +6. Correct Coding Style. Please don't send coding style patches for this
> +   driver until the other work is done.
> +
> +7. The ISP code depends on the exact FW version. The version defined in
> +   BYT: 
> +   drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> +   static const char *release_version = STR(irci_stable_candrpv_0415_20150521_0458);
> +   CHT:
> +   drivers/staging/media/atomisp/pci/atomisp2/css/sh_css_firmware.c
> +   static const char *release_version = STR(irci_ecr-master_20150911_0724);
> +
> +   At some point we may need to round up a few driver versions and see if
> +   there are any specific things that can be done to fold in support for
> +   multiple firmware versions.
> +
> +
> +Limitations:
> +
> +1. Currently the patch only support some camera sensors
> +   gc2235/gc0310/0v2680/ov2722/ov5693/mt9m114...
> +
> +2. To test the patches, you also need the ISP firmware
> +
> +   for BYT:/lib/firmware/shisp_2400b0_v21.bin
> +   for CHT:/lib/firmware/shisp_2401a0_v21.bin
> +
> +   The firmware files will usually be found in /etc/firmware on an Android
> +   device but can also be extracted from the upgrade kit if you've managed
> +   to lose them somehow.
> +
> +3. Without a 3A libary the capture behaviour is not very good. To take a good
> +   picture, you need tune ISP parameters by IOCTL functions or use a 3A libary
> +   such as libxcam.
> +
> +4. The driver is intended to drive the PCI exposed versions of the device.
> +   It will not detect those devices enumerated via ACPI as a field of the
> +   i915 GPU driver.
> +
> +5. The driver supports only v2 of the IPU/Camera. It will not work with the
> +   versions of the hardware in other SoCs.
> +

Reviewing a 200K big patch like this one is not human feasible :-)

My suggestion is to fix it, driver by driver, starting with the I2C sensor
drivers, as, usually, sensor drivers are not that big, and are not too hard
to review.

If they're properly using the V4L2 subdev approach, they should be
independent on the main driver. So, they can be moved out of staging
one by one.

So, let's keep applying patches for it at staging until they get
ready.

When you think that each of those I2C drivers are ready to be 
promoted out of staging, please send them as if they're a new driver to
linux-media@vger.kernel.org, as this will make the review process
easier.

Once we get them all under drivers/media, we can focus on reviewing
the main driver.

Thanks!
Mauro
