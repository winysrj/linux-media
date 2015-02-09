Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:50514 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759515AbbBIP5W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2015 10:57:22 -0500
Date: Mon, 9 Feb 2015 13:57:17 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.20-rc1] media updates
Message-ID: <20150209135717.36604b28@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.20-1


For:

  - Some documentation updates and a few new pixel formats;
  - Stop btcx-risc abuse by cx88 and move it to bt8xx driver;
  - New platform driver: am437x;
  - New webcam driver: toptek;
  - New remote controller hardware protocols added to img-ir driver;
  - Removal of a few very old drivers that relies on old kABIs and are for
    very hard to find hardware: parallel port webcam drivers (bw-qcam, c-cam,
    pms and w9966), tlg2300, Video In/Out for SGI (vino);
  - Removal of the USB Telegent driver (tlg2300). The company that developed
    this driver has long gone and the hardware is hard to find. As it relies
    on a legacy set of kABI symbols and nobody seems to care about it, remove
    it.
  - several improvements at rtl2832 driver;
  - conversion on cx28521 and au0828 to use videobuf2 (VB2);
  - several improvements, fixups and board additions.

Regards,
Mauro

-

The following changes since commit 26bc420b59a38e4e6685a73345a0def461136dce:

  Linux 3.19-rc6 (2015-01-25 20:04:41 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v3.20-1

for you to fetch changes up to 4bad5d2d25099a42e146d7b18d2b98950ed287f5:

  [media] dvb_net: Convert local hex dump to print_hex_dump_debug (2015-02-03 18:24:44 -0200)

----------------------------------------------------------------
media updates for v3.20-rc1

----------------------------------------------------------------
Akihiro Tsukada (1):
      [media] dvb: tc90522: re-add symbol-rate report

Alexey Khoroshilov (1):
      [media] cx231xx: fix usbdev leak on failure paths in cx231xx_usb_probe()

Andrey Utkin (1):
      [media] solo6x10: just pass frame motion flag from hardware, drop additional handling as complicated and unstable

Andy Shevchenko (1):
      [media] lirc_dev: avoid potential null-dereference

Antonio Ospite (1):
      [media] gspca_stv06xx: enable button found on some Quickcam Express variant

Antti Palosaari (95):
      [media] cx23885: do not unregister demod I2C client twice on error
      [media] cx23885: correct some I2C client indentations
      [media] cx23885: fix I2C scan printout
      [media] cx23885: Hauppauge WinTV-HVR5525
      [media] rtl2832: convert driver to I2C binding
      [media] rtl28xxu: switch rtl2832 demod attach to I2C binding
      [media] rtl28xxu: change module unregister order
      [media] si2168: define symbol rate limits
      [media] si2168: rename device state variable from 's' to 'dev'
      [media] si2168: carry pointer to client instead of state
      [media] si2168: get rid of own struct i2c_client pointer
      [media] si2168: simplify si2168_cmd_execute() error path
      [media] si2168: rename few things
      [media] si2168: change firmware version print from debug to info
      [media] si2168: change stream id debug log formatter
      [media] si2168: add own goto label for kzalloc failure
      [media] si2168: enhance firmware download routine
      [media] si2168: remove unneeded fw variable initialization
      [media] si2168: print chip version
      [media] si2168: change firmware variable name and type
      [media] si2157: rename device state variable from 's' to 'dev'
      [media] si2157: simplify si2157_cmd_execute() error path
      [media] si2157: carry pointer to client instead of state in tuner_priv
      [media] si2157: change firmware download error handling
      [media] si2157: trivial ID table changes
      [media] si2157: add own goto label for kfree() on probe error
      [media] si2157: print firmware version
      [media] si2157: print chip version
      [media] si2157: change firmware variable name and type
      [media] dvb-usb-v2: add pointer to 'struct usb_interface' for driver usage
      [media] rtl2830: convert driver to kernel I2C model
      [media] rtl28xxu: use I2C binding for RTL2830 demod driver
      [media] rtl2830: get rid of legacy DVB driver binding
      [media] rtl2830: rename 'priv' to 'dev'
      [media] rtl2830: carry pointer to I2C client for every function
      [media] rtl2830: fix logging
      [media] rtl2830: get rid of internal config data
      [media] rtl2830: style related changes
      [media] rtl2830: implement DVBv5 CNR statistic
      [media] rtl2830: implement DVBv5 signal strength statistics
      [media] rtl2830: implement DVBv5 BER statistic
      [media] rtl2830: wrap DVBv5 signal strength to DVBv3
      [media] rtl2830: wrap DVBv5 BER to DVBv3
      [media] rtl2830: wrap DVBv5 CNR to DVBv3 SNR
      [media] rtl2830: implement PID filter
      [media] rtl28xxu: add support for RTL2831U/RTL2830 PID filter
      [media] rtl2830: implement own I2C locking
      [media] rtl2830: convert to regmap API
      [media] rtl2832: add platform data callbacks for exported resources
      [media] rtl28xxu: use rtl2832 demod callbacks accessing its resources
      [media] rtl2832: remove exported resources
      [media] rtl2832: rename driver state variable from 'priv' to 'dev'
      [media] rtl2832: enhance / fix logging
      [media] rtl2832: move all configuration to platform data struct
      [media] rtl28xxu: use platform data config for rtl2832 demod
      [media] rtl2832: convert to regmap API
      [media] rtl2832: implement DVBv5 CNR statistic
      [media] rtl2832: implement DVBv5 BER statistic
      [media] rtl2832: wrap DVBv5 CNR to DVBv3 SNR
      [media] rtl2832: wrap DVBv5 BER to DVBv3
      [media] rtl2832: implement DVBv5 signal strength statistics
      [media] rtl28xxu: use demod mux I2C adapter for every tuner
      [media] rtl2832: drop FE i2c gate control support
      [media] rtl2832: define more demod lock statuses
      [media] rtl2832: implement PID filter
      [media] rtl28xxu: add support for RTL2832U/RTL2832 PID filter
      [media] rtl2832: use regmap reg cache
      [media] rtl2832: remove unneeded software reset from init()
      [media] rtl2832: merge reg page as a part of reg address
      [media] rtl2832: provide register IO callbacks
      [media] rtl2832_sdr: rename state variable from 's' to 'dev'
      [media] rtl2832_sdr: convert to platform driver
      [media] rtl28xxu: switch SDR module to platform driver
      [media] rtl28xxu: use master I2C adapter for slave demods
      [media] rtl2832_sdr: fix logging
      [media] rtl2832_sdr: cleanups
      [media] rtl2832: cleanups and minor changes
      [media] rtl2832: claim copyright and module author
      [media] rtl2832: implement sleep
      [media] rtl28xxu: fix DVB FE callback
      [media] rtl28xxu: simplify FE callback handling
      [media] rtl28xxu: do not refcount rtl2832_sdr module
      [media] rtl2832_sdr: refcount to rtl28xxu
      [media] rtl2832: remove internal mux I2C adapter
      [media] rtl28xxu: rename state variable 'priv' to 'dev'
      [media] rtl28xxu: fix logging
      [media] rtl28xxu: move usb buffers to state
      [media] rtl28xxu: add heuristic to detect chip type
      [media] rtl28xxu: merge chip type specific all callbacks
      [media] rtl28xxu: merge rtl2831u and rtl2832u properties
      [media] rtl28xxu: correct reg access routine name prefixes
      [media] rtl2832: implement own lock for regmap
      [media] rtl2830: add kernel-doc comments for platform_data
      [media] rtl2832: add kernel-doc comments for platform_data
      [media] rtl2832_sdr: add kernel-doc comments for platform_data

Arnd Bergmann (5):
      [media] timberdale: do not select TIMB_DMA
      [media] radio/aimslab: use mdelay instead of udelay
      [media] siano: fix Kconfig dependencies
      [media] davinci: add V4L2 dependencies
      [media] marvell-ccic: MMP_CAMERA no longer builds

Asaf Vertz (1):
      [media] media: stb0899_drv: use time_after()

Aviv Greenberg (2):
      [media] v4l: Add packed Bayer raw10 pixel formats
      [media] uvcvideo: Remove extra commit on resume()

Benjamin Larsson (4):
      [media] mn88472: calculate the IF register values
      [media] mn88472: document demod reset
      [media] mn88472: add 5MHz dvb-t2 bandwitdh support
      [media] mn88472: simplify bandwidth registers setting code

Benoit Parrot (1):
      [media] media: platform: add VPFE capture driver support for AM437X

Dan Carpenter (1):
      [media] coda: improve safety in coda_register_device()

Fabian Frederick (5):
      [media] tw68: remove unnecessary version.h inclusion
      [media] vivid: remove unnecessary version.h inclusion
      [media] uvcvideo: remove unnecessary version.h inclusion
      [media] s5p-g2d: remove unnecessary version.h inclusion
      [media] s5p-mfc: remove unnecessary version.h inclusion

Fabio Estevam (2):
      [media] coda: coda-common: Remove mx53 entry from coda_platform_ids
      [media] adv7180: Remove the unneeded 'err' label

Fengguang Wu (1):
      [media] media: platform: fix platform_no_drv_owner.cocci warnings

Geert Uytterhoeven (2):
      [media] VIDEO_CAFE_CCIC should select VIDEOBUF2_DMA_SG
      [media] vb2-vmalloc: Protect DMA-specific code by #ifdef CONFIG_HAS_DMA

Guennadi Liakhovetski (1):
      [media] soc-camera: remove redundant code

Hans Verkuil (34):
      [media] media: remove emacs editor variables
      [media] v4l2 subdevs: replace get/set_crop by get/set_selection
      [media] v4l2-subdev: drop get/set_crop pad ops
      [media] v4l2-subdev: drop unused op enum_mbus_fmt
      [media] media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER
      [media] cx25821: remove bogus btcx_risc dependency
      [media] cx231xx: remove btcx_riscmem reference
      [media] btcx-risc: move to bt8xx
      [media] cx28521: drop videobuf abuse in cx25821-alsa
      [media] cx25821: convert to vb2
      [media] cx25821: add create_bufs support
      [media] cx25821: remove video output support
      [media] media: drivers shouldn't touch debug field in video_device
      [media] v4l2 core: improve debug flag handling
      [media] v4l2-framework.txt: document debug attribute
      [media] av7110: fix sparse warning
      [media] budget-core: fix sparse warnings
      [media] ivtv: fix sparse warning
      [media] videobuf2-vmalloc: fix sparse warning
      [media] hd29l2: fix sparse error and warnings
      [media] m5mols: fix sparse warnings
      [media] s5k4ecgx: fix sparse warnings
      [media] s5k6aa: fix sparse warnings
      [media] s5k5baf: fix sparse warnings
      [media] videobuf: make unused exported functions static
      [media] hdmi: add new HDMI 2.0 defines
      [media] hdmi: rename HDMI_AUDIO_CODING_TYPE_EXT_STREAM to _EXT_CT
      [media] vivid: Y offset should depend on quant. range
      [media] pwc: fix WARN_ON
      [media] tlg2300: remove deprecated staging driver
      [media] vino/saa7191: remove deprecated drivers
      [media] bw/c-qcam, w9966, pms: remove deprecated staging drivers
      [media] Documentation/video4linux: remove obsolete text files
      [media] vivid: use consistent colorspace/Y'CbCr Encoding strings

Hans de Goede (3):
      [media] rc: sunxi-cir: Add support for an optional reset controller
      [media] rc: sunxi-cir: Add support for the larger fifo found on sun5i and sun6i
      [media] gspca: Fix underflow in vidioc_s_parm()

Heba Aamer (1):
      [media] staging: lirc_serial: adjust boolean assignments

Ian Molton (1):
      [media] rcar_vin: helper function for streaming stop

Ismael Luceno (5):
      [media] solo6x10: s/unsigned char/u8/
      [media] solo6x10: Fix eeprom_* functions buffer's type
      [media] solo6x10: Fix solo_eeprom_read retval type
      [media] solo6x10: s/uint8_t/u8/
      [media] MAINTAINERS: Update solo6x10 entry

James Hogan (1):
      [media] rc-main: Re-apply filter for no-op protocol change

Joe Howse (1):
      [media] gspca: Add high-speed modes for PS3 Eye camera

Joe Perches (3):
      [media] dvb_net: Use vsprintf %pM extension to print Ethernet addresses
      [media] dvb_net: Use standard debugging facilities
      [media] dvb_net: Convert local hex dump to print_hex_dump_debug

John McMaster (1):
      [media] gspca_touptek: Add support for ToupTek UCMOS series USB cameras

Josh Wu (1):
      [media] ov2640: use the v4l2 size definitions

Julia Lawall (4):
      [media] au0828: Use setup_timer
      [media] s2255drv: Use setup_timer
      [media] usbvision: Use setup_timer
      [media] pvrusb2: Use setup_timer

Jurgen Kramer (1):
      [media] Si2168: increase timeout to fix firmware loading

Lad, Prabhakar (2):
      [media] media: usb: uvc: use vb2_ops_wait_prepare/finish helper
      [media] soc_camera: use vb2_ops_wait_prepare/finish helper

Lars-Peter Clausen (14):
      [media] adv7180: Do not request the IRQ again during resume
      [media] adv7180: Pass correct flags to request_threaded_irq()
      [media] adv7180: Cleanup register define naming
      [media] adv7180: Do implicit register paging
      [media] adv7180: Reset the device before initialization
      [media] adv7180: Add media controller support
      [media] adv7180: Consolidate video mode setting
      [media] adv7180: Prepare for multi-chip support
      [media] adv7180: Add support for the adv7182
      [media] adv7180: Add support for the adv7280/adv7281/adv7282
      [media] adv7180: Add support for the adv7280-m/adv7281-m/adv7281-ma/adv7282-m
      [media] adv7180: Add I2P support
      [media] adv7180: Add fast switch support
      [media] Add MAINTAINERS entry for the adv7180

Laurent Pinchart (7):
      [media] omap3isp: Fix division by 0
      [media] v4l: omap4iss: Enable DMABUF support
      [media] v4l: omap4iss: Remove bogus frame number propagation
      [media] v4l: omap4iss: csi2: Perform real frame number propagation
      [media] v4l: omap4iss: Stop started entities when pipeline start fails
      [media] v4l: vsp1: Remove support for platform data
      [media] Revert "[media] v4l: omap4iss: Add module debug parameter"

Luca Bonissi (1):
      [media] gspca_vc032x: Fix wrong bytesperline

Lucas Stach (1):
      [media] coda: adjust sequence offset after unexpected decoded frame

Luis de Bethencourt (3):
      [media] staging: media: lirc: lirc_zilog.c: fix quoted strings split across lines
      [media] staging: media: lirc: lirc_zilog.c: keep consistency in dev functions
      [media] staging: media: lirc: lirc_zilog.c: missing newline in dev_err()

Malcolm Priestley (5):
      [media] lmedm04: Increase Interupt due time to 200 msec
      [media] lmedm04: Fix usb_submit_urb BOGUS urb xfer, pipe 1 != type 3 in interrupt urb
      [media] lmedm04: create frontend callbacks for signal/snr/ber/ucblocks
      [media] lmedm04: Create frontend call back for read status
      [media] lmedm04: add read snr, signal strength and ber call backs

Markus Elfring (1):
      [media] staging: bcm2048: Delete an unnecessary check before the function call "video_unregister_device"

Markus Pargmann (1):
      [media] coda: fix width validity check when starting to decode

Martin Bugge (2):
      [media] hdmi: added unpack and logging functions for InfoFrames
      [media] adv7842: simplify InfoFrame logging

Martin Kepplinger (1):
      [media] stb0899: use sign_extend32() for sign extension

Mauro Carvalho Chehab (10):
      [media] mb86a20s: remove unused debug modprobe parameter
      Merge tag 'v3.19-rc6' into patchwork
      [media] gspca/touptek: Fix a few CodingStyle issues
      [media] cx231xx: don't use dev it not allocated
      [media] cx23885: move CI/MAC registration to a separate function
      [media] dib8000: upd_demod_gain_period should be u32
      [media] rtl2830: declare functions as static
      [media] rtl2832: declare functions as static
      [media] rtl28xxu: properly initialize pdata
      [media] cx88-dvb: whitespace cleanup

Michael Ira Krufky (2):
      [media] lgdt3305: we only need to pass state into lgdt3305_mpeg_mode_polarity()
      [media] lgdt3305: add support for fixed tp clock mode

Nibble Max (1):
      [media] smipcie: return more proper value in interrupt handler

Nicholas Mc Guire (1):
      [media] pvrusb2: use msecs_to_jiffies for conversion

Nicolas Dufresne (3):
      [media] s5p-mfc-v6+: Use display_delay_enable CID
      [media] s5p-mfc-dec: Don't use encoder stop command
      [media] media-doc: Fix MFC display delay control doc

Nobuhiro Iwamatsu (2):
      [media] v4l: vsp1: Fix VI6_DISP_IRQ_ENB_LNEE macro
      [media] v4l: vsp1: Fix VI6_DISP_IRQ_STA_LNE macro

Olli Salonen (2):
      [media] si2168: return error if set_frontend is called with invalid parameters
      [media] si2168: add support for 1.7MHz bandwidth

Ondrej Zary (3):
      [media] bttv: Convert to generic TEA575x interface
      [media] tea575x: split and export functions
      [media] bttv: Improve TEA575x support

Philipp Zabel (18):
      [media] coda: fix encoder rate control parameter masks
      [media] coda: remove context debugfs entry last
      [media] coda: move meta out of padding
      [media] coda: fix job_ready debug reporting for bitstream decoding
      [media] coda: fix try_fmt_vid_out colorspace setting
      [media] coda: properly clear f_cap in coda_s_fmt_vid_out
      [media] coda: initialize SRAM on probe
      [media] coda: clear RET_DEC_PIC_SUCCESS flag in prepare_decode
      [media] coda: remove unused isequence, reset qsequence in stop_streaming
      [media] coda: issue seq_end_work during stop_streaming
      [media] coda: don't ever use subsampling ping-pong buffers as reconstructed reference buffers
      [media] coda: add coda_estimate_sizeimage and use it in set_defaults
      [media] coda: switch BIT decoder source queue to vmalloc
      [media] coda: make seq_end_work optional
      [media] coda: free context buffers under buffer mutex
      [media] coda: add support for contexts that do not use the BIT processor
      [media] coda: allocate bitstream ringbuffer only for BIT decoder
      [media] coda: simplify check in coda_buf_queue

Prabhakar Lad (9):
      [media] media: s3c-camif: use vb2_ops_wait_prepare/finish helper
      [media] media: ti-vpe: use vb2_ops_wait_prepare/finish helper
      [media] media: exynos-gsc: use vb2_ops_wait_prepare/finish helper
      [media] media: sh_veu: use vb2_ops_wait_prepare/finish helper
      [media] media: s5p-tv: use vb2_ops_wait_prepare/finish helper
      [media] media: s5p-mfc: use vb2_ops_wait_prepare/finish helper
      [media] media: Kconfig: drop duplicate dependency of HAS_DMA
      [media] media: am437x: fix sparse warnings
      [media] media: ti-vpe: Use mem-to-mem ioctl helpers

Rickard Strandqvist (7):
      [media] media: radio: wl128x: fmdrv_rx.c: Remove unused function
      [media] media: i2c: adv7604.c: Remove some unused functions
      [media] media: pci: mantis: mantis_core.c: Remove unused function
      [media] media: pci: saa7134: saa7134-video.c: Remove unused function
      [media] media: platform: vsp1: vsp1_hsit: Remove unused function
      [media] media: i2c: adv7604: Remove some unused functions
      [media] usb: pvrusb2: pvrusb2-hdw: Remove unused function

Russell King (8):
      [media] em28xx: fix em28xx-input removal
      [media] em28xx: ensure "closing" messages terminate with a newline
      [media] em28xx-input: fix missing newlines
      [media] em28xx-core: fix missing newlines
      [media] em28xx-audio: fix missing newlines
      [media] em28xx-audio: fix missing newlines
      [media] em28xx-dvb: fix missing newlines
      [media] em28xx-video: fix missing newlines

Sakari Ailus (22):
      [media] DocBook: v4l: Fix raw bayer pixel format documentation wording
      [media] DocBook: v4l: Rearrange raw bayer format definitions, remove bad comment
      [media] smiapp: Remove FSF's address from the license header
      [media] smiapp: List include/uapi/linux/smiapp.h in MAINTAINERS
      [media] smiapp-pll: include linux/device.h in smiapp-pll.c, not in smiapp-pll.h
      [media] smiapp: Use types better suitable for DT
      [media] smiapp: Don't give the source sub-device a temporary name
      [media] smiapp: Register async subdev
      [media] smiapp: The sensor only needs a single clock, name may be NULL
      [media] of: v4l: Document link-frequencies property in video-interfaces.txt
      [media] of: smiapp: Add documentation
      [media] smiapp: Obtain device information from the Device Tree if OF node exists
      [media] smiapp: Split sub-device initialisation off from the registered callback
      [media] smiapp: Fully probe the device in probe
      [media] smiapp: Access flash capabilities through limits
      [media] smiapp: Free control handlers in sub-device cleanup
      [media] smiapp: Clean up smiapp_init_controls()
      [media] smiapp: Separate late controls from the rest
      [media] smiapp: Move enumerating available media bus codes later
      [media] smiapp: Replace pll_flags quirk with more generic init quirk
      [media] smiapp: Add parentheses to macro arguments used in macros
      [media] smiapp: Don't compile of_read_number() if CONFIG_OF isn't defined

Shuah Khan (4):
      [media] media: au0828 VBI support comment cleanup
      [media] media: fix au0828_analog_register() to not free au0828_dev
      [media] media: fix au0828 compile error from au0828_boards initialization
      [media] media: au0828 - convert to use videobuf2

Sifan Naeem (5):
      [media] rc: img-ir: add scancode requests to a struct
      [media] rc: img-ir: pass toggle bit to the rc driver
      [media] rc: img-ir: biphase enabled with workaround
      [media] rc: img-ir: add philips rc5 decoder module
      [media] rc: img-ir: add philips rc6 decoder module

Takanari Hayama (3):
      [media] v4l: vsp1: Reset VSP1 RPF source address
      [media] v4l: vsp1: Always enable virtual RPF when BRU is in use
      [media] v4l: vsp1: bru: Fix minimum input pixel size

William Manley (1):
      [media] uvcvideo: Add GUID for BGR 8:8:8

William Towle (1):
      [media] rcar_vin: move buffer management to .stop_streaming handler

Wolfram Sang (1):
      [media] staging: media: bcm2048: Remove obsolete cleanup for clientdata

 Documentation/DocBook/media/v4l/controls.xml       |   11 +-
 Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10p.xml          |   99 +
 Documentation/DocBook/media/v4l/pixfmt-srggb12.xml |    2 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |    8 -
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |    8 -
 .../devicetree/bindings/media/i2c/nokia,smia.txt   |   63 +
 .../devicetree/bindings/media/sunxi-ir.txt         |    4 +-
 .../devicetree/bindings/media/ti-am437x-vpfe.txt   |   61 +
 .../devicetree/bindings/media/video-interfaces.txt |    3 +
 Documentation/video4linux/CQcam.txt                |  205 -
 Documentation/video4linux/README.tlg2300           |   47 -
 Documentation/video4linux/v4l2-framework.txt       |   25 +-
 Documentation/video4linux/w9966.txt                |   33 -
 MAINTAINERS                                        |   41 +-
 drivers/media/common/Kconfig                       |    4 -
 drivers/media/common/Makefile                      |    1 -
 drivers/media/common/btcx-risc.h                   |    6 -
 drivers/media/dvb-core/dvb_net.c                   |   88 +-
 drivers/media/dvb-frontends/Kconfig                |    4 +-
 drivers/media/dvb-frontends/au8522.h               |    5 -
 drivers/media/dvb-frontends/dib8000.c              |    3 +-
 drivers/media/dvb-frontends/hd29l2.c               |   10 +-
 drivers/media/dvb-frontends/lg2160.c               |    6 -
 drivers/media/dvb-frontends/lgdt3305.c             |   23 +-
 drivers/media/dvb-frontends/lgdt3305.h             |    6 +
 drivers/media/dvb-frontends/lgdt330x.c             |    6 -
 drivers/media/dvb-frontends/lgdt330x.h             |    6 -
 drivers/media/dvb-frontends/lgdt330x_priv.h        |    6 -
 drivers/media/dvb-frontends/mb86a20s.c             |    4 -
 drivers/media/dvb-frontends/mn88472.h              |    6 +
 drivers/media/dvb-frontends/nxt200x.h              |    6 -
 drivers/media/dvb-frontends/or51132.c              |    6 -
 drivers/media/dvb-frontends/or51132.h              |    6 -
 drivers/media/dvb-frontends/rtl2830.c              |  944 +++--
 drivers/media/dvb-frontends/rtl2830.h              |   79 +-
 drivers/media/dvb-frontends/rtl2830_priv.h         |   24 +-
 drivers/media/dvb-frontends/rtl2832.c              | 1336 +++---
 drivers/media/dvb-frontends/rtl2832.h              |   99 +-
 drivers/media/dvb-frontends/rtl2832_priv.h         |   32 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          | 1189 +++---
 drivers/media/dvb-frontends/rtl2832_sdr.h          |   57 +-
 drivers/media/dvb-frontends/s5h1409.c              |    6 -
 drivers/media/dvb-frontends/s5h1409.h              |    5 -
 drivers/media/dvb-frontends/s5h1411.c              |    5 -
 drivers/media/dvb-frontends/s5h1411.h              |    5 -
 drivers/media/dvb-frontends/si2168.c               |  317 +-
 drivers/media/dvb-frontends/si2168.h               |    6 +-
 drivers/media/dvb-frontends/si2168_priv.h          |    3 +-
 drivers/media/dvb-frontends/stb0899_algo.c         |    5 +-
 drivers/media/dvb-frontends/stb0899_drv.c          |    7 +-
 drivers/media/dvb-frontends/tc90522.c              |    1 +
 drivers/media/i2c/Kconfig                          |    9 +-
 drivers/media/i2c/adv7180.c                        | 1010 ++++-
 drivers/media/i2c/adv7604.c                        |   76 -
 drivers/media/i2c/adv7842.c                        |  184 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |    9 +-
 drivers/media/i2c/msp3400-driver.c                 |    8 -
 drivers/media/i2c/mt9m032.c                        |   42 +-
 drivers/media/i2c/mt9p031.c                        |   41 +-
 drivers/media/i2c/mt9t001.c                        |   41 +-
 drivers/media/i2c/mt9v032.c                        |   43 +-
 drivers/media/i2c/s5k4ecgx.c                       |   11 +-
 drivers/media/i2c/s5k5baf.c                        |   13 +-
 drivers/media/i2c/s5k6aa.c                         |   46 +-
 drivers/media/i2c/smiapp-pll.c                     |    7 +-
 drivers/media/i2c/smiapp-pll.h                     |    8 -
 drivers/media/i2c/smiapp/smiapp-core.c             |  386 +-
 drivers/media/i2c/smiapp/smiapp-limits.c           |    6 -
 drivers/media/i2c/smiapp/smiapp-limits.h           |    6 -
 drivers/media/i2c/smiapp/smiapp-quirk.c            |   14 +-
 drivers/media/i2c/smiapp/smiapp-quirk.h            |   24 +-
 drivers/media/i2c/smiapp/smiapp-reg-defs.h         |    6 -
 drivers/media/i2c/smiapp/smiapp-reg.h              |    6 -
 drivers/media/i2c/smiapp/smiapp-regs.c             |    6 -
 drivers/media/i2c/smiapp/smiapp-regs.h             |    6 -
 drivers/media/i2c/smiapp/smiapp.h                  |    7 -
 drivers/media/i2c/soc_camera/ov2640.c              |   82 +-
 drivers/media/i2c/ths8200.c                        |   10 -
 drivers/media/mmc/siano/Kconfig                    |    2 +
 drivers/media/pci/bt8xx/Kconfig                    |    4 +-
 drivers/media/pci/bt8xx/Makefile                   |    2 +-
 drivers/media/pci/bt8xx/bt878.c                    |    6 -
 drivers/media/{common => pci/bt8xx}/btcx-risc.c    |   36 +-
 drivers/media/pci/bt8xx/btcx-risc.h                |   26 +
 drivers/media/pci/bt8xx/bttv-cards.c               |  324 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   44 +-
 drivers/media/pci/bt8xx/bttv-gpio.c                |    6 -
 drivers/media/pci/bt8xx/bttv-if.c                  |    6 -
 drivers/media/pci/bt8xx/bttv-risc.c                |    6 -
 drivers/media/pci/bt8xx/bttv-vbi.c                 |    7 -
 drivers/media/pci/bt8xx/bttv.h                     |    5 -
 drivers/media/pci/bt8xx/bttvp.h                    |   20 +-
 drivers/media/pci/cx23885/Kconfig                  |    1 +
 drivers/media/pci/cx23885/cx23885-cards.c          |   43 +
 drivers/media/pci/cx23885/cx23885-dvb.c            |  376 +-
 drivers/media/pci/cx23885/cx23885-i2c.c            |    4 +-
 drivers/media/pci/cx23885/cx23885.h                |    3 +-
 drivers/media/pci/cx25821/Kconfig                  |    3 +-
 drivers/media/pci/cx25821/Makefile                 |    3 +-
 drivers/media/pci/cx25821/cx25821-alsa.c           |  113 +-
 drivers/media/pci/cx25821/cx25821-core.c           |  112 +-
 drivers/media/pci/cx25821/cx25821-video.c          |  685 +--
 drivers/media/pci/cx25821/cx25821.h                |   48 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |    3 -
 drivers/media/pci/cx88/cx88-core.c                 |    7 -
 drivers/media/pci/cx88/cx88-dvb.c                  |    4 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    7 -
 drivers/media/pci/cx88/cx88-tvaudio.c              |    7 -
 drivers/media/pci/ivtv/ivtv-irq.c                  |   22 +-
 drivers/media/pci/mantis/mantis_core.c             |   23 -
 drivers/media/pci/saa7134/saa7134-video.c          |    5 -
 drivers/media/pci/smipcie/smipcie.c                |   12 +-
 drivers/media/pci/solo6x10/solo6x10-core.c         |    4 +-
 drivers/media/pci/solo6x10/solo6x10-eeprom.c       |    2 +-
 drivers/media/pci/solo6x10/solo6x10-enc.c          |    6 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c         |    4 +-
 drivers/media/pci/solo6x10/solo6x10-jpeg.h         |    4 +-
 drivers/media/pci/solo6x10/solo6x10-tw28.c         |    4 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   48 +-
 drivers/media/pci/solo6x10/solo6x10.h              |    6 +-
 drivers/media/pci/sta2x11/Kconfig                  |    1 +
 drivers/media/pci/ttpci/av7110.c                   |    5 +-
 drivers/media/pci/ttpci/budget-core.c              |   89 +-
 drivers/media/pci/tw68/tw68.h                      |    1 -
 drivers/media/platform/Kconfig                     |   11 +-
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/am437x/Kconfig              |   11 +
 drivers/media/platform/am437x/Makefile             |    3 +
 drivers/media/platform/am437x/am437x-vpfe.c        | 2776 +++++++++++++
 drivers/media/platform/am437x/am437x-vpfe.h        |  283 ++
 drivers/media/platform/am437x/am437x-vpfe_regs.h   |  140 +
 drivers/media/platform/coda/coda-bit.c             |   25 +-
 drivers/media/platform/coda/coda-common.c          |  165 +-
 drivers/media/platform/coda/coda.h                 |    2 +-
 drivers/media/platform/coda/coda_regs.h            |    4 +-
 drivers/media/platform/davinci/Kconfig             |    6 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |   12 -
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    6 +-
 drivers/media/platform/marvell-ccic/Kconfig        |    3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |    1 -
 drivers/media/platform/omap3isp/isp.c              |    3 +
 drivers/media/platform/s3c-camif/camif-capture.c   |   17 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    1 -
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   23 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   21 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    6 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   21 +-
 drivers/media/platform/sh_veu.c                    |   35 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    7 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    7 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |   94 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    7 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   18 -
 drivers/media/platform/ti-vpe/vpe.c                |  162 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |    4 +-
 drivers/media/platform/vivid/vivid-tpg.c           |   10 +-
 drivers/media/platform/vivid/vivid-tpg.h           |    1 -
 drivers/media/platform/vsp1/vsp1.h                 |   14 +-
 drivers/media/platform/vsp1/vsp1_bru.c             |    2 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   81 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |    5 -
 drivers/media/platform/vsp1/vsp1_regs.h            |    4 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   18 +
 drivers/media/platform/vsp1/vsp1_rwpf.h            |    1 +
 drivers/media/platform/vsp1/vsp1_wpf.c             |   13 +-
 drivers/media/radio/radio-aimslab.c                |    4 +-
 drivers/media/radio/tea575x.c                      |   41 +-
 drivers/media/radio/wl128x/fmdrv_rx.c              |   16 -
 drivers/media/radio/wl128x/fmdrv_rx.h              |    1 -
 drivers/media/rc/img-ir/Kconfig                    |   15 +
 drivers/media/rc/img-ir/Makefile                   |    2 +
 drivers/media/rc/img-ir/img-ir-hw.c                |   84 +-
 drivers/media/rc/img-ir/img-ir-hw.h                |   24 +-
 drivers/media/rc/img-ir/img-ir-jvc.c               |    8 +-
 drivers/media/rc/img-ir/img-ir-nec.c               |   24 +-
 drivers/media/rc/img-ir/img-ir-rc5.c               |   88 +
 drivers/media/rc/img-ir/img-ir-rc6.c               |  117 +
 drivers/media/rc/img-ir/img-ir-sanyo.c             |    8 +-
 drivers/media/rc/img-ir/img-ir-sharp.c             |    8 +-
 drivers/media/rc/img-ir/img-ir-sony.c              |   12 +-
 drivers/media/rc/lirc_dev.c                        |    6 +-
 drivers/media/rc/rc-main.c                         |   14 +-
 drivers/media/rc/sunxi-cir.c                       |   46 +-
 drivers/media/tuners/mt20xx.c                      |    8 -
 drivers/media/tuners/mt2131.c                      |    5 -
 drivers/media/tuners/mt2131.h                      |    5 -
 drivers/media/tuners/mt2131_priv.h                 |    5 -
 drivers/media/tuners/mxl5007t.c                    |    8 -
 drivers/media/tuners/mxl5007t.h                    |    9 -
 drivers/media/tuners/si2157.c                      |  189 +-
 drivers/media/tuners/si2157_priv.h                 |    3 +-
 drivers/media/tuners/tda18271-fe.c                 |    8 -
 drivers/media/tuners/tda18271-maps.c               |    8 -
 drivers/media/tuners/tda18271-priv.h               |    8 -
 drivers/media/tuners/tda827x.c                     |    8 -
 drivers/media/tuners/tda8290.c                     |    8 -
 drivers/media/tuners/tda9887.c                     |    8 -
 drivers/media/tuners/tuner-simple.c                |    8 -
 drivers/media/usb/au0828/Kconfig                   |    2 +-
 drivers/media/usb/au0828/au0828-cards.c            |    2 +-
 drivers/media/usb/au0828/au0828-vbi.c              |  122 +-
 drivers/media/usb/au0828/au0828-video.c            |  976 ++---
 drivers/media/usb/au0828/au0828.h                  |   61 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    9 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |    1 -
 drivers/media/usb/cx231xx/cx231xx.h                |   10 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    2 +
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |    1 +
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |  336 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c      |    6 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h      |    6 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c       |    6 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h       |    6 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c        |    6 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h        |    6 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c        |    6 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h        |    6 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h        |    6 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c      |    8 -
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h      |    9 -
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |    6 -
 drivers/media/usb/dvb-usb-v2/mxl111sf.h            |    6 -
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |  940 +++--
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h            |   27 +-
 drivers/media/usb/dvb-usb/m920x.c                  |    5 -
 drivers/media/usb/em28xx/em28xx-audio.c            |    8 +-
 drivers/media/usb/em28xx/em28xx-core.c             |    4 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   14 +-
 drivers/media/usb/em28xx/em28xx-input.c            |    9 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    7 +-
 drivers/media/usb/gspca/Kconfig                    |   10 +
 drivers/media/usb/gspca/Makefile                   |    2 +
 drivers/media/usb/gspca/gspca.c                    |    2 +-
 drivers/media/usb/gspca/ov534.c                    |   10 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |    4 +-
 drivers/media/usb/gspca/touptek.c                  |  731 ++++
 drivers/media/usb/gspca/vc032x.c                   |   10 +-
 drivers/media/usb/pvrusb2/pvrusb2-audio.c          |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-audio.h          |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-context.c        |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-context.h        |    9 -
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c       |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h       |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-ctrl.c           |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-ctrl.h           |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c    |   12 -
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h    |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-debug.h          |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.c       |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.h       |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c        |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-devattr.h        |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c         |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.h         |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c        |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-encoder.h        |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h        |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h   |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   50 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h            |   13 -
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h       |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-io.c             |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-io.h             |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c         |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-ioread.h         |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-main.c           |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-std.c            |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-std.h            |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c          |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.h          |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-util.h           |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.h           |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c      |   11 -
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h      |   10 -
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.c         |   12 -
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.h         |   10 -
 drivers/media/usb/pvrusb2/pvrusb2.h                |   10 -
 drivers/media/usb/pwc/pwc-if.c                     |   12 +-
 drivers/media/usb/s2255/s2255drv.c                 |    4 +-
 drivers/media/usb/siano/Kconfig                    |    2 +
 drivers/media/usb/stk1160/stk1160-v4l.c            |    5 -
 drivers/media/usb/stkwebcam/stk-webcam.c           |    1 -
 drivers/media/usb/tm6000/tm6000-video.c            |    3 +-
 drivers/media/usb/usbvision/usbvision-core.c       |   13 +-
 drivers/media/usb/usbvision/usbvision-i2c.c        |    8 -
 drivers/media/usb/usbvision/usbvision-video.c      |    8 -
 drivers/media/usb/usbvision/usbvision.h            |    8 -
 drivers/media/usb/uvc/uvc_driver.c                 |    5 +
 drivers/media/usb/uvc/uvc_queue.c                  |   19 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |    1 -
 drivers/media/usb/uvc/uvc_video.c                  |    6 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    3 +
 drivers/media/usb/zr364xx/zr364xx.c                |    2 -
 drivers/media/v4l2-core/v4l2-dev.c                 |   35 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   10 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |    8 -
 drivers/media/v4l2-core/videobuf-dma-sg.c          |   15 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |    9 +-
 drivers/staging/media/Kconfig                      |    6 -
 drivers/staging/media/Makefile                     |    4 -
 drivers/staging/media/bcm2048/radio-bcm2048.c      |    6 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |   69 +-
 drivers/staging/media/lirc/lirc_serial.c           |   10 +-
 drivers/staging/media/lirc/lirc_zilog.c            |  118 +-
 drivers/staging/media/mn88472/mn88472.c            |   63 +-
 drivers/staging/media/mn88472/mn88472_priv.h       |    1 +
 drivers/staging/media/omap4iss/iss.c               |  111 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |   43 +-
 drivers/staging/media/omap4iss/iss_csi2.h          |    2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |   22 +-
 drivers/staging/media/omap4iss/iss_regs.h          |    2 +
 drivers/staging/media/omap4iss/iss_resizer.c       |   18 +-
 drivers/staging/media/omap4iss/iss_video.c         |   16 +-
 drivers/staging/media/parport/Kconfig              |   69 -
 drivers/staging/media/parport/Makefile             |    4 -
 drivers/staging/media/parport/bw-qcam.c            | 1177 ------
 drivers/staging/media/parport/c-qcam.c             |  882 ----
 drivers/staging/media/parport/pms.c                | 1156 ------
 drivers/staging/media/parport/w9966.c              |  980 -----
 drivers/staging/media/tlg2300/Kconfig              |   21 -
 drivers/staging/media/tlg2300/Makefile             |    9 -
 drivers/staging/media/tlg2300/pd-alsa.c            |  337 --
 drivers/staging/media/tlg2300/pd-common.h          |  271 --
 drivers/staging/media/tlg2300/pd-dvb.c             |  597 ---
 drivers/staging/media/tlg2300/pd-main.c            |  553 ---
 drivers/staging/media/tlg2300/pd-radio.c           |  339 --
 drivers/staging/media/tlg2300/pd-video.c           | 1570 -------
 drivers/staging/media/tlg2300/vendorcmds.h         |  243 --
 drivers/staging/media/vino/Kconfig                 |   24 -
 drivers/staging/media/vino/Makefile                |    3 -
 drivers/staging/media/vino/indycam.c               |  378 --
 drivers/staging/media/vino/indycam.h               |   93 -
 drivers/staging/media/vino/saa7191.c               |  649 ---
 drivers/staging/media/vino/saa7191.h               |  245 --
 drivers/staging/media/vino/vino.c                  | 4345 --------------------
 drivers/staging/media/vino/vino.h                  |  138 -
 drivers/video/hdmi.c                               |  822 +++-
 include/linux/hdmi.h                               |   37 +-
 include/linux/platform_data/vsp1.h                 |   27 -
 include/media/smiapp.h                             |   10 +-
 include/media/tea575x.h                            |    5 +
 include/media/v4l2-dev.h                           |    3 +-
 include/media/v4l2-ioctl.h                         |   15 +-
 include/media/v4l2-subdev.h                        |    6 -
 include/media/videobuf-dma-sg.h                    |    8 -
 include/media/videobuf-dvb.h                       |    6 -
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/am437x-vpfe.h                   |  122 +
 include/uapi/linux/v4l2-controls.h                 |    4 +
 include/uapi/linux/videodev2.h                     |   17 +-
 357 files changed, 12056 insertions(+), 21671 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
 create mode 100644 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
 create mode 100644 Documentation/devicetree/bindings/media/ti-am437x-vpfe.txt
 delete mode 100644 Documentation/video4linux/CQcam.txt
 delete mode 100644 Documentation/video4linux/README.tlg2300
 delete mode 100644 Documentation/video4linux/w9966.txt
 rename drivers/media/{common => pci/bt8xx}/btcx-risc.c (90%)
 create mode 100644 drivers/media/pci/bt8xx/btcx-risc.h
 create mode 100644 drivers/media/platform/am437x/Kconfig
 create mode 100644 drivers/media/platform/am437x/Makefile
 create mode 100644 drivers/media/platform/am437x/am437x-vpfe.c
 create mode 100644 drivers/media/platform/am437x/am437x-vpfe.h
 create mode 100644 drivers/media/platform/am437x/am437x-vpfe_regs.h
 create mode 100644 drivers/media/rc/img-ir/img-ir-rc5.c
 create mode 100644 drivers/media/rc/img-ir/img-ir-rc6.c
 create mode 100644 drivers/media/usb/gspca/touptek.c
 delete mode 100644 drivers/staging/media/parport/Kconfig
 delete mode 100644 drivers/staging/media/parport/Makefile
 delete mode 100644 drivers/staging/media/parport/bw-qcam.c
 delete mode 100644 drivers/staging/media/parport/c-qcam.c
 delete mode 100644 drivers/staging/media/parport/pms.c
 delete mode 100644 drivers/staging/media/parport/w9966.c
 delete mode 100644 drivers/staging/media/tlg2300/Kconfig
 delete mode 100644 drivers/staging/media/tlg2300/Makefile
 delete mode 100644 drivers/staging/media/tlg2300/pd-alsa.c
 delete mode 100644 drivers/staging/media/tlg2300/pd-common.h
 delete mode 100644 drivers/staging/media/tlg2300/pd-dvb.c
 delete mode 100644 drivers/staging/media/tlg2300/pd-main.c
 delete mode 100644 drivers/staging/media/tlg2300/pd-radio.c
 delete mode 100644 drivers/staging/media/tlg2300/pd-video.c
 delete mode 100644 drivers/staging/media/tlg2300/vendorcmds.h
 delete mode 100644 drivers/staging/media/vino/Kconfig
 delete mode 100644 drivers/staging/media/vino/Makefile
 delete mode 100644 drivers/staging/media/vino/indycam.c
 delete mode 100644 drivers/staging/media/vino/indycam.h
 delete mode 100644 drivers/staging/media/vino/saa7191.c
 delete mode 100644 drivers/staging/media/vino/saa7191.h
 delete mode 100644 drivers/staging/media/vino/vino.c
 delete mode 100644 drivers/staging/media/vino/vino.h
 delete mode 100644 include/linux/platform_data/vsp1.h
 create mode 100644 include/uapi/linux/am437x-vpfe.h

