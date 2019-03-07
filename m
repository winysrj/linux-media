Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199B6C4360F
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 16:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5D9A2081B
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551975863;
	bh=Ze57Q8qFHSebCgllBocAKG5PrxcuKxN6CfbVo+lvw9s=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=ts3rJTWf2SSUbRkE/LSsv2eQ++3fDwQnG2LuOWY5PeXT+cMED/1FF62YG1f2DYnyT
	 whUBQkfSyuJTBlLOboCKpdN3X8nttDrnyHFvSBTDSzQ8WIKvleT0hFIIm90k8mgrY1
	 qWEa/ncV+pW17IR0K3b2kUsf6bFDSe4eyH+UoWNY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfCGQYR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 11:24:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfCGQYQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 11:24:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7rY8HvMQEhAytgXo/ZDeQWD3BHAlTFZV98KoUXGXykk=; b=UV8fgAru34itNYcb9vr7SO+LD
        YzABHfl4+t0Yo3FUoixZJR9lzwiutZkXMRDYS9kE+YoBf86Dn7dz6BHwMLfn1cck5Q5NVif31U77n
        V+nzb87lz0ieAsRQ4/NHtTs45MW4hMZaOtrXgX7ppBJeHg1AnJYnLB6QNr2ZSRLt+t8Tog+RIJB9V
        125A2o0F8M5GpV/ck0uIFlk173wve9Rch9WgM7AMHeMBrgTFkHcqReiBaOyLRs5QtDulbR0bxxlTg
        BaVssyJd62eQ/wGb490fXxRi6RyJGYcIrU5Ep+S3RjcWCUemwOUbSpXtqU7CYpx1VBjujDjNwC/dG
        EjpFy6/jg==;
Received: from 179.176.120.122.dynamic.adsl.gvt.net.br ([179.176.120.122] helo=coco.lan)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h1vob-0000Zr-1T; Thu, 07 Mar 2019 16:24:14 +0000
Date:   Thu, 7 Mar 2019 13:24:08 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v5.1-rc1] media updates
Message-ID: <20190307132408.4ed36d21@coco.lan>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v=
5.1-1

For:

- Removal of sensor drivers that got converted from soc_camera;
- Remaining soc_camera drivers got moved to staging;
- Some documentation cleanups and improvements;
- the imx staging driver now supports imx7;
- the ov9640, mt9m001 and mt9m111 got converted from soc_camera;
- the vim2m driver now does what a m2m convert driver expects to do;
- epoll() fixes on media subsystems;
- several drivers fixes, typos, cleanups and improvements.

