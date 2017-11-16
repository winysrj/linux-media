Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41486 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753474AbdKPA2P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 19:28:15 -0500
Date: Wed, 15 Nov 2017 22:28:06 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.15-rc1] media updates
Message-ID: <20171115222806.5c86b85f@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.15-1


For:

- Documentation for digital TV (both kAPI and uAPI) are now in sync with
  the implementation (except for legacy/deprecated ioctls). This is a major
  step, as there were always a gap there;

- New sensor driver: imx274;
- New cec driver: cec-gpio;
- New platform driver for rockship rga and tegra CEC;
- New RC driver: tango-ir;
- Several cleanups at atomisp driver;
- Core improvements for RC, CEC, V4L2 async probing support and DVB;
- Lots of drivers cleanup, fixes and improvements.

PS.: This time, there is a merge from staging tree, from the same commit
     you pulled on your tree, in order to solve a conflict at the
     atomisp driver, as reported by Stephen Rothwell.

Regards,
Mauro

-


The following changes since commit c14dd9d5f8beda9d8c621683b4e7d6cb5cd3cda7:

  staging: lustre: add SPDX identifiers to all lustre files (2017-11-11 14:46:21 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.15-1

for you to fetch changes up to f2ecc3d0787e05d9145722feed01d4a11ab6bec1:

  Merge tag 'staging-4.15-rc1' into v4l_for_linus (2017-11-14 10:47:01 -0500)

----------------------------------------------------------------
media updates for v4.15-rc1

----------------------------------------------------------------
Adam Sampson (1):
      media: usbtv: fix brightness and contrast controls

Aishwarya Pant (2):
      media: staging: atomisp2: cleanup null check on memory allocation
      media: staging: atomisp: cleanup out of memory messages

Akinobu Mita (5):
      media: adv7180: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: max2175: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: ov2640: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: ov5640: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: ov9650: remove unnecessary terminated entry in menu items array

Allen Pais (1):
      media: atomisp:use ARRAY_SIZE() instead of open coding

Andrey Konovalov (1):
      media: dib0700: fix invalid dvb_detach argument

Andy Shevchenko (21):
      media: staging: atomisp: Remove dead code for MID (#1)
      media: staging: atomisp: Don't override D3 delay settings here
      media: staging: atomisp: Remove dead code for MID (#2)
      media: staging: atomisp: Remove dead code for MID (#3)
      media: staging: atomisp: Move to upstream IOSF MBI API
      media: staging: atomisp: Remove dead code for MID (#4)
      media: staging: atomisp: Remove unneeded intel-mid.h inclusion
      media: staging: atomisp: Remove IMX sensor support
      media: staging: atomisp: Remove AP1302 sensor support
      media: staging: atomisp: Use module_i2c_driver() macro
      media: staging: atomisp: Switch i2c drivers to use ->probe_new()
      media: staging: atomisp: Do not set GPIO twice
      media: staging: atomisp: Remove unneeded gpio.h inclusion
      media: staging: atomisp: Remove ->gpio_ctrl() callback
      media: staging: atomisp: Remove ->power_ctrl() callback
      media: staging: atomisp: Remove duplicate declaration in header
      media: staging: atomisp: Remove unused members of camera_sensor_platform_data
      media: staging: atomisp: Remove Gmin dead code #1
      media: staging: atomisp: Remove Gmin dead code #2
      media: staging: atomisp: Remove FSF snail address
      media: v4l2-ctrls: Don't validate BITMASK twice

Arnd Bergmann (3):
      [media] rcar_drif: fix potential uninitialized variable use
      media: rockchip/rga: annotate PM functions as __maybe_unused
      media: av7110: avoid 2038 overflow in debug print

Arvind Yadav (4):
      media: Staging: atomisp: constify driver_attribute
      [media] media: rc: constify usb_device_id
      media: coda: Handle return value of kasprintf
      media: imon: Fix null-ptr-deref in imon_probe

Bhumika Goyal (12):
      media: usb: make i2c_client const
      media: pci: make i2c_client const
      [media] media: rc: make device_type const
      [media] saa7146: make saa7146_use_ops const
      media: bt8xx: make bttv_vbi_qops const
      media: zoran: make zoran_template const
      media: cx23885/saa7134: make vb2_ops const
      media: au0828/em28xx: make vb2_ops const
      media: cx231xx: make cx231xx_vbi_qops const
      media: radio-si470x: make si470x_viddev_template const
      media: davinci: make function arguments const
      media: davinci: make ccdc_hw_device structures const

Branislav Radocaj (1):
      media: Staging: atomisp: fix alloc_cast.cocci warnings

Chiranjeevi Rapolu (4):
      [media] media: ov5670: Use recommended black level and output bias
      [media] media: ov5670: Fix not streaming issue after resume
      [media] media: ov13858: Calculate pixel-rate at runtime, use mode
      [media] media: ov13858: Fix 4224x3136 video flickering at some vblanks

Christophe JAILLET (1):
      [media] media: v4l2-pci-skeleton: Fix error handling path in 'skeleton_probe()'

Colin Ian King (18):
      media: rtl28xxu: make array rc_nec_tab static const
      media: cx25840: make array stds static const, reduces object code size
      media: cobalt: remove redundant zero check on retval
      media: ov9640: make const arrays res_x/y static const, reduces object code size
      media: cx23885: make const array buf static, reduces object code size
      [media] media: imon: make two const arrays static, reduces object code size
      [media] gspca: make arrays static, reduces object code size
      [media] ov2640: make array reset_seq static, reduces object code size
      media: radio-raremono: remove redundant initialization of freq
      media: mxl111sf: remove redundant assignment to index
      media: gspca: remove redundant assignment to variable j
      media: bdisp: remove redundant assignment to pix
      media: imx274: fix missing return assignment from call to imx274_mode_regs
      media: v4l: async: fix return of unitialized variable ret
      media: usb: fix spelling mistake: "synchronuously" -> "synchronously"
      media: drxd: make const array fastIncrDecLUT static
      media: cx88: make const arrays default_addr_list and pvr2000_addr_list static
      media: au0828: make const array addr_list static

Dan Carpenter (1):
      media: tc358743: remove an unneeded condition

Daniel Scheller (2):
      media: dvb-frontends/mxl5xx: declare LIST_HEAD(mxllist) static
      media: dvb-core: always call invoke_release() in fe_free()

David Härdeman (14):
      [media] media: lirc_dev: clarify error handling
      [media] media: lirc_dev: remove support for manually specifying minor number
      [media] media: lirc_dev: use cdev_device_add() helper function
      [media] media: lirc_dev: make better use of file->private_data
      [media] media: lirc_dev: make chunk_size and buffer_size mandatory
      [media] media: lirc_dev: change irctl->attached to be a boolean
      [media] media: lirc_dev: sanitize locking
      [media] media: lirc_dev: use an IDA instead of an array to keep track of registered devices
      [media] media: rename struct lirc_driver to struct lirc_dev
      [media] media: lirc_dev: introduce lirc_allocate_device and lirc_free_device
      [media] media: lirc_zilog: add a pointer to the parent device to struct IR
      [media] media: lirc_zilog: use a dynamically allocated lirc_dev
      [media] media: lirc_dev: merge struct irctl into struct lirc_dev
      media: lirc_dev: remove min_timeout and max_timeout

Fabio Estevam (3):
      [media] mt9m111: Propagate the real error on v4l2_clk_get() failure
      [media] ov2640: Propagate the real error on devm_clk_get() failure
      [media] ov2640: Check the return value from clk_prepare_enable()

Gustavo A. R. Silva (2):
      media: st-hva: hva-h264: use swap macro in hva_h264_encode
      media: usb: dvb-usb-v2: dvb_usb_core: remove redundant code in dvb_usb_fe_sleep

Hans Verkuil (24):
      media: cec-pin.c: use proper ktime accessor functions
      media: cec-ioc-dqevent.rst: fix typo
      media: cec-core.rst/cec-ioc-receive.rst: clarify CEC_TX_STATUS_ERROR
      media: cec: add CEC_EVENT_PIN_HPD_LOW/HIGH events
      media: cec-ioc-dqevent.rst: document new CEC_EVENT_PIN_HPD_LOW/HIGH events
      media: dt-bindings: document the CEC GPIO bindings
      media: cec-gpio: add HDMI CEC GPIO driver
      media: MAINTAINERS: add cec-gpio entry
      media: tc358743_regs.h: add CEC registers
      media: tc358743: add CEC support
      media: cobalt: do not register subdev nodes
      media: fix media Kconfig help syntax issues
      media: cec.h: initialize *parent and *port in cec_phys_addr_validate
      media: atomisp: fix small Kconfig issues
      [media] v4l2-tpg: add Y10 and Y12 support
      [media] vivid: add support for Y10 and Y12
      [media] cec-gpio: don't generate spurious HPD events
      [media] v4l2-ctrls.c: allow empty control handlers
      media: cec-pin.h: move non-kAPI parts into cec-pin-priv.h
      media: dt-bindings: document the tegra CEC bindings
      media: tegra-cec: add Tegra HDMI CEC driver
      media: cec-pin: use IS_ERR instead of PTR_ERR_OR_ZERO
      media: tegra-cec: fix messy probe() cleanup
      media: camss-video.c: drop unused header

Hans de Goede (1):
      media: staging: media: atomisp: Fix oops by unbalanced clk enable/disable call

Himanshu Jha (1):
      media: atomisp2: Remove null check before kfree

Hoegeun Kwon (2):
      media: exynos-gsc: Add compatible for Exynos 5250 and 5420 SoC version
      media: exynos-gsc: Add hardware rotation limits

Jacob Chen (6):
      [media] dt-bindings: Document the Rockchip RGA bindings
      [media] rockchip/rga: v4l2 m2m support
      [media] MAINTAINERS: add entry for Rockchip RGA driver
      media: i2c: tc358743: fix spelling mistake
      media: i2c: OV5647: ensure clock lane in LP-11 state before streaming on
      media: i2c: OV5647: change to use macro for the registers

Jaejoong Kim (1):
      media: usb: usbtv: remove duplicate & operation

Johan Hovold (1):
      [media] cx231xx-cards: fix NULL-deref on missing association descriptor

Jérémy Lefaure (1):
      media: staging: atomisp: use ARRAY_SIZE

Kees Cook (14):
      [media] media/i2c/tc358743: Initialize timer
      media: serial_ir: Convert timers to use timer_setup()
      media: staging: atomisp: Convert timers to use timer_setup()
      media: staging: atomisp: i2c: Convert timers to use timer_setup()
      media: rc: Convert timers to use timer_setup()
      media: media/saa7146: Convert timers to use timer_setup()
      media: tc358743: Convert timers to use timer_setup()
      media: saa7146: Convert timers to use timer_setup()
      media: dvb-core: Convert timers to use timer_setup()
      media: tvaudio: Convert timers to use timer_setup()
      media: saa7134: Convert timers to use timer_setup()
      media: pci: Convert timers to use timer_setup()
      media: radio: Convert timers to use timer_setup()
      media: s2255: Convert timers to use timer_setup()

Ladislav Michl (11):
      [media] media: rc: gpio-ir-recv: use helper variable to access device info
      [media] media: rc: gpio-ir-recv: use devm_kzalloc
      [media] media: rc: gpio-ir-recv: use devm_rc_allocate_device
      [media] media: rc: gpio-ir-recv: use devm_gpio_request_one
      [media] media: rc: gpio-ir-recv: use devm_rc_register_device
      [media] media: rc: gpio-ir-recv: do not allow threaded interrupt handler
      [media] media: rc: gpio-ir-recv: use devm_request_irq
      [media] media: rc: gpio-ir-recv: use KBUILD_MODNAME
      [media] media: rc: gpio-ir-recv: remove gpio_ir_recv_platform_data
      [media] media: rc: gpio-ir-recv: use gpiolib API
      [media] media: rc: fix gpio-ir-receiver build failure

Laurent Pinchart (1):
      media: v4l: async: Move async subdev notifier operations to a separate structure

Leon Luo (2):
      media: imx274: device tree binding file
      media: imx274: V4l2 driver for Sony imx274 CMOS sensor

Mans Rullgard (1):
      media: rc: Add driver for tango HW IR decoder

Marc Gonzalez (3):
      [media] media: rc: Delete duplicate debug message
      media: rc: Add tango keymap
      media: dt: bindings: Add binding for tango HW IR decoder

Markus Elfring (18):
      media: drivers: delete error messages for failed memory allocation
      media: drivers: delete unnecessary variable initialisations
      media: drivers: improve a size determination
      media: drivers: Adjust checks for null pointers
      media: dvb-frontends: delete jump targets
      media: meye: Adjust two function calls together with a variable assignment
      media: Hexium Orion: Adjust one function call together with a variable assignment
      media: davinci: do a couple of checkpatch cleanups
      [media] media: imon: delete an error message for a failed memory allocation
      [media] media: img-ir: delete an error message for a failed memory allocation
      [media] imon: Improve a size determination in two functions
      [media] i2c: Delete an error messages for failed memory allocation
      [media] i2c: Improve a size determination
      media: s5p-mfc: Delete an error message for a failed memory allocation
      media: s5p-mfc: Improve a size determination in s5p_mfc_alloc_memdev()
      media: s5p-mfc: Adjust a null pointer check in four functions
      media: tm6000: cleanup trival coding style issues
      media: omap_vout: Fix a possible null pointer dereference in omap_vout_open()

Mauro Carvalho Chehab (51):
      Merge tag 'v4.14-rc2' into patchwork
      media: stv0288: get rid of set_property boilerplate
      media: stv6110: get rid of a srate dead code
      media: friio-fe: get rid of set_property()
      media: dvb_frontend: get rid of get_property() callback
      media: dvb_frontend: get rid of set_property() callback
      media: dvb_frontend: cleanup dvb_frontend_ioctl_properties()
      media: dvb_frontend: cleanup ioctl handling logic
      media: dvb_frontend: get rid of property cache's state
      media: dvb_frontend.h: fix alignment at the cache properties
      media: dvb_frontend: better document the -EPERM condition
      media: dvb_frontend: fix return values for FE_SET_PROPERTY
      media: dvbdev: convert DVB device types into an enum
      media: dvbdev: fully document its functions
      media: dvb_frontend.h: improve kernel-doc markups
      media: dtv-core.rst: add chapters and introductory tests for common parts
      media: dtv-core.rst: split into multiple files
      media: dtv-frontend.rst fix a typo: algoritms -> algorithms
      media: dtv-demux.rst: minor markup improvements
      media: dvb_demux.h: add an enum for DMX_TYPE_* and document
      media: dvb_demux.h: add an enum for DMX_STATE_* and document
      media: dvb_demux.h: get rid of unused timer at struct dvb_demux_filter
      media: dvb_demux: mark a boolean field as such
      media: dvb_demux: dvb_demux_feed.pusi_seen is boolean
      media: dvb_demux.h: get rid of DMX_FEED_ENTRY() macro
      media: dvb_demux: fix type of dvb_demux_feed.ts_type
      media: dvb_demux: document dvb_demux_filter and dvb_demux_feed
      media: dvb_frontend: get rid of dtv_get_property_dump()
      media: dvb_demux.h: document structs defined on it
      media: dvb_demux.h: document functions
      media: dmxdev.h: add kernel-doc markups for data types and functions
      media: dtv-demux.rst: parse other demux headers with kernel-doc
      media: dvb-net.rst: document DVB network kAPI interface
      media: dvb uAPI docs: get rid of examples section
      media: dvb: do some coding style cleanup
      Simplify major/minor non-dynamic logic
      media: rga: make some functions static
      Merge commit '3728e6a255b5' into patchwork
      media: atmel-isc: get rid of an unused var
      media: v4l2-fwnode: use the cached value instead of getting again
      media: v4l2-fwnode: use a typedef for a function callback
      media: atomisp: fix ident for assert/return
      media: atomisp: fix spatch warnings at sh_css.c
      media: atomisp: fix switch coding style at input_system.c
      media: atomisp: fix other inconsistent identing
      media: atomisp: get rid of wrong stddef.h include
      media: atomisp: get rid of storage_class.h
      media: atomisp: make function calls cleaner
      media: camss-vfe: always initialize reg at vfe_set_xbar_cfg()
      dvb_frontend: don't use-after-free the frontend struct
      Merge tag 'staging-4.15-rc1' into v4l_for_linus

Michele Baldessari (1):
      media: Don't do DMA on stack for firmware upload in the AS102 driver

Muhammad Falak R Wani (1):
      media: staging/atomisp: make six local functions static to appease sparse

Nicolas Iooss (1):
      media: staging/atomisp: fix header guards

Niklas Söderlund (2):
      media: v4l: async: fix unbind error in v4l2_async_notifier_unregister()
      media: v4l: async: fix unregister for implicitly registered sub-device notifiers

Oleh Kravchenko (5):
      media: rc: mceusb: add support for 1b80:d3b2
      media: rc: Add Astrometa T2hybrid keymap module
      media: rc: mceusb: add support for 15f4:0135
      media: cx231xx: Fix NTSC/PAL on Evromedia USB Full Hybrid Full HD
      media: cx231xx: Fix NTSC/PAL on Astrometa T2hybrid

Philipp Zabel (2):
      media: tc358743: set entity function to video interface bridge
      media: tc358743: validate lane count

Pierre-Louis Bossart (1):
      media: staging: atomisp: use clock framework for camera clocks

Rajmohan Mani (1):
      [media] dw9714: Set the v4l2 focus ctrl step as 1

Randy Dunlap (1):
      media: ddbridge: fix build warnings

Ricardo Ribalda Delgado (2):
      media: v4l-ioctl: Fix typo on v4l_print_frmsizeenum
      media: v4l2-ctrl: Fix flags field on Control events

Sakari Ailus (45):
      media: staging: media: atomisp: Use tabs in Kconfig
      [media] media: Check for active and has_no_links overrun
      [media] ov13858: Use do_div() for dividing a 64-bit number
      [media] smiapp: Fix error handling in power on sequence
      [media] smiapp: Verify clock frequency after setting it, prevent changing it
      [media] smiapp: Get clock rate if it's not available through DT
      [media] smiapp: Make clock control optional
      media: dt: bindings: media: Document practices for DT bindings, ports, endpoints
      media: dt: bindings: media: Document data lane numbering without lane reordering
      media: smiapp: Use __v4l2_ctrl_handler_setup()
      media: smiapp: Rely on runtime PM
      media: staging: media: MAINTAINERS: Add entry for atomisp driver
      media: staging: atomisp: Add driver prefix to Kconfig option and module names
      media: staging: atomisp: Update TODO regarding sensors
      media: staging: atomisp: Add videobuf2 switch to TODO
      media: v4l: async: Remove re-probing support
      media: v4l: async: Don't set sd->dev NULL in v4l2_async_cleanup
      media: v4l: async: Fix notifier complete callback error handling
      media: v4l: async: Correctly serialise async sub-device unregistration
      media: v4l: async: Use more intuitive names for internal functions
      media: v4l: async: Add V4L2 async documentation to the documentation build
      media: v4l: fwnode: Support generic parsing of graph endpoints in a device
      media: omap3isp: Use generic parser for parsing fwnode endpoints
      media: rcar-vin: Use generic parser for parsing fwnode endpoints
      media: omap3isp: Fix check for our own sub-devices
      media: omap3isp: Print the name of the entity where no source pads could be found
      media: v4l: async: Introduce helpers for calling async ops callbacks
      media: v4l: async: Register sub-devices before calling bound callback
      media: v4l: async: Allow async notifier register call succeed with no subdevs
      media: v4l: async: Prepare for async sub-device notifiers
      media: v4l: async: Allow binding notifiers to sub-devices
      media: v4l: async: Ensure only unique fwnodes are registered to notifiers
      media: dt: bindings: Add a binding for flash LED devices associated to a sensor
      media: dt: bindings: Add lens-focus binding for image sensors
      media: v4l: fwnode: Move KernelDoc documentation to the header
      media: v4l: fwnode: Add a helper function for parsing generic references
      media: v4l: fwnode: Add a helper function to obtain device / integer references
      media: v4l: fwnode: Add convenience function for parsing common external refs
      media: v4l: fwnode: Add a convenience function for registering sensors
      media: dt: bindings: smiapp: Document lens-focus and flash-leds properties
      media: smiapp: Add support for flash and lens devices
      media: et8ek8: Add support for flash and lens devices
      media: ov5670: Add support for flash and lens devices
      media: ov13858: Add support for flash and lens devices
      media: arm: dts: omap3: N9/N950: Add flash references to the camera

Satendra Singh Thakur (1):
      media: dvb_frontend: dtv_property_process_set() cleanups

Sean Young (13):
      [media] media: dvb: a800: port to rc-core
      [media] media: rc: avermedia keymap for a800
      [media] media: rc: ensure that protocols are enabled for scancode drivers
      [media] media: rc: dvb: use dvb device name for rc device
      [media] media: rc: if protocols can't be changed, don't be writable
      [media] media: rc: include device name in rc udev event
      [media] media: vp7045: port TwinhanDTV Alpha to rc-core
      media: rc: nec decoder should not send both repeat and keycode
      media: rc: gpio-ir-tx does not work without devicetree or gpiolib
      media: rc: pwm-ir-tx needs OF
      media: rc: hix5hd2 drivers needs OF
      media: rc: check for integer overflow
      media: rc: ir-spi needs OF

Shuah Khan (1):
      media: s5p-mfc: fix lockdep warning

Simon Yuan (1):
      [media] media: i2c: adv748x: Map v4l2_std_id to the internal reg value

Srishti Sharma (3):
      media: Staging: media: atomisp: Merge assignment with return
      media: Staging: media: atomisp: Use kcalloc instead of kzalloc
      media: Staging: media: atomisp: pci: Eliminate use of typedefs for struct

Stanimir Varbanov (3):
      media: venus: fix wrong size on dma_free
      media: venus: venc: fix bytesused v4l2_plane field
      media: venus: reimplement decoder stop command

Stephen Hemminger (1):
      [media] media: default for RC_CORE should be n

Thomas Meyer (3):
      media: lgdt3306a: Use ARRAY_SIZE macro
      media: staging/atomisp: Use ARRAY_SIZE macro
      [media] media: rc: Use bsearch library function

Tim Harvey (1):
      media: imx: Fix VDIC CSI1 selection

Wei Yongjun (1):
      media: vimc: Fix return value check in vimc_add_subdevs()

Wenyou Yang (9):
      media: atmel-isc: Add spin lock for clock enable ops
      media: atmel-isc: Add prepare and unprepare ops
      media: atmel-isc: Enable the clocks during probe
      media: atmel-isc: Remove unnecessary member
      media: atmel-isc: Rework the format list
      media: ov7670: Add entity pads initialization
      media: ov7670: Add the get_fmt callback
      media: ov7670: Add the ov7670_s_power function
      media: atmel-isc: Fix clock ID for clk_prepare/unprepare

Younian Wang (2):
      media: rc/keymaps: add support for RC of hisilicon TV demo boards
      media: rc/keymaps: add support for RC of hisilicon poplar board

 .../devicetree/bindings/media/cec-gpio.txt         |   32 +
 .../devicetree/bindings/media/exynos5-gsc.txt      |    9 +-
 .../devicetree/bindings/media/i2c/imx274.txt       |   33 +
 .../devicetree/bindings/media/i2c/nokia,smia.txt   |    2 +
 .../devicetree/bindings/media/rockchip-rga.txt     |   33 +
 .../devicetree/bindings/media/tango-ir.txt         |   21 +
 .../devicetree/bindings/media/tegra-cec.txt        |   27 +
 .../devicetree/bindings/media/video-interfaces.txt |   24 +-
 Documentation/media/cec.h.rst.exceptions           |    2 -
 Documentation/media/kapi/cec-core.rst              |    7 +-
 Documentation/media/kapi/dtv-ca.rst                |    4 +
 Documentation/media/kapi/dtv-common.rst            |   55 +
 Documentation/media/kapi/dtv-core.rst              |  574 +---
 Documentation/media/kapi/dtv-demux.rst             |   82 +
 Documentation/media/kapi/dtv-frontend.rst          |  443 +++
 Documentation/media/kapi/dtv-net.rst               |    4 +
 Documentation/media/kapi/v4l2-async.rst            |    3 +
 Documentation/media/kapi/v4l2-core.rst             |    1 +
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |   22 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |   10 +-
 Documentation/media/uapi/dvb/examples.rst          |  378 +--
 Documentation/media/uapi/dvb/fe-get-property.rst   |    7 +-
 Documentation/media/uapi/dvb/net-types.rst         |    2 +-
 MAINTAINERS                                        |   31 +
 arch/arm/boot/dts/omap3-n9.dts                     |    1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |    4 +-
 arch/arm/boot/dts/omap3-n950.dts                   |    1 +
 drivers/media/cec/cec-adap.c                       |   18 +-
 drivers/media/cec/cec-api.c                        |   19 +-
 drivers/media/cec/cec-core.c                       |    9 +-
 drivers/media/cec/cec-pin-priv.h                   |  133 +
 drivers/media/cec/cec-pin.c                        |   40 +-
 drivers/media/common/cypress_firmware.c            |    6 +-
 drivers/media/common/saa7146/saa7146_fops.c        |    6 +-
 drivers/media/common/saa7146/saa7146_vbi.c         |   14 +-
 drivers/media/common/saa7146/saa7146_video.c       |    5 +-
 drivers/media/common/siano/smscoreapi.c            |   39 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |   12 +
 drivers/media/dvb-core/dmxdev.c                    |    8 +-
 drivers/media/dvb-core/dmxdev.h                    |   90 +-
 drivers/media/dvb-core/dvb_demux.c                 |   17 +-
 drivers/media/dvb-core/dvb_demux.h                 |  248 +-
 drivers/media/dvb-core/dvb_frontend.c              |  518 ++-
 drivers/media/dvb-core/dvb_frontend.h              |  117 +-
 drivers/media/dvb-core/dvb_net.h                   |   34 +-
 drivers/media/dvb-core/dvbdev.c                    |   32 +-
 drivers/media/dvb-core/dvbdev.h                    |  137 +-
 drivers/media/dvb-frontends/Kconfig                |    6 +-
 drivers/media/dvb-frontends/as102_fe.c             |    7 +-
 drivers/media/dvb-frontends/cx24113.c              |   10 +-
 drivers/media/dvb-frontends/cx24116.c              |   22 +-
 drivers/media/dvb-frontends/drxd_hard.c            |    9 +-
 drivers/media/dvb-frontends/ds3000.c               |   22 +-
 drivers/media/dvb-frontends/lg2160.c               |   14 -
 drivers/media/dvb-frontends/lgdt3306a.c            |    3 +-
 drivers/media/dvb-frontends/mb86a20s.c             |   23 +-
 drivers/media/dvb-frontends/mxl5xx.c               |    2 +-
 drivers/media/dvb-frontends/si2168.c               |    1 -
 drivers/media/dvb-frontends/sp2.c                  |    9 +-
 drivers/media/dvb-frontends/stv0288.c              |    7 -
 drivers/media/dvb-frontends/stv6110.c              |    9 -
 drivers/media/i2c/Kconfig                          |   16 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/adv7180.c                        |    2 +-
 drivers/media/i2c/adv748x/adv748x-afe.c            |    7 +-
 drivers/media/i2c/adv7604.c                        |   10 +-
 drivers/media/i2c/adv7842.c                        |    6 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |    2 +-
 drivers/media/i2c/dw9714.c                         |    7 +-
 drivers/media/i2c/et8ek8/et8ek8_driver.c           |    2 +-
 drivers/media/i2c/imx274.c                         | 1811 +++++++++++
 drivers/media/i2c/ir-kbd-i2c.c                     |    1 -
 drivers/media/i2c/max2175.c                        |    2 +-
 drivers/media/i2c/mt9m111.c                        |    2 +-
 drivers/media/i2c/ov13858.c                        |   61 +-
 drivers/media/i2c/ov2640.c                         |   17 +-
 drivers/media/i2c/ov5640.c                         |    2 +-
 drivers/media/i2c/ov5647.c                         |   51 +-
 drivers/media/i2c/ov5670.c                         |   37 +-
 drivers/media/i2c/ov6650.c                         |    5 +-
 drivers/media/i2c/ov7670.c                         |  129 +-
 drivers/media/i2c/ov9650.c                         |    1 -
 drivers/media/i2c/smiapp/smiapp-core.c             |  149 +-
 drivers/media/i2c/smiapp/smiapp-regs.c             |    3 +
 drivers/media/i2c/smiapp/smiapp.h                  |    1 +
 drivers/media/i2c/soc_camera/ov9640.c              |   11 +-
 drivers/media/i2c/soc_camera/ov9740.c              |    6 +-
 drivers/media/i2c/tc358743.c                       |  220 +-
 drivers/media/i2c/tc358743_regs.h                  |   94 +-
 drivers/media/i2c/tvaudio.c                        |    8 +-
 drivers/media/media-entity.c                       |   13 +-
 drivers/media/pci/b2c2/Kconfig                     |    4 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |    6 +-
 drivers/media/pci/bt8xx/bttv-input.c               |   19 +-
 drivers/media/pci/bt8xx/bttv-vbi.c                 |    2 +-
 drivers/media/pci/bt8xx/bttvp.h                    |    3 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |    5 -
 drivers/media/pci/cx18/cx18-driver.c               |   28 +-
 drivers/media/pci/cx18/cx18-fileops.c              |    4 +-
 drivers/media/pci/cx18/cx18-fileops.h              |    2 +-
 drivers/media/pci/cx18/cx18-streams.c              |    2 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |    2 +-
 drivers/media/pci/cx23885/cx23885-i2c.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |    2 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +-
 drivers/media/pci/cx25821/cx25821-i2c.c            |    2 +-
 drivers/media/pci/cx88/cx88-input.c                |    4 +-
 drivers/media/pci/ddbridge/ddbridge-io.h           |    4 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |    3 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |    2 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |    4 +-
 drivers/media/pci/ivtv/ivtv-irq.h                  |    2 +-
 drivers/media/pci/mantis/hopper_cards.c            |    9 +-
 drivers/media/pci/mantis/mantis_cards.c            |    8 +-
 drivers/media/pci/meye/meye.c                      |   20 +-
 drivers/media/pci/netup_unidvb/Kconfig             |   12 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    7 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    6 +-
 drivers/media/pci/saa7134/saa7134-i2c.c            |    2 +-
 drivers/media/pci/saa7134/saa7134-input.c          |    9 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |    3 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |    5 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    3 +-
 drivers/media/pci/saa7134/saa7134.h                |    4 +-
 drivers/media/pci/saa7146/hexium_gemini.c          |    7 +-
 drivers/media/pci/saa7146/hexium_orion.c           |   10 +-
 drivers/media/pci/saa7164/saa7164-buffer.c         |    8 +-
 drivers/media/pci/saa7164/saa7164-i2c.c            |    2 +-
 drivers/media/pci/ttpci/av7110.c                   |    8 +-
 drivers/media/pci/ttpci/budget-core.c              |    2 +-
 drivers/media/pci/tw686x/tw686x-core.c             |    7 +-
 drivers/media/pci/zoran/zoran_card.h               |    2 +-
 drivers/media/pci/zoran/zoran_driver.c             |    2 +-
 drivers/media/platform/Kconfig                     |   36 +
 drivers/media/platform/Makefile                    |    6 +
 drivers/media/platform/am437x/am437x-vpfe.c        |    8 +-
 drivers/media/platform/atmel/atmel-isc-regs.h      |    1 +
 drivers/media/platform/atmel/atmel-isc.c           |  652 +++-
 drivers/media/platform/atmel/atmel-isi.c           |   24 +-
 drivers/media/platform/blackfin/ppi.c              |    1 -
 drivers/media/platform/cec-gpio/Makefile           |    1 +
 drivers/media/platform/cec-gpio/cec-gpio.c         |  239 ++
 drivers/media/platform/coda/coda-bit.c             |    4 +
 drivers/media/platform/davinci/ccdc_hw_device.h    |    4 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |    2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |    2 +-
 drivers/media/platform/davinci/isif.c              |    2 +-
 drivers/media/platform/davinci/vpbe_display.c      |   37 +-
 drivers/media/platform/davinci/vpfe_capture.c      |    6 +-
 drivers/media/platform/davinci/vpif_capture.c      |    8 +-
 drivers/media/platform/davinci/vpif_display.c      |    8 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |  127 +-
 drivers/media/platform/exynos4-is/Kconfig          |    2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |    8 +-
 drivers/media/platform/omap/omap_vout.c            |    3 +-
 drivers/media/platform/omap3isp/isp.c              |  133 +-
 drivers/media/platform/omap3isp/isp.h              |    5 +-
 drivers/media/platform/pxa_camera.c                |    8 +-
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c |    3 +
 .../media/platform/qcom/camss-8x16/camss-video.c   |    1 -
 drivers/media/platform/qcom/camss-8x16/camss.c     |    8 +-
 drivers/media/platform/qcom/venus/core.h           |    2 -
 drivers/media/platform/qcom/venus/helpers.c        |    7 -
 drivers/media/platform/qcom/venus/hfi.c            |    1 +
 drivers/media/platform/qcom/venus/hfi_venus.c      |   12 +-
 drivers/media/platform/qcom/venus/vdec.c           |   34 +-
 drivers/media/platform/qcom/venus/venc.c           |    7 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |  117 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |   10 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   14 +-
 drivers/media/platform/rcar-vin/rcar-vin.h         |    4 +-
 drivers/media/platform/rcar_drif.c                 |   12 +-
 drivers/media/platform/rockchip/rga/Makefile       |    3 +
 drivers/media/platform/rockchip/rga/rga-buf.c      |  154 +
 drivers/media/platform/rockchip/rga/rga-hw.c       |  421 +++
 drivers/media/platform/rockchip/rga/rga-hw.h       |  437 +++
 drivers/media/platform/rockchip/rga/rga.c          | 1010 ++++++
 drivers/media/platform/rockchip/rga/rga.h          |  125 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   18 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   14 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    2 +-
 drivers/media/platform/sti/hva/hva-h264.c          |    5 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |   10 +-
 drivers/media/platform/tegra-cec/Makefile          |    1 +
 drivers/media/platform/tegra-cec/tegra_cec.c       |  495 +++
 drivers/media/platform/tegra-cec/tegra_cec.h       |  127 +
 drivers/media/platform/ti-vpe/cal.c                |    8 +-
 drivers/media/platform/vimc/vimc-core.c            |    5 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |   16 +
 drivers/media/platform/xilinx/xilinx-vipp.c        |    8 +-
 drivers/media/radio/radio-cadet.c                  |    7 +-
 drivers/media/radio/radio-raremono.c               |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    2 +-
 drivers/media/radio/si470x/radio-si470x.h          |    2 +-
 drivers/media/radio/wl128x/Kconfig                 |   10 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |    7 +-
 drivers/media/rc/Kconfig                           |   16 +-
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/ati_remote.c                      |    2 +-
 drivers/media/rc/ene_ir.c                          |    7 +-
 drivers/media/rc/gpio-ir-recv.c                    |  192 +-
 drivers/media/rc/igorplugusb.c                     |    8 +-
 drivers/media/rc/img-ir/img-ir-core.c              |    5 +-
 drivers/media/rc/img-ir/img-ir-hw.c                |   13 +-
 drivers/media/rc/img-ir/img-ir-raw.c               |    6 +-
 drivers/media/rc/imon.c                            |   30 +-
 drivers/media/rc/ir-lirc-codec.c                   |   65 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |    7 +-
 drivers/media/rc/ir-nec-decoder.c                  |   29 +-
 drivers/media/rc/keymaps/Makefile                  |    4 +
 drivers/media/rc/keymaps/rc-astrometa-t2hybrid.c   |   70 +
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |    3 +-
 drivers/media/rc/keymaps/rc-hisi-poplar.c          |   69 +
 drivers/media/rc/keymaps/rc-hisi-tv-demo.c         |   81 +
 drivers/media/rc/keymaps/rc-tango.c                |   92 +
 drivers/media/rc/keymaps/rc-twinhan1027.c          |    2 +-
 drivers/media/rc/lirc_dev.c                        |  515 ++-
 drivers/media/rc/mceusb.c                          |   20 +-
 drivers/media/rc/rc-core-priv.h                    |    2 +-
 drivers/media/rc/rc-ir-raw.c                       |    8 +-
 drivers/media/rc/rc-main.c                         |   79 +-
 drivers/media/rc/redrat3.c                         |    2 +-
 drivers/media/rc/serial_ir.c                       |    5 +-
 drivers/media/rc/sir_ir.c                          |    4 +-
 drivers/media/rc/streamzap.c                       |    2 +-
 drivers/media/rc/tango-ir.c                        |  281 ++
 drivers/media/usb/as102/as102_fw.c                 |   28 +-
 drivers/media/usb/au0828/au0828-i2c.c              |    2 +-
 drivers/media/usb/au0828/au0828-input.c            |    2 +-
 drivers/media/usb/au0828/au0828-vbi.c              |    2 +-
 drivers/media/usb/au0828/au0828-video.c            |    4 +-
 drivers/media/usb/au0828/au0828.h                  |    2 +-
 drivers/media/usb/b2c2/Kconfig                     |    6 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    5 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |    4 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |    6 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.h            |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |    4 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |    3 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c        |    1 -
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    2 +-
 drivers/media/usb/dvb-usb/a800.c                   |   65 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |   24 +-
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |    3 +-
 drivers/media/usb/dvb-usb/dvb-usb.h                |    1 +
 drivers/media/usb/dvb-usb/friio-fe.c               |   24 -
 drivers/media/usb/dvb-usb/vp7045.c                 |   88 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |    4 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |    2 +-
 drivers/media/usb/em28xx/em28xx-v4l.h              |    2 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    4 +-
 drivers/media/usb/gspca/Kconfig                    |   16 +-
 drivers/media/usb/gspca/gspca.c                    |    1 -
 drivers/media/usb/gspca/ov519.c                    |   22 +-
 drivers/media/usb/msi2500/msi2500.c                |    2 +-
 drivers/media/usb/pvrusb2/Kconfig                  |    1 -
 drivers/media/usb/pwc/pwc-if.c                     |    3 +-
 drivers/media/usb/s2255/s2255drv.c                 |    7 +-
 drivers/media/usb/stk1160/stk1160-i2c.c            |    2 +-
 drivers/media/usb/stk1160/stk1160-video.c          |    4 +-
 drivers/media/usb/tm6000/tm6000-cards.c            |   27 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |   15 +-
 drivers/media/usb/tm6000/tm6000-input.c            |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   21 +-
 drivers/media/usb/usbtv/usbtv-core.c               |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    4 +-
 drivers/media/usb/zr364xx/zr364xx.c                |   32 +-
 drivers/media/v4l2-core/v4l2-async.c               |  516 ++-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   22 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |  702 +++-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    9 +-
 drivers/staging/media/atomisp/Kconfig              |   11 +-
 drivers/staging/media/atomisp/TODO                 |   24 +-
 drivers/staging/media/atomisp/i2c/Kconfig          |  100 +-
 drivers/staging/media/atomisp/i2c/Makefile         |   19 +-
 drivers/staging/media/atomisp/i2c/ap1302.c         | 1255 --------
 drivers/staging/media/atomisp/i2c/ap1302.h         |  198 --
 .../atomisp/i2c/{gc0310.c => atomisp-gc0310.c}     |   53 +-
 .../atomisp/i2c/{gc2235.c => atomisp-gc2235.c}     |   54 +-
 ...bmsrlisthelper.c => atomisp-libmsrlisthelper.c} |    4 -
 .../atomisp/i2c/{lm3554.c => atomisp-lm3554.c}     |   47 +-
 .../atomisp/i2c/{mt9m114.c => atomisp-mt9m114.c}   |   51 +-
 .../atomisp/i2c/{ov2680.c => atomisp-ov2680.c}     |   51 +-
 .../atomisp/i2c/{ov2722.c => atomisp-ov2722.c}     |   54 +-
 drivers/staging/media/atomisp/i2c/gc0310.h         |   11 -
 drivers/staging/media/atomisp/i2c/gc2235.h         |    7 -
 drivers/staging/media/atomisp/i2c/imx/Kconfig      |    9 -
 drivers/staging/media/atomisp/i2c/imx/Makefile     |   13 -
 drivers/staging/media/atomisp/i2c/imx/ad5816g.c    |  216 --
 drivers/staging/media/atomisp/i2c/imx/ad5816g.h    |   49 -
 drivers/staging/media/atomisp/i2c/imx/common.h     |   65 -
 drivers/staging/media/atomisp/i2c/imx/drv201.c     |  209 --
 drivers/staging/media/atomisp/i2c/imx/drv201.h     |   38 -
 drivers/staging/media/atomisp/i2c/imx/dw9714.c     |  223 --
 drivers/staging/media/atomisp/i2c/imx/dw9714.h     |   63 -
 drivers/staging/media/atomisp/i2c/imx/dw9718.c     |  233 --
 drivers/staging/media/atomisp/i2c/imx/dw9718.h     |   64 -
 drivers/staging/media/atomisp/i2c/imx/dw9719.c     |  198 --
 drivers/staging/media/atomisp/i2c/imx/dw9719.h     |   58 -
 drivers/staging/media/atomisp/i2c/imx/imx.c        | 2480 --------------
 drivers/staging/media/atomisp/i2c/imx/imx.h        |  737 -----
 drivers/staging/media/atomisp/i2c/imx/imx132.h     |  566 ----
 drivers/staging/media/atomisp/i2c/imx/imx134.h     | 2464 --------------
 drivers/staging/media/atomisp/i2c/imx/imx135.h     | 3374 --------------------
 drivers/staging/media/atomisp/i2c/imx/imx175.h     | 1959 ------------
 drivers/staging/media/atomisp/i2c/imx/imx208.h     |  550 ----
 drivers/staging/media/atomisp/i2c/imx/imx219.h     |  227 --
 drivers/staging/media/atomisp/i2c/imx/imx227.h     |  726 -----
 drivers/staging/media/atomisp/i2c/imx/otp.c        |   39 -
 .../media/atomisp/i2c/imx/otp_brcc064_e2prom.c     |   80 -
 drivers/staging/media/atomisp/i2c/imx/otp_e2prom.c |   89 -
 drivers/staging/media/atomisp/i2c/imx/otp_imx.c    |  191 --
 drivers/staging/media/atomisp/i2c/imx/vcm.c        |   45 -
 drivers/staging/media/atomisp/i2c/mt9m114.h        |    9 -
 drivers/staging/media/atomisp/i2c/ov2680.h         |   14 -
 drivers/staging/media/atomisp/i2c/ov2722.h         |   11 -
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig   |   12 +-
 drivers/staging/media/atomisp/i2c/ov5693/Makefile  |    2 +-
 drivers/staging/media/atomisp/i2c/ov5693/ad5823.h  |    4 -
 .../i2c/ov5693/{ov5693.c => atomisp-ov5693.c}      |   59 +-
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |   11 -
 drivers/staging/media/atomisp/i2c/ov8858.c         |   65 +-
 drivers/staging/media/atomisp/i2c/ov8858.h         |    5 -
 drivers/staging/media/atomisp/i2c/ov8858_btns.h    |    5 -
 .../atomisp/include/asm/intel_mid_pcihelpers.h     |   37 -
 .../staging/media/atomisp/include/linux/atomisp.h  |    4 -
 .../atomisp/include/linux/atomisp_gmin_platform.h  |    3 -
 .../media/atomisp/include/linux/atomisp_platform.h |   25 +-
 .../media/atomisp/include/linux/libmsrlisthelper.h |    4 -
 .../staging/media/atomisp/include/media/lm3554.h   |    5 -
 .../staging/media/atomisp/include/media/lm3642.h   |  153 -
 drivers/staging/media/atomisp/pci/Kconfig          |   17 +-
 .../media/atomisp/pci/atomisp2/atomisp-regs.h      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_acc.c       |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_acc.h       |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |   38 +-
 .../media/atomisp/pci/atomisp2/atomisp_cmd.h       |   10 +-
 .../media/atomisp/pci/atomisp2/atomisp_common.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_compat.h    |    4 -
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |    6 +-
 .../atomisp/pci/atomisp2/atomisp_compat_css20.h    |    4 -
 .../atomisp/pci/atomisp2/atomisp_compat_ioctl32.c  |    4 -
 .../atomisp/pci/atomisp2/atomisp_compat_ioctl32.h  |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_csi2.c      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_csi2.h      |    4 -
 .../atomisp/pci/atomisp2/atomisp_dfs_tables.h      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.c     |    6 +-
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.h     |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_file.c      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_file.h      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |    8 +-
 .../media/atomisp/pci/atomisp2/atomisp_fops.h      |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_helper.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |    7 -
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |   20 +-
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.h     |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |    5 -
 .../media/atomisp/pci/atomisp2/atomisp_subdev.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_tables.h    |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_tpg.c       |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_tpg.h       |    4 -
 .../atomisp/pci/atomisp2/atomisp_trace_event.h     |    4 -
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |   67 +-
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.h      |    4 -
 .../base/circbuf/interface/ia_css_circbuf.h        |   39 +-
 .../base/circbuf/interface/ia_css_circbuf_desc.h   |   15 +-
 .../css2400/camera/pipe/src/pipe_binarydesc.c      |    9 +-
 .../pci/atomisp2/css2400/camera/util/src/util.c    |    2 +-
 .../hrt/input_formatter_subsystem_defs.h           |    2 +-
 .../css_2401_csi2p_system/host/csi_rx_private.h    |   18 +-
 .../hrt/input_formatter_subsystem_defs.h           |    2 +-
 .../hrt/input_formatter_subsystem_defs.h           |    2 +-
 .../css2400/hive_isp_css_common/host/dma.c         |    2 +-
 .../hive_isp_css_common/host/event_fifo_private.h  |    2 +-
 .../hive_isp_css_common/host/fifo_monitor.c        |    8 +-
 .../host/fifo_monitor_private.h                    |   28 +-
 .../css2400/hive_isp_css_common/host/gdc.c         |   16 +-
 .../css2400/hive_isp_css_common/host/gp_device.c   |    2 +-
 .../hive_isp_css_common/host/gp_device_private.h   |   16 +-
 .../hive_isp_css_common/host/gpio_private.h        |    4 +-
 .../hive_isp_css_common/host/hmem_private.h        |    4 +-
 .../host/input_formatter_private.h                 |   16 +-
 .../hive_isp_css_common/host/input_system.c        |   80 +-
 .../host/input_system_private.h                    |   64 +-
 .../css2400/hive_isp_css_common/host/irq.c         |   42 +-
 .../css2400/hive_isp_css_common/host/irq_private.h |   12 +-
 .../css2400/hive_isp_css_common/host/isp.c         |    4 +-
 .../css2400/hive_isp_css_common/host/mmu.c         |    6 +-
 .../css2400/hive_isp_css_common/host/mmu_private.h |   12 +-
 .../css2400/hive_isp_css_common/host/sp_private.h  |   60 +-
 .../css2400/hive_isp_css_include/assert_support.h  |    3 +-
 .../atomisp2/css2400/hive_isp_css_include/bamem.h  |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/csi_rx.h |    5 -
 .../atomisp2/css2400/hive_isp_css_include/debug.h  |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/dma.h    |    7 +-
 .../css2400/hive_isp_css_include/event_fifo.h      |    7 +-
 .../css2400/hive_isp_css_include/fifo_monitor.h    |    7 +-
 .../css2400/hive_isp_css_include/gdc_device.h      |    7 +-
 .../css2400/hive_isp_css_include/gp_device.h       |    7 +-
 .../css2400/hive_isp_css_include/gp_timer.h        |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/gpio.h   |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/hmem.h   |    7 +-
 .../hive_isp_css_include/host/csi_rx_public.h      |   18 +-
 .../css2400/hive_isp_css_include/host/gdc_public.h |    6 +-
 .../hive_isp_css_include/host/hmem_public.h        |    4 +-
 .../css2400/hive_isp_css_include/host/isp_op1w.h   |    9 +-
 .../css2400/hive_isp_css_include/host/isp_op2w.h   |    9 +-
 .../css2400/hive_isp_css_include/host/mmu_public.h |    8 +-
 .../hive_isp_css_include/host/ref_vector_func.h    |    9 +-
 .../css2400/hive_isp_css_include/ibuf_ctrl.h       |    7 +-
 .../css2400/hive_isp_css_include/input_formatter.h |    7 +-
 .../css2400/hive_isp_css_include/input_system.h    |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/irq.h    |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/isp.h    |    7 +-
 .../css2400/hive_isp_css_include/isys_dma.h        |    7 +-
 .../css2400/hive_isp_css_include/isys_irq.h        |    9 +-
 .../hive_isp_css_include/isys_stream2mmio.h        |    7 +-
 .../css2400/hive_isp_css_include/math_support.h    |   25 +-
 .../css2400/hive_isp_css_include/mmu_device.h      |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/mpmath.h |    9 +-
 .../atomisp2/css2400/hive_isp_css_include/osys.h   |    7 +-
 .../css2400/hive_isp_css_include/pixelgen.h        |    7 +-
 .../hive_isp_css_include/platform_support.h        |    1 -
 .../css2400/hive_isp_css_include/print_support.h   |    3 +-
 .../atomisp2/css2400/hive_isp_css_include/queue.h  |    7 +-
 .../css2400/hive_isp_css_include/resource.h        |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/socket.h |    7 +-
 .../pci/atomisp2/css2400/hive_isp_css_include/sp.h |    7 +-
 .../css2400/hive_isp_css_include/storage_class.h   |   34 -
 .../css2400/hive_isp_css_include/stream_buffer.h   |    7 +-
 .../css2400/hive_isp_css_include/string_support.h  |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/tag.h    |    7 +-
 .../css2400/hive_isp_css_include/timed_ctrl.h      |    7 +-
 .../css2400/hive_isp_css_include/type_support.h    |   42 -
 .../atomisp2/css2400/hive_isp_css_include/vamem.h  |    7 +-
 .../css2400/hive_isp_css_include/vector_func.h     |    7 +-
 .../css2400/hive_isp_css_include/vector_ops.h      |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/vmem.h   |    7 +-
 .../atomisp2/css2400/hive_isp_css_include/xmem.h   |    7 +-
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c      |    2 +-
 .../atomisp2/css2400/runtime/binary/src/binary.c   |   12 +-
 .../pci/atomisp2/css2400/runtime/bufq/src/bufq.c   |    2 +-
 .../css2400/runtime/debug/interface/ia_css_debug.h |    2 +-
 .../pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c |    3 +-
 .../css2400/runtime/inputfifo/src/inputfifo.c      |   28 +-
 .../css2400/runtime/pipeline/src/pipeline.c        |    2 +-
 .../css2400/runtime/rmgr/interface/ia_css_rmgr.h   |    7 +-
 .../atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c  |    2 +-
 .../atomisp2/css2400/runtime/spctrl/src/spctrl.c   |    6 +-
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  133 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |   15 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_hrt.c      |    2 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |    4 +-
 .../pci/atomisp2/css2400/sh_css_param_shading.c    |    4 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |   54 +-
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |    4 -
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |   34 +-
 .../atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c    |   10 +-
 .../atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c   |    9 +-
 .../media/atomisp/pci/atomisp2/hmm/hmm_vm.c        |    8 +-
 .../atomisp2/hrt/hive_isp_css_custom_host_hrt.h    |    4 -
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c |    4 -
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h |    4 -
 .../media/atomisp/pci/atomisp2/include/hmm/hmm.h   |    4 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_bo.h      |    4 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h  |    4 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_common.h  |    4 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_pool.h    |    4 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_vm.h      |    4 -
 .../atomisp/pci/atomisp2/include/mmu/isp_mmu.h     |    4 -
 .../atomisp/pci/atomisp2/include/mmu/sh_mmu.h      |    4 -
 .../pci/atomisp2/include/mmu/sh_mmu_mrfld.h        |    4 -
 .../media/atomisp/pci/atomisp2/mmu/isp_mmu.c       |    4 -
 .../media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c  |    4 -
 drivers/staging/media/atomisp/platform/Makefile    |    1 -
 .../staging/media/atomisp/platform/clock/Makefile  |    6 -
 .../platform/clock/platform_vlv2_plat_clk.c        |   40 -
 .../platform/clock/platform_vlv2_plat_clk.h        |   27 -
 .../media/atomisp/platform/clock/vlv2_plat_clock.c |  247 --
 .../media/atomisp/platform/intel-mid/Makefile      |    1 -
 .../platform/intel-mid/atomisp_gmin_platform.c     |  141 +-
 .../platform/intel-mid/intel_mid_pcihelpers.c      |  297 --
 drivers/staging/media/imx/imx-ic-prp.c             |    5 +-
 drivers/staging/media/imx/imx-media-dev.c          |    8 +-
 drivers/staging/media/lirc/lirc_zilog.c            |  231 +-
 include/linux/platform_data/media/gpio-ir-recv.h   |   23 -
 include/media/cec-pin.h                            |  111 +-
 include/media/cec.h                                |   16 +-
 include/media/drv-intf/saa7146_vv.h                |    7 +-
 include/media/lirc_dev.h                           |  100 +-
 include/media/rc-map.h                             |    4 +
 include/media/v4l2-async.h                         |   91 +-
 include/media/v4l2-fwnode.h                        |  228 +-
 include/media/v4l2-subdev.h                        |    3 +
 include/uapi/linux/cec.h                           |    2 +
 include/uapi/linux/dvb/frontend.h                  |    2 +-
 samples/v4l/v4l2-pci-skeleton.c                    |    6 +-
 498 files changed, 12046 insertions(+), 22595 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cec-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imx274.txt
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-rga.txt
 create mode 100644 Documentation/devicetree/bindings/media/tango-ir.txt
 create mode 100644 Documentation/devicetree/bindings/media/tegra-cec.txt
 create mode 100644 Documentation/media/kapi/dtv-ca.rst
 create mode 100644 Documentation/media/kapi/dtv-common.rst
 create mode 100644 Documentation/media/kapi/dtv-demux.rst
 create mode 100644 Documentation/media/kapi/dtv-frontend.rst
 create mode 100644 Documentation/media/kapi/dtv-net.rst
 create mode 100644 Documentation/media/kapi/v4l2-async.rst
 create mode 100644 drivers/media/cec/cec-pin-priv.h
 create mode 100644 drivers/media/i2c/imx274.c
 create mode 100644 drivers/media/platform/cec-gpio/Makefile
 create mode 100644 drivers/media/platform/cec-gpio/cec-gpio.c
 create mode 100644 drivers/media/platform/rockchip/rga/Makefile
 create mode 100644 drivers/media/platform/rockchip/rga/rga-buf.c
 create mode 100644 drivers/media/platform/rockchip/rga/rga-hw.c
 create mode 100644 drivers/media/platform/rockchip/rga/rga-hw.h
 create mode 100644 drivers/media/platform/rockchip/rga/rga.c
 create mode 100644 drivers/media/platform/rockchip/rga/rga.h
 create mode 100644 drivers/media/platform/tegra-cec/Makefile
 create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.c
 create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.h
 create mode 100644 drivers/media/rc/keymaps/rc-astrometa-t2hybrid.c
 create mode 100644 drivers/media/rc/keymaps/rc-hisi-poplar.c
 create mode 100644 drivers/media/rc/keymaps/rc-hisi-tv-demo.c
 create mode 100644 drivers/media/rc/keymaps/rc-tango.c
 create mode 100644 drivers/media/rc/tango-ir.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/ap1302.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/ap1302.h
 rename drivers/staging/media/atomisp/i2c/{gc0310.c => atomisp-gc0310.c} (96%)
 rename drivers/staging/media/atomisp/i2c/{gc2235.c => atomisp-gc2235.c} (95%)
 rename drivers/staging/media/atomisp/i2c/{libmsrlisthelper.c => atomisp-libmsrlisthelper.c} (96%)
 rename drivers/staging/media/atomisp/i2c/{lm3554.c => atomisp-lm3554.c} (95%)
 rename drivers/staging/media/atomisp/i2c/{mt9m114.c => atomisp-mt9m114.c} (97%)
 rename drivers/staging/media/atomisp/i2c/{ov2680.c => atomisp-ov2680.c} (97%)
 rename drivers/staging/media/atomisp/i2c/{ov2722.c => atomisp-ov2722.c} (96%)
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/Kconfig
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/Makefile
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/ad5816g.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/ad5816g.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/common.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/drv201.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/drv201.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9714.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9714.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9718.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9718.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9719.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/dw9719.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx132.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx134.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx135.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx175.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx208.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx219.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/imx227.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/otp.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/otp_brcc064_e2prom.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/otp_e2prom.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/otp_imx.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/imx/vcm.c
 rename drivers/staging/media/atomisp/i2c/ov5693/{ov5693.c => atomisp-ov5693.c} (97%)
 delete mode 100644 drivers/staging/media/atomisp/include/asm/intel_mid_pcihelpers.h
 delete mode 100644 drivers/staging/media/atomisp/include/media/lm3642.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_include/storage_class.h
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/Makefile
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.c
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
 delete mode 100644 drivers/staging/media/atomisp/platform/intel-mid/intel_mid_pcihelpers.c
 delete mode 100644 include/linux/platform_data/media/gpio-ir-recv.h
