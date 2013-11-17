Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:44626 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3KQXGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 18:06:54 -0500
From: Gerhard Sittig <gsi@denx.de>
To: linuxppc-dev@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	Anatolij Gustschin <agust@denx.de>,
	Mike Turquette <mturquette@linaro.org>
Cc: Scott Wood <scottwood@freescale.com>, Detlev Zundel <dzu@denx.de>,
	Gerhard Sittig <gsi@denx.de>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Woodhouse <dwmw2@infradead.org>,
	devicetree@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Kumar Gala <galak@kernel.crashing.org>,
	linux-can@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-serial@vger.kernel.org,
	linux-spi@vger.kernel.org, linux-usb@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Paul Mackerras <paulus@samba.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Wolfgang Grandegger <wg@grandegger.com>
Subject: [PATCH v5 00/17] add COMMON_CLK support for PowerPC MPC512x
Date: Mon, 18 Nov 2013 00:06:00 +0100
Message-Id: <1384729577-7336-1-git-send-email-gsi@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

this series introduces support for the common clock framework (CCF,
COMMON_CLK Kconfig option) in the PowerPC based MPC512x platform, which
brings device tree based clock lookup as well

at subsystem maintainers:

this series was streamlined for conflict free application through the
subsystems' individual trees, and consists of the following phases
- peripheral driver cleanup (1/17) (not essential, in fact comments only
  and code which is a NOP)
- introduction of CCF support including migration workarounds and
  backwards compatibility, device tree updates (2/17 - 7/17)
  (nevertheless I suggest to take the .dts/.dtsi updates through the
  PowerPC tree, the extensions are straight forward and strictly are
  clock related, and complement the CCF platform support)
- peripheral driver adjustment to the CCF approach (8/17 - 16/17)
- removal of migration workarounds (17/17)

at device tree maintainers:

- the series does not introduce new bindings, but implements the
  existing clock binding (OF clock provider, DT based clock lookup) and
  so adjusts and extends DTS files
- the code is backwards compatible, and keeps working with device trees
  which don't contain clock related information


the series is based on v3.12, but I'll rebase against v3.13-rc1 (when
available) or any other subtree upon request

