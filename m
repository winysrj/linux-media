Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:47423 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753749AbdL1QDT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 11:03:19 -0500
Message-ID: <1514476996.7000.437.camel@linux.intel.com>
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kristian Beilke <beilke@posteo.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        alan@linux.intel.com
Date: Thu, 28 Dec 2017 18:03:16 +0200
In-Reply-To: <6d1a2dc7-1d7b-78f3-9334-ccdedaa66510@posteo.de>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
         <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
         <1513715821.7000.228.camel@linux.intel.com>
         <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
         <1513866211.7000.250.camel@linux.intel.com>
         <6d1a2dc7-1d7b-78f3-9334-ccdedaa66510@posteo.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2017-12-23 at 01:31 +0100, Kristian Beilke wrote:
> On 12/21/2017 03:23 PM, Andy Shevchenko wrote:
> > On Thu, 2017-12-21 at 13:54 +0100, Kristian Beilke wrote:
> > > On Tue, Dec 19, 2017 at 10:37:01PM +0200, Andy Shevchenko wrote:
> > > > On Tue, 2017-12-19 at 14:00 +0200, Sakari Ailus wrote:
> > > > > Cc Alan and Andy.
> > > > > 
> > > > > On Sat, Dec 16, 2017 at 04:50:04PM +0100, Kristian Beilke
> > > > > wrote:
> > > > > > Dear all,
> > > > > > 
> > > > > > I am trying to get the cameras in a Lenovo IdeaPad Miix 320
> > > > > > (Atom
> > > > > > x5-Z8350 BayTrail) to work. The front camera is an ov2680.
> > > > > > With
> 
> CherryTrail

I didn't try even find a CherryTrail on hand that have AtomISP
enumerated by PCI with a camera sensor connected.

AFAIR Alan has CHT hardware he is developing / testing on.

> > > > WRT to the messages below it seems we have no platform data for
> > > > that
> > > > device. It needs to be added.
> > > > 
> 
> I tried to do exactly this. Extracted some values from
> acpidump/acpixtract and dmidecode, but unsure I nailed it.

Can you share somewhere it (pastebin.com, gist.github.com, etc)?

