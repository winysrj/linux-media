Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53928 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbcCOLF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 07:05:58 -0400
Date: Tue, 15 Mar 2016 08:05:52 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [GIT PULL for v4.6-rc1] media updates
Message-ID: <20160315080552.3cc5d146@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-1

For:
  - Added support for some new video formats;
  - mn88473 DVB frontend driver got promoted from staging;
  - several improvements at the VSP1 driver;
  - several cleanups and improvements at the Media Controller;
  - added Media Controller support to snd-usb-audio. Currently, enabled only
    for au0828-based V4L2/DVB boards;
  - Several improvements at nuvoton-cir: it now supports wake up codes;
  - Add media controller support to em28xx and saa7134 drivers;
  - coda driver now accepts NXP distributed firmware files;
  - Some legacy SoC camera drivers will be moving to staging, as they're
    outdated and nobody so far is willing to fix and convert them to use
    the current media framework;
  - As usual, lots of cleanups, improvements and new board additions.

Thanks!
Mauro

---

The following changes since commit b562e44f507e863c6792946e4e1b1449fbbac85d:

  Linux 4.5 (2016-03-13 21:28:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-1

for you to fetch changes up to 8331c055b23c4155b896a2c3791704ae68992d2b:

  Merge commit '840f5b0572ea' into v4l_for_linus (2016-03-15 07:48:28 -0300)

----------------------------------------------------------------
media updates for v4.6-rc1

----------------------------------------------------------------
Abhilash Jindal (1):
      [media] dvb-frontend: Use boottime

Al Viro (1):
      [media] davinci: ccdc_update_raw_params() frees the wrong thing

Amitoj Kaur Chawla (2):
      [media] media: platform: exynos4-is: media-dev: Add missing of_node_put
      [media] media: platform: vivid: vivid-osd: Remove unnecessary cast to kfree

Andrei Koshkosh (1):
      [media] si2157.c: fix frequency range

Andrzej Hajda (1):
      [media] v4l: omap3isp: Fix handling platform_get_irq result

Andy Shevchenko (1):
      [media] tea575x: convert to library

Antti Palosaari (5):
      [media] rtl28xxu: retry failed i2c messages
      [media] mn88473: move out of staging
      [media] mn88473: finalize driver
      [media] rtl2832: improve slave TS control
      [media] rtl2832: move stats polling to read status

Arnd Bergmann (9):
      [media] s5c73m3: remove duplicate module device table
      [media] hdpvr: hide unused variable
      [media] b2c2: flexcop: avoid unused function warnings
      [media] v4l: remove MEDIA_TUNER dependency for VIDEO_TUNER
      [media] msp3400: use IS_ENABLED check instead of #if
      [media] mx3_camera: use %pad format string for dma_ddr_t
      [media] em28xx: restore lost #ifdef
      [media] saa7134: fix warning with !MEDIA_CONTROLLER
      [media] hide unused functions for !MEDIA_CONTROLLER

Aviv Greenberg (1):
      [media] UVC: Add support for R200 depth camera

Benjamin Larsson (1):
      [media] Add support for Terratec Cinergy S2 Rev.4

Benoit Parrot (6):
      [media] media: ti-vpe: Document CAL driver
      [media] MAINTAINERS: Add ti-vpe maintainer entry
      [media] media: ti-vpe: Add CAL v4l2 camera capture driver
      [media] media: ti-vpe: cal: Fix syntax check warnings
      [media] media: ti-vpe: cal: Fix unreachable code in enum_frame_interval
      [media] media: ti-vpe: cal: Fix warning: variable dereference before being checked

Christophe JAILLET (1):
      [media] netup_unidvb: Remove a useless memset

Dan Carpenter (5):
      [media] vpx3220: signedness bug in vpx3220_fp_read()
      [media] staging: media: lirc: fix MODULE_PARM_DESC typo
      [media] wl128x: fix typo in MODULE_PARM_DESC
      [media] xc2028: unlock on error in xc2028_set_config()
      [media] usb/cpia2_core: clean up a min_t() cast

Eduard Gavin (1):
      [media] tvp5150: Add OF match table

Emilio López (2):
      [media] rc: sunxi-cir: support module autoloading
      [media] usb: musb: sunxi: support module autoloading

Ernst Martin Witte (5):
      [media] af9013: cancel_delayed_work_sync before device removal / kfree
      [media] af9033: cancel_delayed_work_sync before device removal / kfree
      [media] si2157: cancel_delayed_work_sync before device removal / kfree
      [media] rtl2830: cancel_delayed_work_sync before device removal / kfree
      [media] ts2020: cancel_delayed_work_sync before device removal / kfree

Ezequiel Garcia (1):
      [media] stk1160: Remove redundant vb2_buf payload set

Fugang Duan (1):
      [media] radio-si476x: add return value check to avoid dead code

GEORGE (1):
      [media] saa7134: Add support for Snazio TvPVR PRO

Geliang Tang (2):
      [media] sh_mobile_ceu_camera: use soc_camera_from_vb2q
      [media] bttv-driver, usbvision-video: use to_video_device()

Grygorii Strashko (1):
      [media] media: i2c: ov2659: speedup probe if no device connected

Guennadi Liakhovetski (3):
      [media] V4L: ov9650: fix control clusters
      [media] V4L: add Y12I, Y8I and Z16 pixel format documentation
      [media] V4L: fix a confusing function name

Guenter Roeck (1):
      [media] atmel-isi: Fix bad usage of IS_ERR_VALUE

Hans Verkuil (22):
      [media] saa7134: add DMABUF support
      [media] v4l2-dv-timings: skip standards check for V4L2_DV_BT_CAP_CUSTOM
      [media] DocBook media: make explicit that standard/timings never change automatically
      [media] vivid: fix broken Bayer text rendering
      [media] v4l2-ctrls: add V4L2_CID_DV_RX/TX_IT_CONTENT_TYPE controls
      [media] DocBook media: document the new V4L2_CID_DV_RX/TX_IT_CONTENT_TYPE controls
      [media] adv7604: add support to for the content type control
      [media] adv7842: add support to for the content type control
      [media] adv7511: add support to for the content type control
      [media] adv7511: TX_EDID_PRESENT is still 1 after a disconnect
      [media] timblogiw: move to staging in preparation for removal
      [media] tc358743: use - instead of non-ascii wide-dash character
      [media] media-device.h: fix compiler warning
      [media] media.h: use hex values for IF and AUDIO entities too
      [media] vivid: support new multiplanar YUV formats
      [media] soc_camera/omap1: move to staging in preparation for removal
      [media] soc_camera/mx2_camera.c: move to staging in preparation, for removal
      [media] soc_camera/mx3_camera.c: move to staging in preparation, for removal
      [media] v4l2-mc.h: fix compiler warnings
      [media] media.h: always start with 1 for the audio entities
      [media] staging/media: add missing TODO files
      [media] v4l2-mc.h: fix yet more compiler errors

Hans de Goede (4):
      [media] pwc: Add USB id for Philips Spc880nc webcam
      [media] saa7134: Fix bytesperline not being set correctly for planar formats
      [media] bttv: Width must be a multiple of 16 when capturing planar formats
      [media] gspca: Remove unused ovfx2_vga_mode/ovfx2_cif_mode arrays

Heiner Kallweit (23):
      [media] media: rc: nuvoton: mark wakeup-related resources
      [media] media: rc: raw: improve FIFO handling
      [media] nuvoton-cir: use request_muxed_region for accessing EFM registers
      [media] nuvoton-cir: simplify nvt_select_logical_ dev
      [media] nuvoton-cir: simplify nvt_cir_tx_inactive
      [media] nuvoton-cir: factor out logical device disabling
      [media] nuvoton-cir: fix clearing wake fifo
      [media] nuvoton-cir: use IR_DEFAULT_TIMEOUT and consider SAMPLE_PERIOD
      [media] nuvoton-cir: factor out logical device enabling
      [media] nuvoton-cir: improve logical device handling
      [media] nuvoton-cir: remove unneeded EFM operation in nvt_cir_isr
      [media] nuvoton-cir: remove unneeded call to nvt_set_cir_iren
      [media] nuvoton-cir: fix setting ioport base address
      [media] media: rc: nuvoton-cir: improve nvt_hw_detect
      [media] media: rc: nuvoton-cir: add locking to calls of nvt_enable_wake
      [media] media: rc: nuvoton-cir: fix wakeup interrupt bits
      [media] media: rc: nuvoton-cir: fix interrupt handling
      [media] media: rc: nuvoton-cir: improve locking in both interrupt handlers
      [media] rc/nuvoton_cir: fix locking issue with nvt_enable_cir
      [media] rc/nuvoton_cir: fix locking issue when calling nvt_enable_wake
      [media] rc/nuvoton_cir: fix locking issue when calling nvt_disable_cir
      [media] media: rc: nuvoton: support reading / writing wakeup sequence via sysfs
      [media] media: rc: nuvoton: switch attribute wakeup_data to text

Insu Yun (4):
      [media] cx231xx: correctly handling failed allocation
      [media] usbtv: correctly handling failed allocation
      [media] usbvision: fix locking error
      [media] pvrusb2: correctly handling failed thread run

Javier Martinez Canillas (22):
      [media] v4l: omap3isp: Fix module autoloading
      [media] tvp5150: Add device tree binding document
      [media] tvp5150: Initialize the chip on probe
      [media] tvp5150: Configure data interface via DT
      [media] v4l: of: Correct v4l2_of_parse_endpoint() kernel-doc
      [media] adv7604: Check v4l2_of_parse_endpoint() return value
      [media] s5c73m3: Check v4l2_of_parse_endpoint() return value
      [media] s5k5baf: Check v4l2_of_parse_endpoint() return value
      [media] tvp514x: Check v4l2_of_parse_endpoint() return value
      [media] tvp7002: Check v4l2_of_parse_endpoint() return value
      [media] exynos4-is: Check v4l2_of_parse_endpoint() return value
      [media] omap3isp: Check v4l2_of_parse_endpoint() return value
      [media] v4l2-subdev: add registered_async subdev core operation
      [media] v4l2-async: call registered_async after subdev registration
      [media] tvp5150: put endpoint node on error
      [media] tvp5150: store dev id and rom version
      [media] tvp5150: add internal signal generator to HW input list
      [media] tvp5150: move input definition header to dt-bindings
      [media] tvp5150: document input connectors DT bindings
      [media] tvp5150: add HW input connectors support
      [media] v4l2-async: Don't fail if registered_async isn't implemented
      [media] Revert "[media] tvp5150: document input connectors DT bindings"

Jean-Baptiste Theou (1):
      [media] cx231xx: Fix memory leak

Jean-Michel Hautbois (1):
      [media] media: i2c: adv7604: Use v4l2-dv-timings helpers

Jemma Denson (1):
      [media] cx24120: make sure tuner is locked at get_frontend

Joseph Marrero (1):
      [media] davinci_vpfe: make checkpatch happy

Julia Lawall (8):
      [media] soc_camera: constify v4l2_subdev_sensor_ops structures
      [media] constify stv6110x_devctl structure
      [media] drivers/media/usb/as102: constify as102_priv_ops_t structure
      [media] go7007: constify go7007_hpi_ops structures
      [media] av7110: constify sp8870_config structure
      [media] drivers/media/usb/dvb-usb-v2: constify mxl111sf_tuner_config structure
      [media] media: bt8xx: constify or51211_config structure
      [media] media: bt8xx: constify sp887x_config structure

Koji Matsuoka (1):
      [media] soc_camera: rcar_vin: Add ARGB8888 caputre format support

Lad, Prabhakar (1):
      [media] v4l: omap3isp: use vb2_buffer_state enum for vb2 buffer state

Laurent Pinchart (46):
      [media] v4l: omap3isp: Fix data lane shift configuration
      [media] tvp5150: Restructure version detection
      [media] tvp5150: Add tvp5151 support
      [media] tvp5150: Add pixel rate control support
      [media] tvp5150: Add s_stream subdev operation support
      [media] tvp5150: Add g_mbus_config subdev operation support
      [media] tvp5150: fix tvp5150_fill_fmt()
      [media] tvp5150: Add pad-level subdev operations
      [media] v4l: Merge the YUV and YVU 4:2:0 tri-planar non-contiguous formats docs
      [media] v4l: Add YUV 4:2:2 and YUV 4:4:4 tri-planar non-contiguous formats
      [media] v4l: vsp1: Add tri-planar memory formats support
      [media] v4l: vsp1: Group all link creation code in a single file
      [media] v4l: vsp1: Change the type of the rwpf field in struct vsp1_video
      [media] v4l: vsp1: Store the memory format in struct vsp1_rwpf
      [media] v4l: vsp1: Move video operations to vsp1_rwpf
      [media] v4l: vsp1: Rename vsp1_video_buffer to vsp1_vb2_buffer
      [media] v4l: vsp1: Move video device out of struct vsp1_rwpf
      [media] v4l: vsp1: Make rwpf operations independent of video device
      [media] v4l: vsp1: Support VSP1 instances without any UDS
      [media] v4l: vsp1: Move vsp1_video pointer from vsp1_entity to vsp1_rwpf
      [media] v4l: vsp1: Remove struct vsp1_pipeline num_video field
      [media] v4l: vsp1: Decouple pipeline end of frame processing from vsp1_video
      [media] v4l: vsp1: Split pipeline management code from vsp1_video.c
      [media] v4l: vsp1: Rename video pipeline functions to use vsp1_video prefix
      [media] v4l: vsp1: Extract pipeline initialization code into a function
      [media] v4l: vsp1: Reuse local variable instead of recomputing it
      [media] v4l: vsp1: Extract link creation to separate function
      [media] v4l: vsp1: Document the vsp1_pipeline structure
      [media] v4l: vsp1: Fix typo in VI6_DISP_IRQ_STA_DST register bit name
      [media] v4l: vsp1: Set the SRU CTRL0 register when starting the stream
      [media] v4l: vsp1: Remove unused module read functions
      [media] v4l: vsp1: Move entity route setup function to vsp1_entity.c
      [media] v4l: vsp1: Make number of BRU inputs configurable
      [media] v4l: vsp1: Make the BRU optional
      [media] v4l: vsp1: Move format info to vsp1_pipe.c
      [media] v4l: vsp1: Make the userspace API optional
      [media] v4l: vsp1: Make pipeline inputs array index by RPF index
      [media] v4l: vsp1: Set the alpha value manually in RPF and WPF s_stream handlers
      [media] v4l: vsp1: Don't validate links when the userspace API is disabled
      [media] v4l: vsp1: Add VSP+DU support
      [media] v4l: vsp1: Disconnect unused RPFs from the DRM pipeline
      [media] v4l: vsp1: Implement atomic update for the DRM driver
      [media] v4l: vsp1: Add support for the R-Car Gen3 VSP2
      [media] v4l: vsp1: Configure device based on IP version
      [media] v4l: vsp1: Check if an entity is a subdev with the right function
      [media] v4l: exynos4-is: Drop unneeded check when setting up fimc-lite links

Linus Walleij (1):
      [media] : cxd2830r: use gpiochip data pointer

Markus Elfring (8):
      [media] gsc-m2m: Use an unsigned data type for a variable
      [media] si2165: Refactoring for si2165_writereg_mask8()
      [media] tuners: Refactoring for m88rs6000t_sleep()
      [media] r820t: Delete an unnecessary variable initialisation in generic_set_freq()
      [media] msi2500: Delete an unnecessary check in msi2500_set_usb_adc()
      [media] bttv: Returning only value constants in two functions
      [media] au0828: Refactoring for start_urb_transfer()
      [media] hdpvr: Refactoring for hdpvr_read()

Markus Pargmann (1):
      [media] mt9v032: Add reset and standby gpios

Mats Randgaard (2):
      [media] tc358743: Print timings only when debug level is set
      [media] tc358743: Use local array with fixed size in i2c write

Matthias Schwarzott (1):
      [media] si2165: Reject DVB-T bandwidth auto mode

Matthieu Rogez (3):
      [media] em28xx: add support for Terratec Grabby REC button
      [media] em28xx: add support for Terratec Grabby Record led
      [media] em28xx: fix Terratec Grabby AC97 codec detection

Mauro Carvalho Chehab (95):
      Merge tag 'v4.5-rc1' into patchwork
      Revert "[media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY"
      [media] dw2102: use the new USB ID Terratec Cinergy S2 macros
      [media] tvp5150: Fix breakage for serial usage
      [media] em28xx: fix implementation of s_stream
      Revert "[media] tvp5150: Fix breakage for serial usage"
      [media] em28xx: remove unused input types
      [media] xc2028: avoid use after free
      [media] tuner.h: rename TUNER_PAD_IF_OUTPUT to TUNER_PAD_OUTPUT
      [media] v4l2-mc.h: move tuner PAD definitions to this new header
      [media] v4l2-mc.h: Split audio from baseband output
      [media] media.h: add support for IF-PLL video/sound decoder
      [media] v4l2-mc.h Add pads for audio and video IF-PLL decoders
      [media] v4l2-mc: add analog TV demodulator pad index macros
      [media] tvp5150: create the expected number of pads
      [media] msp3400: initialize MC data
      [media] tvp5150: identify it as a MEDIA_ENT_F_ATV_DECODER
      [media] saa7115: initialize demod type and add the needed pads
      [media] em28xx: unregister devices in case of failure
      [media] em28xx: fix tuner detection for Pixelview Prolink PlayTV USB 2.0
      [media] em28xx: make sure that the device has video
      [media] em28xx: avoid divide by zero error
      [media] mt9v011: add media controller support
      [media] em28xx: add media controller support
      [media] dvb_frontend: print DTV property dump also for SET_PROPERTY
      [media] dvb_frontend: add props argument to dtv_get_frontend()
      [media] siano: remove get_frontend stub
      [media] friio-fe: remove get_frontend() callback
      [media] lgs8gxx: don't export get_frontend() callback
      [media] mb86a20s: get rid of dummy get_frontend()
      [media] dvb_frontend: pass the props cache to get_frontend() as arg
      [media] dvb_frontend: Don't let drivers to trash data at cache
      Merge tag 'v4.5-rc3' into patchwork
      [media] v4l2-mc: add a generic function to create the media graph
      [media] em2xx: use v4l2_mc_create_media_graph()
      [media] add media controller support to videobuf2-dvb
      [media] saa7134: use input types, instead of hardcoding strings
      [media] saa7134: unconditionlally update TV standard at demod
      [media] saa7134: Get rid of struct saa7134_input.tv field
      [media] v4l2-mc: add an ancillary routine for PCI-based MC
      [media] saa7134: add media controller support
      [media] au0828: only create V4L2 graph if V4L2 is registered
      [media] au0828: move V4L2-specific code to au0828-core.c
      [media] v4l2-mc.h: prevent it for being included twice
      [media] v4l2-mc: add a routine to create USB media_device
      [media] rc-core: don't lock device at rc_register_device()
      [media] allow overriding the driver name
      [media] use v4l2_mc_usb_media_device_init() on most USB devices
      [media] em28xx-dvb: create RF connector on DVB-only mode
      [media] cx231xx: use v4l2 core function to create the MC graph
      [media] si2157: register as a tuner entity
      [media] cx231xx, em28xx: pass media_device to si2157
      [media] cx231xx: create connectors at the media graph
      [media] v4l2-mc: remove the unused sensor var
      [media] au0828: get rid of AU0828_VMUX_DEBUG
      [media] cx231xx: get rid of CX231XX_VMUX_DEBUG
      [media] tvp5150: replace MEDIA_ENT_F_CONN_TEST by a control
      [media] media.h: get rid of MEDIA_ENT_F_CONN_TEST
      Merge branch 'fixes' into patchwork
      [media] siano: firmware buffer is too small
      [media] smsusb: don't sleep while atomic
      [media] siano: use generic function to create MC device
      [media] vsp1_drm.h: add missing prototypes
      [media] xc4000: shut up a bogus smatch message
      [media] v4l2-mc: fix hardware version for PCI devices
      [media] tvp5150: don't go past decoder->input_ent array
      [media] saa7134: fix detection of external decoders
      [media] dib0090: do the right thing if rf_ramp is NULL
      [media] media-device: move PCI/USB helper functions from v4l2-mc
      [media] media_device: move allocation out of media_device_*_init
      [media] pvrusb2-io: no need to check if sp is not NULL
      [media] pvrusb2: don't go past buf array
      [media] stv0900: avoid going past array
      [media] ivtv: steal could be NULL
      [media] dib9000: read16/write16 could return an error code
      [media] drxj: set_param_parameters array is too short
      [media] av7110: remove a bogus smatch warning
      [media] ttpci: cleanup a bogus smatch warning
      [media] airspy: fix bit set/clean mess on s->flags
      [media] drxj: don't do math if not needed
      [media] dib0090: Do the right check for state->rf_ramp
      [media] technisat-usb2: don't do DMA on the stack
      [media] pt3: fix device identification
      [media] ati_remote: Put timeouts at the accel array
      [media] lirc_dev: avoid double mutex unlock
      Merge branch 'v4l_for_linus' into patchwork
      [media] rc-core: allow calling rc_open with device not initialized
      [media] au0828: use standard demod pads struct
      [media] au0828: use v4l2_mc_create_media_graph()
      [media] v4l2-mc: Fix parameter description
      v4l2-mc.h: Add stubs for the V4L2 PM/pipeline routines
      [media] mceusb: use %*ph for small buffer dumps
      [media] touptek: don't DMA at the stack
      [media] touptek: cast char types on %x printk
      Merge commit '840f5b0572ea' into v4l_for_linus

Nicolas Sugino (1):
      [media] dib8000: Add support for Mygica/Geniatech S2870

Niklas Söderlund (1):
      [media] vim2m: return error if driver registration fails

Nikola Forró (1):
      [media] usbtv: discard redundant video fields

Olli Salonen (6):
      [media] dw2102: convert TechnoTrend S2-4600 to use I2C binding for demod
      [media] cx23885: fix reversed I2C bus numbering
      [media] cx23885: incorrect I2C bus used in the CI registration
      [media] dvb-core: fix return code checking for devices with CA
      [media] dw2102: ts2020 included twice
      [media] dw2102: add support for TeVii S662

Patrick Boettcher (1):
      [media] media: change email address

Philipp Zabel (7):
      [media] coda: fix first encoded frame payload
      [media] dw2102: Add support for Terratec Cinergy S2 USB BOX
      [media] coda: add support for native order firmware files with Freescale header
      [media] coda: add support for firmware files named as distributed by NXP
      [media] media-entity: include linux/bug.h for WARN_ON
      [media] coda: fix error path in case of missing pdata on non-DT platform
      [media] v4l2-ioctl: fix YUV422P pixel format description

Philippe Valembois (2):
      [media] Add support for Avermedia AverTV Volar HD 2 (TD110)
      [media] Fix AverMedia RM-KS remote keymap

RitwikGopi (1):
      [media] Staging: media/lirc: lirc_zilog.c : fixed a string split in multi-line issue

Robert Jarzmik (4):
      [media] pxa_camera: fix the buffer free path
      [media] pxa_camera: move interrupt to tasklet
      [media] pxa_camera: trivial move of dma irq functions
      [media] pxa_camera: conversion to dmaengine

Sakari Ailus (11):
      [media] v4l: omap3isp: Move starting the sensor from streamon IOCTL handler to VB2 QOP
      [media] v4l: omap3isp: Return buffers back to videobuf2 if pipeline streamon fails
      [media] v4l: omap3isp: preview: Mark output buffer done first
      [media] media: v4l: Dual license v4l2-common.h under GPL v2 and BSD licenses
      [media] media: Use all bits of an enumeration
      [media] media: Always keep a graph walk large enough around
      [media] v4l: Add generic pipeline power management code
      [media] v4l: omap3isp: Use V4L2 graph PM operations
      [media] staging: v4l: omap4iss: Use V4L2 graph PM operations
      [media] media: Move media_get_uptr() macro out of the media.h user space header
      [media] media: Properly handle user pointers

Sean Young (1):
      [media] igorplugusb: fix leaks in error path

Shuah Khan (31):
      [media] media: Fix media_open() to clear filp->private_data in error leg
      [media] media: Media Controller fix to not let stream_count go negative
      [media] Docbook: media-types.xml: Add ALSA Media Controller Intf types
      [media] uapi/media.h: Declare interface types for ALSA
      [media] Docbook: media-types.xml: Add Audio Function Entities
      [media] media: Add ALSA Media Controller function entities
      [media] media: Media Controller register/unregister entity_notify API
      [media] media: Media Controller enable/disable source handler API
      [media] media: Media Controller export non locking __media_entity_setup_link()
      [media] media: Media Controller non-locking __media_entity_pipeline_start/stop()
      [media] media: v4l-core add enable/disable source common interfaces
      [media] media: Move au8522_media_pads enum to au8522.h from au8522_priv.h
      [media] media: au8522 change to create MC pad for ALSA Audio Out
      [media] media: au0828 Use au8522_media_pads enum for pad defines
      [media] media: Change v4l-core to check if source is free
      [media] media: au0828 change to use Managed Media Controller API
      [media] media: au0828 handle media_init and media_register window
      [media] media: au0828 create tuner to decoder link in disabled state
      [media] media: au0828 disable tuner to demod link
      [media] media: au0828-core register entity_notify hook
      [media] media: au0828 add enable, disable source handlers
      [media] media: dvb-frontend invoke enable/disable_source handlers
      [media] media: au0828 video change to use v4l_enable_media_source()
      [media] media: au0828 set ctrl_input in au0828_s_input()
      [media] media: au0828 enable the right media source when input changes
      [media] sound/usb: Use Media Controller API to share media resources
      [media] media: au0828 audio mixer isn't connected to decoder
      [media] sound/usb: Use meaninful names for goto labels
      [media] media: fix null pointer dereference in v4l_vb2q_enable_media_source()
      [media] media: add prefixes to interface types
      media: au0828 disable tuner to demod link in au0828_media_device_register()

Simon Horman (1):
      [media] rcar_jpu: Add R-Car Gen2 Fallback Compatibility String

Stefan Pöschel (1):
      [media] af9035: add support for 2nd tuner of MSI DigiVox Diversity

Sudip Mukherjee (4):
      [media] staging: media: lirc: replace NULL comparisons with !var
      [media] staging: media: lirc: no space after cast
      [media] staging: media: lirc: space around operator
      [media] media: ti-vpe: add dependency of HAS_DMA

Takashi Saito (1):
      [media] v4l: vsp1: Add display list support

Tiffany Lin (1):
      [media] media: v4l2-compat-ioctl32: fix missing length copy in put_v4l2_buffer32

Torbjörn Jansson (1):
      [media] dvb-usb-dvbsky: add new product id for TT CT2-4650 CI

Ulrich Hecht (2):
      [media] media: adv7604: implement get_selection
      [media] adv7604: fix SPA register location for ADV7612

Vladimir Zapolskiy (1):
      [media] v4l2-ctrls: remove unclaimed v4l2_ctrl_add_ctrl() interface

Wesley Post (1):
      [media] gspca: Fix ov519 i2c r/w not working when connected to a xhci host

Wu, Xia (1):
      [media] media: videobuf2-core: Fix one __qbuf_dmabuf() error path

Wu-Cheng Li (2):
      [media] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME
      [media] s5p-mfc: add the support of V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME

Xiubo Li (3):
      [media] dvbdev: remove useless parentheses after return
      [media] dvbdev: replace kcalloc with kzalloc
      [media] dvbdev: the space is required after ','

Yoshihiko Mori (1):
      [media] soc_camera: rcar_vin: Add R-Car Gen3 support

 Documentation/ABI/testing/sysfs-class-rc-nuvoton   |   15 +
 Documentation/DocBook/device-drivers.tmpl          |    1 +
 Documentation/DocBook/media/v4l/controls.xml       |   58 +
 .../DocBook/media/v4l/media-ioc-g-topology.xml     |    3 -
 Documentation/DocBook/media/v4l/media-types.xml    |   81 +-
 Documentation/DocBook/media/v4l/pixfmt-y12i.xml    |   49 +
 Documentation/DocBook/media/v4l/pixfmt-y8i.xml     |   80 +
 Documentation/DocBook/media/v4l/pixfmt-yuv420m.xml |   26 +-
 .../v4l/{pixfmt-yvu420m.xml => pixfmt-yuv422m.xml} |  106 +-
 Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml |  177 ++
 Documentation/DocBook/media/v4l/pixfmt-z16.xml     |   81 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |   13 +-
 .../DocBook/media/v4l/vidioc-query-dv-timings.xml  |   14 +-
 .../DocBook/media/v4l/vidioc-querystd.xml          |   10 +
 .../devicetree/bindings/media/i2c/mt9v032.txt      |    2 +
 .../devicetree/bindings/media/i2c/tvp5150.txt      |   45 +
 .../devicetree/bindings/media/rcar_vin.txt         |    1 +
 .../devicetree/bindings/media/renesas,jpu.txt      |   13 +-
 .../devicetree/bindings/media/renesas,vsp1.txt     |   34 +-
 Documentation/devicetree/bindings/media/ti-cal.txt |   72 +
 Documentation/dvb/README.dvb-usb                   |    2 +-
 Documentation/video4linux/CARDLIST.saa7134         |    1 +
 Documentation/video4linux/v4l2-controls.txt        |    1 -
 MAINTAINERS                                        |   12 +-
 drivers/media/common/b2c2/flexcop-fe-tuner.c       |    4 +-
 drivers/media/common/b2c2/flexcop.c                |    4 +-
 drivers/media/common/cypress_firmware.c            |    2 +-
 drivers/media/common/cypress_firmware.h            |    2 +-
 drivers/media/common/siano/smscoreapi.c            |    4 +-
 drivers/media/common/siano/smsdvb-main.c           |    7 -
 drivers/media/dvb-core/dvb-usb-ids.h               |    9 +-
 drivers/media/dvb-core/dvb_frontend.c              |  218 +--
 drivers/media/dvb-core/dvb_frontend.h              |    3 +-
 drivers/media/dvb-core/dvbdev.c                    |   15 +-
 drivers/media/dvb-frontends/Kconfig                |    8 +
 drivers/media/dvb-frontends/Makefile               |    1 +
 drivers/media/dvb-frontends/af9013.c               |    8 +-
 drivers/media/dvb-frontends/af9033.c               |    7 +-
 drivers/media/dvb-frontends/as102_fe.c             |    4 +-
 drivers/media/dvb-frontends/atbm8830.c             |    4 +-
 drivers/media/dvb-frontends/au8522.h               |    1 -
 drivers/media/dvb-frontends/au8522_decoder.c       |    7 +-
 drivers/media/dvb-frontends/au8522_dig.c           |    4 +-
 drivers/media/dvb-frontends/au8522_priv.h          |   11 +-
 drivers/media/dvb-frontends/bcm3510.c              |    4 +-
 drivers/media/dvb-frontends/bcm3510.h              |    2 +-
 drivers/media/dvb-frontends/bcm3510_priv.h         |    2 +-
 drivers/media/dvb-frontends/cx22700.c              |    4 +-
 drivers/media/dvb-frontends/cx22702.c              |    4 +-
 drivers/media/dvb-frontends/cx24110.c              |    4 +-
 drivers/media/dvb-frontends/cx24117.c              |    4 +-
 drivers/media/dvb-frontends/cx24120.c              |    8 +-
 drivers/media/dvb-frontends/cx24123.c              |    4 +-
 drivers/media/dvb-frontends/cxd2820r_c.c           |    4 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |   20 +-
 drivers/media/dvb-frontends/cxd2820r_priv.h        |    9 +-
 drivers/media/dvb-frontends/cxd2820r_t.c           |    4 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c          |    6 +-
 drivers/media/dvb-frontends/cxd2841er.c            |    4 +-
 drivers/media/dvb-frontends/dib0070.c              |    2 +-
 drivers/media/dvb-frontends/dib0090.c              |   16 +-
 drivers/media/dvb-frontends/dib3000.h              |    6 +-
 drivers/media/dvb-frontends/dib3000mb.c            |   17 +-
 drivers/media/dvb-frontends/dib3000mb_priv.h       |    2 +-
 drivers/media/dvb-frontends/dib3000mc.c            |   10 +-
 drivers/media/dvb-frontends/dib3000mc.h            |    2 +-
 drivers/media/dvb-frontends/dib7000m.c             |    8 +-
 drivers/media/dvb-frontends/dib7000p.c             |   10 +-
 drivers/media/dvb-frontends/dib8000.c              |   77 +-
 drivers/media/dvb-frontends/dib9000.c              |   31 +-
 drivers/media/dvb-frontends/dibx000_common.c       |    2 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |   11 +-
 drivers/media/dvb-frontends/dvb_dummy_fe.c         |    7 +-
 drivers/media/dvb-frontends/hd29l2.c               |    4 +-
 drivers/media/dvb-frontends/l64781.c               |    4 +-
 drivers/media/dvb-frontends/lg2160.c               |   62 +-
 drivers/media/dvb-frontends/lgdt3305.c             |    4 +-
 drivers/media/dvb-frontends/lgdt3306a.c            |    4 +-
 drivers/media/dvb-frontends/lgdt330x.c             |    5 +-
 drivers/media/dvb-frontends/lgs8gl5.c              |    5 +-
 drivers/media/dvb-frontends/lgs8gxx.c              |   13 +-
 drivers/media/dvb-frontends/m88ds3103.c            |    4 +-
 drivers/media/dvb-frontends/m88rs2000.c            |    5 +-
 drivers/media/dvb-frontends/mb86a20s.c             |   11 -
 .../mn88473 => media/dvb-frontends}/mn88473.c      |  388 ++--
 drivers/media/dvb-frontends/mn88473.h              |   14 +-
 .../mn88473 => media/dvb-frontends}/mn88473_priv.h |    7 +-
 drivers/media/dvb-frontends/mt312.c                |    4 +-
 drivers/media/dvb-frontends/mt352.c                |    4 +-
 drivers/media/dvb-frontends/or51132.c              |    4 +-
 drivers/media/dvb-frontends/rtl2830.c              |    7 +-
 drivers/media/dvb-frontends/rtl2832.c              |  155 +-
 drivers/media/dvb-frontends/rtl2832.h              |    4 +-
 drivers/media/dvb-frontends/rtl2832_priv.h         |    1 -
 drivers/media/dvb-frontends/s5h1409.c              |    4 +-
 drivers/media/dvb-frontends/s5h1411.c              |    4 +-
 drivers/media/dvb-frontends/s5h1420.c              |    4 +-
 drivers/media/dvb-frontends/s921.c                 |    4 +-
 drivers/media/dvb-frontends/si2165.c               |   28 +-
 drivers/media/dvb-frontends/stb0899_drv.c          |    4 +-
 drivers/media/dvb-frontends/stb6100.c              |    2 +-
 drivers/media/dvb-frontends/stv0297.c              |    4 +-
 drivers/media/dvb-frontends/stv0299.c              |    8 +-
 drivers/media/dvb-frontends/stv0367.c              |    8 +-
 drivers/media/dvb-frontends/stv0900_core.c         |   11 +-
 drivers/media/dvb-frontends/stv6110x.c             |    4 +-
 drivers/media/dvb-frontends/stv6110x.h             |    4 +-
 drivers/media/dvb-frontends/stv6110x_priv.h        |    2 +-
 drivers/media/dvb-frontends/tc90522.c              |   10 +-
 drivers/media/dvb-frontends/tda10021.c             |    4 +-
 drivers/media/dvb-frontends/tda10023.c             |    4 +-
 drivers/media/dvb-frontends/tda10048.c             |    4 +-
 drivers/media/dvb-frontends/tda1004x.c             |    4 +-
 drivers/media/dvb-frontends/tda10071.c             |    4 +-
 drivers/media/dvb-frontends/tda10086.c             |    4 +-
 drivers/media/dvb-frontends/tda8083.c              |    4 +-
 drivers/media/dvb-frontends/ts2020.c               |    4 +
 drivers/media/dvb-frontends/ves1820.c              |    4 +-
 drivers/media/dvb-frontends/ves1x93.c              |    4 +-
 drivers/media/dvb-frontends/zl10353.c              |    4 +-
 drivers/media/i2c/adv7511.c                        |   43 +-
 drivers/media/i2c/adv7604.c                        |  230 +--
 drivers/media/i2c/adv7842.c                        |   20 +
 drivers/media/i2c/msp3400-driver.c                 |   14 +
 drivers/media/i2c/msp3400-driver.h                 |    5 +
 drivers/media/i2c/mt9v011.c                        |   15 +
 drivers/media/i2c/mt9v032.c                        |   28 +
 drivers/media/i2c/ov2659.c                         |    8 +-
 drivers/media/i2c/ov9650.c                         |    4 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |    4 +-
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |    1 -
 drivers/media/i2c/s5k5baf.c                        |    5 +-
 drivers/media/i2c/saa7115.c                        |   19 +
 drivers/media/i2c/soc_camera/mt9m001.c             |    2 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |    2 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |    2 +-
 drivers/media/i2c/tc358743.c                       |   55 +-
 drivers/media/i2c/tvp514x.c                        |    6 +-
 drivers/media/i2c/tvp5150.c                        |  452 ++++-
 drivers/media/i2c/tvp7002.c                        |    6 +-
 drivers/media/i2c/vpx3220.c                        |    2 +-
 drivers/media/media-device.c                       |  145 +-
 drivers/media/media-devnode.c                      |    1 +
 drivers/media/media-entity.c                       |   94 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   53 +-
 drivers/media/pci/bt8xx/dst.c                      |    4 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c                |    4 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   19 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |    2 +-
 drivers/media/pci/ivtv/ivtv-queue.c                |    2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    7 +-
 drivers/media/pci/ngene/ngene-cards.c              |    2 +-
 drivers/media/pci/pt3/pt3.c                        |    3 +-
 drivers/media/pci/saa7134/saa7134-cards.c          | 1851 +++++++++----------
 drivers/media/pci/saa7134/saa7134-core.c           |  195 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |    9 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |    3 +-
 drivers/media/pci/saa7134/saa7134-go7007.c         |    2 +-
 drivers/media/pci/saa7134/saa7134-input.c          |   21 +
 drivers/media/pci/saa7134/saa7134-tvaudio.c        |   13 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  108 +-
 drivers/media/pci/saa7134/saa7134.h                |   46 +-
 drivers/media/pci/ttpci/av7110.c                   |   15 +-
 drivers/media/pci/ttpci/budget.c                   |   36 +-
 drivers/media/platform/Kconfig                     |   22 +-
 drivers/media/platform/Makefile                    |    3 +-
 drivers/media/platform/coda/coda-bit.c             |    2 +-
 drivers/media/platform/coda/coda-common.c          |  106 +-
 drivers/media/platform/coda/coda.h                 |    3 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |    2 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   12 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   20 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   10 +-
 drivers/media/platform/omap3isp/isp.c              |  226 +--
 drivers/media/platform/omap3isp/isp.h              |    4 -
 drivers/media/platform/omap3isp/ispccdc.c          |    2 +-
 drivers/media/platform/omap3isp/isppreview.c       |   14 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  116 +-
 drivers/media/platform/omap3isp/ispvideo.h         |    1 -
 drivers/media/platform/omap3isp/omap3isp.h         |    8 +-
 drivers/media/platform/rcar_jpu.c                  |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   12 +
 drivers/media/platform/soc_camera/Kconfig          |   29 +-
 drivers/media/platform/soc_camera/Makefile         |    3 -
 drivers/media/platform/soc_camera/atmel-isi.c      |    4 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |  478 +++--
 drivers/media/platform/soc_camera/rcar_vin.c       |   41 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   14 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-dvb.c   |    2 +-
 drivers/media/platform/ti-vpe/Makefile             |    4 +
 drivers/media/platform/ti-vpe/cal.c                | 1947 ++++++++++++++++++++
 drivers/media/platform/ti-vpe/cal_regs.h           |  479 +++++
 drivers/media/platform/vim2m.c                     |    2 +-
 drivers/media/platform/vivid/vivid-osd.c           |    2 +-
 drivers/media/platform/vivid/vivid-tpg.c           |   32 +
 drivers/media/platform/vivid/vivid-tpg.h           |    2 +
 drivers/media/platform/vivid/vivid-vid-common.c    |   39 +-
 drivers/media/platform/vsp1/Makefile               |    3 +-
 drivers/media/platform/vsp1/vsp1.h                 |   29 +-
 drivers/media/platform/vsp1/vsp1_bru.c             |   33 +-
 drivers/media/platform/vsp1/vsp1_bru.h             |    3 +-
 drivers/media/platform/vsp1/vsp1_dl.c              |  305 +++
 drivers/media/platform/vsp1/vsp1_dl.h              |   42 +
 drivers/media/platform/vsp1/vsp1_drm.c             |  597 ++++++
 drivers/media/platform/vsp1/vsp1_drm.h             |   49 +
 drivers/media/platform/vsp1/vsp1_drv.c             |  382 ++--
 drivers/media/platform/vsp1/vsp1_entity.c          |   31 +-
 drivers/media/platform/vsp1/vsp1_entity.h          |   14 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |    2 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |   11 +-
 drivers/media/platform/vsp1/vsp1_lut.c             |    7 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |  426 +++++
 drivers/media/platform/vsp1/vsp1_pipe.h            |  134 ++
 drivers/media/platform/vsp1/vsp1_regs.h            |   32 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   88 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   29 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |    9 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |    8 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  518 +-----
 drivers/media/platform/vsp1/vsp1_video.h           |  111 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   98 +-
 drivers/media/radio/radio-si476x.c                 |    4 +-
 drivers/media/radio/tea575x.c                      |   21 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |    2 +-
 drivers/media/rc/ati_remote.c                      |   47 +-
 drivers/media/rc/igorplugusb.c                     |   17 +-
 drivers/media/rc/keymaps/rc-avermedia-rm-ks.c      |   56 +-
 drivers/media/rc/lirc_dev.c                        |    7 +-
 drivers/media/rc/mceusb.c                          |    5 +-
 drivers/media/rc/nuvoton-cir.c                     |  358 ++--
 drivers/media/rc/nuvoton-cir.h                     |   15 +-
 drivers/media/rc/rc-core-priv.h                    |    6 +-
 drivers/media/rc/rc-ir-raw.c                       |   23 +-
 drivers/media/rc/rc-main.c                         |   48 +-
 drivers/media/rc/sunxi-cir.c                       |    1 +
 drivers/media/tuners/m88rs6000t.c                  |   11 +-
 drivers/media/tuners/r820t.c                       |    2 +-
 drivers/media/tuners/si2157.c                      |   39 +-
 drivers/media/tuners/si2157.h                      |    5 +
 drivers/media/tuners/si2157_priv.h                 |    8 +
 drivers/media/tuners/tuner-xc2028.c                |    6 +-
 drivers/media/tuners/xc4000.c                      |    2 +-
 drivers/media/usb/airspy/airspy.c                  |   11 +-
 drivers/media/usb/as102/as102_drv.h                |    2 +-
 drivers/media/usb/as102/as102_usb_drv.c            |    2 +-
 drivers/media/usb/au0828/au0828-core.c             |  456 +++--
 drivers/media/usb/au0828/au0828-dvb.c              |   12 +-
 drivers/media/usb/au0828/au0828-video.c            |  190 +-
 drivers/media/usb/au0828/au0828.h                  |   27 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |    2 +-
 drivers/media/usb/cpia2/cpia2_core.c               |    2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |    2 +
 drivers/media/usb/cx231xx/cx231xx-audio.c          |    5 +
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   68 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |   10 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   47 +-
 drivers/media/usb/cx231xx/cx231xx.h                |    4 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |    6 +-
 drivers/media/usb/dvb-usb-v2/af9035.h              |    3 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_common.h      |    2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   15 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c         |    2 +-
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |    7 +
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c      |    4 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c      |    6 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h      |    8 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |    4 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   32 +-
 drivers/media/usb/dvb-usb-v2/usb_urb.c             |    2 +-
 drivers/media/usb/dvb-usb/a800.c                   |    4 +-
 drivers/media/usb/dvb-usb/af9005-fe.c              |    4 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |    4 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |    2 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |   77 +-
 drivers/media/usb/dvb-usb/dibusb-common.c          |    2 +-
 drivers/media/usb/dvb-usb/dibusb-mb.c              |    6 +-
 drivers/media/usb/dvb-usb/dibusb-mc.c              |    6 +-
 drivers/media/usb/dvb-usb/dibusb.h                 |    2 +-
 drivers/media/usb/dvb-usb/digitv.c                 |    4 +-
 drivers/media/usb/dvb-usb/dtt200u-fe.c             |    7 +-
 drivers/media/usb/dvb-usb/dtt200u.c                |    4 +-
 drivers/media/usb/dvb-usb/dtt200u.h                |    2 +-
 drivers/media/usb/dvb-usb/dvb-usb-common.h         |    2 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c            |   13 +-
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c       |    2 +-
 drivers/media/usb/dvb-usb/dvb-usb-i2c.c            |    2 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |    4 +-
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |    2 +-
 drivers/media/usb/dvb-usb/dvb-usb-urb.c            |    2 +-
 drivers/media/usb/dvb-usb/dvb-usb.h                |    2 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |  105 +-
 drivers/media/usb/dvb-usb/friio-fe.c               |   27 +-
 drivers/media/usb/dvb-usb/nova-t-usb2.c            |    4 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |   43 +-
 drivers/media/usb/dvb-usb/ttusb2.c                 |    2 +-
 drivers/media/usb/dvb-usb/umt-010.c                |    4 +-
 drivers/media/usb/dvb-usb/usb-urb.c                |    2 +-
 drivers/media/usb/dvb-usb/vp702x-fe.c              |    2 +-
 drivers/media/usb/dvb-usb/vp702x.c                 |    4 +-
 drivers/media/usb/dvb-usb/vp7045-fe.c              |    2 +-
 drivers/media/usb/dvb-usb/vp7045.c                 |    4 +-
 drivers/media/usb/dvb-usb/vp7045.h                 |    2 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |    4 +
 drivers/media/usb/em28xx/em28xx-cards.c            |  246 ++-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   21 +
 drivers/media/usb/em28xx/em28xx-video.c            |  213 ++-
 drivers/media/usb/em28xx/em28xx.h                  |   21 +-
 drivers/media/usb/go7007/go7007-priv.h             |    2 +-
 drivers/media/usb/go7007/go7007-usb.c              |    4 +-
 drivers/media/usb/gspca/ov519.c                    |   43 +-
 drivers/media/usb/gspca/touptek.c                  |    8 +-
 drivers/media/usb/gspca/w996Xcf.c                  |    8 +
 drivers/media/usb/hdpvr/hdpvr-core.c               |    2 +
 drivers/media/usb/hdpvr/hdpvr-video.c              |    6 +-
 drivers/media/usb/msi2500/msi2500.c                |    2 -
 drivers/media/usb/pvrusb2/pvrusb2-context.c        |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    3 +
 drivers/media/usb/pvrusb2/pvrusb2-io.c             |    2 +-
 drivers/media/usb/pwc/pwc-if.c                     |    6 +
 drivers/media/usb/siano/smsusb.c                   |   30 +-
 drivers/media/usb/stk1160/stk1160-video.c          |    1 -
 drivers/media/usb/usbtv/usbtv-video.c              |   37 +-
 drivers/media/usb/usbtv/usbtv.h                    |    1 +
 drivers/media/usb/usbvision/usbvision-video.c      |   29 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   20 +
 drivers/media/usb/uvc/uvcvideo.h                   |   12 +
 drivers/media/v4l2-core/Kconfig                    |    1 -
 drivers/media/v4l2-core/Makefile                   |    1 +
 drivers/media/v4l2-core/tuner-core.c               |   26 +-
 drivers/media/v4l2-core/v4l2-async.c               |    7 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   21 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   34 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |    3 +-
 drivers/media/v4l2-core/v4l2-fh.c                  |    2 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   36 +-
 drivers/media/v4l2-core/v4l2-mc.c                  |  403 ++++
 drivers/media/v4l2-core/v4l2-of.c                  |    2 +-
 drivers/media/v4l2-core/videobuf-core.c            |   10 +-
 drivers/media/v4l2-core/videobuf2-core.c           |    5 +
 drivers/media/v4l2-core/videobuf2-dvb.c            |   13 +-
 drivers/staging/media/Kconfig                      |    8 +-
 drivers/staging/media/Makefile                     |    5 +-
 .../staging/media/davinci_vpfe/davinci_vpfe_user.h |    2 +-
 drivers/staging/media/lirc/lirc_parallel.c         |   24 +-
 drivers/staging/media/lirc/lirc_zilog.c            |    4 +-
 drivers/staging/media/mn88473/Kconfig              |    7 -
 drivers/staging/media/mn88473/Makefile             |    5 -
 drivers/staging/media/mn88473/TODO                 |   21 -
 drivers/staging/media/mx2/Kconfig                  |   15 +
 drivers/staging/media/mx2/Makefile                 |    3 +
 drivers/staging/media/mx2/TODO                     |   10 +
 .../soc_camera => staging/media/mx2}/mx2_camera.c  |    0
 drivers/staging/media/mx3/Kconfig                  |   15 +
 drivers/staging/media/mx3/Makefile                 |    3 +
 drivers/staging/media/mx3/TODO                     |   10 +
 .../soc_camera => staging/media/mx3}/mx3_camera.c  |   12 +-
 drivers/staging/media/omap1/Kconfig                |   13 +
 drivers/staging/media/omap1/Makefile               |    3 +
 drivers/staging/media/omap1/TODO                   |    8 +
 .../media/omap1}/omap1_camera.c                    |    0
 drivers/staging/media/omap4iss/iss.c               |  211 +--
 drivers/staging/media/omap4iss/iss.h               |    6 +-
 drivers/staging/media/omap4iss/iss_video.c         |   15 +-
 drivers/staging/media/omap4iss/iss_video.h         |    1 -
 drivers/staging/media/timb/Kconfig                 |   11 +
 drivers/staging/media/timb/Makefile                |    1 +
 .../platform => staging/media/timb}/timblogiw.c    |    0
 drivers/usb/musb/sunxi.c                           |    1 +
 include/{media/i2c => dt-bindings/media}/tvp5150.h |    8 +-
 include/media/media-device.h                       |  149 ++
 include/media/media-entity.h                       |   20 +
 include/media/rc-core.h                            |    2 +
 include/media/tuner.h                              |    9 +-
 include/media/v4l2-ctrls.h                         |   12 -
 include/media/v4l2-dev.h                           |    1 +
 include/media/v4l2-mc.h                            |  243 +++
 include/media/v4l2-subdev.h                        |    3 +
 include/media/videobuf2-dvb.h                      |    5 +
 include/media/vsp1.h                               |   33 +
 include/uapi/linux/media.h                         |   45 +-
 include/uapi/linux/v4l2-common.h                   |   46 +-
 include/uapi/linux/v4l2-controls.h                 |   11 +
 include/uapi/linux/videodev2.h                     |    7 +
 sound/usb/Kconfig                                  |    4 +
 sound/usb/Makefile                                 |    2 +
 sound/usb/card.c                                   |   14 +
 sound/usb/card.h                                   |    3 +
 sound/usb/media.c                                  |  318 ++++
 sound/usb/media.h                                  |   72 +
 sound/usb/mixer.h                                  |    3 +
 sound/usb/pcm.c                                    |   28 +-
 sound/usb/quirks-table.h                           |    1 +
 sound/usb/stream.c                                 |    2 +
 sound/usb/usbaudio.h                               |    6 +
 398 files changed, 12321 insertions(+), 4923 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-rc-nuvoton
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-y12i.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-y8i.xml
 rename Documentation/DocBook/media/v4l/{pixfmt-yvu420m.xml => pixfmt-yuv422m.xml} (58%)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-z16.xml
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp5150.txt
 create mode 100644 Documentation/devicetree/bindings/media/ti-cal.txt
 rename drivers/{staging/media/mn88473 => media/dvb-frontends}/mn88473.c (61%)
 rename drivers/{staging/media/mn88473 => media/dvb-frontends}/mn88473_priv.h (89%)
 create mode 100644 drivers/media/platform/ti-vpe/cal.c
 create mode 100644 drivers/media/platform/ti-vpe/cal_regs.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_dl.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_dl.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_drm.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_drm.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_pipe.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_pipe.h
 create mode 100644 drivers/media/v4l2-core/v4l2-mc.c
 delete mode 100644 drivers/staging/media/mn88473/Kconfig
 delete mode 100644 drivers/staging/media/mn88473/Makefile
 delete mode 100644 drivers/staging/media/mn88473/TODO
 create mode 100644 drivers/staging/media/mx2/Kconfig
 create mode 100644 drivers/staging/media/mx2/Makefile
 create mode 100644 drivers/staging/media/mx2/TODO
 rename drivers/{media/platform/soc_camera => staging/media/mx2}/mx2_camera.c (100%)
 create mode 100644 drivers/staging/media/mx3/Kconfig
 create mode 100644 drivers/staging/media/mx3/Makefile
 create mode 100644 drivers/staging/media/mx3/TODO
 rename drivers/{media/platform/soc_camera => staging/media/mx3}/mx3_camera.c (98%)
 create mode 100644 drivers/staging/media/omap1/Kconfig
 create mode 100644 drivers/staging/media/omap1/Makefile
 create mode 100644 drivers/staging/media/omap1/TODO
 rename drivers/{media/platform/soc_camera => staging/media/omap1}/omap1_camera.c (100%)
 create mode 100644 drivers/staging/media/timb/Kconfig
 create mode 100644 drivers/staging/media/timb/Makefile
 rename drivers/{media/platform => staging/media/timb}/timblogiw.c (100%)
 rename include/{media/i2c => dt-bindings/media}/tvp5150.h (87%)
 create mode 100644 include/media/v4l2-mc.h
 create mode 100644 include/media/vsp1.h
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

