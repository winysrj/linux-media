Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47387
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbcGYLSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 07:18:42 -0400
Date: Mon, 25 Jul 2016 08:18:35 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.8-rc1] media updates - part 1
Message-ID: <20160725081835.1812283e@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.8-1


For:
  - New framework support for HDMI CEC and remote control support;
  - New encoding codec driver for Mediatek SoC;
  - New frontend driver: helene tuner;
  - Added support for NetUp almost universal devices, with supports
    DVB-C/S/S2/T/T2 and ISDB-T.
  - The mn88472 frontend driver got promoted from staging;
  - A new driver for RCar video input;
  - some soc_camera legacy drivers got removed: timb, omap1, mx2, mx3;
  - Lots of driver cleanups, improvements and fixups.

Thanks,
Mauro

---


The following changes since commit a99cde438de0c4c0cecc1d1af1a55a75b10bfdef:

  Linux 4.7-rc6 (2016-07-03 23:01:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.8-1

for you to fetch changes up to 009a620848218d521f008141c62f56bf19294dd9:

  [media] cec: always check all_device_types and features (2016-07-19 13:27:46 -0300)

----------------------------------------------------------------
media updates for v4.8-rc1

----------------------------------------------------------------
Aayush Gupta (1):
      [media] drivers: staging: media: lirc: lirc_parallel: Fix multiline comments by adding trailing '*'

Abylay Ospan (18):
      [media] Add support Sony HELENE Sat/Ter Tuner
      [media] Add support Sony CXD2854ER demodulator
      [media] Fix DVB-S/S2 tune for sony ascot3a tuner
      [media] New hw revision 1.4 of NetUP Universal DVB card added
      [media] Fix CAM module memory read/write
      [media] MAINTAINERS: Add a maintainer for netup_unidvb, cxd2841er, horus3a, ascot2e
      [media] Add carrier offset calculation for DVB-T
      [media] Sanity check when initializing DVB-S/S2 demodulator
      [media] Fix DVB-T frequency offset calculation
      [media] fix DVB-S/S2 tuning
      [media] support DVB-T2 for SONY CXD2841/54
      [media] Change frontend allocation strategy for NetUP Universal DVB cards
      [media] fix typo in SONY demodulator description
      MAINTAINERS: Add Sony Helene TV tuner entry
      [media] DVB-C read signal strength added for Sony demod
      [media] cxd2841er: fix switch-case for DVB-C
      [media] cxd2841er: Reading BER and UCB for DVB-C added
      [media] cxd2841er: Reading SNR for DVB-C added

Alessandro Radicati (2):
      [media] af9035: I2C combined write + read transaction fix
      [media] af9035: fix for MXL5007T devices with I2C read issues

Alexander Shiyan (1):
      [media] media: coda: Fix probe() if reset controller is missing

Alexey Khoroshilov (2):
      [media] radio-maxiradio: fix memory leak when device is removed
      [media] bt8xx: remove needless module refcounting

Amitoj Kaur Chawla (2):
      [media] saa7164: Replace if and BUG with BUG_ON
      [media] ddbridge: Replace vmalloc with vzalloc

Andi Shyti (14):
      [media] lirc_dev: place buffer allocation on separate function
      [media] lirc_dev: allow bufferless driver registration
      [media] lirc_dev: remove unnecessary debug prints
      [media] lirc_dev: replace printk with pr_* or dev_*
      [media] lirc_dev: simplify goto paths
      [media] lirc_dev: do not use goto to create loops
      [media] lirc_dev: simplify if statement in lirc_add_to_buf
      [media] lirc_dev: remove double if ... else statement
      [media] lirc_dev: merge three if statements in only one
      [media] lirc_dev: fix variable constant comparisons
      [media] lirc_dev: fix error return value
      [media] lirc_dev: extremely trivial comment style fix
      [media] lirc_dev: fix potential segfault
      [media] lirc_dev: use LIRC_CAN_REC() define to check if the device can receive

Andrew Morton (1):
      [media] cec-adap.c: work around gcc-4.4.4 anon union initializer bug

Andrew-CT Chen (3):
      [media] dt-bindings: Add a binding for Mediatek Video Processor
      [media] VPU: mediatek: support Mediatek VPU
      [media] arm64: dts: mediatek: Add node for Mediatek Video Processor Unit

Andrey Utkin (1):
      [media] media: solo6x10: increase FRAME_BUF_SIZE

Antonio Ospite (5):
      [media] gspca: ov534/topro: use a define for the default framerate
      [media] gspca: fix setting frame interval type in vidioc_enum_frameintervals()
      [media] gspca: rename wxh_to_mode() to wxh_to_nearest_mode()
      [media] gspca: fix a v4l2-compliance failure about VIDIOC_ENUM_FRAMEINTERVALS
      [media] gspca: fix a v4l2-compliance failure about buffer timestamp

Antti Palosaari (19):
      [media] mn88473: fix error path on probe()
      [media] rtl28xxu: increase failed I2C msg repeat count to 3
      [media] mn88472: finalize driver
      [media] mn88472: move out of staging to media
      [media] af9035: fix logging
      [media] si2168: add support for newer firmwares
      [media] si2168: do not allow driver unbind
      [media] si2157: do not allow driver unbind
      [media] m88ds3103: remove useless most significant bit clear
      [media] m88ds3103: calculate DiSEqC message sending time
      [media] m88ds3103: improve ts clock setting
      [media] m88ds3103: use Hz instead of kHz on calculations
      [media] m88ds3103: refactor firmware download
      [media] af9033: move statistics to read_status()
      [media] af9033: do not allow driver unbind
      [media] it913x: do not allow driver unbind
      [media] rtl2830: do not allow driver unbind
      [media] rtl2830: move statistics to read_status()
      [media] rtl2832: do not allow driver unbind

Arnd Bergmann (8):
      [media] pwc: hide unused label
      [media] gspca: avoid unused variable warnings
      [media] dvb: use ktime_t for internal timeout
      [media] s5p_cec: mark suspend/resume as __maybe_unused
      [media] cec: add MEDIA_SUPPORT dependency
      [media] vsp1: use __maybe_unused for PM handlers
      [media] vsp1: clarify FCP dependency
      [media] mtk-vcodec: fix more type mismatches

Axel Lin (1):
      [media] v4l: mt9v032: Remove duplicate test for I2C_FUNC_SMBUS_WORD_DATA functionality

Bhaktipriya Shridhar (6):
      [media] sn9c20x: Remove deprecated create_singlethread_workqueue
      [media] adv7842: Remove deprecated create_singlethread_workqueue
      [media] tc358743: Remove deprecated create_singlethread_workqueue
      [media] adv7604: Remove deprecated create_singlethread_workqueue
      [media] hdpvr: Remove deprecated create_singlethread_workqueue
      [media] zc3xx: Remove deprecated create_singlethread_workqueue

Colin Ian King (3):
      [media] m88rs2000: initialize status to zero
      [media] netup_unidvb: trivial fix of spelling mistake "initizalize" -> "initialize"
      [media] mb86a20s: apply mask to val after checking for read failure

Dan Carpenter (2):
      [media] em28xx-i2c: rt_mutex_trylock() returns zero on failure
      [media] dvb-usb: silence an uninitialized variable warning

Dragos Bogdan (1):
      [media] adv7604: Add support for hardware reset

Ezequiel Garcia (7):
      [media] tw686x: Introduce an interface to support multiple DMA modes
      [media] tw686x: Add support for DMA contiguous interlaced frame mode
      [media] tw686x: Add support for DMA scatter-gather mode
      [media] tw686x: audio: Implement non-memcpy capture
      [media] tw686x: audio: Allow to configure the period size
      [media] tw686x: audio: Prevent hw param changes while busy
      [media] tw686x: Support VIDIOC_{S,G}_PARM ioctls

Fengguang Wu (2):
      [media] fix semicolon.cocci warnings
      [media] mtk-vcodec: fix platform_no_drv_owner.cocci warnings

Florian Echtler (2):
      [media] sur40: lower poll interval to fix occasional FPS drops to ~56 FPS
      [media] sur40: fix occasional oopses on device close

Guennadi Liakhovetski (2):
      [media] v4l: mt9t001: fix clean up in case of power-on failures
      [media] V4L: fix the Z16 format definition

Hans Verkuil (95):
      [media] staging/media: remove deprecated mx2 driver
      [media] staging/media: remove deprecated mx3 driver
      [media] staging/media: remove deprecated omap1 driver
      [media] staging/media: remove deprecated timb driver
      [media] cec.txt: add CEC framework documentation
      [media] tw686x: be explicit about the possible dma_mode options
      [media] v4l2-ctrl.h: fix comments
      [media] cec-edid: add module for EDID CEC helper functions
      [media] cec.h: add cec header
      [media] cec-funcs.h: static inlines to pack/unpack CEC messages
      [media] cec: add HDMI CEC framework (core)
      [media] cec: add HDMI CEC framework (adapter)
      [media] cec: add HDMI CEC framework (api)
      [media] cec/TODO: add TODO file so we know why this is still in staging
      [media] cec: add compat32 ioctl support
      [media] cec: adv7604: add cec support
      [media] cec: adv7842: add cec support
      [media] cec: adv7511: add cec support
      [media] vivid: add CEC emulation
      [media] DocBook/media: add CEC documentation
      [media] vb2: move dma_attrs to vb2_queue
      [media] vb2: add a dev field to use for the default allocation context
      [media] v4l2-pci-skeleton: set q->dev instead of allocating a context
      [media] sur40: set q->dev instead of allocating a context
      [media] media/pci: convert drivers to use the new vb2_queue dev field
      [media] media/pci/tw686x: convert driver to use the new vb2_queue dev field
      [media] staging/media: convert drivers to use the new vb2_queue dev field
      [media] media/platform: convert drivers to use the new vb2_queue dev field
      [media] media/platform: convert drivers to use the new vb2_queue dev field
      [media] media/platform: convert drivers to use the new vb2_queue dev field
      [media] media/.../soc-camera: convert drivers to use the new vb2_queue dev field
      [media] media/platform: convert drivers to use the new vb2_queue dev field
      [media] media/platform: convert drivers to use the new vb2_queue dev field
      [media] vb2: replace void *alloc_ctxs by struct device *alloc_devs
      [media] MAINTAINERS: change maintainer for gscpa/pwc/radio-shark
      [media] mtk-vcodec: convert driver to use the new vb2_queue dev field
      [media] drivers/media/platform/Kconfig: fix VIDEO_MEDIATEK_VCODEC dependency
      [media] v4l2-tpg: ignore V4L2_DV_RGB_RANGE setting for YUV formats
      [media] rc-main: fix kernel oops after unloading keymap module
      [media] sur40: drop unnecessary format description
      [media] tw686x: make const structs static
      [media] cec-adap: on reply, restore the tx_status value from the transmit
      [media] cec.h/cec-funcs.h: add option to use BSD license
      [media] cec-adap: prevent write to out-of-bounds array index
      [media] cec: fix Kconfig dependency problems
      [media] cec-funcs.h: add length checks
      [media] cec-funcs.h: add missing const modifier
      [media] cec-funcs.h: add missing 'reply' for short audio descriptor
      [media] mtk-vcodec: fix two compiler warnings
      [media] mtk-vcodec: fix compiler warning
      [media] omap_vout: use control framework
      [media] saa7164: drop unused saa7164_ctrl struct
      [media] davinci: drop unused control callbacks
      [media] pvrusb2: use v4l2_s_ctrl instead of the s_ctrl op
      [media] usbvision: use v4l2_ctrl_g_ctrl instead of the g_ctrl op
      [media] mcam-core: use v4l2_s_ctrl instead of the s_ctrl op
      [media] via-camera: use v4l2_s_ctrl instead of the s_ctrl op
      [media] cx231xx: use v4l2_s_ctrl instead of the s_ctrl op
      [media] cx88: use wm8775_s_ctrl instead of the s_ctrl op
      [media] v4l2-flash-led: remove unused ops
      [media] cx18: use v4l2_g/s_ctrl instead of the g/s_ctrl ops
      [media] ivtv: use v4l2_g/s_ctrl instead of the g/s_ctrl ops
      [media] media/i2c: drop the last users of the ctrl core ops
      [media] v4l2-subdev.h: remove the control subdev ops
      [media] vivid: set V4L2_CAP_TIMEPERFRAME
      [media] af9033: fix compiler warnings
      [media] adv7511: drop adv7511_set_IT_content_AVI_InfoFrame
      [media] adv7511: fix quantization range handling
      [media] adv7604/adv7842: fix quantization range handling
      [media] ezkit/cobalt: drop unused op_656_range setting
      [media] adv7604/adv7842: drop unused op_656_range and alt_data_sat fields
      [media] v4l2-ioctl: zero the v4l2_bt_timings reserved field
      [media] adv7511: the h/vsync polarities were always positive
      [media] cec: add check if adapter is unregistered
      [media] cec: CEC_RECEIVE is allowed in monitor mode
      [media] input: serio - add new protocol for the Pulse-Eight USB-CEC Adapter
      [media] pulse8-cec: new driver for the Pulse-Eight USB-CEC Adapter
      [media] MAINTAINERS: add entry for the pulse8-cec driver
      [media] pulse8-cec: add TODO file
      [media] cec: add sanity check for msg->len
      [media] cec: split the timestamp into an rx and tx timestamp
      [media] cec: don't zero reply and timeout on error
      [media] vivid: fix typo causing incorrect CEC physical addresses
      [media] cec: set timestamp for selfie transmits
      [media] cec/TODO: drop comment about sphinx documentation
      [media] s5p-cec/TODO: add TODO item
      [media] cec: CEC_RECEIVE overwrote the timeout field
      [media] cec: clear all status fields before transmit and always fill in sequence
      [media] cec: don't set fh to NULL in CEC_TRANSMIT
      [media] cec: zero unused msg part after msg->len
      [media] cec: limit the size of the transmit queue
      [media] cec: fix test for unconfigured adapter in main message loop
      [media] vivid: support monitor all mode
      [media] cec: poll should check if there is room in the tx queue
      [media] cec: always check all_device_types and features

Heiner Kallweit (11):
      [media] media: rc: nuvoton: fix rx fifo overrun handling
      [media] media: rc: nuvoton: remove interrupt handling for wakeup
      [media] media: rc: nuvoton: clean up initialization of wakeup registers
      [media] media: rc: nuvoton: remove wake states
      [media] media: rc: nuvoton: simplify a few functions
      [media] media: rc: nuvoton: remove unneeded code in nvt_process_rx_ir_data
      [media] media: rc: nuvoton: remove study states
      [media] media: rc: nuvoton: simplify interrupt handling code
      [media] media: rc: nuvoton: remove unneeded check in nvt_get_rx_ir_data
      [media] media: rc: nuvoton: remove two unused elements in struct nvt_dev
      [media] rc: nuvoton: fix hang if chip is configured for alternative EFM IO address

Helen Fornazier (1):
      [media] stk1160: Check *nplanes in queue_setup

Ismael Luceno (1):
      [media] solo6x10: Simplify solo_enum_ext_input

James Patrick-Evans (1):
      [media] airspy: fix error logic during device register

Javier Martinez Canillas (11):
      s5p-mfc: Set device name for reserved memory region devs
      s5p-mfc: Add release callback for memory region devs
      s5p-mfc: Fix race between s5p_mfc_probe() and s5p_mfc_open()
      [media] s5p-mfc: Don't try to put pm->clock if lookup failed
      [media] s5p-mfc: fix typo in s5p_mfc_dec function comment
      [media] s5p-mfc: don't print errors on VIDIOC_REQBUFS unsupported mem type
      [media] s5p-mfc: use vb2_is_streaming() to check vb2 queue status
      [media] s5p-mfc: set capablity bus_info as required by VIDIOC_QUERYCAP
      [media] s5p-mfc: improve v4l2_capability driver and card fields
      [media] DocBook: add dmabuf as streaming I/O in VIDIOC_REQBUFS description
      [media] DocBook: mention the memory type to be set for all streaming I/O

Jonathan McDowell (3):
      [media] Fix RC5 decoding with Fintek CIR chipset
      [media] Convert Wideview WT220 DVB USB driver to rc-core
      [media] Remove spurious blank lines in dw2101 kernel messages

Julia Lawall (3):
      [media] mn88473: fix typo
      [media] mn88472: fix typo
      [media] v4l: mt9t001: constify v4l2_subdev_internal_ops structure

Kamil Debski (3):
      [media] rc: Add HDMI CEC protocol handling
      [media] cec: s5p-cec: Add s5p-cec driver
      [media] rc-cec: Add HDMI CEC keymap module

Laurent Pinchart (40):
      [media] dt-bindings: Add Renesas R-Car FCP DT bindings
      [media] v4l: Add Renesas R-Car FCP driver
      [media] v4l: vsp1: Implement runtime PM support
      [media] v4l: vsp1: Don't handle clocks manually
      [media] v4l: vsp1: Add FCP support
      [media] v4l: vsp1: Add output node value to routing table
      [media] v4l: vsp1: Replace container_of() with dedicated macro
      [media] v4l: vsp1: Make vsp1_entity_get_pad_compose() more generic
      [media] v4l: vsp1: Move frame sequence number from video node to pipeline
      [media] v4l: vsp1: Group DRM RPF parameters in a structure
      [media] drm: rcar-du: Add alpha support for VSP planes
      [media] drm: rcar-du: Add Z-order support for VSP planes
      [media] v4l: vsp1: Remove deprecated DRM API
      [media] v4l: mt9v032: Remove unneeded header
      [media] adv7604: Don't ignore pad number in subdev DV timings pad operations
      [media] videodev2.h: Group YUV 3 planes formats together
      [media] videodev2.h: Fix V4L2_PIX_FMT_YUV411P description
      [media] v4l: vsp1: Fix typo in register field names
      [media] v4l: vsp1: Fix descriptions of Gen2 VSP instances
      [media] v4l: vsp1: Fix crash when resetting pipeline
      [media] v4l: vsp1: pipe: Fix typo in comment
      [media] v4l: vsp1: Constify operation structures
      [media] v4l: vsp1: Stop the pipeline upon the first STREAMOFF
      [media] v4l: vsp1: sru: Fix intensity control ID
      [media] media: Add video processing entity functions
      [media] media: Add video statistics computation functions
      [media] v4l: vsp1: Base link creation on availability of entities
      [media] v4l: vsp1: Don't register media device when userspace API is disabled
      [media] v4l: vsp1: Don't create LIF entity when the userspace API is enabled
      [media] v4l: vsp1: Set entities functions
      [media] v4l: vsp1: dl: Don't free fragments with interrupts disabled
      [media] v4l: vsp1: lut: Initialize the mutex
      [media] v4l: vsp1: lut: Expose configuration through a control
      [media] v4l: vsp1: Add Cubic Look Up Table (CLU) support
      [media] v4l: vsp1: Support runtime modification of controls
      [media] v4l: vsp1: lut: Support runtime modification of controls
      [media] v4l: vsp1: clu: Support runtime modification of controls
      [media] v4l: vsp1: Simplify alpha propagation
      [media] v4l: vsp1: rwpf: Support runtime modification of controls
      [media] v4l: vsp1: wpf: Add flipping support

Lubomir Rintel (2):
      [media] usbtv: clarify the licensing
      [media] usbtv: improve a comment

Marek Szyprowski (9):
      media: vb2-dma-contig: add helper for setting dma max seg size
      media: set proper max seg size for devices on Exynos SoCs
      of: reserved_mem: add support for using more than one region for given device
      media: s5p-mfc: use generic reserved memory bindings
      media: s5p-mfc: replace custom reserved memory handling code with generic one
      media: s5p-mfc: add iommu support
      [media] media: s5p-mfc: fix compilation issue on archs other than ARM (32bit)
      [media] of: reserved_mem: restore old behavior when no region is defined
      [media] s5p-mfc: fix error path in driver probe

Markus Pargmann (2):
      [media] v4l: mt9v032: Do not unset master_mode
      [media] v4l: mt9v032: Add V4L2 controls for AEC and AGC

Martin Blumenstingl (3):
      [media] rtl28xxu: auto-select more DVB-frontends and tuners
      [media] rtl28xxu: sort the config symbols which are auto-selected
      [media] rtl2832: add support for slave ts pid filter

Matthew Leach (1):
      [media] media: usbtv: prevent access to free'd resources

Mauro Carvalho Chehab (44):
      Merge tag 'v4.6' into patchwork
      Merge tag 'v4.7-rc1' into patchwork
      Merge branch 'for-v4.8/media/exynos-mfc' of git://linuxtv.org/snawrocki/samsung into patchwork
      [media] ISDB-T retune and offset fix and DVB-C bw fix
      [media] helene: fix a warning when printing sizeof()
      Update my main e-mails at the Kernel tree
      [media] media-devnode: fix namespace mess
      [media] media-device: dynamically allocate struct media_devnode
      [media] rcar-vin: get rid of an unused var
      [media] media-devnode.h: Fix documentation
      Merge branch 'cec-defines' of git://git.kernel.org/.../dtor/input into topic/cec
      usbvision: remove some unused vars
      exynos4-is: remove some unused vars
      cx18: use macros instead of static const vars
      m5602_core: move skeletons to the .c file
      m5602_s5k4aa: move skeletons to the .c file
      m5602_mt9m111: move skeletons to the .c file
      m5602_ov9650: move skeletons to the .c file
      m5602_s5k83a: move skeletons to the .c file
      m5602_po1030: move skeletons to the .c file
      m5602_ov7660: move skeletons to the .c file
      cx25821-alsa: shutup a Gcc 6.1 warning
      drxj: comment out the unused nicam_presc_table_val table
      dib0090: comment out the unused tables
      r820t: comment out two ancillary tables
      zr36016: remove some unused tables
      vivid: remove some unused vars
      em28xx-dvb: remove some left over
      adv7842: comment out a table useful for debug
      bdisp: move the V/H filter spec to bdisp-hw.c
      [media] move s5p-cec to staging
      [media] s5p_cec: get rid of an unused var
      Merge tag 'v4.7-rc6' into patchwork
      Merge branch 'topic/cec' into patchwork
      [media] cxd2841er: Do some changes at the dvbv5 stats logic
      [media] cxd2841er: Fix signal strengh for DVB-T/T2 and show it in dBm
      [media] cxd2841er: don't expose a dvbv5 stats to userspace if not available
      [media] pulse8-cec: declare function as static
      [media] tw686x: use a formula instead of two tables for div
      Merge branch 'topic/vsp1' into patchwork
      [media] cxd2841er: fix BER report via DVBv5 stats API
      [media] cxd2841er: provide signal strength for DVB-C
      [media] cxd2841er: adjust the dB scale for DVB-C
      [media] cxd2841er: fix signal strength scale for ISDB-T

Max Kellermann (3):
      [media] drivers/media/dvb-core/en50221: move code to dvb_ca_private_free()
      [media] dvb_frontend: eliminate blocking wait in dvb_unregister_frontend()
      [media] dvb-core/en50221: use kref to manage struct dvb_ca_private

Nicolas Dufresne (1):
      [media] uvcvideo: Fix bytesperline calculation for planar YUV

Niklas SÃ¶derlund (1):
      [media] rcar-vin: add Renesas R-Car VIN driver

Oliver Neukum (2):
      [media] uvcvideo: Correct speed testing
      [media] gspca: correct speed testing

Olli Salonen (2):
      [media] ds3000: return error if invalid symbol rate is set
      [media] dw2102: add USB ID for Terratec Cinergy S2 Rev.3

Ricardo Ribalda Delgado (4):
      [media] vb2: V4L2_BUF_FLAG_DONE is set after DQBUF
      [media] vb2: Merge vb2_internal_dqbuf and vb2_dqbuf
      [media] vb2: Merge vb2_internal_qbuf and vb2_qbuf
      [media] vb2: Fix comment

Sakari Ailus (3):
      [media] vb2: core: Skip planes array verification if pb is NULL
      [media] videobuf2-v4l2: Verify planes array in buffer dequeueing
      [media] smiapp: Remove useless rval assignment in smiapp_get_pdata()

Saso Slavicic (1):
      [media] ascot2e: Fix I2C message size check

Sean Young (4):
      [media] rc: make s_tx_mask consistent
      [media] rc: make s_tx_carrier consistent
      [media] redrat3: fix timeout handling
      [media] redrat3: make hardware timeout configurable

Shuah Khan (5):
      [media] media: fix use-after-free in cdev_put() when app exits after driver unbind
      [media] media: fix media devnode ioctl/syscall and unregister race
      [media] s5p-mfc: fix video device release double release in probe error path
      [media] s5p-mfc: fix memory leak in s5p_mfc_remove()
      [media] s5p-mfc: fix null pointer deference in clk_core_enable()

Soeren Moch (1):
      [media] media: dvb_ringbuffer: Add memory barriers

Stefan PÃ¶schel (1):
      [media] af9035: fix dual tuner detection with PCTV 79e

Stephen Backway (1):
      [media] cx23885: Add support for Hauppauge WinTV quadHD DVB version

Sudip Mukherjee (1):
      [media] c8sectpfe: fix memory leak

Sylwester Nawrocki (1):
      [media] exynos4-is: Fix buffer release issue on fimc m2m video nodes

Tiffany Lin (7):
      [media] dt-bindings: Add a binding for Mediatek Video Encoder
      [media] vcodec: mediatek: Add Mediatek V4L2 Video Encoder Driver
      [media] vcodec: mediatek: Add Mediatek VP8 Video Encoder Driver
      [media] vcodec: mediatek: Add Mediatek H264 Video Encoder Driver
      [media] arm64: dts: mediatek: Add Video Encoder for MT8173
      [media] mtk-vcodec: fix sparse warning
      [media] mtk-vcodec: fix default OUTPUT buffer size

Ulrich Hecht (3):
      [media] media: rcar-vin: pad-aware driver initialisation
      [media] media: rcar_vin: Use correct pad number in try_fmt
      [media] media: rcar-vin: add DV timings support

Wei Yongjun (5):
      [media] VPU: mediatek: fix return value check in mtk_vpu_probe()
      [media] VPU: mediatek: remove redundant dev_err call in mtk_vpu_probe()
      [media] vcodec: mediatek: Fix return value check in mtk_vcodec_init_enc_pm()
      [media] mtk-vcodec: remove redundant dev_err call in mtk_vcodec_probe()
      [media] pulse8-cec: fix non static symbol warning

Zhaoxiu Zeng (1):
      [media] mt2063: use lib gcd

ayaka (4):
      [media] s5p-mfc: don't close instance after free OUTPUT buffers
      [media] s5p-mfc: Add handling of buffer freeing reqbufs request
      [media] s5p-mfc: remove unnecessary check in try_fmt
      [media] s5p-mfc: fix a typo in s5p_mfc_dec

 Documentation/DocBook/device-drivers.tmpl          |    3 +
 Documentation/DocBook/media/Makefile               |    2 +
 Documentation/DocBook/media/v4l/biblio.xml         |   10 +
 Documentation/DocBook/media/v4l/cec-api.xml        |   75 +
 Documentation/DocBook/media/v4l/cec-func-close.xml |   64 +
 Documentation/DocBook/media/v4l/cec-func-ioctl.xml |   78 +
 Documentation/DocBook/media/v4l/cec-func-open.xml  |  104 ++
 Documentation/DocBook/media/v4l/cec-func-poll.xml  |   94 +
 .../DocBook/media/v4l/cec-ioc-adap-g-caps.xml      |  151 ++
 .../DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml |  329 ++++
 .../DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml |   86 +
 .../DocBook/media/v4l/cec-ioc-dqevent.xml          |  202 ++
 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml |  255 +++
 .../DocBook/media/v4l/cec-ioc-receive.xml          |  274 +++
 Documentation/DocBook/media/v4l/io.xml             |    4 +-
 .../DocBook/media/v4l/lirc_device_interface.xml    |    2 +-
 Documentation/DocBook/media/v4l/media-types.xml    |   64 +
 Documentation/DocBook/media/v4l/pixfmt-z16.xml     |    2 +-
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |    2 +-
 Documentation/DocBook/media_api.tmpl               |    6 +-
 Documentation/cec.txt                              |  267 +++
 .../devicetree/bindings/media/mediatek-vcodec.txt  |   59 +
 .../devicetree/bindings/media/mediatek-vpu.txt     |   31 +
 .../devicetree/bindings/media/renesas,fcp.txt      |   32 +
 .../devicetree/bindings/media/renesas,vsp1.txt     |    5 +
 .../devicetree/bindings/media/s5p-cec.txt          |   31 +
 .../devicetree/bindings/media/s5p-mfc.txt          |   39 +-
 Documentation/video4linux/CARDLIST.cx23885         |    1 +
 Documentation/video4linux/v4l2-controls.txt        |   15 -
 Documentation/video4linux/vivid.txt                |   36 +-
 MAINTAINERS                                        |   74 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   62 +
 arch/blackfin/mach-bf609/boards/ezkit.c            |    2 -
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c              |   45 +-
 drivers/gpu/drm/rcar-du/rcar_du_vsp.h              |    2 +
 drivers/input/touchscreen/sur40.c                  |   21 +-
 drivers/media/Kconfig                              |    3 +
 drivers/media/Makefile                             |    4 +
 drivers/media/cec-edid.c                           |  168 ++
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |    4 +-
 drivers/media/dvb-core/demux.h                     |    2 +-
 drivers/media/dvb-core/dmxdev.c                    |    2 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |   39 +-
 drivers/media/dvb-core/dvb_demux.c                 |   17 +-
 drivers/media/dvb-core/dvb_demux.h                 |    4 +-
 drivers/media/dvb-core/dvb_frontend.c              |   33 +-
 drivers/media/dvb-core/dvb_net.c                   |    2 +-
 drivers/media/dvb-core/dvb_ringbuffer.c            |   74 +-
 drivers/media/dvb-frontends/Kconfig                |   15 +
 drivers/media/dvb-frontends/Makefile               |    2 +
 drivers/media/dvb-frontends/af9033.c               |  327 ++--
 drivers/media/dvb-frontends/ascot2e.c              |    2 +-
 drivers/media/dvb-frontends/cxd2841er.c            | 1931 +++++++++++++++-----
 drivers/media/dvb-frontends/cxd2841er.h            |   24 +-
 drivers/media/dvb-frontends/cxd2841er_priv.h       |    1 +
 drivers/media/dvb-frontends/dib0090.c              |    6 +
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |    3 +
 drivers/media/dvb-frontends/ds3000.c               |    9 +
 drivers/media/dvb-frontends/helene.c               | 1042 +++++++++++
 drivers/media/dvb-frontends/helene.h               |   79 +
 drivers/media/dvb-frontends/horus3a.c              |   26 +-
 drivers/media/dvb-frontends/m88ds3103.c            |  144 +-
 drivers/media/dvb-frontends/m88ds3103_priv.h       |    3 +-
 drivers/media/dvb-frontends/m88rs2000.c            |    2 +-
 drivers/media/dvb-frontends/mb86a20s.c             |    3 +-
 .../mn88472 => media/dvb-frontends}/mn88472.c      |  519 +++---
 drivers/media/dvb-frontends/mn88472.h              |   45 +-
 .../mn88472 => media/dvb-frontends}/mn88472_priv.h |   11 +-
 drivers/media/dvb-frontends/mn88473.c              |    7 +-
 drivers/media/dvb-frontends/rtl2830.c              |  203 +-
 drivers/media/dvb-frontends/rtl2830_priv.h         |    2 +-
 drivers/media/dvb-frontends/rtl2832.c              |   26 +-
 drivers/media/dvb-frontends/rtl2832_priv.h         |    1 +
 drivers/media/dvb-frontends/rtl2832_sdr.c          |    2 +-
 drivers/media/dvb-frontends/si2168.c               |  127 +-
 drivers/media/dvb-frontends/si2168_priv.h          |    8 +-
 drivers/media/i2c/Kconfig                          |   24 +
 drivers/media/i2c/adv7511.c                        |  445 ++++-
 drivers/media/i2c/adv7604.c                        |  439 ++++-
 drivers/media/i2c/adv7842.c                        |  413 ++++-
 drivers/media/i2c/cs53l32a.c                       |    7 -
 drivers/media/i2c/cx25840/cx25840-core.c           |    7 -
 drivers/media/i2c/msp3400-driver.c                 |    7 -
 drivers/media/i2c/mt9t001.c                        |   17 +-
 drivers/media/i2c/mt9v032.c                        |  279 ++-
 drivers/media/i2c/saa7115.c                        |    7 -
 drivers/media/i2c/smiapp/smiapp-core.c             |    4 +-
 drivers/media/i2c/tc358743.c                       |   15 +-
 drivers/media/i2c/tvaudio.c                        |    7 -
 drivers/media/i2c/wm8775.c                         |    7 -
 drivers/media/media-device.c                       |   47 +-
 drivers/media/media-devnode.c                      |  149 +-
 drivers/media/pci/bt8xx/dst_ca.c                   |    2 -
 drivers/media/pci/cobalt/cobalt-driver.c           |   11 -
 drivers/media/pci/cobalt/cobalt-driver.h           |    1 -
 drivers/media/pci/cobalt/cobalt-v4l2.c             |    4 +-
 drivers/media/pci/cx18/cx18-alsa-mixer.c           |    6 +-
 drivers/media/pci/cx18/cx18-driver.c               |    2 +-
 drivers/media/pci/cx18/cx18-driver.h               |    6 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |    2 +-
 drivers/media/pci/cx18/cx18-streams.c              |   12 +-
 drivers/media/pci/cx18/cx18-vbi.c                  |    6 +-
 drivers/media/pci/cx23885/cx23885-417.c            |    3 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |   59 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   10 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |  104 +-
 drivers/media/pci/cx23885/cx23885-vbi.c            |    3 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    5 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +-
 drivers/media/pci/cx25821/cx25821-alsa.c           |    2 +-
 drivers/media/pci/cx25821/cx25821-core.c           |   10 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    5 +-
 drivers/media/pci/cx25821/cx25821.h                |    1 -
 drivers/media/pci/cx88/cx88-alsa.c                 |    8 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |    4 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    4 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |   10 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |    3 +-
 drivers/media/pci/cx88/cx88-video.c                |   13 +-
 drivers/media/pci/cx88/cx88.h                      |    2 -
 drivers/media/pci/ddbridge/ddbridge-core.c         |    3 +-
 drivers/media/pci/dt3155/dt3155.c                  |   15 +-
 drivers/media/pci/dt3155/dt3155.h                  |    2 -
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c           |    6 +-
 drivers/media/pci/netup_unidvb/Kconfig             |    7 +-
 drivers/media/pci/netup_unidvb/netup_unidvb.h      |   10 +
 drivers/media/pci/netup_unidvb/netup_unidvb_ci.c   |    4 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |  174 +-
 drivers/media/pci/saa7134/saa7134-core.c           |   22 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |    3 +-
 drivers/media/pci/saa7134/saa7134-vbi.c            |    3 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    5 +-
 drivers/media/pci/saa7134/saa7134.h                |    3 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        |    6 +-
 drivers/media/pci/saa7164/saa7164.h                |    4 -
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |   15 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   44 +-
 drivers/media/pci/solo6x10/solo6x10.h              |    2 -
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   20 +-
 drivers/media/pci/tw68/tw68-core.c                 |   15 +-
 drivers/media/pci/tw68/tw68-video.c                |    4 +-
 drivers/media/pci/tw68/tw68.h                      |    1 -
 drivers/media/pci/tw686x/Kconfig                   |    2 +
 drivers/media/pci/tw686x/tw686x-audio.c            |   92 +-
 drivers/media/pci/tw686x/tw686x-core.c             |   56 +-
 drivers/media/pci/tw686x/tw686x-regs.h             |    9 +
 drivers/media/pci/tw686x/tw686x-video.c            |  595 ++++--
 drivers/media/pci/tw686x/tw686x.h                  |   42 +-
 drivers/media/pci/zoran/zr36016.c                  |    4 -
 drivers/media/platform/Kconfig                     |   45 +
 drivers/media/platform/Makefile                    |    7 +
 drivers/media/platform/am437x/am437x-vpfe.c        |   14 +-
 drivers/media/platform/am437x/am437x-vpfe.h        |    2 -
 drivers/media/platform/blackfin/bfin_capture.c     |   17 +-
 drivers/media/platform/coda/coda-common.c          |   20 +-
 drivers/media/platform/coda/coda.h                 |    1 -
 drivers/media/platform/davinci/ccdc_hw_device.h    |    7 -
 drivers/media/platform/davinci/vpbe_display.c      |   14 +-
 drivers/media/platform/davinci/vpif_capture.c      |   15 +-
 drivers/media/platform/davinci/vpif_capture.h      |    2 -
 drivers/media/platform/davinci/vpif_display.c      |   15 +-
 drivers/media/platform/davinci/vpif_display.h      |    2 -
 drivers/media/platform/exynos-gsc/gsc-core.c       |   12 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    2 -
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    8 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    9 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |   12 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    3 -
 drivers/media/platform/exynos4-is/fimc-is.c        |   15 +-
 drivers/media/platform/exynos4-is/fimc-is.h        |    2 -
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   11 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    2 -
 drivers/media/platform/exynos4-is/fimc-lite.c      |   22 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    2 -
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   32 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   17 -
 drivers/media/platform/m2m-deinterlace.c           |   17 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   28 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |    2 -
 drivers/media/platform/mtk-vcodec/Makefile         |   19 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  335 ++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1292 +++++++++++++
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h |   58 +
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  439 +++++
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  137 ++
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h  |   26 +
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |   54 +
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |   27 +
 .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |   94 +
 .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   87 +
 .../media/platform/mtk-vcodec/venc/venc_h264_if.c  |  679 +++++++
 .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   |  486 +++++
 drivers/media/platform/mtk-vcodec/venc_drv_base.h  |   62 +
 drivers/media/platform/mtk-vcodec/venc_drv_if.c    |  113 ++
 drivers/media/platform/mtk-vcodec/venc_drv_if.h    |  163 ++
 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h   |  210 +++
 drivers/media/platform/mtk-vcodec/venc_vpu_if.c    |  238 +++
 drivers/media/platform/mtk-vcodec/venc_vpu_if.h    |   61 +
 drivers/media/platform/mtk-vpu/Makefile            |    3 +
 drivers/media/platform/mtk-vpu/mtk_vpu.c           |  946 ++++++++++
 drivers/media/platform/mtk-vpu/mtk_vpu.h           |  162 ++
 drivers/media/platform/mx2_emmaprp.c               |   19 +-
 drivers/media/platform/omap/omap_vout.c            |  109 +-
 drivers/media/platform/omap/omap_voutdef.h         |    5 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   14 +-
 drivers/media/platform/omap3isp/ispvideo.h         |    1 -
 drivers/media/platform/rcar-fcp.c                  |  181 ++
 drivers/media/platform/rcar-vin/Kconfig            |   11 +
 drivers/media/platform/rcar-vin/Makefile           |    3 +
 drivers/media/platform/rcar-vin/rcar-core.c        |  334 ++++
 drivers/media/platform/rcar-vin/rcar-dma.c         | 1187 ++++++++++++
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |  874 +++++++++
 drivers/media/platform/rcar-vin/rcar-vin.h         |  163 ++
 drivers/media/platform/rcar_jpu.c                  |   24 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    5 +-
 drivers/media/platform/s3c-camif/camif-core.c      |   11 +-
 drivers/media/platform/s3c-camif/camif-core.h      |    2 -
 drivers/media/platform/s5p-g2d/g2d.c               |   17 +-
 drivers/media/platform/s5p-g2d/g2d.h               |    1 -
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   21 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |    2 -
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  227 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   28 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   35 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h     |   79 +
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |   13 +-
 drivers/media/platform/s5p-tv/mixer.h              |    2 -
 drivers/media/platform/s5p-tv/mixer_video.c        |   19 +-
 drivers/media/platform/sh_veu.c                    |   19 +-
 drivers/media/platform/sh_vou.c                    |   16 +-
 drivers/media/platform/soc_camera/Kconfig          |    4 +-
 drivers/media/platform/soc_camera/Makefile         |    2 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |   15 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |   14 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   17 +-
 drivers/media/platform/sti/bdisp/bdisp-filter.h    |  304 ---
 drivers/media/platform/sti/bdisp/bdisp-hw.c        |  305 ++++
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   18 +-
 drivers/media/platform/sti/bdisp/bdisp.h           |    2 -
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |    1 +
 drivers/media/platform/ti-vpe/cal.c                |   17 +-
 drivers/media/platform/ti-vpe/vpe.c                |   22 +-
 drivers/media/platform/via-camera.c                |    2 +-
 drivers/media/platform/vim2m.c                     |    7 +-
 drivers/media/platform/vivid/Kconfig               |    8 +
 drivers/media/platform/vivid/Makefile              |    4 +
 drivers/media/platform/vivid/vivid-cec.c           |  241 +++
 drivers/media/platform/vivid/vivid-cec.h           |   33 +
 drivers/media/platform/vivid/vivid-core.c          |  118 +-
 drivers/media/platform/vivid/vivid-core.h          |   27 +
 drivers/media/platform/vivid/vivid-kthread-cap.c   |   13 +
 drivers/media/platform/vivid/vivid-sdr-cap.c       |    4 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c       |    2 +-
 drivers/media/platform/vivid/vivid-vbi-out.c       |    2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c       |   34 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |    7 +
 drivers/media/platform/vivid/vivid-vid-out.c       |    7 +-
 drivers/media/platform/vsp1/Makefile               |    3 +-
 drivers/media/platform/vsp1/vsp1.h                 |   11 +-
 drivers/media/platform/vsp1/vsp1_bru.c             |   12 +-
 drivers/media/platform/vsp1/vsp1_clu.c             |  292 +++
 drivers/media/platform/vsp1/vsp1_clu.h             |   48 +
 drivers/media/platform/vsp1/vsp1_dl.c              |   72 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |   74 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |  191 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |   92 +-
 drivers/media/platform/vsp1/vsp1_entity.h          |   17 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |   14 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |   16 +-
 drivers/media/platform/vsp1/vsp1_lut.c             |  101 +-
 drivers/media/platform/vsp1/vsp1_lut.h             |    7 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |   58 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |    8 +-
 drivers/media/platform/vsp1/vsp1_regs.h            |   24 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   38 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |    6 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   14 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |   14 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |   16 +-
 drivers/media/platform/vsp1/vsp1_uds.h             |    2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   40 +-
 drivers/media/platform/vsp1/vsp1_video.h           |    2 -
 drivers/media/platform/vsp1/vsp1_wpf.c             |  161 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   13 +-
 drivers/media/platform/xilinx/xilinx-dma.h         |    2 -
 drivers/media/radio/radio-aztech.c                 |    1 -
 drivers/media/radio/radio-maxiradio.c              |    1 +
 drivers/media/rc/ene_ir.c                          |    2 +-
 drivers/media/rc/iguanair.c                        |    2 +-
 drivers/media/rc/ir-lirc-codec.c                   |    5 +-
 drivers/media/rc/ir-rc5-decoder.c                  |    2 +-
 drivers/media/rc/keymaps/Makefile                  |    2 +
 drivers/media/rc/keymaps/rc-cec.c                  |  182 ++
 drivers/media/rc/keymaps/rc-dtt200u.c              |   59 +
 drivers/media/rc/lirc_dev.c                        |  299 ++-
 drivers/media/rc/mceusb.c                          |    8 +-
 drivers/media/rc/nuvoton-cir.c                     |  138 +-
 drivers/media/rc/nuvoton-cir.h                     |   25 -
 drivers/media/rc/rc-main.c                         |   11 +-
 drivers/media/rc/redrat3.c                         |   84 +-
 drivers/media/rc/winbond-cir.c                     |    4 +
 drivers/media/tuners/it913x.c                      |    1 +
 drivers/media/tuners/mt2063.c                      |   30 +-
 drivers/media/tuners/r820t.c                       |   29 +-
 drivers/media/tuners/si2157.c                      |    3 +-
 drivers/media/usb/airspy/airspy.c                  |    4 +-
 drivers/media/usb/au0828/au0828-core.c             |    4 +-
 drivers/media/usb/au0828/au0828-vbi.c              |    2 +-
 drivers/media/usb/au0828/au0828-video.c            |    2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |    4 +-
 drivers/media/usb/dvb-usb-v2/Kconfig               |   13 +-
 drivers/media/usb/dvb-usb-v2/af9035.c              |  275 +--
 drivers/media/usb/dvb-usb-v2/af9035.h              |    3 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    2 +-
 drivers/media/usb/dvb-usb/dtt200u.c                |   74 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c            |    2 -
 drivers/media/usb/dvb-usb/dw2102.c                 |   48 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   11 -
 drivers/media/usb/em28xx/em28xx-i2c.c              |    5 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    2 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |    2 +-
 drivers/media/usb/gspca/cpia1.c                    |    2 +-
 drivers/media/usb/gspca/gspca.c                    |   29 +-
 drivers/media/usb/gspca/konica.c                   |    2 +-
 drivers/media/usb/gspca/m5602/m5602_bridge.h       |   15 -
 drivers/media/usb/gspca/m5602/m5602_core.c         |   15 +
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c      |  144 ++
 drivers/media/usb/gspca/m5602/m5602_mt9m111.h      |  144 --
 drivers/media/usb/gspca/m5602/m5602_ov7660.c       |  153 ++
 drivers/media/usb/gspca/m5602/m5602_ov7660.h       |  153 --
 drivers/media/usb/gspca/m5602/m5602_ov9650.c       |  152 ++
 drivers/media/usb/gspca/m5602/m5602_ov9650.h       |  150 --
 drivers/media/usb/gspca/m5602/m5602_po1030.c       |  104 ++
 drivers/media/usb/gspca/m5602/m5602_po1030.h       |  104 --
 drivers/media/usb/gspca/m5602/m5602_s5k4aa.c       |  199 ++
 drivers/media/usb/gspca/m5602/m5602_s5k4aa.h       |  197 --
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c       |  124 ++
 drivers/media/usb/gspca/m5602/m5602_s5k83a.h       |  124 --
 drivers/media/usb/gspca/ov534.c                    |    7 +-
 drivers/media/usb/gspca/sn9c20x.c                  |   14 +-
 drivers/media/usb/gspca/t613.c                     |    2 +-
 drivers/media/usb/gspca/topro.c                    |    6 +-
 drivers/media/usb/gspca/zc3xx.c                    |   13 +-
 drivers/media/usb/hackrf/hackrf.c                  |    2 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |   10 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |    6 +-
 drivers/media/usb/hdpvr/hdpvr.h                    |    2 -
 drivers/media/usb/msi2500/msi2500.c                |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    6 +-
 drivers/media/usb/pwc/pwc-if.c                     |    4 +-
 drivers/media/usb/s2255/s2255drv.c                 |    2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    5 +-
 drivers/media/usb/usbtv/usbtv-audio.c              |   33 +-
 drivers/media/usb/usbtv/usbtv-core.c               |   40 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   61 +-
 drivers/media/usb/usbtv/usbtv.h                    |   22 +-
 drivers/media/usb/usbvision/usbvision-core.c       |    5 -
 drivers/media/usb/usbvision/usbvision-video.c      |   40 +-
 drivers/media/usb/uvc/uvc_driver.c                 |    2 +-
 drivers/media/usb/uvc/uvc_queue.c                  |    2 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   19 +-
 drivers/media/usb/uvc/uvc_video.c                  |    1 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |   45 -
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |    9 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    4 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   40 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c     |   88 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |   45 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   53 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |    9 +-
 drivers/of/of_reserved_mem.c                       |   83 +-
 drivers/staging/media/Kconfig                      |   14 +-
 drivers/staging/media/Makefile                     |    8 +-
 drivers/staging/media/cec/Kconfig                  |   15 +
 drivers/staging/media/cec/Makefile                 |    5 +
 drivers/staging/media/cec/TODO                     |   31 +
 drivers/staging/media/cec/cec-adap.c               | 1654 +++++++++++++++++
 drivers/staging/media/cec/cec-api.c                |  579 ++++++
 drivers/staging/media/cec/cec-core.c               |  409 +++++
 drivers/staging/media/cec/cec-priv.h               |   56 +
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   14 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 -
 drivers/staging/media/lirc/lirc_parallel.c         |    8 +-
 drivers/staging/media/mn88472/Kconfig              |    7 -
 drivers/staging/media/mn88472/Makefile             |    5 -
 drivers/staging/media/mn88472/TODO                 |   21 -
 drivers/staging/media/mx2/Kconfig                  |   15 -
 drivers/staging/media/mx2/Makefile                 |    3 -
 drivers/staging/media/mx2/TODO                     |   10 -
 drivers/staging/media/mx2/mx2_camera.c             | 1636 -----------------
 drivers/staging/media/mx3/Kconfig                  |   15 -
 drivers/staging/media/mx3/Makefile                 |    3 -
 drivers/staging/media/mx3/TODO                     |   10 -
 drivers/staging/media/mx3/mx3_camera.c             | 1264 -------------
 drivers/staging/media/omap1/Kconfig                |   13 -
 drivers/staging/media/omap1/Makefile               |    3 -
 drivers/staging/media/omap1/TODO                   |    8 -
 drivers/staging/media/omap1/omap1_camera.c         | 1702 -----------------
 drivers/staging/media/omap4iss/iss_video.c         |   12 +-
 drivers/staging/media/omap4iss/iss_video.h         |    1 -
 drivers/staging/media/pulse8-cec/Kconfig           |   10 +
 drivers/staging/media/pulse8-cec/Makefile          |    1 +
 drivers/staging/media/pulse8-cec/TODO              |   52 +
 drivers/staging/media/pulse8-cec/pulse8-cec.c      |  505 +++++
 drivers/staging/media/s5p-cec/Kconfig              |    9 +
 drivers/staging/media/s5p-cec/Makefile             |    2 +
 drivers/staging/media/s5p-cec/TODO                 |    7 +
 drivers/staging/media/s5p-cec/exynos_hdmi_cec.h    |   38 +
 .../staging/media/s5p-cec/exynos_hdmi_cecctrl.c    |  209 +++
 drivers/staging/media/s5p-cec/regs-cec.h           |   96 +
 drivers/staging/media/s5p-cec/s5p_cec.c            |  294 +++
 drivers/staging/media/s5p-cec/s5p_cec.h            |   76 +
 drivers/staging/media/timb/Kconfig                 |   11 -
 drivers/staging/media/timb/Makefile                |    1 -
 drivers/staging/media/timb/timblogiw.c             |  870 ---------
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c  |   12 +-
 drivers/staging/media/tw686x-kh/tw686x-kh.h        |    1 -
 drivers/usb/gadget/function/uvc_queue.c            |    2 +-
 fs/compat_ioctl.c                                  |   12 +
 include/linux/cec-funcs.h                          | 1899 +++++++++++++++++++
 include/linux/cec.h                                | 1011 ++++++++++
 include/linux/of_reserved_mem.h                    |   25 +-
 include/media/cec-edid.h                           |  104 ++
 include/media/cec.h                                |  241 +++
 include/media/davinci/vpbe_display.h               |    2 -
 include/media/i2c/adv7511.h                        |    6 +-
 include/media/i2c/adv7604.h                        |    2 -
 include/media/i2c/adv7842.h                        |    2 -
 include/media/media-device.h                       |    5 +-
 include/media/media-devnode.h                      |   46 +-
 include/media/rc-core.h                            |    3 +
 include/media/rc-map.h                             |    6 +-
 include/media/rcar-fcp.h                           |   37 +
 include/media/v4l2-ctrls.h                         |   34 +-
 include/media/v4l2-subdev.h                        |   21 -
 include/media/videobuf2-core.h                     |   24 +-
 include/media/videobuf2-dma-contig.h               |   11 +-
 include/media/videobuf2-dma-sg.h                   |    3 -
 include/media/vsp1.h                               |   29 +-
 include/uapi/linux/media.h                         |   10 +
 include/uapi/linux/serio.h                         |    1 +
 include/uapi/linux/videodev2.h                     |   14 +-
 include/uapi/linux/vsp1.h                          |   34 -
 samples/v4l/v4l2-pci-skeleton.c                    |   17 +-
 446 files changed, 28811 insertions(+), 11188 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/cec-api.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-close.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-ioctl.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-open.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-func-poll.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-log-addrs.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-adap-g-phys-addr.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-dqevent.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
 create mode 100644 Documentation/DocBook/media/v4l/cec-ioc-receive.xml
 create mode 100644 Documentation/cec.txt
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-vcodec.txt
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-vpu.txt
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fcp.txt
 create mode 100644 Documentation/devicetree/bindings/media/s5p-cec.txt
 create mode 100644 drivers/media/cec-edid.c
 create mode 100644 drivers/media/dvb-frontends/helene.c
 create mode 100644 drivers/media/dvb-frontends/helene.h
 rename drivers/{staging/media/mn88472 => media/dvb-frontends}/mn88472.c (58%)
 rename drivers/{staging/media/mn88472 => media/dvb-frontends}/mn88472_priv.h (88%)
 create mode 100644 drivers/media/platform/mtk-vcodec/Makefile
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
 create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_base.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_vpu_if.c
 create mode 100644 drivers/media/platform/mtk-vcodec/venc_vpu_if.h
 create mode 100644 drivers/media/platform/mtk-vpu/Makefile
 create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.c
 create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.h
 create mode 100644 drivers/media/platform/rcar-fcp.c
 create mode 100644 drivers/media/platform/rcar-vin/Kconfig
 create mode 100644 drivers/media/platform/rcar-vin/Makefile
 create mode 100644 drivers/media/platform/rcar-vin/rcar-core.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-dma.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-v4l2.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-vin.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_iommu.h
 create mode 100644 drivers/media/platform/vivid/vivid-cec.c
 create mode 100644 drivers/media/platform/vivid/vivid-cec.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.h
 create mode 100644 drivers/media/rc/keymaps/rc-cec.c
 create mode 100644 drivers/media/rc/keymaps/rc-dtt200u.c
 create mode 100644 drivers/staging/media/cec/Kconfig
 create mode 100644 drivers/staging/media/cec/Makefile
 create mode 100644 drivers/staging/media/cec/TODO
 create mode 100644 drivers/staging/media/cec/cec-adap.c
 create mode 100644 drivers/staging/media/cec/cec-api.c
 create mode 100644 drivers/staging/media/cec/cec-core.c
 create mode 100644 drivers/staging/media/cec/cec-priv.h
 delete mode 100644 drivers/staging/media/mn88472/Kconfig
 delete mode 100644 drivers/staging/media/mn88472/Makefile
 delete mode 100644 drivers/staging/media/mn88472/TODO
 delete mode 100644 drivers/staging/media/mx2/Kconfig
 delete mode 100644 drivers/staging/media/mx2/Makefile
 delete mode 100644 drivers/staging/media/mx2/TODO
 delete mode 100644 drivers/staging/media/mx2/mx2_camera.c
 delete mode 100644 drivers/staging/media/mx3/Kconfig
 delete mode 100644 drivers/staging/media/mx3/Makefile
 delete mode 100644 drivers/staging/media/mx3/TODO
 delete mode 100644 drivers/staging/media/mx3/mx3_camera.c
 delete mode 100644 drivers/staging/media/omap1/Kconfig
 delete mode 100644 drivers/staging/media/omap1/Makefile
 delete mode 100644 drivers/staging/media/omap1/TODO
 delete mode 100644 drivers/staging/media/omap1/omap1_camera.c
 create mode 100644 drivers/staging/media/pulse8-cec/Kconfig
 create mode 100644 drivers/staging/media/pulse8-cec/Makefile
 create mode 100644 drivers/staging/media/pulse8-cec/TODO
 create mode 100644 drivers/staging/media/pulse8-cec/pulse8-cec.c
 create mode 100644 drivers/staging/media/s5p-cec/Kconfig
 create mode 100644 drivers/staging/media/s5p-cec/Makefile
 create mode 100644 drivers/staging/media/s5p-cec/TODO
 create mode 100644 drivers/staging/media/s5p-cec/exynos_hdmi_cec.h
 create mode 100644 drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c
 create mode 100644 drivers/staging/media/s5p-cec/regs-cec.h
 create mode 100644 drivers/staging/media/s5p-cec/s5p_cec.c
 create mode 100644 drivers/staging/media/s5p-cec/s5p_cec.h
 delete mode 100644 drivers/staging/media/timb/Kconfig
 delete mode 100644 drivers/staging/media/timb/Makefile
 delete mode 100644 drivers/staging/media/timb/timblogiw.c
 create mode 100644 include/linux/cec-funcs.h
 create mode 100644 include/linux/cec.h
 create mode 100644 include/media/cec-edid.h
 create mode 100644 include/media/cec.h
 create mode 100644 include/media/rcar-fcp.h
 delete mode 100644 include/uapi/linux/vsp1.h