The following changes since commit a3b22b9f11d9fbc48b0291ea92259a5a810e9438:

  Linux 5.0-rc7 (2019-02-17 18:46:40 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v=
5.1-1

for you to fetch changes up to 15d90a6ae98e6d2c68497b44a491cb9efbb98ab1:

  media: dvb/earth-pt1: fix wrong initialization for demod blocks (2019-03-=
04 06:17:02 -0500)

----------------------------------------------------------------
media updates for v5.1-rc1

----------------------------------------------------------------
Aditya Pakki (4):
      media: gspca: Check the return value of write_bridge for timeout
      media: gspca: mt9m111: Check write_bridge for timeout
      media: dvb: add return value check on Write16
      media: dvb: Add check on sp8870_readreg

Akihiro Tsukada (1):
      media: dvb/earth-pt1: fix wrong initialization for demod blocks

Akinobu Mita (22):
      media: staging: bcm2835-camera: use V4L2_FRACT_COMPARE
      media: ov2640: set default window and format code at probe time
      media: ov2640: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_F=
ORMAT_TRY
      media: ov2640: set all mbus format field when G_FMT and S_FMT ioctls
      media: i2c: mt9m001: copy mt9m001 soc_camera sensor driver
      media: i2c: mt9m001: dt: add binding for mt9m001
      media: mt9m001: convert to SPDX license identifer
      media: mt9m001: sort headers alphabetically
      media: mt9m001: add of_match_table
      media: mt9m001: introduce multi_reg_write()
      media: mt9m001: switch s_power callback to runtime PM
      media: mt9m001: remove remaining soc_camera specific code
      media: mt9m001: add media controller support
      media: mt9m001: register to V4L2 asynchronous subdevice framework
      media: mt9m001: support log_status ioctl and event interface
      media: mt9m001: make SUBDEV_G_FMT ioctl work with SUBDEV_FORMAT_TRY
      media: mt9m001: set all mbus format field when G_FMT and S_FMT ioctls
      media: mt9m111: make SUBDEV_G_FMT ioctl work with SUBDEV_FORMAT_TRY
      media: mt9m111: set all mbus format field when G_FMT and S_FMT ioctls
      media: mt9m111: set initial frame size other than 0x0
      media: ov2640: fix initial try format
      media: ov7740: fix runtime pm initialization

Alexey Khoroshilov (2):
      media: tw9910: fix failure handling in tw9910_power_on()
      media: tw9910: add helper function for setting gpiod value

Alistair Strachan (1):
      media: uvcvideo: Fix 'type' check leading to overflow

Andrzej Pietrasiewicz (2):
      media: Change Andrzej Pietrasiewicz's e-mail address
      media: MAINTAINERS: Change s5p-jpeg maintainer information.

Andr=C3=A9 Almeida (1):
      media: vivid: add vertical down sampling to imagesize calc

Arnd Bergmann (1):
      media: seco-cec: fix RC_CORE dependency

Ben Kao (2):
      media: ov8856: Add support for OV8856 sensor
      media: ov8856: Modify ov8856 register reading function to be simplifi=
ed

Chen-Yu Tsai (11):
      media: dt-bindings: media: sun6i: Separate H3 compatible from A31
      media: sun6i: Add H3 compatible
      media: ov5640: Move test_pattern_menu before ov5640_set_ctrl_test_pat=
tern
      media: ov5640: Add register definition for test pattern register
      media: ov5640: Disable transparent feature for test pattern
      media: ov5640: Add three more test patterns
      media: ov5640: Set JPEG output timings when outputting JPEG data
      media: ov5640: Consolidate JPEG compression mode setting
      media: sun6i: Fix CSI regmap's max_register
      media: sun6i: Add support for RGB565 formats
      media: sun6i: Add support for JPEG media bus format

Cody P Schafer (1):
      media: cx25840: mark pad sig_types to fix cx231xx init

Colin Ian King (4):
      media: cxd2880-spi: fix two memory leaks of dvb_spi
      media: staging: intel-ipu3: fix unsigned comparison with < 0
      media: wl128x: fix spelling mistake: "Swtich" -> "Switch"
      media: exynos4-is: remove redundant check on type

Dafna Hirschfeld (9):
      media: vicodec: bugfix - replace '=3D' with '|=3D'
      media: vicodec: Add num_planes field to v4l2_fwht_pixfmt_info
      media: vicodec: add support for CROP and COMPOSE selection
      media: vicodec: use 3 bits for the number of components
      media: vicodec: Add pixel encoding flags to fwht header
      media: vicodec: Separate fwht header from the frame data
      media: vicodec: Add support for resolution change event.
      media: vicodec: ensure comp frame pointer kept in range
      media: vicodec: Add a flag for I-frames in fwht header

Dan Carpenter (1):
      media: s5k4ecgx: delete a bogus error message

Ettore Chimenti (1):
      media: secocec: fix ir address shift

Ezequiel Garcia (13):
      media: vb2: Fix buf_out_validate documentation
      media: v4l2-mem2mem: Rename v4l2_m2m_buf_copy_data to v4l2_m2m_buf_co=
py_metadata
      media: v4l: ioctl: Sanitize num_planes before using it
      media: mtk-jpeg: Correct return type for mem2mem buffer helpers
      media: mtk-mdp: Correct return type for mem2mem buffer helpers
      media: mtk-vcodec: Correct return type for mem2mem buffer helpers
      media: mx2_emmaprp: Correct return type for mem2mem buffer helpers
      media: rockchip/rga: Correct return type for mem2mem buffer helpers
      media: s5p-g2d: Correct return type for mem2mem buffer helpers
      media: s5p-jpeg: Correct return type for mem2mem buffer helpers
      media: sh_veu: Correct return type for mem2mem buffer helpers
      media: rockchip/vpu: Correct return type for mem2mem buffer helpers
      media: v4l2-mem2mem: Correct return type for mem2mem buffer helpers

Fabrizio Castro (6):
      media: dt-bindings: rcar-csi2: Add r8a774c0
      media: dt-bindings: rcar-vin: Add R8A774C0 support
      media: rcar-vin: Add support for RZ/G2E
      media: rcar-csi2: Add support for RZ/G2E
      media: vsp1: Add RZ/G support
      media: dt-bindings: media: renesas-fcp: Add RZ/G2 support

French, Nicholas A (2):
      media: lgdt330x: fix lock status reporting
      media: ivtv: add parameter to enable ivtvfb on x86 PAT systems

Hans Verkuil (69):
      media: v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
      media: vim2m: use v4l2_m2m_buf_copy_data
      media: vicodec: use v4l2_m2m_buf_copy_data
      media: buffer.rst: clean up timecode documentation
      media: videodev2.h: add v4l2_timeval_to_ns inline function
      media: vb2: add vb2_find_timestamp()
      media: cedrus: identify buffers by timestamp
      media: extended-controls.rst: update the mpeg2 compound controls
      media: MAINTAINERS: added include/trace/events/pwc.h
      media: v4l2-ctrls.c/uvc: zero v4l2_event
      media: vivid: disable VB2_USERPTR if dma_contig was configured
      media: vivid: take data_offset into account for video output
      media: vivid: do not implement VIDIOC_S_PARM for output streams
      media: vim2m: the v4l2_m2m_buf_copy_data args were swapped
      media: soc_mt9t112: remove obsolete sensor driver
      media: soc_ov772x: remove obsolete sensor driver
      media: tw9910.h: remove obsolete soc_camera.h include.
      media: soc_tw9910: remove obsolete sensor driver
      media: sh_mobile_ceu_camera: remove obsolete soc_camera driver
      media: soc_camera/soc_scale_crop: drop this unused code
      media: soc_camera_platform: remove obsolete soc_camera test driver
      media: vimc: fill in correct driver name in querycap
      media: vidioc-prepare-buf.rst: drop reference to NO_CACHE flags
      media: v4l2-pci-skeleton.c: fix outdated irq code
      media: dev-effect.rst: remove unused Effect Interface chapter
      media: dev-teletext.rst: remove obsolete teletext interface
      media: Documentation/media: rename "Codec Interface"
      media: vb2: vb2_find_timestamp: drop restriction on buffer state
      media: vb2: add buf_out_validate callback
      media: vim2m: add buf_out_validate callback
      media: vivid: add buf_out_validate callback
      media: cedrus: add buf_out_validate callback
      media: vb2: check that buf_out_validate is present
      media: vivid: fix vid_out_buf_prepare()
      media: videobuf2: remove unused variable
      media: vicodec: check type in g/s_selection
      media: vicodec: fill in bus_info in media_device_info
      media: vim2m: fill in bus_info in media_device_info
      media: vicodec: support SOURCE_CHANGE event for decoders only
      media: v4l2-event: keep track of the timestamp in ns
      media: videobuf: use u64 for the timestamp internally
      media: meye: use u64 for the timestamp internally
      media: cpia2: use u64 for the timestamp internally
      media: stkwebcam: use u64 for the timestamp internally
      media: usbvision: use u64 for the timestamp internally
      media: zoran: use u64 for the timestamp internally
      media: v4l2-common: drop v4l2_get_timestamp
      media: hdpvr: fix smatch warning
      media: pxa_camera: fix smatch warning
      media: vimc: fill in bus_info in media_device_info
      media: vimc: add USERPTR support
      media: v4l2-subdev.h: v4l2_subdev_call: use temp __sd variable
      media: vivid: two unregistration fixes
      media: vimc: fix memory leak
      media: vb2: replace bool by bitfield in vb2_buffer
      media: vb2: keep track of timestamp status
      media: cec: fix epoll() by calling poll_wait first
      media: media-request: fix epoll() by calling poll_wait first
      media: vb2: fix epoll() by calling poll_wait first
      media: v4l2-ctrls.c: fix epoll() by calling poll_wait first
      media: v4l2-mem2mem: fix epoll() by calling poll_wait first
      media: v4l2-mem2mem: add q->error check to v4l2_m2m_poll()
      media: videobuf: fix epoll() by calling poll_wait first
      media: dvb-core: fix epoll() by calling poll_wait first
      extended-controls.rst: split up per control class
      media: uvcvideo: Fix smatch warning
      media: uvcvideo: Use usb_make_path to fill in usb_info
      media: vsp1: Fix smatch warning
      media: imx7-media-csi.c: fix merge breakage

Jacopo Mondi (10):
      media: rcar-csi2: Fix PHTW table values for E3/V3M
      media: v4l2: i2c: ov7670: Fix PLL bypass register values
      media: tw9910: Unregister subdevice with v4l2-async
      media: adv748x: Add is_txb()
      media: adv748x: Rename reset procedures
      media: adv748x: csi2: Link AFE with TXA and TXB
      media: adv748x: Store the source subdevice in TX
      media: adv748x: Store the TX sink in HDMI/AFE
      media: adv748x: Implement TX link_setup callback
      media: sh: migor: Include missing dma-mapping header

Jagan Teki (3):
      media: ov5640: Fix set 15fps regression
      media: dt-bindings: media: sun6i: Add A64 CSI compatible
      media: sun6i: Add A64 CSI block support

Kangjie Lu (4):
      media: usb: gspca: add a missed return-value check for do_command
      media: usb: gspca: add a missed check for goto_low_power
      media: lgdt3306a: fix a missing check of return value
      media: mt312: fix a missing check of mt312 reset

Kieran Bingham (3):
      media: vsp1: Fix trivial documentation
      media: i2c: adv748x: Convert SW reset routine to function
      media: i2c: adv748x: Remove PAGE_WAIT

Loic Poulain (2):
      media: ov5640: Add RAW bayer format support
      media: i2c: ov5640: Fix post-reset delay

Lubomir Rintel (4):
      media: ov7670: split register setting from set_fmt() logic
      media: ov7670: split register setting from set_framerate() logic
      media: ov7670: hook s_power onto v4l2 core
      media: ov7670: control clock along with power

Luca Ceresoli (2):
      media: imx274: fix wrong order in test pattern menus
      media: imx274: remote unused function imx274_read_reg

Lucas A. M. Magalh=C3=A3es (2):
      media: vimc: Add vimc-streamer for stream control
      media: vimc: Remove unused but set variables

Manivannan Sadhasivam (2):
      media: dt-bindings: media: i2c: Fix external clock frequency for OV56=
45
      media: dt-bindings: media: i2c: Fix i2c address for OV5645 camera sen=
sor

Marek Szyprowski (1):
      media: s5p-mfc: fix incorrect bus assignment in virtual child device

Matt Ranostay (2):
      media: dt-bindings: media: video-i2c: add melexis mlx90640 documentat=
ion
      media: video-i2c: add Melexis MLX90640 thermal camera

Matthias Reichl (1):
      media: rc: ir-rc6-decoder: enable toggle bit for Zotac remotes

Matwey V. Kornilov (2):
      media: usb: pwc: Introduce TRACE_EVENTs for pwc_isoc_handler()
      media: usb: pwc: Don't use coherent DMA buffers for ISO transfer

Mauro Carvalho Chehab (41):
      ipu3: add missing #include
      media: remove soc_camera ov9640
      media: vicodec: get_next_header is static
      media: vim2m: fix driver for it to handle different fourcc formats
      media: vim2m: use per-file handler work queue
      media: vim2m: allow setting the default transaction time via parameter
      media: vim2m: don't use curr_ctx->dev before checking
      Merge tag 'v5.0-rc7' into patchwork
      media: vim2m: fix build breakage due to a merge conflict
      media: imx7.rst: Fix ReST syntax
      media: imx7-media-csi: don't store a floating pointer
      media: imx7-media-csi: get rid of unused var
      media: ipu3: shut up warnings produced with W=3D1
      media: ipu3-mmu: fix some kernel-doc macros
      media: dvb-frontends: fix several typos
      media: radio: fix several typos
      media: dvb-core: fix several typos
      media: i2c: fix several typos
      media: pci: fix several typos
      media: platform: fix several typos
      media: rc: fix several typos
      media: tuners: fix several typos
      media: usb: fix several typos
      media: v4l2-core: fix several typos
      media: common: fix several typos
      media: include: fix several typos
      media: staging: fix several typos
      media: Documentation: fix several typos
      media: a few more typos at staging, pci, platform, radio and usb
      media: vim2m: add bayer capture formats
      media: vim2m: improve debug messages
      media: vim2m: ensure that width is multiple of two
      media: vim2m: add support for VIDIOC_ENUM_FRAMESIZES
      media: vim2m: use different framesizes for bayer formats
      media: vim2m: better handle cap/out buffers with different sizes
      media: vim2m: add vertical linear scaler
      media: vim2m: don't accept YUYV anymore as output format
      media: vim2m: add an horizontal scaler
      media: vim2m: speedup passthrough copy
      media: vim2m: don't use BUG()
      media: vim2m: Address some coding style issues

Niklas S=C3=B6derlund (6):
      media: rcar-vin: remove unneeded locking in async callbacks
      media: dt-bindings: adv748x: make data-lanes property mandatory for C=
SI-2 endpoints
      media: i2c: adv748x: reuse power up sequence when initializing CSI-2
      media: i2c: adv748x: store number of CSI-2 lanes described in device =
tree
      media: i2c: adv748x: configure number of lanes used for TXA CSI-2 tra=
nsmitter
      media: rcar-vin: fix wrong return value in rvin_set_channel_routing()

Ondrej Jirman (1):
      media: sunxi: cedrus: Fix missing error message context

Patrick Lerda (2):
      media: rc: rcmm decoder and encoder
      media: smipcie: add universal ir capability

Paul Kocialkowski (6):
      media: cedrus: Cleanup duplicate declarations from cedrus_dec header
      media: cedrus: Allow using the current dst buffer as reference
      media: Revert "media: cedrus: Allow using the current dst buffer as r=
eference"
      media: cedrus: Remove completed item from TODO list (dma-buf referenc=
es)
      media: cedrus: Forbid setting new formats on busy queues
      media: cedrus: mpeg2: Use v4l2_m2m_get_vq helper for capture queue

Pawe? Chmiel (6):
      media: s5p-jpeg: Check for fmt_ver_flag when doing fmt enumeration
      media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTAR=
T_INTERVAL
      media: si470x-i2c: Add device tree support
      media: si470x-i2c: Use managed resource helpers
      media: si470x-i2c: Add optional reset-gpio support
      media: dt-bindings: Add binding for si470x radio

Pawel Osciak (1):
      media: vb2: Keep dma-buf buffers mapped until they are freed

Peter Rosin (1):
      media: saa7146: make use of i2c_8bit_addr_from_msg

Petr Cvek (8):
      media: soc_camera: ov9640: move ov9640 out of soc_camera
      media: i2c: ov9640: drop soc_camera code and switch to v4l2_async
      media: MAINTAINERS: add Petr Cvek as a maintainer for the ov9640 driv=
er
      media: i2c: ov9640: add missing SPDX identifiers
      media: i2c: ov9640: change array index or length variables to unsigned
      media: i2c: ov9640: add space before return for better clarity
      media: i2c: ov9640: make array of supported formats constant
      media: i2c: ov9640: fix missing error handling in probe

Philipp Zabel (18):
      media: gspca: ov534: replace msleep(10) with usleep_range
      media: gspca: support multiple pixel formats in ENUM_FRAMEINTERVALS
      media: gspca: support multiple pixel formats in TRY_FMT
      media: gspca: ov543-ov772x: move video format specific registers into=
 bridge_start
      media: gspca: ov534-ov772x: add SGBRG8 bayer mode support
      media: gspca: ov534-ov722x: remove mode specific video data registers=
 from bridge_init
      media: gspca: ov534-ov722x: remove camera clock setup from bridge_init
      media: gspca: ov534-ov772x: remove unnecessary COM3 initialization
      media: v4l2-ctrl: Add control to enable h.264 constrained intra predi=
ction
      media: v4l2-ctrl: Add control for h.264 chroma qp offset
      media: coda: Add control for h.264 constrained intra prediction
      media: coda: Add control for h.264 chroma qp index offset
      media: coda: use macroblock tiling on CODA960 only
      media: coda: fix decoder capture buffer payload
      media: imx: add capture compose rectangle
      media: imx: set compose rectangle to mbus format
      media: imx: lift CSI and PRP ENC/VF width alignment restriction
      media: imx-pxp: fix duplicated if condition

Rui Miguel Silva (10):
      media: staging/imx: refactor imx media device probe
      media: staging/imx: rearrange group id to take in account IPU
      media: dt-bindings: add bindings for i.MX7 media driver
      media: staging/imx7: add imx7 CSI subdev driver
      media: staging/imx7: add MIPI CSI-2 receiver subdev for i.MX7
      media: imx7.rst: add documentation for i.MX7 media driver
      media: staging/imx: add i.MX7 entries to TODO file
      media: video-mux: add bayer formats
      media: MAINTAINERS: add entry for Freescale i.MX7 media driver
      media: imx7_mipi_csis: remove internal ops

Sakari Ailus (15):
      media: Documentation: staging/ipu3-imgu: Fix reference file name
      media: Documentation: staging/ipu3-imgu: Add license information
      media: ipu3-cio2: Allow probe to succeed if there are no sensors conn=
ected
      media: ov9640: Wrap long and unwrap short lines, align wrapped lines =
correctly
      media: MAINTAINERS: Update reviewers for ipu3-cio2
      media: ipu3-cio2, dw9714: Remove Jian Xu's e-mail
      media: v4l: uAPI: V4L2_BUF_TYPE_META_OUTPUT is an output buffer type
      media: ov7670: Remove useless use of a ret variable
      media: uvcvideo: Avoid NULL pointer dereference at the end of streami=
ng
      media: soc_camera: Remove the mt9m001 SoC camera sensor driver
      media: soc_camera: Remove the rj45n1 SoC camera sensor driver
      media: soc_camera: Move to the staging tree
      media: soc_camera: Move the imx074 under soc_camera directory
      media: soc_camera: Move the mt9t031 under soc_camera directory
      media: soc_camera: Depend on BROKEN

Sean Young (1):
      media: Revert "media: rc: some events are dropped by userspace"

Souptick Joarder (1):
      media: media/v4l2-core/videobuf-vmalloc.c: Remove dead code

Stanimir Varbanov (4):
      media: venus: firmware: check fw size against DT memory region size
      media: venus: core: correct maximum hardware load for sdm845
      media: venus: core: correct frequency table for sdm845
      media: venus: helpers: drop setting of timestamp invalid flag

Steve Longerbeam (21):
      media: rcar-vin: Allow independent VIN link enablement
      media: videodev2.h: Add more field helper macros
      media: gpu: ipu-csi: Swap fields according to input/output field types
      media: gpu: ipu-v3: Add planar support to interlaced scan
      media: imx: Fix field negotiation
      media: imx-csi: Double crop height for alternate fields at sink
      media: imx: interweave and odd-chroma-row skip are incompatible
      media: imx-csi: Allow skipping odd chroma rows for YVU420
      media: imx: vdic: rely on VDIC for correct field order
      media: imx-csi: Move crop/compose reset after filling default mbus fi=
elds
      media: imx: Allow interweave with top/bottom lines swapped
      media: imx.rst: Update doc to reflect fixes to interlaced capture
      media: i2c: adv748x: Use devm to allocate the device struct
      media: imx: queue subdev events to reachable video devices
      media: imx: capture: Allow event subscribe/unsubscribe
      media: imx-csi: Input connections to CSI should be optional
      media: imx: csi: Disable CSI immediately after last EOF
      media: imx: csi: Stop upstream before disabling IDMA channel
      media: imx: prpencvf: Stop upstream before disabling IDMA channel
      media: imx: Validate frame intervals before setting
      media: imx: Set capture compose rectangle in capture_device_set_format

Tim Harvey (1):
      media: tda1997x: fix get_edid

Vivek Kasireddy (4):
      media: v4l: Add 32-bit packed YUV formats
      media: v4l2-tpg-core: Add support for 32-bit packed YUV formats (v2)
      media: vivid: Add definitions for the 32-bit packed YUV formats
      media: imx-pxp: Start using the format VUYA32 instead of YUV32 (v2)

Wei Yongjun (1):
      media: platform: Fix missing spin_lock_init()

Yangtao Li (2):
      media: exynos4-is: convert to DEFINE_SHOW_ATTRIBUTE
      media: platform: sti: remove bdisp_dbg_declare() and hva_dbg_declare()

Yong Zhi (4):
      media: ipu3-imgu: Use MENU type for mode control
      media: ipu3-imgu: Remove dead code for NULL check
      media: ipu3-imgu: Prefix functions with imgu_* instead of ipu3_*
      media: ipu3: update meta format documentation

Yunfei Dong (2):
      media: dt-bindings: media: add 'assigned-clocks' to vcodec examples
      media: mtk-vcodec: Using common interface to manage vdec/venc clock

 .../devicetree/bindings/media/i2c/adv748x.txt      |   11 +-
 .../bindings/media/i2c/melexis,mlx90640.txt        |   20 +
 .../devicetree/bindings/media/i2c/mt9m001.txt      |   38 +
 .../devicetree/bindings/media/i2c/ov5645.txt       |    6 +-
 .../devicetree/bindings/media/imx7-csi.txt         |   45 +
 .../devicetree/bindings/media/imx7-mipi-csi2.txt   |   90 +
 .../devicetree/bindings/media/mediatek-vcodec.txt  |   13 +
 .../devicetree/bindings/media/rcar_vin.txt         |    9 +-
 .../devicetree/bindings/media/renesas,fcp.txt      |    5 +-
 .../bindings/media/renesas,rcar-csi2.txt           |    3 +-
 .../devicetree/bindings/media/renesas,vsp1.txt     |    6 +-
 Documentation/devicetree/bindings/media/si470x.txt |   26 +
 .../devicetree/bindings/media/sun6i-csi.txt        |    3 +-
 Documentation/media/dvb-drivers/dvb-usb.rst        |    2 +-
 Documentation/media/kapi/dtv-core.rst              |    2 +-
 Documentation/media/kapi/dtv-frontend.rst          |    2 +-
 Documentation/media/kapi/mc-core.rst               |    2 +-
 Documentation/media/kapi/v4l2-device.rst           |    2 +-
 Documentation/media/kapi/v4l2-intro.rst            |    2 +-
 Documentation/media/kapi/v4l2-subdev.rst           |    4 +-
 Documentation/media/lirc.h.rst.exceptions          |    3 +
 .../media/uapi/dvb/audio-set-bypass-mode.rst       |    2 +-
 Documentation/media/uapi/dvb/ca-set-descr.rst      |    2 +-
 Documentation/media/uapi/dvb/dmx-qbuf.rst          |    2 +-
 Documentation/media/uapi/dvb/dvbproperty.rst       |    2 +-
 Documentation/media/uapi/dvb/video_types.rst       |    2 +-
 Documentation/media/uapi/fdl-appendix.rst          |    2 +-
 Documentation/media/uapi/mediactl/media-types.rst  |    2 +-
 Documentation/media/uapi/mediactl/request-api.rst  |    4 +-
 Documentation/media/uapi/rc/rc-tables.rst          |    4 +-
 Documentation/media/uapi/v4l/buffer.rst            |   11 +-
 Documentation/media/uapi/v4l/common.rst            |   11 +
 Documentation/media/uapi/v4l/control.rst           |    2 +-
 Documentation/media/uapi/v4l/dev-effect.rst        |   28 -
 .../uapi/v4l/{dev-codec.rst =3D> dev-mem2mem.rst}    |   41 +-
 Documentation/media/uapi/v4l/dev-teletext.rst      |   41 -
 Documentation/media/uapi/v4l/devices.rst           |    4 +-
 Documentation/media/uapi/v4l/ext-ctrls-camera.rst  |  508 +++
 Documentation/media/uapi/v4l/ext-ctrls-codec.rst   | 2451 ++++++++++++
 Documentation/media/uapi/v4l/ext-ctrls-detect.rst  |   71 +
 Documentation/media/uapi/v4l/ext-ctrls-dv.rst      |  166 +
 Documentation/media/uapi/v4l/ext-ctrls-flash.rst   |  192 +
 Documentation/media/uapi/v4l/ext-ctrls-fm-rx.rst   |   95 +
 Documentation/media/uapi/v4l/ext-ctrls-fm-tx.rst   |  188 +
 .../media/uapi/v4l/ext-ctrls-image-process.rst     |   63 +
 .../media/uapi/v4l/ext-ctrls-image-source.rst      |   57 +
 Documentation/media/uapi/v4l/ext-ctrls-jpeg.rst    |  113 +
 .../media/uapi/v4l/ext-ctrls-rf-tuner.rst          |   96 +
 Documentation/media/uapi/v4l/extended-controls.rst | 3905 +---------------=
----
 Documentation/media/uapi/v4l/meta-formats.rst      |    2 +-
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |    2 +-
 .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |  144 +-
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst |  170 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    |    6 +-
 Documentation/media/uapi/v4l/vidioc-g-parm.rst     |    2 +-
 .../media/uapi/v4l/vidioc-prepare-buf.rst          |    5 +-
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |    2 +-
 Documentation/media/v4l-drivers/bttv.rst           |    4 +-
 Documentation/media/v4l-drivers/imx.rst            |  107 +-
 Documentation/media/v4l-drivers/imx7.rst           |  162 +
 Documentation/media/v4l-drivers/index.rst          |    1 +
 Documentation/media/v4l-drivers/ipu3.rst           |  151 +-
 Documentation/media/v4l-drivers/pxa_camera.rst     |    2 +-
 Documentation/media/v4l-drivers/qcom_camss.rst     |    2 +-
 MAINTAINERS                                        |   34 +-
 arch/sh/boards/mach-migor/setup.c                  |    1 +
 drivers/gpu/ipu-v3/ipu-cpmem.c                     |   26 +-
 drivers/gpu/ipu-v3/ipu-csi.c                       |  126 +-
 drivers/media/cec/cec-api.c                        |    2 +-
 drivers/media/common/saa7146/saa7146_fops.c        |    2 +-
 drivers/media/common/saa7146/saa7146_i2c.c         |    5 +-
 drivers/media/common/saa7146/saa7146_video.c       |    2 +-
 drivers/media/common/siano/sms-cards.c             |    2 +-
 drivers/media/common/siano/smscoreapi.h            |    2 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |   12 +
 drivers/media/common/videobuf2/videobuf2-core.c    |   53 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |    4 +-
 drivers/media/common/videobuf2/videobuf2-memops.c  |    2 +-
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |   30 +-
 drivers/media/dvb-core/dmxdev.c                    |    8 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |    5 +-
 drivers/media/dvb-core/dvb_frontend.c              |    2 +-
 drivers/media/dvb-core/dvbdev.c                    |    2 +-
 drivers/media/dvb-frontends/cxd2841er.c            |    2 +-
 drivers/media/dvb-frontends/dib0090.c              |    2 +-
 drivers/media/dvb-frontends/dib7000m.c             |    4 +-
 drivers/media/dvb-frontends/dib7000p.c             |    8 +-
 drivers/media/dvb-frontends/dib8000.c              |   12 +-
 drivers/media/dvb-frontends/dib9000.c              |    4 +-
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.h    |    8 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |    8 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |   48 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |   12 +-
 drivers/media/dvb-frontends/drxd_firm.c            |    2 +-
 drivers/media/dvb-frontends/drxd_hard.c            |   30 +-
 drivers/media/dvb-frontends/drxk.h                 |    2 +-
 drivers/media/dvb-frontends/drxk_hard.c            |    8 +-
 drivers/media/dvb-frontends/ds3000.c               |    4 +-
 drivers/media/dvb-frontends/isl6421.c              |    2 +-
 drivers/media/dvb-frontends/lgdt3306a.c            |    5 +-
 drivers/media/dvb-frontends/lgdt330x.c             |    2 +-
 drivers/media/dvb-frontends/m88rs2000.c            |    2 +-
 drivers/media/dvb-frontends/mt312.c                |    4 +-
 drivers/media/dvb-frontends/nxt200x.c              |    4 +-
 drivers/media/dvb-frontends/or51211.c              |    2 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    2 +-
 drivers/media/dvb-frontends/s5h1409.c              |    2 +-
 drivers/media/dvb-frontends/sp8870.c               |    4 +-
 drivers/media/dvb-frontends/stb0899_algo.c         |    6 +-
 drivers/media/dvb-frontends/stv0367_defs.h         |    2 +-
 drivers/media/dvb-frontends/stv0900_core.c         |    4 +-
 drivers/media/dvb-frontends/stv0910.c              |    4 +-
 drivers/media/dvb-frontends/stv6110.c              |    2 +-
 drivers/media/dvb-frontends/tda1004x.h             |    2 +-
 drivers/media/dvb-frontends/tda10086.c             |    2 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |    6 +-
 drivers/media/i2c/Kconfig                          |   36 +-
 drivers/media/i2c/Makefile                         |    4 +-
 drivers/media/i2c/adv7175.c                        |    2 +-
 drivers/media/i2c/adv748x/adv748x-afe.c            |    2 +-
 drivers/media/i2c/adv748x/adv748x-core.c           |  335 +-
 drivers/media/i2c/adv748x/adv748x-csi2.c           |   64 +-
 drivers/media/i2c/adv748x/adv748x-hdmi.c           |    2 +-
 drivers/media/i2c/adv748x/adv748x.h                |   28 +-
 drivers/media/i2c/adv7842.c                        |   10 +-
 drivers/media/i2c/bt819.c                          |    4 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |    3 +-
 drivers/media/i2c/cx25840/cx25840-core.h           |    3 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |    4 +-
 drivers/media/i2c/dw9714.c                         |    2 +-
 drivers/media/i2c/et8ek8/et8ek8_mode.c             |    2 +-
 drivers/media/i2c/imx214.c                         |    2 +-
 drivers/media/i2c/imx274.c                         |   24 +-
 drivers/media/i2c/lm3560.c                         |    2 +-
 drivers/media/i2c/lm3646.c                         |    2 +-
 drivers/media/i2c/m5mols/m5mols.h                  |    2 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |    2 +-
 drivers/media/i2c/msp3400-driver.c                 |    2 +-
 .../i2c/{soc_camera/soc_mt9m001.c =3D> mt9m001.c}    |  457 ++-
 drivers/media/i2c/mt9m111.c                        |   39 +
 drivers/media/i2c/mt9t112.c                        |    2 +-
 drivers/media/i2c/ov2640.c                         |   45 +-
 drivers/media/i2c/ov5640.c                         |  159 +-
 drivers/media/i2c/ov6650.c                         |    4 +-
 drivers/media/i2c/ov7670.c                         |  201 +-
 drivers/media/i2c/ov7740.c                         |    9 +-
 drivers/media/i2c/ov8856.c                         | 1268 +++++++
 .../i2c/{soc_camera/soc_ov9640.c =3D> ov9640.c}      |  123 +-
 drivers/media/i2c/{soc_camera =3D> }/ov9640.h        |    7 +-
 drivers/media/i2c/ov9650.c                         |    4 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |    2 +-
 drivers/media/i2c/s5k4ecgx.c                       |    2 -
 drivers/media/i2c/s5k6aa.c                         |    2 +-
 drivers/media/i2c/saa7115.c                        |    2 +-
 drivers/media/i2c/saa717x.c                        |    2 +-
 drivers/media/i2c/soc_camera/Makefile              |   10 -
 drivers/media/i2c/soc_camera/soc_mt9t112.c         | 1157 ------
 drivers/media/i2c/soc_camera/soc_ov772x.c          | 1123 ------
 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c      | 1415 -------
 drivers/media/i2c/soc_camera/soc_tw9910.c          |  999 -----
 drivers/media/i2c/tda1997x.c                       |    4 +
 drivers/media/i2c/tda1997x_regs.h                  |    2 +-
 drivers/media/i2c/tda9840.c                        |    2 +-
 drivers/media/i2c/tea6415c.c                       |    2 +-
 drivers/media/i2c/tea6420.c                        |    2 +-
 drivers/media/i2c/tvaudio.c                        |    4 +-
 drivers/media/i2c/tvp514x.c                        |    2 +-
 drivers/media/i2c/tw9910.c                         |   29 +-
 drivers/media/i2c/video-i2c.c                      |  110 +-
 drivers/media/media-request.c                      |    3 +-
 drivers/media/pci/bt8xx/bttv-audio-hook.c          |    2 +-
 drivers/media/pci/bt8xx/bttv-audio-hook.h          |    2 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |   12 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   12 +-
 drivers/media/pci/bt8xx/bttv-risc.c                |    2 +-
 drivers/media/pci/bt8xx/bttv.h                     |    2 +-
 drivers/media/pci/bt8xx/dst.c                      |   22 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |    2 +-
 drivers/media/pci/cx18/cx18-cards.h                |    2 +-
 drivers/media/pci/cx18/cx18-dvb.c                  |    6 +-
 drivers/media/pci/cx18/cx18-fileops.c              |    2 +-
 drivers/media/pci/cx18/cx18-io.h                   |    2 +-
 drivers/media/pci/cx18/cx18-mailbox.c              |    2 +-
 drivers/media/pci/cx18/cx18-vbi.c                  |    2 +-
 drivers/media/pci/cx18/cx23418.h                   |    2 +-
 drivers/media/pci/cx23885/cx23885-417.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-alsa.c           |    2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |    6 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +-
 drivers/media/pci/cx23885/cx23888-ir.c             |    4 +-
 drivers/media/pci/cx25821/cx25821-alsa.c           |    2 +-
 drivers/media/pci/cx25821/cx25821-sram.h           |    2 +-
 drivers/media/pci/cx25821/cx25821.h                |    2 +-
 drivers/media/pci/dm1105/dm1105.c                  |    2 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |    7 +-
 drivers/media/pci/ivtv/Kconfig                     |   23 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |    2 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |   16 +-
 drivers/media/pci/meye/meye.c                      |    8 +-
 drivers/media/pci/meye/meye.h                      |    4 +-
 drivers/media/pci/ngene/ngene-core.c               |    2 +-
 drivers/media/pci/pt1/pt1.c                        |   54 +-
 drivers/media/pci/pt3/pt3.h                        |    2 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |    2 +-
 drivers/media/pci/saa7146/mxb.c                    |    4 +-
 drivers/media/pci/saa7164/saa7164-api.c            |    2 +-
 drivers/media/pci/saa7164/saa7164-cards.c          |    4 +-
 drivers/media/pci/saa7164/saa7164-core.c           |    4 +-
 drivers/media/pci/saa7164/saa7164-dvb.c            |    2 +-
 drivers/media/pci/saa7164/saa7164-fw.c             |    2 +-
 drivers/media/pci/smipcie/smipcie-ir.c             |  132 +-
 drivers/media/pci/smipcie/smipcie.h                |    1 -
 drivers/media/pci/solo6x10/solo6x10-disp.c         |    4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
 drivers/media/pci/ttpci/av7110.c                   |    6 +-
 drivers/media/pci/tw68/tw68-video.c                |    2 +-
 drivers/media/platform/Kconfig                     |    5 +-
 drivers/media/platform/Makefile                    |    2 -
 drivers/media/platform/aspeed-video.c              |    1 +
 drivers/media/platform/atmel/atmel-isi.c           |    4 +-
 drivers/media/platform/coda/coda-bit.c             |   24 +-
 drivers/media/platform/coda/coda-common.c          |   13 +-
 drivers/media/platform/coda/coda-jpeg.c            |    2 +-
 drivers/media/platform/coda/coda.h                 |    2 +
 drivers/media/platform/davinci/isif.c              |    4 +-
 drivers/media/platform/davinci/vpbe.c              |    2 +-
 drivers/media/platform/davinci/vpfe_capture.c      |    2 +-
 drivers/media/platform/davinci/vpif.c              |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |    4 +-
 .../media/platform/exynos4-is/fimc-is-command.h    |    2 +-
 drivers/media/platform/exynos4-is/fimc-is-param.h  |    2 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   16 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    4 +-
 drivers/media/platform/exynos4-is/media-dev.h      |    2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |    4 +-
 drivers/media/platform/fsl-viu.c                   |    2 +-
 drivers/media/platform/imx-pxp.c                   |   16 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |    4 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |   40 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_core.h      |    6 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |   20 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |   64 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c  |  163 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |   35 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   74 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  104 +-
 .../media/platform/mtk-vcodec/vdec/vdec_h264_if.c  |    4 +-
 .../media/platform/mtk-vcodec/vdec/vdec_vp8_if.c   |    2 +-
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |    2 +-
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h    |    2 +-
 drivers/media/platform/mx2_emmaprp.c               |    6 +-
 drivers/media/platform/omap/omap_vout.c            |   16 +-
 drivers/media/platform/omap/omap_voutdef.h         |    4 +-
 drivers/media/platform/omap3isp/isp.c              |    2 +-
 drivers/media/platform/omap3isp/ispccdc.c          |    4 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |    2 +-
 drivers/media/platform/pxa_camera.c                |   10 +-
 drivers/media/platform/qcom/venus/core.c           |   12 +-
 drivers/media/platform/qcom/venus/core.h           |    3 +-
 drivers/media/platform/qcom/venus/firmware.c       |   53 +-
 drivers/media/platform/qcom/venus/helpers.c        |    3 -
 drivers/media/platform/rcar-vin/rcar-core.c        |   26 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c        |   66 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |    4 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |    4 +-
 drivers/media/platform/rockchip/rga/rga-hw.c       |    6 +-
 drivers/media/platform/rockchip/rga/rga.c          |    6 +-
 drivers/media/platform/s3c-camif/camif-core.h      |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    6 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   63 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |    6 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.c      |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-hw-s5p.h      |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    4 +-
 drivers/media/platform/seco-cec/seco-cec.h         |    2 +-
 drivers/media/platform/sh_veu.c                    |    4 +-
 drivers/media/platform/soc_camera/Kconfig          |   26 -
 drivers/media/platform/soc_camera/Makefile         |    9 -
 .../platform/soc_camera/sh_mobile_ceu_camera.c     | 1810 ---------
 .../platform/soc_camera/soc_camera_platform.c      |  188 -
 drivers/media/platform/soc_camera/soc_scale_crop.c |  426 ---
 drivers/media/platform/soc_camera/soc_scale_crop.h |   47 -
 drivers/media/platform/sti/bdisp/bdisp-debug.c     |   34 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.h  |    2 +-
 drivers/media/platform/sti/delta/delta.h           |    2 +-
 drivers/media/platform/sti/hva/hva-debugfs.c       |   36 +-
 drivers/media/platform/sti/hva/hva-h264.c          |    2 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |    2 +-
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c |   39 +-
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h |    5 +-
 .../media/platform/sunxi/sun6i-csi/sun6i_video.c   |    3 +
 drivers/media/platform/ti-vpe/vpdma.c              |   14 +-
 drivers/media/platform/ti-vpe/vpe.c                |    2 +-
 drivers/media/platform/vicodec/codec-fwht.c        |  148 +-
 drivers/media/platform/vicodec/codec-fwht.h        |   30 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c   |  394 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.h   |   15 +-
 drivers/media/platform/vicodec/vicodec-core.c      |  658 +++-
 drivers/media/platform/video-mux.c                 |   20 +
 drivers/media/platform/vim2m.c                     |  675 +++-
 drivers/media/platform/vimc/Makefile               |    3 +-
 drivers/media/platform/vimc/vimc-capture.c         |   26 +-
 drivers/media/platform/vimc/vimc-common.c          |   35 -
 drivers/media/platform/vimc/vimc-common.h          |   17 +-
 drivers/media/platform/vimc/vimc-core.c            |    5 +-
 drivers/media/platform/vimc/vimc-debayer.c         |   26 +-
 drivers/media/platform/vimc/vimc-scaler.c          |   28 +-
 drivers/media/platform/vimc/vimc-sensor.c          |   51 +-
 drivers/media/platform/vimc/vimc-streamer.c        |  188 +
 drivers/media/platform/vimc/vimc-streamer.h        |   38 +
 drivers/media/platform/vivid/vivid-core.c          |   26 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   10 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |   30 +
 drivers/media/platform/vivid/vivid-vid-out.c       |   57 +-
 drivers/media/platform/vsp1/vsp1_brx.c             |    4 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |    6 +-
 drivers/media/platform/vsp1/vsp1_video.c           |    2 +-
 drivers/media/platform/xilinx/xilinx-vip.c         |    2 +-
 drivers/media/radio/radio-si476x.c                 |    2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   52 +-
 drivers/media/radio/si470x/radio-si470x.h          |    1 +
 drivers/media/radio/wl128x/fmdrv.h                 |    4 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |    4 +-
 drivers/media/rc/Kconfig                           |   17 +-
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/ati_remote.c                      |    2 +-
 drivers/media/rc/ene_ir.c                          |    2 +-
 drivers/media/rc/ene_ir.h                          |    2 +-
 drivers/media/rc/fintek-cir.h                      |    2 +-
 drivers/media/rc/ir-rc6-decoder.c                  |    2 +
 drivers/media/rc/ir-rcmm-decoder.c                 |  254 ++
 drivers/media/rc/ir-xmp-decoder.c                  |    2 +-
 drivers/media/rc/ite-cir.c                         |    2 +-
 drivers/media/rc/keymaps/rc-behold-columbus.c      |    4 +-
 drivers/media/rc/keymaps/rc-behold.c               |    2 +-
 drivers/media/rc/keymaps/rc-manli.c                |    2 +-
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |    2 +-
 drivers/media/rc/mceusb.c                          |    2 +-
 drivers/media/rc/rc-core-priv.h                    |    5 +
 drivers/media/rc/rc-ir-raw.c                       |    2 +-
 drivers/media/rc/rc-main.c                         |   34 +-
 drivers/media/rc/redrat3.c                         |    2 +-
 drivers/media/spi/cxd2880-spi.c                    |    8 +-
 drivers/media/tuners/mxl5005s.c                    |    2 +-
 drivers/media/tuners/qm1d1b0004.h                  |    2 +-
 drivers/media/tuners/r820t.c                       |    4 +-
 drivers/media/tuners/tda18271-common.c             |   10 +-
 drivers/media/tuners/tda18271-fe.c                 |    2 +-
 drivers/media/tuners/tda18271.h                    |    4 +-
 drivers/media/tuners/xc4000.c                      |    4 +-
 drivers/media/usb/au0828/au0828-core.c             |    2 +-
 drivers/media/usb/au0828/au0828-dvb.c              |    2 +-
 drivers/media/usb/au0828/au0828.h                  |    2 +-
 drivers/media/usb/cpia2/cpia2.h                    |    2 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |    2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                |   11 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |    4 +-
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |    2 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h        |    2 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |    2 +-
 drivers/media/usb/cx231xx/cx231xx.h                |    2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    2 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |    8 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |    4 +-
 drivers/media/usb/dvb-usb/af9005.c                 |    2 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c           |    2 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |    2 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |    2 +-
 drivers/media/usb/dvb-usb/dvb-usb.h                |    2 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |    4 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |    4 +-
 drivers/media/usb/em28xx/em28xx-reg.h              |    2 +-
 drivers/media/usb/gspca/Kconfig                    |    2 +-
 drivers/media/usb/gspca/autogain_functions.c       |    2 +-
 drivers/media/usb/gspca/benq.c                     |    4 +-
 drivers/media/usb/gspca/cpia1.c                    |   14 +-
 drivers/media/usb/gspca/gspca.c                    |   18 +-
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c      |    8 +-
 drivers/media/usb/gspca/m5602/m5602_po1030.c       |    8 +-
 drivers/media/usb/gspca/mr97310a.c                 |   10 +-
 drivers/media/usb/gspca/ov519.c                    |    4 +-
 drivers/media/usb/gspca/ov534.c                    |  153 +-
 drivers/media/usb/gspca/pac_common.h               |    2 +-
 drivers/media/usb/gspca/sn9c20x.c                  |    2 +-
 drivers/media/usb/gspca/sonixb.c                   |    4 +-
 drivers/media/usb/gspca/sonixj.c                   |    2 +-
 drivers/media/usb/gspca/spca501.c                  |    2 +-
 drivers/media/usb/gspca/sq905.c                    |    2 +-
 drivers/media/usb/gspca/sunplus.c                  |    4 +-
 drivers/media/usb/gspca/t613.c                     |    2 +-
 drivers/media/usb/gspca/touptek.c                  |    4 +-
 drivers/media/usb/gspca/w996Xcf.c                  |    2 +-
 drivers/media/usb/gspca/zc3xx-reg.h                |    2 +-
 drivers/media/usb/gspca/zc3xx.c                    |    8 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |   14 +-
 drivers/media/usb/hdpvr/hdpvr.h                    |    2 +-
 drivers/media/usb/pwc/pwc-dec23.c                  |    4 +-
 drivers/media/usb/pwc/pwc-if.c                     |   71 +-
 drivers/media/usb/pwc/pwc-misc.c                   |    2 +-
 drivers/media/usb/siano/smsusb.c                   |    2 +-
 drivers/media/usb/stk1160/stk1160-core.c           |    4 +-
 drivers/media/usb/stk1160/stk1160-reg.h            |    4 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |    4 +-
 drivers/media/usb/tm6000/tm6000-alsa.c             |    2 +-
 drivers/media/usb/tm6000/tm6000-core.c             |    4 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |    2 +-
 drivers/media/usb/tm6000/tm6000-i2c.c              |    2 +-
 drivers/media/usb/tm6000/tm6000-stds.c             |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |    4 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |    2 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |    2 +-
 drivers/media/usb/usbvision/usbvision-core.c       |   10 +-
 drivers/media/usb/usbvision/usbvision-video.c      |    4 +-
 drivers/media/usb/usbvision/usbvision.h            |   10 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |    2 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   16 +-
 drivers/media/usb/uvc/uvc_video.c                  |   10 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    6 +-
 drivers/media/usb/zr364xx/zr364xx.c                |    6 +-
 drivers/media/v4l2-core/v4l2-common.c              |   10 -
 drivers/media/v4l2-core/v4l2-ctrls.c               |   16 +-
 drivers/media/v4l2-core/v4l2-event.c               |   19 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   16 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   20 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   52 +-
 drivers/media/v4l2-core/videobuf-core.c            |   12 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c      |    2 +-
 drivers/media/v4l2-core/videobuf-vmalloc.c         |   22 +-
 drivers/staging/media/Kconfig                      |    6 +-
 drivers/staging/media/Makefile                     |    3 +-
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |    2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |    4 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |    2 +-
 drivers/staging/media/imx/Kconfig                  |    9 +-
 drivers/staging/media/imx/Makefile                 |    4 +
 drivers/staging/media/imx/TODO                     |    9 +
 drivers/staging/media/imx/imx-ic-common.c          |    6 +-
 drivers/staging/media/imx/imx-ic-prp.c             |   25 +-
 drivers/staging/media/imx/imx-ic-prpencvf.c        |   91 +-
 drivers/staging/media/imx/imx-media-capture.c      |  119 +-
 drivers/staging/media/imx/imx-media-csi.c          |  230 +-
 drivers/staging/media/imx/imx-media-dev-common.c   |   90 +
 drivers/staging/media/imx/imx-media-dev.c          |  122 +-
 drivers/staging/media/imx/imx-media-internal-sd.c  |   20 +-
 drivers/staging/media/imx/imx-media-of.c           |    6 +-
 drivers/staging/media/imx/imx-media-utils.c        |   47 +-
 drivers/staging/media/imx/imx-media-vdic.c         |   21 +-
 drivers/staging/media/imx/imx-media.h              |   45 +-
 drivers/staging/media/imx/imx7-media-csi.c         | 1369 +++++++
 drivers/staging/media/imx/imx7-mipi-csis.c         | 1160 ++++++
 drivers/staging/media/imx074/Kconfig               |    5 -
 drivers/staging/media/imx074/Makefile              |    1 -
 drivers/staging/media/imx074/TODO                  |    5 -
 drivers/staging/media/ipu3/Makefile                |    6 +
 drivers/staging/media/ipu3/TODO                    |    7 +-
 drivers/staging/media/ipu3/include/intel-ipu3.h    |   10 +-
 drivers/staging/media/ipu3/ipu3-abi.h              |    2 +-
 drivers/staging/media/ipu3/ipu3-css-fw.c           |   18 +-
 drivers/staging/media/ipu3/ipu3-css-fw.h           |    8 +-
 drivers/staging/media/ipu3/ipu3-css-params.c       |  271 +-
 drivers/staging/media/ipu3/ipu3-css-params.h       |    8 +-
 drivers/staging/media/ipu3/ipu3-css-pool.c         |   32 +-
 drivers/staging/media/ipu3/ipu3-css-pool.h         |   30 +-
 drivers/staging/media/ipu3/ipu3-css.c              |  460 +--
 drivers/staging/media/ipu3/ipu3-css.h              |   92 +-
 drivers/staging/media/ipu3/ipu3-dmamap.c           |   43 +-
 drivers/staging/media/ipu3/ipu3-dmamap.h           |   14 +-
 drivers/staging/media/ipu3/ipu3-mmu.c              |  125 +-
 drivers/staging/media/ipu3/ipu3-mmu.h              |   18 +-
 drivers/staging/media/ipu3/ipu3-tables.c           |   50 +-
 drivers/staging/media/ipu3/ipu3-tables.h           |   54 +-
 drivers/staging/media/ipu3/ipu3-v4l2.c             |  299 +-
 drivers/staging/media/ipu3/ipu3.c                  |   97 +-
 drivers/staging/media/ipu3/ipu3.h                  |   20 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |    2 +-
 .../media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c    |    6 +-
 .../media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c    |    6 +-
 .../i2c =3D> staging/media}/soc_camera/Kconfig       |   46 +-
 drivers/staging/media/soc_camera/Makefile          |    7 +
 .../staging/media/{imx074 =3D> soc_camera}/imx074.c  |    0
 .../media/{mt9t031 =3D> soc_camera}/mt9t031.c        |    0
 .../media}/soc_camera/soc_camera.c                 |    4 +-
 .../media}/soc_camera/soc_mediabus.c               |    0
 .../i2c =3D> staging/media}/soc_camera/soc_mt9v022.c |    0
 .../i2c =3D> staging/media}/soc_camera/soc_ov5642.c  |    0
 .../i2c =3D> staging/media}/soc_camera/soc_ov9740.c  |    0
 drivers/staging/media/sunxi/cedrus/TODO            |    5 -
 drivers/staging/media/sunxi/cedrus/cedrus.h        |    9 +-
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c    |    2 +
 drivers/staging/media/sunxi/cedrus/cedrus_dec.h    |    6 -
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c     |   28 +-
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c  |   23 +-
 drivers/staging/media/sunxi/cedrus/cedrus_video.c  |   19 +
 drivers/staging/media/zoran/zoran.h                |    2 +-
 drivers/staging/media/zoran/zoran_card.c           |    2 +-
 drivers/staging/media/zoran/zoran_device.c         |    6 +-
 drivers/staging/media/zoran/zoran_driver.c         |    4 +-
 .../vc04_services/bcm2835-camera/bcm2835-camera.c  |    8 +-
 include/linux/platform_data/media/si4713.h         |    4 +-
 .../platform_data/media/soc_camera_platform.h      |   83 -
 include/media/davinci/dm355_ccdc.h                 |    4 +-
 include/media/davinci/dm644x_ccdc.h                |    2 +-
 include/media/drv-intf/exynos-fimc.h               |    2 +-
 include/media/drv-intf/saa7146.h                   |    2 +-
 include/media/drv-intf/saa7146_vv.h                |    4 +-
 include/media/drv-intf/sh_mobile_ceu.h             |   29 -
 include/media/dvb_frontend.h                       |    8 +-
 include/media/i2c/tw9910.h                         |    2 -
 include/media/mpeg2-ctrls.h                        |   14 +-
 include/media/rc-map.h                             |   18 +-
 include/media/v4l2-common.h                        |    9 -
 include/media/v4l2-ctrls.h                         |    2 +-
 include/media/v4l2-event.h                         |    2 +
 include/media/v4l2-fwnode.h                        |    4 +-
 include/media/v4l2-mem2mem.h                       |   44 +-
 include/media/v4l2-subdev.h                        |    9 +-
 include/media/videobuf-core.h                      |    4 +-
 include/media/videobuf2-core.h                     |   15 +-
 include/media/videobuf2-dma-sg.h                   |    2 +-
 include/media/videobuf2-v4l2.h                     |   16 +
 include/trace/events/pwc.h                         |   65 +
 include/uapi/linux/lirc.h                          |    6 +
 include/uapi/linux/v4l2-controls.h                 |    2 +
 include/uapi/linux/videodev2.h                     |   26 +-
 include/video/imx-ipu-v3.h                         |    8 +-
 samples/v4l/v4l2-pci-skeleton.c                    |    8 +-
 tools/include/uapi/linux/lirc.h                    |   12 +
 tools/testing/selftests/ir/ir_loopback.c           |    9 +
 536 files changed, 15295 insertions(+), 15371 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/melexis,mlx=