> > > > > > Can I somehow help to improve
> > > > > > the driver?
> > > > 
> > > > Yes, definitely, but first of all we need to find at least one
> > > > device
> > > > and corresponding firmware where it actually works.
> > > > 
> > > > For me it doesn't generate any interrupt (after huge hacking to
> > > > make
> > > > that firmware loaded and settings / platform data applied).
> > > > 
> > > 
> > > What exactly are you looking for?
> > 
> > For anything that *somehow* works.
> > 
> > >  An Android device where the ov2680
> > > works?
> > 
> > First of all, I most likely do not have hardware with such sensor.
> > Second, I'm using one of the prototype HW based on BayTrail with PCI
> > enumerable AtomISP.
> > 
> > >  Some x86_64 hardware, where the matching firmware is available
> > > and
> > > the driver in 4.15 works?
> > 
> > Yes, that's what I would like to have before moving forward with any
> > new
> > sensor drivers, clean ups or alike type of changes to the driver.
> > 
> 
> After your set of patches I applied the CherryTrail support I found
> here
> https://github.com/croutor/atomisp2401
> 
> As a result I get:
> 
> [    0.000000] DMI: LENOVO 80XF/LNVNB161216, BIOS 5HCN31WW 09/11/2017
> [    2.806685] axp20x-i2c i2c-INT33F4:00: AXP20x variant AXP288 found
> [    2.849606] axp20x-i2c i2c-INT33F4:00: AXP20X driver loaded
> [   19.593200] media: Linux media interface: v0.10
> [   19.627138] Linux video capture interface: v2.00
> [   19.652771] atomisp_ov2680: module is from the staging directory,
> the
> quality is unknown, you have been warned.
> [   19.676093] ov2680 i2c-OVTI2680:00: gmin: initializing atomisp
> module
> subdev data.PMIC ID 2
> [   19.676097] ov2680 i2c-OVTI2680:00: suddev name = ov2680 0-0010
> [   19.677548] gmin_v1p8_ctrl PMIC_AXP.
> [   19.685261] axp_regulator_set success.
> [   19.685428] axp_v1p8_on XXOV2680 00000010
> [   19.691777] axp_regulator_set success.
> [   19.708488] dw_dmac INTL9C60:00: DesignWare DMA Controller, 8
> channels
> [   19.752432] ov2680 i2c-OVTI2680:00: unable to set PMC rate 1
> [   19.760507] dw_dmac INTL9C60:01: DesignWare DMA Controller, 8
> channels
> [   19.789335] ov2680 i2c-OVTI2680:00: camera pdata: port: 0 lanes: 1
> order: 00000002
> [   19.793616] ov2680 i2c-OVTI2680:00: sensor_revision id = 0x2680
> [   19.793638] gmin_v1p8_ctrl PMIC_AXP.
> [   19.802615] axp_regulator_set success.
> [   19.806384] axp_regulator_set success.
> [   19.806396] ov2680 i2c-OVTI2680:00: register atomisp i2c module
> type 1
> [   19.859215] shpchp: Standard Hot Plug PCI Controller Driver
> version: 0.4
> [   19.906592] atomisp: module is from the staging directory, the
> quality is unknown, you have been warned.
> 
> [   19.910763]
> **********************************************************
> [   19.910765] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
> NOTICE   **
> [   19.910766]
> **                                                      **
> [   19.910767] ** trace_printk() being used. Allocating extra
> memory.  **
> [   19.910768]
> **                                                      **
> [   19.910769] ** This means that this is a DEBUG kernel and it
> is     **
> [   19.910770] ** unsafe for production
> use.                           **
> [   19.910771]
> **                                                      **
> [   19.910772] ** If you see this message and you are not
> debugging    **
> [   19.910773] ** the kernel, report this immediately to your
> vendor!  **
> [   19.910774]
> **                                                      **
> [   19.910775] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE
> NOTICE   **
> [   19.910776]
> **********************************************************
> [   19.923072] (NULL device *): hwmon_device_register() is deprecated.
> Please convert the driver to use hwmon_device_register_with_info().
> [   19.923219] (NULL device *): hwmon_device_register() is deprecated.
> Please convert the driver to use hwmon_device_register_with_info().
> [   19.932909] atomisp-isp2 0000:00:03.0: atomisp: device 000022B8
> revision 54
> [   19.932917] atomisp-isp2 0000:00:03.0: ISP HPLL frequency base =
> 1600 MHz
> [   20.133834] axp288_fuel_gauge axp288_fuel_gauge: axp288 not
> configured by firmware
> [   20.162738] atomisp-isp2 0000:00:03.0: Subdev OVTI2680:00
> successfully register
> [   20.162750] atomisp-isp2 0000:00:03.0: Entity type for entity ATOM
> ISP CSI2-port0 was not initialized!
> [   20.162753] atomisp-isp2 0000:00:03.0: Entity type for entity ATOM
> ISP CSI2-port1 was not initialized!
> [   20.162756] atomisp-isp2 0000:00:03.0: Entity type for entity ATOM
> ISP CSI2-port2 was not initialized!
> [   20.162759] atomisp-isp2 0000:00:03.0: Entity type for entity
> file_input_subdev was not initialized!
> [   20.162762] atomisp-isp2 0000:00:03.0: Entity type for entity
> tpg_subdev was not initialized!
> [   20.162765] atomisp-isp2 0000:00:03.0: Entity type for entity
> ATOMISP_SUBDEV_0 was not initialized!
> [   20.166183] atomisp-isp2 0000:00:03.0: Entity type for entity
> ATOMISP_SUBDEV_1 was not initialized!
> [   21.120554] rt5645 i2c-10EC5645:00: i2c-10EC5645:00 supply avdd not
> found, using dummy regulator
> [   21.120587] rt5645 i2c-10EC5645:00: i2c-10EC5645:00 supply cpvdd
> not
> found, using dummy regulator
> [   21.145141] intel_sst_acpi 808622A8:00: LPE base: 0x91400000
> size:0x200000
> [   21.145146] intel_sst_acpi 808622A8:00: IRAM base: 0x914c0000
> [   21.145241] intel_sst_acpi 808622A8:00: DRAM base: 0x91500000
> [   21.145250] intel_sst_acpi 808622A8:00: SHIM base: 0x91540000
> [   21.145262] intel_sst_acpi 808622A8:00: Mailbox base: 0x91544000
> [   21.145269] intel_sst_acpi 808622A8:00: DDR base: 0x20000000
> [   21.145403] intel_sst_acpi 808622A8:00: Got drv data max stream 25
> [   21.892310] atomisp-isp2 0000:00:03.0: Refused to change power
> state,
> currently in D3
> [   21.904537] OVTI2680:00:
>                ov2680_s_parm:run_mode :2000
> [   21.919743] atomisp-isp2 0000:00:03.0: Refused to change power
> state,
> currently in D3
> [   21.930399] OVTI2680:00:
>                ov2680_s_parm:run_mode :2000
> [   21.956479] atomisp-isp2 0000:00:03.0: Refused to change power
> state,
> currently in D3

