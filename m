Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab2GaXAS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 19:00:18 -0400
Message-ID: <50186377.9040307@redhat.com>
Date: Tue, 31 Jul 2012 20:00:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 3.6-rc1] media updates part 2
References: <5017F674.80404@redhat.com>
In-Reply-To: <5017F674.80404@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Em 31-07-2012 12:15, Mauro Carvalho Chehab escreveu:
> Hi Linus,
> 
> Please pull from:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> 
> For the second part of media patches:
> 	- radio API: add support to work with radio frequency bands;
> 	- new AM/FM radio drivers: radio-shark, radio-shark2;
> 	- new Remote Controller USB driver: iguanair;
> 	- conversion of several drivers to the v4l2 core control framework;
> 	- new board additions at existing drivers;
> 	- the remaining (and vast majority of the patches) are due to
> 	  drivers/DocBook fixes/cleanups.
> 

Linus,

Randy pointed me a compilation breakage due to a 64 bit division, so I added one
extra patch there:

      [media] radio-tea5777: use library for 64bits div

So, please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For the above plus the fix.

Thank you!
Mauro

- -

The following changes since commit 2cefabc00ffdc1f22f960df946ae41b163081d5e:

  v4l: Export v4l2-common.h in include/linux/Kbuild (2012-07-12 03:27:39 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to adfe1560de1c696324554fba70c92f2d7c947ff7:

  [media] radio-tea5777: use library for 64bits div (2012-07-31 18:24:44 -0300)

- ----------------------------------------------------------------
Alan Cox (3):
      [media] ov9640: fix missing break
      [media] cx25821,medusa: incorrect check on decoder type
      [media] az6007: fix incorrect memcpy

Anton Blanchard (3):
      [media] cx23885: Silence unknown command warnings
      [media] winbond-cir: Fix txandrx module info
      [media] winbond-cir: Initialise timeout, driver_type and allowed_protos

Antonio Ospite (2):
      [media] gspca_kinect: remove traces of the gspca control mechanism
      [media] gspca_ov534: Convert to the control framework

Dan Carpenter (4):
      [media] tvp5150: signedness bug in tvp5150_selmux()
      [media] tuner-xc2028: fix "=" vs "==" typo
      [media] tuner-xc2028: unlock on error in xc2028_get_afc()
      [media] dib8000: move dereference after check for NULL

Daniel Drake (1):
      [media] via-camera: pass correct format settings to sensor

David Dillow (1):
      [media] cx231xx: don't DMA to random addresses

Devendra Naga (2):
      [media] staging/media/dt3155v4l: use module_pci_driver macro
      [media] staging/media/solo6x10: use module_pci_driver macro

Devin Heitmueller (6):
      [media] cx25840: fix regression in HVR-1800 analog support
      [media] cx25840: fix regression in analog support hue/saturation controls
      [media] cx25840: fix regression in HVR-1800 analog audio
      [media] cx25840: fix vsrc/hsrc usage on cx23888 designs
      [media] cx23885: make analog support work for HVR_1250 (cx23885 variant)
      [media] cx23885: add support for HVR-1255 analog (cx23888 variant)

Douglas Bagnall (1):
      [media] Avoid sysfs oops when an rc_dev's raw device is absent

Dror Cohen (1):
      [media] media/video: vpif: fixed vpfe->vpif typo

Du, Changbin (1):
      [media] rc: ati_remote.c: code style fixing

Duan Jiong (2):
      [media] smiapp-core.c: remove duplicated include
      [media] pms.c: remove duplicated include

Emil Goode (1):
      [media] lirc: fix non-ANSI function declaration warning

Ezequiel García (11):
      [media] saa7164: Remove useless struct i2c_algo_bit_data
      [media] cx23885: Remove useless struct i2c_algo_bit_data
      [media] cx231xx: Remove useless struct i2c_algo_bit_data
      [media] cx25821: Remove useless struct i2c_algo_bit_data
      [media] saa7164: Remove unused saa7164_call_i2c_clients()
      [media] saa7164: Replace struct memcpy with struct assignment
      [media] cx23885: Replace struct memcpy with struct assignment
      [media] cx231xx: Replace struct memcpy with struct assignment
      [media] cx25821: Replace struct memcpy with struct assignment
      [media] v4l2-dev.c: Move video_put() after debug printk
      [media] cx25821: Remove bad strcpy to read-only char*

Federico Vaga (1):
      [media] adv7180.c: convert to v4l2 control framework

Fengguang Wu (1):
      [media] pms: fix build error in pms_probe()

Hans Verkuil (49):
      [media] Fix VIDIOC_TRY_EXT_CTRLS regression
      [media] gspca-conex: convert to the control framework
      [media] gspca-cpia1: convert to the control framework
      [media] gspca-etoms: convert to the control framework
      [media] gspca-jeilinj: convert to the control framework
      [media] gspca-konica: convert to the control framework
      [media] gspca-mr97310a: convert to the control framework
      [media] nw80x: convert to the control framework
      [media] ov519: convert to the control framework
      [media] ov534_9: convert to the control framework
      [media] es401: convert to the control framework
      [media] spca1528: convert to the control framework
      [media] spca500: convert to the control framework
      [media] spca501: convert to the control framework
      [media] gspca-spca501: remove old function prototypes
      [media] spca505: convert to the control framework
      [media] spca506: convert to the control framework
      [media] spca508: convert to the control framework
      [media] spca561: convert to the control framework
      [media] sq930x: convert to the control framework
      [media] stk014: convert to the control framework
      [media] sunplus: convert to the control framework
      [media] gspca_t613: convert to the control framework
      [media] tv8532: convert to the control framework
      [media] vicam: convert to the control framework
      [media] xirlink_cit: convert to the control framework
      [media] vc032x: convert to the control framework
      [media] gspca-topro: convert to the control framework
      [media] gspca: clear priv field and disable relevant ioctls
      [media] gspca: always call v4l2_ctrl_handler_setup after start
      [media] v4l2-ioctl: Don't assume file->private_data always points to a v4l2_fh
      [media] v4l2-dev: forgot to add VIDIOC_DV_TIMINGS_CAP
      [media] v4l2-ioctl.c: zero the v4l2_dv_timings_cap struct
      [media] mem2mem_testdev: convert to the control framework and v4l2_fh
      [media] mem2mem_testdev: set bus_info and device_caps
      [media] v4l2-mem2mem: support events in v4l2_m2m_poll
      [media] mem2mem_testdev: add control events support
      [media] mem2mem_testdev: set default size and fix colorspace
      [media] v4l2-dev: G_PARM was incorrectly enabled for all video nodes
      [media] Fix DV_TIMINGS_CAP documentation
      [media] videodev2.h: add VIDIOC_ENUM_FREQ_BANDS
      [media] v4l2: add core support for the new VIDIOC_ENUM_FREQ_BANDS ioctl
      [media] v4l2 spec: add VIDIOC_ENUM_FREQ_BANDS documentation
      [media] radio-cadet: upgrade to latest frameworks
      [media] radio-cadet: fix RDS handling
      [media] radio-cadet: implement frequency band enumeration
      [media] vivi: remove pointless video_nr++
      [media] vivi: fix a few format-related compliance issues
      [media] Use a named union in struct v4l2_ioctl_info

Hans de Goede (28):
      [media] snd_tea575x: Add write_/read_val operations
      [media] snd_tea575x: Add a cannot_mute flag
      [media] radio-shark: New driver for the Griffin radioSHARK USB radio receiver
      [media] radio-si470x: Don't unnecesarily read registers on G_TUNER
      [media] radio-si470x: Always use interrupt to wait for tune/seek completion
      [media] radio-si470x: Lower hardware freq seek signal treshold
      [media] radio-si470x: Lower firmware version requirements
      [media] gspca_pac7302: Convert to the control framework
      [media] gscpa_sonixb: Use usb_err for error handling
      [media] gscpa_sonixb: Convert to the control framework
      [media] gspca_sonixb: Fix OV7630 gain control
      [media] gspca: Remove bogus JPEG quality controls from various sub-drivers
      [media] gspca_benq: Remove empty ctrls array
      [media] gspca: Add reset_resume callback to all sub-drivers
      [media] gspca_konica: Fix init sequence
      [media] gspca_sn9c2028: Remove empty ctrls array
      [media] gscpa_spca561: Add brightness control for rev12a cams
      [media] gspca_stv0680: Remove empty ctrls array
      [media] gspca_t613: Disable CIF resolutions
      [media] gspca_xirlink_cit: Grab backlight compensation control while streaming
      [media] gspca: Don't use video_device_node_name in v4l2_device release handler
      [media] v4l2-ctrls: Teach v4l2-ctrls that V4L2_CID_AUTOBRIGHTNESS is a boolean
      [media] shark2: New driver for the Griffin radioSHARK v2 USB radio receiver
      [media] radio-si470x: Lower firmware version requirements
      [media] v4l2: Add rangelow and rangehigh fields to the v4l2_hw_freq_seek struct
      [media] radio-si470x: restore ctrl settings after suspend/resume
      [media] radio-si470x: Fix band selection
      [media] radio-si470x: Add support for the new band APIs

Hans-Frieder Vogt (1):
      [media] rtl2832.c: minor cleanup

Jesper Juhl (1):
      [media] Documentation: Add newline at end-of-file to files lacking one

Julia Lawall (2):
      [media] drivers/staging/media/easycap/easycap_main.c: add missing usb_free_urb
      [media] drivers/media/dvb/siano/smscoreapi.c: use list_for_each_entry

Kamil Debski (1):
      [media] s5p-mfc: Fixed setup of custom controls in decoder and encoder

Lad, Prabhakar (3):
      [media] videobuf-dma-contig: restore buffer mapping for uncached bufers
      [media] davinci: vpif capture: migrate driver to videobuf2
      [media] davinci: vpif display: migrate driver to videobuf2

Laurent Pinchart (7):
      [media] omap3isp: preview: Fix output size computation depending on input format
      [media] omap3isp: preview: Fix contrast and brightness handling
      [media] soc-camera: Don't fail at module init time if no device is present
      [media] soc-camera: Pass the physical device to the power operation
      [media] ov2640: Don't access the device in the g_mbus_fmt operation
      [media] ov772x: Don't access the device in the g_mbus_fmt operation
      [media] tw9910: Don't access the device in the g_mbus_fmt operation

Manjunath Hadli (12):
      [media] davinci: vpif: add check for genuine interrupts in the isr
      [media] davinci: vpif: make generic changes to re-use the vpif drivers on da850/omap-l138 soc
      [media] davinci: vpif: make request_irq flags as shared
      [media] davinci: vpif: fix setting of data width in config_vpif_params() function
      [media] davinci: vpif display: size up the memory for the buffers from the buffer pool
      [media] davinci: vpif capture: size up the memory for the buffers from the buffer pool
      [media] davinci: vpif: add support for clipping on output data
      [media] davinci: vpif display: Add power management support
      [media] davinci: vpif capture:Add power management support
      [media] davinci: vpif: Add suspend/resume callbacks to vpif driver
      [media] davinci: vpif: add build configuration for vpif drivers
      [media] davinci: vpif: Enable selection of the ADV7343 and THS7303

Mark Lord (1):
      [media] mceusb: Add Twisted Melon USB IDs

Mauro Carvalho Chehab (5):
      [media] smiapp-core: fix compilation build error
      [media] em28xx: fix em28xx-rc load
      Merge branch 'v4l_for_linus' into staging/for_v3.6
      [media] Documentation: Update cardlists
      [media] radio-tea5777: use library for 64bits div

Nicolas THERY (3):
      [media] v4l: DocBook: fix version number typo
      [media] v4l: DocBook: VIDIOC_CREATE_BUFS: add hyperlink
      [media] v4l: fix copy/paste typo in vb2_reqbufs comment

Prabhakar Lad (2):
      [media] davinci: vpbe: fix check for s_dv_preset function pointer
      [media] davinci: vpbe: fix build error when CONFIG_VIDEO_ADV_DEBUG is enabled

Randy Dunlap (1):
      [media] media: pms.c needs linux/slab.h

Sachin Kamat (5):
      [media] s5p-fimc: Fix compiler warning in fimc-lite.c
      [media] s5p-fimc: Stop media entity pipeline if fimc_pipeline_validate fails
      [media] s5p-fimc: Replace custom err() macro with v4l2_err() macro
      [media] V4L: Use NULL pointer instead of plain integer in v4l2-ctrls.c file
      [media] videobuf-dma-contig: Use NULL instead of plain integer

Sakari Ailus (1):
      [media] s5p-fimc: media_entity_pipeline_start() may fail

Santosh Nayak (1):
      [media] dvb-core: Release semaphore on error path dvb_register_device()

Sean Young (2):
      [media] Minor cleanups for MCE USB
      [media] Add support for the IguanaWorks USB IR Transceiver

Sylwester Nawrocki (15):
      [media] s5p-fimc: Fix bug in capture node open()
      [media] s5p-fimc: Don't create multiple active links to same sink entity
      [media] s5p-fimc: Honour sizeimage in VIDIOC_S_FMT
      [media] s5p-fimc: Remove superfluous checks for buffer type
      [media] s5p-fimc: Prevent lock-up in multiple sensor systems
      [media] s5p-fimc: Fix fimc-lite system wide suspend procedure
      [media] s5p-fimc: Shorten pixel formats description
      [media] s5p-fimc: Update to the control handler lock changes
      [media] s5p-fimc: Add missing FIMC-LITE file operations locking
      [media] Revert "[media] V4L: JPEG class documentation corrections"
      [media] s5p-fimc: Remove V4L2_FL_LOCK_ALL_FOPS flag
      [media] s5p-fimc: Use switch statement for better readability
      [media] m5mols: Correct reported ISO values
      [media] V4L: Add capability flags for memory-to-memory devices
      [media] Feature removal: using capture and output capabilities for m2m devices

Tim Gardner (4):
      [media] s2255drv: Add MODULE_FIRMWARE statement
      [media] xc5000: Add MODULE_FIRMWARE statements
      [media] lgs8gxx: Declare MODULE_FIRMWARE usage
      [media] tlg2300: Declare MODULE_FIRMWARE usage

Tony Gentile (1):
      [media] bttv: add support for Aposonic W-DVR

 Documentation/ABI/stable/vdso                      |   2 +-
 Documentation/ABI/testing/sysfs-block-zram         |   2 +-
 .../ABI/testing/sysfs-bus-usb-devices-usbsevseg    |   2 +-
 .../testing/sysfs-class-backlight-driver-adp8870   |   2 +-
 Documentation/DocBook/media/v4l/compat.xml         |  23 +-
 Documentation/DocBook/media/v4l/controls.xml       |   7 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |   6 +
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |   4 +-
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |  14 +-
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml   | 179 +++++
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   7 -
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |   7 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |  26 +-
 .../DocBook/media/v4l/vidioc-querycap.xml          |  13 +
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |  50 +-
 Documentation/arm/Samsung-S3C24XX/H1940.txt        |   2 +-
 Documentation/arm/Samsung-S3C24XX/SMDK2440.txt     |   2 +-
 Documentation/feature-removal-schedule.txt         |  14 +
 Documentation/sound/alsa/hdspm.txt                 |   2 +-
 Documentation/video4linux/CARDLIST.au0828          |   2 +-
 Documentation/video4linux/CARDLIST.bttv            |   1 +
 Documentation/video4linux/CARDLIST.cx23885         |   4 +-
 Documentation/video4linux/CARDLIST.saa7134         |   1 +
 Documentation/video4linux/cpia2_overview.txt       |   2 +-
 Documentation/video4linux/stv680.txt               |   2 +-
 drivers/hid/hid-core.c                             |   1 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/media/common/tuners/tuner-xc2028.c         |   4 +-
 drivers/media/common/tuners/xc5000.c               |   8 +-
 drivers/media/dvb/dvb-core/dvbdev.c                |   1 +
 drivers/media/dvb/dvb-usb/az6007.c                 |   2 +-
 drivers/media/dvb/frontends/dib8000.c              |   4 +-
 drivers/media/dvb/frontends/lgs8gxx.c              |   5 +-
 drivers/media/dvb/frontends/rtl2832.c              |   2 +-
 drivers/media/dvb/siano/smscoreapi.c               |  39 +-
 drivers/media/radio/Kconfig                        |  33 +
 drivers/media/radio/Makefile                       |   4 +
 drivers/media/radio/radio-cadet.c                  | 388 +++++-----
 drivers/media/radio/radio-shark.c                  | 376 ++++++++++
 drivers/media/radio/radio-shark2.c                 | 348 +++++++++
 drivers/media/radio/radio-tea5777.c                | 491 ++++++++++++
 drivers/media/radio/radio-tea5777.h                |  87 +++
 drivers/media/radio/si470x/radio-si470x-common.c   | 283 +++----
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   6 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |  47 +-
 drivers/media/radio/si470x/radio-si470x.h          |   7 +-
 drivers/media/rc/Kconfig                           |  11 +
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/ati_remote.c                      | 133 ++--
 drivers/media/rc/iguanair.c                        | 639 ++++++++++++++++
 drivers/media/rc/mceusb.c                          |  20 +-
 drivers/media/rc/rc-main.c                         |   5 +-
 drivers/media/rc/winbond-cir.c                     |   4 +-
 drivers/media/video/adv7180.c                      | 235 +++---
 drivers/media/video/bt8xx/bttv-cards.c             |  10 +-
 drivers/media/video/bt8xx/bttv.h                   |   2 +-
 drivers/media/video/cx231xx/cx231xx-i2c.c          |   8 +-
 drivers/media/video/cx231xx/cx231xx.h              |   2 -
 drivers/media/video/cx23885/cx23885-cards.c        |  89 ++-
 drivers/media/video/cx23885/cx23885-dvb.c          |   6 +
 drivers/media/video/cx23885/cx23885-i2c.c          |  10 +-
 drivers/media/video/cx23885/cx23885-video.c        |   9 +-
 drivers/media/video/cx23885/cx23885.h              |   3 +-
 drivers/media/video/cx25821/cx25821-core.c         |   3 -
 drivers/media/video/cx25821/cx25821-i2c.c          |  10 +-
 drivers/media/video/cx25821/cx25821-medusa-video.c |   2 +-
 drivers/media/video/cx25821/cx25821.h              |   4 +-
 drivers/media/video/cx25840/cx25840-core.c         |  76 +-
 drivers/media/video/davinci/Kconfig                |  30 +-
 drivers/media/video/davinci/Makefile               |   8 +-
 drivers/media/video/davinci/vpbe_display.c         |   4 +-
 drivers/media/video/davinci/vpif.c                 |  45 +-
 drivers/media/video/davinci/vpif.h                 |  45 ++
 drivers/media/video/davinci/vpif_capture.c         | 694 ++++++++---------
 drivers/media/video/davinci/vpif_capture.h         |  16 +-
 drivers/media/video/davinci/vpif_display.c         | 684 +++++++++--------
 drivers/media/video/davinci/vpif_display.h         |  23 +-
 drivers/media/video/em28xx/em28xx-cards.c          |   2 +-
 drivers/media/video/gspca/benq.c                   |   7 +-
 drivers/media/video/gspca/conex.c                  | 208 ++----
 drivers/media/video/gspca/cpia1.c                  | 486 ++++--------
 drivers/media/video/gspca/etoms.c                  | 221 ++----
 drivers/media/video/gspca/finepix.c                |   1 +
 drivers/media/video/gspca/gl860/gl860.c            |   1 +
 drivers/media/video/gspca/gspca.c                  |  50 +-
 drivers/media/video/gspca/jeilinj.c                | 219 +++---
 drivers/media/video/gspca/jl2005bcd.c              |   3 +-
 drivers/media/video/gspca/kinect.c                 |  10 +-
 drivers/media/video/gspca/konica.c                 | 289 ++------
 drivers/media/video/gspca/m5602/m5602_core.c       |   1 +
 drivers/media/video/gspca/mars.c                   |  48 +-
 drivers/media/video/gspca/mr97310a.c               | 439 ++++-------
 drivers/media/video/gspca/nw80x.c                  | 203 +++--
 drivers/media/video/gspca/ov519.c                  | 600 +++++++--------
 drivers/media/video/gspca/ov534.c                  | 570 +++++++-------
 drivers/media/video/gspca/ov534_9.c                | 294 +++-----
 drivers/media/video/gspca/pac207.c                 |   1 +
 drivers/media/video/gspca/pac7302.c                | 372 ++++------
 drivers/media/video/gspca/pac7311.c                |   1 +
 drivers/media/video/gspca/se401.c                  | 184 ++---
 drivers/media/video/gspca/sn9c2028.c               |   7 +-
 drivers/media/video/gspca/sonixb.c                 | 622 ++++++++--------
 drivers/media/video/gspca/sonixj.c                 |   1 +
 drivers/media/video/gspca/spca1528.c               | 271 ++-----
 drivers/media/video/gspca/spca500.c                | 201 ++---
 drivers/media/video/gspca/spca501.c                | 257 ++-----
 drivers/media/video/gspca/spca505.c                |  77 +-
 drivers/media/video/gspca/spca506.c                | 209 ++----
 drivers/media/video/gspca/spca508.c                |  71 +-
 drivers/media/video/gspca/spca561.c                | 393 +++-------
 drivers/media/video/gspca/sq905.c                  |   1 +
 drivers/media/video/gspca/sq905c.c                 |   1 +
 drivers/media/video/gspca/sq930x.c                 | 110 +--
 drivers/media/video/gspca/stk014.c                 | 188 ++---
 drivers/media/video/gspca/stv0680.c                |   7 +-
 drivers/media/video/gspca/sunplus.c                | 237 ++----
 drivers/media/video/gspca/t613.c                   | 824 ++++++---------------
 drivers/media/video/gspca/topro.c                  | 459 ++++++------
 drivers/media/video/gspca/tv8532.c                 | 125 +---
 drivers/media/video/gspca/vc032x.c                 | 694 ++++-------------
 drivers/media/video/gspca/vicam.c                  |  68 +-
 drivers/media/video/gspca/w996Xcf.c                |  15 +-
 drivers/media/video/gspca/xirlink_cit.c            | 473 ++++--------
 drivers/media/video/m5mols/m5mols_controls.c       |   4 +-
 drivers/media/video/mem2mem_testdev.c              | 263 +++----
 drivers/media/video/mx2_emmaprp.c                  |  10 +-
 drivers/media/video/omap3isp/isppreview.c          |   6 +-
 drivers/media/video/ov2640.c                       |   6 +-
 drivers/media/video/ov772x.c                       |   8 +-
 drivers/media/video/ov9640.c                       |   1 +
 drivers/media/video/pms.c                          |   1 +
 drivers/media/video/s2255drv.c                     |   1 +
 drivers/media/video/s5p-fimc/fimc-capture.c        |  99 ++-
 drivers/media/video/s5p-fimc/fimc-core.c           |  19 +-
 drivers/media/video/s5p-fimc/fimc-core.h           |   3 -
 drivers/media/video/s5p-fimc/fimc-lite.c           |  73 +-
 drivers/media/video/s5p-fimc/fimc-m2m.c            |  52 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |  48 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.h        |   2 -
 drivers/media/video/s5p-fimc/fimc-reg.c            |  20 +-
 drivers/media/video/s5p-g2d/g2d.c                  |   9 +-
 drivers/media/video/s5p-jpeg/jpeg-core.c           |  10 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |  11 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |  12 +-
 drivers/media/video/saa7164/saa7164-i2c.c          |  20 +-
 drivers/media/video/saa7164/saa7164.h              |   2 -
 drivers/media/video/smiapp/smiapp-core.c           |   2 +-
 drivers/media/video/soc_camera.c                   |   9 +-
 drivers/media/video/tlg2300/pd-main.c              |   4 +-
 drivers/media/video/tvp5150.c                      |   2 +-
 drivers/media/video/tw9910.c                       |   8 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |   1 +
 drivers/media/video/v4l2-ctrls.c                   |   3 +-
 drivers/media/video/v4l2-dev.c                     |  18 +-
 drivers/media/video/v4l2-ioctl.c                   | 118 ++-
 drivers/media/video/v4l2-mem2mem.c                 |  18 +-
 drivers/media/video/via-camera.c                   |   2 +-
 drivers/media/video/videobuf-dma-contig.c          |  55 +-
 drivers/media/video/videobuf2-core.c               |   4 +-
 drivers/media/video/vivi.c                         |  26 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |  15 +-
 drivers/staging/media/easycap/easycap_main.c       |   1 +
 drivers/staging/media/lirc/lirc_bt829.c            |   2 +-
 drivers/staging/media/solo6x10/core.c              |  13 +-
 include/linux/videodev2.h                          |  47 +-
 include/media/davinci/vpif_types.h                 |   2 +
 include/media/v4l2-ioctl.h                         |   2 +
 include/sound/tea575x-tuner.h                      |   5 +
 sound/i2c/other/tea575x-tuner.c                    |  41 +-
 169 files changed, 7731 insertions(+), 8212 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
 create mode 100644 drivers/media/radio/radio-shark.c
 create mode 100644 drivers/media/radio/radio-shark2.c
 create mode 100644 drivers/media/radio/radio-tea5777.c
 create mode 100644 drivers/media/radio/radio-tea5777.h
 create mode 100644 drivers/media/rc/iguanair.c

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQGGN3AAoJEGO08Bl/PELnzcIP/2ohDoYQG4wXQieskbM1/AIq
nQgGm22eOe2U6mI0ih6Qe4OjLJn4gx06fdT24aeTwzk2Go6KGDhBcgEeXicdWXwi
y777m5t+k1r+bMYTB7g/h/U5ovsSXzJTkbzEMKchxGMWBBtEPLTdULk5bO3Sh4L6
SQiCvtzyUp9FeEgAXD1xcwiqCMa99TDmD5N4npyRaA6lmrzG1iESqFKAej884Gj7
UPsi5NdUAkk/9MpyhhNzTe10//rym1OHGlxzGJ8RgbufrNlgIlo2egUYRl8/5WtR
SWr8o9fw0paC+DsIpFy+5NoMH0DjBGgh0TO+3vtZUPdbxQRg/jyuGth4vkldP3zx
nNIyC87hYh03NRWcTEOsMfDpqFckSwiy6iH5wGh6uBeOaX4VJIUQo4VYuH+Z+wt+
bcOU5ALQwAQdBTiauixCbWGxVxtsVwxTS1ML6GqVpn6yiqX9HU9VLSYu37Kh0lAO
Tnk3zDNhGWAqcKJ4nY/wjSdpwo8aaobEZbvi5+WN7S4VB17SnsGIn5qm5uN2BZ2J
Mfl7EHcx91AgaoKFUjT1gBPzXZfybJ0jgd6QxRM9puuFPpr7RAtUO7pkQ4OiVXeQ
M6rVIpWjkinClR2NHx67rMOLzrajNHPLQ10NgHgSkMDZQkJ/ybLqiffi40dlDkVr
fJCrYkLrVWdkWq31cEKC
=3W0M
-----END PGP SIGNATURE-----
