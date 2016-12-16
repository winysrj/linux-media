Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42412
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754967AbcLPLzv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 06:55:51 -0500
Date: Fri, 16 Dec 2016 09:55:43 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.10-rc1] media updates
Message-ID: <20161216095543.4d5cfe41@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.10-1

For:

  - New Mediatek drivers: mtk-mdp and mtk-vcodec;
  - Some additions at the media documentation;
  - the CEC core and drivers were promoted from staging to mainstream;
  - Some cleanups at the DVB core;
  - The LIRC serial driver got promoted from staging to mainstream;
  - Added a driver for Renesas R-Car FDP1 driver;
  - add DVBv5 statistics support to mn88473 driver;
  - several fixes related to printk continuation lines;
  - add support for HSV encoding formats;
  - Lots of other cleanups, fixups and driver improvements.

Thanks!
Mauro

-

The following changes since commit e7aa8c2eb11ba69b1b69099c3c7bd6be3087b0ba:

  Merge tag 'docs-4.10' of git://git.lwn.net/linux (2016-12-12 21:58:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.10-1

for you to fetch changes up to 65390ea01ce678379da32b01f39fcfac4903f256:

  Merge branch 'patchwork' into v4l_for_linus (2016-12-15 08:38:35 -0200)

----------------------------------------------------------------
media updates for v4.10-rc1

----------------------------------------------------------------
Andi Shyti (1):
      [media] lirc_dev: remove compat_ioctl assignment

Andrea Gelmini (1):
      [media] extended-controls.rst: fix typo

Andrew-CT Chen (1):
      [media] VPU: mediatek: Add decode support

Andrey Utkin (3):
      [media] tw5864: crop picture width to 704
      [media] media: solo6x10: fix lockup by avoiding delayed register write
      [media] saa7146: Fix for while releasing video buffers

Andrzej Hajda (1):
      [media] s5p-mfc: Correct scratch buffer size of H.263 decoder

Antti Palosaari (3):
      [media] mn88473: refactor and fix statistics
      [media] mn88473: fix chip id check on probe
      [media] mn88472: fix chip id check on probe

Archit Taneja (1):
      [media] media: ti-vpe: Use line average de-interlacing for first 2 frames

Arnd Bergmann (11):
      [media] platform: pxa_camera: add VIDEO_V4L2 dependency
      [media] s5p-cec: mark PM functions as __maybe_unused again
      [media] media: mtk-mdp: mark PM functions as __maybe_unused
      [media] dvb: remove unused systime() function
      [media] go7007: add MEDIA_CAMERA_SUPPORT dependency
      [media] em28xx: only use mt9v011 if camera support is enabled
      [media] staging: media: davinci_vfpe: allow modular build
      [media] staging: media: davinci_vpfe: fix W=1 build warnings
      [media] v4l: rcar_fdp1: mark PM functions as __maybe_unused
      [media] v4l: rcar_fdp1: add FCP dependency
      [media] DaVinci-VPFE-Capture: fix error handling

Baoyou Xie (1):
      [media] coda: add missing header dependencies

Benoit Parrot (17):
      [media] media: i2c: tvp514x: Reported mbus format should be MEDIA_BUS_FMT_UYVY8_2X8
      [media] media: ti-vpe: vpdma: Make vpdma library into its own module
      [media] media: ti-vpe: vpdma: Add multi-instance and multi-client support
      [media] media: ti-vpe: vpdma: Add helper to set a background color
      [media] media: ti-vpe: vpdma: Fix bus error when vpdma is writing a descriptor
      [media] media: ti-vpe: vpe: Added MODULE_DEVICE_TABLE hint
      [media] media: ti-vpe: vpdma: Corrected YUV422 data type label
      [media] media: ti-vpe: vpdma: RGB data type yield inverted data
      [media] media: ti-vpe: vpe: Fix vb2 buffer cleanup
      [media] media: ti-vpe: vpe: Enable DMABUF export
      [media] media: ti-vpe: Make scaler library into its own module
      [media] media: ti-vpe: scaler: Add debug support for multi-instance
      [media] media: ti-vpe: vpe: Make sure frame size dont exceed scaler capacity
      [media] media: ti-vpe: vpdma: Add RAW8 and RAW16 data types
      [media] media: ti-vpe: Make colorspace converter library into its own module
      [media] media: ti-vpe: csc: Add debug support for multi-instance
      [media] media: ti-vpe: vpe: Add proper support single and multi-plane buffer

CIJOML CIJOMLovic (1):
      [media] Add support for EVOLVEO XtraTV stick

Christophe JAILLET (1):
      [media] VPU: mediatek: Fix return value in case of error

Colin Ian King (5):
      [media] VPU: mediatek: fix null pointer dereference on pdev
      [media] cx24120: do not allow an invalid delivery system types
      [media] variable name is never null, so remove null check
      [media] st-hva: fix a copy-and-paste variable name error
      [media] zoran: fix spelling mistake in dprintk message

CrazyCat (1):
      [media] dvb-usb-cxusb: Geniatech T230 - resync TS FIFO after lock

Dan Carpenter (5):
      [media] st-hva: fix some error handling in hva_hw_probe()
      [media] blackfin: check devm_pinctrl_get() for errors
      [media] stk-webcam: fix an endian bug in stk_camera_read_reg()
      [media] staging: media: davinci_vpfe: unlock on error in vpfe_reqbufs()
      [media] uvcvideo: freeing an error pointer

Daniel Wagner (2):
      [media] imon: use complete() instead of complete_all()
      [media] lirc_imon: use complete() instead complete_all()

Donghwa Lee (1):
      [media] s5p-mfc: Skip incomplete frame

Douglas Anderson (1):
      [media] s5p-mfc: Set DMA_ATTR_ALLOC_SINGLE_PAGES

Edgar Thier (1):
      [media] uvcvideo: Add bayer 16-bit format patterns

Enrico Mioso (1):
      [media] Add Cinergy S2 rev.4 support

Fabio Estevam (1):
      [media] coda: fix the error path in coda_probe()

Fengguang Wu (1):
      [media] media: fix platform_no_drv_owner.cocci warnings

Geliang Tang (1):
      [media] netup_unidvb: use module_pci_driver

Hans Verkuil (31):
      [media] pixfmt-reserved.rst: Improve MT21C documentation
      [media] mtk-mdp: fix double mutex_unlock
      [media] videodev2.h: checkpatch cleanup
      [media] videodev2.h: add VICs and picture aspect ratio
      [media] vidioc-g-dv-timings.rst: document the new dv_timings flags
      [media] v4l2-dv-timings: add VICs and picture aspect ratio
      [media] v4l2-dv-timings: add helpers for vic and pixelaspect ratio
      [media] cobalt: add cropcap support
      [media] adv7604: add vic detect
      [media] cec-core.rst: improve documentation
      [media] control.rst: improve the queryctrl code examples
      [media] cobalt: fix copy-and-paste error
      [media] pulse8-cec: set all_device_types when restoring config
      [media] cec rst: convert tables and drop the 'row' comments
      [media] cec: add flag to cec_log_addrs to enable RC passthrough
      [media] cec: add CEC_MSG_FL_REPLY_TO_FOLLOWERS
      [media] cec: filter invalid messages
      [media] cec: accept two replies for CEC_MSG_INITIATE_ARC
      [media] cec: add proper support for CDC-Only CEC devices
      [media] cec: move the CEC framework out of staging and to media
      [media] cec: sanitize msg.flags
      [media] cec.h/cec-funcs.h: don't use bool in public headers
      [media] cec: an inner loop clobbered the outer loop variable
      [media] pulse8-cec: move out of staging
      [media] s5p-cec/st-cec: update TODOs
      [media] MAINTAINERS: update paths
      [media] cec: zero counters in cec_received_msg()
      [media] vivid: fix HDMI VSDB block in the EDID
      [media] cec: ignore messages that we initiated
      [media] vpfe_capture: fix compiler warning
      [media] cec: pass parent device in register(), not allocate()

Harinarayan Bhatta (2):
      [media] media: ti-vpe: Increasing max buffer height and width
      [media] media: ti-vpe: Free vpdma buffers in vpe_release

Heiner Kallweit (7):
      [media] rc: ir-raw: change type of available_protocols to atomic64_t
      [media] rc: core: add managed versions of rc_allocate_device and rc_register_device
      [media] rc: nuvoton: use managed versions of rc_allocate_device and rc_register_device
      [media] media: rc: nuvoton: eliminate member pdev from struct nvt_dev
      [media] media: rc: nuvoton: eliminate nvt->tx.lock
      [media] media: rc: nuvoton: rename spinlock nvt_lock
      [media] media: rc: nuvoton: replace usage of spin_lock_irqsave in ISR

Henrik Ingo (1):
      [media] uvcvideo: uvc_scan_fallback() for webcams with broken chain

Ingi Kim (1):
      [media] s5p-mfc: Fix MFC context buffer size

