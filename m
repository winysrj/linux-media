Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55003 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbcAKNnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 08:43:39 -0500
Date: Mon, 11 Jan 2016 11:43:30 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.5-rc1] media core and driver updates
Message-ID: <20160111114330.3b3bad13@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.5-1

For the first part of patches for Kernel 4.5. There's nothing really big
here:
  - driver-specific headers for media devices were moved to separate
    directories, in order to make clear what headers belong to the core
    kABI and require documentation;
  - Platform data for media drivers were moved from include/media to
    include/linux/platform_data/media;
  - add a driver for cs3308 8-channel volume control, used on some
    high-end capture boards;
  - lirc.h kAPI header were added at include/uapi/linux;
  - Driver cleanups, new board additions and improvements.

Regards,
Mauro

---

The following changes since commit afd2ff9b7e1b367172f18ba7f693dfb62bdcb2dc:

  Linux 4.4 (2016-01-10 15:01:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.5-1

for you to fetch changes up to c3152592e70bbf023ec106ee9ea271e9060bc09a:

  Merge branch 'patchwork' into v4l_for_linus (2016-01-11 11:13:27 -0200)

----------------------------------------------------------------
media updates for v4.5-rc1

----------------------------------------------------------------
Alberto Mardegan (1):
      [media] em28xx: add Terratec Cinergy T XS (MT2060)

Alec Leamas (1):
      [media] bz#75751: Move internal header file lirc.h to uapi/

Alexey Khoroshilov (1):
      [media] lirc_imon: do not leave imon_probe() with mutex held

Andrzej Hajda (7):
      [media] staging: media: davinci_vpfe: fix ipipe_mode type
      [media] s5p-mfc: use one implementation of s5p_mfc_get_new_ctx
      [media] s5p-mfc: make queue cleanup code common
      [media] s5p-mfc: remove unnecessary callbacks
      [media] s5p-mfc: use spinlock to protect MFC context
      [media] s5p-mfc: merge together s5p_mfc_hw_call and s5p_mfc_hw_call_void
      [media] s5p-mfc: remove volatile attribute from MFC register addresses

Anton V. Shokurov (1):
      [media] uvcvideo: Fix reading the current exposure value of UVC

Antonio Ospite (1):
      [media] gspca: ov534/topro: prevent a division by 0

Antti Palosaari (3):
      [media] rtl28xxu: return demod reg page from driver cache
      [media] rtl2832: print reg number on error case
      [media] rtl2832: do not filter out slave TS null packets

Arnd Bergmann (6):
      [media] staging/davinci/vpfe/dm365: add missing dependencies
      [media] sh-vou: clarify videobuf2 dependency
      [media] davinci: add i2c Kconfig dependencies
      [media] staging: media: lirc: Replace timeval with ktime_t in lirc_serial.c
      [media] staging: media: lirc: Replace timeval with ktime_t in lirc_sasem.c
      [media] staging: media: lirc: Replace timeval with ktime_t in lirc_parallel.c

Arno Bauernöppel (1):
      [media] Add support for dvb usb stick Hauppauge WinTV-soloHD

Aviv Greenberg (1):
      [media] UVC: Add support for ds4 depth camera

Chen-Yu Tsai (1):
      [media] rc: sunxi-cir: Initialize the spinlock properly

Christian Engelmayer (1):
      [media] as102: fix potential double free in as102_fw_upload()

Dan Carpenter (3):
      [media] av7110: don't allow negative volumes
      [media] av7110: potential divide by zero
      [media] uvcvideo: small cleanup in uvc_video_clock_update()

Eric Nelson (2):
      [media] rc-core: define a default timeout for drivers
      [media] rc: gpio-ir-recv: add timeout on idle

Geert Uytterhoeven (1):
      [media] rcar_vin: Remove obsolete platform data support

Graham Whaley (1):
      [media] DocBook/media/Makefile: Do not fail mkdir if dir already exists

Hans Verkuil (26):
      [media] DocBook media: s/input stream/capture stream/
      [media] go7007: fix broken test
      [media] vivid: fix compliance error
      [media] vb2: fix a regression in poll() behavior for output,streams
      [media] adv7511: fix incorrect bit offset
      [media] v4l2-dv-timings: add new arg to v4l2_match_dv_timings
      [media] cx23885: fix format/crop handling
      [media] cx231xx: fix NTSC cropcap, add missing cropcap for 417
      [media] ivtv/cx18: fix inverted pixel aspect ratio
      [media] cx25840: fix VBI support for cx23888
      [media] cx25840: more cx23888 register address changes
      [media] cx25840: relax a Vsrc check
      [media] cx25840: fix cx25840_s_stream for cx2388x and cx231xx
      [media] cx25840: initialize the standard to NTSC_M
      [media] cs3308: add new 8-channel volume control driver
      [media] cx23885: add support for ViewCast 260e and 460e
      [media] cx23885: video instead of vbi register used
      [media] vb2: drop v4l2_format argument from queue_setup
      [media] DocBook media: update VIDIOC_CREATE_BUFS documentation
      [media] solo6x10: use v4l2_get_timestamp to fill in buffer timestamp
      [media] videobuf2-core.c: update module description
      [media] videobuf2-core: fill_user_buffer and copy_timestamp should return void
      [media] videobuf2-core: move __setup_lengths into __vb2_queue_alloc()
      [media] videobuf2-core: fill in q->bufs[vb->index] before buf_init()
      [media] videobuf2-core: call __setup_offsets before buf_init()
      [media] videobuf2-core: fix plane_sizes handling in VIDIOC_CREATE_BUFS

Heiner Kallweit (19):
      [media] media: rc: ir-sharp-decoder: add support for Denon variant of the protocol
      [media] media: rc: nuvoton-cir: remove unneeded IRQ_RETVAL usage
      [media] media: rc: nuvoton-cir: remove unneeded lock
      [media] media: rc: nuvoton-cir: switch resource handling to devm functions
      [media] media: rc: nuvoton-cir: improve chip detection
      [media] media: rc: nuvoton-cir: make nvt_hw_detect void
      [media] media: rc: nuvoton-cir: add support for the NCT6779D
      [media] media: rc: nuvoton-cir: simplify debug code
      [media] media: rc: nuvoton-cir: switch chip detection message to info level
      [media] media: rc: nuvoton-cir: replace nvt_pr with dev_ functions
      [media] media: rc-core: simplify logging in rc_register_device
      [media] media: rc: fix decoder module unloading
      [media] media: rc: preparation for on-demand decoder module loading
      [media] media: rc: constify struct proto_names
      [media] media: rc: load decoder modules on-demand
      [media] media: rc: move check whether a protocol is enabled to the core
      [media] media: rc: improve RC_BIT_ constant definition
      [media] media: cx23885: fix type of allowed_protos
      [media] media: rc: remove unneeded code

Insu Yun (1):
      [media] mxl111sf: missing return values validation

Javier Martinez Canillas (1):
      [media] s5c73m3: Export OF module alias information

Joseph Marrero (1):
      [media] radio-bcm2048: fix code indent

Josh Wu (9):
      [media] soc_camera: get the clock name by using macro: v4l2_clk_name_i2c()
      [media] v4l2-clk: add new macro for v4l2_clk_name_of()
      [media] v4l2-clk: add new definition: V4L2_CLK_NAME_SIZE
      [media] v4l2-clk: v4l2_clk_get() also need to find the of_fullname clock
      [media] atmel-isi: correct yuv swap according to different sensor outputs
      [media] atmel-isi: prepare for the support of preview path
      [media] atmel-isi: add code to setup correct resolution for preview path
      [media] atmel-isi: setup YCC_SWAP correctly when using preview path
      [media] atmel-isi: support RGB565 output when sensor output YUV formats

Julia Lawall (11):
      [media] drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c: use correct structure type name in sizeof
      [media] media: videobuf2: fix compare_const_fl.cocci warnings
      [media] radio-shark2: constify radio_tea5777_ops structures
      [media] i2c: constify v4l2_ctrl_ops structures
      [media] v4l: xilinx-tpg: add missing of_node_put
      [media] v4l: xilinx-vipp: add missing of_node_put
      [media] drivers/media/usb/dvb-usb-v2: constify mxl111sf_demod_config structure
      [media] ttusb-dec: constify ttusbdecfe_config structure
      [media] media, sound: tea575x: constify snd_tea575x_ops structures
      [media] cx231xx: constify cx2341x_handler_ops structures
      [media] s5p-mfc: constify s5p_mfc_codec_ops structures

Junghak Sung (6):
      [media] media: videobuf2: Move timestamp to vb2_buffer
      [media] media: videobuf2: Add copy_timestamp to struct vb2_queue
      [media] media: videobuf2: Separate vb2_poll()
      [media] media: videobuf2: last_buffer_queued is set at fill_v4l2_buffer()
      [media] media: videobuf2: Refactor vb2_fileio_data and vb2_thread
      [media] media: videobuf2: Move vb2_fileio_data and vb2_thread to core part

Junsu Shin (1):
      [media] staging: media: davinci_vpfe: Fix over 80 characters coding style issue

Kosuke Tatsukawa (1):
      [media] media: fix waitqueue_active without memory barrier in cpia2 driver

Lars-Peter Clausen (1):
      [media] dm1105: Remove unnecessary synchronize_irq() before free_irq()

Laura Abbott (1):
      [media] si2157: return -EINVAL if firmware blob is too big

Laurent Pinchart (4):
      [media] uvcvideo: Enable UVC 1.5 device detection
      [media] media: omap4iss: csi2: Fix IRQ handling when stopping module
      [media] media: omap4iss: Make module stop timeout print a warning message
      [media] v4l: omap_vout: Don't free buffers if they haven't been allocated

Malcolm Priestley (1):
      [media] media: dvb-core: Don't force CAN_INVERSION_AUTO in oneshot mode

Markus Elfring (2):
      [media] c8sectpfe: Delete unnecessary checks before two function calls
      [media] c8sectpfe: Combine three checks into a single if block

Mats Randgaard (1):
      [media] v4l2-dv-timings: Compare horizontal blanking

Matthias Schwarzott (12):
      [media] cx231xx_dvb: use demod_i2c for demod attach
      [media] si2165: fix checkpatch issues
      [media] si2165: rename frontend -> fe
      [media] si2165: rename si2165_set_parameters to si2165_set_frontend
      [media] si2165: create function si2165_write_reg_list for writing register lists
      [media] si2165: only write agc registers after reset before start_syncro
      [media] si2165: move setting ts config to init
      [media] si2165: Simplify si2165_set_if_freq_shift usage
      [media] si2165: set list of DVB-T registers together
      [media] si2165: Prepare si2165_set_frontend() for future DVB-C support
      [media] si2165: Add DVB-C support for HVR-4400/HVR-5500
      [media] tda10071: Fix dependency to REGMAP_I2C

Mauro Carvalho Chehab (41):
      Merge tag 'v4.4-rc1' into patchwork
      [media] Revert "[media] ivtv: avoid going past input/audio array"
      [media] ivtv: avoid going past input/audio array
      [media] demux.h: move documentation overview from device-drivers.tmpl
      [media] device-drivers.tmpl: better organize DVB function calls
      [media] dvb: document dvb_frontend_sleep_until()
      [media] Document the obscure dvb_frontend_reinitialise()
      [media] dvb_frontend: document the most used functions
      [media] dvb_frontend.h: Add a description for the header
      [media] demux.h: Some documentation fixups for the header
      [media] dvb_frontend: resume tone and voltage
      [media] dvb_frontend.h: Document suspend/resume functions
      [media] dvb_frontend.h: get rid of unused tuner params/states
      [media] stb6100: get rid of tuner_state at struct stb6100_state
      [media] tda665x: split set_frequency from set_state
      [media] tda666x: add support for set_parms() and get_frequency()
      [media] tda8261: don't use set_state/get_state callbacks
      [media] tda6655: get rid of get_state()/set_state()
      [media] stb6100: get rid of get_state()/set_state()
      [media] dvb_frontend: get rid of set_state ops & related data
      [media] dvb_frontend.h: improve documentation for struct dvb_tuner_ops
      [media] include/media: split I2C headers from V4L2 core
      [media] include/media: move driver interface headers to a separate dir
      [media] include/media: move platform_data to linux/platform_data/media
      [media] s5c73m3-spi: fix compilation breakage when compiled as Module
      DocBook: only copy stuff to media_api if media xml is generated
      [media] move media platform data to linux/platform_data/media
      smsir.h: remove a now duplicated definition (IR_DEFAULT_TIMEOUT)
      [media] fix dvb_frontend_sleep_until() logic
      Merge tag 'v4.4-rc2' into patchwork
      MAINTAINERS: use https://linuxtv.org for LinuxTV URLs
      WHENCE: use https://linuxtv.org for LinuxTV URLs
      drm, ipu-v3: use https://linuxtv.org for LinuxTV URL
      [media] use https://linuxtv.org for LinuxTV URLs
      Revert "[media] UVC: Add support for ds4 depth camera"
      [media] videobuf2: avoid memory leak on errors
      [media] cx23885-dvb: initialize a8293_pdata
      [media] cx23885-dvb: move initialization of a8293_pdata
      [media] ir-lirc-codec.c: don't leak lirc->drv-rbuf
      [media] au8522: Avoid memory leak for device config data
      Merge branch 'patchwork' into v4l_for_linus

Mikhail Ulyanov (2):
      [media] V4L2: platform: rcar_jpu: remove redundant code
      [media] V4L2: platform: rcar_jpu: switch off clock on release later

Mikko Rapeli (1):
      [media] include/uapi/linux/dvb/video.h: remove stdint.h include

Nate Weibley (1):
      [media] omap4iss: Fix overlapping luma/chroma planes

Nicholas Mc Guire (2):
      [media] staging: media: davinci_vpfe: drop condition with no effect
      [media] ddbridge: fix wait_event_timeout return handling

Oliver Neukum (1):
      [media] usbvision fix overflow of interfaces array

Peter Griffin (4):
      [media] ARM: DT: STi: stihxxx-b2120: Add pulse-width properties to ssc2 & ssc3
      [media] ARM: DT: STi: STiH407: Add c8sectpfe LinuxDVB DT node
      [media] c8sectpfe: Update binding to reset-gpios
      [media] c8sectpfe: Update DT binding doc with some minor fixes

Philipp Zabel (5):
      [media] coda: make to_coda_video_device static
      [media] coda: relax coda_jpeg_check_buffer for trailing bytes
      [media] coda: hook up vidioc_prepare_buf
      [media] coda: don't start streaming without queued buffers
      [media] coda: enable MPEG-2 ES decoding

Prashant Laddha (4):
      [media] v4l2-dv-timings: add condition checks for reduced fps
      [media] vivid: add support for reduced fps in video out
      [media] vivid-capture: add control for reduced frame rate
      [media] vivid: add support for reduced frame rate in video capture

Ricardo Ribalda Delgado (7):
      [media] v4l2-core/v4l2-ctrls: Filter NOOP CH_RANGE events
      [media] videodev2.h: Extend struct v4l2_ext_controls
      [media] media/core: Replace ctrl_class with which
      [media] media/v4l2-core: struct struct v4l2_ext_controls param which
      [media] usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
      [media] media/usb/pvrusb2: Support for V4L2_CTRL_WHICH_DEF_VAL
      [media] Docbook: media: Document changes on struct v4l2_ext_controls

Russell King (1):
      [media] rc: allow rc modules to be loaded if rc-main is not a module

Sakari Ailus (1):
      [media] staging: omap4iss: Compiling V4L2 framework and I2C as modules is fine

Sudeep Holla (1):
      [media] media: st-rc: remove misuse of IRQF_NO_SUSPEND flag

Terry Heo (1):
      [media] cx231xx: fix bulk transfer mode

Tina Ruchandani (1):
      [media] rc-core: Remove 'struct timeval' usage

Tommi Franttila (1):
      [media] v4l2-device: Don't unregister ACPI/Device Tree based devices

Ulrich Hecht (1):
      [media] media: adv7180: increase delay after reset to 5ms

Vladis Dronov (1):
      [media] usbvision: fix crash on detecting device with invalid configuration

Walter Cheuk (1):
      [media] tv tuner max2165 driver: extend frequency range

 Documentation/DocBook/device-drivers.tmpl          |  84 +-
 Documentation/DocBook/media/Makefile               |   6 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml    |   2 +-
 Documentation/DocBook/media/dvb/examples.xml       |   2 +-
 Documentation/DocBook/media/dvb/intro.xml          |   2 +-
 Documentation/DocBook/media/v4l/capture.c.xml      |   2 +-
 Documentation/DocBook/media/v4l/compat.xml         |   2 +-
 Documentation/DocBook/media/v4l/io.xml             |  10 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |  10 +
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |  30 +-
 .../DocBook/media/v4l/vidioc-dbg-g-chip-info.xml   |   2 +-
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml    |   2 +-
 Documentation/DocBook/media/v4l/vidioc-enumstd.xml |   2 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |  28 +-
 Documentation/DocBook/media_api.tmpl               |   6 +-
 .../bindings/media/stih407-c8sectpfe.txt           |  20 +-
 Documentation/dvb/README.dvb-usb                   |   4 +-
 Documentation/dvb/faq.txt                          |   2 +-
 Documentation/dvb/get_dvb_firmware                 |  22 +-
 Documentation/dvb/readme.txt                       |  10 +-
 Documentation/video4linux/API.html                 |   2 +-
 Documentation/video4linux/CARDLIST.em28xx          |   4 +-
 Documentation/video4linux/fimc.txt                 |   6 +-
 Documentation/video4linux/omap4_camera.txt         |   2 +-
 Documentation/video4linux/si4713.txt               |   2 +-
 Documentation/video4linux/v4l2-pci-skeleton.c      |  13 +-
 MAINTAINERS                                        | 226 ++---
 arch/arm/boot/dts/stihxxx-b2120.dtsi               |  46 +-
 arch/arm/mach-davinci/board-da850-evm.c            |   4 +-
 arch/arm/mach-davinci/board-dm355-evm.c            |   2 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |   4 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |   2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |   4 +-
 arch/arm/mach-imx/devices/devices-common.h         |   4 +-
 arch/arm/mach-omap1/include/mach/camera.h          |   2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   4 +-
 arch/arm/mach-pxa/devices.c                        |   2 +-
 arch/arm/mach-pxa/em-x270.c                        |   2 +-
 arch/arm/mach-pxa/ezx.c                            |   2 +-
 arch/arm/mach-pxa/mioa701.c                        |   2 +-
 arch/arm/mach-pxa/palmtreo.c                       |   2 +-
 arch/arm/mach-pxa/palmz72.c                        |   2 +-
 arch/arm/mach-pxa/pcm990-baseboard.c               |   4 +-
 arch/arm/plat-samsung/devs.c                       |   2 +-
 arch/blackfin/mach-bf561/boards/ezkit.c            |   2 +-
 arch/blackfin/mach-bf609/boards/ezkit.c            |   6 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |   6 +-
 arch/sh/boards/mach-ecovec24/setup.c               |  10 +-
 arch/sh/boards/mach-kfr2r09/setup.c                |   4 +-
 arch/sh/boards/mach-migor/setup.c                  |   6 +-
 arch/sh/boards/mach-se/7724/setup.c                |   6 +-
 drivers/gpu/ipu-v3/ipu-cpmem.c                     |   2 +-
 drivers/input/touchscreen/sur40.c                  |  13 +-
 drivers/media/Kconfig                              |   4 +-
 drivers/media/common/cx2341x.c                     |   2 +-
 drivers/media/common/saa7146/saa7146_core.c        |   2 +-
 drivers/media/common/saa7146/saa7146_fops.c        |   2 +-
 drivers/media/common/saa7146/saa7146_hlp.c         |   2 +-
 drivers/media/common/saa7146/saa7146_i2c.c         |   2 +-
 drivers/media/common/saa7146/saa7146_vbi.c         |   2 +-
 drivers/media/common/saa7146/saa7146_video.c       |   2 +-
 drivers/media/common/siano/smsir.h                 |   2 -
 drivers/media/dvb-core/demux.h                     |  67 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |   1 +
 drivers/media/dvb-core/dvb_frontend.c              |  27 +-
 drivers/media/dvb-core/dvb_frontend.h              | 221 +++--
 drivers/media/dvb-frontends/Kconfig                |   2 +-
 drivers/media/dvb-frontends/au8522_common.c        |  10 +-
 drivers/media/dvb-frontends/au8522_decoder.c       |  14 +-
 drivers/media/dvb-frontends/au8522_dig.c           |  16 +-
 drivers/media/dvb-frontends/au8522_priv.h          |   2 +-
 drivers/media/dvb-frontends/bsbe1-d01a.h           |   2 +-
 drivers/media/dvb-frontends/bsbe1.h                |   2 +-
 drivers/media/dvb-frontends/bsru6.h                |   2 +-
 drivers/media/dvb-frontends/isl6405.c              |   2 +-
 drivers/media/dvb-frontends/isl6405.h              |   2 +-
 drivers/media/dvb-frontends/isl6421.c              |   2 +-
 drivers/media/dvb-frontends/isl6421.h              |   2 +-
 drivers/media/dvb-frontends/lnbp21.c               |   2 +-
 drivers/media/dvb-frontends/lnbp21.h               |   2 +-
 drivers/media/dvb-frontends/lnbp22.c               |   2 +-
 drivers/media/dvb-frontends/lnbp22.h               |   2 +-
 drivers/media/dvb-frontends/rtl2832.c              |  21 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   4 +-
 drivers/media/dvb-frontends/si2165.c               | 351 +++++---
 drivers/media/dvb-frontends/stb6100.c              |  76 +-
 drivers/media/dvb-frontends/stb6100.h              |   1 -
 drivers/media/dvb-frontends/stb6100_cfg.h          |  37 +-
 drivers/media/dvb-frontends/stb6100_proc.h         |  43 +-
 drivers/media/dvb-frontends/tda665x.c              | 183 ++--
 drivers/media/dvb-frontends/tda8261.c              | 125 ++-
 drivers/media/dvb-frontends/tda8261_cfg.h          |  37 +-
 drivers/media/dvb-frontends/tdhd1.h                |   2 +-
 drivers/media/i2c/Kconfig                          |  10 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/ad9389b.c                        |   2 +-
 drivers/media/i2c/adp1653.c                        |   2 +-
 drivers/media/i2c/adv7180.c                        |   2 +-
 drivers/media/i2c/adv7183.c                        |   2 +-
 drivers/media/i2c/adv7343.c                        |   2 +-
 drivers/media/i2c/adv7393.c                        |   2 +-
 drivers/media/i2c/adv7511.c                        |   4 +-
 drivers/media/i2c/adv7604.c                        |   8 +-
 drivers/media/i2c/adv7842.c                        |   8 +-
 drivers/media/i2c/ak881x.c                         |   2 +-
 drivers/media/i2c/as3645a.c                        |   2 +-
 drivers/media/i2c/bt819.c                          |   2 +-
 drivers/media/i2c/cs3308.c                         | 138 +++
 drivers/media/i2c/cx25840/cx25840-audio.c          |   2 +-
 drivers/media/i2c/cx25840/cx25840-core.c           | 117 +--
 drivers/media/i2c/cx25840/cx25840-core.h           |   1 +
 drivers/media/i2c/cx25840/cx25840-firmware.c       |   2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |   2 +-
 drivers/media/i2c/cx25840/cx25840-vbi.c            |  34 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |   2 +-
 drivers/media/i2c/lm3560.c                         |   2 +-
 drivers/media/i2c/lm3646.c                         |   2 +-
 drivers/media/i2c/m52790.c                         |   2 +-
 drivers/media/i2c/m5mols/m5mols_capture.c          |   4 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   2 +-
 drivers/media/i2c/msp3400-driver.c                 |   4 +-
 drivers/media/i2c/msp3400-driver.h                 |   2 +-
 drivers/media/i2c/msp3400-kthreads.c               |   2 +-
 drivers/media/i2c/mt9m032.c                        |   4 +-
 drivers/media/i2c/mt9p031.c                        |   4 +-
 drivers/media/i2c/mt9t001.c                        |   4 +-
 drivers/media/i2c/mt9v011.c                        |   4 +-
 drivers/media/i2c/mt9v032.c                        |   4 +-
 drivers/media/i2c/noon010pc30.c                    |   2 +-
 drivers/media/i2c/ov2659.c                         |   4 +-
 drivers/media/i2c/ov7670.c                         |   2 +-
 drivers/media/i2c/ov9650.c                         |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c          |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |   1 +
 drivers/media/i2c/s5c73m3/s5c73m3.h                |   2 +-
 drivers/media/i2c/s5k4ecgx.c                       |   2 +-
 drivers/media/i2c/s5k6aa.c                         |   2 +-
 drivers/media/i2c/saa6588.c                        |   2 +-
 drivers/media/i2c/saa7115.c                        |   2 +-
 drivers/media/i2c/saa7127.c                        |   2 +-
 drivers/media/i2c/smiapp/smiapp.h                  |   2 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |   2 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |   2 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   4 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   2 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   2 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   2 +-
 drivers/media/i2c/sr030pc30.c                      |   2 +-
 drivers/media/i2c/tc358743.c                       |   6 +-
 drivers/media/i2c/ths7303.c                        |   2 +-
 drivers/media/i2c/tvaudio.c                        |   2 +-
 drivers/media/i2c/tvp514x.c                        |   2 +-
 drivers/media/i2c/tvp5150.c                        |   2 +-
 drivers/media/i2c/tvp7002.c                        |   2 +-
 drivers/media/i2c/uda1342.c                        |   2 +-
 drivers/media/i2c/upd64031a.c                      |   2 +-
 drivers/media/i2c/upd64083.c                       |   2 +-
 drivers/media/i2c/wm8775.c                         |   2 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |   4 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   6 +-
 drivers/media/pci/bt8xx/bttvp.h                    |   4 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |   6 +-
 drivers/media/pci/cobalt/cobalt-irq.c              |   4 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |  18 +-
 drivers/media/pci/cx18/cx18-cards.c                |   2 +-
 drivers/media/pci/cx18/cx18-controls.c             |   2 +-
 drivers/media/pci/cx18/cx18-controls.h             |   2 +-
 drivers/media/pci/cx18/cx18-driver.h               |   2 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |   4 +-
 drivers/media/pci/cx18/cx23418.h                   |   2 +-
 drivers/media/pci/cx23885/Kconfig                  |   1 +
 drivers/media/pci/cx23885/cx23885-417.c            |   4 +-
 drivers/media/pci/cx23885/cx23885-cards.c          | 116 ++-
 drivers/media/pci/cx23885/cx23885-core.c           |  12 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   8 +-
 drivers/media/pci/cx23885/cx23885-i2c.c            |   2 +
 drivers/media/pci/cx23885/cx23885-input.c          |   2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |   5 +-
 drivers/media/pci/cx23885/cx23885-video.c          |  49 +-
 drivers/media/pci/cx23885/cx23885.h                |   9 +-
 drivers/media/pci/cx25821/cx25821-video.c          |  14 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |   2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   4 +-
 drivers/media/pci/cx88/cx88-core.c                 |   2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   2 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |   2 +-
 drivers/media/pci/cx88/cx88-video.c                |   4 +-
 drivers/media/pci/cx88/cx88.h                      |   6 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |   4 +-
 drivers/media/pci/dm1105/dm1105.c                  |   1 -
 drivers/media/pci/dt3155/dt3155.c                  |  13 +-
 drivers/media/pci/ivtv/ivtv-cards.c                |  12 +-
 drivers/media/pci/ivtv/ivtv-controls.c             |   2 +-
 drivers/media/pci/ivtv/ivtv-controls.h             |   2 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |   4 +-
 drivers/media/pci/ivtv/ivtv-driver.h               |   4 +-
 drivers/media/pci/ivtv/ivtv-fileops.c              |   2 +-
 drivers/media/pci/ivtv/ivtv-firmware.c             |   2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |   2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |  10 +-
 drivers/media/pci/ivtv/ivtv-routing.c              |   8 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |   3 +-
 drivers/media/pci/saa7134/saa7134-core.c           |   2 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |   2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |   2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   4 +-
 drivers/media/pci/saa7134/saa7134.h                |   4 +-
 drivers/media/pci/saa7146/hexium_gemini.c          |   2 +-
 drivers/media/pci/saa7146/hexium_orion.c           |   2 +-
 drivers/media/pci/saa7146/mxb.c                    |   4 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   4 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   4 +-
 drivers/media/pci/ttpci/av7110.c                   |   6 +-
 drivers/media/pci/ttpci/av7110.h                   |   2 +-
 drivers/media/pci/ttpci/av7110_av.c                |  11 +-
 drivers/media/pci/ttpci/av7110_av.h                |   3 +-
 drivers/media/pci/ttpci/av7110_ca.c                |   2 +-
 drivers/media/pci/ttpci/av7110_hw.c                |   2 +-
 drivers/media/pci/ttpci/av7110_v4l.c               |   2 +-
 drivers/media/pci/ttpci/budget-av.c                |   4 +-
 drivers/media/pci/ttpci/budget-ci.c                |   2 +-
 drivers/media/pci/ttpci/budget-core.c              |   2 +-
 drivers/media/pci/ttpci/budget-patch.c             |   2 +-
 drivers/media/pci/ttpci/budget.c                   |   2 +-
 drivers/media/pci/ttpci/budget.h                   |   2 +-
 drivers/media/pci/tw68/tw68-video.c                |  22 +-
 drivers/media/pci/zoran/zoran_card.c               |   2 +-
 drivers/media/platform/Kconfig                     |   2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |  19 +-
 drivers/media/platform/blackfin/bfin_capture.c     |  14 +-
 drivers/media/platform/coda/coda-bit.c             |   8 +-
 drivers/media/platform/coda/coda-common.c          |  25 +-
 drivers/media/platform/coda/coda-jpeg.c            |  26 +-
 drivers/media/platform/coda/coda.h                 |   4 +-
 drivers/media/platform/davinci/Kconfig             |   6 +
 drivers/media/platform/davinci/vpbe_display.c      |  15 +-
 drivers/media/platform/davinci/vpif_capture.c      |  19 +-
 drivers/media/platform/davinci/vpif_display.c      |  19 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   5 +-
 drivers/media/platform/exynos4-is/common.c         |   2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |  33 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  35 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |   2 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |   2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  35 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |   2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   4 +-
 drivers/media/platform/exynos4-is/fimc-reg.c       |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   2 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   2 +-
 drivers/media/platform/m2m-deinterlace.c           |   3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |  17 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |   2 +-
 drivers/media/platform/mx2_emmaprp.c               |   3 +-
 drivers/media/platform/omap/omap_vout_vrfb.c       |  10 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   3 +-
 drivers/media/platform/rcar_jpu.c                  |  40 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |  35 +-
 drivers/media/platform/s3c-camif/camif-core.h      |   2 +-
 drivers/media/platform/s3c-camif/camif-regs.h      |   2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |   4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 103 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  14 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |  16 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  39 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.h       |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  47 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.h       |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       | 507 ++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |  94 ---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    | 121 +--
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   4 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   2 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |   2 +-
 drivers/media/platform/sh_veu.c                    |  33 +-
 drivers/media/platform/sh_vou.c                    |  15 +-
 drivers/media/platform/soc_camera/atmel-isi.c      | 168 +++-
 drivers/media/platform/soc_camera/atmel-isi.h      |  10 +
 drivers/media/platform/soc_camera/mx2_camera.c     |  12 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |  44 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |   4 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |   4 +-
 drivers/media/platform/soc_camera/rcar_vin.c       | 119 +--
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  45 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |   6 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  25 +-
 .../platform/soc_camera/soc_camera_platform.c      |   2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |   2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |  14 +-
 .../platform/sti/c8sectpfe/c8sectpfe-common.c      |  16 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |   2 +-
 drivers/media/platform/ti-vpe/vpe.c                |   3 +-
 drivers/media/platform/timblogiw.c                 |   2 +-
 drivers/media/platform/via-camera.c                |   2 +-
 drivers/media/platform/vim2m.c                     |  15 +-
 drivers/media/platform/vivid/vivid-core.h          |   3 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |  35 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   6 +-
 drivers/media/platform/vivid/vivid-kthread-out.c   |   8 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   6 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |   8 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |   2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |  34 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |  30 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  53 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |  14 +-
 drivers/media/platform/xilinx/xilinx-tpg.c         |   2 +
 drivers/media/platform/xilinx/xilinx-vipp.c        |   4 +-
 drivers/media/radio/radio-maxiradio.c              |   4 +-
 drivers/media/radio/radio-sf16fmr2.c               |   4 +-
 drivers/media/radio/radio-shark.c                  |   4 +-
 drivers/media/radio/radio-shark2.c                 |   2 +-
 drivers/media/radio/radio-si476x.c                 |   2 +-
 drivers/media/radio/radio-tea5777.h                |   2 +-
 drivers/media/radio/radio-timb.c                   |   2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c      |   2 +-
 drivers/media/radio/si4713/si4713.h                |   2 +-
 drivers/media/radio/tea575x.c                      |   2 +-
 drivers/media/rc/Kconfig                           |   3 +-
 drivers/media/rc/gpio-ir-recv.c                    |  24 +-
 drivers/media/rc/ir-jvc-decoder.c                  |   3 -
 drivers/media/rc/ir-lirc-codec.c                   |   1 +
 drivers/media/rc/ir-mce_kbd-decoder.c              |   3 -
 drivers/media/rc/ir-nec-decoder.c                  |   3 -
 drivers/media/rc/ir-rc5-decoder.c                  |   3 -
 drivers/media/rc/ir-rc6-decoder.c                  |   5 -
 drivers/media/rc/ir-rx51.c                         |   2 +-
 drivers/media/rc/ir-sanyo-decoder.c                |   3 -
 drivers/media/rc/ir-sharp-decoder.c                |   7 +-
 drivers/media/rc/ir-sony-decoder.c                 |   4 -
 drivers/media/rc/ir-xmp-decoder.c                  |   3 -
 drivers/media/rc/nuvoton-cir.c                     | 156 ++--
 drivers/media/rc/nuvoton-cir.h                     |  28 +-
 drivers/media/rc/rc-core-priv.h                    |  71 --
 drivers/media/rc/rc-ir-raw.c                       |  41 +-
 drivers/media/rc/rc-main.c                         |  88 +-
 drivers/media/rc/st_rc.c                           |  14 +-
 drivers/media/rc/streamzap.c                       |  19 +-
 drivers/media/rc/sunxi-cir.c                       |   2 +
 drivers/media/tuners/max2165.c                     |   2 +-
 drivers/media/tuners/mt2063.c                      |   1 -
 drivers/media/tuners/si2157.c                      |   1 +
 drivers/media/usb/airspy/airspy.c                  |   4 +-
 drivers/media/usb/as102/as102_fw.c                 |   1 +
 drivers/media/usb/au0828/au0828-vbi.c              |  14 +-
 drivers/media/usb/au0828/au0828-video.c            |  14 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |   3 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |  26 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  10 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |  15 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |   8 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   7 +-
 drivers/media/usb/cx231xx/cx231xx.h                |   4 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |   2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c      |   4 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h      |   4 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |   6 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |  16 +-
 drivers/media/usb/dvb-usb/Kconfig                  |   2 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |   4 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |  18 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |  15 +
 drivers/media/usb/em28xx/em28xx-vbi.c              |  20 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  23 +-
 drivers/media/usb/em28xx/em28xx.h                  |   2 +-
 drivers/media/usb/go7007/go7007-driver.c           |   2 +-
 drivers/media/usb/go7007/go7007-usb.c              |   6 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   3 +-
 drivers/media/usb/gspca/ov534.c                    |   9 +-
 drivers/media/usb/gspca/topro.c                    |   6 +-
 drivers/media/usb/hackrf/hackrf.c                  |   6 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   2 +-
 drivers/media/usb/hdpvr/hdpvr.h                    |   2 +-
 drivers/media/usb/msi2500/msi2500.c                |   1 -
 drivers/media/usb/pvrusb2/pvrusb2-audio.c          |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c    |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h   |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |  16 +-
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c      |   2 +-
 drivers/media/usb/pwc/pwc-if.c                     |   5 +-
 drivers/media/usb/s2255/s2255drv.c                 |   4 +-
 drivers/media/usb/stk1160/stk1160-core.c           |   2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |   4 +-
 drivers/media/usb/stk1160/stk1160-video.c          |   2 +-
 drivers/media/usb/tm6000/tm6000-cards.c            |   2 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |   2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |  11 +-
 drivers/media/usb/usbvision/usbvision-core.c       |   2 +-
 drivers/media/usb/usbvision/usbvision-video.c      |  25 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   3 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   3 +-
 drivers/media/usb/uvc/uvc_queue.c                  |  14 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  20 +
 drivers/media/usb/uvc/uvc_video.c                  |  17 +-
 drivers/media/v4l2-core/v4l2-clk.c                 |   9 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   6 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  77 +-
 drivers/media/v4l2-core/v4l2-device.c              |  21 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |  16 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  14 +-
 drivers/media/v4l2-core/videobuf2-core.c           | 926 +++++++++++++++++++--
 drivers/media/v4l2-core/videobuf2-internal.h       | 161 ----
 drivers/media/v4l2-core/videobuf2-v4l2.c           | 703 ++--------------
 drivers/mfd/timberdale.c                           |   4 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c      |   4 +-
 drivers/staging/media/davinci_vpfe/Kconfig         |   2 +
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |   5 +-
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   7 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |   2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   4 +-
 drivers/staging/media/lirc/lirc_imon.c             |   2 +
 drivers/staging/media/lirc/lirc_parallel.c         |  35 +-
 drivers/staging/media/lirc/lirc_sasem.c            |  20 +-
 drivers/staging/media/lirc/lirc_serial.c           |  50 +-
 drivers/staging/media/omap4iss/Kconfig             |   2 +-
 drivers/staging/media/omap4iss/iss.c               |   4 +-
 drivers/staging/media/omap4iss/iss.h               |   2 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |   6 +-
 drivers/staging/media/omap4iss/iss_csiphy.h        |   2 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |   4 +-
 drivers/staging/media/omap4iss/iss_video.c         |   3 +-
 drivers/usb/gadget/function/uvc_queue.c            |   4 +-
 firmware/WHENCE                                    |   2 +-
 include/linux/platform_data/camera-rcar.h          |  25 -
 .../linux/platform_data/{ => media}/camera-mx2.h   |   0
 .../linux/platform_data/{ => media}/camera-mx3.h   |   0
 .../linux/platform_data/{ => media}/camera-pxa.h   |   0
 include/linux/platform_data/{ => media}/coda.h     |   0
 .../{ => linux/platform_data}/media/gpio-ir-recv.h |   1 -
 include/{ => linux/platform_data}/media/ir-rx51.h  |   0
 .../{ => linux/platform_data}/media/mmp-camera.h   |   0
 .../{ => linux/platform_data}/media/omap1_camera.h |   0
 include/{ => linux/platform_data}/media/omap4iss.h |   0
 include/{ => linux/platform_data}/media/s5p_hdmi.h |   1 -
 include/{ => linux/platform_data}/media/si4713.h   |   2 +-
 include/{ => linux/platform_data}/media/sii9234.h  |   0
 .../platform_data}/media/soc_camera_platform.h     |   0
 .../{ => linux/platform_data}/media/timb_radio.h   |   0
 .../{ => linux/platform_data}/media/timb_video.h   |   0
 include/linux/videodev2.h                          |   2 +-
 include/media/{ => drv-intf}/cx2341x.h             |   0
 include/media/{ => drv-intf}/cx25840.h             |   0
 include/media/{ => drv-intf}/exynos-fimc.h         |   0
 include/media/{ => drv-intf}/msp3400.h             |   1 -
 include/media/{ => drv-intf}/s3c_camif.h           |   0
 include/media/{ => drv-intf}/saa7146.h             |   0
 include/media/{ => drv-intf}/saa7146_vv.h          |   2 +-
 include/media/{ => drv-intf}/sh_mobile_ceu.h       |   0
 include/media/{ => drv-intf}/sh_mobile_csi2.h      |   0
 include/media/{ => drv-intf}/sh_vou.h              |   0
 include/media/{ => drv-intf}/si476x.h              |   2 +-
 include/media/{ => drv-intf}/soc_mediabus.h        |   0
 include/media/{ => drv-intf}/tea575x.h             |   2 +-
 include/media/{ => i2c}/ad9389b.h                  |   0
 include/media/{ => i2c}/adp1653.h                  |   2 +-
 include/media/{ => i2c}/adv7183.h                  |   0
 include/media/{ => i2c}/adv7343.h                  |   0
 include/media/{ => i2c}/adv7393.h                  |   0
 include/media/{ => i2c}/adv7511.h                  |   0
 include/media/{ => i2c}/adv7604.h                  |   0
 include/media/{ => i2c}/adv7842.h                  |   0
 include/media/{ => i2c}/ak881x.h                   |   0
 include/media/{ => i2c}/as3645a.h                  |   2 +-
 include/media/{ => i2c}/bt819.h                    |   0
 include/media/{ => i2c}/cs5345.h                   |   0
 include/media/{ => i2c}/cs53l32a.h                 |   0
 include/media/{ => i2c}/ir-kbd-i2c.h               |   0
 include/media/{ => i2c}/lm3560.h                   |   2 +-
 include/media/{ => i2c}/lm3646.h                   |   2 +-
 include/media/{ => i2c}/m52790.h                   |   0
 include/media/{ => i2c}/m5mols.h                   |   0
 include/media/{ => i2c}/mt9m032.h                  |   0
 include/media/{ => i2c}/mt9p031.h                  |   0
 include/media/{ => i2c}/mt9t001.h                  |   0
 include/media/{ => i2c}/mt9t112.h                  |   0
 include/media/{ => i2c}/mt9v011.h                  |   0
 include/media/{ => i2c}/mt9v022.h                  |   0
 include/media/{ => i2c}/mt9v032.h                  |   0
 include/media/{ => i2c}/noon010pc30.h              |   0
 include/media/{ => i2c}/ov2659.h                   |   0
 include/media/{ => i2c}/ov7670.h                   |   0
 include/media/{ => i2c}/ov772x.h                   |   0
 include/media/{ => i2c}/ov9650.h                   |   0
 include/media/{ => i2c}/rj54n1cb0c.h               |   0
 include/media/{ => i2c}/s5c73m3.h                  |   0
 include/media/{ => i2c}/s5k4ecgx.h                 |   0
 include/media/{ => i2c}/s5k6aa.h                   |   0
 include/media/{ => i2c}/saa6588.h                  |   0
 include/media/{ => i2c}/saa7115.h                  |   1 -
 include/media/{ => i2c}/saa7127.h                  |   1 -
 include/media/{ => i2c}/smiapp.h                   |   2 +-
 include/media/{ => i2c}/sr030pc30.h                |   0
 include/media/{ => i2c}/tc358743.h                 |   0
 include/media/{ => i2c}/ths7303.h                  |   0
 include/media/{ => i2c}/tvaudio.h                  |   0
 include/media/{ => i2c}/tvp514x.h                  |   0
 include/media/{ => i2c}/tvp5150.h                  |   1 -
 include/media/{ => i2c}/tvp7002.h                  |   0
 include/media/{ => i2c}/tw9910.h                   |   0
 include/media/{ => i2c}/uda1342.h                  |   0
 include/media/{ => i2c}/upd64031a.h                |   0
 include/media/{ => i2c}/upd64083.h                 |   0
 include/media/{ => i2c}/wm8775.h                   |   0
 include/media/lirc.h                               | 169 +---
 include/media/rc-core.h                            |   1 +
 include/media/rc-map.h                             |  40 +-
 include/media/v4l2-clk.h                           |   5 +
 include/media/v4l2-dv-timings.h                    |  25 +-
 include/media/videobuf2-core.h                     | 108 ++-
 include/media/videobuf2-v4l2.h                     |  40 +-
 include/trace/events/v4l2.h                        |   4 +-
 include/trace/events/vb2.h                         |   7 +-
 include/uapi/drm/drm_fourcc.h                      |   2 +-
 include/uapi/linux/dvb/video.h                     |   1 -
 include/uapi/linux/lirc.h                          | 168 ++++
 include/uapi/linux/usb/video.h                     |   1 +
 include/uapi/linux/v4l2-controls.h                 |   6 +-
 include/uapi/linux/videodev2.h                     |  14 +-
 sound/pci/es1968.c                                 |   4 +-
 sound/pci/fm801.c                                  |   4 +-
 528 files changed, 4540 insertions(+), 4096 deletions(-)
 create mode 100644 drivers/media/i2c/cs3308.c
 delete mode 100644 drivers/media/v4l2-core/videobuf2-internal.h
 delete mode 100644 include/linux/platform_data/camera-rcar.h
 rename include/linux/platform_data/{ => media}/camera-mx2.h (100%)
 rename include/linux/platform_data/{ => media}/camera-mx3.h (100%)
 rename include/linux/platform_data/{ => media}/camera-pxa.h (100%)
 rename include/linux/platform_data/{ => media}/coda.h (100%)
 rename include/{ => linux/platform_data}/media/gpio-ir-recv.h (99%)
 rename include/{ => linux/platform_data}/media/ir-rx51.h (100%)
 rename include/{ => linux/platform_data}/media/mmp-camera.h (100%)
 rename include/{ => linux/platform_data}/media/omap1_camera.h (100%)
 rename include/{ => linux/platform_data}/media/omap4iss.h (100%)
 rename include/{ => linux/platform_data}/media/s5p_hdmi.h (99%)
 rename include/{ => linux/platform_data}/media/si4713.h (96%)
 rename include/{ => linux/platform_data}/media/sii9234.h (100%)
 rename include/{ => linux/platform_data}/media/soc_camera_platform.h (100%)
 rename include/{ => linux/platform_data}/media/timb_radio.h (100%)
 rename include/{ => linux/platform_data}/media/timb_video.h (100%)
 rename include/media/{ => drv-intf}/cx2341x.h (100%)
 rename include/media/{ => drv-intf}/cx25840.h (100%)
 rename include/media/{ => drv-intf}/exynos-fimc.h (100%)
 rename include/media/{ => drv-intf}/msp3400.h (99%)
 rename include/media/{ => drv-intf}/s3c_camif.h (100%)
 rename include/media/{ => drv-intf}/saa7146.h (100%)
 rename include/media/{ => drv-intf}/saa7146_vv.h (99%)
 rename include/media/{ => drv-intf}/sh_mobile_ceu.h (100%)
 rename include/media/{ => drv-intf}/sh_mobile_csi2.h (100%)
 rename include/media/{ => drv-intf}/sh_vou.h (100%)
 rename include/media/{ => drv-intf}/si476x.h (94%)
 rename include/media/{ => drv-intf}/soc_mediabus.h (100%)
 rename include/media/{ => drv-intf}/tea575x.h (98%)
 rename include/media/{ => i2c}/ad9389b.h (100%)
 rename include/media/{ => i2c}/adp1653.h (99%)
 rename include/media/{ => i2c}/adv7183.h (100%)
 rename include/media/{ => i2c}/adv7343.h (100%)
 rename include/media/{ => i2c}/adv7393.h (100%)
 rename include/media/{ => i2c}/adv7511.h (100%)
 rename include/media/{ => i2c}/adv7604.h (100%)
 rename include/media/{ => i2c}/adv7842.h (100%)
 rename include/media/{ => i2c}/ak881x.h (100%)
 rename include/media/{ => i2c}/as3645a.h (98%)
 rename include/media/{ => i2c}/bt819.h (100%)
 rename include/media/{ => i2c}/cs5345.h (100%)
 rename include/media/{ => i2c}/cs53l32a.h (100%)
 rename include/media/{ => i2c}/ir-kbd-i2c.h (100%)
 rename include/media/{ => i2c}/lm3560.h (98%)
 rename include/media/{ => i2c}/lm3646.h (98%)
 rename include/media/{ => i2c}/m52790.h (100%)
 rename include/media/{ => i2c}/m5mols.h (100%)
 rename include/media/{ => i2c}/mt9m032.h (100%)
 rename include/media/{ => i2c}/mt9p031.h (100%)
 rename include/media/{ => i2c}/mt9t001.h (100%)
 rename include/media/{ => i2c}/mt9t112.h (100%)
 rename include/media/{ => i2c}/mt9v011.h (100%)
 rename include/media/{ => i2c}/mt9v022.h (100%)
 rename include/media/{ => i2c}/mt9v032.h (100%)
 rename include/media/{ => i2c}/noon010pc30.h (100%)
 rename include/media/{ => i2c}/ov2659.h (100%)
 rename include/media/{ => i2c}/ov7670.h (100%)
 rename include/media/{ => i2c}/ov772x.h (100%)
 rename include/media/{ => i2c}/ov9650.h (100%)
 rename include/media/{ => i2c}/rj54n1cb0c.h (100%)
 rename include/media/{ => i2c}/s5c73m3.h (100%)
 rename include/media/{ => i2c}/s5k4ecgx.h (100%)
 rename include/media/{ => i2c}/s5k6aa.h (100%)
 rename include/media/{ => i2c}/saa6588.h (100%)
 rename include/media/{ => i2c}/saa7115.h (99%)
 rename include/media/{ => i2c}/saa7127.h (99%)
 rename include/media/{ => i2c}/smiapp.h (98%)
 rename include/media/{ => i2c}/sr030pc30.h (100%)
 rename include/media/{ => i2c}/tc358743.h (100%)
 rename include/media/{ => i2c}/ths7303.h (100%)
 rename include/media/{ => i2c}/tvaudio.h (100%)
 rename include/media/{ => i2c}/tvp514x.h (100%)
 rename include/media/{ => i2c}/tvp5150.h (99%)
 rename include/media/{ => i2c}/tvp7002.h (100%)
 rename include/media/{ => i2c}/tw9910.h (100%)
 rename include/media/{ => i2c}/uda1342.h (100%)
 rename include/media/{ => i2c}/upd64031a.h (100%)
 rename include/media/{ => i2c}/upd64083.h (100%)
 rename include/media/{ => i2c}/wm8775.h (100%)
 create mode 100644 include/uapi/linux/lirc.h

