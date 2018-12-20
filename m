Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CFAC43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 464762186A
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 12:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545309161;
	bh=99KZ6cKeSP2gHZ6Y5kr39cQE/ZEe8i4Lsmf3b7st66M=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=ZMAYLzS1b9Ho8eJAajVdV2GVwAzqJUmflKyv9YZHrsjLuLR87T4tNwB6C7jF+paa2
	 Q0aiuXuVemSyIUbNuyXvVduxSN0CEfMqQI9kdm2CAlX2jKNiGg8uCcgeSF0dweUu8V
	 NxmyBo9UO/7U5GhsjyXeBAR74EmJCz5RIfkbJyxw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731574AbeLTMcd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:32:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:44912 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbeLTMcd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 07:32:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mlBd4vCnOR7XGeWBkQEhWnhm7pkrWK/vV2j07u/EVuY=; b=dr6N/Bu1Y+XdznyHvFZRFIFmLR
        IhS+o3lIIM9kPDBNFYOlllXgeLlPnF2HnY7Q42EJWrT2nrUqgR5XfRk59tvplcJmAZIAUN768m1F3
        l51x67k10k8D4GGAHa0RBB5VMCfl9KnBZur6tah/tOtd+qTPS0Qyz7TY/BGaToBmDltI3LVSIF0cZ
        rKLhUs/DdCZajOXLyiCHeTLu/NqxAPdc+ACQUweUw9uNHJsL7jSzR44HeVYem0G3zG4T4tv5j8PAG
        2OIsc7T+OqYc8tEuZJXw+DL2jJa9KoMk0b/kSIotydA6BwlQHRWXpOREnIuMeF9xIvEvOXMzxsjTe
        i0Vu0Lpw==;
Received: from [191.33.191.108] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZxV6-0007jq-5j; Thu, 20 Dec 2018 12:32:29 +0000
Date:   Thu, 20 Dec 2018 10:32:23 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.21] First part of media patches
Message-ID: <20181220103223.3b5c64da@coco.lan>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/me=
dia/v4.20-6

For the first set of media patches for 4.21. It contains:

- Three new platform drivers: aspeed-video seco-sed and sun5i-csi;
- One new sensor driver: imx214;
- Support for Xbox DVD Movie Playback kit remote controller;
- Removal of the legacy friio driver. The functionalities were ported to
  another driver, already merged;
- New staging driver: Rockchip VPU;
- Added license text or SPDX tags to all media documentation files;
- Usual set of cleanup, fixes and enhancements.

PS.: The last patch here is a regression fix that I received yesterday.
Usually, I would wait for an extra day for it to get merged at -next,
but as you wanted an early submission, I'm opting to send it to you
before arriving -next.=20

Regards,
Mauro