the series passes 'checkpatch.pl --strict' except for one warning which
cannot get resolved, since the <linux/clk-provider.h> API dictates the
data type, "fixing" the checkpatch warning would break compilation

  WARNING: static const char * array should probably be static const char * const
  #420: FILE: arch/powerpc/platforms/512x/clock-commonclk.c:342:
  +static const char *parent_names_mux0[] = {

  total: 0 errors, 1 warnings, 0 checks, 834 lines checked

checkpatch appears to choke on the NODE_CHK() macro in the backwards
compat patch, while I cannot see why since it groks the FOR_NODES() and
NODE_PREP() macros

  Use of uninitialized value $c in pattern match (m//) at ./scripts/checkpatch.pl line 3280.
  Use of uninitialized value in substr at ./scripts/checkpatch.pl line 3287.
  Use of uninitialized value $s in substr at ./scripts/checkpatch.pl line 3287.


the series has been build tested (each step on PowerPC 512x, 52xx, 5xxx
multi platform, 83xx, 85xx, 86xx, and on ARM v6/v7), run tested (each
step on 512x, the switch to CCF on 52xx), and tested for backwards
compatibility (each step on 512x with a v3.11 dtb)


changes in v5:
- extend comments in the PCI driver cleanup (probe() vs setup_arch()
  discussion, no code change); all other peripheral driver cleanup from
  v4 was taken into mainline
- concentrate migration support in a separate routine for improved
  maintainability
- fix the oscillator frequency lookup ('osc' reference) in the CCF
  platform support code which creates the clock tree
- add backwards compatibility with device trees that lack clock specs,
  concentrate compat support in a separate routine for improved
  maintainability, add it in a separate patch for easier review
- consistent use of the 'ipg' name in DTS files for the register access
  clock item of peripherals
- switch from PPC_CLOCK to COMMON_CLK at the same time for 512x and 52xx
  (keep multi-platform setups operational), in a separate patch
- move removal of migration support to the very end of the series, it's
  no longer intertwined with peripheral driver adjustment
- SPI and UART: get 'mclk' and 'ipg' clock items in a more consistent
  order (less obfuscation in the diff)
- add/adjust Cc: and Acked-By: entries, rework commit messages and
  comments where appropriate

changes in v4:
- remove explicit devm_clk_put() calls as these will occur implicitly
  upon device release (01/31, 02/31, 03/31, 04/31, 05/31, 06/31, 08/31,
  09/31, 27/31)
- split the PSC (SPI, UART) and MSCAN (CAN) related MCLK subtrees into
  separate 'ipg'/'bdlc' gated clock items for register access as well as
  the 'mclk' clock subtrees that apply to bitrates -- this eliminates
  the need for "shared gates" and further reduces clock pre-enable
  workarounds (11/31, 15/31, 17/31, 18/31, 20/31, 21/31, 22/31, 27/31)
- further adjust the CAN clock driver, fix an incomplete error code path
  in the network device open callback (11/31), only enable the bitrate
  clock when the network device is open (27/31)
- remove debug output in the clock tree setup when introducing the
  platform's clock driver, there already is CONFIG_COMMON_CLK_DEBUG to
  retrieve more complete information (17/31)
- remove an "enums don't work here" comment in the dt-bindings header
  file (15/31)
- reword and update commit messages (body and/or subject) where
  appropriate (03/31, 04/31, 05/31, 06/31, 08/31, 09/31, 11/31, 12/31,
  17/31, 20/31, 21/31, 22/31, 27/31, 28/31, 30/31, 31/31)
- add 'Reviewed-By' attributes which were received for v3

changes in v3:
- rebase the series against v3.11-rc2
- re-ordered the series to first address all general clock handling
  concerns in existing drivers, before introducing common clock support
  in the platform's clock driver
- slightly rework the SPI (01/31), UART (02/31), and PSC FIFO (23/31)
  clock handling in comparison to v2 which introduced those fixes
  (devm_{get,put}_clk() calls, fewer goto labels in error paths)
- fix and improve clock handling (balance allocation and release of
  clocks, check for errors during setup) in all of the other drivers
  which this series has touched before in naive ways: USB (03/31), NAND
  flash (04/31), video capture (05/31), I2C (06/31), ethernet (08/31),
  PCI (09/31), CAN (11/31)
- silence a build warning in the ethernet driver (07/31)
- eliminate all PPC_CLOCK references, use 'per' clock names for NAND
  flash (25/31) and VIU (26/31) as well
- unbreak CAN operation for the period between introducing common clock
  support in the platform's clock driver and introducing common clock
  support in the CAN peripheral driver as well as providing clock specs
  in the device tree (provide clkdev aliases for SYS and REF)
- improve common clock support for CAN (devm_{get,put}_clk() calls,
  check enable() errors, keep a reference to used clocks, disable and
  put clocks after use)
- reworded several commit messages to better reflect the kind of change
  and because fixes were applied before adding common infrastructure
  support
- point to individual numbered patches of the series in the list of
  changes for v2 as well

changes in v2:
- cleanup of the UART (02/24) and SPI (01/24) clock handling before the
  introduction of common clock support for the platform, as incomplete
  clock handling becomes fatal or more dangerous later (which in turn
  changes the context of the "device tree lookup only" followup patch
  later)
- reordered the sequence of patches to keep the serial communication
  related parts together (UART, SPI, and PSC FIFO changes after common
  clock support was introduced, which have become 11-14/24 now)
- updated commit messages for the clock API use cleanup in the serial
  communication drivers, updated comments and reworded commit messages
  in the core clock driver to expand on the pre-enable workaround and
  clkdev registration (09/24)
- keep a reference to the PSC FIFO clock during use instead of looking
  up the clock again in the uninit() routine (14/24)
- remove the clkdev.h header file inclusion directive with the removal
  of the clkdev registration call (13/24)


Gerhard Sittig (17):
  powerpc/fsl-pci: improve clock API use
  dts: mpc512x: introduce dt-bindings/clock/ header
  dts: mpc512x: add clock related device tree specs
  clk: mpc512x: introduce COMMON_CLK for MPC512x (disabled)
  clk: mpc512x: add backwards compat to the CCF code
  dts: mpc512x: add clock specs for client lookups
  clk: mpc5xxx: switch to COMMON_CLK, retire PPC_CLOCK
  spi: mpc512x: adjust to OF based clock lookup
  serial: mpc512x: adjust for OF based clock lookup
  serial: mpc512x: setup the PSC FIFO clock as well
  USB: fsl-mph-dr-of: adjust for OF based clock lookup
  mtd: mpc5121_nfc: adjust for OF based clock lookup
  [media] fsl-viu: adjust for OF based clock lookup
  net: can: mscan: adjust to common clock support for mpc512x
  net: can: mscan: remove non-CCF code for MPC512x
  powerpc/mpc512x: improve DIU related clock setup
  clk: mpc512x: remove migration support workarounds

 arch/powerpc/Kconfig                          |    5 -
 arch/powerpc/boot/dts/ac14xx.dts              |    7 +
 arch/powerpc/boot/dts/mpc5121.dtsi            |  113 ++-
 arch/powerpc/kernel/Makefile                  |    1 -
 arch/powerpc/kernel/clock.c                   |   82 ---
 arch/powerpc/platforms/512x/Kconfig           |    2 +-
 arch/powerpc/platforms/512x/Makefile          |    3 +-
 arch/powerpc/platforms/512x/clock-commonclk.c |  950 +++++++++++++++++++++++++
 arch/powerpc/platforms/512x/clock.c           |  753 --------------------
 arch/powerpc/platforms/512x/mpc512x_shared.c  |  169 +++--
 arch/powerpc/platforms/52xx/Kconfig           |    2 +-
 arch/powerpc/sysdev/fsl_pci.c                 |   52 ++
 drivers/media/platform/fsl-viu.c              |    2 +-
 drivers/mtd/nand/mpc5121_nfc.c                |    2 +-
 drivers/net/can/mscan/mpc5xxx_can.c           |  270 ++++---
 drivers/spi/spi-mpc512x-psc.c                 |   26 +-
 drivers/tty/serial/mpc52xx_uart.c             |   90 ++-
 drivers/usb/host/fsl-mph-dr-of.c              |   13 +-
 include/dt-bindings/clock/mpc512x-clock.h     |   69 ++
 include/linux/clk-provider.h                  |   16 +
 20 files changed, 1556 insertions(+), 1071 deletions(-)
 delete mode 100644 arch/powerpc/kernel/clock.c
 create mode 100644 arch/powerpc/platforms/512x/clock-commonclk.c
 delete mode 100644 arch/powerpc/platforms/512x/clock.c
 create mode 100644 include/dt-bindings/clock/mpc512x-clock.h

-- 
1.7.10.4