Javier Martinez Canillas (12):
      [media] v4l: vsp1: Fix module autoload for OF registration
      [media] v4l: rcar-fcp: Fix module autoload for OF registration
      [media] rc: meson-ir: Fix module autoload
      [media] s5p-cec: Fix module autoload
      [media] st-cec: Fix module autoload
      [media] exynos-gsc: change spamming try_fmt log message to debug
      [media] exynos-gsc: don't clear format when freeing buffers with REQBUFS(0)
      [media] exynos-gsc: fix supported RGB pixel format
      [media] exynos-gsc: do proper bytesperline and sizeimage calculation
      [media] exynos-gsc: don't release a non-dynamically allocated video_device
      [media] exynos-gsc: unregister video device node on driver removal
      [media] exynos-gsc: cleanup m2m src and dst vb2 queues on STREAMOFF

Jean-Baptiste Abbadie (3):
      [media] Staging: media: radio-bcm2048: Fix symbolic permissions
      [media] Staging: media: radio-bcm2048: Fix indentation
      [media] Staging: media: radio-bcm2048: Remove FSF address from GPL notice

Joerg Riechardt (1):
      [media] stv090x: use lookup tables for carrier/noise ratio

Jonathan Sims (1):
      [media] hdpvr: fix interrupted recording

Julia Lawall (1):
      [media] vcodec: mediatek: fix odd_ptr_err.cocci warnings

Kieran Bingham (2):
      [media] dt-bindings: Add Renesas R-Car FDP1 bindings
      [media] v4l: Add Renesas R-Car FDP1 Driver

Laurent Pinchart (7):
      [media] v4l: vsp1: Add support for capture and output in HSV formats
      [media] v4l: omap3isp: Fix OF node double put when parsing OF graph
      [media] v4l: ctrls: Add deinterlacing mode control
      [media] v4l: Add description of the Y8I, Y12I and Z16 formats
      [media] v4l: tvp5150: Compile tvp5150_link_setup out if !CONFIG_MEDIA_CONTROLLER
      [media] v4l: tvp5150: Don't inline the tvp5150_selmux() function
      [media] v4l: tvp5150: Add missing break in set control handler

Leo Sperling (1):
      [media] staging: media: davinci_vpfe: Fix indentation issue in vpfe_video.c

Lubomir Rintel (1):
      [media] usbtv: add video controls

Maciej S. Szmigiero (1):
      [media] saa7134: fix warm Medion 7134 EEPROM read

Maninder Singh (1):
      [media] staging: st-cec: add parentheses around complex macros

Manuel Rodriguez (1):
      [media] staging: media: davinci_vpfe: Fix spelling error on a comment

Marek Szyprowski (17):
      [media] s5p-mfc: fix failure path of s5p_mfc_alloc_memdev()
      [media] exynos-gsc: Simplify system PM even more
      [media] exynos-gsc: Remove unused lclk_freqency entry
      [media] exynos-gsc: Add missing newline char in debug messages
      [media] exynos-gsc: Use of_device_get_match_data() helper
      [media] exynos-gsc: Enable driver on ARCH_EXYNOS
      [media] exynos-gsc: Add support for Exynos5433 specific version
      [media] s5p-mfc: Use clock gating only on MFC v5 hardware
      [media] s5p-mfc: Fix clock management in s5p_mfc_release() function
      [media] s5p-mfc: Use printk_ratelimited for reporting ioctl errors
      [media] s5p-mfc: Remove special clock rate management
      [media] s5p-mfc: Ensure that clock is disabled before turning power off
      [media] s5p-mfc: Remove dead conditional code
      [media] s5p-mfc: Kill all IS_ERR_OR_NULL in clocks management code
      [media] s5p-mfc: Don't keep clock prepared all the time
      [media] s5p-mfc: Rework clock handling
      [media] s5p-mfc: Add support for MFC v8 available in Exynos 5433 SoCs

Markus Elfring (45):
      [media] dvb-tc90522: Use kmalloc_array() in tc90522_master_xfer()
      [media] dvb-tc90522: Rename a jump label in tc90522_probe()
      [media] cx88-dsp: Use kmalloc_array() in read_rds_samples()
      [media] cx88-dsp: Add some spaces for better code readability
      [media] blackfin-capture: Use kcalloc() in bcap_init_sensor_formats()
      [media] blackfin-capture: Delete an error message for a failed memory allocation
      [media] DaVinci-VPBE: Use kmalloc_array() in vpbe_initialize()
      [media] DaVinci-VPBE: Delete two error messages for a failed memory allocation
      [media] DaVinci-VPBE: Adjust 16 checks for null pointers
      [media] DaVinci-VPBE: Return an error code only as a constant in vpbe_probe()
      [media] DaVinci-VPBE: Return the success indication only as a constant in vpbe_set_mode()
      [media] DaVinci-VPBE: Reduce the scope for a variable in vpbe_set_default_output()
      [media] DaVinci-VPBE: Rename a jump label in vpbe_set_output()
      [media] DaVinci-VPBE: Delete an unnecessary variable initialisation in vpbe_set_output()
      [media] DaVinci-VPFE-Capture: Use kmalloc_array() in vpfe_probe()
      [media] DaVinci-VPFE-Capture: Delete three error messages for a failed memory allocation
      [media] DaVinci-VPFE-Capture: Improve another size determination in vpfe_probe()
      [media] DaVinci-VPFE-Capture: Delete an unnecessary variable initialisation in vpfe_probe()
      [media] DaVinci-VPFE-Capture: Improve another size determination in vpfe_open()
      [media] DaVinci-VPFE-Capture: Adjust 13 checks for null pointers
      [media] DaVinci-VPFE-Capture: Delete an unnecessary variable initialisation in 11 functions
      [media] DaVinci-VPFE-Capture: Move two assignments in vpfe_s_input()
      [media] DaVinci-VPFE-Capture: Delete unnecessary braces in vpfe_isr()
      [media] DaVinci-VPFE-Capture: Delete an unnecessary return statement in vpfe_unregister_ccdc_device()
      [media] DaVinci-VPIF-Capture: Use kcalloc() in vpif_probe()
      [media] DaVinci-VPIF-Capture: Delete an error message for a failed memory allocation
      [media] DaVinci-VPIF-Capture: Adjust ten checks for null pointers
      [media] DaVinci-VPIF-Capture: Delete an unnecessary variable initialisation in vpif_querystd()
      [media] DaVinci-VPIF-Capture: Delete an unnecessary variable initialisation in vpif_channel_isr()
      [media] DaVinci-VPIF-Display: Use kcalloc() in vpif_probe()
      [media] DaVinci-VPIF-Display: Delete an error message for a failed memory allocation
      [media] DaVinci-VPIF-Display: Adjust 11 checks for null pointers
      [media] DaVinci-VPIF-Display: Delete an unnecessary variable initialisation in vpif_channel_isr()
      [media] DaVinci-VPIF-Display: Delete an unnecessary variable initialisation in process_progressive_mode()
      [media] DaVinci-VPBE: Check return value of a setup_if_config() call in vpbe_set_output()
      [media] DaVinci-VPFE-Capture: Replace a memcpy() call by an assignment in vpfe_enum_input()
      [media] RedRat3: Use kcalloc() in two functions
      [media] RedRat3: Delete six messages for a failed memory allocation
      [media] RedRat3: Improve another size determination in redrat3_reset()
      [media] RedRat3: Return directly after a failed kcalloc() in redrat3_transmit_ir()
      [media] RedRat3: Delete an unnecessary variable initialisation in redrat3_get_firmware_rev()
      [media] RedRat3: Delete an unnecessary variable initialisation in redrat3_init_rc_dev()
      [media] RedRat3: Return directly after a failed rc_allocate_device() in redrat3_init_rc_dev()
      [media] winbond-cir: Use kmalloc_array() in wbcir_tx()
      [media] uvcvideo: Use memdup_user() rather than duplicating its implementation

Martin Blumenstingl (1):
      [media] mn88473: add DVBv5 statistics support

Masahiro Yamada (1):
      [media] squash lines for simple wrapper functions

Masanari Iida (1):
      [media] v4l: doc: Fix typo in vidioc-g-tuner.rst

