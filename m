Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40436
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754540AbdBUSI7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 13:08:59 -0500
Date: Tue, 21 Feb 2017 15:08:50 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.11-rc1] media updates
Message-ID: <20170221150850.3d92f22f@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.11-1

For:
  - New drivers:
	i.MX6 Video Data Order Adapter's (VDOA)
	Toshiba et8ek8 5MP sensor
	STM DELTA multi-format video decoder V4L2 driver
	SPI connected IR LED
	Mediatek IR remote receiver
	ZyDAS ZD1301 DVB USB interface driver

  - new RC keymaps;
  - Some very old LIRC drivers got removed from staging;
  - RC core gained support encoding IR scan codes;
  - DVB si2168 gained support for DVBv5 statistics;
  - lirc_sir driver ported to rc-core and promoted from staging;
  - other bug fixes, board additions and driver improvements.

Thanks!
Mauro



The following changes since commit 7ce7d89f48834cefece7804d38fc5d85382edf77:

  Linux 4.10-rc1 (2016-12-25 16:13:08 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.11-1

for you to fetch changes up to 9eeb0ed0f30938f31a3d9135a88b9502192c18dd:

  [media] mtk-vcodec: fix build warnings without DEBUG (2017-02-08 12:08:20 -0200)

----------------------------------------------------------------
media updates for v4.11-rc1

----------------------------------------------------------------
Andi Shyti (6):
      [media] rc-main: assign driver type during allocation
      [media] rc-main: split setup and unregister functions
      [media] rc-core: add support for IR raw transmitters
      [media] rc-ir-raw: do not generate any receiving thread for raw transmitters
      [media] Documentation: bindings: add documentation for ir-spi device driver
      [media] rc: add support for IR LEDs driven through SPI

Andrzej Hajda (1):
      [media] v4l: s5c73m3: fix negation operator

Antti Palosaari (22):
      [media] mn88473: add DVB-T2 PLP support
      [media] cxd2820r: fix gpio null pointer dereference
      [media] si2168: implement ber statistics
      [media] si2168: implement ucb statistics
      [media] af9035: read and store whole eeprom
      [media] af9033: convert to regmap api
      [media] af9033: use 64-bit div macro where possible
      [media] af9033: style related and minor changes
      [media] af9033: return regmap for integrated IT913x tuner driver
      [media] it913x: change driver model from i2c to platform
      [media] af9035: register it9133 tuner using platform binding
      [media] it913x: add chip device ids for binding
      [media] af9035: correct demod i2c addresses
      [media] af9033: estimate cnr from formula
      [media] mt2060: add i2c bindings
      [media] mt2060: add param to split long i2c writes
      [media] zd1301_demod: ZyDAS ZD1301 DVB-T demodulator driver
      [media] MAINTAINERS: add zd1301_demod driver
      [media] zd1301: ZyDAS ZD1301 DVB USB interface driver
      [media] MAINTAINERS: add zd1301 DVB USB interface driver
      [media] mt2060: implement sleep
      [media] MAINTAINERS: remove hd29l2

Antti Seppälä (3):
      [media] rc: rc-ir-raw: Add Manchester encoder (phase encoder) helper
      [media] rc: ir-rc6-decoder: Add encode capability
      [media] rc: nuvoton-cir: Add support wakeup via sysfs filter callback

Arnd Bergmann (6):
      [media] dvb: avoid warning in dvb_net
      [media] s5k4ecgx: select CRC32 helper
      [media] b2c2: use IS_REACHABLE() instead of open-coding it
      [media] dvb-usb-v2: avoid use-after-free
      [media] ttpci: address stringop overflow warning
      [media] zd1301: fix building interface driver without demodulator

Arvind Yadav (1):
      [media] exynos4-is: fimc-is: Unmap region obtained by of_iomap()

Baruch Siach (4):
      [media] ov2659: remove NOP assignment
      [media] adv7170: drop redundant ret local
      [media] v4l2-subdev.h: fix v4l2_subdev_pad_config documentation
      [media] coda: add Freescale firmware compatibility location

Bhumika Goyal (10):
      [media] media: platform: soc_camera_platform : constify v4l2_subdev_* structures
      [media] exynos4-is: constify v4l2_subdev_* structures
      [media] media: platform: xilinx: xilinx-tpg: constify v4l2_subdev_* structures
      [media] drivers: media: i2c: constify v4l2_subdev_* structures
      [media] media: i2c: m5mols: m5mols_core: constify v4l2_subdev_pad_ops structures
      [media] drivers: media: i2c: ak881x: constify v4l2_subdev_* structures
      [media] drivers: media: i2c: ml86v7667: constify v4l2_subdev_* structures
      [media] media: platform: s3c-camif: constify v4l2_subdev_ops structures
      [media] media: pci: constify vb2_ops structure
      [media] media: dvb-frontends: constify vb2_ops structure

Cao jin (1):
      [media] ngene: drop ngene_link_reset()

Christoph Hellwig (1):
      [media] media/cobalt: use pci_irq_allocate_vectors

Christophe JAILLET (2):
      [media] soc-camera: Fix a return value in case of error
      [media] exynos4-is: Add missing 'of_node_put'

Colin Ian King (6):
      [media] dvb-frontends: fix spelling mistake on cx24123_pll_calcutate
      [media] cobalt: fix spelling mistake: "Celcius" -> "Celsius"
      [media] b2c2: fix spelling mistake: "Contunuity" -> "Continuity"
      [media] gp8psk: fix spelling mistake: "firmare" -> "firmware"
      [media] gspca_stv06xx: remove redundant check for err < 0
      [media] saa7164: "first image" should be "second image" in error message

Corentin Labbe (2):
      [media] media: s5p-cec: Remove unneeded linux/miscdevice.h include
      [media] media: s5p-cec: Remove references to non-existent PLAT_S5P symbol

Dan Carpenter (2):
      [media] media: ti-vpe: vpdma: fix a timeout loop
      [media] mantis_dvb: fix some error codes in mantis_dvb_init()

Davidlohr Bueso (1):
      [media] media/usbvision: remove ctrl_urb_wq

Fengguang Wu (1):
      [media] media: fix semicolon.cocci warnings

Guennadi Liakhovetski (3):
      [media] uvcvideo: (cosmetic) Add and use an inline function
      [media] uvcvideo: (cosmetic) Remove a superfluous assignment
      [media] uvcvideo: Fix a wrong macro

Hans Verkuil (9):
      [media] cec: fix report_current_latency
      [media] cec: when canceling a message, don't overwrite old status info
      [media] cec: CEC_MSG_GIVE_FEATURES should abort for CEC version < 2
      [media] cec: update log_addr[] before finishing configuration
      [media] cec: replace cec_report_features by cec_fill_msg_report_features
      [media] cec: move cec_report_phys_addr into cec_config_thread_func
      [media] cec: fix race between configuring and unconfiguring
      [media] gen-errors.rst: document EIO
      [media] v4l2-ctrls.c: add NULL check

Heiner Kallweit (1):
      [media] rc: refactor raw handler kthread

Hugues Fruchet (10):
      [media] Documentation: DT: add bindings for ST DELTA
      [media] ARM: dts: STiH407-family: add DELTA dt node
      [media] ARM: multi_v7_defconfig: enable STMicroelectronics DELTA Support
      [media] MAINTAINERS: add st-delta driver
      [media] st-delta: STiH4xx multi-format video decoder v4l2 driver
      [media] st-delta: add memory allocator helper functions
      [media] st-delta: rpmsg ipc support
      [media] st-delta: EOS (End Of Stream) support
      [media] st-delta: add mjpeg support
      [media] st-delta: debug: trace stream/frame information & summary

Jaejoong Kim (1):
      [media] uvcvideo: Change result code of debugfs_init to void

James Hogan (6):
      [media] rc: rc-ir-raw: Add scancode encoder callback
      [media] rc: rc-ir-raw: Add pulse-distance modulation helper
      [media] rc: ir-rc5-decoder: Add encode capability
      [media] rc: ir-nec-decoder: Add encode capability
      [media] rc: rc-core: Add support for encode_wakeup drivers
      [media] rc: rc-loopback: Add loopback of filter scancodes

Javi Merino (1):
      [media] v4l: async: make v4l2 coexist with devicetree nodes in a dt overlay

Javier Martinez Canillas (2):
      [media] exynos-gsc: Fix unbalanced pm_runtime_enable() error
      [media] exynos-gsc: Avoid spamming the log on VIDIOC_TRY_FMT

Jean-Christophe Trotin (2):
      [media] st-hva: encoding summary at instance release
      [media] st-hva: add debug file system

Kees Cook (2):
      [media] mtk-vcodec: use designated initializers
      [media] solo6x10: use designated initializers

Kevin Cheng (2):
      [media] lgdt3306a: support i2c mux for use by em28xx
      [media] em28xx: support for Hauppauge WinTV-dualHD 01595 ATSC/QAM

Kevin Hilman (5):
      [media] davinci: VPIF: fix module loading, init errors
      [media] davinci: vpif_capture: remove hard-coded I2C adapter id
      [media] davinci: vpif_capture: fix start/stop streaming locking
      [media] dt-bindings: add TI VPIF documentation
      [media] davinci: VPIF: add basic support for DT init

Lars-Peter Clausen (1):
      [media] adv7604: Initialize drive strength to default when using DT

Laurent Pinchart (6):
      [media] v4l: tvp5150: Reset device at probe time, not in get/set format handlers
      [media] v4l: tvp5150: Fix comment regarding output pin muxing
      [media] v4l: tvp5150: Don't override output pinmuxing at stream on/off time
      [media] v4l: mt9v032: Remove unneeded gpiod NULL check
      [media] v4l: vsp1: Add VIDIOC_EXPBUF support
      [media] v4l: subdev: Clean up properly in subdev devnode registration error path

Lubomir Rintel (1):
      [media] usbtv: add sharpness control

Marcel Hasler (3):
      [media] stk1160: Remove stk1160-mixer and setup internal AC97 codec automatically
      [media] stk1160: Check whether to use AC97 codec
      [media] stk1160: Wait for completion of transfers to and from AC97 codec

Marek Szyprowski (1):
      [media] media: exynos4-is: add flags to dummy Exynos IS i2c adapter

Markus Elfring (5):
      [media] v4l2-async: Use kmalloc_array() in v4l2_async_notifier_unregister()
      [media] pvrusb2-io: Use kmalloc_array() in pvr2_stream_buffer_count()
      [media] pvrusb2-io: Add some spaces for better code readability
      [media] bt8xx: Delete two error messages for a failed memory allocation
      [media] bt8xx: Delete unnecessary variable initialisations in ca_send_message()

Martin Blumenstingl (3):
      [media] rc/keymaps: add a keytable for the GeekBox remote control
      [media] Documentation: devicetree: meson-ir: "linux,rc-map-name" is supported
      [media] Documentation: devicetree: add the RC map name of the geekbox remote

Martin Wache (1):
      [media] dib7000p: avoid division by zero

Matej Hulín (1):
      [media] media: radio-cadet, initialize timer with setup_timer

Mats Randgaard (3):
      [media] tc358743: Do not read number of CSI lanes in use from chip
      [media] tc358743: Disable HDCP with "manual HDCP authentication" bit
      [media] tc358743: ctrl_detect_tx_5v should always be updated

Mauro Carvalho Chehab (10):
      Merge tag 'v4.10-rc1' into patchwork
      [media] coda/imx-vdoa: constify structs
      Revert "[media] coda/imx-vdoa: constify structs"
      [media] st-hva: hva_dbg_summary() should be static
      [media] ivtv: prepare to convert to pr_foo()
      [media] ivtv: use pr_foo() instead of calling printk() directly
      [media] ivtv: mark DVB "borrowed" ioctls as deprecated
      [media] stk1160: make some functions static
      [media] dvb-usb: don't use stack for firmware load
      [media] coda/imx-vdoa: constify structs

Max Kellermann (1):
      [media] pctv452e: move buffer to heap, no mutex

Michael Tretter (3):
      [media] coda: fix frame index to returned error
      [media] coda: use VDOA for un-tiling custom macroblock format
      [media] coda: support YUYV output if VDOA is used

Minghsiu Tsai (1):
      [media] mtk-vcodec: fix build warnings without DEBUG

Nicholas Mc Guire (2):
      [media] ov9650: use msleep() for uncritical long delay
      [media] m5mols: set usleep_range delta greater 0

Nicolas Iooss (3):
      [media] am437x-vpfe: always assign bpp variable
      [media] tw686x: silent -Wformat-security warning
      [media] v4l: rcar_fdp1: use %4.4s to format a 4-byte string

Niels Ole Salscheider (1):
      [media] cx23885: attach md88ds3103 driver via i2c_client for DVBSky S952

Niklas Söderlund (1):
      [media] v4l: of: check for unique lanes in data-lanes and clock-lanes

Oleh Kravchenko (2):
      [media] cx231xx: Initial support Evromedia USB Full Hybrid Full HD
      [media] cx231xx: Fix I2C on Internal Master 3 Bus

Pan Bian (2):
      [media] media: platform: sti: return -ENOMEM on errors
      [media] media: pci: meye: set error code on failures

Pavel Machek (4):
      [media] Add maintainers for camera on N900
      [media] media: et8ek8: add device tree binding documentation
      [media] media: Driver for Toshiba et8ek8 5MP sensor
      [media] mark myself as mainainer for camera on N900

Philipp Zabel (4):
      [media] dt-bindings: Add a binding for Video Data Order Adapter
      [media] coda: add i.MX6 VDOA driver
      [media] coda: correctly set capture compose rectangle
      [media] coda: add debug output about tiling

Piotr Oleszczyk (1):
      [media] add Hama Hybrid DVB-T Stick support

Randy Dunlap (1):
      [media] media: fix dm1105.c build error

Rasmus Villemoes (4):
      [media] lmedm04: use %phN for hex dump
      [media] lmedm04: change some static variables to automatic
      [media] lmedm04: make some string arrays static
      [media] lmedm04: make lme2510_powerup a little smaller

Sakari Ailus (14):
      [media] smiapp: Implement power-on and power-off sequences without runtime PM
      [media] smiapp: Make suspend and resume functions __maybe_unused
      [media] media: Properly pass through media entity types in entity enumeration
      [media] media: Drop FSF's postal address from the source code files
      [media] media: entity: Fix stream count check
      [media] media: entity: Be vocal about failing sanity checks
      [media] media: Rename graph and pipeline structs and functions
      [media] media: entity: Split graph walk iteration into two functions
      [media] media: Use single quotes to quote entity names
      [media] media: entity: Add debug information to graph walk
      [media] omap3isp: Use a local media device pointer instead
      [media] xilinx: Use a local media device pointer instead
      [media] davinci: Use a local media device pointer instead
      [media] et8ek8: Fix compiler / Coccinelle warnings

Santosh Kumar Singh (5):
      [media] vim2m: Clean up file handle in open() error path
      [media] zoran: Clean up file handle in open() error path
      [media] tm6000: Clean up file handle in open() error path
      [media] ivtv: Clean up file handle in open() error path
      [media] pvrusb2: Clean up file handle in open() error path

Scott Matheina (2):
      [media] staging/s5p-cec: fixed alignment should match open parenthesis
      [media] staging/media/s5p-cec/exynos_hdmi_cecctrl.c Fixed blank line before closing brace '}'

Sean Wang (3):
      [media] rc: add driver for IR remote receiver on MT7623 SoC
      [media] Documentation: devicetree: move shared property used by rc into a common place
      [media] Documentation: devicetree: Add document bindings for mtk-cir

Sean Young (30):
      [media] cxusb: port to rc-core
      [media] mceusb: LIRC_SET_SEND_CARRIER returns 0 on success
      [media] lirc_dev: LIRC_{G,S}ET_REC_MODE do not work
      [media] lirc: LIRC_{G,S}ET_SEND_MODE fail if device cannot transmit
      [media] em28xx: IR protocol not reported correctly
      [media] serial_ir: generate timeout
      [media] rc: allow software timeout to be set
      [media] rc5x: 6th command bit is S2 bit
      [media] rc5x: document that this is the 20 bit variant
      [media] rc: change wakeup_protocols to list all protocol variants
      [media] rc: Add scancode validation
      [media] rc: unify nec32 protocol scancode format
      [media] winbond-cir: use sysfs wakeup filter
      [media] rc: raw IR drivers cannot handle cec, unknown or other
      [media] rc: ir-jvc-decoder: Add encode capability
      [media] rc: ir-sanyo-decoder: Add encode capability
      [media] rc: ir-sharp-decoder: Add encode capability
      [media] rc: ir-sony-decoder: Add encode capability
      [media] ir-rx51: port to rc-core
      [media] staging: lirc_sir: port to rc-core
      [media] staging: lirc_parallel: remove
      [media] staging: lirc_bt829: remove
      [media] staging: lirc_imon: port remaining usb ids to imon and remove
      [media] rx51: broken build
      [media] lirc: fix transmit-only read features
      [media] rc: remove excessive spaces from error message
      [media] lirc: LIRC_GET_MIN_TIMEOUT should be in range
      [media] lirc: fix null dereference for tx-only devices
      [media] lirc: cannot read from tx-only device
      [media] mce_kbd: add missing keys from UK layout

Shailendra Verma (5):
      [media] exynos4-is: Clean up file handle in open() error path
      [media] exynos-gsc: Clean up file handle in open() error path
      [media] v4l: omap3isp: Clean up file handle in open() and release()
      [media] v4l: omap4iss: Clean up file handle in open() and release()
      [media] Staging: media: platform: davinci: - Fix for memory leak

Shuah Khan (1):
      [media] media: Protect enable_source and disable_source handler code paths

Shyam Saini (1):
      [media] media: usb: cpia2: Use kmemdup instead of kmalloc and memcpy

Soren Brinkmann (1):
      [media] vivid: Enable 4k resolution for webcam capture device

Stefan Brüns (1):
      [media] cxusb: Use a dma capable buffer also for reading

Sudip Mukherjee (1):
      [media] bt8xx: fix memory leak

Tiffany Lin (1):
      [media] mtk-vcodec: use V4L2_DEC_CMD_STOP to implement flush

Tuukka Toivonen (1):
      [media] v4l2-async: failing functions shouldn't have side effects

Wei Yongjun (2):
      [media] tm6000: fix typo in parameter description
      [media] gp8psk: make local symbol gp8psk_fe_ops static

devendra sharma (1):
      [media] media: dvb: dmx: fixed coding style issues of spacing

 Documentation/ABI/testing/sysfs-class-rc           |   14 +-
 .../devicetree/bindings/leds/irled/spi-ir-led.txt  |   29 +
 .../devicetree/bindings/media/fsl-vdoa.txt         |   21 +
 .../devicetree/bindings/media/gpio-ir-receiver.txt |    3 +-
 .../devicetree/bindings/media/hix5hd2-ir.txt       |    2 +-
 .../bindings/media/i2c/toshiba,et8ek8.txt          |   48 +
 .../devicetree/bindings/media/meson-ir.txt         |    3 +
 .../devicetree/bindings/media/mtk-cir.txt          |   24 +
 Documentation/devicetree/bindings/media/rc.txt     |  117 ++
 .../devicetree/bindings/media/st,st-delta.txt      |   17 +
 .../devicetree/bindings/media/sunxi-ir.txt         |    2 +-
 .../devicetree/bindings/media/ti,da850-vpif.txt    |   83 +
 Documentation/media/kapi/mc-core.rst               |   18 +-
 Documentation/media/uapi/gen-errors.rst            |   10 +-
 Documentation/media/uapi/rc/rc-sysfs-nodes.rst     |   13 +-
 MAINTAINERS                                        |   52 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |    2 +
 arch/arm/boot/dts/stih407-family.dtsi              |   10 +
 arch/arm/configs/multi_v7_defconfig                |    1 +
 arch/arm/mach-omap2/pdata-quirks.c                 |   10 +-
 drivers/hid/hid-picolcd_cir.c                      |    5 +-
 drivers/media/cec/cec-adap.c                       |  103 +-
 drivers/media/cec/cec-core.c                       |    3 +-
 drivers/media/common/b2c2/flexcop-fe-tuner.c       |    3 +-
 drivers/media/common/b2c2/flexcop.c                |    4 -
 drivers/media/common/cx2341x.c                     |    4 -
 drivers/media/common/siano/sms-cards.c             |    4 -
 drivers/media/common/siano/sms-cards.h             |    4 -
 drivers/media/common/siano/smscoreapi.c            |    4 -
 drivers/media/common/siano/smsir.c                 |    5 +-
 drivers/media/common/tveeprom.c                    |    4 -
 drivers/media/dvb-core/demux.h                     |    4 -
 drivers/media/dvb-core/dmxdev.c                    |   16 +-
 drivers/media/dvb-core/dmxdev.h                    |    4 -
 drivers/media/dvb-core/dvb-usb-ids.h               |    5 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |    7 +-
 drivers/media/dvb-core/dvb_demux.c                 |    4 -
 drivers/media/dvb-core/dvb_demux.h                 |    4 -
 drivers/media/dvb-core/dvb_frontend.c              |   31 +-
 drivers/media/dvb-core/dvb_math.c                  |    4 -
 drivers/media/dvb-core/dvb_math.h                  |    4 -
 drivers/media/dvb-core/dvb_net.c                   |   22 +-
 drivers/media/dvb-core/dvb_net.h                   |    4 -
 drivers/media/dvb-core/dvb_ringbuffer.c            |    4 -
 drivers/media/dvb-core/dvbdev.c                    |    4 -
 drivers/media/dvb-core/dvbdev.h                    |    4 -
 drivers/media/dvb-frontends/Kconfig                |   17 +-
 drivers/media/dvb-frontends/Makefile               |    2 +-
 drivers/media/dvb-frontends/af9013.c               |    4 -
 drivers/media/dvb-frontends/af9013.h               |    4 -
 drivers/media/dvb-frontends/af9013_priv.h          |    4 -
 drivers/media/dvb-frontends/af9033.c               |  837 ++++----
 drivers/media/dvb-frontends/af9033.h               |   13 +-
 drivers/media/dvb-frontends/af9033_priv.h          |  185 +-
 drivers/media/dvb-frontends/atbm8830.c             |    4 -
 drivers/media/dvb-frontends/atbm8830.h             |    4 -
 drivers/media/dvb-frontends/atbm8830_priv.h        |    4 -
 drivers/media/dvb-frontends/au8522_decoder.c       |    5 -
 drivers/media/dvb-frontends/bcm3510.h              |    4 -
 drivers/media/dvb-frontends/bcm3510_priv.h         |    4 -
 drivers/media/dvb-frontends/bsbe1-d01a.h           |    7 +-
 drivers/media/dvb-frontends/bsbe1.h                |    7 +-
 drivers/media/dvb-frontends/bsru6.h                |    7 +-
 drivers/media/dvb-frontends/cx24113.c              |    4 -
 drivers/media/dvb-frontends/cx24113.h              |    4 -
 drivers/media/dvb-frontends/cx24123.c              |    6 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |    2 +-
 drivers/media/dvb-frontends/dib0070.c              |    4 -
 drivers/media/dvb-frontends/dib0090.c              |    4 -
 drivers/media/dvb-frontends/dib7000p.c             |   15 +-
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    |    4 -
 drivers/media/dvb-frontends/drxd.h                 |    8 +-
 drivers/media/dvb-frontends/drxd_firm.c            |    8 +-
 drivers/media/dvb-frontends/drxd_firm.h            |    8 +-
 drivers/media/dvb-frontends/drxd_hard.c            |    8 +-
 drivers/media/dvb-frontends/drxd_map_firm.h        |    8 +-
 drivers/media/dvb-frontends/drxk_hard.c            |    8 +-
 drivers/media/dvb-frontends/dvb-pll.c              |    4 -
 drivers/media/dvb-frontends/dvb_dummy_fe.c         |    4 -
 drivers/media/dvb-frontends/dvb_dummy_fe.h         |    4 -
 drivers/media/dvb-frontends/ec100.c                |    4 -
 drivers/media/dvb-frontends/ec100.h                |    4 -
 drivers/media/dvb-frontends/hd29l2.c               |  870 ---------
 drivers/media/dvb-frontends/hd29l2.h               |   65 -
 drivers/media/dvb-frontends/hd29l2_priv.h          |  301 ---
 drivers/media/dvb-frontends/isl6405.c              |    7 +-
 drivers/media/dvb-frontends/isl6405.h              |    7 +-
 drivers/media/dvb-frontends/isl6421.c              |    7 +-
 drivers/media/dvb-frontends/isl6421.h              |    7 +-
 drivers/media/dvb-frontends/itd1000.c              |    4 -
 drivers/media/dvb-frontends/itd1000.h              |    4 -
 drivers/media/dvb-frontends/itd1000_priv.h         |    4 -
 drivers/media/dvb-frontends/ix2505v.c              |    4 -
 drivers/media/dvb-frontends/ix2505v.h              |    4 -
 drivers/media/dvb-frontends/lg2160.c               |    4 -
 drivers/media/dvb-frontends/lg2160.h               |    4 -
 drivers/media/dvb-frontends/lgdt3305.c             |    4 -
 drivers/media/dvb-frontends/lgdt3305.h             |    4 -
 drivers/media/dvb-frontends/lgdt3306a.c            |  108 ++
 drivers/media/dvb-frontends/lgdt3306a.h            |    4 +
 drivers/media/dvb-frontends/lgdt330x.c             |    4 -
 drivers/media/dvb-frontends/lgdt330x.h             |    4 -
 drivers/media/dvb-frontends/lgdt330x_priv.h        |    4 -
 drivers/media/dvb-frontends/lgs8gxx.c              |    4 -
 drivers/media/dvb-frontends/lgs8gxx.h              |    4 -
 drivers/media/dvb-frontends/lgs8gxx_priv.h         |    4 -
 drivers/media/dvb-frontends/lnbh24.h               |    4 -
 drivers/media/dvb-frontends/lnbp21.c               |    7 +-
 drivers/media/dvb-frontends/lnbp21.h               |    7 +-
 drivers/media/dvb-frontends/lnbp22.c               |    7 +-
 drivers/media/dvb-frontends/lnbp22.h               |    7 +-
 drivers/media/dvb-frontends/mn88473.c              |   10 +-
 drivers/media/dvb-frontends/mt352.c                |    4 -
 drivers/media/dvb-frontends/mt352.h                |    4 -
 drivers/media/dvb-frontends/mt352_priv.h           |    4 -
 drivers/media/dvb-frontends/nxt200x.c              |    4 -
 drivers/media/dvb-frontends/nxt200x.h              |    4 -
 drivers/media/dvb-frontends/or51132.c              |    4 -
 drivers/media/dvb-frontends/or51132.h              |    4 -
 drivers/media/dvb-frontends/or51211.c              |    4 -
 drivers/media/dvb-frontends/or51211.h              |    4 -
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    2 +-
 drivers/media/dvb-frontends/s5h1420.c              |    4 -
 drivers/media/dvb-frontends/s5h1420.h              |    4 -
 drivers/media/dvb-frontends/s5h1432.c              |    4 -
 drivers/media/dvb-frontends/s5h1432.h              |    4 -
 drivers/media/dvb-frontends/si2168.c               |   70 +-
 drivers/media/dvb-frontends/si2168_priv.h          |    1 +
 drivers/media/dvb-frontends/stv0367.c              |    4 -
 drivers/media/dvb-frontends/stv0367.h              |    4 -
 drivers/media/dvb-frontends/stv0367_priv.h         |    4 -
 drivers/media/dvb-frontends/stv0367_regs.h         |    4 -
 drivers/media/dvb-frontends/stv0900.h              |    4 -
 drivers/media/dvb-frontends/stv0900_core.c         |    4 -
 drivers/media/dvb-frontends/stv0900_init.h         |    4 -
 drivers/media/dvb-frontends/stv0900_priv.h         |    4 -
 drivers/media/dvb-frontends/stv0900_reg.h          |    4 -
 drivers/media/dvb-frontends/stv0900_sw.c           |    4 -
 drivers/media/dvb-frontends/stv6110.c              |    4 -
 drivers/media/dvb-frontends/stv6110.h              |    4 -
 drivers/media/dvb-frontends/tda18271c2dd.c         |    8 +-
 drivers/media/dvb-frontends/tdhd1.h                |    7 +-
 drivers/media/dvb-frontends/tua6100.c              |    4 -
 drivers/media/dvb-frontends/tua6100.h              |    4 -
 drivers/media/dvb-frontends/zd1301_demod.c         |  551 ++++++
 drivers/media/dvb-frontends/zd1301_demod.h         |   73 +
 drivers/media/dvb-frontends/zl10036.c              |    4 -
 drivers/media/dvb-frontends/zl10036.h              |    4 -
 drivers/media/dvb-frontends/zl10039.c              |    4 -
 drivers/media/dvb-frontends/zl10353.c              |    4 -
 drivers/media/dvb-frontends/zl10353.h              |    4 -
 drivers/media/dvb-frontends/zl10353_priv.h         |    4 -
 drivers/media/i2c/Kconfig                          |    2 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/adp1653.c                        |    5 -
 drivers/media/i2c/adv7170.c                        |    9 +-
 drivers/media/i2c/adv7175.c                        |    4 -
 drivers/media/i2c/adv7180.c                        |    4 -
 drivers/media/i2c/adv7183.c                        |    4 -
 drivers/media/i2c/adv7183_regs.h                   |    4 -
 drivers/media/i2c/adv7604.c                        |    3 +
 drivers/media/i2c/ak881x.c                         |    6 +-
 drivers/media/i2c/aptina-pll.c                     |    5 -
 drivers/media/i2c/aptina-pll.h                     |    5 -
 drivers/media/i2c/as3645a.c                        |    5 -
 drivers/media/i2c/bt819.c                          |    4 -
 drivers/media/i2c/bt856.c                          |    4 -
 drivers/media/i2c/cs5345.c                         |    4 -
 drivers/media/i2c/cs53l32a.c                       |    4 -
 drivers/media/i2c/cx25840/cx25840-audio.c          |    4 -
 drivers/media/i2c/cx25840/cx25840-core.c           |    4 -
 drivers/media/i2c/cx25840/cx25840-core.h           |    4 -
 drivers/media/i2c/cx25840/cx25840-firmware.c       |    4 -
 drivers/media/i2c/cx25840/cx25840-ir.c             |    5 -
 drivers/media/i2c/cx25840/cx25840-vbi.c            |    4 -
 drivers/media/i2c/et8ek8/Kconfig                   |    6 +
 drivers/media/i2c/et8ek8/Makefile                  |    2 +
 drivers/media/i2c/et8ek8/et8ek8_driver.c           | 1514 +++++++++++++++
 drivers/media/i2c/et8ek8/et8ek8_mode.c             |  587 ++++++
 drivers/media/i2c/et8ek8/et8ek8_reg.h              |   96 +
 drivers/media/i2c/ir-kbd-i2c.c                     |    6 +-
 drivers/media/i2c/ks0127.c                         |    4 -
 drivers/media/i2c/ks0127.h                         |    4 -
 drivers/media/i2c/m52790.c                         |    4 -
 drivers/media/i2c/m5mols/m5mols_core.c             |    7 +-
 drivers/media/i2c/ml86v7667.c                      |    6 +-
 drivers/media/i2c/msp3400-driver.c                 |    5 -
 drivers/media/i2c/msp3400-kthreads.c               |    5 -
 drivers/media/i2c/mt9m032.c                        |    5 -
 drivers/media/i2c/mt9p031.c                        |    8 +-
 drivers/media/i2c/mt9v032.c                        |   11 +-
 drivers/media/i2c/noon010pc30.c                    |    4 +-
 drivers/media/i2c/ov2659.c                         |    1 -
 drivers/media/i2c/ov7640.c                         |    4 -
 drivers/media/i2c/ov9650.c                         |    4 +-
 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c          |    2 +-
 drivers/media/i2c/s5k6a3.c                         |    6 +-
 drivers/media/i2c/saa7110.c                        |    4 -
 drivers/media/i2c/saa7115.c                        |    4 -
 drivers/media/i2c/saa7127.c                        |    4 -
 drivers/media/i2c/saa717x.c                        |    4 -
 drivers/media/i2c/saa7185.c                        |    4 -
 drivers/media/i2c/smiapp/smiapp-core.c             |   33 +-
 drivers/media/i2c/soc_camera/ov9640.c              |    2 +-
 drivers/media/i2c/sony-btf-mpx.c                   |    4 -
 drivers/media/i2c/tc358743.c                       |   47 +-
 drivers/media/i2c/tc358743_regs.h                  |    1 +
 drivers/media/i2c/tlv320aic23b.c                   |    4 -
 drivers/media/i2c/tvp514x.c                        |    4 -
 drivers/media/i2c/tvp514x_regs.h                   |    4 -
 drivers/media/i2c/tvp5150.c                        |   56 +-
 drivers/media/i2c/tvp5150_reg.h                    |    9 +
 drivers/media/i2c/tvp7002.c                        |    4 -
 drivers/media/i2c/tvp7002_reg.h                    |    4 -
 drivers/media/i2c/tw2804.c                         |    4 -
 drivers/media/i2c/tw9903.c                         |    4 -
 drivers/media/i2c/tw9906.c                         |    4 -
 drivers/media/i2c/uda1342.c                        |    4 -
 drivers/media/i2c/upd64031a.c                      |    4 -
 drivers/media/i2c/upd64083.c                       |    5 -
 drivers/media/i2c/vp27smpx.c                       |    4 -
 drivers/media/i2c/vpx3220.c                        |    4 -
 drivers/media/i2c/vs6624.c                         |    4 -
 drivers/media/i2c/vs6624_regs.h                    |    4 -
 drivers/media/i2c/wm8739.c                         |    4 -
 drivers/media/i2c/wm8775.c                         |    4 -
 drivers/media/media-device.c                       |   14 +-
 drivers/media/media-devnode.c                      |    4 -
 drivers/media/media-entity.c                       |  166 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |    2 +-
 drivers/media/pci/bt8xx/bttv-input.c               |    6 +-
 drivers/media/pci/bt8xx/dst_ca.c                   |   11 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c                |    5 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.h                |    4 -
 drivers/media/pci/cobalt/cobalt-cpld.c             |    4 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |    8 +-
 drivers/media/pci/cobalt/cobalt-driver.h           |    2 -
 drivers/media/pci/cx18/cx18-alsa-main.c            |    5 -
 drivers/media/pci/cx18/cx18-alsa-mixer.c           |    5 -
 drivers/media/pci/cx18/cx18-alsa-mixer.h           |    5 -
 drivers/media/pci/cx18/cx18-alsa-pcm.c             |    5 -
 drivers/media/pci/cx18/cx18-alsa-pcm.h             |    5 -
 drivers/media/pci/cx18/cx18-alsa.h                 |    5 -
 drivers/media/pci/cx18/cx18-audio.c                |    5 -
 drivers/media/pci/cx18/cx18-audio.h                |    5 -
 drivers/media/pci/cx18/cx18-av-audio.c             |    5 -
 drivers/media/pci/cx18/cx18-av-core.c              |    5 -
 drivers/media/pci/cx18/cx18-av-core.h              |    5 -
 drivers/media/pci/cx18/cx18-av-firmware.c          |    5 -
 drivers/media/pci/cx18/cx18-av-vbi.c               |    5 -
 drivers/media/pci/cx18/cx18-cards.c                |    5 -
 drivers/media/pci/cx18/cx18-cards.h                |    4 -
 drivers/media/pci/cx18/cx18-controls.c             |    5 -
 drivers/media/pci/cx18/cx18-driver.c               |    5 -
 drivers/media/pci/cx18/cx18-driver.h               |    5 -
 drivers/media/pci/cx18/cx18-dvb.c                  |    4 -
 drivers/media/pci/cx18/cx18-dvb.h                  |    4 -
 drivers/media/pci/cx18/cx18-fileops.c              |    5 -
 drivers/media/pci/cx18/cx18-fileops.h              |    5 -
 drivers/media/pci/cx18/cx18-firmware.c             |    5 -
 drivers/media/pci/cx18/cx18-firmware.h             |    5 -
 drivers/media/pci/cx18/cx18-gpio.c                 |    5 -
 drivers/media/pci/cx18/cx18-gpio.h                 |    4 -
 drivers/media/pci/cx18/cx18-i2c.c                  |    5 -
 drivers/media/pci/cx18/cx18-i2c.h                  |    5 -
 drivers/media/pci/cx18/cx18-io.c                   |    5 -
 drivers/media/pci/cx18/cx18-io.h                   |    5 -
 drivers/media/pci/cx18/cx18-ioctl.c                |    5 -
 drivers/media/pci/cx18/cx18-ioctl.h                |    5 -
 drivers/media/pci/cx18/cx18-irq.c                  |    5 -
 drivers/media/pci/cx18/cx18-irq.h                  |    5 -
 drivers/media/pci/cx18/cx18-mailbox.c              |    5 -
 drivers/media/pci/cx18/cx18-mailbox.h              |    5 -
 drivers/media/pci/cx18/cx18-queue.c                |    5 -
 drivers/media/pci/cx18/cx18-queue.h                |    5 -
 drivers/media/pci/cx18/cx18-scb.c                  |    5 -
 drivers/media/pci/cx18/cx18-scb.h                  |    5 -
 drivers/media/pci/cx18/cx18-streams.c              |    5 -
 drivers/media/pci/cx18/cx18-streams.h              |    5 -
 drivers/media/pci/cx18/cx18-vbi.c                  |    5 -
 drivers/media/pci/cx18/cx18-vbi.h                  |    5 -
 drivers/media/pci/cx18/cx18-version.h              |    5 -
 drivers/media/pci/cx18/cx18-video.c                |    5 -
 drivers/media/pci/cx18/cx18-video.h                |    5 -
 drivers/media/pci/cx18/cx23418.h                   |    5 -
 drivers/media/pci/cx23885/cx23885-dvb.c            |   54 +-
 drivers/media/pci/cx23885/cx23885-input.c          |   25 +-
 drivers/media/pci/cx25821/cx25821-alsa.c           |    4 -
 drivers/media/pci/cx25821/cx25821-audio-upstream.c |    4 -
 drivers/media/pci/cx25821/cx25821-audio-upstream.h |    4 -
 drivers/media/pci/cx25821/cx25821-audio.h          |    4 -
 drivers/media/pci/cx25821/cx25821-biffuncs.h       |    4 -
 drivers/media/pci/cx25821/cx25821-cards.c          |    4 -
 drivers/media/pci/cx25821/cx25821-core.c           |    4 -
 drivers/media/pci/cx25821/cx25821-gpio.c           |    4 -
 drivers/media/pci/cx25821/cx25821-i2c.c            |    4 -
 drivers/media/pci/cx25821/cx25821-medusa-defines.h |    4 -
 drivers/media/pci/cx25821/cx25821-medusa-reg.h     |    4 -
 drivers/media/pci/cx25821/cx25821-medusa-video.c   |    4 -
 drivers/media/pci/cx25821/cx25821-medusa-video.h   |    4 -
 drivers/media/pci/cx25821/cx25821-reg.h            |    4 -
 drivers/media/pci/cx25821/cx25821-sram.h           |    4 -
 drivers/media/pci/cx25821/cx25821-video-upstream.c |    4 -
 drivers/media/pci/cx25821/cx25821-video-upstream.h |    4 -
 drivers/media/pci/cx25821/cx25821-video.c          |    4 -
 drivers/media/pci/cx25821/cx25821-video.h          |    4 -
 drivers/media/pci/cx25821/cx25821.h                |    4 -
 drivers/media/pci/cx88/cx88-input.c                |    3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |    8 +-
 drivers/media/pci/ddbridge/ddbridge-regs.h         |    8 +-
 drivers/media/pci/ddbridge/ddbridge.h              |    8 +-
 drivers/media/pci/dm1105/Kconfig                   |    2 +-
 drivers/media/pci/dm1105/dm1105.c                  |    7 +-
 drivers/media/pci/ivtv/Kconfig                     |   13 +
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |   31 +-
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c           |   18 +-
 drivers/media/pci/ivtv/ivtv-alsa-mixer.h           |    5 -
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |   21 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h             |    5 -
 drivers/media/pci/ivtv/ivtv-alsa.h                 |    5 -
 drivers/media/pci/ivtv/ivtv-driver.c               |   12 +-
 drivers/media/pci/ivtv/ivtv-driver.h               |   37 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |   49 +-
 drivers/media/pci/ivtv/ivtv-mailbox.c              |    4 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |   23 +-
 drivers/media/pci/mantis/mantis_dvb.c              |    5 +-
 drivers/media/pci/mantis/mantis_input.c            |    2 +-
 drivers/media/pci/meye/meye.c                      |    5 +-
 drivers/media/pci/meye/meye.h                      |    4 -
 drivers/media/pci/ngene/ngene-cards.c              |   15 +-
 drivers/media/pci/ngene/ngene-core.c               |    8 +-
 drivers/media/pci/ngene/ngene-dvb.c                |    8 +-
 drivers/media/pci/ngene/ngene-i2c.c                |    8 +-
 drivers/media/pci/ngene/ngene.h                    |    8 +-
 drivers/media/pci/pluto2/pluto2.c                  |    4 -
 drivers/media/pci/pt1/pt1.c                        |    4 -
 drivers/media/pci/pt1/va1j5jf8007s.c               |    4 -
 drivers/media/pci/pt1/va1j5jf8007s.h               |    4 -
 drivers/media/pci/pt1/va1j5jf8007t.c               |    4 -
 drivers/media/pci/pt1/va1j5jf8007t.h               |    4 -
 drivers/media/pci/saa7134/saa7134-alsa.c           |    4 -
 drivers/media/pci/saa7134/saa7134-cards.c          |    4 -
 drivers/media/pci/saa7134/saa7134-core.c           |    4 -
 drivers/media/pci/saa7134/saa7134-dvb.c            |    4 -
 drivers/media/pci/saa7134/saa7134-empress.c        |    4 -
 drivers/media/pci/saa7134/saa7134-i2c.c            |    4 -
 drivers/media/pci/saa7134/saa7134-input.c          |    6 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |    4 -
 drivers/media/pci/saa7134/saa7134-tvaudio.c        |    4 -
 drivers/media/pci/saa7134/saa7134-vbi.c            |    4 -
 drivers/media/pci/saa7134/saa7134-video.c          |    4 -
 drivers/media/pci/saa7134/saa7134.h                |    4 -
 drivers/media/pci/saa7164/saa7164-api.c            |    4 -
 drivers/media/pci/saa7164/saa7164-buffer.c         |    4 -
 drivers/media/pci/saa7164/saa7164-bus.c            |    4 -
 drivers/media/pci/saa7164/saa7164-cards.c          |    4 -
 drivers/media/pci/saa7164/saa7164-cmd.c            |    4 -
 drivers/media/pci/saa7164/saa7164-core.c           |    4 -
 drivers/media/pci/saa7164/saa7164-dvb.c            |    4 -
 drivers/media/pci/saa7164/saa7164-encoder.c        |    4 -
 drivers/media/pci/saa7164/saa7164-fw.c             |    6 +-
 drivers/media/pci/saa7164/saa7164-i2c.c            |    4 -
 drivers/media/pci/saa7164/saa7164-reg.h            |    4 -
 drivers/media/pci/saa7164/saa7164-types.h          |    4 -
 drivers/media/pci/saa7164/saa7164-vbi.c            |    4 -
 drivers/media/pci/saa7164/saa7164.h                |    4 -
 drivers/media/pci/smipcie/smipcie-ir.c             |    3 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c         |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.h            |    4 -
 drivers/media/pci/ttpci/av7110.c                   |    7 +-
 drivers/media/pci/ttpci/av7110_av.c                |    7 +-
 drivers/media/pci/ttpci/av7110_ca.c                |    7 +-
 drivers/media/pci/ttpci/av7110_hw.c                |   15 +-
 drivers/media/pci/ttpci/av7110_hw.h                |   12 +-
 drivers/media/pci/ttpci/av7110_ir.c                |    7 +-
 drivers/media/pci/ttpci/av7110_v4l.c               |    7 +-
 drivers/media/pci/ttpci/budget-av.c                |    7 +-
 drivers/media/pci/ttpci/budget-ci.c                |    9 +-
 drivers/media/pci/ttpci/budget-core.c              |    7 +-
 drivers/media/pci/ttpci/budget-patch.c             |    7 +-
 drivers/media/pci/ttpci/budget.c                   |    7 +-
 drivers/media/pci/ttpci/dvb_filter.h               |    4 -
 drivers/media/pci/tw686x/tw686x-core.c             |    2 +-
 drivers/media/pci/zoran/videocodec.c               |    4 -
 drivers/media/pci/zoran/videocodec.h               |    4 -
 drivers/media/pci/zoran/zoran.h                    |    4 -
 drivers/media/pci/zoran/zoran_card.c               |    4 -
 drivers/media/pci/zoran/zoran_card.h               |    4 -
 drivers/media/pci/zoran/zoran_device.c             |    4 -
 drivers/media/pci/zoran/zoran_device.h             |    4 -
 drivers/media/pci/zoran/zoran_driver.c             |    5 +-
 drivers/media/pci/zoran/zoran_procfs.c             |    4 -
 drivers/media/pci/zoran/zoran_procfs.h             |    4 -
 drivers/media/pci/zoran/zr36016.c                  |    4 -
 drivers/media/pci/zoran/zr36016.h                  |    4 -
 drivers/media/pci/zoran/zr36050.c                  |    4 -
 drivers/media/pci/zoran/zr36050.h                  |    4 -
 drivers/media/pci/zoran/zr36057.h                  |    4 -
 drivers/media/pci/zoran/zr36060.c                  |    4 -
 drivers/media/pci/zoran/zr36060.h                  |    4 -
 drivers/media/platform/Kconfig                     |   53 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/am437x/am437x-vpfe.c        |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |    4 -
 drivers/media/platform/blackfin/ppi.c              |    4 -
 drivers/media/platform/coda/Makefile               |    1 +
 drivers/media/platform/coda/coda-bit.c             |   93 +-
 drivers/media/platform/coda/coda-common.c          |  181 +-
 drivers/media/platform/coda/coda.h                 |    5 +-
 drivers/media/platform/coda/imx-vdoa.c             |  338 ++++
 drivers/media/platform/coda/imx-vdoa.h             |   58 +
 drivers/media/platform/davinci/ccdc_hw_device.h    |    4 -
 drivers/media/platform/davinci/dm355_ccdc.c        |    4 -
 drivers/media/platform/davinci/dm355_ccdc_regs.h   |    4 -
 drivers/media/platform/davinci/dm644x_ccdc.c       |    4 -
 drivers/media/platform/davinci/dm644x_ccdc_regs.h  |    4 -
 drivers/media/platform/davinci/isif.c              |    4 -
 drivers/media/platform/davinci/isif_regs.h         |    4 -
 drivers/media/platform/davinci/vpbe.c              |    4 -
 drivers/media/platform/davinci/vpbe_osd.c          |    4 -
 drivers/media/platform/davinci/vpbe_osd_regs.h     |    4 -
 drivers/media/platform/davinci/vpbe_venc.c         |    4 -
 drivers/media/platform/davinci/vpbe_venc_regs.h    |    4 -
 drivers/media/platform/davinci/vpfe_capture.c      |    6 +-
 drivers/media/platform/davinci/vpif.c              |   14 +-
 drivers/media/platform/davinci/vpif_capture.c      |   28 +-
 drivers/media/platform/davinci/vpif_capture.h      |    6 +-
 drivers/media/platform/davinci/vpif_display.c      |    6 +
 drivers/media/platform/davinci/vpss.c              |    4 -
 drivers/media/platform/exynos-gsc/gsc-core.c       |    3 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   12 +-
 drivers/media/platform/exynos4-is/fimc-is-i2c.c    |    9 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |    8 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    8 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    8 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   20 +-
 drivers/media/platform/exynos4-is/media-dev.h      |    2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |    8 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  160 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |   14 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |    2 +
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c    |    5 +-
 .../media/platform/mtk-vcodec/venc/venc_h264_if.c  |    8 +-
 .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   |    8 +-
 drivers/media/platform/mtk-vcodec/venc_vpu_if.c    |    4 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   18 +-
 drivers/media/platform/rcar_fdp1.c                 |    4 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    8 +-
 .../platform/soc_camera/soc_camera_platform.c      |    6 +-
 drivers/media/platform/sti/bdisp/bdisp-debug.c     |    2 +-
 drivers/media/platform/sti/delta/Makefile          |    6 +
 drivers/media/platform/sti/delta/delta-cfg.h       |   64 +
 drivers/media/platform/sti/delta/delta-debug.c     |   72 +
 drivers/media/platform/sti/delta/delta-debug.h     |   18 +
 drivers/media/platform/sti/delta/delta-ipc.c       |  594 ++++++
 drivers/media/platform/sti/delta/delta-ipc.h       |   76 +
 drivers/media/platform/sti/delta/delta-mem.c       |   51 +
 drivers/media/platform/sti/delta/delta-mem.h       |   14 +
 drivers/media/platform/sti/delta/delta-mjpeg-dec.c |  455 +++++
 drivers/media/platform/sti/delta/delta-mjpeg-fw.h  |  225 +++
 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c |  149 ++
 drivers/media/platform/sti/delta/delta-mjpeg.h     |   35 +
 drivers/media/platform/sti/delta/delta-v4l2.c      | 1993 ++++++++++++++++++++
 drivers/media/platform/sti/delta/delta.h           |  566 ++++++
 drivers/media/platform/sti/hva/Makefile            |    1 +
 drivers/media/platform/sti/hva/hva-debugfs.c       |  422 +++++
 drivers/media/platform/sti/hva/hva-h264.c          |    6 +
 drivers/media/platform/sti/hva/hva-hw.c            |   48 +
 drivers/media/platform/sti/hva/hva-hw.h            |    3 +
 drivers/media/platform/sti/hva/hva-mem.c           |    5 +-
 drivers/media/platform/sti/hva/hva-v4l2.c          |   78 +-
 drivers/media/platform/sti/hva/hva.h               |   96 +-
 drivers/media/platform/ti-vpe/vpdma.c              |    2 +-
 drivers/media/platform/vim2m.c                     |    2 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |    5 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |    4 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   17 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   16 +-
 drivers/media/platform/xilinx/xilinx-tpg.c         |    8 +-
 drivers/media/radio/dsbr100.c                      |    4 -
 drivers/media/radio/radio-cadet.c                  |    8 +-
 drivers/media/radio/radio-isa.c                    |    5 -
 drivers/media/radio/radio-isa.h                    |    5 -
 drivers/media/radio/radio-keene.c                  |    4 -
 drivers/media/radio/radio-ma901.c                  |    4 -
 drivers/media/radio/radio-mr800.c                  |    4 -
 drivers/media/radio/radio-shark.c                  |    4 -
 drivers/media/radio/radio-shark2.c                 |    4 -
 drivers/media/radio/radio-tea5764.c                |    4 -
 drivers/media/radio/radio-tea5777.c                |    4 -
 drivers/media/radio/radio-tea5777.h                |    4 -
 drivers/media/radio/radio-timb.c                   |    4 -
 drivers/media/radio/radio-wl1273.c                 |    4 -
 drivers/media/radio/saa7706h.c                     |    4 -
 drivers/media/radio/si470x/radio-si470x-common.c   |    4 -
 drivers/media/radio/si470x/radio-si470x-i2c.c      |    4 -
 drivers/media/radio/si470x/radio-si470x-usb.c      |    4 -
 drivers/media/radio/si470x/radio-si470x.h          |    4 -
 drivers/media/radio/si4713/radio-platform-si4713.c |    4 -
 drivers/media/radio/si4713/si4713.c                |    4 -
 drivers/media/radio/tef6862.c                      |    4 -
 drivers/media/radio/wl128x/fmdrv.h                 |    4 -
 drivers/media/radio/wl128x/fmdrv_common.c          |    4 -
 drivers/media/radio/wl128x/fmdrv_common.h          |    4 -
 drivers/media/radio/wl128x/fmdrv_rx.c              |    4 -
 drivers/media/radio/wl128x/fmdrv_rx.h              |    4 -
 drivers/media/radio/wl128x/fmdrv_tx.c              |    4 -
 drivers/media/radio/wl128x/fmdrv_tx.h              |    4 -
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    4 -
 drivers/media/radio/wl128x/fmdrv_v4l2.h            |    4 -
 drivers/media/rc/Kconfig                           |   22 +-
 drivers/media/rc/Makefile                          |    2 +
 drivers/media/rc/ati_remote.c                      |    7 +-
 drivers/media/rc/ene_ir.c                          |   10 +-
 drivers/media/rc/ene_ir.h                          |    5 -
 drivers/media/rc/fintek-cir.c                      |   10 +-
 drivers/media/rc/fintek-cir.h                      |    5 -
 drivers/media/rc/gpio-ir-recv.c                    |    5 +-
 drivers/media/rc/igorplugusb.c                     |    7 +-
 drivers/media/rc/iguanair.c                        |   13 +-
 drivers/media/rc/img-ir/img-ir-hw.c                |   15 +-
 drivers/media/rc/img-ir/img-ir-nec.c               |   21 +-
 drivers/media/rc/img-ir/img-ir-raw.c               |    3 +-
 drivers/media/rc/img-ir/img-ir-sony.c              |   26 +-
 drivers/media/rc/imon.c                            |  138 +-
 drivers/media/rc/ir-hix5hd2.c                      |    5 +-
 drivers/media/rc/ir-jvc-decoder.c                  |   39 +
 drivers/media/rc/ir-lirc-codec.c                   |   17 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |    2 +-
 drivers/media/rc/ir-nec-decoder.c                  |   86 +-
 drivers/media/rc/ir-rc5-decoder.c                  |  105 +-
 drivers/media/rc/ir-rc6-decoder.c                  |  117 ++
 drivers/media/rc/ir-rx51.c                         |  332 ++--
 drivers/media/rc/ir-sanyo-decoder.c                |   43 +
 drivers/media/rc/ir-sharp-decoder.c                |   50 +
 drivers/media/rc/ir-sony-decoder.c                 |   48 +
 drivers/media/rc/ir-spi.c                          |  199 ++
 drivers/media/rc/ite-cir.c                         |   10 +-
 drivers/media/rc/ite-cir.h                         |    5 -
 drivers/media/rc/keymaps/Makefile                  |    4 +
 drivers/media/rc/keymaps/rc-d680-dmb.c             |   75 +
 drivers/media/rc/keymaps/rc-dvico-mce.c            |   85 +
 drivers/media/rc/keymaps/rc-dvico-portable.c       |   76 +
 drivers/media/rc/keymaps/rc-geekbox.c              |   55 +
 drivers/media/rc/keymaps/rc-rc6-mce.c              |    1 +
 drivers/media/rc/keymaps/rc-technisat-usb2.c       |    4 -
 drivers/media/rc/keymaps/rc-tivo.c                 |   86 +-
 drivers/media/rc/lirc_dev.c                        |   13 +-
 drivers/media/rc/mceusb.c                          |   13 +-
 drivers/media/rc/meson-ir.c                        |    5 +-
 drivers/media/rc/mtk-cir.c                         |  335 ++++
 drivers/media/rc/nuvoton-cir.c                     |  130 +-
 drivers/media/rc/nuvoton-cir.h                     |    5 -
 drivers/media/rc/rc-core-priv.h                    |  109 +-
 drivers/media/rc/rc-ir-raw.c                       |  308 ++-
 drivers/media/rc/rc-loopback.c                     |   48 +-
 drivers/media/rc/rc-main.c                         |  527 ++++--
 drivers/media/rc/redrat3.c                         |    9 +-
 drivers/media/rc/serial_ir.c                       |   29 +-
 drivers/media/rc/st_rc.c                           |    5 +-
 drivers/media/rc/streamzap.c                       |    9 +-
 drivers/media/rc/sunxi-cir.c                       |    5 +-
 drivers/media/rc/ttusbir.c                         |   14 +-
 drivers/media/rc/winbond-cir.c                     |  266 +--
 drivers/media/tuners/fc0011.c                      |    4 -
 drivers/media/tuners/fc0012-priv.h                 |    4 -
 drivers/media/tuners/fc0012.c                      |    4 -
 drivers/media/tuners/fc0012.h                      |    4 -
 drivers/media/tuners/fc0013-priv.h                 |    4 -
 drivers/media/tuners/fc0013.c                      |    4 -
 drivers/media/tuners/fc0013.h                      |    4 -
 drivers/media/tuners/fc001x-common.h               |    4 -
 drivers/media/tuners/it913x.c                      |   96 +-
 drivers/media/tuners/it913x.h                      |   30 +-
 drivers/media/tuners/max2165.c                     |    4 -
 drivers/media/tuners/max2165.h                     |    4 -
 drivers/media/tuners/max2165_priv.h                |    4 -
 drivers/media/tuners/mc44s803.c                    |    4 -
 drivers/media/tuners/mc44s803.h                    |    4 -
 drivers/media/tuners/mc44s803_priv.h               |    4 -
 drivers/media/tuners/mt2060.c                      |  129 +-
 drivers/media/tuners/mt2060.h                      |   27 +-
 drivers/media/tuners/mt2060_priv.h                 |   15 +-
 drivers/media/tuners/mt2131.c                      |    4 -
 drivers/media/tuners/mt2131.h                      |    4 -
 drivers/media/tuners/mt2131_priv.h                 |    4 -
 drivers/media/tuners/mxl5007t.c                    |    4 -
 drivers/media/tuners/mxl5007t.h                    |    4 -
 drivers/media/tuners/qt1010.c                      |    4 -
 drivers/media/tuners/qt1010.h                      |    4 -
 drivers/media/tuners/qt1010_priv.h                 |    4 -
 drivers/media/tuners/tda18218.c                    |    4 -
 drivers/media/tuners/tda18218.h                    |    4 -
 drivers/media/tuners/tda18218_priv.h               |    4 -
 drivers/media/tuners/tda827x.c                     |    4 -
 drivers/media/tuners/xc4000.c                      |    4 -
 drivers/media/tuners/xc4000.h                      |    4 -
 drivers/media/tuners/xc5000.c                      |    4 -
 drivers/media/tuners/xc5000.h                      |    4 -
 drivers/media/usb/au0828/au0828-cards.c            |    4 -
 drivers/media/usb/au0828/au0828-cards.h            |    4 -
 drivers/media/usb/au0828/au0828-core.c             |   29 +-
 drivers/media/usb/au0828/au0828-dvb.c              |    4 -
 drivers/media/usb/au0828/au0828-i2c.c              |    4 -
 drivers/media/usb/au0828/au0828-input.c            |    3 +-
 drivers/media/usb/au0828/au0828-reg.h              |    4 -
 drivers/media/usb/au0828/au0828-video.c            |    5 -
 drivers/media/usb/au0828/au0828.h                  |    4 -
 drivers/media/usb/cpia2/cpia2.h                    |    4 -
 drivers/media/usb/cpia2/cpia2_core.c               |    4 -
 drivers/media/usb/cpia2/cpia2_registers.h          |    4 -
 drivers/media/usb/cpia2/cpia2_usb.c                |    8 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                |    4 -
 drivers/media/usb/cx231xx/Kconfig                  |    1 +
 drivers/media/usb/cx231xx/cx231xx-417.c            |    4 -
 drivers/media/usb/cx231xx/cx231xx-audio.c          |    4 -
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   29 +
 drivers/media/usb/cx231xx/cx231xx-core.c           |    7 +-
 drivers/media/usb/cx231xx/cx231xx-dif.h            |    4 -
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |   70 +
 drivers/media/usb/cx231xx/cx231xx-input.c          |    2 +-
 drivers/media/usb/cx231xx/cx231xx.h                |    1 +
 drivers/media/usb/dvb-usb-v2/Kconfig               |    8 +
 drivers/media/usb/dvb-usb-v2/Makefile              |    3 +
 drivers/media/usb/dvb-usb-v2/af9015.c              |    4 -
 drivers/media/usb/dvb-usb-v2/af9015.h              |    4 -
 drivers/media/usb/dvb-usb-v2/af9035.c              |  267 ++-
 drivers/media/usb/dvb-usb-v2/af9035.h              |    7 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |    4 -
 drivers/media/usb/dvb-usb-v2/anysee.h              |    4 -
 drivers/media/usb/dvb-usb-v2/au6610.c              |    4 -
 drivers/media/usb/dvb-usb-v2/au6610.h              |    4 -
 drivers/media/usb/dvb-usb-v2/ce6230.c              |    4 -
 drivers/media/usb/dvb-usb-v2/ce6230.h              |    4 -
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   12 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |    4 -
 drivers/media/usb/dvb-usb-v2/ec168.c               |    4 -
 drivers/media/usb/dvb-usb-v2/ec168.h               |    4 -
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   22 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c      |    4 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h      |    4 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c       |    4 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h       |    4 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c        |    4 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h        |    4 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c        |    4 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h        |    4 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h        |    4 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c      |    4 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h      |    4 -
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    2 +-
 drivers/media/usb/dvb-usb-v2/zd1301.c              |  298 +++
 drivers/media/usb/dvb-usb/af9005-fe.c              |    4 -
 drivers/media/usb/dvb-usb/af9005-remote.c          |    4 -
 drivers/media/usb/dvb-usb/af9005.c                 |    4 -
 drivers/media/usb/dvb-usb/af9005.h                 |    4 -
 drivers/media/usb/dvb-usb/cinergyT2-core.c         |    4 -
 drivers/media/usb/dvb-usb/cinergyT2-fe.c           |    4 -
 drivers/media/usb/dvb-usb/cinergyT2.h              |    4 -
 drivers/media/usb/dvb-usb/cxusb.c                  |  327 +---
 drivers/media/usb/dvb-usb/dib0700_devices.c        |    7 +-
 drivers/media/usb/dvb-usb/dtv5100.c                |    4 -
 drivers/media/usb/dvb-usb/dtv5100.h                |    4 -
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c       |   19 +-
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |    3 +-
 drivers/media/usb/dvb-usb/gp8psk.c                 |    4 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |  133 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |    6 +-
 drivers/media/usb/em28xx/em28xx-audio.c            |    4 -
 drivers/media/usb/em28xx/em28xx-cards.c            |   19 +
 drivers/media/usb/em28xx/em28xx-dvb.c              |   74 +
 drivers/media/usb/em28xx/em28xx-input.c            |   15 +-
 drivers/media/usb/em28xx/em28xx.h                  |    1 +
 drivers/media/usb/gspca/autogain_functions.c       |    4 -
 drivers/media/usb/gspca/benq.c                     |    4 -
 drivers/media/usb/gspca/conex.c                    |    4 -
 drivers/media/usb/gspca/cpia1.c                    |    4 -
 drivers/media/usb/gspca/etoms.c                    |    4 -
 drivers/media/usb/gspca/finepix.c                  |    4 -
 drivers/media/usb/gspca/gspca.c                    |    4 -
 drivers/media/usb/gspca/jeilinj.c                  |    4 -
 drivers/media/usb/gspca/jl2005bcd.c                |    4 -
 drivers/media/usb/gspca/jpeg.h                     |    4 -
 drivers/media/usb/gspca/kinect.c                   |    4 -
 drivers/media/usb/gspca/konica.c                   |    4 -
 drivers/media/usb/gspca/mars.c                     |    4 -
 drivers/media/usb/gspca/mr97310a.c                 |    4 -
 drivers/media/usb/gspca/nw80x.c                    |    4 -
 drivers/media/usb/gspca/ov519.c                    |    4 -
 drivers/media/usb/gspca/ov534.c                    |    4 -
 drivers/media/usb/gspca/ov534_9.c                  |    4 -
 drivers/media/usb/gspca/pac207.c                   |    4 -
 drivers/media/usb/gspca/pac7302.c                  |    4 -
 drivers/media/usb/gspca/pac7311.c                  |    4 -
 drivers/media/usb/gspca/pac_common.h               |    4 -
 drivers/media/usb/gspca/se401.c                    |    4 -
 drivers/media/usb/gspca/se401.h                    |    4 -
 drivers/media/usb/gspca/sn9c2028.c                 |    4 -
 drivers/media/usb/gspca/sn9c2028.h                 |    4 -
 drivers/media/usb/gspca/sn9c20x.c                  |    4 -
 drivers/media/usb/gspca/sonixb.c                   |    4 -
 drivers/media/usb/gspca/sonixj.c                   |    4 -
 drivers/media/usb/gspca/spca1528.c                 |    4 -
 drivers/media/usb/gspca/spca500.c                  |    4 -
 drivers/media/usb/gspca/spca501.c                  |    4 -
 drivers/media/usb/gspca/spca505.c                  |    4 -
 drivers/media/usb/gspca/spca506.c                  |    4 -
 drivers/media/usb/gspca/spca508.c                  |    4 -
 drivers/media/usb/gspca/spca561.c                  |    4 -
 drivers/media/usb/gspca/sq905.c                    |    4 -
 drivers/media/usb/gspca/sq905c.c                   |    4 -
 drivers/media/usb/gspca/sq930x.c                   |    4 -
 drivers/media/usb/gspca/stk014.c                   |    4 -
 drivers/media/usb/gspca/stk1135.c                  |    4 -
 drivers/media/usb/gspca/stk1135.h                  |    4 -
 drivers/media/usb/gspca/stv0680.c                  |    4 -
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |    4 -
 drivers/media/usb/gspca/stv06xx/stv06xx.h          |    4 -
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c     |    4 -
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.h     |    4 -
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |    4 -
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.h   |    4 -
 drivers/media/usb/gspca/stv06xx/stv06xx_sensor.h   |    4 -
 drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c   |    4 -
 drivers/media/usb/gspca/stv06xx/stv06xx_st6422.h   |    4 -
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c   |    7 -
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.h   |    4 -
 drivers/media/usb/gspca/sunplus.c                  |    4 -
 drivers/media/usb/gspca/t613.c                     |    4 -
 drivers/media/usb/gspca/tv8532.c                   |    4 -
 drivers/media/usb/gspca/vc032x.c                   |    4 -
 drivers/media/usb/gspca/vicam.c                    |    4 -
 drivers/media/usb/gspca/w996Xcf.c                  |    4 -
 drivers/media/usb/gspca/xirlink_cit.c              |    4 -
 drivers/media/usb/gspca/zc3xx.c                    |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-audio.c          |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-audio.h          |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-context.c        |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-context.h        |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c       |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h       |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-ctrl.c           |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-ctrl.h           |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c    |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h    |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-debug.h          |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.c       |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.h       |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c        |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-devattr.h        |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-dvb.c            |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c         |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.h         |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c        |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-encoder.h        |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h        |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h   |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h            |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h       |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-io.c             |  127 +-
 drivers/media/usb/pvrusb2/pvrusb2-io.h             |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c         |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-ioread.h         |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-main.c           |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-std.c            |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-std.h            |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c          |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.h          |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-util.h           |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |    7 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.h           |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c      |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h      |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.c         |    4 -
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.h         |    4 -
 drivers/media/usb/pvrusb2/pvrusb2.h                |    4 -
 drivers/media/usb/s2255/s2255drv.c                 |    4 -
 drivers/media/usb/stk1160/Kconfig                  |   10 +-
 drivers/media/usb/stk1160/Makefile                 |    4 +-
 drivers/media/usb/stk1160/stk1160-ac97.c           |  183 +-
 drivers/media/usb/stk1160/stk1160-core.c           |    8 +-
 drivers/media/usb/stk1160/stk1160-reg.h            |   10 +
 drivers/media/usb/stk1160/stk1160.h                |   11 +-
 drivers/media/usb/stkwebcam/stk-sensor.c           |    4 -
 drivers/media/usb/stkwebcam/stk-webcam.c           |    4 -
 drivers/media/usb/stkwebcam/stk-webcam.h           |    4 -
 drivers/media/usb/tm6000/tm6000-cards.c            |    4 -
 drivers/media/usb/tm6000/tm6000-core.c             |    4 -
 drivers/media/usb/tm6000/tm6000-dvb.c              |    4 -
 drivers/media/usb/tm6000/tm6000-i2c.c              |    4 -
 drivers/media/usb/tm6000/tm6000-input.c            |    9 +-
 drivers/media/usb/tm6000/tm6000-regs.h             |    4 -
 drivers/media/usb/tm6000/tm6000-stds.c             |    4 -
 drivers/media/usb/tm6000/tm6000-usb-isoc.h         |    4 -
 drivers/media/usb/tm6000/tm6000-video.c            |    9 +-
 drivers/media/usb/tm6000/tm6000.h                  |    4 -
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |    4 -
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           |    4 -
 drivers/media/usb/ttusb-dec/ttusbdecfe.h           |    4 -
 drivers/media/usb/usbtv/usbtv-video.c              |    8 +
 drivers/media/usb/usbvision/usbvision-cards.c      |    4 -
 drivers/media/usb/usbvision/usbvision-core.c       |    6 -
 drivers/media/usb/usbvision/usbvision-i2c.c        |    4 -
 drivers/media/usb/usbvision/usbvision-video.c      |    5 -
 drivers/media/usb/usbvision/usbvision.h            |    5 -
 drivers/media/usb/uvc/uvc_debugfs.c                |   15 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   13 +-
 drivers/media/usb/uvc/uvc_video.c                  |    3 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    4 +-
 drivers/media/usb/zr364xx/zr364xx.c                |    4 -
 drivers/media/v4l2-core/v4l2-async.c               |   26 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |    3 +
 drivers/media/v4l2-core/v4l2-device.c              |    2 +-
 drivers/media/v4l2-core/v4l2-event.c               |    5 -
 drivers/media/v4l2-core/v4l2-fh.c                  |    5 -
 drivers/media/v4l2-core/v4l2-mc.c                  |   44 +-
 drivers/media/v4l2-core/v4l2-of.c                  |   13 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |    4 -
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   25 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 +-
 drivers/staging/media/lirc/Kconfig                 |   22 +-
 drivers/staging/media/lirc/Makefile                |    3 -
 drivers/staging/media/lirc/lirc_bt829.c            |  401 ----
 drivers/staging/media/lirc/lirc_imon.c             |  979 ----------
 drivers/staging/media/lirc/lirc_parallel.c         |  741 --------
 drivers/staging/media/lirc/lirc_parallel.h         |   26 -
 drivers/staging/media/lirc/lirc_sir.c              |  296 +--
 drivers/staging/media/omap4iss/iss_video.c         |   34 +-
 drivers/staging/media/s5p-cec/Kconfig              |    2 +-
 drivers/staging/media/s5p-cec/exynos_hdmi_cec.h    |    1 -
 .../staging/media/s5p-cec/exynos_hdmi_cecctrl.c    |    5 +-
 include/linux/platform_data/media/ir-rx51.h        |    6 +-
 include/media/blackfin/ppi.h                       |    4 -
 include/media/davinci/ccdc_types.h                 |    4 -
 include/media/davinci/dm355_ccdc.h                 |    4 -
 include/media/davinci/dm644x_ccdc.h                |    4 -
 include/media/davinci/isif.h                       |    4 -
 include/media/davinci/vpbe.h                       |    4 -
 include/media/davinci/vpbe_osd.h                   |    4 -
 include/media/davinci/vpbe_types.h                 |    4 -
 include/media/davinci/vpbe_venc.h                  |    4 -
 include/media/davinci/vpfe_capture.h               |    4 -
 include/media/davinci/vpfe_types.h                 |    4 -
 include/media/davinci/vpif_types.h                 |    5 +-
 include/media/davinci/vpss.h                       |    4 -
 include/media/drv-intf/tea575x.h                   |    4 -
 include/media/i2c/adp1653.h                        |    5 -
 include/media/i2c/adv7183.h                        |    4 -
 include/media/i2c/as3645a.h                        |    5 -
 include/media/i2c/lm3560.h                         |    5 -
 include/media/i2c/mt9m032.h                        |    5 -
 include/media/i2c/smiapp.h                         |    5 -
 include/media/i2c/ths7303.h                        |    4 -
 include/media/i2c/tvp514x.h                        |    4 -
 include/media/i2c/tvp7002.h                        |    4 -
 include/media/i2c/upd64031a.h                      |    4 -
 include/media/i2c/upd64083.h                       |    4 -
 include/media/media-device.h                       |    8 +-
 include/media/media-devnode.h                      |    4 -
 include/media/media-entity.h                       |   69 +-
 include/media/rc-core.h                            |   32 +-
 include/media/rc-map.h                             |   31 +-
 include/media/v4l2-event.h                         |    5 -
 include/media/v4l2-fh.h                            |    5 -
 include/media/v4l2-subdev.h                        |    6 +-
 include/uapi/linux/cec-funcs.h                     |   10 +-
 871 files changed, 14700 insertions(+), 9200 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/irled/spi-ir-led.txt
 create mode 100644 Documentation/devicetree/bindings/media/fsl-vdoa.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
 create mode 100644 Documentation/devicetree/bindings/media/mtk-cir.txt
 create mode 100644 Documentation/devicetree/bindings/media/rc.txt
 create mode 100644 Documentation/devicetree/bindings/media/st,st-delta.txt
 create mode 100644 Documentation/devicetree/bindings/media/ti,da850-vpif.txt
 delete mode 100644 drivers/media/dvb-frontends/hd29l2.c
 delete mode 100644 drivers/media/dvb-frontends/hd29l2.h
 delete mode 100644 drivers/media/dvb-frontends/hd29l2_priv.h
 create mode 100644 drivers/media/dvb-frontends/zd1301_demod.c
 create mode 100644 drivers/media/dvb-frontends/zd1301_demod.h
 create mode 100644 drivers/media/i2c/et8ek8/Kconfig
 create mode 100644 drivers/media/i2c/et8ek8/Makefile
 create mode 100644 drivers/media/i2c/et8ek8/et8ek8_driver.c
 create mode 100644 drivers/media/i2c/et8ek8/et8ek8_mode.c
 create mode 100644 drivers/media/i2c/et8ek8/et8ek8_reg.h
 create mode 100644 drivers/media/platform/coda/imx-vdoa.c
 create mode 100644 drivers/media/platform/coda/imx-vdoa.h
 create mode 100644 drivers/media/platform/sti/delta/Makefile
 create mode 100644 drivers/media/platform/sti/delta/delta-cfg.h
 create mode 100644 drivers/media/platform/sti/delta/delta-debug.c
 create mode 100644 drivers/media/platform/sti/delta/delta-debug.h
 create mode 100644 drivers/media/platform/sti/delta/delta-ipc.c
 create mode 100644 drivers/media/platform/sti/delta/delta-ipc.h
 create mode 100644 drivers/media/platform/sti/delta/delta-mem.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mem.h
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-dec.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-fw.h
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg-hdr.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mjpeg.h
 create mode 100644 drivers/media/platform/sti/delta/delta-v4l2.c
 create mode 100644 drivers/media/platform/sti/delta/delta.h
 create mode 100644 drivers/media/platform/sti/hva/hva-debugfs.c
 create mode 100644 drivers/media/rc/ir-spi.c
 create mode 100644 drivers/media/rc/keymaps/rc-d680-dmb.c
 create mode 100644 drivers/media/rc/keymaps/rc-dvico-mce.c
 create mode 100644 drivers/media/rc/keymaps/rc-dvico-portable.c
 create mode 100644 drivers/media/rc/keymaps/rc-geekbox.c
 create mode 100644 drivers/media/rc/mtk-cir.c
 create mode 100644 drivers/media/usb/dvb-usb-v2/zd1301.c
 delete mode 100644 drivers/staging/media/lirc/lirc_bt829.c
 delete mode 100644 drivers/staging/media/lirc/lirc_imon.c
 delete mode 100644 drivers/staging/media/lirc/lirc_parallel.c
 delete mode 100644 drivers/staging/media/lirc/lirc_parallel.h