90640.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m001.txt
 create mode 100644 Documentation/devicetree/bindings/media/imx7-csi.txt
 create mode 100644 Documentation/devicetree/bindings/media/imx7-mipi-csi2.=
txt
 create mode 100644 Documentation/devicetree/bindings/media/si470x.txt
 delete mode 100644 Documentation/media/uapi/v4l/dev-effect.rst
 rename Documentation/media/uapi/v4l/{dev-codec.rst =3D> dev-mem2mem.rst} (=
50%)
 delete mode 100644 Documentation/media/uapi/v4l/dev-teletext.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-camera.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-codec.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-detect.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-dv.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-flash.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-fm-rx.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-fm-tx.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-image-process.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-image-source.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-jpeg.rst
 create mode 100644 Documentation/media/uapi/v4l/ext-ctrls-rf-tuner.rst
 create mode 100644 Documentation/media/v4l-drivers/imx7.rst
 rename drivers/media/i2c/{soc_camera/soc_mt9m001.c =3D> mt9m001.c} (66%)
 create mode 100644 drivers/media/i2c/ov8856.c
 rename drivers/media/i2c/{soc_camera/soc_ov9640.c =3D> ov9640.c} (90%)
 rename drivers/media/i2c/{soc_camera =3D> }/ov9640.h (96%)
 delete mode 100644 drivers/media/i2c/soc_camera/Makefile
 delete mode 100644 drivers/media/i2c/soc_camera/soc_mt9t112.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_ov772x.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_tw9910.c
 delete mode 100644 drivers/media/platform/soc_camera/Kconfig
 delete mode 100644 drivers/media/platform/soc_camera/Makefile
 delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_camera_platform.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.h
 create mode 100644 drivers/media/platform/vimc/vimc-streamer.c
 create mode 100644 drivers/media/platform/vimc/vimc-streamer.h
 create mode 100644 drivers/media/rc/ir-rcmm-decoder.c
 create mode 100644 drivers/staging/media/imx/imx-media-dev-common.c
 create mode 100644 drivers/staging/media/imx/imx7-media-csi.c
 create mode 100644 drivers/staging/media/imx/imx7-mipi-csis.c
 delete mode 100644 drivers/staging/media/imx074/Kconfig
 delete mode 100644 drivers/staging/media/imx074/Makefile
 delete mode 100644 drivers/staging/media/imx074/TODO
 rename drivers/{media/i2c =3D> staging/media}/soc_camera/Kconfig (54%)
 create mode 100644 drivers/staging/media/soc_camera/Makefile
 rename drivers/staging/media/{imx074 =3D> soc_camera}/imx074.c (100%)
 rename drivers/staging/media/{mt9t031 =3D> soc_camera}/mt9t031.c (100%)
 rename drivers/{media/platform =3D> staging/media}/soc_camera/soc_camera.c=
 (99%)
 rename drivers/{media/platform =3D> staging/media}/soc_camera/soc_mediabus=
.c (100%)
 rename drivers/{media/i2c =3D> staging/media}/soc_camera/soc_mt9v022.c (10=
0%)
 rename drivers/{media/i2c =3D> staging/media}/soc_camera/soc_ov5642.c (100=
%)
 rename drivers/{media/i2c =3D> staging/media}/soc_camera/soc_ov9740.c (100=
%)
 delete mode 100644 include/linux/platform_data/media/soc_camera_platform.h
 delete mode 100644 include/media/drv-intf/sh_mobile_ceu.h
 create mode 100644 include/trace/events/pwc.h