Mauro Carvalho Chehab (148):
      [media] dvb-usb: warn if return value for USB read/write routines is not checked
      Merge tag 'v4.9-rc1' into patchwork
      [media] radio-bcm2048: don't ignore errors
      [media] tuner-xc2028: mark printk continuation lines as such
      [media] tuner-xc2028: don't break long lines
      [media] em28xx: don't break long lines
      [media] em28xx: mark printk continuation lines as such
      [media] em28xx: use pr_foo instead of em28xx-specific printk macros
      [media] em28xx: convert the remaining printks to pr_foo
      [media] dvb-core: don't break long lines
      [media] tuner-core: don't break long lines
      [media] tuner-core: use %&ph for small buffer dumps
      [media] dvb-core: use pr_foo() instead of printk()
      [media] dvb_demux: convert an internal ifdef into a Kconfig option
      [media] dvb_demux: uncomment a packet loss check code
      [media] dvb-core: get rid of demux optional circular buffer
      [media] dvb-core: move dvb_filter out of the DVB core
      [media] dvb_filter: get rid of dead code
      [media] dvb_filter: use KERN_CONT where needed
      [media] uvc_driver: use KERN_CONT where needed
      [media] imon: use %*ph to do small hexa dumps
      [media] mt20xx: use %*ph to do small hexa dumps
      [media] tvaudio: mark printk continuation lines as such
      [media] flexcop-i2c: mark printk continuation lines as such
      [media] cx2341x: mark printk continuation lines as such
      [media] dvb-pll: use pr_foo() macros instead of printk()
      [media] nxt6000: use pr_foo() macros instead of printk()
      [media] b2c2: don't break long lines
      [media] cx25840: don't break long lines
      [media] smiapp: don't break long lines
      [media] soc_camera: don't break long lines
      [media] b2c2: don't break long lines
      [media] bt8xx: don't break long lines
      [media] cx18: don't break long lines
      [media] cx23885: don't break long lines
      [media] cx88: don't break long lines
      [media] ddbridge: don't break long lines
      [media] dm1105: don't break long lines
      [media] ivtv: don't break long lines
      [media] meye: don't break long lines
      [media] pt1: don't break long lines
      [media] saa7134: don't break long lines
      [media] saa7164: don't break long lines
      [media] solo6x10: don't break long lines
      [media] ttpci: don't break long lines
      [media] tw68: don't break long lines
      [media] davinci: don't break long lines
      [media] exynos4-is: don't break long lines
      [media] marvell-ccic: don't break long lines
      [media] omap: don't break long lines
      [media] omap3isp: don't break long lines
      [media] s5p-mfc: don't break long lines
      [media] c8sectpfe: don't break long lines
      [media] ti-vpe: don't break long lines
      [media] si470x: don't break long lines
      [media] si4713: don't break long lines
      [media] wl128x: don't break long lines
      [media] au0828: don't break long lines
      [media] b2c2: don't break long lines
      [media] cpia2: don't break long lines
      [media] cx231xx: don't break long lines
      [media] dvb-usb: don't break long lines
      [media] dvb-usb-v2: don't break long lines
      [media] em28xx: don't break long lines
      [media] gspca: don't break long lines
      [media] hdpvr: don't break long lines
      [media] pvrusb2: don't break long lines
      [media] pwc: don't break long lines
      [media] siano: don't break long lines
      [media] stkwebcam: don't break long lines
      [media] tm6000: don't break long lines
      [media] ttusb-budget: don't break long lines
      [media] ttusb-dec: don't break long lines
      [media] usbvision: don't break long lines
      [media] zr364xx: don't break long lines
      [media] v4l2-core: don't break long lines
      [media] dvb-frontends: don't break long lines
      [media] common: don't break long lines
      [media] firewire: don't break long lines
      [media] platform: don't break long lines
      [media] radio: don't break long lines
      [media] rc: don't break long lines
      [media] tuners: don't break long lines
      [media] tveeprom: use dev_foo() for printk messages
      [media] mtk-vcodec: fix some smatch warnings
      [media] mtk-mdp: fix compilation warnings if !DEBUG
      [media] spca506: rewrite a commented line to avoid wrong parsing
      [media] stv06xx: store device name after the USB_DEVICE line
      [media] gspca-cardlist.rst: sort entries and adjust table margins
      [media] gspca-cardlist.rst: update cardlist from drivers USB IDs
      [media] gspca-cardlist.rst: update camera names
      [media] cardlist: convert them to asciiart tables
      [media] v4l2-flash-led-class: remove a now unused var
      [media] usbtv: don't do DMA on stack
      [media] cec-ioc-adap-g-log-addrs.rst: describe CEC_LOG_ADDRS_FL_CDC_ONLY
      Merge tag 'v4.9-rc5' into patchwork
      [media] dtv-core: get rid of duplicated kernel-doc include
      [media] docs-rst: cleanup SVG files
      [media] stb0899_drv: get rid of continuation lines
      [media] stv090x: get rid of continuation lines
      [media] bt8xx/dst: use a more standard way to print messages
      [media] bt8xx: use pr_foo() macros instead of printk()
      [media] cx23885: use KERN_CONT where needed
      gp8psk-fe: add missing MODULE_foo() macros
      [media] cx23885: convert it to use pr_foo() macros
      [media] cx88: use KERN_CONT where needed
      [media] cx88: convert it to use pr_foo() macros
      [media] cx88: make checkpatch happier
      [media] pluto2: use KERN_CONT where needed
      [media] zoran: use KERN_CONT where needed
      [media] wl128x: use KERNEL_CONT where needed
      [media] pvrusb2: use KERNEL_CONT where needed
      [media] ttusb_dec: use KERNEL_CONT where needed
      [media] ttpci: cleanup debug macros and remove dead code
      [media] dib0070: use pr_foo() instead of printk()
      [media] dib0090: use pr_foo() instead of printk()
      [media] dib3000mb: use pr_foo() instead of printk()
      [media] dib3000mc: use pr_foo() instead of printk()
      [media] dib7000m: use pr_foo() instead of printk()
      [media] dib7000p: use pr_foo() instead of printk()
      [media] dib8000: use pr_foo() instead of printk()
      [media] dib9000: use pr_foo() instead of printk()
      [media] dibx000_common: use pr_foo() instead of printk()
      [media] af9005: remove a printk that would require a KERN_CONT
      [media] tuner-core: use pr_foo, instead of internal printk macros
      [media] v4l2-common: add a debug macro to be used with dev_foo()
      [media] msp3400-driver: don't use KERN_CONT
      [media] msp3400: convert it to use dev_foo() macros
      [media] em28xx: convert it from pr_foo() to dev_foo()
      [media] tvp5150: convert it to use dev_foo() macros
      [media] tvp5150: Get rid of direct calls to printk()
      [media] tvp5150: get rid of KERN_CONT
      [media] rc-main: use pr_foo() macros
      [media] tveeprom: print log messages using pr_foo()
      [media] Kconfig: fix breakages when DVB_CORE is not selected
      Revert "[media] dvb_frontend: merge duplicate dvb_tuner_ops.release implementations"
      Merge tag 'v4.9-rc6' into patchwork
      lirc_serial: make checkpatch happy
      [media] serial_ir: fix reference to 8250 serial code
      [media] vpdma: remove vpdma_enable_list_notify_irq()
      [media] ti-vpe: get rid of some smatch warnings
      [media] dvb_net: prepare to split a very complex function
      [media] dvb-net: split the logic at dvb_net_ule() into other functions
      [media] cx88: make checkpatch.pl happy
      [media] em28xx: don't change the device's name
      [media] em28xx: use usb_interface for dev_foo() calls
      [media] em28xx: don't store usb_device at struct em28xx
      Merge branch 'patchwork' into v4l_for_linus

Max Kellermann (12):
      [media] rc-main: clear rc_map.name in ir_free_table()
      [media] dvb: make DVB frontend *_ops instances "const"
      [media] dvbdev: split dvb_unregister_device()
      [media] dvb-core/en50221: use dvb_remove_device()
      [media] dvb_frontend: merge duplicate dvb_tuner_ops.release implementations
      [media] dvb_frontend: tuner_ops.release returns void
      [media] dvb_frontend: merge the two dvb_frontend_detach() versions
      [media] dvb_frontend: add "detach" callback
      [media] stb0899: move code to "detach" callback
      [media] dvb_frontend: move kref to struct dvb_frontend
      [media] media-entity: clear media_gobj.mdev in _destroy()
      [media] drivers/media/media-device: fix double free bug in _unregister()

Minghsiu Tsai (9):
      [media] VPU: mediatek: Add mdp support
      [media] dt-bindings: Add a binding for Mediatek MDP
      [media] media: Add Mediatek MDP Driver
      [media] arm64: dts: mediatek: Add MDP for MT8173
      [media] media: mtk-mdp: support pixelformat V4L2_PIX_FMT_MT21C
      [media] media: mtk-mdp: add Maintainers entry for Mediatek MDP driver
      [media] media: mtk-mdp: fix build warning in arch x86
      [media] media: mtk-mdp: fix build error
      [media] mtk-mdp: allocate video_device dynamically

Nicolas Dufresne (1):
      [media] exynos4-is: fimc: Roundup imagesize to row size for tiled formats

Nicolas Iooss (2):
      [media] mb86a20s: always initialize a return value
      [media] ite-cir: initialize use_demodulator before using it

Nikhil Devshatwar (16):
      [media] media: ti-vpe: vpe: Do not perform job transaction atomically
      [media] media: ti-vpe: Add support for SEQ_TB buffers
      [media] media: ti-vpe: vpe: Return NULL for invalid buffer type
      [media] media: ti-vpe: vpdma: Add support for setting max width height
      [media] media: ti-vpe: vpdma: Add abort channel desc and cleanup APIs
      [media] media: ti-vpe: vpdma: Make list post atomic operation
      [media] media: ti-vpe: vpdma: Clear IRQs for individual lists
      [media] media: ti-vpe: vpe: configure line mode separately
      [media] media: ti-vpe: vpe: Setup srcdst parameters in start_streaming
      [media] media: ti-vpe: vpe: Post next descriptor only for list complete IRQ
      [media] media: ti-vpe: vpe: Add RGB565 and RGB5551 support
      [media] media: ti-vpe: vpdma: allocate and maintain hwlist
      [media] media: ti-vpe: sc: Fix incorrect optimization
      [media] media: ti-vpe: vpdma: Fix race condition for firmware loading
      [media] media: ti-vpe: vpdma: Use bidirectional cached buffers
      [media] media: ti-vpe: vpe: Fix line stride for output motion vector

Olli Salonen (1):
      [media] dvb-usb-dvbsky: Add support for TechnoTrend S2-4650 CI

