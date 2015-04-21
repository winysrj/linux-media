Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42514 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbbDUPXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 11:23:54 -0400
Date: Tue, 21 Apr 2015 12:23:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.1-rc1] media updates
Message-ID: <20150421122315.6ddd42f4@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.1-2

For:
  - A new frontend driver for new ATSC devices: lgdt3306a
  - A new sensor driver: ov2659
  - a new platform driver: xilinx
  - The m88ts2022 tuner driver was merged at ts2020 driver
  - The media controller gained experimental support for DVB and hybrid
    devices;
  - Lots of random cleanups, fixes and improvements on media drivers

Thanks,
Mauro

-

The following changes since commit 2c33ce009ca2389dbf0535d0672214d09738e35e:

  Merge Linus master into drm-next (2015-04-20 13:05:20 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.1-2

for you to fetch changes up to 64131a87f2aae2ed9e05d8227c5b009ca6c50d98:

  Merge branch 'drm-next-merged' of git://people.freedesktop.org/~airlied/linux into v4l_for_linus (2015-04-21 09:44:55 -0300)

----------------------------------------------------------------
media updates for v4.1-rc1

----------------------------------------------------------------
Alexey Khoroshilov (2):
      [media] sh_vou: fix memory leak on error paths in sh_vou_open()
      [media] usbvision: fix leak of usb_dev on failure paths in usbvision_probe()

Andrzej Pietrasiewicz (1):
      [media] s5p-jpeg: add 5420 family support

Antti Palosaari (11):
      [media] mn88473: define symbol rate limits
      [media] mn88472: define symbol rate limits
      [media] ts2020: add support for TS2022
      [media] ts2020: implement I2C client bindings
      [media] em28xx: switch PCTV 461e to ts2020 driver
      [media] cx23885: switch ts2022 to ts2020 driver
      [media] smipcie: switch ts2022 to ts2020 driver
      [media] dvbsky: switch ts2022 to ts2020 driver
      [media] dw2102: switch ts2022 to ts2020 driver
      [media] m88ts2022: remove obsolete driver
      [media] ts2020: do not use i2c_transfer() on sleep()

Arnd Bergmann (2):
      [media] wl128x-radio really depends on TI_ST
      [media] Add and use IS_REACHABLE macro

Benjamin Larsson (14):
      [media] mn88473: calculate the IF register values
      [media] mn88473: simplify bandwidth registers setting code
      [media] r820t: add DVBC profile in sysfreq_sel
      [media] r820t: change read_gain() code to match register layout
      [media] rtl28xxu: lower the rc poll time to mitigate i2c transfer errors
      [media] mn88472: implement lock for all delivery systems
      [media] mn88472: implement firmware parity check
      [media] mn88473: implement firmware parity check
      [media] mn88473: check if firmware is already running before loading it
      [media] mn88472: check if firmware is already running before loading it
      [media] mn88473: implement lock for all delivery systems
      [media] mn88472: add ts mode and ts clock to driver
      [media] r820t: add settings for SYS_DVBC_ANNEX_C standard
      [media] r820t: enable flt_ext_wide for SYS_DVBC_ANNEX_A standard

Benoit Parrot (1):
      [media] media: i2c: add support for omnivision's ov2659 sensor

Christian Dale (1):
      [media] WinFast DTV2000 DS Plus

Christian Engelmayer (2):
      [media] cx88: Fix possible leak in cx8802_probe()
      [media] si2165: Fix possible leak in si2165_upload_firmware()

David Howells (3):
      [media] m88ts2022: Nested loops shouldn't use the same index variable
      [media] cx23885: Always initialise dev->slock spinlock
      [media] cxusb: Use enum to represent table offsets rather than hard-coding numbers

Devin Heitmueller (1):
      [media] xc5000: fix memory corruption when unplugging device

Dimitris Lampridis (1):
      [media] rtl28xxu: add support for Turbo-X DTT2000

Enrico Scholz (1):
      [media] mt9p031: fixed calculation of clk_div

Ezequiel Garcia (2):
      [media] stk1160: Make sure current buffer is released
      [media] MAINTAINERS: Update the maintainer mail address for stk1160

Fabian Frederick (1):
      [media] saa7146: replace current->state by set_current_state()

Florian Echtler (2):
      [media] add raw video stream support for Samsung SUR40
      [media] sur40: fix occasional hard freeze due to buffer queue underrun

Fred Richter (1):
      [media] DVB: add support for LG Electronics LGDT3306A ATSC/QAM-B Demodulator

Geert Uytterhoeven (2):
      [media] am437x: VIDEO_AM437X_VPFE should depend on HAS_DMA
      [media] timberdale: VIDEO_TIMBERDALE should depend on HAS_DMA

Gilles Risch (1):
      [media] Basic support for the Elgato EyeTV Hybrid INT 2008 USB Stick

Guennadi Liakhovetski (2):
      [media] V4L: remove clock name from v4l2_clk API
      [media] V4L: add CCF support to the v4l2_clk API

Hans Verkuil (118):
      [media] media.h: mark alsa struct in media_entity_desc as TODO
      [media] DocBook media: fix validation error
      [media] pvrusb2: replace .ioctl by .unlocked_ioctl
      [media] radio-bcm2048: use unlocked_ioctl instead of ioctl
      [media] uvc gadget: switch to v4l2 core locking
      [media] uvc gadget: switch to unlocked_ioctl
      [media] uvc gadget: set device_caps in querycap
      [media] v4l2-core: remove the old .ioctl BKL replacement
      [media] pvrusb2: use struct v4l2_fh
      [media] v4l2-core: drop g/s_priority ops
      [media] DocBook media: fix xvYCC601 documentation
      [media] DocBook media: fix typos in YUV420M description
      [media] v4l2-subdev: replace v4l2_subdev_fh by v4l2_subdev_pad_config
      [media] v4l2-subdev.h: add 'which' field for the enum structs
      [media] v4l2-subdev.c: add 'which' checks for enum ops
      [media] v4l2-subdev: support new 'which' field in enum_mbus_code
      [media] v4l2-subdev: add support for the new enum_frame_size 'which' field
      [media] DocBook media: document the new 'which' field
      [media] v4l2-subdev: add support for the new enum_frame_interval 'which' field
      [media] v4l2-subdev: remove enum_framesizes/intervals
      [media] vb2: check if vb2_fop_write/read is allowed
      [media] v4l2-framework.txt: debug -> dev_debug
      [media] v4l2-ioctl: tidy up debug messages
      [media] DocBook media: fix xv601/709 formulas
      [media] DocBook media: BT.2020 RGB uses limited quantization range
      [media] videodev2.h: fix comment
      [media] vivid: BT.2020 R'G'B' is limited range
      [media] DocBook v4l: update bytesperline handling
      [media] DocBook media: fix section IDs
      [media] rtl2832: fix compiler warning
      [media] cx231xx: fix compiler warnings
      [media] DocBook media: fix PIX_FMT_SGRBR8 example
      [media] au0828: fix broken streaming
      [media] v4l2-dev: disable selection ioctls for non-video devices
      [media] v4l2-ioctl: allow all controls if ctrl_class == 0
      [media] vivid: the overlay API wasn't disabled completely for multiplanar
      [media] vivid: fix typo in plane size checks
      [media] vivid: wrong top/bottom order for FIELD_ALTERNATE
      [media] vivid: use TPG_MAX_PLANES instead of hardcoding plane-arrays
      [media] vivid: fix test pattern movement for V4L2_FIELD_ALTERNATE
      [media] vivid: add new checkboard patterns
      [media] vivid-tpg: don't add offset when switching to monochrome
      [media] vivid: do not allow video loopback for SEQ_TB/BT
      [media] vivid-tpg: separate planes and buffers
      [media] vivid-tpg: add helper functions for single buffer planar formats
      [media] vivid-tpg: add hor/vert downsampling fields
      [media] vivid-tpg: precalculate downsampled lines
      [media] vivid-tpg: correctly average the two pixels in gen_twopix()
      [media] vivid-tpg: add hor/vert downsampling support to tpg_gen_text
      [media] vivid-tpg: finish hor/vert downsampling support
      [media] vivid-tpg: add support for more planar formats
      [media] vivid-tpg: add support for V4L2_PIX_FMT_GREY
      [media] vivid-tpg: add helper functions to simplify common calculations
      [media] vivid-tpg: add const where appropriate
      [media] vivid-tpg: add a new tpg_draw_params structure
      [media] vivid-tpg: move common parameters to tpg_draw_params
      [media] vivid-tpg: move pattern-related fields to struct tpg_draw_params
      [media] vivid-tpg: move 'extras' parameters to tpg_draw_params
      [media] vivid-tpg: move the 'extras' drawing to a separate function
      [media] vivid-tpg: split off the pattern drawing code
      [media] vivid: add new format fields
      [media] vivid: add support for single buffer planar formats
      [media] vivid: add downsampling support
      [media] vivid: add the new planar and monochrome formats
      [media] vivid: add RGB444 support
      [media] vivid: fix format comments
      [media] vivid: add support for [A|X]RGB555X
      [media] vivid: add support for NV24 and NV42
      [media] vivid: add support for PIX_FMT_RGB332
      [media] DocBook media: clarify BGR666
      [media] vivid: add support for BGR666
      [media] vivid: add support for packed YUV formats
      [media] vivid: turn this into a platform_device
      [media] vivid: use v4l2_device.release to clean up the driver
      [media] vivid: add support for 8-bit Bayer formats
      [media] vivid: allow s_dv_timings if it is the same as the current
      [media] vivid: report only one frameinterval
      [media] vivid: sanitize selection rectangle
      [media] DocBook media: fix VIDIOC_CROPCAP type description
      [media] DocBook media: fix awkward language in VIDIOC_QUERYCAP
      [media] DocBook media: improve event documentation
      [media] DocBook media: fix BT.2020 description
      [media] vivid-tpg.c: fix wrong Bt.2020 coefficients
      [media] DocBook media: improve V4L2_DV_FL_HALF_LINE documentation
      [media] ivtv: embed video_device
      [media] vim2m: embed video_device
      [media] saa7146: embed video_device
      [media] radio-bcm2048: embed video_device
      [media] dt3155v4l: embed video_device
      [media] meye: embed video_device
      [media] m2m-deinterlace: embed video_device
      [media] wl128x: embed video_device
      [media] gadget/uvc: embed video_device
      [media] hdpvr: embed video_device
      [media] tm6000: embed video_device
      [media] usbvision: embed video_device
      [media] cx231xx: embed video_device
      [media] v4l2_plane_pix_format: use __u32 bytesperline instead of __u16
      [media] sta2x11: embed video_device
      [media] ivtv: replace crop by selection
      [media] ivtv: disable fbuf support if ivtvfb isn't loaded
      [media] cx18: embed video_device
      [media] m88ts2022: remove from Makefile
      [media] ov2640: add missing consumer.h include
      [media] videodev2.h/v4l2-dv-timings.h: add V4L2_DV_FL_IS_CE_VIDEO flag
      [media] v4l2-dv-timings: log new V4L2_DV_FL_IS_CE_VIDEO flag
      [media] DocBook media: document the new V4L2_DV_FL_IS_CE_VIDEO flag
      [media] adv: use V4L2_DV_FL_IS_CE_VIDEO instead of V4L2_DV_BT_STD_CEA861
      [media] vivid: use V4L2_DV_FL_IS_CE_VIDEO instead of V4L2_DV_BT_STD_CEA861
      [media] cx18: add support for control events
      [media] cx18: fix VIDIOC_ENUMINPUT: wrong std value
      [media] cx18: replace cropping ioctls by selection ioctls
      [media] cx88: embed video_device
      [media] bttv: embed video_device
      [media] em28xx: embed video_device
      [media] uvc: embed video_device
      [media] uvcvideo: fix cropcap v4l2-compliance failure
      [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL

Hyun Kwon (2):
      [media] v4l: Sort YUV formats of v4l2_mbus_pixelcode
      [media] v4l: Add VUY8 24 bits bus format

Jacek Anaszewski (1):
      [media] s5p-jpeg: Initialize jpeg_addr fields to zero

Josh Wu (4):
      [media] media: soc-camera: use icd->control instead of icd->pdev for reset()
      [media] media: ov2640: add async probe function
      [media] media: ov2640: dt: add the device tree binding document
      [media] media: ov2640: add primary dt support

Julia Lawall (1):
      [media] media: pci: cx23885: don't export static symbol

Kamil Debski (4):
      [media] vb2: split the io_flags member of vb2_queue into a bit field
      [media] vb2: add allow_zero_bytesused flag to the vb2_queue struct
      [media] coda: set allow_zero_bytesused flag for vb2_queue_init
      [media] s5p-mfc: set allow_zero_bytesused flag for vb2_queue_init

Kiran Padwal (2):
      [media] staging: dt3155v4l: Switch to using managed resource with devm_
      [media] s5k5baf: Add missing error check for devm_kzalloc

KyongHo Cho (1):
      [media] v4l: vb2-memops: use vma slab when vma allocation

Lad, Prabhakar (31):
      [media] media: au0828: drop vbi_buffer_filled() and re-use buffer_filled()
      [media] media: drop call to v4l2_device_unregister_subdev()
      [media] media: i2c: ths7303: drop module param debug
      [media] media: omap/omap_vout: fix type of input members to omap_vout_setup_vrfb_bufs()
      [media] media: omap3isp: video: drop setting of vb2 buffer state to VB2_BUF_STATE_ACTIVE
      [media] media: am437x-vpfe: match the OF node/i2c addr instead of name
      [media] media: am437x-vpfe: return error in case memory allocation failure
      [media] media: am437x-vpfe: embed video_device struct in vpfe_device
      [media] media: blackfin: bfin_capture: drop buf_init() callback
      [media] media: blackfin: bfin_capture: release buffers in case start_streaming() call back fails
      [media] media: blackfin: bfin_capture: set min_buffers_needed
      [media] media: blackfin: bfin_capture: set vb2 buffer field
      [media] media: blackfin: bfin_capture: improve queue_setup() callback
      [media] media: blackfin: bfin_capture: use vb2_fop_mmap/poll
      [media] media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
      [media] media: blackfin: bfin_capture: use vb2_ioctl_* helpers
      [media] media: blackfin: bfin_capture: make sure all buffers are returned on stop_streaming() callback
      [media] media: blackfin: bfin_capture: return -ENODATA for *std calls
      [media] media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
      [media] media: blackfin: bfin_capture: add support for vidioc_create_bufs
      [media] media: blackfin: bfin_capture: add support for VB2_DMABUF
      [media] media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
      [media] media: blackfin: bfin_capture: set v4l2 buffer sequence
      [media] media: blackfin: bfin_capture: drop bcap_get_unmapped_area()
      [media] media: blackfin: bfin_capture: embed video_device struct in bcap_device
      [media] media: davinci: vpif_capture: embed video_device struct in channel_obj
      [media] media: davinci: vpif_display: embed video_device struct in channel_obj
      [media] media: i2c: mt9p031: make sure we destroy the mutex
      [media] media: i2c: mt9p031: add support for asynchronous probing
      [media] media: davinci: vpfe_capture: embed video_device
      [media] media: sh_vou: embed video_device

Laurent Pinchart (23):
      [media] media: omap3isp: video: Don't call vb2 mmap with queue lock held
      [media] media: omap3isp: video: Use v4l2_get_timestamp()
      [media] media: omap3isp: hist: Move histogram DMA to DMA engine
      [media] omap3isp: DT support for clocks
      [media] uvcvideo: Don't call vb2 mmap and get_unmapped_area with queue lock held
      [media] uvcvideo: Recognize the Tasco USB microscope
      [media] uvcvideo: Validate index during step-wise frame intervals enumeration
      [media] media: am437x: Don't release OF node reference twice
      [media] soc-camera: Unregister v4l2 clock in the OF bind error path
      [media] soc-camera: Make clock_start and clock_stop operations optional
      [media] rcar-vin: Don't implement empty optional clock operations
      [media] staging: media: omap4iss: Cleanup media entities after unregistration
      [media] staging: media: omap4iss: video: Don't WARN() on unknown pixel formats
      [media] v4l: mt9p031: Convert to the gpiod API
      [media] v4l: mt9v032: Consider control initialization errors as fatal
      [media] of: Add vendor prefix for Aptina Imaging
      [media] v4l: mt9v032: Add OF support
      [media] media: entity: Document the media_entity_ops structure
      [media] v4l: Add RBG and RGB 8:8:8 media bus formats on 24 and 32 bit busses
      [media] v4l: of: Add v4l2_of_parse_link() function
      [media] v4l: xilinx: Add Xilinx Video IP core
      [media] v4l: xilinx: Add Video Timing Controller driver
      [media] v4l: xilinx: Add Test Pattern Generator driver

Luis de Bethencourt (5):
      [media] gpsca: remove the risk of a division by zero
      [media] media: bcm2048: remove unused return of function
      [media] dvb-usb: fix spaces after commas
      [media] dib0700: remove unused macros
      [media] rtl2832: remove compiler warning

Marek Szyprowski (2):
      [media] media: s5p-mfc: fix mmap support for 64bit arch
      [media] media: s5p-mfc: fix broken pointer cast on 64bit arch

Markus Elfring (8):
      [media] stk-webcam: Delete an unnecessary check before the function call "vfree"
      [media] au0828: Delete unnecessary checks before the function call "video_unregister_device"
      [media] mn88472: Deletion of an unnecessary check before the function call "release_firmware"
      [media] mn88472: One function call less in mn88472_init() after error detection
      [media] sp2: Delete an unnecessary check before the function call "kfree"
      [media] V4L2: Delete an unnecessary check before the function call "media_entity_put"
      [media] DVB: Delete an unnecessary check before the function call "dvb_unregister_device"
      [media] DVB: Less function calls in dvb_ca_en50221_init() after error detection

Masatake YAMATO (1):
      [media] am437x: include linux/videodev2.h for expanding BASE_VIDIOC_PRIVATE

Mauro Carvalho Chehab (70):
      [media] media: Fix DVB devnode representation at media controller
      [media] Docbook: Fix documentation for media controller devnodes
      [media] media: add new types for DVB devnodes
      [media] DocBook: Document the DVB API devnodes at the media controller
      [media] media: add a subdev type for tuner
      [media] DocBook: Add tuner subdev at documentation
      [media] dvbdev: add support for media controller
      [media] cx231xx: add media controller support
      [media] dvb_frontend: add media controller support for DVB frontend
      [media] dmxdev: add support for demux/dvr nodes at media controller
      [media] dvb_ca_en50221: add support for CA node at the media controller
      [media] dvb_net: add support for DVB net node at the media controller
      [media] dvbdev: add pad for the DVB devnodes
      [media] tuner-core: properly initialize media controller subdev
      [media] cx25840: fill the media controller entity
      [media] cx231xx: initialize video/vbi pads
      [media] cx231xx: create media links for analog mode
      [media] dvbdev: represent frontend with two pads
      [media] dvbdev: add a function to create DVB media graph
      [media] cx231xx: create DVB graph
      [media] dvbdev: enable DVB-specific links
      [media] dvb-frontend: enable tuner link when the FE thread starts
      [media] cx231xx: enable tuner->decoder link at videobuf start
      [media] dvb_frontend: start media pipeline while thread is running
      Merge tag 'v4.0-rc1' into patchwork
      [media] dvb core: only start media entity if not NULL
      [media] dvb-frontend: remove a warning
      [media] cx231xx: fix compilation if the media controller is not defined
      [media] tuner-core: fix compilation if the media controller is not defined
      [media] dvb core: rename the media controller entities
      [media] cx25840: better document the media controller TODO
      [media] cx231xx: Improve the media controller comment
      [media] cx231xx: enable the analog tuner at buffer setup
      [media] cx25840: fix return logic when media entity init fails
      [media] cx25840: better document the media pads
      [media] siano: add support for the media controller at USB driver
      [media] siano: use pr_* print functions
      [media] siano: replace sms_warn() by pr_warn()
      [media] siano: replace sms_err by pr_err
      [media] siano: replace sms_log() by pr_debug()
      [media] siano: replace sms_debug() by pr_debug()
      [media] siano: get rid of sms_info()
      [media] siano: get rid of sms_dbg parameter
      [media] siano: print a message if DVB register succeeds
      [media] siano: register media controller earlier
      [media] dvb-usb-v2: create one media_dev per adapter
      [media] dvb-usb: create one media_dev per adapter
      [media] dvbdev: use adapter arg for dvb_create_media_graph()
      [media] dvb: Avoid warnings when compiled without the media controller
      [media] use a function for DVB media controller register
      [media] siano: avoid a linkedit error if !MC
      [media] fixp-arith: replace sin/cos table by a better precision one
      [media] lgdt3306a: Use hexadecimal values in lowercase
      [media] lgdt3306a: Use IS_ENABLED() for attach function
      [media] lgdt3306a: one bit fields should be unsigned
      [media] lgdt3306a: don't go past the buffer
      [media] lgdt3306a: properly handle I/O errors
      [media] lgdt3306a: Remove FSF address
      [media] lbdt3306a: rework at printk macros
      [media] lbdt3306a: simplify the lock status check
      [media] lgdt3306a: Don't use else were not needed
      [media] lbdt3306a: remove uneeded braces
      [media] lgdt3306a: constify log tables
      [media] lgdt3306a: Break long lines
      [media] lgdt3306a: Minor source code cleanups
      Revert "[media] v4l: vb2-memops: use vma slab when vma allocation"
      dvb-frontends: use IS_REACHABLE() instead of IS_ENABLED()
      Revert "[media] Add device tree support to adp1653 flash driver"
      Merge branch 'patchwork' into v4l_for_linus
      Merge branch 'drm-next-merged' of git://people.freedesktop.org/~airlied/linux into v4l_for_linus

Michael Ira Krufky (9):
      [media] lgdt3306a: clean up whitespace & unneeded brackets
      [media] lgdt3306a: remove unnecessary 'else'
      [media] lgdt3306a: move EXPORT_SYMBOL to be just after function
      [media] lgdt3306a: fix ERROR: do not use assignment in if condition
      [media] lgdt3306a: do not add new typedefs
      [media] lgdt3306a: fix ERROR: do not use C99 // comments
      [media] lgdt3306a: fix WARNING: please, no spaces at the start of a line
      [media] lgdt3306a: typo fix
      [media] lgdt3306a: more small whitespace cleanups

Michael Opdenacker (1):
      [media] DocBook media: fix broken EIA hyperlink

Nicholas Mc Guire (4):
      [media] cx231xx: drop condition with no effect
      [media] si470x: fixup wait_for_completion_timeout return handling
      [media] media: radio: assign wait_for_completion_timeout to appropriately typed var
      [media] media: radio: handle timeouts

Olli Salonen (7):
      [media] si2157: IF frequency for ATSC and QAM
      [media] cx231xx: Hauppauge HVR-955Q ATSC/QAM tuner
      [media] saa7164: free_irq before pci_disable_device
      [media] si2157: extend frequency range for ATSC
      [media] dw2102: combine su3000_state and s6x0_state into dw2102_state
      [media] dw2102: store i2c client for tuner into dw2102_state
      [media] dw2102: TechnoTrend TT-connect S2-4600 DVB-S/S2 tuner

Pablo Anton (1):
      [media] media: i2c: ADV7604: Rename adv7604 prefixes

Pavel Machek (1):
      [media] Add device tree support to adp1653 flash driver

Peter Seiderer (2):
      [media] coda: check kasprintf return value in coda_open
      [media] coda: fix double call to debugfs_remove

Philipp Zabel (13):
      [media] v4l2-mem2mem: no need to initialize b in v4l2_m2m_next_buf and v4l2_m2m_buf_remove
      [media] coda: bitrate can only be set in kbps steps
      [media] coda: bitstream payload is unsigned
      [media] coda: use strlcpy instead of snprintf
      [media] coda: allocate per-context buffers from REQBUFS
      [media] coda: allocate bitstream buffer from REQBUFS, size depends on the format
      [media] coda: move parameter buffer in together with context buffer allocation
      [media] coda: remove duplicate error messages for buffer allocations
      [media] coda: fail to start streaming if userspace set invalid formats
      [media] coda: call SEQ_END when the first queue is stopped
      [media] coda: fix fill bitstream errors in nonstreaming case
      [media] coda: drop dma_sync_single_for_device in coda_bitstream_queue
      [media] coda: Add tracing support

Prashant Laddha (4):
      [media] vivid sdr: Use LUT based implementation for sin/cos()
      [media] vivid sdr: fix broken sine tone generated for sdr FM
      [media] vivid: add CVT,GTF standards to vivid dv timings caps
      [media] vivid: add support to set CVT, GTF timings

Rafael Lourenço de Lima Chehab (2):
      [media] dvb-usb-v2: add support for the media controller at USB driver
      [media] dvb-usb: add support for the media controller at USB driver

Ricardo Ribalda Delgado (5):
      [media] media/v4l2-ctrls: volatiles should not generate CH_VALUE
      [media] media: New flag V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
      [media] media/v4l2-ctrls: Add execute flags to write_only controls
      [media] media/v4l2-ctrls: Always execute EXECUTE_ON_WRITE ctrls
      [media] media/Documentation: New flag EXECUTE_ON_WRITE

Rickard Strandqvist (1):
      [media] s5p-jpeg: Remove some unused functions

Russell King (1):
      [media] media: omap3isp: remove unused clkdev

Sakari Ailus (19):
      [media] omap3isp: Fix error handling in probe
      [media] omap3isp: Avoid a BUG_ON() in media_entity_create_link()
      [media] omap3isp: Separate external link creation from platform data parsing
      [media] omap3isp: Platform data could be NULL
      [media] omap3isp: Refactor device configuration structs for Device Tree
      [media] omap3isp: Rename regulators to better suit the Device Tree
      [media] omap3isp: Calculate vpclk_div for CSI-2
      [media] omap3isp: Replace mmio_base_phys array with the histogram block base
      [media] omap3isp: Move the syscon register out of the ISP register maps
      [media] omap3isp: Replace many MMIO regions by two
      [media] dt: bindings: Add lane-polarity property to endpoint nodes
      [media] v4l: of: Read lane-polarities endpoint property
      [media] omap3isp: Add support for the Device Tree
      [media] omap3isp: Deprecate platform data support
      [media] Revert "[media] smiapp: Don't compile of_read_number() if CONFIG_OF isn't defined"
      [media] smiapp: Use of_property_read_u64_array() to read a 64-bit number array
      [media] smiapp: Make pixel_order_str static
      [media] smiapp: Read link-frequencies property from the endpoint node
      [media] smiapp: Clean up smiapp_get_pdata()

Shuah Khan (1):
      [media] media: au0828 - embed vdev and vbi_dev structs in au0828_dev

Sifan Naeem (2):
      [media] rc: img-ir: Add and enable sys clock for img-ir
      [media] rc: img-ir: fix error in parameters passed to irq_free()

Simon Farnsworth (1):
      [media] cx18: Fix bytes_per_line

Tapasweni Pathak (2):
      [media] drivers: media: i2c : s5c73m3: Replace dev_err with pr_err
      [media] drivers: media: platform: vivid: Fix possible null derefrence

Uwe Kleine-König (2):
      [media] media: adv7604: improve usage of gpiod API
      [media] media: radio-si4713: improve usage of gpiod API

Wei Yongjun (1):
      [media] v4l2: remove unused including <linux/version.h>

Yannick Guerrini (1):
      [media] si2168: tda10071: m88ds3103: Fix trivial typos

Zhangfei Gao (1):
      [media] ir-hix5hd2: remove writel/readl_relaxed define

jean-michel.hautbois@vodalys.com (2):
      [media] media: i2c: ADV7604: In free run mode, signal is locked
      [media] media: adv7604: CP CSC uses a different register on adv7604 and adv7611

 Documentation/DocBook/media/v4l/compat.xml         |    2 +-
 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |   92 +-
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |   79 +-
 Documentation/DocBook/media/v4l/pixfmt-sgrbg8.xml  |   16 +-
 .../DocBook/media/v4l/pixfmt-srggb10p.xml          |    2 +-
 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |    4 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         |  110 +-
 Documentation/DocBook/media/v4l/subdev-formats.xml |  771 ++++---
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 +
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml |    9 +-
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |  121 +-
 Documentation/DocBook/media/v4l/vidioc-g-crop.xml  |    5 +
 .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |   18 +-
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml  |    4 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |    4 +-
 .../DocBook/media/v4l/vidioc-querycap.xml          |    8 +-
 .../DocBook/media/v4l/vidioc-queryctrl.xml         |   12 +-
 .../v4l/vidioc-subdev-enum-frame-interval.xml      |   13 +-
 .../media/v4l/vidioc-subdev-enum-frame-size.xml    |   13 +-
 .../media/v4l/vidioc-subdev-enum-mbus-code.xml     |   11 +-
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  111 +-
 .../bindings/media/exynos-jpeg-codec.txt           |    2 +-
 .../devicetree/bindings/media/i2c/mt9v032.txt      |   39 +
 .../devicetree/bindings/media/i2c/ov2640.txt       |   46 +
 .../devicetree/bindings/media/i2c/ov2659.txt       |   38 +
 .../devicetree/bindings/media/video-interfaces.txt |    6 +
 .../devicetree/bindings/media/xilinx/video.txt     |   35 +
 .../devicetree/bindings/media/xilinx/xlnx,v-tc.txt |   33 +
 .../bindings/media/xilinx/xlnx,v-tpg.txt           |   71 +
 .../bindings/media/xilinx/xlnx,video.txt           |   55 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/video4linux/v4l2-controls.txt        |    4 +-
 Documentation/video4linux/v4l2-framework.txt       |    6 +-
 Documentation/video4linux/vivid.txt                |    5 +
 MAINTAINERS                                        |   33 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   57 +-
 arch/arm/mach-omap2/devices.c                      |   76 +-
 arch/arm/mach-omap2/omap34xx.h                     |   36 +-
 drivers/input/ff-memless.c                         |   18 +-
 drivers/input/touchscreen/Kconfig                  |    2 +
 drivers/input/touchscreen/sur40.c                  |  434 +++-
 drivers/media/Kconfig                              |   10 +-
 drivers/media/common/saa7146/saa7146_fops.c        |   19 +-
 drivers/media/common/saa7146/saa7146_vbi.c         |    4 +-
 drivers/media/common/siano/sms-cards.c             |    8 +-
 drivers/media/common/siano/sms-cards.h             |    3 +-
 drivers/media/common/siano/smscoreapi.c            |  164 +-
 drivers/media/common/siano/smscoreapi.h            |   32 +-
 drivers/media/common/siano/smsdvb-debugfs.c        |    6 +-
 drivers/media/common/siano/smsdvb-main.c           |   74 +-
 drivers/media/common/siano/smsir.c                 |   18 +-
 drivers/media/dvb-core/dmxdev.c                    |   11 +-
 drivers/media/dvb-core/dvb-usb-ids.h               |    3 +
 drivers/media/dvb-core/dvb_ca_en50221.c            |   30 +-
 drivers/media/dvb-core/dvb_frontend.c              |  124 +-
 drivers/media/dvb-core/dvb_net.c                   |    6 +-
 drivers/media/dvb-core/dvbdev.c                    |  144 +-
 drivers/media/dvb-core/dvbdev.h                    |   27 +
 drivers/media/dvb-frontends/Kconfig                |    8 +
 drivers/media/dvb-frontends/Makefile               |    1 +
 drivers/media/dvb-frontends/a8293.h                |    2 +-
 drivers/media/dvb-frontends/af9013.h               |    2 +-
 drivers/media/dvb-frontends/atbm8830.h             |    2 +-
 drivers/media/dvb-frontends/au8522.h               |    2 +-
 drivers/media/dvb-frontends/bcm3510.h              |    2 +-
 drivers/media/dvb-frontends/cx22700.h              |    2 +-
 drivers/media/dvb-frontends/cx22702.h              |    2 +-
 drivers/media/dvb-frontends/cx24110.h              |    2 +-
 drivers/media/dvb-frontends/cx24113.h              |    2 +-
 drivers/media/dvb-frontends/cx24116.h              |    2 +-
 drivers/media/dvb-frontends/cx24117.h              |    2 +-
 drivers/media/dvb-frontends/cx24123.h              |    2 +-
 drivers/media/dvb-frontends/cxd2820r.h             |    2 +-
 drivers/media/dvb-frontends/dib0070.h              |    2 +-
 drivers/media/dvb-frontends/dib0090.h              |    2 +-
 drivers/media/dvb-frontends/dib3000.h              |    2 +-
 drivers/media/dvb-frontends/dib3000mc.h            |    2 +-
 drivers/media/dvb-frontends/dib7000m.h             |    2 +-
 drivers/media/dvb-frontends/dib7000p.h             |    2 +-
 drivers/media/dvb-frontends/dib8000.h              |    2 +-
 drivers/media/dvb-frontends/dib9000.h              |    2 +-
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    |    2 +-
 drivers/media/dvb-frontends/drxd.h                 |    2 +-
 drivers/media/dvb-frontends/drxk.h                 |    2 +-
 drivers/media/dvb-frontends/ds3000.h               |    2 +-
 drivers/media/dvb-frontends/dvb-pll.h              |    2 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.h         |    2 +-
 drivers/media/dvb-frontends/ec100.h                |    2 +-
 drivers/media/dvb-frontends/hd29l2.h               |    2 +-
 drivers/media/dvb-frontends/isl6405.h              |    2 +-
 drivers/media/dvb-frontends/isl6421.h              |    2 +-
 drivers/media/dvb-frontends/isl6423.h              |    2 +-
 drivers/media/dvb-frontends/itd1000.h              |    2 +-
 drivers/media/dvb-frontends/ix2505v.h              |    2 +-
 drivers/media/dvb-frontends/l64781.h               |    2 +-
 drivers/media/dvb-frontends/lg2160.h               |    2 +-
 drivers/media/dvb-frontends/lgdt3305.h             |    2 +-
 drivers/media/dvb-frontends/lgdt3306a.c            | 2144 ++++++++++++++++++++
 drivers/media/dvb-frontends/lgdt3306a.h            |   74 +
 drivers/media/dvb-frontends/lgdt330x.h             |    2 +-
 drivers/media/dvb-frontends/lgs8gl5.h              |    2 +-
 drivers/media/dvb-frontends/lgs8gxx.h              |    2 +-
 drivers/media/dvb-frontends/lnbh24.h               |    2 +-
 drivers/media/dvb-frontends/lnbp21.h               |    2 +-
 drivers/media/dvb-frontends/lnbp22.h               |    2 +-
 drivers/media/dvb-frontends/m88rs2000.h            |    2 +-
 drivers/media/dvb-frontends/mb86a16.h              |    2 +-
 drivers/media/dvb-frontends/mb86a20s.h             |    2 +-
 drivers/media/dvb-frontends/mn88472.h              |   12 +
 drivers/media/dvb-frontends/mn88473.h              |    6 +
 drivers/media/dvb-frontends/mt312.h                |    2 +-
 drivers/media/dvb-frontends/mt352.h                |    2 +-
 drivers/media/dvb-frontends/nxt200x.h              |    2 +-
 drivers/media/dvb-frontends/nxt6000.h              |    2 +-
 drivers/media/dvb-frontends/or51132.h              |    2 +-
 drivers/media/dvb-frontends/or51211.h              |    2 +-
 drivers/media/dvb-frontends/rtl2832.c              |    2 +-
 drivers/media/dvb-frontends/s5h1409.h              |    2 +-
 drivers/media/dvb-frontends/s5h1411.h              |    2 +-
 drivers/media/dvb-frontends/s5h1420.h              |    2 +-
 drivers/media/dvb-frontends/s5h1432.h              |    2 +-
 drivers/media/dvb-frontends/s921.h                 |    2 +-
 drivers/media/dvb-frontends/si2165.c               |    2 +-
 drivers/media/dvb-frontends/si2165.h               |    2 +-
 drivers/media/dvb-frontends/si21xx.h               |    2 +-
 drivers/media/dvb-frontends/sp2.c                  |    5 +-
 drivers/media/dvb-frontends/sp8870.h               |    2 +-
 drivers/media/dvb-frontends/sp887x.h               |    2 +-
 drivers/media/dvb-frontends/stb0899_drv.h          |    2 +-
 drivers/media/dvb-frontends/stb6000.h              |    2 +-
 drivers/media/dvb-frontends/stb6100.h              |    2 +-
 drivers/media/dvb-frontends/stv0288.h              |    2 +-
 drivers/media/dvb-frontends/stv0297.h              |    2 +-
 drivers/media/dvb-frontends/stv0299.h              |    2 +-
 drivers/media/dvb-frontends/stv0367.h              |    2 +-
 drivers/media/dvb-frontends/stv0900.h              |    2 +-
 drivers/media/dvb-frontends/stv090x.h              |    2 +-
 drivers/media/dvb-frontends/stv6110.h              |    2 +-
 drivers/media/dvb-frontends/stv6110x.h             |    2 +-
 drivers/media/dvb-frontends/tda1002x.h             |    4 +-
 drivers/media/dvb-frontends/tda10048.h             |    2 +-
 drivers/media/dvb-frontends/tda1004x.h             |    2 +-
 drivers/media/dvb-frontends/tda10071.h             |    2 +-
 drivers/media/dvb-frontends/tda10086.h             |    2 +-
 drivers/media/dvb-frontends/tda18271c2dd.h         |    2 +-
 drivers/media/dvb-frontends/tda665x.h              |    2 +-
 drivers/media/dvb-frontends/tda8083.h              |    2 +-
 drivers/media/dvb-frontends/tda8261.h              |    2 +-
 drivers/media/dvb-frontends/tda826x.h              |    2 +-
 drivers/media/dvb-frontends/ts2020.c               |  302 ++-
 drivers/media/dvb-frontends/ts2020.h               |   27 +-
 drivers/media/dvb-frontends/tua6100.h              |    2 +-
 drivers/media/dvb-frontends/ves1820.h              |    2 +-
 drivers/media/dvb-frontends/ves1x93.h              |    2 +-
 drivers/media/dvb-frontends/zl10036.h              |    2 +-
 drivers/media/dvb-frontends/zl10039.h              |    2 +-
 drivers/media/dvb-frontends/zl10353.h              |    2 +-
 drivers/media/i2c/Kconfig                          |   11 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ad9389b.c                        |   10 +-
 drivers/media/i2c/adv7180.c                        |   10 +-
 drivers/media/i2c/adv7343.c                        |    1 -
 drivers/media/i2c/adv7511.c                        |   26 +-
 drivers/media/i2c/adv7604.c                        |  945 ++++-----
 drivers/media/i2c/adv7842.c                        |    5 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   30 +
 drivers/media/i2c/cx25840/cx25840-core.h           |   11 +
 drivers/media/i2c/m5mols/m5mols_core.c             |   16 +-
 drivers/media/i2c/mt9m032.c                        |   34 +-
 drivers/media/i2c/mt9p031.c                        |   81 +-
 drivers/media/i2c/mt9t001.c                        |   36 +-
 drivers/media/i2c/mt9v032.c                        |  115 +-
 drivers/media/i2c/noon010pc30.c                    |   17 +-
 drivers/media/i2c/ov2659.c                         | 1509 ++++++++++++++
 drivers/media/i2c/ov7670.c                         |   37 +-
 drivers/media/i2c/ov9650.c                         |   16 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   72 +-
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |    2 +-
 drivers/media/i2c/s5k4ecgx.c                       |   16 +-
 drivers/media/i2c/s5k5baf.c                        |   40 +-
 drivers/media/i2c/s5k6a3.c                         |   18 +-
 drivers/media/i2c/s5k6aa.c                         |   34 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  118 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |    1 -
 drivers/media/i2c/soc_camera/ov2640.c              |  125 +-
 drivers/media/i2c/ths7303.c                        |    4 -
 drivers/media/i2c/ths8200.c                        |    1 -
 drivers/media/i2c/tvp514x.c                        |   13 +-
 drivers/media/i2c/tvp7002.c                        |   15 +-
 drivers/media/mmc/siano/smssdio.c                  |   17 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   73 +-
 drivers/media/pci/bt8xx/bttvp.h                    |    6 +-
 drivers/media/pci/cx18/cx18-alsa-main.c            |    2 +-
 drivers/media/pci/cx18/cx18-driver.h               |    3 +-
 drivers/media/pci/cx18/cx18-fileops.c              |   27 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |   58 +-
 drivers/media/pci/cx18/cx18-streams.c              |   66 +-
 drivers/media/pci/cx18/cx18-streams.h              |    2 +-
 drivers/media/pci/cx23885/Kconfig                  |    1 -
 drivers/media/pci/cx23885/altera-ci.c              |    3 -
 drivers/media/pci/cx23885/altera-ci.h              |    2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |    1 +
 drivers/media/pci/cx23885/cx23885-dvb.c            |   30 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    1 -
 drivers/media/pci/cx88/cx88-blackbird.c            |   22 +-
 drivers/media/pci/cx88/cx88-core.c                 |   18 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    3 +-
 drivers/media/pci/cx88/cx88-video.c                |   61 +-
 drivers/media/pci/cx88/cx88.h                      |   17 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |    2 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |    4 +-
 drivers/media/pci/ivtv/ivtv-driver.h               |    2 +-
 drivers/media/pci/ivtv/ivtv-fileops.c              |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |  159 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |    8 +-
 drivers/media/pci/ivtv/ivtv-streams.c              |  113 +-
 drivers/media/pci/ivtv/ivtv-streams.h              |    2 +-
 drivers/media/pci/meye/meye.c                      |   21 +-
 drivers/media/pci/meye/meye.h                      |    2 +-
 drivers/media/pci/saa7146/hexium_gemini.c          |    2 +-
 drivers/media/pci/saa7146/hexium_orion.c           |    2 +-
 drivers/media/pci/saa7146/mxb.c                    |    4 +-
 drivers/media/pci/saa7164/saa7164-core.c           |    4 +-
 drivers/media/pci/smipcie/Kconfig                  |    2 +-
 drivers/media/pci/smipcie/smipcie.c                |   12 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   35 +-
 drivers/media/pci/ttpci/av7110.h                   |    4 +-
 drivers/media/pci/ttpci/budget-av.c                |    2 +-
 drivers/media/platform/Kconfig                     |    4 +-
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/am437x/Kconfig              |    2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   59 +-
 drivers/media/platform/am437x/am437x-vpfe.h        |    3 +-
 drivers/media/platform/blackfin/bfin_capture.c     |  348 +---
 drivers/media/platform/coda/Makefile               |    2 +
 drivers/media/platform/coda/coda-bit.c             |  205 +-
 drivers/media/platform/coda/coda-common.c          |  113 +-
 drivers/media/platform/coda/coda-jpeg.c            |    1 +
 drivers/media/platform/coda/coda.h                 |   18 +-
 drivers/media/platform/coda/trace.h                |  203 ++
 drivers/media/platform/davinci/vpfe_capture.c      |   26 +-
 drivers/media/platform/davinci/vpif_capture.c      |   52 +-
 drivers/media/platform/davinci/vpif_capture.h      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |   49 +-
 drivers/media/platform/davinci/vpif_display.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   22 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   28 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   33 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   16 +-
 drivers/media/platform/m2m-deinterlace.c           |   21 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   48 +-
 drivers/media/platform/omap/omap_vout.c            |    2 +-
 drivers/media/platform/omap/omap_vout_vrfb.c       |    1 +
 drivers/media/platform/omap/omap_vout_vrfb.h       |    4 +-
 drivers/media/platform/omap3isp/isp.c              |  563 +++--
 drivers/media/platform/omap3isp/isp.h              |   43 +-
 drivers/media/platform/omap3isp/ispccdc.c          |  112 +-
 drivers/media/platform/omap3isp/ispccp2.c          |   68 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |   56 +-
 drivers/media/platform/omap3isp/ispcsiphy.c        |   48 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c      |    1 -
 drivers/media/platform/omap3isp/isph3a_af.c        |    1 -
 drivers/media/platform/omap3isp/isphist.c          |  127 +-
 drivers/media/platform/omap3isp/isppreview.c       |   70 +-
 drivers/media/platform/omap3isp/ispresizer.c       |   80 +-
 drivers/media/platform/omap3isp/ispstat.c          |    2 +-
 drivers/media/platform/omap3isp/ispstat.h          |    5 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   20 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   18 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   63 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   12 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c      |   32 -
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h      |    3 -
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    7 +
 drivers/media/platform/s5p-tv/mixer_video.c        |    2 +-
 drivers/media/platform/sh_vou.c                    |   30 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |   15 -
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |    1 -
 drivers/media/platform/soc_camera/soc_camera.c     |  108 +-
 drivers/media/platform/via-camera.c                |   15 +-
 drivers/media/platform/vim2m.c                     |   23 +-
 drivers/media/platform/vivid/vivid-core.c          |   93 +-
 drivers/media/platform/vivid/vivid-core.h          |    8 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |    2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |  125 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   66 +-
 drivers/media/platform/vivid/vivid-tpg.c           | 1082 +++++++---
 drivers/media/platform/vivid/vivid-tpg.h           |  112 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |  180 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |  378 +++-
 drivers/media/platform/vivid/vivid-vid-out.c       |   85 +-
 drivers/media/platform/vsp1/vsp1_bru.c             |   42 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |   16 +-
 drivers/media/platform/vsp1/vsp1_entity.h          |    4 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |   18 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |   22 +-
 drivers/media/platform/vsp1/vsp1_lut.c             |   22 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |   37 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   12 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |   30 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |   30 +-
 drivers/media/platform/xilinx/Kconfig              |   23 +
 drivers/media/platform/xilinx/Makefile             |    5 +
 drivers/media/platform/xilinx/xilinx-dma.c         |  766 +++++++
 drivers/media/platform/xilinx/xilinx-dma.h         |  109 +
 drivers/media/platform/xilinx/xilinx-tpg.c         |  931 +++++++++
 drivers/media/platform/xilinx/xilinx-vip.c         |  323 +++
 drivers/media/platform/xilinx/xilinx-vip.h         |  238 +++
 drivers/media/platform/xilinx/xilinx-vipp.c        |  669 ++++++
 drivers/media/platform/xilinx/xilinx-vipp.h        |   49 +
 drivers/media/platform/xilinx/xilinx-vtc.c         |  380 ++++
 drivers/media/platform/xilinx/xilinx-vtc.h         |   42 +
 drivers/media/radio/radio-wl1273.c                 |   27 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |   14 +-
 drivers/media/radio/si4713/si4713.c                |   18 +-
 drivers/media/radio/wl128x/Kconfig                 |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |   28 +-
 drivers/media/rc/img-ir/img-ir-core.c              |   31 +-
 drivers/media/rc/img-ir/img-ir.h                   |    2 +
 drivers/media/rc/ir-hix5hd2.c                      |    8 -
 drivers/media/tuners/Kconfig                       |    8 -
 drivers/media/tuners/Makefile                      |    1 -
 drivers/media/tuners/fc0011.h                      |    2 +-
 drivers/media/tuners/fc0012.h                      |    2 +-
 drivers/media/tuners/fc0013.h                      |    2 +-
 drivers/media/tuners/fc2580.h                      |    2 +-
 drivers/media/tuners/m88ts2022.c                   |  579 ------
 drivers/media/tuners/m88ts2022.h                   |   54 -
 drivers/media/tuners/m88ts2022_priv.h              |   35 -
 drivers/media/tuners/max2165.h                     |    2 +-
 drivers/media/tuners/mc44s803.h                    |    2 +-
 drivers/media/tuners/mt2060.h                      |    2 +-
 drivers/media/tuners/mt2063.h                      |    2 +-
 drivers/media/tuners/mt20xx.h                      |    2 +-
 drivers/media/tuners/mt2131.h                      |    2 +-
 drivers/media/tuners/mt2266.h                      |    2 +-
 drivers/media/tuners/mxl5005s.h                    |    2 +-
 drivers/media/tuners/mxl5007t.h                    |    2 +-
 drivers/media/tuners/qt1010.h                      |    2 +-
 drivers/media/tuners/r820t.c                       |   29 +-
 drivers/media/tuners/r820t.h                       |    2 +-
 drivers/media/tuners/si2157.c                      |   25 +-
 drivers/media/tuners/si2157_priv.h                 |    1 +
 drivers/media/tuners/tda18218.h                    |    2 +-
 drivers/media/tuners/tda18271.h                    |    2 +-
 drivers/media/tuners/tda827x.h                     |    2 +-
 drivers/media/tuners/tda8290.h                     |    2 +-
 drivers/media/tuners/tda9887.h                     |    2 +-
 drivers/media/tuners/tea5761.h                     |    2 +-
 drivers/media/tuners/tea5767.h                     |    2 +-
 drivers/media/tuners/tua9001.h                     |    2 +-
 drivers/media/tuners/tuner-simple.h                |    2 +-
 drivers/media/tuners/tuner-xc2028.h                |    2 +-
 drivers/media/tuners/xc4000.h                      |    2 +-
 drivers/media/tuners/xc5000.c                      |    5 +-
 drivers/media/tuners/xc5000.h                      |    2 +-
 drivers/media/usb/au0828/au0828-video.c            |  104 +-
 drivers/media/usb/au0828/au0828.h                  |    4 +-
 drivers/media/usb/cx231xx/Kconfig                  |    1 +
 drivers/media/usb/cx231xx/cx231xx-417.c            |   33 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  144 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |   13 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |   71 +
 drivers/media/usb/cx231xx/cx231xx-video.c          |  176 +-
 drivers/media/usb/cx231xx/cx231xx.h                |   21 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |    2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    1 +
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   58 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |   26 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    8 +-
 drivers/media/usb/dvb-usb/Kconfig                  |    5 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |  155 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |    3 -
 drivers/media/usb/dvb-usb/dib0700_devices.c        |    3 -
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c            |   69 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |  192 +-
 drivers/media/usb/em28xx/Kconfig                   |    2 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |    2 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   13 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   14 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  119 +-
 drivers/media/usb/em28xx/em28xx.h                  |    7 +-
 drivers/media/usb/gspca/ov534.c                    |   11 +-
 drivers/media/usb/gspca/topro.c                    |    4 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |   10 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   19 +-
 drivers/media/usb/hdpvr/hdpvr.h                    |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   84 +-
 drivers/media/usb/siano/smsusb.c                   |  136 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |   17 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |    6 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   59 +-
 drivers/media/usb/tm6000/tm6000.h                  |    4 +-
 drivers/media/usb/usbvision/usbvision-video.c      |   94 +-
 drivers/media/usb/usbvision/usbvision.h            |    4 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   30 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   15 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   70 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    2 +-
 drivers/media/v4l2-core/tuner-core.c               |   22 +
 drivers/media/v4l2-core/v4l2-clk.c                 |   81 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   22 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   55 +-
 drivers/media/v4l2-core/v4l2-device.c              |    5 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |    6 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   12 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |    4 +-
 drivers/media/v4l2-core/v4l2-of.c                  |  102 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   33 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   60 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c      |   39 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |   51 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |   49 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |   83 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   59 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |   37 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.h        |    4 +-
 drivers/staging/media/mn88472/mn88472.c            |   93 +-
 drivers/staging/media/mn88472/mn88472_priv.h       |    2 +
 drivers/staging/media/mn88473/mn88473.c            |  133 +-
 drivers/staging/media/mn88473/mn88473_priv.h       |    1 +
 drivers/staging/media/omap4iss/iss_csi2.c          |   42 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |   48 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |   58 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |   52 +-
 drivers/staging/media/omap4iss/iss_video.c         |    8 +-
 drivers/usb/gadget/function/f_uvc.c                |   40 +-
 drivers/usb/gadget/function/uvc.h                  |    3 +-
 drivers/usb/gadget/function/uvc_queue.c            |   79 +-
 drivers/usb/gadget/function/uvc_queue.h            |    4 +-
 drivers/usb/gadget/function/uvc_v4l2.c             |    8 +-
 drivers/usb/gadget/function/uvc_video.c            |    3 +-
 include/dt-bindings/media/xilinx-vip.h             |   39 +
 include/linux/fixp-arith.h                         |  145 +-
 include/linux/kconfig.h                            |    9 +
 include/media/adv7604.h                            |   83 +-
 include/media/davinci/vpfe_capture.h               |    2 +-
 include/media/media-entity.h                       |   21 +-
 include/media/mt9p031.h                            |    2 -
 include/media/omap3isp.h                           |   38 +-
 include/media/ov2659.h                             |   34 +
 include/media/saa7146_vv.h                         |    4 +-
 include/media/v4l2-clk.h                           |   10 +-
 include/media/v4l2-dev.h                           |    1 -
 include/media/v4l2-device.h                        |    2 -
 include/media/v4l2-ioctl.h                         |    6 -
 include/media/v4l2-of.h                            |   30 +
 include/media/v4l2-subdev.h                        |   55 +-
 include/media/videobuf2-core.h                     |   20 +-
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/am437x-vpfe.h                   |    2 +
 include/uapi/linux/media-bus-format.h              |   15 +-
 include/uapi/linux/media.h                         |   52 +-
 include/uapi/linux/v4l2-dv-timings.h               |   64 +-
 include/uapi/linux/v4l2-subdev.h                   |   12 +-
 include/uapi/linux/videodev2.h                     |   18 +-
 include/uapi/linux/xilinx-v4l2-controls.h          |   73 +
 458 files changed, 17083 insertions(+), 6399 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9v032.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2659.txt
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/video.txt
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,v-tc.txt
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt
 create mode 100644 drivers/media/dvb-frontends/lgdt3306a.c
 create mode 100644 drivers/media/dvb-frontends/lgdt3306a.h
 create mode 100644 drivers/media/i2c/ov2659.c
 create mode 100644 drivers/media/platform/coda/trace.h
 create mode 100644 drivers/media/platform/xilinx/Kconfig
 create mode 100644 drivers/media/platform/xilinx/Makefile
 create mode 100644 drivers/media/platform/xilinx/xilinx-dma.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-dma.h
 create mode 100644 drivers/media/platform/xilinx/xilinx-tpg.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-vip.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-vip.h
 create mode 100644 drivers/media/platform/xilinx/xilinx-vipp.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-vipp.h
 create mode 100644 drivers/media/platform/xilinx/xilinx-vtc.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-vtc.h
 delete mode 100644 drivers/media/tuners/m88ts2022.c
 delete mode 100644 drivers/media/tuners/m88ts2022.h
 delete mode 100644 drivers/media/tuners/m88ts2022_priv.h
 create mode 100644 include/dt-bindings/media/xilinx-vip.h
 create mode 100644 include/media/ov2659.h
 create mode 100644 include/uapi/linux/xilinx-v4l2-controls.h