The following changes since commit 7566ec393f4161572ba6f11ad5171fd5d59b0fbd:

  Linux 4.20-rc7 (2018-12-16 15:46:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/me=
dia/v4.20-6

for you to fetch changes up to 4bd46aa0353e022c2401a258e93b107880a66533:

  media: cx23885: only reset DMA on problematic CPUs (2018-12-20 06:52:01 -=
0500)

----------------------------------------------------------------
media fixes for v4.20-rc8

----------------------------------------------------------------
Akinobu Mita (13):
      media: video-i2c: avoid accessing released memory area when removing =
driver
      media: video-i2c: use i2c regmap
      media: v4l2-common: add V4L2_FRACT_COMPARE
      media: vivid: use V4L2_FRACT_COMPARE
      media: video-i2c: support changing frame interval
      media: mt9m111: support log_status ioctl and event interface
      media: mt9m111: add V4L2_CID_COLORFX control
      media: ov2640: add V4L2_CID_TEST_PATTERN control
      media: ov2640: support log_status ioctl and event interface
      media: ov5640: support log_status ioctl and event interface
      media: ov7670: support log_status ioctl and event interface
      media: ov772x: support log_status ioctl and event interface
      media: video-i2c: support runtime PM

Alexandre Courbot (1):
      media: venus: fix reported size of 0-length buffers

Alexey Khoroshilov (2):
      media: mtk-vcodec: Release device nodes in mtk_vcodec_init_enc_pm()
      media: DaVinci-VPBE: fix error handling in vpbe_initialize()

Andrea Merello (1):
      media: xilinx: fix typo in formats table

Andreas Pape (2):
      media: stkwebcam: Support for ASUS A6VM notebook added.
      media: stkwebcam: Bugfix for wrong return values

Andrey Abramov (1):
      media: Staging: media: replace deprecated probe method

Arnd Bergmann (1):
      media: i2c: TDA1997x: select CONFIG_HDMI

Ben Hutchings (1):
      media: Documentation/media: uapi: Explicitly say there are no Invaria=
nt Sections

Benjamin Valentin (1):
      media: rc: add driver for Xbox DVD Movie Playback Kit

Bingbu Cao (3):
      media: imx319: fix wrong order in test pattern menus
      media: imx355: fix wrong order in test pattern menus
      media: unify some sony camera sensors pattern naming

Brad Love (2):
      media: mceusb: Include three Hauppauge USB dvb device with IR rx
      media: cx23885: only reset DMA on problematic CPUs

Chen, JasonX Z (1):
      media: imx258: remove test pattern map from driver

Chiranjeevi Rapolu (1):
      media: ov13858: Check for possible null pointer

Christoph Hellwig (1):
      media: sti/bdisp: don't pass GFP_DMA32 to dma_alloc_attrs

Colin Ian King (6):
      media: dib0700: fix spelling mistake "Amplifyer" -> "Amplifier"
      media: exynos4-is: fix spelling mistake ACTURATOR -> ACTUATOR
      media: em28xx: fix spelling mistake, "Cinnergy" -> "Cinergy"
      media: tda7432: fix spelling mistake "maximium" -> "maximum"
      media: pvrusb2: fix spelling mistake "statuss" -> "status"
      media: sun6i: fix spelling mistake "droped" -> "dropped"

Corentin Labbe (1):
      media: usb: dvb-usb: remove old friio driver

Dafna Hirschfeld (4):
      media: vicodec: prepare support for various number of planes
      media: vicodec: Add support of greyscale format
      media: vicodec: Add support for 4 planes formats
      media: vicodec: Change variable names

Daniel Axtens (1):
      media: uvcvideo: Refactor teardown of uvc on USB disconnect

Dhaval Shah (1):
      media: xilinx: Use SPDX-License-Identifier

Dmitry Osipenko (1):
      media: staging: tegra-vde: Replace debug messages with trace points

Eddie James (2):
      media: dt-bindings: media: Add Aspeed Video Engine binding documentat=
ion
      media: platform: Add Aspeed Video Engine driver

Enrico Scholz (1):
      media: mt9m111: allow to setup pixclk polarity

Eric Biggers (1):
      media: v4l: constify v4l2_ioctls[]

Ettore Chimenti (2):
      media: add SECO cec driver
      media: seco-cec: add Consumer-IR support

Ezequiel Garcia (7):
      media: mem2mem: Require capture and output mutexes to match
      media: v4l2-ioctl.c: Simplify locking for m2m devices
      media: v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
      media: cedrus: Get rid of interrupt bottom-half
      media: dt-bindings: Document the Rockchip VPU bindings
      media: add Rockchip VPU JPEG encoder driver
      media: v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields

Fabio Estevam (4):
      media: imx-pxp: Check the return value from clk_prepare_enable()
      media: imx-pxp: Check for pxp_soft_reset() error
      media: imx-pxp: Improve pxp_soft_reset() error message
      media: v4l2-fwnode: Demote warning to debug level

Gabriel Francisco Mandaji (1):
      media: vivid: Improve timestamping

Hans Verkuil (35):
      media: v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE
      media: v4l2-common.h: put backwards compat defines under #ifndef __KE=
RNEL__
      media: v4l2-ioctl: add QUIRK_INVERTED_CROP
      media: davinci/vpbe: drop unused g_cropcap
      media: cropcap/g_selection split
      media: exynos-gsc: replace v4l2_crop by v4l2_selection
      media: s5p_mfc_dec.c: convert g_crop to g_selection
      media: exynos4-is: convert g/s_crop to g/s_selection
      media: s5p-g2d: convert g/s_crop to g/s_selection
      media: v4l2-ioctl: remove unused vidioc_g/s_crop
      media: vidioc_cropcap -> vidioc_g_pixelaspect
      media: vim2m/vicodec: set device_caps in video_device struct
      media: vidioc-enum-fmt.rst: update list of valid buftypes
      media: cec-pin: fix broken tx_ignore_nack_until_eom error injection
      media: pulse8-cec: return 0 when invalidating the logical address
      media: vb2: vb2_mmap: move lock up
      media: adv7604: add CEC support for adv7611/adv7612
      media: cec: report Vendor ID after initialization
      media: cec: add debug_phys_addr module option
      media: cec: keep track of outstanding transmits
      media: vivid: fix error handling of kthread_run
      media: vivid: set min width/height to a value > 0
      media: vivid: fill in media_device bus_info
      media: vim2m: use cancel_delayed_work_sync instead of flush_schedule_=
work
      media: adv*/tc358743/ths8200: fill in min width/height/pixelclock
      media: vb2: check memory model for VIDIOC_CREATE_BUFS
      media: MAINTAINERS fixups
      media: v4l2-tpg: array index could become negative
      media: vivid: free bitmap_cap when updating std/timings/etc.
      media: videobuf2-v4l2: drop WARN_ON in vb2_warn_zero_bytesused()
      media: seco-cec: fix Makefile
      media: dib0900: fix smatch warnings
      media: vivid: fix smatch warnings
      media: vivid: add req_validate error injection
      media: vicodec: move the GREY format to the end of the list

Helen Fornazier (1):
      media: vimc: fix start stream when link is disabled

Iliya Iliev (1):
      media: drivers: media: pci: b2c2: Fix errors due to unappropriate cod=
ing style.

Jacopo Mondi (7):
      media: dt-bindings: rcar-vin: Add R8A77990 support
      media: rcar-vin: Add support for R-Car R8A77990
      media: dt-bindings: rcar-csi2: Add R8A77990
      media: rcar-csi2: Add R8A77990 support
      media: rcar: rcar-csi2: Update V3M/E3 PHTW tables
      media: rcar-csi2: Handle per-SoC number of channels
      media: ov5640: Fix set format regression

Jasmin Jessich (1):
      media: adv7604 added include of linux/interrupt.h

John Sheu (1):
      media: vb2: Allow reqbufs(0) with "in use" MMAP buffers

Jonas Karlman (1):
      media: v4l: Fix MPEG-2 slice Intra DC Precision validation

Julia Lawall (8):
      media: ov5645: constify v4l2_ctrl_ops structure
      media: ov7740: constify structures stored in fields of v4l2_subdev_op=
s structure
      media: video-i2c: hwmon: constify vb2_ops structure
      media: vicodec: constify v4l2_ctrl_ops structure
      media: rockchip/rga: constify v4l2_m2m_ops structure
      media: vimc: constify structures stored in fields of v4l2_subdev_ops =
structure
      media: rockchip/rga: constify video_device structure
      media: mxl5xx: constify dvb_frontend_ops structure

Kelvin Lawson (1):
      media: venus: Support V4L2 QP parameters in Venus encoder

Kieran Bingham (10):
      media: uvcvideo: Refactor URB descriptors
      media: uvcvideo: Convert decode functions to use new context structure
      media: uvcvideo: Protect queue internals with helper
      media: uvcvideo: queue: Simplify spin-lock usage
      media: uvcvideo: queue: Support asynchronous buffer handling
      media: uvcvideo: Abstract streaming object lifetime
      media: uvcvideo: Move decode processing to process context
      media: uvcvideo: Split uvc_video_enable into two
      media: uvcvideo: Rename uvc_{un,}init_video()
      media: uvcvideo: Utilise for_each_uvc_urb iterator

Lubomir Rintel (1):
      media: marvell-ccic: trivial fix to the datasheet URL

Luca Ceresoli (4):
      media: imx274: fix stack corruption in imx274_read_reg
      media: imx274: declare the correct number of controls
      media: imx274: select REGMAP_I2C
      media: v4l2-subdev: document controls need _FL_HAS_DEVNODE

Lucas Stach (2):
      media: coda: limit queueing into internal bitstream buffer
      media: coda: don't disable IRQs across buffer meta handling

Malathi Gottam (5):
      media: venus: change the default value of GOP size
      media: venus: add support for USERPTR to queue
      media: venus: handle peak bitrate set property
      media: venus: dynamic handling of bitrate
      media: venus: add support for key frame

Malcolm Priestley (5):
      media: dvb-usb-v2: Fix incorrect use of transfer_flags URB_FREE_BUFFER
      media: lmedm04: Move usb buffer to lme2510_state.
      media: lmedm04: use dvb_usbv2_generic_rw_locked
      media: lmedm04: Add missing usb_free_urb to free interrupt urb.
      media: lmedm04: Move interrupt buffer to priv buffer.

Marco Felsch (4):
      media: tvp5150: fix irq_request error path during probe
      media: mt9m111: add s_stream callback
      media: dt-bindings: media: mt9m111: adapt documentation to be more cl=
ear
      media: dt-bindings: media: mt9m111: add pclk-sample property

Matt Ranostay (1):
      media: video-i2c: check if chip struct has set_power function

Mauro Carvalho Chehab (23):
      media: rc: imon: replace strcpy() by strscpy()
      media: sum6i: Fix a few coding style issues
      media: sun6i: manually fix other coding style issues
      media: seco-cec: declare ops as static const
      media: vb2: be sure to unlock mutex on errors
      media: dvb_frontend: don't print function names twice
      media: dvb_frontend: add debug message for frequency intervals
      media: dvb-pll: fix tuner frequency ranges
      media: dvb-pll: don't re-validate tuner frequencies
      media: ddbridge: remove another duplicate of io.h and sort includes
      media: remove text encoding from rst files
      media: add SPDX header to media uAPI files
      media: svg files: dual-licence some files with GPL and GFDL
      media: docs: brainless mass add SPDX headers to all media files
      media: pixfmt-meta-d4xx.rst: Add a license to it
      Merge commit '0072a0c14d5b7cb72c611d396f143f5dcd73ebe2' into patchwork
      media: rockchip/vpu: fix a few alignments
      media: cetrus: return an error if alloc fails
      media: cedrus: don't initialize pointers with zero
      media: rockchip vpu: remove some unused vars
      Merge tag 'v4.20-rc7' into patchwork
      media: docs: fix some GPL licensing ambiguity at the text
      media: drxk_hard: check if parameter is not NULL

Maxime Ripard (13):
      media: dt-bindings: media: sun6i: Add A31 and H3 compatibles
      media: sun6i: Add A31 compatible
      media: ov5640: Adjust the clock based on the expected rate
      media: ov5640: Remove the clocks registers initialization
      media: ov5640: Remove redundant defines
      media: ov5640: Remove redundant register setup
      media: ov5640: Compute the clock rate at runtime
      media: ov5640: Remove pixel clock rates
      media: ov5640: Enhance FPS handling
      media: ov5640: Make the return rate type more explicit
      media: ov5640: Make the FPS clamping / rounding more extendable
      media: ov5640: Add 60 fps support
      media: ov5640: Remove duplicate auto-exposure setup

Michael Grzeschik (2):
      media: mt9m111: add streaming check to set_fmt
      media: mt9m111: add support to select formats and fps for {Q,SXGA}

Michael Tretter (3):
      media: coda: print SEQ_INIT error code as hex value
      media: v4l2-pci-skeleton: replace vb2_buffer with vb2_v4l2_buffer
      media: v4l2-pci-skeleton: depend on CONFIG_SAMPLES

Nathan Chancellor (3):
      media: imx214: Remove unnecessary self assignment in for loop
      media: firewire: Fix app_info parameter type in avc_ca{,_app}_info
      media: ddbridge: Move asm includes after linux ones

Neil Armstrong (3):
      media: cxd2880-spi: fix probe when dvb_attach fails
      media: cxd2880-spi: Add optional vcc regulator
      media: sony-cxd2880: add optional vcc regulator to bindings

Nikita Gerasimov (1):
      media: rtl28xxu: add support for Sony CXD2837ER slave demod

Niklas S=C3=B6derlund (1):
      media: v4l2: async: remove locking when initializing async notifier

Paul Kocialkowski (4):
      media: cedrus: Remove global IRQ spin lock from the driver
      media: dt-bindings: media: cedrus: Add compatibles for the A64 and H5
      media: cedrus: Add device-tree compatible and variant for H5 support
      media: cedrus: Add device-tree compatible and variant for A64 support

Philipp Zabel (14):
      media: coda: fix memory corruption in case more than 32 instances are=
 opened
      media: coda: store unmasked fifo position in meta
      media: coda: always hold back decoder jobs until we have enough bitst=
ream payload
      media: coda: reduce minimum frame size to 48x16 pixels.
      media: coda: remove unused instances list
      media: coda: set V4L2_CAP_TIMEPERFRAME flag in coda_s_parm
      media: coda: implement ENUM_FRAMEINTERVALS
      media: coda: never set infinite timeperframe
      media: coda: fail S_SELECTION for read-only targets
      media: coda: improve queue busy error message
      media: coda: normalise debug output
      media: coda: debug output when setting visible size via crop selection
      media: v4l2: clarify H.264 loop filter offset controls
      media: coda: fix H.264 deblocking filter controls

Rajmohan Mani (1):
      media: intel-ipu3: cio2: Remove redundant definitions

Randy Dunlap (1):
      media: seco-cec: add missing header file to fix build

Ricardo Ribalda Delgado (3):
      media: imx214: device tree binding
      media: imx214: Add imx214 camera sensor driver
      media: doc-rst: Fix broken references

Rob Herring (2):
      media: Use of_node_name_eq for node name comparisons
      media: staging: media: imx: Use of_node_name_eq for node name compari=
sons

Rui Miguel Silva (1):
      media: ov2680: fix null dereference at power on

Sakari Ailus (4):
      media: v4l: uAPI doc: Simplify NATIVE_SIZE selection target documenta=
tion
      media: v4l: uAPI doc: Changing frame interval won't change format
      media: v4l2-mem2mem: Simplify exiting the function in __v4l2_m2m_try_=
schedule
      media: v4l: ioctl: Allow drivers to fill in the format description

Sean Young (9):
      media: rc: XBox DVD Remote uses 12 bits scancodes
      media: rc: imon_raw: use fls rather than loop per bit
      media: saa7134: rc device does not need 'saa7134 IR (' prefix
      media: saa7134: hvr1110 can decode rc6
      media: rc: cec devices do not have a lirc chardev
      media: rc: ensure close() is called on rc_unregister_device
      media: v4l uapi docs: few minor corrections and typos
      media: saa7134: rc-core maintains users count, no need to duplicate
      media: dib7000p: Remove dead code

Sergei Shtylyov (2):
      media: rcar-csi2: add R8A77980 support
      media: rcar-vin: add R8A77980 support

Sergey Dorodnicov (2):
      media: v4l: Add 4bpp packed depth confidence format CNF4
      media: uvcvideo: Add support for the CNF4 format

Stanimir Varbanov (1):
      media: venus: firmware: register separate platform_device for firmwar=
e loader

Tim Harvey (1):
      media: adv7180: add g_skip_frames support

Todor Tomov (2):
      media: camss: Take in account sensor skip frames
      media: MAINTAINERS: Change Todor Tomov's email address

Tomasz Figa (2):
      media: mtk-vcodec: Remove VA from encoder frame buffers
      media: v4l2-device: Link subdevices to their parent devices if availa=
ble

Victor Toso (2):
      media: af9033: Remove duplicated switch statement
      media: dvb: Use WARM definition from identify_state()

Vikash Garodia (4):
      media: venus: firmware: add routine to reset ARM9
      media: venus: firmware: move load firmware in a separate function
      media: venus: firmware: add no TZ boot and shutdown routine
      media: dt-bindings: media: Document bindings for venus firmware device

Vivek Gautam (1):
      media: venus: core: Set dma maximum segment size

Wen Yang (1):
      media: siano: Use kmemdup instead of duplicating its function

Yong Deng (2):
      media: dt-bindings: media: Add Allwinner V3s Camera Sensor Interface =
(CSI)
      media: sun6i: Add support for Allwinner CSI V3s

YueHaibing (1):
      media: imx-pxp: remove duplicated include from imx-pxp.c

kbuild test robot (1):
      media: platform: fix platform_no_drv_owner.cocci warnings

zhong jiang (4):
      media: usb: Use kmemdup instead of duplicating its function.
      media: dvb-frontends: Use kmemdup instead of duplicating its function
      media: remove redundant include moduleparam.h
      media: ddbridge: remove some duplicated include file

 .../devicetree/bindings/media/aspeed-video.txt     |   26 +
 Documentation/devicetree/bindings/media/cedrus.txt |    2 +
 .../devicetree/bindings/media/i2c/mt9m111.txt      |   13 +-
 .../devicetree/bindings/media/i2c/sony,imx214.txt  |   53 +
 .../devicetree/bindings/media/qcom,venus.txt       |   14 +-
 .../devicetree/bindings/media/rcar_vin.txt         |    2 +
 .../bindings/media/renesas,rcar-csi2.txt           |    2 +
 .../devicetree/bindings/media/rockchip-vpu.txt     |   29 +
 .../devicetree/bindings/media/spi/sony-cxd2880.txt |    4 +
 .../devicetree/bindings/media/sun6i-csi.txt        |   59 +
 Documentation/media/.gitignore                     |    2 +
 Documentation/media/Makefile                       |    2 +
 Documentation/media/audio.h.rst.exceptions         |    2 +
 Documentation/media/ca.h.rst.exceptions            |    2 +
 Documentation/media/cec-drivers/index.rst          |    2 +-
 Documentation/media/cec-drivers/pulse8-cec.rst     |    2 +
 Documentation/media/cec.h.rst.exceptions           |    2 +
 Documentation/media/conf.py                        |    2 +
 Documentation/media/conf_nitpick.py                |    2 +
 Documentation/media/dmx.h.rst.exceptions           |    2 +
 Documentation/media/dvb-drivers/avermedia.rst      |    2 +
 Documentation/media/dvb-drivers/bt8xx.rst          |    2 +
 Documentation/media/dvb-drivers/cards.rst          |    2 +
 Documentation/media/dvb-drivers/ci.rst             |    2 +
 Documentation/media/dvb-drivers/contributors.rst   |    2 +
 Documentation/media/dvb-drivers/dvb-usb.rst        |    2 +
 Documentation/media/dvb-drivers/faq.rst            |    2 +
 Documentation/media/dvb-drivers/frontends.rst      |    2 +
 Documentation/media/dvb-drivers/index.rst          |    2 +-
 Documentation/media/dvb-drivers/intro.rst          |    2 +
 Documentation/media/dvb-drivers/lmedm04.rst        |    2 +
 Documentation/media/dvb-drivers/opera-firmware.rst |    2 +
 Documentation/media/dvb-drivers/technisat.rst      |    2 +
 Documentation/media/dvb-drivers/ttusb-dec.rst      |    2 +
 Documentation/media/dvb-drivers/udev.rst           |    2 +
 Documentation/media/frontend.h.rst.exceptions      |    2 +
 Documentation/media/index.rst                      |    2 +
 Documentation/media/intro.rst                      |    2 +-
 Documentation/media/kapi/cec-core.rst              |    2 +
 Documentation/media/kapi/csi2.rst                  |    2 +
 Documentation/media/kapi/dtv-ca.rst                |    2 +
 Documentation/media/kapi/dtv-common.rst            |    2 +
 Documentation/media/kapi/dtv-core.rst              |    2 +
 Documentation/media/kapi/dtv-demux.rst             |    2 +
 Documentation/media/kapi/dtv-frontend.rst          |    2 +
 Documentation/media/kapi/dtv-net.rst               |    2 +
 Documentation/media/kapi/mc-core.rst               |    2 +
 Documentation/media/kapi/rc-core.rst               |    2 +
 Documentation/media/kapi/v4l2-async.rst            |    2 +
 Documentation/media/kapi/v4l2-clocks.rst           |    2 +
 Documentation/media/kapi/v4l2-common.rst           |    2 +
 Documentation/media/kapi/v4l2-controls.rst         |    2 +
 Documentation/media/kapi/v4l2-core.rst             |    2 +
 Documentation/media/kapi/v4l2-dev.rst              |    2 +
 Documentation/media/kapi/v4l2-device.rst           |    2 +
 Documentation/media/kapi/v4l2-dv-timings.rst       |    2 +
 Documentation/media/kapi/v4l2-event.rst            |    1 +
 Documentation/media/kapi/v4l2-fh.rst               |    2 +
 Documentation/media/kapi/v4l2-flash-led-class.rst  |    2 +
 Documentation/media/kapi/v4l2-fwnode.rst           |    2 +
 Documentation/media/kapi/v4l2-intro.rst            |    2 +
 Documentation/media/kapi/v4l2-mc.rst               |    2 +
 Documentation/media/kapi/v4l2-mediabus.rst         |    2 +
 Documentation/media/kapi/v4l2-mem2mem.rst          |    2 +
 Documentation/media/kapi/v4l2-rect.rst             |    2 +
 Documentation/media/kapi/v4l2-subdev.rst           |    2 +
 Documentation/media/kapi/v4l2-tuner.rst            |    2 +
 Documentation/media/kapi/v4l2-tveeprom.rst         |    2 +
 Documentation/media/kapi/v4l2-videobuf.rst         |    2 +
 Documentation/media/kapi/v4l2-videobuf2.rst        |    2 +
 Documentation/media/lirc.h.rst.exceptions          |    2 +
 Documentation/media/media.h.rst.exceptions         |    2 +
 Documentation/media/media_kapi.rst                 |    2 +-
 Documentation/media/media_uapi.rst                 |    8 +-
 Documentation/media/net.h.rst.exceptions           |    2 +
 Documentation/media/typical_media_device.svg       |   10 +
 Documentation/media/uapi/cec/cec-api.rst           |    9 +-
 Documentation/media/uapi/cec/cec-func-close.rst    |    9 +-
 Documentation/media/uapi/cec/cec-func-ioctl.rst    |    9 +-
 Documentation/media/uapi/cec/cec-func-open.rst     |    9 +-
 Documentation/media/uapi/cec/cec-func-poll.rst     |    9 +-
 Documentation/media/uapi/cec/cec-funcs.rst         |    9 +
 Documentation/media/uapi/cec/cec-header.rst        |    9 +-
 Documentation/media/uapi/cec/cec-intro.rst         |    9 +
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |    9 +-
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |    9 +-
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    |    9 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |    9 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    |    9 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |    9 +-
 Documentation/media/uapi/cec/cec-pin-error-inj.rst |    9 +
 .../uapi/dvb/audio-bilingual-channel-select.rst    |    9 +-
 .../media/uapi/dvb/audio-channel-select.rst        |    9 +-
 .../media/uapi/dvb/audio-clear-buffer.rst          |    9 +-
 Documentation/media/uapi/dvb/audio-continue.rst    |    9 +-
 Documentation/media/uapi/dvb/audio-fclose.rst      |    9 +-
 Documentation/media/uapi/dvb/audio-fopen.rst       |    9 +-
 Documentation/media/uapi/dvb/audio-fwrite.rst      |    9 +-
 .../media/uapi/dvb/audio-get-capabilities.rst      |    9 +-
 Documentation/media/uapi/dvb/audio-get-status.rst  |    9 +-
 Documentation/media/uapi/dvb/audio-pause.rst       |    9 +-
 Documentation/media/uapi/dvb/audio-play.rst        |    9 +-
 .../media/uapi/dvb/audio-select-source.rst         |    9 +-
 Documentation/media/uapi/dvb/audio-set-av-sync.rst |    9 +-
 .../media/uapi/dvb/audio-set-bypass-mode.rst       |    9 +-
 Documentation/media/uapi/dvb/audio-set-id.rst      |    9 +-
 Documentation/media/uapi/dvb/audio-set-mixer.rst   |    9 +-
 Documentation/media/uapi/dvb/audio-set-mute.rst    |    9 +-
 .../media/uapi/dvb/audio-set-streamtype.rst        |    9 +-
 Documentation/media/uapi/dvb/audio-stop.rst        |    9 +-
 Documentation/media/uapi/dvb/audio.rst             |    9 +-
 Documentation/media/uapi/dvb/audio_data_types.rst  |    9 +-
 .../media/uapi/dvb/audio_function_calls.rst        |    9 +-
 Documentation/media/uapi/dvb/ca-fclose.rst         |    9 +-
 Documentation/media/uapi/dvb/ca-fopen.rst          |    9 +-
 Documentation/media/uapi/dvb/ca-get-cap.rst        |    9 +-
 Documentation/media/uapi/dvb/ca-get-descr-info.rst |    9 +-
 Documentation/media/uapi/dvb/ca-get-msg.rst        |    9 +-
 Documentation/media/uapi/dvb/ca-get-slot-info.rst  |    9 +-
 Documentation/media/uapi/dvb/ca-reset.rst          |    9 +-
 Documentation/media/uapi/dvb/ca-send-msg.rst       |    9 +-
 Documentation/media/uapi/dvb/ca-set-descr.rst      |    9 +-
 Documentation/media/uapi/dvb/ca.rst                |    9 +-
 Documentation/media/uapi/dvb/ca_data_types.rst     |    9 +-
 Documentation/media/uapi/dvb/ca_function_calls.rst |    9 +-
 Documentation/media/uapi/dvb/demux.rst             |    9 +-
 Documentation/media/uapi/dvb/dmx-add-pid.rst       |    9 +-
 Documentation/media/uapi/dvb/dmx-expbuf.rst        |    9 +
 Documentation/media/uapi/dvb/dmx-fclose.rst        |    9 +-
 Documentation/media/uapi/dvb/dmx-fopen.rst         |    9 +-
 Documentation/media/uapi/dvb/dmx-fread.rst         |    9 +-
 Documentation/media/uapi/dvb/dmx-fwrite.rst        |    9 +-
 Documentation/media/uapi/dvb/dmx-get-pes-pids.rst  |    9 +-
 Documentation/media/uapi/dvb/dmx-get-stc.rst       |    9 +-
 Documentation/media/uapi/dvb/dmx-mmap.rst          |    9 +
 Documentation/media/uapi/dvb/dmx-munmap.rst        |    9 +
 Documentation/media/uapi/dvb/dmx-qbuf.rst          |    9 +
 Documentation/media/uapi/dvb/dmx-querybuf.rst      |    9 +
 Documentation/media/uapi/dvb/dmx-remove-pid.rst    |    9 +-
 Documentation/media/uapi/dvb/dmx-reqbufs.rst       |    9 +
 .../media/uapi/dvb/dmx-set-buffer-size.rst         |    9 +-
 Documentation/media/uapi/dvb/dmx-set-filter.rst    |    9 +-
 .../media/uapi/dvb/dmx-set-pes-filter.rst          |    9 +-
 Documentation/media/uapi/dvb/dmx-start.rst         |    9 +-
 Documentation/media/uapi/dvb/dmx-stop.rst          |    9 +-
 Documentation/media/uapi/dvb/dmx_fcalls.rst        |    9 +-
 Documentation/media/uapi/dvb/dmx_types.rst         |    9 +-
 .../media/uapi/dvb/dvb-fe-read-status.rst          |    9 +-
 .../media/uapi/dvb/dvb-frontend-event.rst          |    9 +-
 .../media/uapi/dvb/dvb-frontend-parameters.rst     |    9 +-
 Documentation/media/uapi/dvb/dvbapi.rst            |    9 +-
 Documentation/media/uapi/dvb/dvbproperty.rst       |    9 +-
 Documentation/media/uapi/dvb/dvbstb.svg            |   27 +
 Documentation/media/uapi/dvb/examples.rst          |    9 +-
 Documentation/media/uapi/dvb/fe-bandwidth-t.rst    |    9 +-
 .../media/uapi/dvb/fe-diseqc-recv-slave-reply.rst  |    9 +-
 .../media/uapi/dvb/fe-diseqc-reset-overload.rst    |    9 +-
 .../media/uapi/dvb/fe-diseqc-send-burst.rst        |    9 +-
 .../media/uapi/dvb/fe-diseqc-send-master-cmd.rst   |    9 +-
 .../uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst    |    9 +-
 .../media/uapi/dvb/fe-enable-high-lnb-voltage.rst  |    9 +-
 Documentation/media/uapi/dvb/fe-get-event.rst      |    9 +-
 Documentation/media/uapi/dvb/fe-get-frontend.rst   |    9 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |    9 +-
 Documentation/media/uapi/dvb/fe-get-property.rst   |    9 +-
 Documentation/media/uapi/dvb/fe-read-ber.rst       |    9 +-
 .../media/uapi/dvb/fe-read-signal-strength.rst     |    9 +-
 Documentation/media/uapi/dvb/fe-read-snr.rst       |    9 +-
 Documentation/media/uapi/dvb/fe-read-status.rst    |    9 +-
 .../media/uapi/dvb/fe-read-uncorrected-blocks.rst  |    9 +-
 .../media/uapi/dvb/fe-set-frontend-tune-mode.rst   |    9 +-
 Documentation/media/uapi/dvb/fe-set-frontend.rst   |    9 +-
 Documentation/media/uapi/dvb/fe-set-tone.rst       |    9 +-
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |    9 +-
 Documentation/media/uapi/dvb/fe-type-t.rst         |    9 +-
 .../media/uapi/dvb/fe_property_parameters.rst      |    9 +-
 Documentation/media/uapi/dvb/frontend-header.rst   |    9 +
 .../uapi/dvb/frontend-property-cable-systems.rst   |    9 +-
 .../dvb/frontend-property-satellite-systems.rst    |    9 +-
 .../dvb/frontend-property-terrestrial-systems.rst  |    9 +-
 .../media/uapi/dvb/frontend-stat-properties.rst    |    9 +-
 Documentation/media/uapi/dvb/frontend.rst          |    9 +-
 Documentation/media/uapi/dvb/frontend_f_close.rst  |    9 +-
 Documentation/media/uapi/dvb/frontend_f_open.rst   |    9 +-
 Documentation/media/uapi/dvb/frontend_fcalls.rst   |    9 +-
 .../media/uapi/dvb/frontend_legacy_api.rst         |    9 +-
 .../media/uapi/dvb/frontend_legacy_dvbv3_api.rst   |    9 +-
 Documentation/media/uapi/dvb/headers.rst           |    9 +
 Documentation/media/uapi/dvb/intro.rst             |    9 +-
 Documentation/media/uapi/dvb/legacy_dvb_apis.rst   |    9 +-
 Documentation/media/uapi/dvb/net-add-if.rst        |    9 +-
 Documentation/media/uapi/dvb/net-get-if.rst        |    9 +-
 Documentation/media/uapi/dvb/net-remove-if.rst     |    9 +-
 Documentation/media/uapi/dvb/net-types.rst         |    9 +-
 Documentation/media/uapi/dvb/net.rst               |    9 +-
 .../media/uapi/dvb/query-dvb-frontend-info.rst     |    9 +-
 .../media/uapi/dvb/video-clear-buffer.rst          |    9 +-
 Documentation/media/uapi/dvb/video-command.rst     |    9 +-
 Documentation/media/uapi/dvb/video-continue.rst    |    9 +-
 .../media/uapi/dvb/video-fast-forward.rst          |    9 +-
 Documentation/media/uapi/dvb/video-fclose.rst      |    9 +-
 Documentation/media/uapi/dvb/video-fopen.rst       |    9 +-
 Documentation/media/uapi/dvb/video-freeze.rst      |    9 +-
 Documentation/media/uapi/dvb/video-fwrite.rst      |    9 +-
 .../media/uapi/dvb/video-get-capabilities.rst      |    9 +-
 Documentation/media/uapi/dvb/video-get-event.rst   |    9 +-
 .../media/uapi/dvb/video-get-frame-count.rst       |    9 +-
 Documentation/media/uapi/dvb/video-get-pts.rst     |    9 +-
 Documentation/media/uapi/dvb/video-get-size.rst    |    9 +-
 Documentation/media/uapi/dvb/video-get-status.rst  |    9 +-
 Documentation/media/uapi/dvb/video-play.rst        |    9 +-
 .../media/uapi/dvb/video-select-source.rst         |    9 +-
 Documentation/media/uapi/dvb/video-set-blank.rst   |    9 +-
 .../media/uapi/dvb/video-set-display-format.rst    |    9 +-
 Documentation/media/uapi/dvb/video-set-format.rst  |    9 +-
 .../media/uapi/dvb/video-set-streamtype.rst        |    9 +-
 Documentation/media/uapi/dvb/video-slowmotion.rst  |    9 +-
 .../media/uapi/dvb/video-stillpicture.rst          |    9 +-
 Documentation/media/uapi/dvb/video-stop.rst        |    9 +-
 Documentation/media/uapi/dvb/video-try-command.rst |    9 +-
 Documentation/media/uapi/dvb/video.rst             |    9 +-
 .../media/uapi/dvb/video_function_calls.rst        |    9 +-
 Documentation/media/uapi/dvb/video_types.rst       |    9 +-
 Documentation/media/uapi/fdl-appendix.rst          |    9 +-
 Documentation/media/uapi/gen-errors.rst            |    9 +-
 .../media/uapi/mediactl/media-controller-intro.rst |    9 +-
 .../media/uapi/mediactl/media-controller-model.rst |    9 +-
 .../media/uapi/mediactl/media-controller.rst       |    9 +-
 .../media/uapi/mediactl/media-func-close.rst       |    9 +-
 .../media/uapi/mediactl/media-func-ioctl.rst       |    9 +-
 .../media/uapi/mediactl/media-func-open.rst        |    9 +-
 Documentation/media/uapi/mediactl/media-funcs.rst  |    9 +
 Documentation/media/uapi/mediactl/media-header.rst |    9 +-
 .../media/uapi/mediactl/media-ioc-device-info.rst  |    9 +-
 .../uapi/mediactl/media-ioc-enum-entities.rst      |    9 +-
 .../media/uapi/mediactl/media-ioc-enum-links.rst   |    9 +-
 .../media/uapi/mediactl/media-ioc-g-topology.rst   |    9 +-
 .../uapi/mediactl/media-ioc-request-alloc.rst      |    6 +-
 .../media/uapi/mediactl/media-ioc-setup-link.rst   |    9 +-
 .../uapi/mediactl/media-request-ioc-queue.rst      |    6 +-
 .../uapi/mediactl/media-request-ioc-reinit.rst     |    6 +-
 Documentation/media/uapi/mediactl/media-types.rst  |    9 +-
 Documentation/media/uapi/mediactl/request-api.rst  |    6 +-
 .../media/uapi/mediactl/request-func-close.rst     |    6 +-
 .../media/uapi/mediactl/request-func-ioctl.rst     |    6 +-
 .../media/uapi/mediactl/request-func-poll.rst      |    6 +-
 Documentation/media/uapi/rc/keytable.c.rst         |    9 +-
 Documentation/media/uapi/rc/lirc-dev-intro.rst     |    9 +-
 Documentation/media/uapi/rc/lirc-dev.rst           |    9 +-
 Documentation/media/uapi/rc/lirc-func.rst          |    9 +-
 Documentation/media/uapi/rc/lirc-get-features.rst  |    9 +-
 Documentation/media/uapi/rc/lirc-get-rec-mode.rst  |    9 +-
 .../media/uapi/rc/lirc-get-rec-resolution.rst      |    9 +-
 Documentation/media/uapi/rc/lirc-get-send-mode.rst |    9 +-
 Documentation/media/uapi/rc/lirc-get-timeout.rst   |    9 +-
 Documentation/media/uapi/rc/lirc-header.rst        |    9 +-
 Documentation/media/uapi/rc/lirc-read.rst          |    9 +-
 .../uapi/rc/lirc-set-measure-carrier-mode.rst      |    9 +-
 .../media/uapi/rc/lirc-set-rec-carrier-range.rst   |    9 +-
 .../media/uapi/rc/lirc-set-rec-carrier.rst         |    9 +-
 .../media/uapi/rc/lirc-set-rec-timeout-reports.rst |    9 +-
 .../media/uapi/rc/lirc-set-rec-timeout.rst         |    9 +-
 .../media/uapi/rc/lirc-set-send-carrier.rst        |    9 +-
 .../media/uapi/rc/lirc-set-send-duty-cycle.rst     |    9 +-
 .../media/uapi/rc/lirc-set-transmitter-mask.rst    |    9 +-
 .../media/uapi/rc/lirc-set-wideband-receiver.rst   |    9 +-
 Documentation/media/uapi/rc/lirc-write.rst         |    9 +-
 Documentation/media/uapi/rc/rc-intro.rst           |    9 +-
 Documentation/media/uapi/rc/rc-sysfs-nodes.rst     |    9 +-
 Documentation/media/uapi/rc/rc-table-change.rst    |    9 +-
 Documentation/media/uapi/rc/rc-tables.rst          |    9 +-
 Documentation/media/uapi/rc/remote_controllers.rst |    9 +-
 Documentation/media/uapi/v4l/app-pri.rst           |   11 +-
 Documentation/media/uapi/v4l/async.rst             |    9 +-
 Documentation/media/uapi/v4l/audio.rst             |   11 +-
 Documentation/media/uapi/v4l/bayer.svg             |   27 +
 Documentation/media/uapi/v4l/biblio.rst            |    9 +-
 Documentation/media/uapi/v4l/buffer.rst            |    9 +-
 Documentation/media/uapi/v4l/capture-example.rst   |    9 +-
 Documentation/media/uapi/v4l/capture.c.rst         |    9 +-
 Documentation/media/uapi/v4l/colorspaces-defs.rst  |    9 +-
 .../media/uapi/v4l/colorspaces-details.rst         |    9 +-
 Documentation/media/uapi/v4l/colorspaces.rst       |    9 +-
 Documentation/media/uapi/v4l/common-defs.rst       |    9 +-
 Documentation/media/uapi/v4l/common.rst            |    9 +-
 Documentation/media/uapi/v4l/compat.rst            |    9 +-
 Documentation/media/uapi/v4l/constraints.svg       |   27 +
 Documentation/media/uapi/v4l/control.rst           |    9 +-
 Documentation/media/uapi/v4l/crop.rst              |    9 +-
 Documentation/media/uapi/v4l/crop.svg              |   10 +-
 Documentation/media/uapi/v4l/depth-formats.rst     |   10 +-
 Documentation/media/uapi/v4l/dev-capture.rst       |   11 +-
 Documentation/media/uapi/v4l/dev-codec.rst         |    9 +-
 Documentation/media/uapi/v4l/dev-effect.rst        |    9 +-
 Documentation/media/uapi/v4l/dev-event.rst         |    9 +-
 Documentation/media/uapi/v4l/dev-meta.rst          |    9 +-
 Documentation/media/uapi/v4l/dev-osd.rst           |    9 +-
 Documentation/media/uapi/v4l/dev-output.rst        |    9 +-
 Documentation/media/uapi/v4l/dev-overlay.rst       |    9 +-
 Documentation/media/uapi/v4l/dev-radio.rst         |    9 +-
 Documentation/media/uapi/v4l/dev-raw-vbi.rst       |    9 +-
 Documentation/media/uapi/v4l/dev-rds.rst           |    9 +-
 Documentation/media/uapi/v4l/dev-sdr.rst           |    9 +-
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |    9 +-
 Documentation/media/uapi/v4l/dev-subdev.rst        |    9 +-
 Documentation/media/uapi/v4l/dev-teletext.rst      |   11 +-
 Documentation/media/uapi/v4l/dev-touch.rst         |    9 +-
 Documentation/media/uapi/v4l/devices.rst           |    9 +-
 Documentation/media/uapi/v4l/diff-v4l.rst          |    9 +-
 Documentation/media/uapi/v4l/dmabuf.rst            |    9 +-
 Documentation/media/uapi/v4l/dv-timings.rst        |    9 +-
 Documentation/media/uapi/v4l/extended-controls.rst |   15 +-
 Documentation/media/uapi/v4l/field-order.rst       |    9 +-
 Documentation/media/uapi/v4l/fieldseq_bt.svg       |   12 +-
 Documentation/media/uapi/v4l/fieldseq_tb.svg       |   12 +-
 Documentation/media/uapi/v4l/format.rst            |   11 +-
 Documentation/media/uapi/v4l/func-close.rst        |    9 +-
 Documentation/media/uapi/v4l/func-ioctl.rst        |    9 +-
 Documentation/media/uapi/v4l/func-mmap.rst         |    9 +-
 Documentation/media/uapi/v4l/func-munmap.rst       |    9 +-
 Documentation/media/uapi/v4l/func-open.rst         |    9 +-
 Documentation/media/uapi/v4l/func-poll.rst         |    9 +-
 Documentation/media/uapi/v4l/func-read.rst         |    9 +-
 Documentation/media/uapi/v4l/func-select.rst       |    9 +-
 Documentation/media/uapi/v4l/func-write.rst        |    9 +-
 Documentation/media/uapi/v4l/hist-v4l2.rst         |    9 +-
 Documentation/media/uapi/v4l/hsv-formats.rst       |    9 +-
 Documentation/media/uapi/v4l/io.rst                |    9 +-
 .../media/uapi/v4l/libv4l-introduction.rst         |    9 +-
 Documentation/media/uapi/v4l/libv4l.rst            |    9 +-
 Documentation/media/uapi/v4l/meta-formats.rst      |    9 +-
 Documentation/media/uapi/v4l/mmap.rst              |   31 +-
 Documentation/media/uapi/v4l/nv12mt.svg            |   27 +
 Documentation/media/uapi/v4l/nv12mt_example.svg    |   27 +
 Documentation/media/uapi/v4l/open.rst              |   11 +-
 Documentation/media/uapi/v4l/pipeline.dot          |    2 +
 Documentation/media/uapi/v4l/pixfmt-cnf4.rst       |   31 +
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |    9 +-
 Documentation/media/uapi/v4l/pixfmt-grey.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-indexed.rst    |    9 +-
 Documentation/media/uapi/v4l/pixfmt-intro.rst      |    9 +-
 Documentation/media/uapi/v4l/pixfmt-inzi.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-m420.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-meta-d4xx.rst  |    9 +-
 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst   |    9 +-
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst        |    9 +-
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst        |    9 +-
 Documentation/media/uapi/v4l/pixfmt-nv12.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-nv12m.rst      |    9 +-
 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst     |    9 +-
 Documentation/media/uapi/v4l/pixfmt-nv16.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-nv16m.rst      |    9 +-
 Documentation/media/uapi/v4l/pixfmt-nv24.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst |    9 +-
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst |    9 +-
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst |    9 +-
 Documentation/media/uapi/v4l/pixfmt-reserved.rst   |    9 +-
 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    9 +-
 Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst   |    9 +-
 Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst |    9 +-
 Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst   |    9 +-
 Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst |    9 +-
 .../media/uapi/v4l/pixfmt-sdr-pcu16be.rst          |    9 +-
 .../media/uapi/v4l/pixfmt-sdr-pcu18be.rst          |    9 +-
 .../media/uapi/v4l/pixfmt-sdr-pcu20be.rst          |   10 +-
 Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst |    9 +-
 .../media/uapi/v4l/pixfmt-srggb10-ipu3.rst         |    9 +-
 Documentation/media/uapi/v4l/pixfmt-srggb10.rst    |    9 +-
 .../media/uapi/v4l/pixfmt-srggb10alaw8.rst         |    9 +-
 .../media/uapi/v4l/pixfmt-srggb10dpcm8.rst         |    9 +-
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst   |    9 +-
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst    |    9 +-
 Documentation/media/uapi/v4l/pixfmt-srggb12p.rst   |    9 +-
 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst   |    9 +-
 Documentation/media/uapi/v4l/pixfmt-srggb16.rst    |    9 +-
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst     |    9 +-
 Documentation/media/uapi/v4l/pixfmt-tch-td08.rst   |    9 +-
 Documentation/media/uapi/v4l/pixfmt-tch-td16.rst   |    9 +-
 Documentation/media/uapi/v4l/pixfmt-tch-tu08.rst   |    9 +-
 Documentation/media/uapi/v4l/pixfmt-tch-tu16.rst   |    9 +-
 Documentation/media/uapi/v4l/pixfmt-uv8.rst        |    9 +-
 Documentation/media/uapi/v4l/pixfmt-uyvy.rst       |    9 +-
 .../media/uapi/v4l/pixfmt-v4l2-mplane.rst          |    9 +-
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-vyuy.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-y10.rst        |    9 +-
 Documentation/media/uapi/v4l/pixfmt-y10b.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-y10p.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-y12.rst        |    9 +-
 Documentation/media/uapi/v4l/pixfmt-y12i.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-y16-be.rst     |    9 +-
 Documentation/media/uapi/v4l/pixfmt-y16.rst        |    9 +-
 Documentation/media/uapi/v4l/pixfmt-y41p.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-y8i.rst        |    9 +-
 Documentation/media/uapi/v4l/pixfmt-yuv410.rst     |    9 +-
 Documentation/media/uapi/v4l/pixfmt-yuv411p.rst    |    9 +-
 Documentation/media/uapi/v4l/pixfmt-yuv420.rst     |    9 +-
 Documentation/media/uapi/v4l/pixfmt-yuv420m.rst    |    9 +-
 Documentation/media/uapi/v4l/pixfmt-yuv422m.rst    |    9 +-
 Documentation/media/uapi/v4l/pixfmt-yuv422p.rst    |    9 +-
 Documentation/media/uapi/v4l/pixfmt-yuv444m.rst    |    9 +-
 Documentation/media/uapi/v4l/pixfmt-yuyv.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-yvyu.rst       |    9 +-
 Documentation/media/uapi/v4l/pixfmt-z16.rst        |    9 +-
 Documentation/media/uapi/v4l/pixfmt.rst            |    9 +-
 Documentation/media/uapi/v4l/planar-apis.rst       |    9 +-
 Documentation/media/uapi/v4l/querycap.rst          |    9 +-
 Documentation/media/uapi/v4l/rw.rst                |    9 +-
 Documentation/media/uapi/v4l/sdr-formats.rst       |    9 +-
 .../media/uapi/v4l/selection-api-configuration.rst |    9 +-
 .../media/uapi/v4l/selection-api-examples.rst      |    9 +-
 .../media/uapi/v4l/selection-api-intro.rst         |    9 +-
 .../media/uapi/v4l/selection-api-targets.rst       |    9 +-
 .../media/uapi/v4l/selection-api-vs-crop-api.rst   |    9 +-
 Documentation/media/uapi/v4l/selection-api.rst     |    9 +-
 Documentation/media/uapi/v4l/selection.svg         |   27 +
 Documentation/media/uapi/v4l/selections-common.rst |    9 +-
 Documentation/media/uapi/v4l/standard.rst          |    9 +-
 Documentation/media/uapi/v4l/streaming-par.rst     |    9 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    |    9 +-
 .../uapi/v4l/subdev-image-processing-crop.svg      |   10 +
 .../uapi/v4l/subdev-image-processing-full.svg      |   10 +
 ...ubdev-image-processing-scaling-multi-source.svg |   10 +
 Documentation/media/uapi/v4l/tch-formats.rst       |    9 +-
 Documentation/media/uapi/v4l/tuner.rst             |   13 +-
 Documentation/media/uapi/v4l/user-func.rst         |    9 +-
 Documentation/media/uapi/v4l/userp.rst             |   17 +-
 .../media/uapi/v4l/v4l2-selection-flags.rst        |    9 +-
 .../media/uapi/v4l/v4l2-selection-targets.rst      |   16 +-
 Documentation/media/uapi/v4l/v4l2.rst              |    9 +-
 Documentation/media/uapi/v4l/v4l2grab-example.rst  |    9 +-
 Documentation/media/uapi/v4l/v4l2grab.c.rst        |    9 +-
 Documentation/media/uapi/v4l/vbi_525.svg           |   12 +-
 Documentation/media/uapi/v4l/vbi_625.svg           |   12 +-
 Documentation/media/uapi/v4l/vbi_hsync.svg         |   12 +-
 Documentation/media/uapi/v4l/video.rst             |   13 +-
 Documentation/media/uapi/v4l/videodev.rst          |    9 +-
 .../media/uapi/v4l/vidioc-create-bufs.rst          |    9 +-
 Documentation/media/uapi/v4l/vidioc-cropcap.rst    |    9 +-
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |    9 +-
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |    9 +-
 .../media/uapi/v4l/vidioc-decoder-cmd.rst          |    9 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |    9 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |    9 +-
 .../media/uapi/v4l/vidioc-encoder-cmd.rst          |    9 +-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |    9 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   17 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |    9 +-
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |    9 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |    9 +-
 Documentation/media/uapi/v4l/vidioc-enumaudio.rst  |    9 +-
 .../media/uapi/v4l/vidioc-enumaudioout.rst         |    9 +-
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |    9 +-
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst |    9 +-
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |    9 +-
 Documentation/media/uapi/v4l/vidioc-expbuf.rst     |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-audio.rst    |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-crop.rst     |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-ctrl.rst     |    9 +-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     |    9 +-
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |    9 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst     |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst      |    9 +-
 .../media/uapi/v4l/vidioc-g-frequency.rst          |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-input.rst    |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst |    9 +-
 .../media/uapi/v4l/vidioc-g-modulator.rst          |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-output.rst   |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |   12 +-
 Documentation/media/uapi/v4l/vidioc-g-priority.rst |    9 +-
 .../media/uapi/v4l/vidioc-g-selection.rst          |    9 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-std.rst      |    9 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |    9 +-
 Documentation/media/uapi/v4l/vidioc-log-status.rst |    9 +-
 Documentation/media/uapi/v4l/vidioc-overlay.rst    |    9 +-
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |    9 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |    9 +-
 .../media/uapi/v4l/vidioc-query-dv-timings.rst     |    9 +-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |    9 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |    9 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |    9 +-
 Documentation/media/uapi/v4l/vidioc-querystd.rst   |    9 +-
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst    |   26 +-
 .../media/uapi/v4l/vidioc-s-hw-freq-seek.rst       |    9 +-
 Documentation/media/uapi/v4l/vidioc-streamon.rst   |    9 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst |    9 +-
 .../uapi/v4l/vidioc-subdev-enum-frame-size.rst     |    9 +-
 .../uapi/v4l/vidioc-subdev-enum-mbus-code.rst      |    9 +-
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |    9 +-
 .../media/uapi/v4l/vidioc-subdev-g-fmt.rst         |    9 +-
 .../uapi/v4l/vidioc-subdev-g-frame-interval.rst    |   12 +-
 .../media/uapi/v4l/vidioc-subdev-g-selection.rst   |    9 +-
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |    9 +-
 Documentation/media/uapi/v4l/yuv-formats.rst       |    9 +-
 .../media/v4l-drivers/au0828-cardlist.rst          |    2 +
 Documentation/media/v4l-drivers/bttv-cardlist.rst  |    2 +
 Documentation/media/v4l-drivers/bttv.rst           |    2 +
 Documentation/media/v4l-drivers/cafe_ccic.rst      |    2 +
 Documentation/media/v4l-drivers/cardlist.rst       |    2 +
 Documentation/media/v4l-drivers/cpia2.rst          |    2 +
 Documentation/media/v4l-drivers/cx18.rst           |    2 +
 Documentation/media/v4l-drivers/cx2341x.rst        |    2 +
 .../media/v4l-drivers/cx23885-cardlist.rst         |    2 +
 Documentation/media/v4l-drivers/cx88-cardlist.rst  |    2 +
 Documentation/media/v4l-drivers/cx88.rst           |    2 +
 Documentation/media/v4l-drivers/davinci-vpbe.rst   |    2 +
 .../media/v4l-drivers/em28xx-cardlist.rst          |    4 +-
 Documentation/media/v4l-drivers/fimc.rst           |    2 +
 Documentation/media/v4l-drivers/fourcc.rst         |    2 +
 Documentation/media/v4l-drivers/gspca-cardlist.rst |    2 +
 Documentation/media/v4l-drivers/imx.rst            |    2 +
 Documentation/media/v4l-drivers/index.rst          |    2 +-
 Documentation/media/v4l-drivers/ivtv-cardlist.rst  |    2 +
 Documentation/media/v4l-drivers/ivtv.rst           |    1 +
 Documentation/media/v4l-drivers/max2175.rst        |    2 +
 Documentation/media/v4l-drivers/meye.rst           |    2 +
 Documentation/media/v4l-drivers/omap3isp.rst       |    2 +
 Documentation/media/v4l-drivers/omap4_camera.rst   |    2 +
 Documentation/media/v4l-drivers/philips.rst        |    2 +
 Documentation/media/v4l-drivers/pvrusb2.rst        |    2 +
 Documentation/media/v4l-drivers/pxa_camera.rst     |    2 +
 Documentation/media/v4l-drivers/qcom_camss.rst     |    2 +
 .../media/v4l-drivers/qcom_camss_8x96_graph.dot    |    2 +
 .../media/v4l-drivers/qcom_camss_graph.dot         |    2 +
 Documentation/media/v4l-drivers/radiotrack.rst     |    2 +
 Documentation/media/v4l-drivers/rcar-fdp1.rst      |    2 +
 .../media/v4l-drivers/saa7134-cardlist.rst         |    2 +
 Documentation/media/v4l-drivers/saa7134.rst        |    2 +
 .../media/v4l-drivers/saa7164-cardlist.rst         |    2 +
 .../media/v4l-drivers/sh_mobile_ceu_camera.rst     |    4 +-
 Documentation/media/v4l-drivers/si470x.rst         |    2 +
 Documentation/media/v4l-drivers/si4713.rst         |    2 +
 Documentation/media/v4l-drivers/si476x.rst         |    2 +
 Documentation/media/v4l-drivers/soc-camera.rst     |    2 +
 .../media/v4l-drivers/tm6000-cardlist.rst          |    2 +
 Documentation/media/v4l-drivers/tuner-cardlist.rst |    2 +
 Documentation/media/v4l-drivers/tuners.rst         |    2 +
 .../media/v4l-drivers/usbvision-cardlist.rst       |    2 +
 Documentation/media/v4l-drivers/uvcvideo.rst       |    2 +
 Documentation/media/v4l-drivers/v4l-with-ir.rst    |    2 +
 Documentation/media/v4l-drivers/vivid.rst          |    2 +
 Documentation/media/v4l-drivers/zoran.rst          |    2 +
 Documentation/media/v4l-drivers/zr364xx.rst        |    2 +
 Documentation/media/video.h.rst.exceptions         |    2 +
 Documentation/media/videodev2.h.rst.exceptions     |    2 +
 MAINTAINERS                                        |   55 +-
 drivers/media/cec/cec-adap.c                       |   34 +-
 drivers/media/cec/cec-core.c                       |    6 +
 drivers/media/cec/cec-pin.c                        |    5 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |    2 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |   25 +-
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |    3 +-
 drivers/media/dvb-core/dvb_frontend.c              |   11 +-
 drivers/media/dvb-frontends/af9033.c               |   12 +-
 drivers/media/dvb-frontends/dib0090.c              |   32 +-
 drivers/media/dvb-frontends/dib7000p.c             |    7 +-
 drivers/media/dvb-frontends/drxk_hard.c            |    8 +-
 drivers/media/dvb-frontends/lgdt3306a.c            |    6 +-
 drivers/media/dvb-frontends/mxl5xx.c               |    2 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |    1 -
 drivers/media/firewire/firedtv-avc.c               |    6 +-
 drivers/media/firewire/firedtv.h                   |    6 +-
 drivers/media/i2c/Kconfig                          |   15 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ad9389b.c                        |    2 +-
 drivers/media/i2c/adv7180.c                        |   15 +
 drivers/media/i2c/adv7511.c                        |    2 +-
 drivers/media/i2c/adv7604.c                        |   68 +-
 drivers/media/i2c/adv7842.c                        |    4 +-
 drivers/media/i2c/imx214.c                         | 1118 +++++++++++++
 drivers/media/i2c/imx258.c                         |   28 +-
 drivers/media/i2c/imx274.c                         |    9 +-
 drivers/media/i2c/imx319.c                         |    8 +-
 drivers/media/i2c/imx355.c                         |    8 +-
 drivers/media/i2c/mt9m111.c                        |  266 ++-
 drivers/media/i2c/ov13858.c                        |    6 +-
 drivers/media/i2c/ov2640.c                         |   21 +-
 drivers/media/i2c/ov2680.c                         |   12 +-
 drivers/media/i2c/ov5640.c                         |  771 +++++----
 drivers/media/i2c/ov5645.c                         |    2 +-
 drivers/media/i2c/ov7670.c                         |    6 +-
 drivers/media/i2c/ov772x.c                         |    7 +-
 drivers/media/i2c/ov7740.c                         |    4 +-
 drivers/media/i2c/tc358743.c                       |    2 +-
 drivers/media/i2c/tda7432.c                        |    4 +-
 drivers/media/i2c/ths8200.c                        |    2 +-
 drivers/media/i2c/tvp5150.c                        |    2 +-
 drivers/media/i2c/video-i2c.c                      |  300 +++-
 drivers/media/pci/b2c2/flexcop-dma.c               |   70 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   12 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |   48 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |   13 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   55 +-
 drivers/media/pci/cx23885/cx23885-i2c.c            |    1 -
 drivers/media/pci/cx23885/cx23885-video.c          |   40 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +
 drivers/media/pci/ddbridge/ddbridge.h              |   48 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.h           |    2 -
 drivers/media/pci/ivtv/ivtv-ioctl.c                |   17 +-
 drivers/media/pci/mantis/mantis_cards.c            |    1 -
 drivers/media/pci/saa7134/saa7134-core.c           |    8 +-
 drivers/media/pci/saa7134/saa7134-input.c          |  115 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   21 +-
 drivers/media/pci/saa7134/saa7134.h                |   10 +-
 drivers/media/platform/Kconfig                     |   32 +
 drivers/media/platform/Makefile                    |    5 +
 drivers/media/platform/am437x/am437x-vpfe.c        |   31 +-
 drivers/media/platform/aspeed-video.c              | 1729 ++++++++++++++++=
++++
 drivers/media/platform/coda/coda-bit.c             |  132 +-
 drivers/media/platform/coda/coda-common.c          |  246 +--
 drivers/media/platform/coda/coda.h                 |   34 +-
 drivers/media/platform/coda/coda_regs.h            |    2 +-
 drivers/media/platform/coda/trace.h                |   10 +-
 drivers/media/platform/davinci/vpbe.c              |   30 +-
 drivers/media/platform/davinci/vpbe_display.c      |   10 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   12 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |   57 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    3 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   23 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    6 +-
 drivers/media/platform/exynos4-is/fimc-is-errno.c  |    4 +-
 drivers/media/platform/exynos4-is/fimc-is-errno.h  |    2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |  130 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   12 +-
 drivers/media/platform/imx-pxp.c                   |   18 +-
 drivers/media/platform/marvell-ccic/cafe-driver.c  |    2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |    6 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |   10 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |    5 +
 drivers/media/platform/mtk-vcodec/venc_drv_if.h    |    2 +-
 drivers/media/platform/qcom/camss/camss-vfe.c      |   23 +-
 drivers/media/platform/qcom/camss/camss.c          |    2 +-
 drivers/media/platform/qcom/camss/camss.h          |    1 +
 drivers/media/platform/qcom/venus/core.c           |   32 +-
 drivers/media/platform/qcom/venus/core.h           |    6 +
 drivers/media/platform/qcom/venus/firmware.c       |  235 ++-
 drivers/media/platform/qcom/venus/firmware.h       |   17 +-
 drivers/media/platform/qcom/venus/hfi_cmds.c       |    2 +-
 drivers/media/platform/qcom/venus/hfi_venus.c      |   15 +-
 drivers/media/platform/qcom/venus/hfi_venus_io.h   |    8 +
 drivers/media/platform/qcom/venus/vdec.c           |    4 +-
 drivers/media/platform/qcom/venus/venc.c           |   23 +-
 drivers/media/platform/qcom/venus/venc_ctrls.c     |   36 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |   52 +
 drivers/media/platform/rcar-vin/rcar-csi2.c        |   97 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   10 +-
 drivers/media/platform/rockchip/rga/rga.c          |    4 +-
 drivers/media/platform/s5p-g2d/g2d.c               |  102 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   49 +-
 drivers/media/platform/seco-cec/Makefile           |    1 +
 drivers/media/platform/seco-cec/seco-cec.c         |  796 +++++++++
 drivers/media/platform/seco-cec/seco-cec.h         |  141 ++
 drivers/media/platform/sh_vou.c                    |    2 +-
 drivers/media/platform/sti/bdisp/bdisp-hw.c        |    2 +-
 drivers/media/platform/sunxi/sun6i-csi/Kconfig     |    9 +
 drivers/media/platform/sunxi/sun6i-csi/Makefile    |    3 +
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c |  913 +++++++++++
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h |  135 ++
 .../media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h |  196 +++
 .../media/platform/sunxi/sun6i-csi/sun6i_video.c   |  679 ++++++++
 .../media/platform/sunxi/sun6i-csi/sun6i_video.h   |   38 +
 drivers/media/platform/ti-vpe/cal.c                |    4 +-
 drivers/media/platform/vicodec/codec-fwht.c        |   84 +-
 drivers/media/platform/vicodec/codec-fwht.h        |   15 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c   |  122 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.h   |    3 +-
 drivers/media/platform/vicodec/vicodec-core.c      |  143 +-
 drivers/media/platform/vim2m.c                     |    6 +-
 drivers/media/platform/vimc/vimc-common.c          |    2 +
 drivers/media/platform/vimc/vimc-sensor.c          |    2 +-
 drivers/media/platform/vivid/vivid-core.c          |   48 +-
 drivers/media/platform/vivid/vivid-core.h          |    5 +
 drivers/media/platform/vivid/vivid-ctrls.c         |   16 +
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   56 +-
 drivers/media/platform/vivid/vivid-kthread-out.c   |    5 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |    4 -
 drivers/media/platform/vivid/vivid-vid-cap.c       |   29 +-
 drivers/media/platform/vivid/vivid-vid-cap.h       |    2 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |    2 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |   18 +-
 drivers/media/platform/vivid/vivid-vid-out.h       |    2 +-
 drivers/media/platform/xilinx/Kconfig              |    2 +
 drivers/media/platform/xilinx/Makefile             |    2 +
 drivers/media/platform/xilinx/xilinx-dma.c         |    5 +-
 drivers/media/platform/xilinx/xilinx-dma.h         |    5 +-
 drivers/media/platform/xilinx/xilinx-tpg.c         |    7 +-
 drivers/media/platform/xilinx/xilinx-vip.c         |    7 +-
 drivers/media/platform/xilinx/xilinx-vip.h         |    5 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |    5 +-
 drivers/media/platform/xilinx/xilinx-vipp.h        |    5 +-
 drivers/media/platform/xilinx/xilinx-vtc.c         |    5 +-
 drivers/media/platform/xilinx/xilinx-vtc.h         |    5 +-
 drivers/media/rc/Kconfig                           |   12 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/imon.c                            |    4 +-
 drivers/media/rc/imon_raw.c                        |   47 +-
 drivers/media/rc/keymaps/Makefile                  |    1 +
 drivers/media/rc/keymaps/rc-xbox-dvd.c             |   63 +
 drivers/media/rc/mceusb.c                          |    9 +
 drivers/media/rc/rc-main.c                         |    8 +-
 drivers/media/rc/xbox_remote.c                     |  306 ++++
 drivers/media/spi/cxd2880-spi.c                    |   17 +
 drivers/media/usb/au0828/au0828-video.c            |   38 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                |   31 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   41 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   41 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |    1 +
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |    6 +-
 drivers/media/usb/dvb-usb-v2/gl861.c               |    3 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |  102 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   40 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h            |    4 +-
 drivers/media/usb/dvb-usb-v2/usb_urb.c             |    5 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |    2 +-
 drivers/media/usb/dvb-usb/friio-fe.c               |  440 -----
 drivers/media/usb/dvb-usb/friio.c                  |  522 ------
 drivers/media/usb/dvb-usb/friio.h                  |   99 --
 drivers/media/usb/em28xx/em28xx-cards.c            |    2 +-
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   13 +-
 drivers/media/usb/siano/smsusb.c                   |    3 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   13 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   83 +-
 drivers/media/usb/uvc/uvc_isight.c                 |    6 +-
 drivers/media/usb/uvc/uvc_queue.c                  |  110 +-
 drivers/media/usb/uvc/uvc_status.c                 |   12 +-
 drivers/media/usb/uvc/uvc_video.c                  |  274 ++--
 drivers/media/usb/uvc/uvcvideo.h                   |   69 +-
 drivers/media/v4l2-core/Kconfig                    |    1 +
 drivers/media/v4l2-core/v4l2-async.c               |    4 -
 drivers/media/v4l2-core/v4l2-ctrls.c               |    3 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |    8 +-
 drivers/media/v4l2-core/v4l2-device.c              |    1 +
 drivers/media/v4l2-core/v4l2-fwnode.c              |    8 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  106 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   66 +-
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/bcm2048/radio-bcm2048.c      |    5 +-
 drivers/staging/media/imx/imx-media-of.c           |    2 +-
 drivers/staging/media/rockchip/vpu/Kconfig         |   13 +
 drivers/staging/media/rockchip/vpu/Makefile        |   10 +
 drivers/staging/media/rockchip/vpu/TODO            |   13 +
 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c |  118 ++
 .../media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c    |  125 ++
 .../staging/media/rockchip/vpu/rk3288_vpu_regs.h   |  442 +++++
 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c |  118 ++
 .../media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c    |  159 ++
 .../staging/media/rockchip/vpu/rk3399_vpu_regs.h   |  600 +++++++
 drivers/staging/media/rockchip/vpu/rockchip_vpu.h  |  232 +++
 .../media/rockchip/vpu/rockchip_vpu_common.h       |   29 +
 .../staging/media/rockchip/vpu/rockchip_vpu_drv.c  |  537 ++++++
 .../staging/media/rockchip/vpu/rockchip_vpu_enc.c  |  670 ++++++++
 .../staging/media/rockchip/vpu/rockchip_vpu_hw.h   |   58 +
 .../staging/media/rockchip/vpu/rockchip_vpu_jpeg.c |  290 ++++
 .../staging/media/rockchip/vpu/rockchip_vpu_jpeg.h |   14 +
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   23 +-
 drivers/staging/media/sunxi/cedrus/cedrus.h        |    2 -
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c    |   11 +-
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c     |   37 +-
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  |    5 -
 drivers/staging/media/tegra-vde/tegra-vde.c        |  222 +--
 drivers/staging/media/tegra-vde/trace.h            |   93 ++
 include/dt-bindings/media/xilinx-vip.h             |    5 +-
 include/media/cec.h                                |    1 +
 include/media/davinci/vpbe.h                       |    4 -
 include/media/rc-map.h                             |    1 +
 include/media/v4l2-common.h                        |    5 +
 include/media/v4l2-dev.h                           |   13 +-
 include/media/v4l2-ioctl.h                         |   16 +-
 include/media/v4l2-subdev.h                        |    6 +-
 include/uapi/linux/v4l2-common.h                   |   28 +-
 include/uapi/linux/videodev2.h                     |    2 +
 samples/v4l/v4l2-pci-skeleton.c                    |   11 +-
 780 files changed, 17553 insertions(+), 3643 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/sony,imx214=
.txt
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt
 create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-cnf4.rst
 create mode 100644 drivers/media/i2c/imx214.c
 create mode 100644 drivers/media/platform/aspeed-video.c
 create mode 100644 drivers/media/platform/seco-cec/Makefile
 create mode 100644 drivers/media/platform/seco-cec/seco-cec.c
 create mode 100644 drivers/media/platform/seco-cec/seco-cec.h
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Kconfig
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/Makefile
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi_reg.h
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c
 create mode 100644 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.h
 create mode 100644 drivers/media/rc/keymaps/rc-xbox-dvd.c
 create mode 100644 drivers/media/rc/xbox_remote.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio-fe.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.h
 create mode 100644 drivers/staging/media/rockchip/vpu/Kconfig
 create mode 100644 drivers/staging/media/rockchip/vpu/Makefile
 create mode 100644 drivers/staging/media/rockchip/vpu/TODO
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_e=
nc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_e=
nc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
 create mode 100644 drivers/staging/media/tegra-vde/trace.h