Paul Bolle (1):
      [media] dvb-usb: remove another redundant #include <linux/kconfig.h>

Peter Chen (1):
      [media] media: platform: ti-vpe: call of_node_put on non-null pointer

Peter Griffin (1):
      [media] c8sectpfe: Remove clk_disable_unprepare hacks

Peter Ujfalusi (1):
      [media] v4l: omap3isp: Use dma_request_chan_by_mask() to request the DMA channel

Philipp Zabel (1):
      [media] uvcvideo: add support for Oculus Rift Sensor

Ricardo Ribalda Delgado (14):
      [media] videodev2.h Add HSV formats
      [media] Documentation: Add HSV format
      [media] Documentation: Add Ricardo Ribalda
      [media] vivid: Code refactor for color encoding
      [media] vivid: Add support for HSV formats
      [media] vivid: Rename variable
      [media] vivid: Introduce TPG_COLOR_ENC_LUMA
      [media] vivid: Fix YUV555 and YUV565 handling
      [media] vivid: Local optimization
      [media] videodev2.h Add HSV encoding
      [media] Documentation: Add HSV encodings
      [media] vivid: Add support for HSV encoding
      [media] v4l2-tpg: Init hv_enc field with a valid value
      [media] vivid: Set color_enc on HSV formats

Robert Jarzmik (1):
      [media] media: platform: pxa_camera: add missing sensor power on

Ruqiang Ju (1):
      [media] ir-hix5hd2: make hisilicon,power-syscon property deprecated

Saatvik Arya (1):
      [media] staging: media: davinci_vpfe: dm365_resizer: Fix some spelling mistakes

Sakari Ailus (30):
      [media] smiapp: Move sub-device initialisation into a separate function
      [media] smiapp: Explicitly define number of pads in initialisation
      [media] smiapp: Initialise media entity after sensor init
      [media] smiapp: Split off sub-device registration into two
      [media] smiapp: Provide a common function to obtain native pixel array size
      [media] smiapp: Remove unnecessary BUG_ON()'s
      [media] smiapp: Always initialise the sensor in probe
      [media] smiapp: Fix resource management in registration failure
      [media] smiapp: Merge smiapp_init() with smiapp_probe()
      [media] smiapp: Read frame format earlier
      [media] smiapp: Unify setting up sub-devices
      [media] smiapp: Use SMIAPP_PADS when referring to number of pads
      [media] smiapp: Obtain frame layout from the frame descriptor
      [media] smiapp: Improve debug messages from frame layout reading
      [media] smiapp: Remove useless newlines and other small cleanups
      [media] smiapp: Obtain correct media bus code for try format
      [media] smiapp: Drop a debug print on frame size and bit depth
      [media] smiapp-pll: Don't complain aloud about failing PLL calculation
      [media] smiapp: Drop BUG_ON() in suspend path
      [media] smiapp: Set device for pixel array and binner
      [media] smiapp: Set use suspend and resume ops for other functions
      [media] smiapp: Use runtime PM
      [media] smiapp: Implement support for autosuspend
      [media] ad5820: Fix sparse warning
      [media] v4l: flash led class: Fix of_node release in probe() error path
      [media] v4l: Document that m2m devices have a file handle specific context
      [media] doc-rst: v4l: Add documentation on CSI-2 bus configuration
      [media] v4l: compat: Prevent allocating excessive amounts of memory
      [media] v4l: Add 16-bit raw bayer pixel formats
      [media] doc-rst: Specify raw bayer format variant used in the examples

Sean Young (16):
      [media] winbond-cir: use name without space for pnp driver
      [media] redrat3: don't include vendor/product id in name
      [media] redrat3: remove dead code and pointless messages
      [media] redrat3: fix error paths in probe
      [media] redrat3: enable carrier reports using wideband receiver
      [media] redrat3: increase set size for lengths to maximum
      [media] lirc: might sleep error in lirc_dev_fop_read
      [media] lirc: prevent use-after free
      [media] lirc: use-after free while reading from device and unplugging
      [media] lirc_serial: port to rc-core
      [media] lirc_serial: use precision ktime rather than guessing
      [media] lirc_serial: move out of staging and rename to serial_ir
      [media] sanyo decoder: address was being truncated
      [media] mceusb: remove useless debug message
      [media] mceusb: remove pointless mce_flush_rx_buffer function
      [media] lirc: fix error paths in lirc_cdev_add()

Shailendra Verma (1):
      [media] staging: lirc: Improvement in code readability

Shuah Khan (4):
      [media] s5p-mfc: Collapse two error message into one
      [media] s5p-mfc: include buffer size in error message
      [media] media: Update documentation for media_entity_notify
      [media] media: remove obsolete Media Device Managed resource interfaces

Songjun Wu (1):
      [media] atmel-isc: start dma in some scenario

Takashi Sakamoto (1):
      [media] firewire: use dev_dbg() instead of printk()

Tiffany Lin (11):
      [media] dt-bindings: Add a binding for Mediatek Video Decoder
      [media] vcodec: mediatek: Add Mediatek V4L2 Video Decoder Driver
      [media] vcodec: mediatek: Add Mediatek H264 Video Decoder Drive
      [media] vcodec: mediatek: Add Mediatek VP8 Video Decoder Driver
      [media] Add documentation for V4L2_PIX_FMT_VP9
      [media] vcodec: mediatek: Add Mediatek VP9 Video Decoder Driver
      [media] vcodec: mediatek: add Maintainers entry for Mediatek MT8173 vcodec drivers
      [media] v4l: add Mediatek compressed video block format
      [media] docs-rst: Add compressed video formats used on MT8173 codec driver
      [media] vcodec: mediatek: Add V4L2_PIX_FMT_MT21C support for v4l2 decoder
      [media] arm64: dts: mediatek: Add Video Decoder for MT8173

Ulf Hansson (7):
      [media] exynos-gsc: Simplify clock management
      [media] exynos-gsc: Convert gsc_m2m_resume() from int to void
      [media] exynos-gsc: Make driver functional when CONFIG_PM is unset
      [media] exynos-gsc: Make PM callbacks available conditionally
      [media] exynos-gsc: Fixup clock management at ->remove()
      [media] exynos-gsc: Do full clock gating at runtime PM suspend
      [media] exynos-gsc: Simplify system PM

Ulrich Hecht (2):
      [media] media: adv7604: fix bindings inconsistency for default-input
      [media] media: adv7604: automatic "default-input" selection

Vincent Stehlé (1):
      [media] media: mtk-mdp: NULL-terminate mtk_mdp_comp_dt_ids

Wayne Porter (1):
      [media] bcm2048: Remove FSF mailing address

Wei Yongjun (9):
      [media] gs1662: remove .owner field for driver
      [media] gs1662: drop kfree for memory allocated with devm_kzalloc
      [media] bdisp: fix error return code in bdisp_probe()
      [media] cx88: fix error return code in cx8802_dvb_probe()
      [media] stih-cec: remove unused including <linux/version.h>
      [media] s5p-cec: remove unused including <linux/version.h>
      [media] dibusb: fix possible memory leak in dibusb_rc_query()
      [media] c8sectpfe: fix error return code in c8sectpfe_probe()
      [media] atmel-isc: fix error return code in atmel_isc_probe()

Wu-Cheng Li (3):
      [media] videodev2.h: add V4L2_PIX_FMT_VP9 format
      [media] v4l2-ioctl: add VP9 format description
      [media] mtk-vcodec: add index check in decoder vidioc_qbuf