I have few hacks on top of this.

First of all, take a base as atomisp branch of sakari's media_tree
repository:

https://git.linuxtv.org/sailus/media_tree.git/

Second, apply

--- a/drivers/staging/media/atomisp/platform/intel-
mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-
mid/atomisp_gmin_platform.c
@@ -499,6 +499,7 @@ static int gmin_v1p8_ctrl(struct v4l2_subdev
*subdev, int on)
                        return regulator_disable(gs->v1p8_reg);
        }
 
+return 0;
        return -EINVAL;
 }
 
@@ -535,6 +536,7 @@ static int gmin_v2p8_ctrl(struct v4l2_subdev
*subdev, int on)
                        return regulator_disable(gs->v2p8_reg);
        }
 
+return 0;
        return -EINVAL;
 }

---
a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++
b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -184,6 +184,7 @@ sh_css_check_firmware_version(const char *fw_data)
        firmware_header = (struct firmware_header *)fw_data;
        file_header = &firmware_header->file_header;
 
+return true;
        if (strcmp(file_header->version, release_version) != 0) {
                return false;

--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -348,6 +348,8 @@ DEFINES := -DHRT_HW -DHRT_ISP_CSS_CUSTOM_HOST
-DHRT_USE_VIR_ADDRS -D__HOST__
 #DEFINES += -DPUNIT_CAMERA_BUSY
 #DEFINES += -DUSE_KMEM_CACHE
 
+DEFINES += -DDEBUG
+
 DEFINES += -DATOMISP_POSTFIX=\"css2400b0_v21\" -DISP2400B0

For CHT you have to change define in this file to 2401 here and line
below AFAIU (never did this).

Third, you need to change pmic_id to be PMIC_AXP (I have longer patch
for this, that's why don't post here). Just hard code it for now in gmin
file.

Fourth, you have to be sure the clock rate is chosen correctly
(currently there is a bug in clk_set_rate() where parameter is clock
source index instead of frequency!). I think you need to hardcode
19200000 there instead of gs->clock_src.

> I am still not sure the FW gets loaded, and there is still no
> /dev/camera, but it looks promising.

You may add a debug print in necessary function inside ->probe (in
atomisp_v4l2.c). I dont't remember if -DDEBUG will enable something like
that. Perhaps.

You are expecting /dev/video<N> nodes. /dev/camera is usually a udev's
alias against one of /dev/video<N> nodes.

>  Am I on the right track here, or am
> I wasting my (and your) time?

It's both: track is right and it's waste of time.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
