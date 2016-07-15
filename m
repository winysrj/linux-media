Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:50982 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbcGOUQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 16:16:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: kernel-build-reports@lists.linaro.org
Cc: "kernelci. org bot" <bot@kernelci.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Simon Horman <horms@verge.net.au>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ray Jui <rjui@broadcom.com>,
	Yendapally Reddy Dhananjaya Reddy
	<yendapally.reddy@broadcom.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kedareswara rao Appana <appanad@xilinx.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: next build: 143 builds: 3 failed, 140 passed, 4 errors, 131 warnings (next-20160715)
Date: Fri, 15 Jul 2016 22:15:54 +0200
Message-ID: <1777393.XTWXVmed56@wuerfel>
In-Reply-To: <5788d8ee.531d1c0a.63fc8.5973@mx.google.com>
References: <5788d8ee.531d1c0a.63fc8.5973@mx.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, July 15, 2016 5:37:02 AM CEST kernelci. org bot wrote:
> 
>       1  pm-rcar-gen2.c:(.init.text+0x740): undefined reference to `platform_can_secondary_boot'

I sent a patch for it, Geert added an Ack, but it's still waiting to come
back through the renesas tree.

Note that the actual error is in arch/arm/mach-shmobile/platsmp.c,
not in pm-rcar-gen2.c

>       1  fs/fat/dir.c:758:424: internal compiler error: Segmentation fault

I reported the gcc but when it broke in 4.9, but it was only fixed in 6.1,
so this will have to wait for the kernelci infrastructure to do something
about it by updating their toolchain or blacklisting the config.

>       1  drivers/pinctrl/bcm/pinctrl-nsp-mux.c:356:20: error: 'pinconf_generic_dt_node_to_map_group' undeclared here (not in a function)
>       1  drivers/pinctrl/bcm/pinctrl-cygnus-mux.c:739:20: error: 'pinconf_generic_dt_node_to_map_group' undeclared here (not in a function)

I though I sent a patch for it but con't find it now. We basically need
this:

Subject: [PATCH] pinctrl: bcm: add OF dependencies

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/pinctrl/bcm/Kconfig b/drivers/pinctrl/bcm/Kconfig
index 7967c6723676..63246770bd74 100644
--- a/drivers/pinctrl/bcm/Kconfig
+++ b/drivers/pinctrl/bcm/Kconfig
@@ -60,6 +60,7 @@ config PINCTRL_IPROC_GPIO
 config PINCTRL_CYGNUS_MUX
 	bool "Broadcom Cygnus IOMUX driver"
 	depends on (ARCH_BCM_CYGNUS || COMPILE_TEST)
+	depends on OF
 	select PINMUX
 	select GENERIC_PINCONF
 	default ARCH_BCM_CYGNUS
@@ -103,6 +104,7 @@ config PINCTRL_NS2_MUX
 config PINCTRL_NSP_MUX
 	bool "Broadcom NSP IOMUX driver"
 	depends on (ARCH_BCM_NSP || COMPILE_TEST)
+	depends on OF
 	select PINMUX
 	select GENERIC_PINCONF
 	default ARCH_BCM_NSP


> Warnings summary:
> 
>      43  drivers/video/fbdev/core/fbmon.c:1497:67: warning: parameter 'specs' set but not used [-Wunused-but-set-parameter]

I sent a patch on June 16 when this warning was only for "make W=1", but
never got a reply from the fbdev maintainers (which is not uncommon
for that subsystem). Now Andrew merged a patch to have the warning at the
default level, I'll send him my oneline patch so he can apply it as well:

--- a/drivers/video/fbdev/core/fbmon.c
+++ b/drivers/video/fbdev/core/fbmon.c
@@ -1496,7 +1496,6 @@ int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
 }
 void fb_edid_to_monspecs(unsigned char *edid, struct fb_monspecs *specs)
 {
-       specs = NULL;
 }
 void fb_edid_add_monspecs(unsigned char *edid, struct fb_monspecs *specs)
 {


>      14  drivers/i2c/i2c-core.c:269:20: warning: 'i2c_acpi_add_device' defined but not used [-Wunused-function]

This was the result of an incomplete merge conflict resolution in linux-next,
hopefully to be resolved soon.

>       6  arch/arm64/configs/defconfig:352:warning: override: reassigning to symbol PWM

I have to look into this.

>       4  WARNING: modpost: missing MODULE_LICENSE() in drivers/dma/xilinx/zynqmp_dma.o

I have not seen this one before, but it should be obvious, Kedareswara rao Appana
just submitted the new driver recently and can probably send a fix.

>       3  drivers/misc/lkdtm_core.c:97:22: warning: 'jp_shrink_inactive_list' defined but not used [-Wunused-function]
>       3  drivers/misc/lkdtm_core.c:89:13: warning: 'jp_ll_rw_block' defined but not used [-Wunused-function]
>       3  drivers/misc/lkdtm_core.c:83:13: warning: 'jp_tasklet_action' defined but not used [-Wunused-function]
>       3  drivers/misc/lkdtm_core.c:75:20: warning: 'jp_handle_irq_event' defined but not used [-Wunused-function]
>       3  drivers/misc/lkdtm_core.c:68:21: warning: 'jp_do_irq' defined but not used [-Wunused-function]
>       3  drivers/misc/lkdtm_core.c:340:16: warning: 'lkdtm_debugfs_entry' defined but not used [-Wunused-function]
>       3  drivers/misc/lkdtm_core.c:114:12: warning: 'jp_scsi_dispatch_cmd' defined but not used [-Wunused-function]
>       3  drivers/misc/lkdtm_core.c:106:12: warning: 'jp_hrtimer_start' defined but not used [-Wunused-function]

This showed up today, and I sent a patch.

>       2  net/bluetooth/6lowpan.c:608:570: warning: 'addr_type' may be used uninitialized in this function [-Wmaybe-uninitialized]

I assume this is the result of using an older compiler, I haven't looked at the
details. Olof's build bot doesn't have it.

>       2  lib/test_hash.c:234:7: warning: "HAVE_ARCH_HASH_64" is not defined [-Wundef]
>       2  lib/test_hash.c:229:7: warning: "HAVE_ARCH_HASH_32" is not defined [-Wundef]
>       2  lib/test_hash.c:224:7: warning: "HAVE_ARCH__HASH_32" is not defined [-Wundef]
>       2  lib/test_hash.c:146:2: warning: missing braces around initializer [-Wmissing-braces]
>       2  lib/test_hash.c:146:2: warning: (near initialization for 'hash_or[0]') [-Wmissing-braces]

These are definitely coming from an older compiler, a couple of possible workarounds
have been sent in the past.

>       2  drivers/misc/mic/scif/scif_dma.c:118:27: warning: parameter 'ep' set but not used [-Wunused-but-set-parameter]

I also sent a patch for this on June 16, but I have some hope that
the maintainers still get to it.

>       2  drivers/net/xen-netback/hash.c:127:6: warning: 'val' may be used uninitialized in this function [-Wmaybe-uninitialized]
>       2  drivers/misc/lkdtm_usercopy.c:54:15: warning: 'bad_stack' may be used uninitialized in this function [-Wmaybe-uninitialized]
>       2  drivers/media/usb/dvb-usb/dvb-usb-dvb.c:323:5: warning: 'ret' may be used uninitialized in this function [-Wmaybe-uninitialized]
>       2  drivers/gpu/drm/nouveau/nvkm/subdev/top/gk104.c:89:90: warning: 'type' may be used uninitialized in this function [-Wmaybe-uninitialized]
>       2  drivers/extcon/extcon.c:455:6: warning: 'idx' may be used uninitialized in this function [-Wmaybe-uninitialized]

I don't see any of these on ARM with gcc-6.1, I assume these are from older compilers,
or possibly architecture specific.

>       2  drivers/media/dvb-frontends/cxd2841er.c:3249:569: warning: 'carrier_offset' may be used uninitialized in this function [-Wmaybe-uninitialized]
>       2  drivers/media/dvb-frontends/cxd2841er.c:3249:552: warning: 'carrier_offset' may be used uninitialized in this function [-Wmaybe-uninitialized]

This was a side-effect of changes in the dynamic debug code to use
jump labels. I sent a patch to work around it in the driver, which
is not broken.

>       1  include/trace/events/devlink.h:16:467: warning: format '%lu' expects argument of type 'long unsigned int', but argument 10 has type 'size_t {aka unsigned int}' [-Wformat=]

I think my patch should be in tomorrow's linux-next.

>       1  drivers/tty/serial/8250/8250_fintek.c:34:0: warning: "IRQ_MODE" redefined

Sent a patch a while ago.

>       1  arch/arm/configs/mps2_defconfig:102:warning: symbol value 'y' invalid for PRINTK_TIME

I'll fix this later, it's harmless and is a result of a merge in linux-next.

>       1  .config:974:warning: override: NOHIGHMEM changes choice state
>       1  .config:973:warning: override: SLOB changes choice state
>       1  .config:971:warning: override: KERNEL_XZ changes choice state
>       1  .config:970:warning: override: CC_OPTIMIZE_FOR_SIZE changes choice state
>       1  .config:946:warning: override: SLOB changes choice state
>       1  .config:943:warning: override: CC_OPTIMIZE_FOR_SIZE changes choice state
>       1  .config:877:warning: override: SLOB changes choice state
>       1  .config:875:warning: override: KERNEL_XZ changes choice state
>       1  .config:874:warning: override: CC_OPTIMIZE_FOR_SIZE changes choice state

We had some discussion about these, I think it's fixable but we don't have
a good patch yet (I suggested on that turned out to be bad).

	Arnd