Буди Романто, AreMa Inc (1):
      [media] Raise adapter number limit

 .../devicetree/bindings/media/exynos5-gsc.txt      |    3 +-
 .../devicetree/bindings/media/hix5hd2-ir.txt       |    6 +-
 .../devicetree/bindings/media/i2c/adv7604.txt      |    3 +-
 .../devicetree/bindings/media/mediatek-mdp.txt     |  109 +
 .../devicetree/bindings/media/mediatek-vcodec.txt  |   57 +-
 .../devicetree/bindings/media/renesas,fdp1.txt     |   37 +
 .../devicetree/bindings/media/s5p-mfc.txt          |    1 +
 Documentation/media/Makefile                       |    2 +-
 Documentation/media/kapi/cec-core.rst              |   38 +-
 Documentation/media/kapi/csi2.rst                  |   61 +
 Documentation/media/kapi/dtv-core.rst              |    8 -
 Documentation/media/media_kapi.rst                 |    1 +
 Documentation/media/typical_media_device.svg       | 2974 +++++++++++++++++++-
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |  156 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |  488 ++--
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  182 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |  317 +--
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |  418 ++-
 Documentation/media/uapi/v4l/control.rst           |   88 +-
 Documentation/media/uapi/v4l/dev-codec.rst         |    2 +-
 Documentation/media/uapi/v4l/extended-controls.rst |    6 +-
 Documentation/media/uapi/v4l/hsv-formats.rst       |   19 +
 Documentation/media/uapi/v4l/pixfmt-002.rst        |    5 +
 Documentation/media/uapi/v4l/pixfmt-003.rst        |    5 +
 Documentation/media/uapi/v4l/pixfmt-006.rst        |   31 +-
 Documentation/media/uapi/v4l/pixfmt-013.rst        |    5 +
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst |  157 ++
 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |   10 +-
 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    2 +-
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst   |    2 +-
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst    |    2 +-
 .../v4l/{pixfmt-sbggr16.rst => pixfmt-srggb16.rst} |   25 +-
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst     |    2 +-
 Documentation/media/uapi/v4l/pixfmt.rst            |    1 +
 .../uapi/v4l/subdev-image-processing-crop.svg      |  299 +-
 .../uapi/v4l/subdev-image-processing-full.svg      |  779 +++--
 ...ubdev-image-processing-scaling-multi-source.svg |  566 ++--
 Documentation/media/uapi/v4l/v4l2.rst              |    9 +
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |   11 +
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |    4 +-
 .../media/v4l-drivers/au0828-cardlist.rst          |   18 +-
 Documentation/media/v4l-drivers/bttv-cardlist.rst  |  340 +--
 .../media/v4l-drivers/cx23885-cardlist.rst         |  122 +-
 Documentation/media/v4l-drivers/cx88-cardlist.rst  |  188 +-
 .../media/v4l-drivers/em28xx-cardlist.rst          |  206 +-
 Documentation/media/v4l-drivers/gspca-cardlist.rst |  843 +++---
 Documentation/media/v4l-drivers/index.rst          |    3 +
 Documentation/media/v4l-drivers/ivtv-cardlist.rst  |   61 +-
 Documentation/media/v4l-drivers/rcar-fdp1.rst      |   37 +
 .../media/v4l-drivers/saa7134-cardlist.rst         |  400 +--
 .../media/v4l-drivers/saa7164-cardlist.rst         |   36 +-
 .../media/v4l-drivers/tm6000-cardlist.rst          |   39 +-
 Documentation/media/v4l-drivers/tuner-cardlist.rst |  188 +-
 .../media/v4l-drivers/usbvision-cardlist.rst       |  142 +-
 Documentation/media/videodev2.h.rst.exceptions     |    7 +
 MAINTAINERS                                        |   43 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |  128 +
 drivers/media/Kconfig                              |   18 +-
 drivers/media/Makefile                             |    4 +
 drivers/{staging => }/media/cec/Makefile           |    2 +-
 drivers/{staging => }/media/cec/cec-adap.c         |  244 +-
 drivers/{staging => }/media/cec/cec-api.c          |   13 +-
 drivers/{staging => }/media/cec/cec-core.c         |   18 +-
 drivers/{staging => }/media/cec/cec-priv.h         |    0
 drivers/media/common/b2c2/flexcop-common.h         |    1 -
 drivers/media/common/b2c2/flexcop-eeprom.c         |    3 +-
 drivers/media/common/b2c2/flexcop-i2c.c            |   14 +-
 drivers/media/common/b2c2/flexcop-misc.c           |    9 +-
 drivers/media/common/b2c2/flexcop.c                |    3 +-
 drivers/media/common/cx2341x.c                     |   12 +-
 drivers/media/common/saa7146/saa7146_video.c       |    4 +
 drivers/media/common/siano/smsdvb-main.c           |    2 +-
 drivers/media/common/tveeprom.c                    |   77 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |  412 ++-
 drivers/media/dvb-core/Kconfig                     |   17 +-
 drivers/media/dvb-core/Makefile                    |    2 +-
 drivers/media/dvb-core/demux.h                     |    5 +-
 drivers/media/dvb-core/dmxdev.c                    |   28 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |    2 +
 drivers/media/dvb-core/dvb_ca_en50221.c            |   60 +-
 drivers/media/dvb-core/dvb_demux.c                 |  115 +-
 drivers/media/dvb-core/dvb_demux.h                 |    2 -
 drivers/media/dvb-core/dvb_filter.c                |  603 ----
 drivers/media/dvb-core/dvb_frontend.c              |  107 +-
 drivers/media/dvb-core/dvb_frontend.h              |   10 +-
 drivers/media/dvb-core/dvb_net.c                   |  952 ++++---
 drivers/media/dvb-core/dvbdev.c                    |   44 +-
 drivers/media/dvb-core/dvbdev.h                    |   25 +-
 drivers/media/dvb-frontends/Kconfig                |    9 +-
 drivers/media/dvb-frontends/af9013.c               |    4 +-
 drivers/media/dvb-frontends/af9033.c               |    2 +-
 drivers/media/dvb-frontends/as102_fe.c             |    2 +-
 drivers/media/dvb-frontends/ascot2e.c              |    3 +-
 drivers/media/dvb-frontends/atbm8830.c             |    2 +-
 drivers/media/dvb-frontends/au8522_common.c        |    4 +-
 drivers/media/dvb-frontends/au8522_dig.c           |    4 +-
 drivers/media/dvb-frontends/bcm3510.c              |    4 +-
 drivers/media/dvb-frontends/cx22700.c              |    4 +-
 drivers/media/dvb-frontends/cx24110.c              |    8 +-
 drivers/media/dvb-frontends/cx24113.c              |    7 +-
 drivers/media/dvb-frontends/cx24116.c              |   12 +-
 drivers/media/dvb-frontends/cx24117.c              |    8 +-
 drivers/media/dvb-frontends/cx24120.c              |    7 +-
 drivers/media/dvb-frontends/cx24123.c              |    8 +-
 drivers/media/dvb-frontends/cxd2841er.c            |    6 +-
 drivers/media/dvb-frontends/dib0070.c              |   53 +-
 drivers/media/dvb-frontends/dib0090.c              |  165 +-
 drivers/media/dvb-frontends/dib3000mb.c            |  141 +-
 drivers/media/dvb-frontends/dib3000mb_priv.h       |   16 +-
 drivers/media/dvb-frontends/dib3000mc.c            |   12 +-
 drivers/media/dvb-frontends/dib7000m.c             |   77 +-
 drivers/media/dvb-frontends/dib7000p.c             |  131 +-
 drivers/media/dvb-frontends/dib8000.c              |  261 +-
 drivers/media/dvb-frontends/dib9000.c              |  175 +-
 drivers/media/dvb-frontends/dibx000_common.c       |   46 +-
 drivers/media/dvb-frontends/dibx000_common.h       |    2 -
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |    4 +-
 drivers/media/dvb-frontends/drxd_hard.c            |    2 +-
 drivers/media/dvb-frontends/drxk_hard.c            |    2 +-
 drivers/media/dvb-frontends/ds3000.c               |   19 +-
 drivers/media/dvb-frontends/dvb-pll.c              |   22 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.c         |   12 +-
 drivers/media/dvb-frontends/ec100.c                |    4 +-
 drivers/media/dvb-frontends/gp8psk-fe.c            |    4 +-
 drivers/media/dvb-frontends/hd29l2.c               |    4 +-
 drivers/media/dvb-frontends/helene.c               |    3 +-
 drivers/media/dvb-frontends/horus3a.c              |    3 +-
 drivers/media/dvb-frontends/itd1000.c              |    3 +-
 drivers/media/dvb-frontends/ix2505v.c              |    3 +-
 drivers/media/dvb-frontends/l64781.c               |    4 +-
 drivers/media/dvb-frontends/lg2160.c               |    4 +-
 drivers/media/dvb-frontends/lgdt3305.c             |    8 +-
 drivers/media/dvb-frontends/lgdt3306a.c            |    4 +-
 drivers/media/dvb-frontends/lgdt330x.c             |   11 +-
 drivers/media/dvb-frontends/lgs8gl5.c              |    4 +-
 drivers/media/dvb-frontends/lgs8gxx.c              |    2 +-
 drivers/media/dvb-frontends/m88ds3103.c            |    4 +-
 drivers/media/dvb-frontends/m88rs2000.c            |   13 +-
 drivers/media/dvb-frontends/mb86a16.c              |    2 +-
 drivers/media/dvb-frontends/mb86a20s.c             |    5 +-
 drivers/media/dvb-frontends/mn88472.c              |   26 +-
 drivers/media/dvb-frontends/mn88473.c              |  225 +-
 drivers/media/dvb-frontends/mn88473_priv.h         |    2 +
 drivers/media/dvb-frontends/mt312.c                |    9 +-
 drivers/media/dvb-frontends/mt352.c                |    4 +-
 drivers/media/dvb-frontends/nxt200x.c              |   15 +-
 drivers/media/dvb-frontends/nxt6000.c              |  140 +-
 drivers/media/dvb-frontends/or51132.c              |   10 +-
 drivers/media/dvb-frontends/or51211.c              |    7 +-
 drivers/media/dvb-frontends/rtl2830.c              |    2 +-
 drivers/media/dvb-frontends/rtl2832.c              |    2 +-
 drivers/media/dvb-frontends/s5h1409.c              |    8 +-
 drivers/media/dvb-frontends/s5h1411.c              |    8 +-
 drivers/media/dvb-frontends/s5h1420.c              |    4 +-
 drivers/media/dvb-frontends/s5h1432.c              |    8 +-
 drivers/media/dvb-frontends/s921.c                 |    8 +-
 drivers/media/dvb-frontends/si2165.c               |    2 +-
 drivers/media/dvb-frontends/si21xx.c               |   10 +-
 drivers/media/dvb-frontends/sp8870.c               |    4 +-
 drivers/media/dvb-frontends/sp887x.c               |    7 +-
 drivers/media/dvb-frontends/stb0899_drv.c          |   34 +-
 drivers/media/dvb-frontends/stb6000.c              |    3 +-
 drivers/media/dvb-frontends/stb6100.c              |    6 +-
 drivers/media/dvb-frontends/stv0288.c              |   13 +-
 drivers/media/dvb-frontends/stv0297.c              |    8 +-
 drivers/media/dvb-frontends/stv0299.c              |   11 +-
 drivers/media/dvb-frontends/stv0367.c              |    4 +-
 drivers/media/dvb-frontends/stv0900_core.c         |    2 +-
 drivers/media/dvb-frontends/stv0900_sw.c           |    3 +-
 drivers/media/dvb-frontends/stv090x.c              |   28 +-
 drivers/media/dvb-frontends/stv6110.c              |    3 +-
 drivers/media/dvb-frontends/stv6110x.c             |    4 +-
 drivers/media/dvb-frontends/tc90522.c              |    7 +-
 drivers/media/dvb-frontends/tda10021.c             |    7 +-
 drivers/media/dvb-frontends/tda10023.c             |   10 +-
 drivers/media/dvb-frontends/tda10048.c             |   16 +-
 drivers/media/dvb-frontends/tda1004x.c             |    4 +-
 drivers/media/dvb-frontends/tda10071.c             |    4 +-
 drivers/media/dvb-frontends/tda10086.c             |    2 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |    3 +-
 drivers/media/dvb-frontends/tda665x.c              |    3 +-
 drivers/media/dvb-frontends/tda8083.c              |    4 +-
 drivers/media/dvb-frontends/tda8261.c              |    3 +-
 drivers/media/dvb-frontends/tda826x.c              |    3 +-
 drivers/media/dvb-frontends/ts2020.c               |    3 +-
 drivers/media/dvb-frontends/tua6100.c              |    3 +-
 drivers/media/dvb-frontends/ves1820.c              |   12 +-
 drivers/media/dvb-frontends/ves1x93.c              |    4 +-
 drivers/media/dvb-frontends/zl10036.c              |    8 +-
 drivers/media/dvb-frontends/zl10039.c              |    6 +-
 drivers/media/dvb-frontends/zl10353.c              |    4 +-
 drivers/media/firewire/firedtv-avc.c               |    4 +-
 drivers/media/firewire/firedtv-rc.c                |    5 +-
 drivers/media/i2c/Kconfig                          |    6 +-
 drivers/media/i2c/ad5820.c                         |    5 +-
 drivers/media/i2c/adv7511.c                        |    5 +-
 drivers/media/i2c/adv7604.c                        |   30 +-
 drivers/media/i2c/adv7842.c                        |    6 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   11 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |    7 +-
 drivers/media/i2c/msp3400-driver.c                 |   90 +-
 drivers/media/i2c/msp3400-kthreads.c               |  115 +-
 drivers/media/i2c/smiapp-pll.c                     |    3 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  946 ++++---
 drivers/media/i2c/smiapp/smiapp-regs.c             |    4 +-
 drivers/media/i2c/smiapp/smiapp.h                  |   28 +-
 drivers/media/i2c/soc_camera/ov772x.c              |    3 +-
 drivers/media/i2c/soc_camera/ov9740.c              |    3 +-
 drivers/media/i2c/soc_camera/tw9910.c              |    3 +-
 drivers/media/i2c/tvaudio.c                        |    5 +-
 drivers/media/i2c/tvp514x.c                        |    6 +-
 drivers/media/i2c/tvp5150.c                        |  298 +-
 drivers/media/media-device.c                       |   32 +-
 drivers/media/media-entity.c                       |    6 +
 drivers/media/pci/b2c2/flexcop-dma.c               |    6 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |    7 +-
 drivers/media/pci/bt8xx/btcx-risc.c                |   46 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |    9 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |    6 +-
 drivers/media/pci/bt8xx/bttv-i2c.c                 |    6 +-
 drivers/media/pci/bt8xx/bttv-input.c               |    4 +-
 drivers/media/pci/bt8xx/dst.c                      |  278 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c                |   25 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |   23 +-
 drivers/media/pci/cx18/cx18-alsa-main.c            |    8 +-
 drivers/media/pci/cx18/cx18-av-core.c              |   17 +-
 drivers/media/pci/cx18/cx18-av-firmware.c          |    3 +-
 drivers/media/pci/cx18/cx18-controls.c             |    9 +-
 drivers/media/pci/cx18/cx18-driver.c               |   35 +-
 drivers/media/pci/cx18/cx18-dvb.c                  |    6 +-
 drivers/media/pci/cx18/cx18-fileops.c              |    6 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |    6 +-
 drivers/media/pci/cx18/cx18-irq.c                  |    4 +-
 drivers/media/pci/cx18/cx18-mailbox.c              |   39 +-
 drivers/media/pci/cx18/cx18-queue.c                |    8 +-
 drivers/media/pci/cx18/cx18-streams.c              |    7 +-
 drivers/media/pci/cx23885/altera-ci.c              |   15 +-
 drivers/media/pci/cx23885/altera-ci.h              |   14 +-
 drivers/media/pci/cx23885/cimax2.c                 |   15 +-
 drivers/media/pci/cx23885/cx23885-417.c            |   65 +-
 drivers/media/pci/cx23885/cx23885-alsa.c           |   30 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |   53 +-
 drivers/media/pci/cx23885/cx23885-core.c           |  146 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   41 +-
 drivers/media/pci/cx23885/cx23885-f300.c           |    2 +-
 drivers/media/pci/cx23885/cx23885-i2c.c            |   27 +-
 drivers/media/pci/cx23885/cx23885-input.c          |    6 +-
 drivers/media/pci/cx23885/cx23885-ir.c             |    4 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |    7 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   26 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +
 drivers/media/pci/cx23885/cx23888-ir.c             |   13 +-
 drivers/media/pci/cx23885/netup-eeprom.c           |    4 +-
 drivers/media/pci/cx23885/netup-init.c             |    8 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |  304 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |  292 +-
 drivers/media/pci/cx88/cx88-cards.c                |  485 ++--
 drivers/media/pci/cx88/cx88-core.c                 |  420 +--
 drivers/media/pci/cx88/cx88-dsp.c                  |  136 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |  331 ++-
 drivers/media/pci/cx88/cx88-i2c.c                  |  136 +-
 drivers/media/pci/cx88/cx88-input.c                |   60 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |  315 +--
 drivers/media/pci/cx88/cx88-reg.h                  |  123 +-
 drivers/media/pci/cx88/cx88-tvaudio.c              |  169 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |   47 +-
 drivers/media/pci/cx88/cx88-video.c                |  403 +--
 drivers/media/pci/cx88/cx88-vp3054-i2c.c           |   60 +-
 drivers/media/pci/cx88/cx88-vp3054-i2c.h           |   38 +-
 drivers/media/pci/cx88/cx88.h                      |  203 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |    6 +-
 drivers/media/pci/dm1105/dm1105.c                  |    3 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |   12 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |   37 +-
 drivers/media/pci/ivtv/ivtv-firmware.c             |    4 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |    8 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |    3 +-
 drivers/media/pci/meye/meye.c                      |   17 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |   13 +-
 drivers/media/pci/pluto2/pluto2.c                  |    4 +-
 drivers/media/pci/pt1/pt1.c                        |    7 +-
 drivers/media/pci/pt1/va1j5jf8007s.c               |    2 +-
 drivers/media/pci/pt1/va1j5jf8007t.c               |    2 +-
 drivers/media/pci/saa7134/saa7134-alsa.c           |    3 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |    8 +-
 drivers/media/pci/saa7134/saa7134-core.c           |   39 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |   32 +-
 drivers/media/pci/saa7134/saa7134-i2c.c            |   31 +
 drivers/media/pci/saa7134/saa7134-input.c          |   13 +-
 drivers/media/pci/saa7164/saa7164-buffer.c         |    3 +-
 drivers/media/pci/saa7164/saa7164-bus.c            |    4 +-
 drivers/media/pci/saa7164/saa7164-cards.c          |    4 +-
 drivers/media/pci/saa7164/saa7164-cmd.c            |   12 +-
 drivers/media/pci/saa7164/saa7164-core.c           |   66 +-
 drivers/media/pci/saa7164/saa7164-dvb.c            |   34 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        |   18 +-
 drivers/media/pci/saa7164/saa7164-fw.c             |   10 +-
 drivers/media/pci/saa7164/saa7164-vbi.c            |   14 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |    4 +-
 drivers/media/pci/solo6x10/solo6x10.h              |    3 +
 drivers/media/pci/ttpci/Makefile                   |    2 +-
 drivers/media/pci/ttpci/av7110.c                   |   49 +-
 drivers/media/pci/ttpci/av7110.h                   |    7 +-
 drivers/media/pci/ttpci/av7110_hw.c                |   12 +-
 drivers/media/pci/ttpci/budget-av.c                |    3 +-
 drivers/media/pci/ttpci/budget-ci.c                |    4 +-
 drivers/media/pci/ttpci/budget-patch.c             |    3 +-
 drivers/media/pci/ttpci/budget.c                   |    3 +-
 drivers/media/pci/ttpci/budget.h                   |    8 +-
 drivers/media/pci/ttpci/dvb_filter.c               |  114 +
 drivers/media/{dvb-core => pci/ttpci}/dvb_filter.h |    0
 drivers/media/pci/ttpci/ttpci-eeprom.c             |    3 +-
 drivers/media/pci/tw5864/tw5864-reg.h              |    8 +
 drivers/media/pci/tw5864/tw5864-video.c            |   13 +-
 drivers/media/pci/tw68/tw68-video.c                |   16 +-
 drivers/media/pci/zoran/zoran_device.c             |   35 +-
 drivers/media/pci/zoran/zoran_driver.c             |    2 +-
 drivers/media/platform/Kconfig                     |   49 +-
 drivers/media/platform/Makefile                    |    3 +
 drivers/media/platform/atmel/atmel-isc.c           |    9 +-
 drivers/media/platform/blackfin/bfin_capture.c     |    6 +-
 drivers/media/platform/blackfin/ppi.c              |    2 +
 drivers/media/platform/coda/coda-common.c          |    7 +-
 drivers/media/platform/coda/coda-h264.c            |    1 +
 drivers/media/platform/davinci/dm355_ccdc.c        |    4 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |    4 +-
 drivers/media/platform/davinci/vpbe.c              |   82 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   91 +-
 drivers/media/platform/davinci/vpif_capture.c      |   37 +-
 drivers/media/platform/davinci/vpif_display.c      |   39 +-
 drivers/media/platform/davinci/vpss.c              |    7 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |  279 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |   11 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   38 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |   14 +-
 drivers/media/platform/exynos4-is/media-dev.c      |    3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   26 +-
 drivers/media/platform/mtk-mdp/Makefile            |    9 +
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c      |  159 ++
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.h      |   72 +
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c      |  290 ++
 drivers/media/platform/mtk-mdp/mtk_mdp_core.h      |  260 ++
 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h       |  126 +
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       | 1286 +++++++++
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h       |   22 +
 drivers/media/platform/mtk-mdp/mtk_mdp_regs.c      |  156 +
 drivers/media/platform/mtk-mdp/mtk_mdp_regs.h      |   31 +
 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c       |  145 +
 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h       |   41 +
 drivers/media/platform/mtk-vcodec/Makefile         |   15 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 1451 ++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h |   88 +
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |  394 +++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  |  202 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h  |   28 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |   62 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |    8 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |    3 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |   33 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |    5 +
 .../media/platform/mtk-vcodec/vdec/vdec_h264_if.c  |  507 ++++
 .../media/platform/mtk-vcodec/vdec/vdec_vp8_if.c   |  634 +++++
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   |  967 +++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_base.h  |   56 +
 drivers/media/platform/mtk-vcodec/vdec_drv_if.c    |  122 +
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |  101 +
 drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h   |  103 +
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c    |  170 ++
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h    |   96 +
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |   21 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.h           |   48 +-
 drivers/media/platform/mx2_emmaprp.c               |   10 +-
 drivers/media/platform/omap/omap_vout.c            |   24 +-
 drivers/media/platform/omap/omap_vout_vrfb.c       |    5 +-
 drivers/media/platform/omap3isp/isp.c              |   23 +-
 drivers/media/platform/omap3isp/ispccdc.c          |    9 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |   13 +-
 drivers/media/platform/omap3isp/ispcsiphy.c        |    4 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c      |    8 +-
 drivers/media/platform/omap3isp/isph3a_af.c        |    8 +-
 drivers/media/platform/omap3isp/isphist.c          |   28 +-
 drivers/media/platform/omap3isp/ispstat.c          |   58 +-
 drivers/media/platform/pxa_camera.c                |   18 +-
 drivers/media/platform/rcar-fcp.c                  |    1 +
 drivers/media/platform/rcar_fdp1.c                 | 2445 ++++++++++++++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c  |   17 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |    3 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |    2 +-
 drivers/media/platform/s5p-mfc/regs-mfc.h          |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   73 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h     |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   15 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    7 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |  132 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |    1 +
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |   24 +-
 drivers/media/platform/sti/hva/hva-hw.c            |    8 +-
 drivers/media/platform/ti-vpe/Makefile             |   10 +-
 drivers/media/platform/ti-vpe/cal.c                |   14 +-
 drivers/media/platform/ti-vpe/csc.c                |   18 +-
 drivers/media/platform/ti-vpe/csc.h                |    2 +-
 drivers/media/platform/ti-vpe/sc.c                 |   28 +-
 drivers/media/platform/ti-vpe/sc.h                 |   11 +-
 drivers/media/platform/ti-vpe/vpdma.c              |  355 ++-
 drivers/media/platform/ti-vpe/vpdma.h              |   85 +-
 drivers/media/platform/ti-vpe/vpdma_priv.h         |  130 +-
 drivers/media/platform/ti-vpe/vpe.c                |  471 +++-
 drivers/media/platform/via-camera.c                |    7 +-
 drivers/media/platform/vivid/Kconfig               |    2 +-
 drivers/media/platform/vivid/vivid-cec.c           |    3 +-
 drivers/media/platform/vivid/vivid-cec.h           |    1 -
 drivers/media/platform/vivid/vivid-core.c          |   13 +-
 drivers/media/platform/vivid/vivid-core.h          |    3 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |   25 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |   17 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |   70 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |    1 +
 drivers/media/platform/vsp1/vsp1_drv.c             |    1 +
 drivers/media/platform/vsp1/vsp1_pipe.c            |    8 +
 drivers/media/platform/vsp1/vsp1_rwpf.c            |    2 +
 drivers/media/platform/vsp1/vsp1_video.c           |    5 +
 drivers/media/radio/radio-gemtek.c                 |    8 +-
 drivers/media/radio/radio-wl1273.c                 |    3 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |    7 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |   15 +-
 drivers/media/radio/si4713/si4713.c                |   13 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   46 +-
 drivers/media/radio/wl128x/fmdrv_rx.c              |    8 +-
 drivers/media/rc/Kconfig                           |   17 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/ati_remote.c                      |    3 +-
 drivers/media/rc/ene_ir.c                          |    3 +-
 drivers/media/rc/fintek-cir.c                      |    6 +-
 drivers/media/rc/imon.c                            |   61 +-
 drivers/media/rc/ir-hix5hd2.c                      |   25 +-
 drivers/media/rc/ir-sanyo-decoder.c                |    3 +-
 drivers/media/rc/ite-cir.c                         |   11 +-
 drivers/media/rc/lirc_dev.c                        |   29 +-
 drivers/media/rc/mceusb.c                          |  102 +-
 drivers/media/rc/meson-ir.c                        |    1 +
 drivers/media/rc/nuvoton-cir.c                     |  143 +-
 drivers/media/rc/nuvoton-cir.h                     |    4 +-
 drivers/media/rc/rc-ir-raw.c                       |   17 +-
 drivers/media/rc/rc-main.c                         |   70 +-
 drivers/media/rc/redrat3.c                         |  327 ++-
 drivers/media/rc/serial_ir.c                       |  844 ++++++
 drivers/media/rc/streamzap.c                       |   11 +-
 drivers/media/rc/winbond-cir.c                     |   13 +-
 drivers/media/spi/gs1662.c                         |    4 +-
 drivers/media/tuners/fc0011.c                      |   11 +-
 drivers/media/tuners/fc0012.c                      |    3 +-
 drivers/media/tuners/fc0013.c                      |    3 +-
 drivers/media/tuners/max2165.c                     |    4 +-
 drivers/media/tuners/mc44s803.c                    |    8 +-
 drivers/media/tuners/mt2060.c                      |    3 +-
 drivers/media/tuners/mt2063.c                      |    4 +-
 drivers/media/tuners/mt20xx.c                      |   25 +-
 drivers/media/tuners/mt2131.c                      |    3 +-
 drivers/media/tuners/mt2266.c                      |    3 +-
 drivers/media/tuners/mxl5005s.c                    |    3 +-
 drivers/media/tuners/mxl5007t.c                    |    4 +-
 drivers/media/tuners/qt1010.c                      |    3 +-
 drivers/media/tuners/r820t.c                       |    4 +-
 drivers/media/tuners/tda18218.c                    |    3 +-
 drivers/media/tuners/tda18271-common.c             |    4 +-
 drivers/media/tuners/tda18271-fe.c                 |    7 +-
 drivers/media/tuners/tda18271-maps.c               |    6 +-
 drivers/media/tuners/tda827x.c                     |    3 +-
 drivers/media/tuners/tda8290.c                     |    8 +-
 drivers/media/tuners/tda9887.c                     |    2 +-
 drivers/media/tuners/tea5761.c                     |   10 +-
 drivers/media/tuners/tea5767.c                     |    4 +-
 drivers/media/tuners/tuner-simple.c                |   49 +-
 drivers/media/tuners/tuner-xc2028.c                |  120 +-
 drivers/media/tuners/xc4000.c                      |   29 +-
 drivers/media/tuners/xc5000.c                      |    4 +-
 drivers/media/usb/Kconfig                          |    5 +
 drivers/media/usb/Makefile                         |    1 +
 drivers/media/usb/au0828/au0828-video.c            |    3 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   11 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |    4 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |   10 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |    4 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |    2 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |    4 +
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   14 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c      |    2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c        |   12 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c      |    3 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |   10 +-
 drivers/media/usb/dvb-usb/af9005-fe.c              |    4 +-
 drivers/media/usb/dvb-usb/af9005.c                 |    1 -
 drivers/media/usb/dvb-usb/cinergyT2-core.c         |    6 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c           |    4 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |   26 +
 drivers/media/usb/dvb-usb/cxusb.h                  |    5 +
 drivers/media/usb/dvb-usb/dib0700_core.c           |    5 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |    3 +-
 drivers/media/usb/dvb-usb/dibusb-common.c          |    2 +-
 drivers/media/usb/dvb-usb/dibusb-mc-common.c       |    1 -
 drivers/media/usb/dvb-usb/dtt200u-fe.c             |    4 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c            |    3 +-
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c       |    6 +-
 drivers/media/usb/dvb-usb/dvb-usb.h                |    6 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |   12 +-
 drivers/media/usb/dvb-usb/friio-fe.c               |    4 +-
 drivers/media/usb/dvb-usb/friio.c                  |    4 +-
 drivers/media/usb/dvb-usb/gp8psk.c                 |    3 +-
 drivers/media/usb/dvb-usb/m920x.c                  |   10 +-
 drivers/media/usb/dvb-usb/opera1.c                 |    3 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |    3 +-
 drivers/media/usb/dvb-usb/vp702x-fe.c              |    4 +-
 drivers/media/usb/dvb-usb/vp7045-fe.c              |    4 +-
 drivers/media/usb/em28xx/Kconfig                   |    2 +-
 drivers/media/usb/em28xx/em28xx-audio.c            |   95 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |   69 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |  204 +-
 drivers/media/usb/em28xx/em28xx-core.c             |  206 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |  112 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |  291 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   65 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    9 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  163 +-
 drivers/media/usb/em28xx/em28xx.h                  |   19 +-
 drivers/media/usb/go7007/Kconfig                   |    2 +-
 drivers/media/usb/gspca/gspca.c                    |    3 +-
 drivers/media/usb/gspca/jl2005bcd.c                |    5 +-
 drivers/media/usb/gspca/m5602/m5602_core.c         |   11 +-
 drivers/media/usb/gspca/mr97310a.c                 |    3 +-
 drivers/media/usb/gspca/ov519.c                    |    3 +-
 drivers/media/usb/gspca/pac207.c                   |    4 +-
 drivers/media/usb/gspca/pac7302.c                  |    3 +-
 drivers/media/usb/gspca/sn9c20x.c                  |    6 +-
 drivers/media/usb/gspca/spca506.c                  |    3 +-
 drivers/media/usb/gspca/sq905.c                    |    3 +-
 drivers/media/usb/gspca/sq905c.c                   |    9 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |   27 +-
 drivers/media/usb/gspca/sunplus.c                  |    3 +-
 drivers/media/usb/gspca/topro.c                    |    3 +-
 drivers/media/usb/gspca/zc3xx.c                    |    3 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |    9 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |    7 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   26 +-
 .../media => media/usb}/pulse8-cec/Kconfig         |    2 +-
 .../media => media/usb}/pulse8-cec/Makefile        |    0
 .../media => media/usb}/pulse8-cec/pulse8-cec.c    |   12 +-
 drivers/media/usb/pvrusb2/pvrusb2-audio.c          |    4 +-
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c       |    4 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c    |    4 +-
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.c       |    4 +-
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c         |    7 +-
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c        |   29 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |  181 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |   47 +-
 drivers/media/usb/pvrusb2/pvrusb2-io.c             |   35 +-
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c         |   36 +-
 drivers/media/usb/pvrusb2/pvrusb2-std.c            |    3 +-
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c          |    1 -
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   10 +-
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c      |    4 +-
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.c         |    3 +-
 drivers/media/usb/pwc/pwc-if.c                     |    4 +-
 drivers/media/usb/pwc/pwc-v4l.c                    |    6 +-
 drivers/media/usb/siano/smsusb.c                   |    4 +-
 drivers/media/usb/stkwebcam/stk-sensor.c           |   10 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   14 +-
 drivers/media/usb/stkwebcam/stk-webcam.h           |    2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c             |    4 +-
 drivers/media/usb/tm6000/tm6000-core.c             |   14 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |   16 +-
 drivers/media/usb/tm6000/tm6000-i2c.c              |    3 +-
 drivers/media/usb/tm6000/tm6000-stds.c             |    3 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   18 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |    3 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |   92 +-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           |    8 +-
 drivers/media/usb/usbtv/usbtv-video.c              |  105 +-
 drivers/media/usb/usbtv/usbtv.h                    |    3 +
 drivers/media/usb/usbvision/usbvision-core.c       |   20 +-
 drivers/media/usb/usbvision/usbvision-video.c      |    4 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  177 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   19 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   12 +
 drivers/media/usb/zr364xx/zr364xx.c                |    6 +-
 drivers/media/v4l2-core/Kconfig                    |    1 +
 drivers/media/v4l2-core/tuner-core.c               |  121 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   30 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |    2 +
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   59 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |   16 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  103 +-
 drivers/media/v4l2-core/videobuf-core.c            |    3 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   25 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   10 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |    3 +-
 drivers/staging/media/Kconfig                      |    4 -
 drivers/staging/media/Makefile                     |    2 -
 drivers/staging/media/bcm2048/radio-bcm2048.c      |   66 +-
 drivers/staging/media/bcm2048/radio-bcm2048.h      |    5 -
 drivers/staging/media/cec/Kconfig                  |   12 -
 drivers/staging/media/cec/TODO                     |   32 -
 drivers/staging/media/davinci_vpfe/Makefile        |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   31 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.h |    2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    8 +-
 drivers/staging/media/lirc/Kconfig                 |   13 -
 drivers/staging/media/lirc/Makefile                |    1 -
 drivers/staging/media/lirc/lirc_imon.c             |   11 +-
 drivers/staging/media/lirc/lirc_sasem.c            |    5 +-
 drivers/staging/media/lirc/lirc_serial.c           | 1130 --------
 drivers/staging/media/pulse8-cec/TODO              |   52 -
 drivers/staging/media/s5p-cec/Kconfig              |    2 +-
 drivers/staging/media/s5p-cec/TODO                 |   12 +-
 drivers/staging/media/s5p-cec/s5p_cec.c            |   11 +-
 drivers/staging/media/st-cec/Kconfig               |    2 +-
 drivers/staging/media/st-cec/TODO                  |    7 +
 drivers/staging/media/st-cec/stih-cec.c            |   11 +-
 include/media/cec.h                                |   12 +-
 include/media/media-device.h                       |   38 +-
 include/media/rc-core.h                            |   18 +
 include/media/v4l2-common.h                        |    7 +
 include/media/v4l2-dv-timings.h                    |   20 +-
 include/media/v4l2-mem2mem.h                       |    3 +
 include/media/v4l2-tpg.h                           |   24 +-
 include/uapi/linux/Kbuild                          |    2 +
 include/{ => uapi}/linux/cec-funcs.h               |   76 +-
 include/{ => uapi}/linux/cec.h                     |   94 +-
 include/uapi/linux/v4l2-controls.h                 |    1 +
 include/uapi/linux/v4l2-dv-timings.h               |   97 +-
 include/uapi/linux/videodev2.h                     |  118 +-
 633 files changed, 27631 insertions(+), 13401 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fdp1.txt
 create mode 100644 Documentation/media/kapi/csi2.rst
 create mode 100644 Documentation/media/uapi/v4l/hsv-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
 rename Documentation/media/uapi/v4l/{pixfmt-sbggr16.rst => pixfmt-srggb16.rst} (52%)
 create mode 100644 Documentation/media/v4l-drivers/rcar-fdp1.rst
 rename drivers/{staging => }/media/cec/Makefile (70%)
 rename drivers/{staging => }/media/cec/cec-adap.c (84%)
 rename drivers/{staging => }/media/cec/cec-api.c (97%)
 rename drivers/{staging => }/media/cec/cec-core.c (98%)
 rename drivers/{staging => }/media/cec/cec-priv.h (100%)
 delete mode 100644 drivers/media/dvb-core/dvb_filter.c
 create mode 100644 drivers/media/pci/ttpci/dvb_filter.c
 rename drivers/media/{dvb-core => pci/ttpci}/dvb_filter.h (100%)
 create mode 100644 drivers/media/platform/mtk-mdp/Makefile
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.h
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.c
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.h
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.h
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
 create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_base.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_drv_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_ipi_msg.h
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h
 create mode 100644 drivers/media/platform/rcar_fdp1.c
 create mode 100644 drivers/media/rc/serial_ir.c
 rename drivers/{staging/media => media/usb}/pulse8-cec/Kconfig (86%)
 rename drivers/{staging/media => media/usb}/pulse8-cec/Makefile (100%)
 rename drivers/{staging/media => media/usb}/pulse8-cec/pulse8-cec.c (97%)
 delete mode 100644 drivers/staging/media/cec/Kconfig
 delete mode 100644 drivers/staging/media/cec/TODO
 delete mode 100644 drivers/staging/media/lirc/lirc_serial.c
 delete mode 100644 drivers/staging/media/pulse8-cec/TODO
 create mode 100644 drivers/staging/media/st-cec/TODO
 rename include/{ => uapi}/linux/cec-funcs.h (98%)
 rename include/{ => uapi}/linux/cec.h (93%)

