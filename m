Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43361 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753118AbdHTQ6C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 12:58:02 -0400
Date: Sun, 20 Aug 2017 17:58:00 +0100
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.14] RC changes (part #1)
Message-ID: <20170820165800.3hr72dtw5i5z4ajb@gofer.mess.org>
References: <20170804151816.2s2rdxjtqvg6g5mj@gofer.mess.org>
 <20170820105426.1f5a6afd@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170820105426.1f5a6afd@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 20, 2017 at 10:54:26AM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 4 Aug 2017 16:18:16 +0100
> Sean Young <sean@mess.org> escreveu:
> 
> > Hi Mauro,
> > 
> > This is missing David Härdeman lirc cleanups, since they conflict with 
> > a revert for v4.13.
> > 
> > What we do have is three new RC drivers: ZTE ZX family SoCs, and two
> > GPIO drivers for IR TX (one using pwm and another bit banging). These
> > two drivers are useful for the Raspberry Pi. Also RC core no longer
> > has any dependency on CONFIG_MEDIA_SUPPORT.
> > 
> > Thanks
> > 
> > Sean
> > 
> > 
> > The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:
> > 
> >   media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)
> > 
> > are available in the git repository at:
> > 
> >   git://linuxtv.org/syoung/media_tree.git for-v4.14a
> > 
> > for you to fetch changes up to 7af1952a935c062490dd697cd2cf7c65ee75dc19:
> > 
> >   [media] winbond-cir: buffer overrun during transmit (2017-08-04 15:59:50 +0100)
> > 
> > ----------------------------------------------------------------
> > Arvind Yadav (2):
> >       [media] imon: constify attribute_group structures
> >       [media] rc: constify attribute_group structures
> > 
> > David Härdeman (1):
> >       [media] rc-core: consistent use of rc_repeat()
> > 
> > Gustavo A. R. Silva (1):
> >       [media] sir_ir: remove unnecessary static in sir_interrupt()
> > 
> > Heiner Kallweit (1):
> >       [media] rc: nuvoton: remove rudimentary transmit functionality
> > 
> > Philipp Zabel (2):
> >       [media] st-rc: explicitly request exclusive reset control
> >       [media] rc: sunxi-cir: explicitly request exclusive reset control
> > 
> > Sean Wang (4):
> >       [media] dt-bindings: media: mtk-cir: Add support for MT7622 SoC
> >       [media] rc: mtk-cir: add platform data to adapt into various hardware
> >       [media] rc: mtk-cir: add support for MediaTek MT7622 SoC
> >       [media] rc: mtk-cir: add MAINTAINERS entry for MediaTek CIR driver
> > 
> > Sean Young (10):
> >       [media] rc-core: do not depend on MEDIA_SUPPORT
> >       [media] rc-core: rename input_name to device_name
> >       [media] rc: mce kbd decoder not needed for IR TX drivers
> >       [media] rc: gpio-ir-tx: add new driver
> >       [media] rc: pwm-ir-tx: add new driver
> >       [media] dt-bindings: pwm-ir-tx: Add support for PWM IR Transmitter
> >       [media] dt-bindings: gpio-ir-tx: add support for GPIO IR Transmitter
> >       [media] lirc_zilog: driver only sends LIRCCODE
> >       [media] mceusb: do not read data parameters unless required
> >       [media] winbond-cir: buffer overrun during transmit
> > 
> > Shawn Guo (3):
> >       [media] rc: ir-nec-decoder: move scancode composing code into a shared function
> >       [media] dt-bindings: add bindings document for zx-irdec
> >       [media] rc: add zx-irdec remote control driver
> > 
> > Yves Lemée (1):
> >       [media] lirc_zilog: Clean up lirc zilog error codes
> > 
> >  .../devicetree/bindings/leds/irled/gpio-ir-tx.txt  |  14 ++
> >  .../devicetree/bindings/leds/irled/pwm-ir-tx.txt   |  13 ++
> >  .../devicetree/bindings/media/mtk-cir.txt          |   8 +-
> >  .../devicetree/bindings/media/zx-irdec.txt         |  14 ++
> >  MAINTAINERS                                        |  17 ++
> >  arch/arm/configs/imx_v6_v7_defconfig               |   2 +-
> >  arch/arm/configs/omap2plus_defconfig               |   2 +-
> >  arch/arm/configs/sunxi_defconfig                   |   2 +-
> >  arch/mips/configs/pistachio_defconfig              |   2 +-
> >  drivers/hid/hid-picolcd_cir.c                      |   2 +-
> >  drivers/media/Kconfig                              |  17 +-
> >  drivers/media/cec/cec-core.c                       |   4 +-
> >  drivers/media/common/siano/smsir.c                 |   4 +-
> >  drivers/media/i2c/ir-kbd-i2c.c                     |   2 +-
> >  drivers/media/pci/bt8xx/bttv-input.c               |   2 +-
> >  drivers/media/pci/cx23885/cx23885-input.c          |   2 +-
> >  drivers/media/pci/cx88/cx88-input.c                |   2 +-
> >  drivers/media/pci/dm1105/dm1105.c                  |   2 +-
> >  drivers/media/pci/mantis/mantis_common.h           |   2 +-
> >  drivers/media/pci/mantis/mantis_input.c            |   4 +-
> >  drivers/media/pci/saa7134/saa7134-input.c          |   2 +-
> >  drivers/media/pci/smipcie/smipcie-ir.c             |   4 +-
> >  drivers/media/pci/smipcie/smipcie.h                |   2 +-
> >  drivers/media/pci/ttpci/budget-ci.c                |   2 +-
> >  drivers/media/rc/Kconfig                           |  53 ++++-
> >  drivers/media/rc/Makefile                          |   3 +
> >  drivers/media/rc/ati_remote.c                      |   2 +-
> >  drivers/media/rc/ene_ir.c                          |   4 +-
> >  drivers/media/rc/fintek-cir.c                      |   2 +-
> >  drivers/media/rc/gpio-ir-recv.c                    |   2 +-
> >  drivers/media/rc/gpio-ir-tx.c                      | 174 +++++++++++++++
> >  drivers/media/rc/igorplugusb.c                     |   2 +-
> >  drivers/media/rc/iguanair.c                        |   2 +-
> >  drivers/media/rc/img-ir/img-ir-hw.c                |   2 +-
> >  drivers/media/rc/img-ir/img-ir-raw.c               |   2 +-
> >  drivers/media/rc/imon.c                            |   6 +-
> >  drivers/media/rc/ir-hix5hd2.c                      |   2 +-
> >  drivers/media/rc/ir-mce_kbd-decoder.c              |   6 +
> >  drivers/media/rc/ir-nec-decoder.c                  |  42 +---
> >  drivers/media/rc/ir-sanyo-decoder.c                |  10 +-
> >  drivers/media/rc/ir-spi.c                          |   1 +
> >  drivers/media/rc/ite-cir.c                         |   2 +-
> >  drivers/media/rc/keymaps/Makefile                  |   3 +-
> >  drivers/media/rc/keymaps/rc-zx-irdec.c             |  79 +++++++
> >  drivers/media/rc/mceusb.c                          |  38 ++--
> >  drivers/media/rc/meson-ir.c                        |   2 +-
> >  drivers/media/rc/mtk-cir.c                         | 244 ++++++++++++++++-----
> >  drivers/media/rc/nuvoton-cir.c                     | 116 +---------
> >  drivers/media/rc/nuvoton-cir.h                     |  24 --
> >  drivers/media/rc/pwm-ir-tx.c                       | 138 ++++++++++++
> >  drivers/media/rc/rc-loopback.c                     |   2 +-
> >  drivers/media/rc/rc-main.c                         |  20 +-
> >  drivers/media/rc/redrat3.c                         |   2 +-
> >  drivers/media/rc/serial_ir.c                       |  10 +-
> >  drivers/media/rc/sir_ir.c                          |   4 +-
> >  drivers/media/rc/st_rc.c                           |   4 +-
> >  drivers/media/rc/streamzap.c                       |   2 +-
> >  drivers/media/rc/sunxi-cir.c                       |   4 +-
> >  drivers/media/rc/ttusbir.c                         |   2 +-
> >  drivers/media/rc/winbond-cir.c                     |   4 +-
> >  drivers/media/rc/zx-irdec.c                        | 183 ++++++++++++++++
> >  drivers/media/usb/au0828/au0828-input.c            |   2 +-
> >  drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   5 +-
> >  drivers/media/usb/dvb-usb/dvb-usb-remote.c         |   2 +-
> >  drivers/media/usb/em28xx/em28xx-input.c            |   2 +-
> >  drivers/media/usb/tm6000/tm6000-input.c            |   2 +-
> >  drivers/staging/media/lirc/lirc_zilog.c            |  18 +-
> >  include/media/cec.h                                |   2 +-
> >  include/media/rc-core.h                            |  37 +++-
> >  include/media/rc-map.h                             |   1 +
> >  70 files changed, 1035 insertions(+), 361 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
> >  create mode 100644 Documentation/devicetree/bindings/leds/irled/pwm-ir-tx.txt
> >  create mode 100644 Documentation/devicetree/bindings/media/zx-irdec.txt
> >  create mode 100644 drivers/media/rc/gpio-ir-tx.c
> >  create mode 100644 drivers/media/rc/keymaps/rc-zx-irdec.c
> >  create mode 100644 drivers/media/rc/pwm-ir-tx.c
> >  create mode 100644 drivers/media/rc/zx-irdec.c
> 
> Patches applied. Yet, some new drivers were added here. 
> Please add them to MAINTAINERS.

The GPIO/PWM IR transmitters have entries in MAINTAINERS, but as you
rightfully point out zx-irdec.c does not. Please note this discussion:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg116831.html

What do you think?

Sean
