Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49895 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbbFYMjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 08:39:21 -0400
Date: Thu, 25 Jun 2015 09:39:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.2-rc1] media updates
Message-ID: <20150625093915.6bd3cf17@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.2-1

For the following media updates:
- Lots of improvements at the DVB API DocBook documentation. Now, the frontend
  and the network APIs are fully in sync with the Kernel and looks more like
  the rest of the media documentation;
- New frontend driver: cx24120
- New driver for a PCI device: cobalt. This driver is actually not sold in
  the market, but it is a good example of a multi-HDMI input device;
- The dt3155 driver were promoted from staging;
- The mantis driver got remote controller support;
- New V4L2 driver for ST bdisp SoC chipsets;
- Make sparse and smatch happier: several bugs were solved by fixing
  the issues reported by those static code analyzers.
- Lots of new device additions, new features, improvements and cleanups at
  the existing drivers.

The following changes since commit 030bbdbf4c833bc69f502eae58498bc5572db736:

  Linux 4.1-rc3 (2015-05-10 15:12:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.2-1

for you to fetch changes up to faebbd8f134f0c054f372982c8ddd1bbcc41b440:

  [media] lmedm04: fix the range for relative measurements (2015-06-24 08:38:30 -0300)

----------------------------------------------------------------
media updates for v4.2-rc1

----------------------------------------------------------------
Alexey Khoroshilov (1):
      [media] marvell-ccic: fix memory leak on failure path in cafe_smbus_setup()

Antonio Ospite (1):
      [media] cx25821: cx25821-medusa-reg.h: fix 0x0x prefix

Antti Palosaari (56):
      [media] msi001: revise synthesizer calculation
      [media] msi001: cleanups / renames
      [media] msi2500: revise synthesizer calculation
      [media] msi2500: cleanups
      [media] fc2580: implement I2C client bindings
      [media] rtl28xxu: bind fc2580 using I2C binding
      [media] af9035: bind fc2580 using I2C binding
      [media] fc2580: remove obsolete media attach
      [media] fc2580: improve set params logic
      [media] fc2580: cleanups and variable renames
      [media] fc2580: use regmap for register I2C access
      [media] af9035: fix device order in ID list
      [media] tua9001: add I2C bindings
      [media] af9035: bind tua9001 using I2C binding
      [media] rtl28xxu: bind tua9001 using I2C binding
      [media] tua9001: remove media attach
      [media] tua9001: various minor changes
      [media] tua9001: use regmap for I2C register access
      [media] tua9001: use div_u64() for frequency calculation
      [media] rtl2832: add inittab for FC2580 tuner
      [media] rtl28xxu: set correct FC2580 tuner for RTL2832 demod
      [media] fc2580: calculate filter control word dynamically
      [media] fc2580: implement V4L2 subdevice for SDR control
      [media] rtl2832_sdr: add support for fc2580 tuner
      [media] rtl28xxu: load SDR module for fc2580 based devices
      [media] e4000: revise synthesizer calculation
      [media] e4000: various small changes
      [media] e4000: implement V4L2 subdevice tuner and core ops
      [media] dvb-core: fix 32-bit overflow during bandwidth calculation
      [media] vivid: SDR cap add 'CU08' Complex U8 format
      [media] v4l2: correct two SDR format names
      [media] m88ds3103: do not return error from get_frontend() when not ready
      [media] m88ds3103: implement DVBv5 CNR statistics
      [media] m88ds3103: implement DVBv5 BER
      [media] m88ds3103: use jiffies when polling DiSEqC TX ready
      [media] m88ds3103: add I2C client binding
      [media] af9035: add USB ID 07ca:0337 AVerMedia HD Volar (A867)
      [media] si2168: Implement own I2C adapter locking
      [media] si2157: implement signal strength stats
      [media] tda10071: implement I2C client bindings
      [media] a8293: implement I2C client bindings
      [media] em28xx: add support for DVB SEC I2C client
      [media] em28xx: bind PCTV 460e using I2C client
      [media] cx23885: add support for DVB I2C SEC client
      [media] cx23885: Hauppauge WinTV Starburst bind I2C demod and SEC
      [media] cx23885: Hauppauge WinTV-HVR4400/HVR5500 bind I2C demod and SEC
      [media] cx23885: Hauppauge WinTV-HVR5525 bind I2C SEC
      [media] tda10071: add missing error status when probe() fails
      [media] fc2580: add missing error status when probe() fails
      [media] ts2020: re-implement PLL calculations
      [media] ts2020: improve filter limit calc
      [media] ts2020: register I2C driver from legacy media attach
      [media] ts2020: convert to regmap I2C API
      [media] m88ds3103: rename variables and correct logging
      [media] m88ds3103: use regmap for I2C register access
      [media] em28xx: PCTV 461e use I2C client for demod and SEC

Antti Seppälä (3):
      [media] rc: rc-ir-raw: Add Manchester encoder (phase encoder) helper
      [media] rc: ir-rc6-decoder: Add encode capability
      [media] rc: nuvoton-cir: Add support for writing wakeup samples via sysfs filter callback

Arnd Bergmann (3):
      [media] exynos4_is: exynos4-fimc requires i2c
      [media] R820T tuner needs CONFIG_BITREVERSE
      [media] coda: remove extraneous TRACE_SYSTEM_STRING

Brendan McGrath (1):
      [media] saa7164: use an MSI interrupt when available

Cheolhyun Park (1):
      [media] drx-j: Misspelled comment corrected

Christian Engelmayer (1):
      [media] mn88472: Fix possible leak in mn88472_init()

Dan Carpenter (5):
      [media] i2c: ov2659: signedness bug inov2659_set_fmt()
      [media] v4l: xilinx: harmless buffer overflow
      [media] rtl2832_sdr: cleanup some set_bit() calls
      [media] m88ds3103: a couple missing error codes
      [media] dvb-core: prevent some corruption the legacy ioctl

David Howells (6):
      [media] dvb: Document FE_SCALE_DECIBEL units consistently
      [media] ts2020: Add a comment about lifetime of on-stack pdata in ts2020_attach()
      [media] TS2020: Calculate tuner gain correctly
      [media] ts2020: Provide DVBv5 API signal strength
      [media] ts2020: Copy loop_through from the config to the internal data
      [media] ts2020: Allow stats polling to be suppressed

David Härdeman (1):
      [media] rc-core: fix dib0700 scancode generation for RC5

Dmitry Eremin-Solenikov (1):
      [media] saa7134: add AverMedia AverTV/505 card support

Fabian Frederick (3):
      [media] constify of_device_id array
      [media] siano: define SRVM_MAX_PID_FILTERS only once
      [media] omap_vout: use swap() in omapvid_init()

Fabien Dessenne (4):
      [media] bdisp: add DT bindings documentation
      [media] bdisp: 2D blitter driver using v4l2 mem2mem framework
      [media] bdisp: add debug file system
      [media] bdisp: remove needless check

Fabio Estevam (3):
      [media] ir-hix5hd2: Fix build warning
      [media] st_rc: fix build warning
      [media] radio-si470x-i2c: Pass the IRQF_ONESHOT flag

Florian Echtler (4):
      [media] reduce poll interval to allow full 60 FPS framerate
      [media] add frame size/frame rate query functions
      [media] add extra debug output, remove noisy warning
      [media] return BUF_STATE_ERROR if streaming stopped during acquisition

Geert Uytterhoeven (4):
      [media] v4l: xilinx: VIDEO_XILINX should depend on HAS_DMA
      [media] v4l: VIDEOBUF2_DMA_SG should depend on HAS_DMA
      [media] Input: TOUCHSCREEN_SUR40 should depend on HAS_DMA
      [media] wl128x: Allow compile test of GPIO consumers if !GPIOLIB

Hans Verkuil (124):
      [media] v4l2-of: fix compiler errors if CONFIG_OF is undefined
      [media] vivid-tpg: add tpg_log_status()
      [media] vivid-tpg: add full range SMPTE 240M support
      [media] vivid-tpg: add full range BT.2020 support
      [media] vivid-tpg: add full range BT.2020C support
      [media] vivid-tpg: fix XV601/709 Y'CbCr encoding
      [media] DocBook/media: attemps -> attempts
      [media] s5c73m3/s5k5baf/s5k6aa: fix compiler warnings
      [media] s3c-camif: fix compiler warnings
      [media] cx24123/mb86a20s/s921: fix compiler warnings
      [media] radio-bcm2048: fix compiler warning
      [media] v4l2-ioctl: fill in the description for VIDIOC_ENUM_FMT
      [media] v4l2-pci-skeleton: drop format description
      [media] vim2m: drop format description
      [media] vivid: drop format description
      [media] cx88: v4l2-compliance fixes
      [media] bttv: fix missing irq after reloading driver
      [media] DocBook/media: fix typo
      [media] DocBook/media: Improve G_EDID specification
      [media] saa7164: fix querycap warning
      [media] cx18: add missing caps for the PCM video device
      [media] usbtv: fix v4l2-compliance issues
      [media] marvell-ccic: fix vb2 warning
      [media] marvell-ccic: fill in bus_info
      [media] marvell-ccic: webcam drivers shouldn't support g/s_std
      [media] ov7670: check for valid width/height in ov7670_enum_frame_interval
      [media] marvell-ccic: fill in colorspace
      [media] marvell-ccic: control handler fixes
      [media] marvell-ccic: switch to struct v4l2_fh
      [media] marvell-ccic: implement control events
      [media] marvell-ccic: use vb2 helpers and core locking
      [media] marvell-ccic: add create_bufs support
      [media] marvell-ccic: add DMABUF support for all three DMA modes
      [media] marvell-ccic: fix streaming issues
      [media] marvell-ccic: correctly requeue buffers
      [media] marvell-ccic: add planar support to dma-vmalloc
      [media] marvell-ccic: drop V4L2_PIX_FMT_JPEG dead code
      [media] ov7670: use colorspace SRGB instead of JPEG
      [media] marvell-ccic: fix the bytesperline and sizeimage calculations
      [media] marvell-ccic: drop support for PIX_FMT_422P
      [media] marvell-ccic: fix V4L2_PIX_FMT_SBGGR8 support
      [media] dt3155v4l: code cleanup
      [media] dt3155v4l: remove unused statistics
      [media] dt3155v4l: add v4l2_device support
      [media] dt3155v4l: remove pointless dt3155_alloc/free_coherent
      [media] dt3155v4l: remove bogus single-frame capture in init_board
      [media] dt3155v4l: move vb2_queue to top-level
      [media] dt3155v4l: drop CONFIG_DT3155_STREAMING
      [media] dt3155v4l: correctly start and stop streaming
      [media] dt3155v4l: drop CONFIG_DT3155_CCIR, use s_std instead
      [media] dt3155v4l: fix format handling
      [media] dt3155v4l: support inputs VID0-3
      [media] dt3155: move out of staging into drivers/media/pci
      [media] dt3155: add GFP_DMA32 flag to vb2 queue
      [media] v4l2: replace enum_mbus_fmt by enum_mbus_code
      [media] v4l2: replace video op g_mbus_fmt by pad op get_fmt
      [media] v4l2: replace try_mbus_fmt by set_fmt
      [media] v4l2: replace s_mbus_fmt by set_fmt
      [media] v4l2: replace try_mbus_fmt by set_fmt in bridge drivers
      [media] v4l2: replace s_mbus_fmt by set_fmt in bridge drivers
      [media] saa7164: fix compiler warning
      [media] marvell-ccic: fix RGB444 format
      [media] sta2x11: use monotonic timestamp
      [media] rcar-vin: use monotonic timestamps
      [media] DocBook/media: remove spurious space
      [media] DocBook/media: improve timestamp documentation
      [media] DocBook/media: fix syntax error
      [media] adv7842: Make output format configurable through pad format operations
      [media] vb2: allow requeuing buffers while streaming
      [media] adv7604/adv7842: replace FMT_CHANGED by V4L2_DEVICE_NOTIFY_EVENT
      [media] cobalt: add new driver
      [media] cobalt: fix irqs used for the adv7511 transmitter
      [media] cobalt: fix 64-bit division link error
      [media] cobalt: fix compiler warnings on 32 bit OSes
      [media] e4000: fix compiler warning
      [media] cobalt: fix sparse warnings
      [media] cobalt: fix sparse warnings
      [media] cobalt: fix sparse warnings
      [media] cobalt: fix sparse warnings
      [media] cobalt: fix sparse warnings
      [media] cx24120: fix sparse warning
      [media] saa7164: fix sparse warning
      [media] adv7604/cobalt: missing GPIOLIB dependency
      [media] DocBook/media: add missing entry for V4L2_PIX_FMT_Y16_BE
      [media] ivtv: fix incorrect audio mode report in log_status
      [media] videodev2.h: add COLORSPACE_DEFAULT
      [media] DocBook/media: document COLORSPACE_DEFAULT
      [media] videodev2.h: add COLORSPACE_RAW
      [media] DocBook/media: document COLORSPACE_RAW
      [media] videodev2.h: add macros to map colorspace defaults
      [media] vivid: use new V4L2_MAP_*_DEFAULT defines
      [media] DocBook media: fix typos
      [media] DocBook media: xmllint fixes
      [media] DocBook media: rewrite frontend open/close
      [media] videodev2.h: add support for transfer functions
      [media] DocBook/media: document new xfer_func fields
      [media] adv7511: add xfer_func support
      [media] am437x-vpfe: add support for xfer_func
      [media] vivid: add xfer_func support
      [media] vivid-tpg: precalculate colorspace/xfer_func combinations
      [media] cobalt: support transfer function
      [media] cobalt: simplify colorspace code
      [media] vivid.txt: update the vivid documentation
      [media] vivid: move PRINTSTR to separate functions
      [media] vivid: move video loopback control to the capture device
      [media] stk1160: add DMABUF support
      [media] vivid-tpg: improve Y16 color setup
      [media] v4l2-ioctl: clear the reserved field of v4l2_create_buffers
      [media] DocBook media: correct description of reserved fields
      [media] v4l2-ioctl: log buffer type 0 correctly
      [media] v4l2-mem2mem: add support for prepare_buf
      [media] vim2m: add create_bufs and prepare_buf support
      [media] adv7511: replace uintX_t by uX for consistency
      [media] adv7842: replace uintX_t by uX for consistency
      [media] adv7511: log the currently set infoframes
      [media] adv7604: log infoframes
      [media] adv7604: fix broken saturator check
      [media] adv7604: log alt-gamma and HDMI colorspace
      [media] v4l2-dv-timings: support interlaced in v4l2_print_dv_timings
      [media] cx231xx: fix compiler warning
      [media] bdisp: update MAINTAINERS
      [media] cobalt: fix 64-bit division
      [media] Revert "[media] vb2: Push mmap_sem down to memops"
      [media] videodev2.h: fix copy-and-paste error in V4L2_MAP_XFER_FUNC_DEFAULT

Heiko Stübner (1):
      [media] rc: gpio-ir-recv: don't sleep in irq handler

James Hogan (4):
      [media] rc: rc-ir-raw: Add scancode encoder callback
      [media] rc: ir-rc5-decoder: Add encode capability
      [media] rc: rc-core: Add support for encode_wakeup drivers
      [media] rc: rc-loopback: Add loopback of filter scancodes

Jan Kara (1):
      [media] vb2: Push mmap_sem down to memops

Jan Klötzke (5):
      [media] rc/keymaps: add RC keytable for TechniSat TS35
      [media] rc/keymaps: add keytable for Terratec Cinergy C PCI
      [media] rc/keymaps: add keytable for Terratec Cinergy S2 HD
      [media] rc/keymaps: add keytable for Twinhan DTV CAB CI
      [media] mantis: add remote control support

Jemma Denson (28):
      [media] Add support for TechniSat Skystar S2
      [media] cx24120: Fix minor style typo in Kconfig
      [media] cx24120: Move clock set to read_status
      [media] cx24120: Add missing command to cx24120_check_cmd
      [media] cx24120: Fix hexdump length in writeregs
      [media] cx24120: Rework vco function to remove xxyyzz variable
      [media] cx24120: Add DVBv5 signal strength stats
      [media] cx24120: Enable DVBv5 signal strength stats
      [media] cx24120: Remove additional calls to read_status
      [media] cx24120: Return DVBv3 signal strength from cache
      [media] cx24120: Improve cooked signal strength value
      [media] cx24120: More coding style fixes
      [media] cx24120: Fix disecq_send_burst command
      [media] cx24120: Move CNR to DVBv5 stats
      [media] cx24120: Tidy up calls to dev_dbg
      [media] cx24120: Remove unneccesary assignments in cx24120_init
      [media] cx24120: Tidy cx24120_init
      [media] cx24120: More tidying in cx24120_init
      [media] b2c2: Reset no_base_addr on skystarS2 attach failure
      [media] cx24120: Complete modfec_table
      [media] cx24120: Add in dvbv5 stats for bit error rate
      [media] cx24120: Convert read_ber to retrieve from cache
      [media] cx24120: Convert ucblocks to dvbv5 stats
      [media] cx24120: Check for lock before updating BER & UCB
      [media] cx24120: Update comment & fix typo
      [media] cx24120: Assume ucb registers is a counter
      [media] b2c2: Mismatch in config ifdefs for SkystarS2
      [media] b2c2: Add option to skip the first 6 pid filters

Juergen Gier (1):
      [media] saa7134: switch tuner FMD1216ME_MK3 to analog

Julia Lawall (3):
      [media] si4713: fix error return code
      [media] as102: fix error return code
      [media] radio: fix error return code

Krzysztof Kozlowski (5):
      [media] media: platform: exynos-gsc: Constify platform_device_id
      [media] media: platform: exynos4-is: Constify platform_device_id
      [media] media: platform: s3c-camif: Constify platform_device_id
      [media] media: platform: s5p: Constify platform_device_id
      [media] staging: media: omap4iss: Constify platform_device_id

Ksenija Stanojevic (1):
      [media] Staging: media: lirc: Replace timeval with ktime_t

Lad, Prabhakar (5):
      [media] media: i2c: ov2659: Use v4l2_of_alloc_parse_endpoint()
      [media] media: davinci_vpfe: clear the output_specs
      [media] media: davinci_vpfe: set minimum required buffers to three
      [media] media: davinci_vpfe: use monotonic timestamp
      [media] media: davinci: vpbe: use v4l2_get_timestamp()

Laurent Navet (1):
      [media] fc0013: remove unneeded test

Laurent Pinchart (5):
      [media] uvcvideo: Implement DMABUF exporter role
      [media] uvcvideo: Fix incorrect bandwidth with Chicony device 04f2:b50b
      [media] uvcvideo: Remove unneeded device disconnected flag
      [media] MAINTAINERS: Add entry for the Renesas VSP1 driver
      [media] vb2: Don't WARN when v4l2_buffer.bytesused is 0 for multiplanar buffers

Malcolm Priestley (2):
      [media] lmedm04: Enable dont_poll for TS2020 tuner
      [media] lmedm04: implement dvb v5 statistics

Marek Szyprowski (1):
      [media] media: s5p-mfc: fix sparse warnings

Mauro Carvalho Chehab (205):
      Merge tag 'v4.1-rc1' into patchwork
      [media] dib8000: fix compiler warning
      [media] am437x-vpfe: really update the vpfe_ccdc_update_raw_params data
      [media] am437x: Fix a wrong identation
      [media] am437x: remove unused variable
      [media] rc: fix bad indenting
      [media] cx18: avoid going past input/audio array
      [media] saa7134: fix indent issues
      [media] ngene: preventing dereferencing a NULL pointer
      [media] saa7164: Check if dev is NULL before dereferencing it
      [media] saa717x: fix multi-byte read code
      [media] radio-si476x: Fix indent
      [media] ivtv: avoid going past input/audio array
      [media] zoran: fix indent
      [media] s3c-camif: Check if fmt is NULL before use
      [media] s5p_mfc: remove a dead code
      [media] ir-sony-decoder: shutup smatch warnings
      [media] wl128x: fix int type for streg_cbdata
      [media] qt1010: Reduce text size by using static const
      [media] go7007: don't use vb before test if it is not NULL
      [media] benq: fix indentation
      [media] bcm3510: fix indentation
      [media] dib3000mc: Fix indentation
      [media] lgdt3306a: fix indentation
      [media] stv0288: fix indentation
      [media] s5h1420: fix a buffer overflow when checking userspace params
      [media] cx24116: fix a buffer overflow when checking userspace params
      [media] af9013: Don't accept invalid bandwidth
      [media] cx24117: fix a buffer overflow when checking userspace params
      [media] zc3xx: don't go past quality array
      [media] zc3xx: remove dead code and uneeded gotos
      [media] vivid-radio-rx: Don't go past buffer
      [media] qt1010: avoid going past array
      [media] mantis: remove dead code
      [media] tda1004x: fix identation
      [media] r820t: fix identing
      [media] bttv: fix indenting
      [media] zl10353: fix indenting
      [media] stv0297: change typecast to u64 to avoid smatch warnings
      [media] ov7670: check read error also for REG_AECHH on ov7670_s_exp()
      [media] cx231xx: fix bad indenting
      [media] dib3000mc: fix bad indenting
      [media] dib0070: Fix indenting
      [media] go7007: Comment some dead code
      [media] vp702x: comment dead code
      [media] redrat3: change return argument on redrat3_send_cmd() to int
      [media] sonixj: fix bad indenting
      [media] stk014: fix bad indenting
      [media] pvrusb2: fix inconsistent indenting
      [media] cx25840: fix bad identing
      [media] stv0900: fix bad indenting
      [media] s5h1420: use only one statement per line
      [media] tda10086: change typecast to u64 to avoid smatch warnings
      [media] bttv: fix audio hooks
      [media] ttusb-dec: fix bad indentation
      [media] s5p-mfc: fix bad indentation
      [media] usbvision: fix bad indentation
      [media] saa7134: fix bad indenting
      [media] dib0700: fix bad indentation
      [media] af9005: fix bad indenting
      [media] dw2102: fix bad indenting
      [media] xirlink_cit: comment unreachable code
      [media] vivid: fix bad indenting
      [media] cx23885: fix bad indentation
      [media] m2m-deinterlace: remove dead code
      v4l2-ioctl: add a missing break at v4l_fill_fmtdesc()
      saa7164: Fix CodingStyle issues added on previous patches
      dt3155: fix CodingStyle issues
      media: replace bellow -> below
      media controller: add EXPERIMENTAL to Kconfig option for DVB support
      Merge tag 'v4.1-rc3' into patchwork
      [media] saa7134: prepare to use pr_foo macros
      [media] saa7134: instead of using printk KERN_foo, use pr_foo
      [media] saa7134: fix a few other occurrences of KERN_INFO/KERN_WARNING
      [media] saa7134-alsa: use pr_debug() instead of printk
      [media] saa7134-dvb: get rid of wprintk() macro
      [media] saa7134-dvb: use pr_debug() for the saa7134 dvb module
      [media] saa7134-empress: use pr_debug() for the saa7134 empress module
      [media] saa7134: use pr_warn() on some places where no KERN_foo were used
      [media] saa7134: better handle core debug messages
      [media] saa7134-i2c: make debug macros to use pr_fmt()
      [media] saa7134-ts: use pr_fmt() at the debug macro
      [media] saa7134: change the debug macros for saa7134-tvaudio
      [media] saa7134: change the debug macros for video and vbi
      [media] saa7134: change the debug macros for IR input
      [media] saa7134-i2c: simplify debug dump and use pr_info()
      [media] saa7134: replace remaining occurences or printk()
      [media] saa7134: avoid complex macro warnings
      [media] saa7134: fix CodingStyle issues on the lines touched by pr_foo refactor
      [media] dib0700: avoid the risk of forgetting to add the adapter's size
      [media] cx24120: don't initialize a var that won't be used
      [media] cx24120: declare cx24120_init() as static
      [media] cx24120: constify static data
      [media] e4000: Fix rangehigh value
      [media] DocBook: Update DVB supported standards at introduction
      [media] DocBook: add a note about the ALSA API
      [media] DocBook: add drawing with a typical media device
      [media] DocBook: fix emphasis at the DVB documentation
      [media] DocBook: Improve DVB frontend description
      [media] DocBook: move DVBv3 frontend bits to a separate section
      [media] dvb: split enum from typedefs at frontend.h
      [media] DocBook: reformat FE_GET_INFO ioctl documentation
      [media] DocBook: move FE_GET_INFO to a separate xml file
      [media] DocBook: improve documentation for FE_READ_STATUS
      [media] DocBook: move DVB properties to happen earlier at the document
      [media] DocBook: rewrite FE_GET_PROPERTY/FE_SET_PROPERTY to use the std way
      [media] DocBook: fix xref to the FE open() function
      [media] DocBook: Merge FE_SET_PROPERTY/FE_GET_PROPERTY ioctl description
      [media] DocBook: Improve the description of the properties API
      [media] DocBook: Add xref links for DTV propeties
      [media] DocBook: Improve xref check for undocumented ioctls
      [media] DocBook: remove duplicated ioctl from v4l2-subdev
      [media] DocBook: Fix false positive undefined ioctl references
      [media] DocBook: Rename ioctl xml files
      [media] DocBook: move FE_GET_PROPERTY to its own xml file
      [media] DocBook: reformat FE_SET_FRONTEND_TUNE_MODE ioctl
      [media] DocBook: reformat FE_ENABLE_HIGH_LNB_VOLTAGE ioctl
      [media] DocBook: better document FE_SET_VOLTAGE ioctl
      [media] DocBook: better document FE_SET_TONE ioctl
      [media] DocBook: better document FE_DISEQC_SEND_BURST ioctl
      [media] DocBook: better document FE_DISEQC_RECV_SLAVE_REPLY
      [media] DocBook: better document FE_DISEQC_SEND_MASTER_CMD
      [media] DocBook: better document FE_DISEQC_RESET_OVERLOAD
      [media] DocBook: better organize the function descriptions for frontend
      [media] DocBook: fix FE_READ_STATUS argument description
      [media] DocBook: Provide a high-level description for DVB frontend
      [media] DocBook: add a proper description for dvb_frontend_info.fe_type
      [media] DocBook: Better document enum fe_modulation
      [media] DocBook: some fixes at FE_GET_INFO
      [media] DocBook/Makefile: improve typedef parser
      [media] DocBook: cross-reference enum fe_modulation where needed
      [media] DocBook: improve documentation for DVB spectral inversion
      [media] DocBook: improve documentation for OFDM transmission mode
      [media] DocBook: move fe_bandwidth to the frontend legacy section
      [media] DocBook: improve documentation for FEC fields
      [media] DocBook: improve documentation for guard interval
      [media] DocBook: improve documentation for hierarchy
      [media] DocBook: improve documentation of the properties structs
      [media] DocBook: Add an example for using FE_SET_PROPERTY
      [media] DocBook: cleaup the notes about DTV properties
      [media] DocBook: Fix arguments on some ioctl documentation
      [media] DocBook: Update DocBook version and fix a few legacy things
      [media] DocBook: some fixes for DVB FE open()
      [media] DocBook: fix FE_SET_PROPERTY ioctl arguments
      [media] vivid: don't use more than 1024 bytes of stack
      [media] drxk: better handle errors
      [media] em28xx: remove dead code
      [media] sh_vou: avoid going past arrays
      [media] dib0090: Remove a dead code
      [media] bt8xx: remove needless check
      [media] ivtv: fix two smatch warnings
      [media] tm6000: remove needless check
      [media] ir: Fix IR_MAX_DURATION enforcement
      [media] rc: set IR_MAX_DURATION to 500 ms
      [media] usbvision: cleanup the code
      [media] lirc_imon: simplify error handling code
      [media] DocBook: document DVB net API
      [media] DocBook: specify language and encoding for the document
      [media] DocBook: Change DTD schema to version 4.5
      [media] Docbook: typo fix: use note(d) instead of notice(d)
      [media] DocBook: fix some syntax issues at dvbproperty.xml
      [media] DocBook: Use constant tag for monospaced fonts
      [media] DocBook: handle enums on frontend.h
      [media] DocBook: Add entry IDs for enum fe_caps
      [media] DocBook: add entry IDs for enum fe_sec_mini_cmd
      [media] DocBook: add entry IDs for enum fe_status
      [media] DocBook: add entry IDs for enum fe_sec_tone_mode
      [media] Docbook: add entry IDs for enum fe_sec_voltage
      [media] DocBook: Add entry IDs for the enums defined at dvbproperty.xml
      [media] DocBook: Better document DTMB time interleaving
      [media] DocBook: add IDs for enum fe_bandwidth
      [media] DocBook: remove a wrong cut-and-paste data
      [media] DocBook: add placeholders for ATSC M/H properties
      [media] DocBook: Add documentation for ATSC M/H properties
      [media] DocBook: document DVB-S2 pilot in a table
      [media] DocBook: Remove duplicated documentation for SEC_VOLTAGE_*
      [media] DocBook: better document the DVB-S2 rolloff factor
      [media] DocBook: properly document the delivery systems
      [media] DocBook: add xrefs for enum fe_type
      [media] dvb: Get rid of typedev usage for enums
      [media] frontend: Move legacy API enums/structs to the end
      [media] frontend: move legacy typedefs to the end
      [media] DocBook: Remove comments before parsing enum values
      [media] frontend: Fix a typo at the comments
      [media] dvb: frontend.h: improve dvb_frontent_parameters comment
      [media] dvb: frontend.h: add a note for the deprecated enums/structs
      [media] dvb: dmx.h: don't use anonymous enums
      [media] DocBook: Change format for enum dmx_output documentation
      [media] ov2659: Don't depend on subdev API
      [media] usb drivers: use BUG_ON() instead of if () BUG
      [media] Documentation: update cardlists
      [media] mantis: cleanup CodingStyle issues due to last commit
      ts2020: fix compilation on i386
      [media] bdisp: remove unused var
      [media] cx88: don't declare restart_video_queue if not used
      [media] bdisp-debug: don't try to divide by s64
      [media] mantis: cleanup a warning
      [media] bdisp: prevent compiling on random arch
      [media] si470x: cleanup define namespace
      [media] tuner-i2c: be consistent with I2C declaration
      [media] use CONFIG_PM_SLEEP for suspend/resume
      [media] saa7134: fix page size on some archs
      [media] omap3isp: remove unused var
      [media] lmedm04: use u32 instead of u64 for relative stats
      [media] lmedm04: fix the range for relative measurements

Michael S. Tsirkin (1):
      [media] media/fintek: drop pci_ids dependency

Nikhil Devshatwar (1):
      [media] v4l: of: Correct pclk-sample for BT656 bus

Olli Salonen (11):
      [media] dw2102: TeVii S482 support
      [media] si2168: add support for gapped clock
      [media] dvbsky: use si2168 config option ts_clock_gapped
      [media] si2168: add I2C error handling
      [media] si2157: support selection of IF interface
      [media] rtl28xxu: add I2C read without write
      [media] rtl2832: add support for GoTView MasterHD 3 USB tuner
      [media] dw2102: remove unnecessary printing of MAC address
      [media] dw2102: resync fifo when demod locks
      [media] saa7164: change Si2168 reglen to 0 bit
      [media] saa7164: Improvements for I2C handling"

Patrick Boettcher (6):
      [media] cx24120: minor checkpatch fixes
      [media] cx24120: i2c-max-write-size is now configurable
      [media] MAINTAINERS: add cx24120-maintainer
      [media] cx24120: fix codingstyle issue first round
      [media] cx24120: fix strict checkpatch-errors
      [media] cx24120: fix minor checkpatch-error

Pavel Machek (2):
      [media] media: i2c/adp1653: Documentation for devicetree support for adp1653
      [media] media: i2c/adp1653: Devicetree support for adp1653

Peter Seiderer (1):
      [media] videodev2: Add V4L2_BUF_FLAG_LAST

Philipp Zabel (5):
      [media] vivid: add 1080p capture at 2 fps and 5 fps to webcam emulation
      [media] DocBook media: document codec draining flow
      [media] videobuf2: return -EPIPE from DQBUF after the last buffer
      [media] coda: Set last buffer flag and fix EOS event
      [media] s5p-mfc: Set last buffer flag

Piotr S. Staszewski (1):
      [media] staging: media: omap4iss: Reformat overly long lines

Prashant Laddha (8):
      [media] v4l2-dv-timings: fix rounding error in vsync_bp calculation
      [media] v4l2-dv-timings: fix rounding in hblank and hsync calculation
      [media] v4l2-dv-timings: add sanity checks in cvt,gtf calculations
      [media] v4l2-dv-timings: replace hsync magic number with a macro
      [media] v4l2-dv-timings: fix overflow in gtf timings calculation
      [media] v4l2-dv-timing: avoid rounding twice in gtf hblank calc
      [media] v4l2-dv-timings: add interlace support in detect cvt/gtf
      [media] vivid: Use interlaced info for cvt/gtf timing detection

Rafael Lourenço de Lima Chehab (1):
      [media] au0828: move dev->boards atribuition to happen earlier

Ricardo Ribalda Delgado (7):
      [media] media/vivid: Add support for Y16 format
      [media] media/vivid: Code cleanout
      [media] media/videobuf2-dma-sg: Fix handling of sg_table structure
      [media] media/videobuf2-dma-contig: Save output from dma_map_sg
      [media] media/videobuf2-dma-vmalloc: Save output from dma_map_sg
      [media] media/v4l2-core: Add support for V4L2_PIX_FMT_Y16_BE
      [media] media/vivid: Add support for Y16_BE format

Sakari Ailus (4):
      [media] v4l: of: Remove the head field in struct v4l2_of_endpoint
      [media] v4l: of: Instead of zeroing bus_type and bus field separately, unify this
      [media] v4l: of: Parse variable length properties --- link-frequencies
      [media] smiapp: Use v4l2_of_alloc_parse_endpoint()

Silvan Jegen (1):
      [media] mantis: fix error handling

Steven Toth (6):
      [media] saa7164: I2C improvements for upcoming HVR2255/2205 boards
      [media] saa7164: Adding additional I2C debug
      [media] saa7164: Improvements for I2C handling
      [media] saa7164: Add Digital TV support for the HVR2255 and HVR2205
      [media] saa7164: Copyright update
      [media] saa7164: fix HVR2255 ATSC inversion issue

Takeshi Yoshimura (1):
      [media] ddbridge: Do not free_irq() if request_irq() failed

Thomas Reitmayr (1):
      [media] media: Fix regression in some more dib0700 based devices

Tina Ruchandani (1):
      [media] dvb-frontend: Replace timeval with ktime_t

Tommi Rantala (1):
      [media] cx231xx: Add support for Terratec Grabby

Vaishali Thakkar (1):
      [media] s5k5baf: Convert use of __constant_cpu_to_be16 to cpu_to_be16

Vasily Khoruzhick (2):
      [media] gspca: sn9c2028: Add support for Genius Videocam Live v2
      [media] gspca: sn9c2028: Add gain and autogain controls Genius Videocam Live v2

Wei Yongjun (1):
      [media] rtl28xxu: fix return value check in rtl2832u_tuner_attach()

jean-michel.hautbois@vodalys.com (2):
      [media] media: adv7604: Fix masks used for querying timings in ADV7611
      [media] v4l2-subdev: allow subdev to send an event to the v4l2_device notify function

 Documentation/DocBook/media/.gitignore                               |    1 +
 Documentation/DocBook/media/Makefile                                 |   88 +-
 Documentation/DocBook/media/dvb/audio.xml                            |    6 +-
 Documentation/DocBook/media/dvb/ca.xml                               |    4 +-
 Documentation/DocBook/media/dvb/demux.xml                            |   61 +-
 Documentation/DocBook/media/dvb/dvbapi.xml                           |   34 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml                      | 1117 +-
 Documentation/DocBook/media/dvb/examples.xml                         |    6 +-
 Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml       |   78 +
 Documentation/DocBook/media/dvb/fe-diseqc-reset-overload.xml         |   51 +
 Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml             |   89 +
 Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml        |   72 +
 Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml       |   61 +
 Documentation/DocBook/media/dvb/fe-get-info.xml                      |  266 +
 Documentation/DocBook/media/dvb/fe-get-property.xml                  |   81 +
 Documentation/DocBook/media/dvb/fe-read-status.xml                   |  107 +
 Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml        |   64 +
 Documentation/DocBook/media/dvb/fe-set-tone.xml                      |   91 +
 Documentation/DocBook/media/dvb/fe-set-voltage.xml                   |   69 +
 Documentation/DocBook/media/dvb/frontend.xml                         | 1747 +-
 Documentation/DocBook/media/dvb/frontend_legacy_api.xml              |  654 +
 Documentation/DocBook/media/dvb/intro.xml                            |   30 +-
 Documentation/DocBook/media/dvb/kdapi.xml                            |    4 +-
 Documentation/DocBook/media/dvb/net.xml                              |  374 +-
 Documentation/DocBook/media/dvb/video.xml                            |   10 +-
 Documentation/DocBook/media/typical_media_device.svg                 |   28 +
 Documentation/DocBook/media/v4l/controls.xml                         |    4 +-
 Documentation/DocBook/media/v4l/io.xml                               |   26 +-
 Documentation/DocBook/media/v4l/media-func-open.xml                  |    2 +-
 Documentation/DocBook/media/v4l/pixfmt-y16-be.xml                    |   81 +
 Documentation/DocBook/media/v4l/pixfmt.xml                           |  134 +-
 Documentation/DocBook/media/v4l/remote_controllers.xml               |    2 +-
 Documentation/DocBook/media/v4l/subdev-formats.xml                   |   12 +-
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml               |    3 +-
 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml               |   12 +-
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml                   |    5 +-
 Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml               |   10 +-
 Documentation/DocBook/media/v4l/vidioc-enum-frameintervals.xml       |    3 +-
 Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml           |    3 +-
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml                    |    3 +-
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml              |    4 +-
 Documentation/DocBook/media/v4l/vidioc-g-edid.xml                    |   11 +-
 Documentation/DocBook/media/v4l/vidioc-g-selection.xml               |    2 +-
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml                      |   10 +
 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml          |    3 +-
 Documentation/DocBook/media/v4l/vidioc-querybuf.xml                  |    3 +-
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml                   |    4 +-
 Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml           |    3 +-
 Documentation/DocBook/media_api.tmpl                                 |   53 +-
 Documentation/devicetree/bindings/media/i2c/adp1653.txt              |   37 +
 Documentation/devicetree/bindings/media/st,stih4xx.txt               |   32 +
 Documentation/video4linux/CARDLIST.cx23885                           |    9 +-
 Documentation/video4linux/CARDLIST.em28xx                            |    2 +
 Documentation/video4linux/CARDLIST.saa7134                           |    1 +
 Documentation/video4linux/CARDLIST.saa7164                           |    3 +
 Documentation/video4linux/v4l2-framework.txt                         |    4 +
 Documentation/video4linux/v4l2-pci-skeleton.c                        |    2 -
 Documentation/video4linux/vivid.txt                                  |   32 +-
 MAINTAINERS                                                          |   42 +
 drivers/input/touchscreen/Kconfig                                    |    3 +-
 drivers/input/touchscreen/sur40.c                                    |   46 +-
 drivers/media/Kconfig                                                |    2 +-
 drivers/media/common/b2c2/Kconfig                                    |    1 +
 drivers/media/common/b2c2/flexcop-common.h                           |    1 +
 drivers/media/common/b2c2/flexcop-fe-tuner.c                         |   63 +-
 drivers/media/common/b2c2/flexcop-hw-filter.c                        |   16 +-
 drivers/media/common/b2c2/flexcop-misc.c                             |    1 +
 drivers/media/common/b2c2/flexcop-reg.h                              |    1 +
 drivers/media/common/siano/smscoreapi.h                              |    3 +-
 drivers/media/common/siano/smsdvb-main.c                             |    6 +-
 drivers/media/common/siano/smsdvb.h                                  |    2 +-
 drivers/media/common/siano/smsir.c                                   |    2 +-
 drivers/media/dvb-core/dvb_frontend.c                                |   78 +-
 drivers/media/dvb-core/dvb_frontend.h                                |   45 +-
 drivers/media/dvb-frontends/Kconfig                                  |   13 +-
 drivers/media/dvb-frontends/Makefile                                 |    1 +
 drivers/media/dvb-frontends/a8293.c                                  |   89 +-
 drivers/media/dvb-frontends/a8293.h                                  |   15 +
 drivers/media/dvb-frontends/af9013.c                                 |    8 +-
 drivers/media/dvb-frontends/af9033.c                                 |    4 +-
 drivers/media/dvb-frontends/as102_fe.c                               |    4 +-
 drivers/media/dvb-frontends/atbm8830.c                               |    3 +-
 drivers/media/dvb-frontends/au8522_dig.c                             |    4 +-
 drivers/media/dvb-frontends/au8522_priv.h                            |    2 +-
 drivers/media/dvb-frontends/bcm3510.c                                |    6 +-
 drivers/media/dvb-frontends/cx22700.c                                |    9 +-
 drivers/media/dvb-frontends/cx22702.c                                |    2 +-
 drivers/media/dvb-frontends/cx24110.c                                |   19 +-
 drivers/media/dvb-frontends/cx24116.c                                |   46 +-
 drivers/media/dvb-frontends/cx24117.c                                |   42 +-
 drivers/media/dvb-frontends/cx24120.c                                | 1595 +
 drivers/media/dvb-frontends/cx24120.h                                |   58 +
 drivers/media/dvb-frontends/cx24123.c                                |   18 +-
 drivers/media/dvb-frontends/cx24123.h                                |    2 +-
 drivers/media/dvb-frontends/cxd2820r_c.c                             |    2 +-
 drivers/media/dvb-frontends/cxd2820r_core.c                          |    5 +-
 drivers/media/dvb-frontends/cxd2820r_priv.h                          |    8 +-
 drivers/media/dvb-frontends/cxd2820r_t.c                             |    2 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c                            |    2 +-
 drivers/media/dvb-frontends/dib0070.c                                |  575 +-
 drivers/media/dvb-frontends/dib0090.c                                |    4 +-
 drivers/media/dvb-frontends/dib3000mb.c                              |    7 +-
 drivers/media/dvb-frontends/dib3000mc.c                              |   20 +-
 drivers/media/dvb-frontends/dib7000m.c                               |    2 +-
 drivers/media/dvb-frontends/dib7000p.c                               |    6 +-
 drivers/media/dvb-frontends/dib8000.c                                |   10 +-
 drivers/media/dvb-frontends/dib8000.h                                |    2 +-
 drivers/media/dvb-frontends/dib9000.c                                |    4 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c                          |   42 +-
 drivers/media/dvb-frontends/drxd_hard.c                              |    2 +-
 drivers/media/dvb-frontends/drxk_hard.c                              |   11 +-
 drivers/media/dvb-frontends/drxk_hard.h                              |    2 +-
 drivers/media/dvb-frontends/ds3000.c                                 |   13 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.c                           |    9 +-
 drivers/media/dvb-frontends/ec100.c                                  |    2 +-
 drivers/media/dvb-frontends/hd29l2.c                                 |    2 +-
 drivers/media/dvb-frontends/hd29l2_priv.h                            |    2 +-
 drivers/media/dvb-frontends/isl6405.c                                |    3 +-
 drivers/media/dvb-frontends/isl6421.c                                |    6 +-
 drivers/media/dvb-frontends/l64781.c                                 |    2 +-
 drivers/media/dvb-frontends/lg2160.c                                 |    2 +-
 drivers/media/dvb-frontends/lgdt3305.c                               |    4 +-
 drivers/media/dvb-frontends/lgdt3306a.c                              |   11 +-
 drivers/media/dvb-frontends/lgdt330x.c                               |    8 +-
 drivers/media/dvb-frontends/lgs8gl5.c                                |    2 +-
 drivers/media/dvb-frontends/lgs8gxx.c                                |    3 +-
 drivers/media/dvb-frontends/lnbp21.c                                 |    4 +-
 drivers/media/dvb-frontends/lnbp22.c                                 |    3 +-
 drivers/media/dvb-frontends/m88ds3103.c                              | 1275 +-
 drivers/media/dvb-frontends/m88ds3103.h                              |   67 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h                         |   20 +-
 drivers/media/dvb-frontends/m88rs2000.c                              |   19 +-
 drivers/media/dvb-frontends/mb86a16.c                                |    7 +-
 drivers/media/dvb-frontends/mb86a16.h                                |    3 +-
 drivers/media/dvb-frontends/mb86a20s.c                               |    6 +-
 drivers/media/dvb-frontends/mb86a20s.h                               |    2 +-
 drivers/media/dvb-frontends/mt312.c                                  |   17 +-
 drivers/media/dvb-frontends/mt352.c                                  |    2 +-
 drivers/media/dvb-frontends/nxt200x.c                                |    2 +-
 drivers/media/dvb-frontends/nxt6000.c                                |   12 +-
 drivers/media/dvb-frontends/or51132.c                                |    6 +-
 drivers/media/dvb-frontends/or51211.c                                |    2 +-
 drivers/media/dvb-frontends/rtl2830.c                                |    2 +-
 drivers/media/dvb-frontends/rtl2830_priv.h                           |    2 +-
 drivers/media/dvb-frontends/rtl2832.c                                |   10 +-
 drivers/media/dvb-frontends/rtl2832.h                                |    2 +
 drivers/media/dvb-frontends/rtl2832_priv.h                           |   51 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c                            |  120 +-
 drivers/media/dvb-frontends/rtl2832_sdr.h                            |    1 +
 drivers/media/dvb-frontends/s5h1409.c                                |    6 +-
 drivers/media/dvb-frontends/s5h1411.c                                |    6 +-
 drivers/media/dvb-frontends/s5h1420.c                                |   43 +-
 drivers/media/dvb-frontends/s5h1432.c                                |    4 +-
 drivers/media/dvb-frontends/s921.c                                   |    6 +-
 drivers/media/dvb-frontends/s921.h                                   |    2 +-
 drivers/media/dvb-frontends/si2165.c                                 |    2 +-
 drivers/media/dvb-frontends/si2168.c                                 |  144 +-
 drivers/media/dvb-frontends/si2168.h                                 |    3 +
 drivers/media/dvb-frontends/si2168_priv.h                            |    6 +-
 drivers/media/dvb-frontends/si21xx.c                                 |   10 +-
 drivers/media/dvb-frontends/sp8870.c                                 |    3 +-
 drivers/media/dvb-frontends/sp887x.c                                 |    2 +-
 drivers/media/dvb-frontends/stb0899_drv.c                            |    8 +-
 drivers/media/dvb-frontends/stv0288.c                                |   39 +-
 drivers/media/dvb-frontends/stv0297.c                                |   19 +-
 drivers/media/dvb-frontends/stv0299.c                                |   34 +-
 drivers/media/dvb-frontends/stv0367.c                                |   12 +-
 drivers/media/dvb-frontends/stv0367_priv.h                           |    2 +-
 drivers/media/dvb-frontends/stv0900_core.c                           |    6 +-
 drivers/media/dvb-frontends/stv0900_sw.c                             |    6 +-
 drivers/media/dvb-frontends/stv090x.c                                |    5 +-
 drivers/media/dvb-frontends/stv6110.c                                |    2 +-
 drivers/media/dvb-frontends/tc90522.c                                |   17 +-
 drivers/media/dvb-frontends/tda10021.c                               |    9 +-
 drivers/media/dvb-frontends/tda10023.c                               |    5 +-
 drivers/media/dvb-frontends/tda10048.c                               |    2 +-
 drivers/media/dvb-frontends/tda1004x.c                               |    5 +-
 drivers/media/dvb-frontends/tda10071.c                               |  117 +-
 drivers/media/dvb-frontends/tda10071.h                               |   29 +
 drivers/media/dvb-frontends/tda10071_priv.h                          |   11 +-
 drivers/media/dvb-frontends/tda10086.c                               |   13 +-
 drivers/media/dvb-frontends/tda8083.c                                |   38 +-
 drivers/media/dvb-frontends/ts2020.c                                 |  591 +-
 drivers/media/dvb-frontends/ts2020.h                                 |   17 +-
 drivers/media/dvb-frontends/ves1820.c                                |    6 +-
 drivers/media/dvb-frontends/ves1x93.c                                |   15 +-
 drivers/media/dvb-frontends/zl10353.c                                |   12 +-
 drivers/media/firewire/firedtv-fe.c                                  |    8 +-
 drivers/media/firewire/firedtv.h                                     |    4 +-
 drivers/media/i2c/Kconfig                                            |    4 +-
 drivers/media/i2c/adp1653.c                                          |  100 +-
 drivers/media/i2c/adv7170.c                                          |   42 +-
 drivers/media/i2c/adv7175.c                                          |   42 +-
 drivers/media/i2c/adv7183.c                                          |   61 +-
 drivers/media/i2c/adv7511.c                                          |  160 +-
 drivers/media/i2c/adv7604.c                                          |  192 +-
 drivers/media/i2c/adv7842.c                                          |  309 +-
 drivers/media/i2c/ak881x.c                                           |   39 +-
 drivers/media/i2c/cx25840/cx25840-core.c                             |   17 +-
 drivers/media/i2c/ml86v7667.c                                        |   29 +-
 drivers/media/i2c/mt9v011.c                                          |   53 +-
 drivers/media/i2c/ov2659.c                                           |   38 +-
 drivers/media/i2c/ov7670.c                                           |   65 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c                             |    2 +-
 drivers/media/i2c/s5k5baf.c                                          |    4 +-
 drivers/media/i2c/s5k6aa.c                                           |    2 +-
 drivers/media/i2c/saa6752hs.c                                        |   42 +-
 drivers/media/i2c/saa7115.c                                          |   16 +-
 drivers/media/i2c/saa717x.c                                          |   20 +-
 drivers/media/i2c/smiapp/smiapp-core.c                               |   38 +-
 drivers/media/i2c/soc_camera/imx074.c                                |   66 +-
 drivers/media/i2c/soc_camera/mt9m001.c                               |   43 +-
 drivers/media/i2c/soc_camera/mt9m111.c                               |   57 +-
 drivers/media/i2c/soc_camera/mt9t031.c                               |   74 +-
 drivers/media/i2c/soc_camera/mt9t112.c                               |   41 +-
 drivers/media/i2c/soc_camera/mt9v022.c                               |   43 +-
 drivers/media/i2c/soc_camera/ov2640.c                                |   62 +-
 drivers/media/i2c/soc_camera/ov5642.c                                |   60 +-
 drivers/media/i2c/soc_camera/ov6650.c                                |   43 +-
 drivers/media/i2c/soc_camera/ov772x.c                                |   41 +-
 drivers/media/i2c/soc_camera/ov9640.c                                |   32 +-
 drivers/media/i2c/soc_camera/ov9740.c                                |   35 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c                            |   66 +-
 drivers/media/i2c/soc_camera/tw9910.c                                |   41 +-
 drivers/media/i2c/sr030pc30.c                                        |   62 +-
 drivers/media/i2c/tvaudio.c                                          |    2 +-
 drivers/media/i2c/tvp514x.c                                          |   55 +-
 drivers/media/i2c/tvp5150.c                                          |   30 +-
 drivers/media/i2c/tvp7002.c                                          |   48 -
 drivers/media/i2c/vs6624.c                                           |   55 +-
 drivers/media/pci/Kconfig                                            |    2 +
 drivers/media/pci/Makefile                                           |    2 +
 drivers/media/pci/bt8xx/bttv-audio-hook.c                            |  443 +-
 drivers/media/pci/bt8xx/bttv-driver.c                                |    5 +-
 drivers/media/pci/bt8xx/dst.c                                        |   25 +-
 drivers/media/pci/bt8xx/dst_ca.c                                     |  138 +-
 drivers/media/pci/bt8xx/dst_common.h                                 |   12 +-
 drivers/media/pci/cobalt/Kconfig                                     |   18 +
 drivers/media/pci/cobalt/Makefile                                    |    5 +
 drivers/media/pci/cobalt/cobalt-alsa-main.c                          |  162 +
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c                           |  603 +
 drivers/media/pci/cobalt/cobalt-alsa-pcm.h                           |   22 +
 drivers/media/pci/cobalt/cobalt-alsa.h                               |   41 +
 drivers/media/pci/cobalt/cobalt-cpld.c                               |  341 +
 drivers/media/pci/cobalt/cobalt-cpld.h                               |   29 +
 drivers/media/pci/cobalt/cobalt-driver.c                             |  832 +
 drivers/media/pci/cobalt/cobalt-driver.h                             |  380 +
 drivers/media/pci/cobalt/cobalt-flash.c                              |  128 +
 drivers/media/pci/cobalt/cobalt-flash.h                              |   29 +
 drivers/media/pci/cobalt/cobalt-i2c.c                                |  396 +
 drivers/media/pci/cobalt/cobalt-i2c.h                                |   25 +
 drivers/media/pci/cobalt/cobalt-irq.c                                |  258 +
 drivers/media/pci/cobalt/cobalt-irq.h                                |   25 +
 drivers/media/pci/cobalt/cobalt-omnitek.c                            |  341 +
 drivers/media/pci/cobalt/cobalt-omnitek.h                            |   62 +
 drivers/media/pci/cobalt/cobalt-v4l2.c                               | 1272 +
 drivers/media/pci/cobalt/cobalt-v4l2.h                               |   22 +
 drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h       |  115 +
 drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h         |   44 +
 drivers/media/pci/cobalt/m00389_cvi_memmap_package.h                 |   59 +
 drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h               |   44 +
 drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h           |   57 +
 drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h   |   53 +
 drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h  |   88 +
 drivers/media/pci/cx18/cx18-av-core.c                                |   16 +-
 drivers/media/pci/cx18/cx18-controls.c                               |   13 +-
 drivers/media/pci/cx18/cx18-driver.c                                 |    4 +-
 drivers/media/pci/cx18/cx18-ioctl.c                                  |   12 +-
 drivers/media/pci/cx18/cx18-streams.c                                |    1 +
 drivers/media/pci/cx23885/altera-ci.c                                |    2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c                              |  150 +-
 drivers/media/pci/cx23885/cx23885-f300.c                             |    2 +-
 drivers/media/pci/cx23885/cx23885-f300.h                             |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c                            |   12 +-
 drivers/media/pci/cx23885/cx23885.h                                  |    3 +-
 drivers/media/pci/cx25821/cx25821-medusa-reg.h                       |    6 +-
 drivers/media/pci/cx88/cx88-core.c                                   |    2 +
 drivers/media/pci/cx88/cx88-dvb.c                                    |   12 +-
 drivers/media/pci/cx88/cx88-mpeg.c                                   |    6 +-
 drivers/media/pci/cx88/cx88-vbi.c                                    |    6 +-
 drivers/media/pci/cx88/cx88-video.c                                  |    9 +-
 drivers/media/pci/cx88/cx88.h                                        |    6 +-
 drivers/media/pci/ddbridge/ddbridge-core.c                           |    3 +-
 drivers/media/pci/dm1105/dm1105.c                                    |    3 +-
 drivers/media/pci/dt3155/Kconfig                                     |   13 +
 drivers/media/pci/dt3155/Makefile                                    |    1 +
 drivers/media/pci/dt3155/dt3155.c                                    |  632 +
 .../media/dt3155v4l/dt3155v4l.h => media/pci/dt3155/dt3155.h}        |   64 +-
 drivers/media/pci/ivtv/ivtv-controls.c                               |   12 +-
 drivers/media/pci/ivtv/ivtv-driver.c                                 |    4 +-
 drivers/media/pci/ivtv/ivtv-driver.h                                 |    3 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                                  |   15 +-
 drivers/media/pci/mantis/hopper_cards.c                              |   14 +-
 drivers/media/pci/mantis/mantis_cards.c                              |   94 +-
 drivers/media/pci/mantis/mantis_common.h                             |   33 +-
 drivers/media/pci/mantis/mantis_dma.c                                |    5 +-
 drivers/media/pci/mantis/mantis_i2c.c                                |   12 +-
 drivers/media/pci/mantis/mantis_input.c                              |  110 +-
 drivers/media/pci/mantis/mantis_input.h                              |   24 +
 drivers/media/pci/mantis/mantis_pcmcia.c                             |    4 +-
 drivers/media/pci/mantis/mantis_uart.c                               |   61 +-
 drivers/media/pci/mantis/mantis_vp1034.c                             |    2 +-
 drivers/media/pci/mantis/mantis_vp1034.h                             |    3 +-
 drivers/media/pci/ngene/ngene-core.c                                 |   10 +-
 drivers/media/pci/ngene/ngene.h                                      |    2 +-
 drivers/media/pci/pt1/pt1.c                                          |    6 +-
 drivers/media/pci/pt1/va1j5jf8007s.c                                 |    4 +-
 drivers/media/pci/pt1/va1j5jf8007t.c                                 |    4 +-
 drivers/media/pci/pt3/pt3.c                                          |    2 +-
 drivers/media/pci/saa7134/saa7134-alsa.c                             |   55 +-
 drivers/media/pci/saa7134/saa7134-cards.c                            |  150 +-
 drivers/media/pci/saa7134/saa7134-core.c                             |  161 +-
 drivers/media/pci/saa7134/saa7134-dvb.c                              |  122 +-
 drivers/media/pci/saa7134/saa7134-empress.c                          |   55 +-
 drivers/media/pci/saa7134/saa7134-go7007.c                           |   11 +-
 drivers/media/pci/saa7134/saa7134-i2c.c                              |   87 +-
 drivers/media/pci/saa7134/saa7134-input.c                            |   59 +-
 drivers/media/pci/saa7134/saa7134-ts.c                               |   24 +-
 drivers/media/pci/saa7134/saa7134-tvaudio.c                          |  168 +-
 drivers/media/pci/saa7134/saa7134-vbi.c                              |   14 +-
 drivers/media/pci/saa7134/saa7134-video.c                            |   43 +-
 drivers/media/pci/saa7134/saa7134.h                                  |    6 +-
 drivers/media/pci/saa7164/saa7164-api.c                              |   11 +-
 drivers/media/pci/saa7164/saa7164-buffer.c                           |    2 +-
 drivers/media/pci/saa7164/saa7164-bus.c                              |    2 +-
 drivers/media/pci/saa7164/saa7164-cards.c                            |  188 +-
 drivers/media/pci/saa7164/saa7164-cmd.c                              |    2 +-
 drivers/media/pci/saa7164/saa7164-core.c                             |   82 +-
 drivers/media/pci/saa7164/saa7164-dvb.c                              |  241 +-
 drivers/media/pci/saa7164/saa7164-encoder.c                          |   13 +-
 drivers/media/pci/saa7164/saa7164-fw.c                               |    2 +-
 drivers/media/pci/saa7164/saa7164-i2c.c                              |    9 +-
 drivers/media/pci/saa7164/saa7164-reg.h                              |    2 +-
 drivers/media/pci/saa7164/saa7164-types.h                            |    2 +-
 drivers/media/pci/saa7164/saa7164-vbi.c                              |   13 +-
 drivers/media/pci/saa7164/saa7164.h                                  |    8 +-
 drivers/media/pci/smipcie/smipcie.c                                  |    1 +
 drivers/media/pci/sta2x11/sta2x11_vip.c                              |    3 +-
 drivers/media/pci/ttpci/av7110.c                                     |   18 +-
 drivers/media/pci/ttpci/av7110.h                                     |   27 +-
 drivers/media/pci/ttpci/budget-core.c                                |    3 +-
 drivers/media/pci/ttpci/budget-patch.c                               |   15 +-
 drivers/media/pci/ttpci/budget.c                                     |   12 +-
 drivers/media/pci/ttpci/budget.h                                     |    2 +-
 drivers/media/pci/zoran/zoran_device.c                               |   13 +-
 drivers/media/platform/Kconfig                                       |   10 +
 drivers/media/platform/Makefile                                      |    2 +
 drivers/media/platform/am437x/am437x-vpfe.c                          |   35 +-
 drivers/media/platform/blackfin/bfin_capture.c                       |   40 +-
 drivers/media/platform/coda/coda-bit.c                               |    4 +-
 drivers/media/platform/coda/coda-common.c                            |   27 +-
 drivers/media/platform/coda/coda.h                                   |    3 +
 drivers/media/platform/coda/trace.h                                  |    2 -
 drivers/media/platform/davinci/vpbe_display.c                        |    9 +-
 drivers/media/platform/davinci/vpfe_capture.c                        |   19 +-
 drivers/media/platform/exynos-gsc/gsc-core.c                         |    2 +-
 drivers/media/platform/exynos4-is/Kconfig                            |    1 +
 drivers/media/platform/exynos4-is/media-dev.c                        |    2 +-
 drivers/media/platform/fsl-viu.c                                     |    2 +-
 drivers/media/platform/m2m-deinterlace.c                             |    1 -
 drivers/media/platform/marvell-ccic/cafe-driver.c                    |   13 +-
 drivers/media/platform/marvell-ccic/mcam-core.c                      |  480 +-
 drivers/media/platform/marvell-ccic/mcam-core.h                      |    3 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c                     |    1 +
 drivers/media/platform/omap/omap_vout.c                              |   10 +-
 drivers/media/platform/omap3isp/isppreview.c                         |    4 -
 drivers/media/platform/s3c-camif/camif-capture.c                     |   13 +-
 drivers/media/platform/s3c-camif/camif-core.c                        |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c                                 |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c                             |    5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c                      |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c                      |    4 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c                             |   14 +-
 drivers/media/platform/s5p-tv/mixer_drv.c                            |   15 +-
 drivers/media/platform/s5p-tv/sdo_drv.c                              |   14 +-
 drivers/media/platform/sh_vou.c                                      |   75 +-
 drivers/media/platform/soc_camera/atmel-isi.c                        |   74 +-
 drivers/media/platform/soc_camera/mx2_camera.c                       |  113 +-
 drivers/media/platform/soc_camera/mx3_camera.c                       |  105 +-
 drivers/media/platform/soc_camera/omap1_camera.c                     |  106 +-
 drivers/media/platform/soc_camera/pxa_camera.c                       |   99 +-
 drivers/media/platform/soc_camera/rcar_vin.c                         |  113 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c             |  115 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c                   |   35 +-
 drivers/media/platform/soc_camera/soc_camera.c                       |   30 +-
 drivers/media/platform/soc_camera/soc_camera_platform.c              |   24 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c                   |   37 +-
 drivers/media/platform/sti/bdisp/Makefile                            |    3 +
 drivers/media/platform/sti/bdisp/bdisp-debug.c                       |  679 +
 drivers/media/platform/sti/bdisp/bdisp-filter.h                      |  346 +
 drivers/media/platform/sti/bdisp/bdisp-hw.c                          |  823 +
 drivers/media/platform/sti/bdisp/bdisp-reg.h                         |  235 +
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                        | 1416 +
 drivers/media/platform/sti/bdisp/bdisp.h                             |  216 +
 drivers/media/platform/via-camera.c                                  |   19 +-
 drivers/media/platform/vim2m.c                                       |   12 +-
 drivers/media/platform/vivid/vivid-core.c                            |   20 +-
 drivers/media/platform/vivid/vivid-core.h                            |    6 +-
 drivers/media/platform/vivid/vivid-ctrls.c                           |  139 +-
 drivers/media/platform/vivid/vivid-radio-rx.c                        |    2 +
 drivers/media/platform/vivid/vivid-sdr-cap.c                         |   96 +-
 drivers/media/platform/vivid/vivid-sdr-cap.h                         |    2 +
 drivers/media/platform/vivid/vivid-tpg-colors.c                      |  478 +-
 drivers/media/platform/vivid/vivid-tpg-colors.h                      |    4 +-
 drivers/media/platform/vivid/vivid-tpg.c                             |  313 +-
 drivers/media/platform/vivid/vivid-tpg.h                             |   20 +
 drivers/media/platform/vivid/vivid-vid-cap.c                         |   31 +-
 drivers/media/platform/vivid/vivid-vid-common.c                      |   68 +-
 drivers/media/platform/vivid/vivid-vid-out.c                         |    7 +-
 drivers/media/platform/xilinx/Kconfig                                |    2 +-
 drivers/media/platform/xilinx/xilinx-dma.c                           |    4 +-
 drivers/media/radio/radio-si476x.c                                   |    4 +-
 drivers/media/radio/radio-timb.c                                     |    4 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c                        |    9 +-
 drivers/media/radio/si470x/radio-si470x-usb.c                        |    6 +-
 drivers/media/radio/si470x/radio-si470x.h                            |    8 +-
 drivers/media/radio/si4713/si4713.c                                  |    4 +-
 drivers/media/radio/wl128x/Kconfig                                   |    4 +-
 drivers/media/radio/wl128x/fmdrv.h                                   |    2 +-
 drivers/media/rc/fintek-cir.c                                        |    1 -
 drivers/media/rc/gpio-ir-recv.c                                      |    4 +-
 drivers/media/rc/ir-hix5hd2.c                                        |    8 +-
 drivers/media/rc/ir-rc5-decoder.c                                    |  116 +
 drivers/media/rc/ir-rc6-decoder.c                                    |  122 +
 drivers/media/rc/ir-sony-decoder.c                                   |   28 +-
 drivers/media/rc/keymaps/Makefile                                    |    4 +
 drivers/media/rc/keymaps/rc-technisat-ts35.c                         |   76 +
 drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c                 |   88 +
 drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c                 |   86 +
 drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c                     |   98 +
 drivers/media/rc/nuvoton-cir.c                                       |  127 +
 drivers/media/rc/nuvoton-cir.h                                       |    1 +
 drivers/media/rc/rc-core-priv.h                                      |   36 +
 drivers/media/rc/rc-ir-raw.c                                         |  139 +
 drivers/media/rc/rc-loopback.c                                       |   36 +
 drivers/media/rc/rc-main.c                                           |    9 +-
 drivers/media/rc/redrat3.c                                           |    7 +-
 drivers/media/rc/st_rc.c                                             |   12 +-
 drivers/media/rc/streamzap.c                                         |    6 +-
 drivers/media/tuners/Kconfig                                         |    5 +-
 drivers/media/tuners/e4000.c                                         |  592 +-
 drivers/media/tuners/e4000.h                                         |    1 -
 drivers/media/tuners/e4000_priv.h                                    |   11 +-
 drivers/media/tuners/fc0013.c                                        |    2 -
 drivers/media/tuners/fc2580.c                                        |  781 +-
 drivers/media/tuners/fc2580.h                                        |   40 +-
 drivers/media/tuners/fc2580_priv.h                                   |   36 +-
 drivers/media/tuners/msi001.c                                        |  267 +-
 drivers/media/tuners/qt1010.c                                        |    8 +-
 drivers/media/tuners/r820t.c                                         |    4 +-
 drivers/media/tuners/si2157.c                                        |   44 +-
 drivers/media/tuners/si2157.h                                        |    6 +
 drivers/media/tuners/si2157_priv.h                                   |    2 +
 drivers/media/tuners/tua9001.c                                       |  331 +-
 drivers/media/tuners/tua9001.h                                       |   35 +-
 drivers/media/tuners/tua9001_priv.h                                  |   19 +-
 drivers/media/tuners/tuner-i2c.h                                     |   10 +-
 drivers/media/tuners/tuner-xc2028.c                                  |    2 +-
 drivers/media/usb/as102/as102_drv.c                                  |    1 +
 drivers/media/usb/au0828/au0828-cards.c                              |    2 -
 drivers/media/usb/au0828/au0828-core.c                               |    2 +
 drivers/media/usb/cx231xx/cx231xx-417.c                              |   21 +-
 drivers/media/usb/cx231xx/cx231xx-avcore.c                           |   44 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c                            |   56 +-
 drivers/media/usb/cx231xx/cx231xx-core.c                             |   30 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c                              |    2 +
 drivers/media/usb/cx231xx/cx231xx-vbi.c                              |    3 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                            |   26 +-
 drivers/media/usb/cx231xx/cx231xx.h                                  |    1 +
 drivers/media/usb/dvb-usb-v2/af9015.c                                |    2 +-
 drivers/media/usb/dvb-usb-v2/af9015.h                                |    2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c                                |   58 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c                                |   18 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c                               |  112 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c                        |   14 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c                              |  193 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h                              |    5 +
 drivers/media/usb/dvb-usb/af9005-fe.c                                |    7 +-
 drivers/media/usb/dvb-usb/az6027.c                                   |    3 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c                             |    2 +-
 drivers/media/usb/dvb-usb/cxusb.c                                    |    1 +
 drivers/media/usb/dvb-usb/dib0700.h                                  |    2 +-
 drivers/media/usb/dvb-usb/dib0700_core.c                             |   70 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c                          |  145 +-
 drivers/media/usb/dvb-usb/dtt200u-fe.c                               |    7 +-
 drivers/media/usb/dvb-usb/dw2102.c                                   |   55 +-
 drivers/media/usb/dvb-usb/friio-fe.c                                 |    3 +-
 drivers/media/usb/dvb-usb/gp8psk-fe.c                                |   13 +-
 drivers/media/usb/dvb-usb/opera1.c                                   |    3 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c                           |    2 +-
 drivers/media/usb/dvb-usb/vp702x-fe.c                                |   17 +-
 drivers/media/usb/dvb-usb/vp702x.c                                   |    7 +-
 drivers/media/usb/dvb-usb/vp7045-fe.c                                |    3 +-
 drivers/media/usb/em28xx/em28xx-camera.c                             |   12 +-
 drivers/media/usb/em28xx/em28xx-dvb.c                                |  216 +-
 drivers/media/usb/em28xx/em28xx-video.c                              |    1 -
 drivers/media/usb/go7007/go7007-driver.c                             |    3 +-
 drivers/media/usb/go7007/go7007-usb.c                                |    4 +
 drivers/media/usb/go7007/go7007-v4l2.c                               |   12 +-
 drivers/media/usb/go7007/s2250-board.c                               |   18 +-
 drivers/media/usb/gspca/benq.c                                       |    4 +-
 drivers/media/usb/gspca/sn9c2028.c                                   |  241 +-
 drivers/media/usb/gspca/sn9c2028.h                                   |   18 +-
 drivers/media/usb/gspca/sonixj.c                                     |    2 +-
 drivers/media/usb/gspca/stk014.c                                     |    2 +-
 drivers/media/usb/gspca/xirlink_cit.c                                |   12 +-
 drivers/media/usb/gspca/zc3xx.c                                      |   16 +-
 drivers/media/usb/msi2500/msi2500.c                                  |  655 +-
 drivers/media/usb/pvrusb2/pvrusb2-context.c                          |    3 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                              |   35 +-
 drivers/media/usb/pvrusb2/pvrusb2-io.c                               |   30 +-
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c                           |   24 +-
 drivers/media/usb/stk1160/stk1160-v4l.c                              |    3 +-
 drivers/media/usb/tm6000/tm6000-video.c                              |    5 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c                    |    9 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c                              |    4 +-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c                             |   10 +-
 drivers/media/usb/usbtv/usbtv-video.c                                |   12 +-
 drivers/media/usb/usbvision/usbvision-core.c                         |    4 +-
 drivers/media/usb/usbvision/usbvision-video.c                        |   17 +-
 drivers/media/usb/uvc/uvc_driver.c                                   |    2 -
 drivers/media/usb/uvc/uvc_queue.c                                    |   12 +
 drivers/media/usb/uvc/uvc_v4l2.c                                     |   16 +-
 drivers/media/usb/uvc/uvc_video.c                                    |    8 +
 drivers/media/usb/uvc/uvcvideo.h                                     |    7 +-
 drivers/media/usb/zr364xx/zr364xx.c                                  |    3 +-
 drivers/media/v4l2-core/Kconfig                                      |    2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c                            |  117 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                                 |  214 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c                               |   38 +-
 drivers/media/v4l2-core/v4l2-of.c                                    |  100 +-
 drivers/media/v4l2-core/videobuf2-core.c                             |   63 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c                       |    6 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c                           |   22 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c                          |    6 +-
 drivers/staging/media/Kconfig                                        |    2 -
 drivers/staging/media/Makefile                                       |    1 -
 drivers/staging/media/bcm2048/radio-bcm2048.c                        |    3 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c                   |    1 +
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h                 |    2 -
 drivers/staging/media/davinci_vpfe/vpfe_video.c                      |   18 +-
 drivers/staging/media/dt3155v4l/Kconfig                              |   29 -
 drivers/staging/media/dt3155v4l/Makefile                             |    1 -
 drivers/staging/media/dt3155v4l/dt3155v4l.c                          |  981 -
 drivers/staging/media/lirc/lirc_imon.c                               |   97 +-
 drivers/staging/media/lirc/lirc_sir.c                                |   75 +-
 drivers/staging/media/mn88472/mn88472.c                              |    6 +-
 drivers/staging/media/mn88472/mn88472_priv.h                         |    2 +-
 drivers/staging/media/mn88473/mn88473.c                              |    2 +-
 drivers/staging/media/mn88473/mn88473_priv.h                         |    2 +-
 drivers/staging/media/omap4iss/iss.c                                 |    2 +-
 drivers/staging/media/omap4iss/iss_csi2.c                            |   18 +-
 drivers/staging/media/omap4iss/iss_ipipe.c                           |   30 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c                         |   10 +-
 drivers/staging/media/omap4iss/iss_resizer.c                         |    8 +-
 include/media/adp1653.h                                              |    8 +-
 include/media/adv7511.h                                              |    7 +-
 include/media/adv7604.h                                              |    1 -
 include/media/adv7842.h                                              |  142 +-
 include/media/rc-core.h                                              |    9 +-
 include/media/rc-map.h                                               |    4 +
 include/media/v4l2-dv-timings.h                                      |    6 +-
 include/media/v4l2-mediabus.h                                        |    2 +
 include/media/v4l2-mem2mem.h                                         |    4 +
 include/media/v4l2-of.h                                              |   20 +-
 include/media/v4l2-subdev.h                                          |   18 +-
 include/media/videobuf2-core.h                                       |   13 +
 include/trace/events/v4l2.h                                          |    3 +-
 include/uapi/linux/dvb/dmx.h                                         |   10 +-
 include/uapi/linux/dvb/frontend.h                                    |  223 +-
 include/uapi/linux/v4l2-mediabus.h                                   |    4 +-
 include/uapi/linux/videodev2.h                                       |   83 +-
 572 files changed, 27336 insertions(+), 10262 deletions(-)
 create mode 100644 Documentation/DocBook/media/.gitignore
 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-reset-overload.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-get-info.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-get-property.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-read-status.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-set-tone.xml
 create mode 100644 Documentation/DocBook/media/dvb/fe-set-voltage.xml
 create mode 100644 Documentation/DocBook/media/dvb/frontend_legacy_api.xml
 create mode 100644 Documentation/DocBook/media/typical_media_device.svg
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-y16-be.xml
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adp1653.txt
 create mode 100644 Documentation/devicetree/bindings/media/st,stih4xx.txt
 create mode 100644 drivers/media/dvb-frontends/cx24120.c
 create mode 100644 drivers/media/dvb-frontends/cx24120.h
 create mode 100644 drivers/media/pci/cobalt/Kconfig
 create mode 100644 drivers/media/pci/cobalt/Makefile
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-main.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-pcm.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-pcm.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-cpld.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-cpld.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-driver.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-driver.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-flash.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-flash.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-i2c.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-i2c.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-irq.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-irq.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-omnitek.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-omnitek.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-v4l2.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-v4l2.h
 create mode 100644 drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00389_cvi_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h
 create mode 100644 drivers/media/pci/dt3155/Kconfig
 create mode 100644 drivers/media/pci/dt3155/Makefile
 create mode 100644 drivers/media/pci/dt3155/dt3155.c
 rename drivers/{staging/media/dt3155v4l/dt3155v4l.h => media/pci/dt3155/dt3155.h} (82%)
 create mode 100644 drivers/media/pci/mantis/mantis_input.h
 create mode 100644 drivers/media/platform/sti/bdisp/Makefile
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-debug.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-filter.h
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-hw.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-reg.h
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp-v4l2.c
 create mode 100644 drivers/media/platform/sti/bdisp/bdisp.h
 create mode 100644 drivers/media/rc/keymaps/rc-technisat-ts35.c
 create mode 100644 drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.c
 create mode 100644 drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.c
 create mode 100644 drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.c
 delete mode 100644 drivers/staging/media/dt3155v4l/Kconfig
 delete mode 100644 drivers/staging/media/dt3155v4l/Makefile
 delete mode 100644 drivers/staging/media/dt3155v4l/dt3155v4l.c

