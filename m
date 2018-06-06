Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752119AbeFFUHC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 16:07:02 -0400
Date: Wed, 6 Jun 2018 17:06:56 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.18-rc1] media updates
Message-ID: <20180606170656.62081366@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/me=
dia/v4.18-2

For:

- removal of atomisp driver from staging, as nobody would have time to
  dedicate huge efforts to fix all the problems there. Also, we have a
  feeling that the driver may not even run the way it is;
- Zoran driver has been moved to staging, in order to be either fixed
  to use VB2 and the proper media kAPIs or to be removed;
- Removal of videobuf-dvb driver, with is unused for a while;
- Some V4L2 documentation fixes/improvements;
- New sensor drivers: imx258 and ov7251;
- A new driver were added to allow using I2C transparent drivers;
- Several improvements at the ddbridge driver;
- Several improvements at the ISDB pt1 driver, making it more
  coherent with the DVB framework;
- Added a new platform driver for MIPI CSI-2 RX: cadence;
- Now, all media drivers can be compiled on x86 with
  COMPILE_TEST;
- almost all media drivers now build on non-x86 architectures
  with COMPILE_TEST;
- lots of other random stuff: cleanups, support for new board
  models, bug fixes, etc.

The atomisp removal is the biggest diffstat change here.

Regards,
Mauro

---

The following changes since commit 75bc37fefc4471e718ba8e651aa74673d4e0a9eb:

  Linux 4.17-rc4 (2018-05-06 16:57:38 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/me=
dia/v4.18-2

for you to fetch changes up to 48a8bbc7ca494709522621929f8407ab823d73fc:

  media: omap2: fix compile-testing with FB_OMAP2=3Dm (2018-06-06 14:37:51 =
-0400)

----------------------------------------------------------------
media updates for v4.18-rc1

----------------------------------------------------------------
Akihiro Tsukada (16):
      media: media/dvb: earth-pt3: use the new i2c binding helper
      media: dvb-frontends/tc90522: fix bit shift mistakes
      media: dvb-core/dvb_frontend: set better default for ISDB-T
      media: dvb-frontends/tc90522: use SPDX License Identifier
      media: dvb/pci/pt3: use SPDX License Identifier
      media: tuners/mxl301rf: use SPDX License Identifier
      media: tuners/qm1d1c0042: use SPDX License Identifier
      media: dvb-frontends/dvb-pll: add i2c driver support
      media: dvb-frontends/dvb-pll: add tua6034 ISDB-T tuner used in Friio
      media: dvb-usb-v2/gl861: use usleep_range() for short delay
      media: dvb-usb-v2/gl861: ensure USB message buffers DMA'able
      media: dvb-frontends/dvb-pll: add tda6651 ISDB-T pll_desc
      media: tuners: add new i2c driver for Sharp qm1d1b0004 ISDB-S tuner
      media: dvb: earth-pt1: decompose pt1 driver into sub drivers
      media: dvb: earth-pt1: add support for suspend/resume
      media: dvb: earth-pt1: replace schedule_timeout with usleep_range

Akinobu Mita (6):
      media: ov2640: make set_fmt() work in power-down mode
      media: ov2640: make s_ctrl() work in power-down mode
      media: dt-bindings: ov772x: add device tree binding
      media: ov772x: correct setting of banding filter
      media: pxa_camera: avoid duplicate s_power calls
      media: pxa_camera: ignore -ENOIOCTLCMD from v4l2_subdev_call for s_po=
wer

Anders Roxell (3):
      drivers: omap2: Kconfig: make FB_OMAP2_DSS_INIT depend on OF
      media: drivers: media: platform: make VIDEO_VIU depend on I2C
      media: usb: cx231xx-417: include linux/slab.h header

Andi Shyti (1):
      media: rc: ir-spi: update Andi's e-mail

Arnd Bergmann (6):
      media: omap3isp: Allow it to build with COMPILE_TEST
      media: cxd2880-spi: avoid out-of-bounds access warning
      media: omap3isp: support 64-bit version of omap3isp_stat_data
      media: marvel-ccic: allow ccic and mmp drivers to coexist
      media: marvel-ccic: mmp: select VIDEOBUF2_VMALLOC/DMA_CONTIG
      media: omap2: fix compile-testing with FB_OMAP2=3Dm

Arvind Yadav (2):
      media: platform: Use gpio_is_valid()
      media: sta2x11: Use gpio_is_valid() and remove unnecessary check

Bhumika Goyal (2):
      media: v4l: omap3isp: make v4l2_file_operations const
      media: omap3isp: make omap3isp_prev_csc and omap3isp_prev_rgbtorgb co=
nst

Bingbu Cao (1):
      media: intel-ipu3: cio2: Handle IRQs until INT_STS is cleared

Brad Love (20):
      media: cx231xx: Fix several incorrect demod addresses
      media: cx231xx: Use board profile values for addresses
      media: cx231xx: Style fix for struct zero init
      media: cx231xx: Ignore an i2c mux adapter
      media: cx231xx: Switch to using new dvb i2c helpers
      media: cx231xx: Update 955Q from dvb attach to i2c device
      media: cx231xx: Remove unnecessary parameter clear
      media: cx231xx: Remove RC_CORE dependency
      media: cx231xx: Add I2C_MUX dependency
      media: cx231xx: Fix recursive dependency
      media: em28xx: Fix DualHD broken second tuner
      media: intel-ipu3: Kconfig coding style issue
      media: cec: Kconfig coding style issue
      media: saa7164: Fix driver name in debug output
      media: cx23885: Handle additional bufs on interrupt
      media: cx23885: Use PCI and TS masks in irq functions
      media: cx23885: Ryzen DMA related RiSC engine stall fixes
      media: cx23885: Expand registers in dma tsport reg dump
      media: cx23885: Add some missing register documentation
      media: em28xx: Demote several dev_err to dev_info

Chris Lesiak (1):
      media: platform: video-mux: propagate format from sink to source

Chris Mayo (1):
      media: em28xx-cards: output regular messages as info

Christophe JAILLET (1):
      media: i2c: tda1997: Fix an error handling path 'tda1997x_probe()'

Colin Ian King (8):
      media: cec: set ev rather than v with CEC_PIN_EVENT_FL_DROPPED bit
      media: include/media: fix missing | operator when setting cfg
      media: media/usbvision: fix spelling mistake: "compresion" -> "compre=
ssion"
      media: cx231xx: Fix spelling mistake: "senario" -> "scenario"
      media: dvb_frontends: fix spelling mistake: "unexpcted" -> "unexpecte=
d"
      media: atomisp: fix spelling mistake: "diregard" -> "disregard"
      media: smiapp: fix timeout checking in smiapp_read_nvm
      media: hdpvr: fix spelling mistake: "Hauppage" -> "Hauppauge"

Dan Carpenter (2):
      media: vpbe_venc: potential uninitialized variable in ven_sub_dev_ini=
t()
      media: vivid: potential integer overflow in vidioc_g_edid()

Daniel Scheller (27):
      media: ddbridge: don't uselessly check for dma in start/stop functions
      media: dvb-frontends/stv0910: add init values for TSINSDELM/L
      media: dvb-frontends/stv0910: fix CNR reporting in read_snr()
      media: ddbridge: move modparams to ddbridge-core.c
      media: ddbridge: move ddb_wq and the wq+class initialisation to -core
      media: ddbridge: move MSI IRQ cleanup to a helper function
      media: ddbridge: request/free_irq using pci_irq_vector, enable MSI-X
      media: ddbridge: add helper for IRQ handler setup
      media: ddbridge: add macros to handle IRQs in nibble and byte blocks
      media: ddbridge: improve separated MSI IRQ handling
      media: ddbridge: use spin_lock_irqsave() in output_work()
      media: ddbridge: fix output buffer check
      media: ddbridge: set devid entry for link 0
      media: ddbridge: make DMA buffer count and size modparam-configurable
      media: ddbridge: support dummy tuners with 125MByte/s dummy data stre=
am
      media: ddbridge: initial support for MCI-based MaxSX8 cards
      media: ddbridge/max: implement MCI/MaxSX8 attach function
      media: ddbridge: add hardware defs and PCI IDs for MCI cards
      media: ddbridge: recognize and attach the MaxSX8 cards
      media: ddbridge: set driver version to 0.9.33-integrated
      media: ddbridge, cxd2099: include guard, fix unneeded NULL init, stri=
ngs
      media: ngene: cleanup superfluous I2C adapter evaluation
      media: ngene: fix ci_tsfix modparam description typo
      media: ddbridge/mci: protect against out-of-bounds array access in st=
op()
      media: ddbridge/mci: add identifiers to function definition arguments
      media: dvb-frontends/stv0910: make TS speed configurable
      media: ddbridge: conditionally enable fast TS for stv0910-equipped br=
idges

Devin Heitmueller (1):
      media: cx88: Get rid of spurious call to cx8800_start_vbi_dma()

Dmitry Osipenko (7):
      media: staging: tegra-vde: Align bitstream size to 16K
      media: staging: tegra-vde: Silence some of checkpatch warnings
      media: staging: tegra-vde: Correct minimum size of U/V planes
      media: staging: tegra-vde: Do not handle spurious interrupts
      media: staging: tegra-vde: Correct included header
      media: staging: tegra-vde: Reset memory client
      media: staging: tegra-vde: Reset VDE regardless of memory client rese=
tting failure

Ezequiel Garcia (6):
      media: usbtv: Implement wait_prepare and wait_finish
      media: gspca: Kill all URBs before releasing any of them
      media: stk1160: Fix typo s/therwise/Otherwise
      media: stk1160: Add missing calls to mutex_destroy
      media: m2m-deinterlace: Remove DMA_ENGINE dependency
      media: tw686x: Fix incorrect vb2_mem_ops GFP flags

Fabien Dessenne (2):
      media: bdisp: don't use GFP_DMA
      media: st-hva: don't use GFP_DMA

Fabio Estevam (2):
      media: ov5695: Remove owner assignment from i2c_driver
      media: ov13858: Remove owner assignment from i2c_driver

Fabrizio Castro (2):
      media: dt-bindings: media: rcar_vin: Reverse SoC part number list
      media: dt-bindings: media: rcar_vin: add device tree support for r8a7=
74[35]

Fengguang Wu (1):
      media: vcodec: fix ptr_ret.cocci warnings

Geert Uytterhoeven (2):
      media: vsp1: Drop OF dependency of VIDEO_RENESAS_VSP1
      media: Remove depends on HAS_DMA in case of platform dependency

Gustavo A. R. Silva (1):
      media: au8522: remove duplicate code

Gustavo Padovan (2):
      media: xilinx: regroup caps on querycap
      media: hackrf: group device capabilities

Hans Verkuil (26):
      media: cec: fix smatch error
      media: cec-gpio: use GPIOD_OUT_HIGH_OPEN_DRAIN
      media: v4l2-dev.h: fix doc warning
      media: v4l2-device.h: always expose mdev
      media: lgdt330x.h: fix compiler warning
      media: zoran: move to staging in preparation for removal
      media: go7007: fix two sparse warnings
      media: zoran: fix compiler warning
      media: s5p-mfc: fix two sparse warnings
      media: hdpvr: fix compiler warning
      media: imx: fix compiler warning
      media: renesas-ceu: fix compiler warning
      media: soc_camera: fix compiler warning
      media: cec: improve cec status documentation
      media: adv7511: fix clearing of the CEC receive buffer
      media: videobuf2-core: don't call memop 'finish' when queueing
      media: gspca: convert to vb2
      media: v4l2-ioctl: clear fields in s_parm
      media: v4l2-ioctl: delete unused v4l2_disable_ioctl_locking
      media: gspca: fix g/s_parm handling
      media: cec: fix wrong tx/rx_status values when canceling a msg
      media: adv7511: fix incorrect clear of CEC receive interrupt
      media: pvrusb2: replace pvr2_v4l2_ioctl by video_ioctl2
      media: v4l2-core: push taking ioctl mutex down to ioctl handler
      media: v4l2-ioctl.c: fix missing unlock in __video_do_ioctl()
      media: media/radio/Kconfig: add back RADIO_ISA

Hans de Goede (1):
      media: gspca: Stop using GFP_DMA for buffers for USB bulk transfers

Hugo Grostabussiat (6):
      media: usbtv: Use same decoder sequence as Windows driver
      media: usbtv: Add SECAM support
      media: usbtv: Use V4L2 defines to select capture resolution
      media: usbtv: Keep norm parameter specific
      media: usbtv: Enforce standard for color decoding
      media: usbtv: Use the constant for supported standards

Jacopo Mondi (3):
      media: renesas-ceu: Set mbus_fmt on subdev operations
      media: dt-bindings: media: renesas-ceu: Add R-Mobile R8A7740
      media: arch: sh: migor: Fix TW9910 PDN gpio

Jan Luebbe (1):
      media: imx-csi: fix burst size for 16 bit

Jasmin Jessich (2):
      media: Use ktime_set() in pt1.c
      media: Revert cleanup ktime_set() usage

Jason Chen (1):
      media: imx258: Add imx258 camera sensor driver

Jia-Ju Bai (1):
      media: dvb-usb: Replace GFP_ATOMIC with GFP_KERNEL

Julia Lawall (2):
      media: pvrusb2: delete unneeded include
      media: staging: media: use relevant lock

Kai-Heng Feng (1):
      media: cx231xx: Add support for AverMedia DVD EZMaker 7

Kieran Bingham (11):
      media: vsp1: Release buffers for each video node
      media: vsp1: Move video suspend resume handling to video object
      media: vsp1: Reword uses of 'fragment' as 'body'
      media: vsp1: Protect bodies against overflow
      media: vsp1: Provide a body pool
      media: vsp1: Convert display lists to use new body pool
      media: vsp1: Use reference counting for bodies
      media: vsp1: Refactor display list configure operations
      media: vsp1: Adapt entities to configure into a body
      media: vsp1: Move video configuration to a cached dlb
      media: uvcvideo: Prevent setting unavailable flags

Koji Matsuoka (1):
      media: rcar-vin: Fix image alignment for setting pre clipping

Laurent Pinchart (25):
      media: omap3isp: Enable driver compilation on ARM with COMPILE_TEST
      media: v4l: vsp1: Don't start/stop media pipeline for DRM
      media: v4l: vsp1: Remove unused field from vsp1_drm_pipeline structure
      media: v4l: vsp1: Store pipeline pointer in vsp1_entity
      media: v4l: vsp1: Use vsp1_entity.pipe to check if entity belongs to =
a pipeline
      media: v4l: vsp1: Share duplicated DRM pipeline configuration code
      media: v4l: vsp1: Move DRM atomic commit pipeline setup to separate f=
unction
      media: v4l: vsp1: Setup BRU at atomic commit time
      media: v4l: vsp1: Replace manual DRM pipeline input setup in vsp1_du_=
setup_lif
      media: v4l: vsp1: Move DRM pipeline output setup code to a function
      media: v4l: vsp1: Turn frame end completion status into a bitfield
      media: v4l: vsp1: Add per-display list internal completion notificati=
on support
      media: v4l: vsp1: Generalize detection of entity removal from DRM pip=
eline
      media: v4l: vsp1: Assign BRU and BRS to pipelines dynamically
      media: v4l: vsp1: Add BRx dynamic assignment debugging messages
      media: v4l: vsp1: Rename BRU to BRx
      media: v4l: vsp1: Use SPDX license headers
      media: v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad operation co=
de
      media: v4l: vsp1: Reset the crop and compose rectangles in the set_fm=
t helper
      media: v4l: vsp1: Document the vsp1_du_atomic_config structure
      media: v4l: vsp1: Extend the DU API to support CRC computation
      media: v4l: vsp1: Add support for the DISCOM entity
      media: v4l: vsp1: Integrate DISCOM in display pipeline
      media: drm: rcar-du: Add support for CRC computation
      media: i2c: adv748x: Fix pixel rate values

Leonard Crestez (1):
      media: v4l: fwnode: Fix comment incorrectly mentioning v4l2_fwnode_pa=
rse_endpoint

Luc Van Oostenryck (3):
      media: frontends: fix ops get_algo()'s return type
      media: lgdt3306a: fix lgdt3306a_search()'s return type
      media: dvb_net: fix dvb_net_tx()'s return type

Luca Ceresoli (11):
      media: imx274: document reset delays more clearly
      media: imx274: fix typo in comment
      media: imx274: slightly simplify code
      media: imx274: remove unused data from struct imx274_frmfmt
      media: imx274: rename and reorder register address definitions
      media: imx274: remove non-indexed pointers from mode_table
      media: docs: selection: fix typos
      media: docs: clarify relationship between crop and selection APIs
      media: docs: selection: rename files to something meaningful
      media: docs: selection: improve formatting
      media: docs: selection: fix misleading sentence about the CROP API

Marcel Stork (2):
      media: em28xx: merge two identical cases inside a switch()
      media: em28xx: Add new dvb-t board ":Zolid Hybrid Tv Stick"

Matt Ranostay (2):
      media: dt-bindings: Add bindings for panasonic,amg88xx
      media: video-i2c: add video-i2c driver

Matthias Reichl (1):
      media: rc: ite-cir: lower timeout and extend allowed timeout range

Mauro Carvalho Chehab (119):
      media: omap3isp/isp: remove an unused static var
      media: fsl-viu: mark static functions as such
      media: fsl-viu: allow building it with COMPILE_TEST
      media: cec_gpio: allow building CEC_GPIO with COMPILE_TEST
      media: exymos4-is: allow compile test for EXYNOS FIMC-LITE
      media: mmp-camera.h: add missing platform data
      media: marvel-ccic: re-enable mmp-driver build
      media: mmp-driver: make two functions static
      media: davinci: allow building isif code
      media: davinci: allow build vpbe_display with COMPILE_TEST
      media: vpbe_venc: don't store return codes if they won't be used
      media: davinci: get rid of lots of kernel-doc warnings
      media: omap2: omapfb: allow building it with COMPILE_TEST
      media: omap: allow building it with COMPILE_TEST
      media: omap4iss: make it build with COMPILE_TEST
      media: si470x: allow build both USB and I2C at the same time
      media: staging: davinci_vpfe: allow building with COMPILE_TEST
      media: davinci_vpfe: remove useless checks from ipipe
      media: dm365_ipipe: remove an unused var
      media: davinci_vpfe: fix vpfe_ipipe_init() error handling
      media: davinci_vpfe: mark __iomem as such
      media: davinci_vpfe: get rid of an unused var at dm365_isif.c
      media: davinci_vpfe: vpfe_video: remove an unused var
      media: davinci_vpfe: don't use kernel-doc markup for simple comments
      media: davinci_vpfe: fix a typo for "default"
      media: davinci_vpfe: cleanup ipipe_[g|s]_config logic
      media: davinci_vpfe: fix __user annotations
      media: si470x: fix __be16 annotations
      media: isif: reorder a statement to match coding style
      media: davinci: fix an inconsistent ident
      media: mmp-driver: add needed __iomem marks to power_regs
      media: vpbe_display: properly handle error case
      media: vpbe_display: get rid of warnings
      media: ispstat: use %p to print the address of a buffer
      media: isppreview: fix __user annotations
      media: fsl-viu: use %p to print pointers
      media: fsl-viu: fix __iomem annotations
      media: omap_vout: fix wrong identing
      media: staging: atomisp: fix number conversion
      media: staging: atomisp: don't declare the same vars as both private =
and public
      media: atomisp: fix __user annotations
      media: staging: atomisp: fix string comparation logic
      media: dvb_frontend: fix locking issues at dvb_frontend_get_event()
      media: v4l2-fwnode: simplify v4l2_fwnode_reference_parse_int_props()
      media: atomisp: remove an impossible condition
      media: platform: fix some 64-bits warnings
      media: v4l2-compat-ioctl32: prevent go past max size
      media: atomisp: compat32: use get_user() before referencing user data
      media: staging: atomisp: add missing include
      media: atomisp: compat32: fix __user annotations
      media: atomisp: get rid of a warning
      media: st_rc: Don't stay on an IRQ handler forever
      media: mantis: prevent staying forever in a loop at IRQ
      media: si470x: fix a typo at the Makefile causing build issues
      media: v4l2-compat-ioctl32: fix several __user annotations
      media: v4l2-compat-ioctl32: better name userspace pointers
      media: v4l2-compat-ioctl32: simplify casts
      media: v4l2-compat-ioctl32: better document the code
      media: omap: omap-iommu.h: allow building drivers with COMPILE_TEST
      media: sound, media: allow building ISA drivers it with COMPILE_TEST
      media: sound, isapnp: allow building more drivers with COMPILE_TEST
      media: siano: get rid of __le32/__le16 cast warnings
      media: siano: be sure to not override devpath size
      media: s5p-jpeg: don't return a value on a void function
      media: em28xx: Don't use ops->resume if NULL
      media: davinci: don't override the error code
      media: flexcop-i2c: get rid of KERN_CONT
      media: radio: allow building ISA drivers with COMPILE_TEST
      media: sta2x11_vip: allow build with COMPILE_TEST
      media: rc: allow build pnp-dependent drivers with COMPILE_TEST
      media: ipu3: allow building it with COMPILE_TEST on non-x86 archs
      media: omapfb: omapfb_dss.h: add stubs to build with COMPILE_TEST && =
DRM_OMAP
      media: omap2: allow building it with COMPILE_TEST && DRM_OMAP
      media: video-i2c: get rid of two gcc warnings
      media: dvbsky: use the new dvb_module_probe() API
      media: dvbsky: fix driver unregister logic
      media: dvb-usb-v2: stop using coherent memory for URBs
      media: cx231xx: get rid of videobuf-dvb dependency
      media: v4l2-core: get rid of videobuf-dvb
      media: em28xx: fix a regression with HVR-950
      media: lgdt330x: use kernel-doc instead of inlined comments
      media: lgdt330x: fix coding style issues
      media: lgdt330x: use pr_foo() macros
      media: lgdt330x: print info when device gets probed
      media: lgdt330x: convert it to the new I2C binding way
      media: lgdt330x: do some cleanups at status logic
      media: lgdt330x: constify several register init arrays
      media: lgdt330x: move *read_status functions
      media: lgdt330x: provide DVBv5 Carrier S/N measurements
      media: lgdt330x: get rid of read_ber stub
      media: lgdt330x: add block error counts via DVBv5
      media: lgdt330x: don't use an uninitialized state
      media: pt3: no need to check if null for dvb_module_release()
      media: v4l2-dev: use pr_foo() for printing messages
      media: pt1: fix strncmp() size warning
      media: cx231xx: remove a now unused var
      media: pt1: use #ifdef CONFIG_PM_SLEEP instead of #if
      media: docs: update em28xx and cx23885 cardlists
      media: meye: allow building it with COMPILE_TEST on non-x86
      media: include/video/omapfb_dss.h: use IS_ENABLED()
      qm1d1b0004: fix a warning about an unused default_cfg var
      media: dvbsky: use just one mutex for serializing device R/W ops
      Merge tag 'v4.17-rc4' into patchwork
      media: update/fix my e-mail on some places
      media: dvb_frontend: cleanup some coding style errors
      media: gp8psk: don't abuse of GFP_DMA
      media: siano: use GFP_DMA only for smssdio
      media: dvb_ca_en50221: prevent using slot_info for Spectre attacs
      media: staging: atomisp: get rid of __KERNEL macros
      media: staging: atomisp: reenable warnings for I2C
      media: atomisp: ov2680.h: fix identation
      media: staging: atomisp-gc2235: don't fill an unused var
      media: staging: atomisp: Comment out several unused sensor resolutions
      media: atomisp: ov2680: don't declare unused vars
      media: atomisp-gc0310: return errors at gc0310_init()
      media: atomisp-mt9m114: remove dead data
      media: atomisp-mt9m114: comment out unused stuff
      media: imx258: get rid of an unused var
      media: cec-pin-error-inj: avoid a false-positive Spectre detection

Max Kellermann (1):
      media: dvbdev: add a mutex protecting the "mdev" pointer

Maxime Ripard (9):
      media: dt-bindings: media: Add Cadence MIPI-CSI2 RX Device Tree bindi=
ngs
      media: v4l: cadence: Add Cadence MIPI-CSI2 RX driver
      media: dt-bindings: media: Add Cadence MIPI-CSI2 TX Device Tree bindi=
ngs
      media: v4l: cadence: Add Cadence MIPI-CSI2 TX driver
      media: ov5640: Don't force the auto exposure state at start time
      media: ov5640: Init properly the SCLK dividers
      media: ov5640: Change horizontal and vertical resolutions name
      media: ov5640: Add horizontal and vertical totals
      media: ov5640: Program the visible resolution

Micha=C5=82 Winiarski (3):
      media: rc: nuvoton: Tweak the interrupt enabling dance
      media: rc: nuvoton: Keep track of users on CIR enable/disable
      media: rc: nuvoton: Keep device enabled during reg init

Myl=C3=A8ne Josserand (1):
      media: ov5640: Add light frequency control

Nasser Afshin (4):
      media: i2c: tvp5150: Use parentheses for sizeof
      media: i2c: tvp5150: Add a space after commas
      media: i2c: tvp5150: Use the correct comment style
      media: i2c: tvp5150: Fix open brace placement codding style

Niklas S=C3=B6derlund (41):
      media: rcar-vin: add Gen3 devicetree bindings documentation
      media: rcar-vin: rename poorly named initialize and cleanup functions
      media: rcar-vin: unregister video device on driver removal
      media: rcar-vin: move subdevice handling to async callbacks
      media: rcar-vin: move model information to own struct
      media: rcar-vin: move max width and height information to chip inform=
ation
      media: rcar-vin: move functions regarding scaling
      media: rcar-vin: all Gen2 boards can scale simplify logic
      media: rcar-vin: set a default field to fallback on
      media: rcar-vin: fix handling of single field frames (top, bottom and=
 alternate fields)
      media: rcar-vin: update bytesperline and sizeimage calculation
      media: rcar-vin: align pixelformat check
      media: rcar-vin: break out format alignment and checking
      media: rcar-vin: simplify how formats are set and reset
      media: rcar-vin: cache video standard
      media: rcar-vin: move media bus configuration to struct rvin_dev
      media: rcar-vin: enable Gen3 hardware configuration
      media: rcar-vin: add function to manipulate Gen3 chsel value
      media: rcar-vin: add flag to switch to media controller mode
      media: rcar-vin: use different v4l2 operations in media controller mo=
de
      media: rcar-vin: force default colorspace for media centric mode
      media: rcar-vin: prepare for media controller mode initialization
      media: rcar-vin: add group allocator functions
      media: rcar-vin: change name of video device
      media: rcar-vin: add chsel information to rvin_info
      media: rcar-vin: parse Gen3 OF and setup media graph
      media: rcar-vin: add link notify for Gen3
      media: rcar-vin: extend {start, stop}_streaming to work with media co=
ntroller
      media: rcar-vin: enable support for r8a7795
      media: rcar-vin: enable support for r8a7796
      media: rcar-vin: enable support for r8a77970
      media: rcar-vin: remove generic gen3 compatible string
      media: rcar-vin: fix null pointer dereference in rvin_group_get()
      media: rcar-vin: add support for MEDIA_BUS_FMT_UYVY8_1X16
      media: rcar-vin: enable field toggle after a set number of lines for =
Gen3
      media: entity: fix spelling for media_entity_get_fwnode_pad()
      media: Revert "media: rcar-vin: enable field toggle after a set numbe=
r of lines for Gen3"
      media: rcar-vin: fix crop and compose handling for Gen3
      media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver documentation
      media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
      media: rcar-csi2: set default format if a unsupported one is requested

Ondrej Zary (3):
      media: gspca_zc3xx: Implement proper autogain and exposure control fo=
r OV7648
      media: gspca_zc3xx: Fix power line frequency settings for OV7648
      media: gspca_zc3xx: Enable short exposure times for OV7648

Peter Rosin (1):
      media: saa7146: fix error return from master_xfer

Philipp Zabel (5):
      media: coda: reuse coda_s_fmt_vid_cap to propagate format in coda_s_f=
mt_vid_out
      media: coda: do not try to propagate format if capture queue busy
      media: coda: set colorimetry on coded queue
      media: imx: add 16-bit grayscale support
      media: uvcvideo: Fix driver reference counting

Rainer Keller (1):
      media: dvb: add alternative USB PID for Hauppauge WinTV-soloHD

Robin Murphy (1):
      media: videobuf-dma-sg: Fix dma_{sync,unmap}_sg() calls

Ryder Lee (1):
      media: rc: mtk-cir: use of_device_get_match_data()

Sakari Ailus (10):
      media: ov7740: Fix number of controls hint
      media: ov7740: Check for possible NULL return value in control creati=
on
      media: ov7740: Fix control handler error at the end of control init
      media: ov7740: Set subdev HAS_EVENT flag
      media: tda1997x: Use bitwise or for setting subdev flags
      media: omap3isp: Remove useless NULL check in omap3isp_stat_config
      media: omap3isp: Don't use GFP_DMA
      media: staging: atomisp: Remove driver
      media: cadence: csi2rx: Fix csi2rx_start error handling
      media: ov5640: Use dev_fwnode() to obtain device's fwnode

Sami Tolvanen (2):
      media: media-device: fix ioctl function types
      media: v4l2-ioctl: replace IOCTL_INFO_STD with stub functions

Samuel Williams (1):
      media: bttv: Fixed oops error when capturing at yuv410p

Sean Young (24):
      media: rc: report receiver and transmitter type on device register
      media: rc: set timeout to smallest value required by enabled protocols
      media: rc: add ioctl to get the current timeout
      media: rc: per-protocol repeat period and minimum keyup timer
      media: rc: mce_kbd decoder: low timeout values cause double keydowns
      media: rc: mce_kbd protocol encodes two scancodes
      media: rc: mce_kbd decoder: fix stuck keys
      media: rc: mce_kbd decoder: remove superfluous call to input_sync
      media: rc: mce_kbd decoder: fix race condition
      media: rc: mceusb: IR of length 0 means IR timeout, not reset
      media: rc: mceusb: allow the timeout to be configurable
      media: cx88: enable IR transmitter on HVR-1300
      media: rc: only register protocol for rc device if enabled
      media: rc: imon decoder: support the stick
      media: rc: probe zilog transmitter when zilog receiver is found
      media: mceusb: MCE_CMD_SETIRTIMEOUT cause strange behaviour on device
      media: mceusb: filter out bogus timing irdata of duration 0
      media: mceusb: add missing break
      media: lirc-func.rst: new ioctl LIRC_GET_REC_TIMEOUT is not in a sepa=
rate file
      media: rc: default to idle on at startup or after reset
      media: rc: drivers should produce alternate pulse and space timing ev=
ents
      media: rc: decoders do not need to check for transitions
      media: rc: winbond: do not send reset and timeout raw events on start=
up
      media: rc: ensure input/lirc device can be opened after register

Shaokun Zhang (1):
      media: atomisp: fix misleading addr information

Simon Que (1):
      media: v4l2-core: Rename array 'video_driver' to 'video_drivers'

Souptick Joarder (1):
      media: videobuf: Change return type to vm_fault_t

Suman Anna (1):
      media: omap3isp: fix unbalanced dma_iommu_mapping

Todor Tomov (3):
      media: ov5645: Fix write_reg return code
      media: dt-bindings: media: Binding document for OV7251 camera sensor
      media: Add a driver for the ov7251 camera sensor

Wei Yongjun (1):
      media: rcar_jpu: Add missing clk_disable_unprepare() on error in jpu_=
open()

Wolfram Sang (1):
      media: platform: am437x: simplify getting .drvdata

Yasunari Takiguchi (3):
      media: cxd2880-spi: Modified how to declare structure
      media: cxd2880:Optimized spi drive current and BER/PER set/get condit=
ion
      media: cxd2880: Changed version information

YueHaibing (1):
      media: staging: atomisp: Using module_pci_driver

ming_qian (1):
      media: uvcvideo: Support realtek's UVC 1.5 device

 Documentation/ABI/testing/sysfs-class-rc           |    16 +-
 Documentation/ABI/testing/sysfs-class-rc-nuvoton   |     2 +-
 Documentation/ABI/testing/sysfs-devices-edac       |    14 +-
 .../devicetree/bindings/media/cdns,csi2rx.txt      |   100 +
 .../devicetree/bindings/media/cdns,csi2tx.txt      |    98 +
 .../devicetree/bindings/media/i2c/ov7251.txt       |    52 +
 .../devicetree/bindings/media/i2c/ov772x.txt       |    40 +
 .../bindings/media/i2c/panasonic,amg88xx.txt       |    19 +
 .../devicetree/bindings/media/rcar_vin.txt         |   138 +-
 .../devicetree/bindings/media/renesas,ceu.txt      |     7 +-
 .../bindings/media/renesas,rcar-csi2.txt           |   101 +
 Documentation/media/kapi/cec-core.rst              |     5 +-
 Documentation/media/uapi/cec/cec-ioc-receive.rst   |    24 +-
 Documentation/media/uapi/dvb/dvbapi.rst            |     2 +-
 Documentation/media/uapi/rc/lirc-dev-intro.rst     |     2 +-
 .../media/uapi/rc/lirc-set-rec-timeout.rst         |    14 +-
 Documentation/media/uapi/v4l/common.rst            |     2 +-
 Documentation/media/uapi/v4l/crop.rst              |    22 +-
 Documentation/media/uapi/v4l/selection-api-005.rst |    34 -
 ...api-004.rst =3D> selection-api-configuration.rst} |     2 +-
 ...tion-api-006.rst =3D> selection-api-examples.rst} |     0
 ...lection-api-002.rst =3D> selection-api-intro.rst} |     0
 ...ction-api-003.rst =3D> selection-api-targets.rst} |     0
 .../media/uapi/v4l/selection-api-vs-crop-api.rst   |    39 +
 Documentation/media/uapi/v4l/selection-api.rst     |    14 +-
 Documentation/media/uapi/v4l/selection.svg         |     4 +-
 Documentation/media/uapi/v4l/v4l2.rst              |     2 +-
 .../media/v4l-drivers/cx23885-cardlist.rst         |    18 +-
 .../media/v4l-drivers/em28xx-cardlist.rst          |    10 +-
 MAINTAINERS                                        |    31 +-
 arch/sh/boards/mach-migor/setup.c                  |     2 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c             |   156 +-
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h             |    15 +
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c              |    12 +-
 drivers/media/Kconfig                              |    12 +-
 drivers/media/cec/cec-adap.c                       |    19 +-
 drivers/media/cec/cec-core.c                       |     2 +-
 drivers/media/cec/cec-pin-error-inj.c              |    33 +-
 drivers/media/cec/cec-pin.c                        |     2 +-
 drivers/media/common/b2c2/flexcop-fe-tuner.c       |     4 +-
 drivers/media/common/b2c2/flexcop-i2c.c            |    47 +-
 drivers/media/common/b2c2/flexcop.c                |     2 +-
 drivers/media/common/b2c2/flexcop.h                |     1 +
 drivers/media/common/saa7146/saa7146_i2c.c         |     4 +-
 drivers/media/common/siano/smscoreapi.c            |    32 +-
 drivers/media/common/siano/smscoreapi.h            |     3 +
 drivers/media/common/siano/smsendian.c             |    14 +-
 drivers/media/common/videobuf2/Kconfig             |     2 -
 drivers/media/common/videobuf2/videobuf2-core.c    |     9 +-
 drivers/media/dvb-core/dmxdev.c                    |     2 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |     2 +
 drivers/media/dvb-core/dvb_frontend.c              |   230 +-
 drivers/media/dvb-core/dvb_net.c                   |     2 +-
 drivers/media/dvb-core/dvbdev.c                    |     4 +
 drivers/media/dvb-frontends/Kconfig                |     2 +-
 drivers/media/dvb-frontends/as102_fe.h             |     2 +-
 drivers/media/dvb-frontends/au8522_decoder.c       |    14 +-
 drivers/media/dvb-frontends/cx24116.c              |     2 +-
 drivers/media/dvb-frontends/cx24117.c              |     2 +-
 drivers/media/dvb-frontends/cx24120.c              |     2 +-
 drivers/media/dvb-frontends/cx24123.c              |     2 +-
 drivers/media/dvb-frontends/cxd2099.c              |     4 +-
 drivers/media/dvb-frontends/cxd2099.h              |     2 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |     2 +-
 .../cxd2880/cxd2880_tnrdmd_driver_version.h        |     4 +-
 drivers/media/dvb-frontends/cxd2880/cxd2880_top.c  |    14 +-
 drivers/media/dvb-frontends/dvb-pll.c              |   110 +
 drivers/media/dvb-frontends/dvb-pll.h              |     6 +
 drivers/media/dvb-frontends/l64781.c               |     4 +-
 drivers/media/dvb-frontends/lgdt3306a.c            |     2 +-
 drivers/media/dvb-frontends/lgdt330x.c             |   874 +-
 drivers/media/dvb-frontends/lgdt330x.h             |    41 +-
 drivers/media/dvb-frontends/mb86a20s.c             |     2 +-
 drivers/media/dvb-frontends/mxl5xx.c               |     2 +-
 drivers/media/dvb-frontends/s921.c                 |     2 +-
 drivers/media/dvb-frontends/stv0910.c              |    15 +-
 drivers/media/dvb-frontends/stv0910.h              |     1 +
 drivers/media/dvb-frontends/tc90522.c              |    15 +-
 drivers/media/dvb-frontends/tc90522.h              |    11 +-
 drivers/media/i2c/Kconfig                          |    36 +
 drivers/media/i2c/Makefile                         |     3 +
 drivers/media/i2c/adv748x/adv748x-afe.c            |    12 +-
 drivers/media/i2c/adv748x/adv748x-hdmi.c           |     8 +-
 drivers/media/i2c/adv7511.c                        |    22 +-
 drivers/media/i2c/imx258.c                         |  1318 +++
 drivers/media/i2c/imx274.c                         |    74 +-
 drivers/media/i2c/ir-kbd-i2c.c                     |     4 +-
 drivers/media/i2c/ov13858.c                        |     1 -
 drivers/media/i2c/ov2640.c                         |   112 +-
 drivers/media/i2c/ov5640.c                         |   257 +-
 drivers/media/i2c/ov5645.c                         |     6 +-
 drivers/media/i2c/ov5695.c                         |     1 -
 drivers/media/i2c/ov7251.c                         |  1503 +++
 drivers/media/i2c/ov772x.c                         |     2 +-
 drivers/media/i2c/ov7740.c                         |    22 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |    11 +-
 drivers/media/i2c/tda1997x.c                       |     4 +-
 drivers/media/i2c/tvp5150.c                        |   159 +-
 drivers/media/i2c/video-i2c.c                      |   564 +
 drivers/media/media-device.c                       |    21 +-
 drivers/media/mmc/siano/smssdio.c                  |     2 +-
 drivers/media/pci/Kconfig                          |     1 -
 drivers/media/pci/Makefile                         |     1 -
 drivers/media/pci/bt8xx/bttv-risc.c                |    17 +-
 drivers/media/pci/bt8xx/dst.c                      |     2 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c                |     4 +-
 drivers/media/pci/cx23885/cx23885-core.c           |   132 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |     6 +-
 drivers/media/pci/cx23885/cx23885-reg.h            |    14 +
 drivers/media/pci/cx88/cx88-dvb.c                  |     7 +-
 drivers/media/pci/cx88/cx88-input.c                |    11 +-
 drivers/media/pci/cx88/cx88-vbi.c                  |     1 -
 drivers/media/pci/ddbridge/Kconfig                 |     1 +
 drivers/media/pci/ddbridge/Makefile                |     2 +-
 drivers/media/pci/ddbridge/ddbridge-ci.c           |     2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |   419 +-
 drivers/media/pci/ddbridge/ddbridge-hw.c           |    11 +
 drivers/media/pci/ddbridge/ddbridge-i2c.c          |     5 +-
 drivers/media/pci/ddbridge/ddbridge-main.c         |    91 +-
 drivers/media/pci/ddbridge/ddbridge-max.c          |    42 +
 drivers/media/pci/ddbridge/ddbridge-max.h          |     1 +
 drivers/media/pci/ddbridge/ddbridge-mci.c          |   551 +
 drivers/media/pci/ddbridge/ddbridge-mci.h          |   156 +
 drivers/media/pci/ddbridge/ddbridge-regs.h         |     4 +
 drivers/media/pci/ddbridge/ddbridge.h              |    50 +-
 drivers/media/pci/dt3155/Kconfig                   |     1 -
 drivers/media/pci/intel/ipu3/Kconfig               |    16 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |    32 +-
 drivers/media/pci/mantis/mantis_uart.c             |     7 +
 drivers/media/pci/meye/Kconfig                     |     3 +-
 drivers/media/pci/ngene/ngene-cards.c              |    18 +-
 drivers/media/pci/ngene/ngene-dvb.c                |     2 +-
 drivers/media/pci/pt1/Kconfig                      |     3 +
 drivers/media/pci/pt1/Makefile                     |     3 +-
 drivers/media/pci/pt1/pt1.c                        |   471 +-
 drivers/media/pci/pt1/va1j5jf8007s.c               |   732 --
 drivers/media/pci/pt1/va1j5jf8007s.h               |    42 -
 drivers/media/pci/pt1/va1j5jf8007t.c               |   532 -
 drivers/media/pci/pt1/va1j5jf8007t.h               |    42 -
 drivers/media/pci/pt3/pt3.c                        |    70 +-
 drivers/media/pci/pt3/pt3.h                        |    11 +-
 drivers/media/pci/pt3/pt3_dma.c                    |    11 +-
 drivers/media/pci/pt3/pt3_i2c.c                    |    11 +-
 drivers/media/pci/saa7164/saa7164-fw.c             |     3 +-
 drivers/media/pci/solo6x10/Kconfig                 |     1 -
 drivers/media/pci/sta2x11/Kconfig                  |     3 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    31 +-
 drivers/media/pci/tw5864/Kconfig                   |     1 -
 drivers/media/pci/tw686x/Kconfig                   |     1 -
 drivers/media/pci/tw686x/tw686x-video.c            |     3 +-
 drivers/media/platform/Kconfig                     |    57 +-
 drivers/media/platform/Makefile                    |     1 +
 drivers/media/platform/am437x/Kconfig              |     2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |     6 +-
 drivers/media/platform/atmel/Kconfig               |     4 +-
 drivers/media/platform/cadence/Kconfig             |    34 +
 drivers/media/platform/cadence/Makefile            |     4 +
 drivers/media/platform/cadence/cdns-csi2rx.c       |   498 +
 drivers/media/platform/cadence/cdns-csi2tx.c       |   563 +
 drivers/media/platform/cec-gpio/cec-gpio.c         |     2 +-
 drivers/media/platform/coda/coda-common.c          |    45 +-
 drivers/media/platform/davinci/Kconfig             |    12 +-
 drivers/media/platform/davinci/isif.c              |     4 +-
 drivers/media/platform/davinci/vpbe.c              |    38 +-
 drivers/media/platform/davinci/vpbe_display.c      |    33 +-
 drivers/media/platform/davinci/vpbe_osd.c          |    21 +-
 drivers/media/platform/davinci/vpbe_venc.c         |    11 +-
 drivers/media/platform/davinci/vpfe_capture.c      |     2 +-
 drivers/media/platform/exynos4-is/Kconfig          |     4 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |     2 +-
 drivers/media/platform/fsl-viu.c                   |    63 +-
 drivers/media/platform/marvell-ccic/Kconfig        |     7 +-
 drivers/media/platform/marvell-ccic/Makefile       |     9 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |     9 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |     6 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    |     5 +-
 drivers/media/platform/omap/Kconfig                |     7 +-
 drivers/media/platform/omap/omap_vout.c            |    17 +-
 drivers/media/platform/omap/omap_vout_vrfb.c       |     4 +-
 drivers/media/platform/omap3isp/isp.c              |    22 +-
 drivers/media/platform/omap3isp/ispccdc.c          |     2 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c      |     2 +
 drivers/media/platform/omap3isp/isph3a_af.c        |     2 +
 drivers/media/platform/omap3isp/isphist.c          |     2 +
 drivers/media/platform/omap3isp/isppreview.c       |     6 +-
 drivers/media/platform/omap3isp/ispstat.c          |    37 +-
 drivers/media/platform/omap3isp/ispstat.h          |     4 +-
 drivers/media/platform/omap3isp/ispvideo.c         |     2 +-
 drivers/media/platform/pxa_camera.c                |    50 +-
 drivers/media/platform/rcar-vin/Kconfig            |    16 +-
 drivers/media/platform/rcar-vin/Makefile           |     1 +
 drivers/media/platform/rcar-vin/rcar-core.c        |   959 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c        |  1084 ++
 drivers/media/platform/rcar-vin/rcar-dma.c         |   912 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   490 +-
 drivers/media/platform/rcar-vin/rcar-vin.h         |   146 +-
 drivers/media/platform/rcar_jpu.c                  |     4 +-
 drivers/media/platform/renesas-ceu.c               |    23 +-
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |     4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |     4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |     4 +-
 drivers/media/platform/soc_camera/Kconfig          |     3 +-
 .../platform/soc_camera/soc_camera_platform.c      |     3 +-
 drivers/media/platform/sti/bdisp/bdisp-hw.c        |     2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |     4 +
 drivers/media/platform/sti/c8sectpfe/Kconfig       |     2 +-
 drivers/media/platform/sti/hva/hva-mem.c           |     2 +-
 drivers/media/platform/sti/hva/hva-v4l2.c          |     4 +
 drivers/media/platform/via-camera.c                |     2 +-
 drivers/media/platform/video-mux.c                 |    16 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |     2 +-
 drivers/media/platform/vsp1/Makefile               |     4 +-
 drivers/media/platform/vsp1/vsp1.h                 |    16 +-
 drivers/media/platform/vsp1/vsp1_bru.h             |    48 -
 .../media/platform/vsp1/{vsp1_bru.c =3D> vsp1_brx.c} |   218 +-
 drivers/media/platform/vsp1/vsp1_brx.h             |    44 +
 drivers/media/platform/vsp1/vsp1_clu.c             |   184 +-
 drivers/media/platform/vsp1/vsp1_clu.h             |     7 +-
 drivers/media/platform/vsp1/vsp1_dl.c              |   441 +-
 drivers/media/platform/vsp1/vsp1_dl.h              |    36 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |   951 +-
 drivers/media/platform/vsp1/vsp1_drm.h             |    31 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |    38 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |   137 +-
 drivers/media/platform/vsp1/vsp1_entity.h          |    60 +-
 drivers/media/platform/vsp1/vsp1_hgo.c             |    32 +-
 drivers/media/platform/vsp1/vsp1_hgo.h             |     6 +-
 drivers/media/platform/vsp1/vsp1_hgt.c             |    34 +-
 drivers/media/platform/vsp1/vsp1_hgt.h             |     6 +-
 drivers/media/platform/vsp1/vsp1_histo.c           |    67 +-
 drivers/media/platform/vsp1/vsp1_histo.h           |     9 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |    26 +-
 drivers/media/platform/vsp1/vsp1_hsit.h            |     6 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |    96 +-
 drivers/media/platform/vsp1/vsp1_lif.h             |     6 +-
 drivers/media/platform/vsp1/vsp1_lut.c             |   151 +-
 drivers/media/platform/vsp1/vsp1_lut.h             |     7 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |   127 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |    24 +-
 drivers/media/platform/vsp1/vsp1_regs.h            |    46 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   207 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |     6 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |    10 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |    30 +-
 drivers/media/platform/vsp1/vsp1_sru.h             |     6 +-
 drivers/media/platform/vsp1/vsp1_uds.c             |    79 +-
 drivers/media/platform/vsp1/vsp1_uds.h             |     8 +-
 drivers/media/platform/vsp1/vsp1_uif.c             |   264 +
 drivers/media/platform/vsp1/vsp1_uif.h             |    32 +
 drivers/media/platform/vsp1/vsp1_video.c           |   220 +-
 drivers/media/platform/vsp1/vsp1_video.h           |     9 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   340 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |    10 +-
 drivers/media/radio/Kconfig                        |    44 +-
 drivers/media/radio/si470x/Kconfig                 |    16 +-
 drivers/media/radio/si470x/Makefile                |     8 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    70 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |    24 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |    18 +-
 drivers/media/radio/si470x/radio-si470x.h          |    15 +-
 drivers/media/rc/Kconfig                           |    10 +-
 drivers/media/rc/ir-imon-decoder.c                 |   136 +-
 drivers/media/rc/ir-jvc-decoder.c                  |     1 +
 drivers/media/rc/ir-mce_kbd-decoder.c              |    64 +-
 drivers/media/rc/ir-nec-decoder.c                  |     1 +
 drivers/media/rc/ir-rc5-decoder.c                  |     4 +-
 drivers/media/rc/ir-rc6-decoder.c                  |    11 +-
 drivers/media/rc/ir-sanyo-decoder.c                |     1 +
 drivers/media/rc/ir-sharp-decoder.c                |     1 +
 drivers/media/rc/ir-sony-decoder.c                 |     1 +
 drivers/media/rc/ir-spi.c                          |     4 +-
 drivers/media/rc/ir-xmp-decoder.c                  |     1 +
 drivers/media/rc/ite-cir.c                         |     8 +-
 drivers/media/rc/ite-cir.h                         |     7 -
 drivers/media/rc/lirc_dev.c                        |    31 +-
 drivers/media/rc/mceusb.c                          |    53 +-
 drivers/media/rc/mtk-cir.c                         |     4 +-
 drivers/media/rc/nuvoton-cir.c                     |    89 +-
 drivers/media/rc/rc-core-priv.h                    |     6 +
 drivers/media/rc/rc-ir-raw.c                       |    81 +-
 drivers/media/rc/rc-main.c                         |    72 +-
 drivers/media/rc/st_rc.c                           |    16 +-
 drivers/media/rc/winbond-cir.c                     |     4 +-
 drivers/media/spi/cxd2880-spi.c                    |    32 +-
 drivers/media/tuners/Kconfig                       |     7 +
 drivers/media/tuners/Makefile                      |     1 +
 drivers/media/tuners/mxl301rf.c                    |    11 +-
 drivers/media/tuners/mxl301rf.h                    |    11 +-
 drivers/media/tuners/qm1d1b0004.c                  |   266 +
 drivers/media/tuners/qm1d1b0004.h                  |    24 +
 drivers/media/tuners/qm1d1c0042.c                  |    11 +-
 drivers/media/tuners/qm1d1c0042.h                  |    11 +-
 drivers/media/usb/cx231xx/Kconfig                  |     5 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |     1 +
 drivers/media/usb/cx231xx/cx231xx-cards.c          |     9 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |   382 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c        |     2 +-
 drivers/media/usb/cx231xx/cx231xx.h                |     3 -
 drivers/media/usb/dvb-usb-v2/dvbsky.c              |   425 +-
 drivers/media/usb/dvb-usb-v2/gl861.c               |    22 +-
 drivers/media/usb/dvb-usb-v2/usb_urb.c             |    17 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |     9 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c            |     4 +
 drivers/media/usb/dvb-usb/gp8psk.c                 |     2 +-
 drivers/media/usb/dvb-usb/usb-urb.c                |     6 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |    50 +-
 drivers/media/usb/em28xx/em28xx-core.c             |     5 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |     8 +-
 drivers/media/usb/em28xx/em28xx-v4l.h              |     2 +-
 drivers/media/usb/em28xx/em28xx.h                  |     1 +
 drivers/media/usb/go7007/go7007-fw.c               |     3 +
 drivers/media/usb/go7007/go7007-v4l2.c             |     2 +-
 drivers/media/usb/gspca/Kconfig                    |     1 +
 drivers/media/usb/gspca/gspca.c                    |   946 +-
 drivers/media/usb/gspca/gspca.h                    |    38 +-
 drivers/media/usb/gspca/jl2005bcd.c                |     2 +-
 drivers/media/usb/gspca/m5602/m5602_core.c         |     4 +-
 drivers/media/usb/gspca/ov534.c                    |     1 -
 drivers/media/usb/gspca/sq905.c                    |     2 +-
 drivers/media/usb/gspca/sq905c.c                   |     2 +-
 drivers/media/usb/gspca/topro.c                    |     1 -
 drivers/media/usb/gspca/vc032x.c                   |     2 +-
 drivers/media/usb/gspca/vicam.c                    |     2 +-
 drivers/media/usb/gspca/zc3xx.c                    |    58 +-
 drivers/media/usb/hackrf/hackrf.c                  |    11 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |     2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |     2 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c    |     1 -
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c        |     4 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |    83 +-
 drivers/media/usb/siano/smsusb.c                   |     2 +-
 drivers/media/usb/stk1160/stk1160-core.c           |     4 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   117 +-
 drivers/media/usb/usbtv/usbtv.h                    |     2 +-
 drivers/media/usb/usbvision/usbvision-core.c       |     2 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |    17 +-
 drivers/media/usb/uvc/uvc_driver.c                 |    11 +-
 drivers/media/usb/uvc/uvc_video.c                  |    24 +-
 drivers/media/v4l2-core/Kconfig                    |     6 -
 drivers/media/v4l2-core/Makefile                   |     1 -
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   807 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |    73 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |    28 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   286 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |    17 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c          |     6 +-
 drivers/media/v4l2-core/videobuf-dvb.c             |   398 -
 drivers/pnp/isapnp/Kconfig                         |     2 +-
 drivers/staging/media/Kconfig                      |     4 +-
 drivers/staging/media/Makefile                     |     2 +-
 drivers/staging/media/atomisp/Kconfig              |    12 -
 drivers/staging/media/atomisp/Makefile             |     6 -
 drivers/staging/media/atomisp/TODO                 |    74 -
 drivers/staging/media/atomisp/i2c/Kconfig          |    86 -
 drivers/staging/media/atomisp/i2c/Makefile         |    25 -
 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c |  1392 ---
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |  1122 --
 .../media/atomisp/i2c/atomisp-libmsrlisthelper.c   |   205 -
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c |   968 --
 .../staging/media/atomisp/i2c/atomisp-mt9m114.c    |  1917 ----
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c |  1470 ---
 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c |  1271 ---
 drivers/staging/media/atomisp/i2c/gc0310.h         |   404 -
 drivers/staging/media/atomisp/i2c/gc2235.h         |   670 --
 drivers/staging/media/atomisp/i2c/mt9m114.h        |  1777 ---
 drivers/staging/media/atomisp/i2c/ov2680.h         |   856 --
 drivers/staging/media/atomisp/i2c/ov2722.h         |  1262 ---
 drivers/staging/media/atomisp/i2c/ov5693/Kconfig   |    11 -
 drivers/staging/media/atomisp/i2c/ov5693/Makefile  |     9 -
 drivers/staging/media/atomisp/i2c/ov5693/ad5823.h  |    63 -
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      |  1993 ----
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h  |  1376 ---
 .../staging/media/atomisp/include/linux/atomisp.h  |  1359 ---
 .../atomisp/include/linux/atomisp_gmin_platform.h  |    36 -
 .../media/atomisp/include/linux/atomisp_platform.h |   249 -
 .../media/atomisp/include/linux/libmsrlisthelper.h |    28 -
 .../staging/media/atomisp/include/media/lm3554.h   |   131 -
 drivers/staging/media/atomisp/pci/Kconfig          |    14 -
 drivers/staging/media/atomisp/pci/Makefile         |     5 -
 .../staging/media/atomisp/pci/atomisp2/Makefile    |   349 -
 .../media/atomisp/pci/atomisp2/atomisp-regs.h      |   205 -
 .../media/atomisp/pci/atomisp2/atomisp_acc.c       |   604 -
 .../media/atomisp/pci/atomisp2/atomisp_acc.h       |   120 -
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       |  6696 -----------
 .../media/atomisp/pci/atomisp2/atomisp_cmd.h       |   446 -
 .../media/atomisp/pci/atomisp2/atomisp_common.h    |    75 -
 .../media/atomisp/pci/atomisp2/atomisp_compat.h    |   662 --
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |  4704 --------
 .../atomisp/pci/atomisp2/atomisp_compat_css20.h    |   277 -
 .../atomisp/pci/atomisp2/atomisp_compat_ioctl32.c  |  1259 ---
 .../atomisp/pci/atomisp2/atomisp_compat_ioctl32.h  |   365 -
 .../media/atomisp/pci/atomisp2/atomisp_csi2.c      |   442 -
 .../media/atomisp/pci/atomisp2/atomisp_csi2.h      |    57 -
 .../atomisp/pci/atomisp2/atomisp_dfs_tables.h      |   408 -
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.c     |   205 -
 .../media/atomisp/pci/atomisp2/atomisp_drvfs.h     |    24 -
 .../media/atomisp/pci/atomisp2/atomisp_file.c      |   225 -
 .../media/atomisp/pci/atomisp2/atomisp_file.h      |    43 -
 .../media/atomisp/pci/atomisp2/atomisp_fops.c      |  1304 ---
 .../media/atomisp/pci/atomisp2/atomisp_fops.h      |    50 -
 .../media/atomisp/pci/atomisp2/atomisp_helper.h    |    29 -
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |   310 -
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  3124 ------
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.h     |    69 -
 .../media/atomisp/pci/atomisp2/atomisp_subdev.c    |  1422 ---
 .../media/atomisp/pci/atomisp2/atomisp_subdev.h    |   467 -
 .../media/atomisp/pci/atomisp2/atomisp_tables.h    |   187 -
 .../media/atomisp/pci/atomisp2/atomisp_tpg.c       |   164 -
 .../media/atomisp/pci/atomisp2/atomisp_tpg.h       |    38 -
 .../atomisp/pci/atomisp2/atomisp_trace_event.h     |   129 -
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |  1573 ---
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.h      |    40 -
 .../media/atomisp/pci/atomisp2/css2400/Makefile    |     2 -
 .../base/circbuf/interface/ia_css_circbuf.h        |   376 -
 .../base/circbuf/interface/ia_css_circbuf_comm.h   |    56 -
 .../base/circbuf/interface/ia_css_circbuf_desc.h   |   169 -
 .../atomisp2/css2400/base/circbuf/src/circbuf.c    |   321 -
 .../base/refcount/interface/ia_css_refcount.h      |    83 -
 .../atomisp2/css2400/base/refcount/src/refcount.c  |   281 -
 .../camera/pipe/interface/ia_css_pipe_binarydesc.h |   297 -
 .../camera/pipe/interface/ia_css_pipe_stagedesc.h  |    52 -
 .../camera/pipe/interface/ia_css_pipe_util.h       |    39 -
 .../css2400/camera/pipe/src/pipe_binarydesc.c      |   880 --
 .../css2400/camera/pipe/src/pipe_stagedesc.c       |   115 -
 .../atomisp2/css2400/camera/pipe/src/pipe_util.c   |    51 -
 .../css2400/camera/util/interface/ia_css_util.h    |   141 -
 .../pci/atomisp2/css2400/camera/util/src/util.c    |   227 -
 .../ia_css_isp_configs.c                           |   360 -
 .../ia_css_isp_configs.h                           |   189 -
 .../ia_css_isp_params.c                            |  3221 ------
 .../ia_css_isp_params.h                            |   399 -
 .../ia_css_isp_states.c                            |   214 -
 .../ia_css_isp_states.h                            |    72 -
 .../atomisp2/css2400/css_2400_system/hrt/bits.h    |   104 -
 .../css2400/css_2400_system/hrt/cell_params.h      |    42 -
 .../hrt/css_receiver_2400_common_defs.h            |   200 -
 .../css_2400_system/hrt/css_receiver_2400_defs.h   |   258 -
 .../atomisp2/css2400/css_2400_system/hrt/defs.h    |    36 -
 .../css2400/css_2400_system/hrt/dma_v2_defs.h      |   199 -
 .../css2400/css_2400_system/hrt/gdc_v2_defs.h      |   170 -
 .../css2400/css_2400_system/hrt/gp_timer_defs.h    |    36 -
 .../css2400/css_2400_system/hrt/gpio_block_defs.h  |    42 -
 .../css_2400_system/hrt/hive_isp_css_defs.h        |   416 -
 .../hrt/hive_isp_css_host_ids_hrt.h                |    84 -
 .../hrt/hive_isp_css_irq_types_hrt.h               |    72 -
 .../hrt/hive_isp_css_streaming_to_mipi_types_hrt.h |    26 -
 .../css2400/css_2400_system/hrt/hive_types.h       |   128 -
 .../atomisp2/css2400/css_2400_system/hrt/if_defs.h |    22 -
 .../hrt/input_formatter_subsystem_defs.h           |    53 -
 .../css_2400_system/hrt/input_selector_defs.h      |    89 -
 .../css_2400_system/hrt/input_switch_2400_defs.h   |    30 -
 .../css_2400_system/hrt/input_system_ctrl_defs.h   |   254 -
 .../css_2400_system/hrt/input_system_defs.h        |   126 -
 .../css_2400_system/hrt/irq_controller_defs.h      |    28 -
 .../css_2400_system/hrt/isp2400_mamoiada_params.h  |   254 -
 .../css2400/css_2400_system/hrt/isp2400_support.h  |    38 -
 .../css_2400_system/hrt/isp_acquisition_defs.h     |   234 -
 .../css2400/css_2400_system/hrt/isp_capture_defs.h |   310 -
 .../css2400/css_2400_system/hrt/mmu_defs.h         |    23 -
 .../hrt/scalar_processor_2400_params.h             |    20 -
 .../css2400/css_2400_system/hrt/str2mem_defs.h     |    39 -
 .../css_2400_system/hrt/streaming_to_mipi_defs.h   |    28 -
 .../css_2400_system/hrt/timed_controller_defs.h    |    22 -
 .../pci/atomisp2/css2400/css_2400_system/hrt/var.h |    74 -
 .../atomisp2/css2400/css_2400_system/hrt/version.h |    20 -
 .../atomisp2/css2400/css_2400_system/spmem_dump.c  |  3634 ------
 .../css2400/css_2401_csi2p_system/csi_rx_global.h  |    63 -
 .../ia_css_isp_configs.c                           |   360 -
 .../ia_css_isp_configs.h                           |   189 -
 .../ia_css_isp_params.c                            |  3220 ------
 .../ia_css_isp_params.h                            |   399 -
 .../ia_css_isp_states.c                            |   214 -
 .../ia_css_isp_states.h                            |    72 -
 .../css2400/css_2401_csi2p_system/host/csi_rx.c    |    41 -
 .../css_2401_csi2p_system/host/csi_rx_local.h      |    61 -
 .../css_2401_csi2p_system/host/csi_rx_private.h    |   282 -
 .../css2400/css_2401_csi2p_system/host/ibuf_ctrl.c |    22 -
 .../css_2401_csi2p_system/host/ibuf_ctrl_local.h   |    58 -
 .../css_2401_csi2p_system/host/ibuf_ctrl_private.h |   233 -
 .../host/input_system_local.h                      |   106 -
 .../host/input_system_private.h                    |   128 -
 .../css2400/css_2401_csi2p_system/host/isys_dma.c  |    40 -
 .../css_2401_csi2p_system/host/isys_dma_local.h    |    20 -
 .../css_2401_csi2p_system/host/isys_dma_private.h  |    60 -
 .../css2400/css_2401_csi2p_system/host/isys_irq.c  |    39 -
 .../css_2401_csi2p_system/host/isys_irq_local.h    |    35 -
 .../css_2401_csi2p_system/host/isys_irq_private.h  |   108 -
 .../css_2401_csi2p_system/host/isys_stream2mmio.c  |    21 -
 .../host/isys_stream2mmio_local.h                  |    36 -
 .../host/isys_stream2mmio_private.h                |   168 -
 .../css_2401_csi2p_system/host/pixelgen_local.h    |    50 -
 .../css_2401_csi2p_system/host/pixelgen_private.h  |   164 -
 .../css_2401_csi2p_system/host/system_local.h      |   381 -
 .../hrt/PixelGen_SysBlock_defs.h                   |   126 -
 .../css2400/css_2401_csi2p_system/hrt/bits.h       |   104 -
 .../css_2401_csi2p_system/hrt/cell_params.h        |    42 -
 .../hrt/css_receiver_2400_common_defs.h            |   200 -
 .../hrt/css_receiver_2400_defs.h                   |   258 -
 .../css2400/css_2401_csi2p_system/hrt/defs.h       |    36 -
 .../css_2401_csi2p_system/hrt/dma_v2_defs.h        |   199 -
 .../css_2401_csi2p_system/hrt/gdc_v2_defs.h        |   170 -
 .../css_2401_csi2p_system/hrt/gp_timer_defs.h      |    36 -
 .../css_2401_csi2p_system/hrt/gpio_block_defs.h    |    42 -
 .../hrt/hive_isp_css_2401_irq_types_hrt.h          |    68 -
 .../css_2401_csi2p_system/hrt/hive_isp_css_defs.h  |   435 -
 .../hrt/hive_isp_css_host_ids_hrt.h                |   119 -
 .../hrt/hive_isp_css_streaming_to_mipi_types_hrt.h |    26 -
 .../css2400/css_2401_csi2p_system/hrt/hive_types.h |   128 -
 .../css_2401_csi2p_system/hrt/ibuf_cntrl_defs.h    |   138 -
 .../css2400/css_2401_csi2p_system/hrt/if_defs.h    |    22 -
 .../hrt/input_formatter_subsystem_defs.h           |    53 -
 .../hrt/input_selector_defs.h                      |    89 -
 .../hrt/input_switch_2400_defs.h                   |    30 -
 .../hrt/input_system_ctrl_defs.h                   |   254 -
 .../css_2401_csi2p_system/hrt/input_system_defs.h  |   126 -
 .../hrt/irq_controller_defs.h                      |    28 -
 .../css_2401_csi2p_system/hrt/isp2400_support.h    |    38 -
 .../hrt/isp2401_mamoiada_params.h                  |   258 -
 .../hrt/isp_acquisition_defs.h                     |   234 -
 .../css_2401_csi2p_system/hrt/isp_capture_defs.h   |   310 -
 .../hrt/mipi_backend_common_defs.h                 |   210 -
 .../css_2401_csi2p_system/hrt/mipi_backend_defs.h  |   215 -
 .../css2400/css_2401_csi2p_system/hrt/mmu_defs.h   |    23 -
 .../css_2401_csi2p_system/hrt/rx_csi_defs.h        |   175 -
 .../hrt/scalar_processor_2400_params.h             |    20 -
 .../css_2401_csi2p_system/hrt/str2mem_defs.h       |    39 -
 .../css_2401_csi2p_system/hrt/stream2mmio_defs.h   |    71 -
 .../hrt/streaming_to_mipi_defs.h                   |    28 -
 .../hrt/timed_controller_defs.h                    |    22 -
 .../css2400/css_2401_csi2p_system/hrt/var.h        |    99 -
 .../css2400/css_2401_csi2p_system/hrt/version.h    |    20 -
 .../css_2401_csi2p_system/ibuf_ctrl_global.h       |    80 -
 .../css_2401_csi2p_system/input_system_global.h    |   206 -
 .../css_2401_csi2p_system/isys_dma_global.h        |    87 -
 .../css_2401_csi2p_system/isys_irq_global.h        |    35 -
 .../isys_stream2mmio_global.h                      |    39 -
 .../css_2401_csi2p_system/pixelgen_global.h        |    91 -
 .../css2400/css_2401_csi2p_system/spmem_dump.c     |  3686 ------
 .../css2400/css_2401_csi2p_system/system_global.h  |   458 -
 .../ia_css_isp_configs.c                           |   360 -
 .../ia_css_isp_configs.h                           |   189 -
 .../ia_css_isp_params.c                            |  3220 ------
 .../ia_css_isp_params.h                            |   399 -
 .../ia_css_isp_states.c                            |   214 -
 .../ia_css_isp_states.h                            |    72 -
 .../atomisp2/css2400/css_2401_system/hrt/bits.h    |   104 -
 .../css2400/css_2401_system/hrt/cell_params.h      |    42 -
 .../hrt/css_receiver_2400_common_defs.h            |   200 -
 .../css_2401_system/hrt/css_receiver_2400_defs.h   |   258 -
 .../atomisp2/css2400/css_2401_system/hrt/defs.h    |    36 -
 .../css2400/css_2401_system/hrt/dma_v2_defs.h      |   199 -
 .../css2400/css_2401_system/hrt/gdc_v2_defs.h      |   170 -
 .../css2400/css_2401_system/hrt/gp_timer_defs.h    |    36 -
 .../css2400/css_2401_system/hrt/gpio_block_defs.h  |    42 -
 .../hrt/hive_isp_css_2401_irq_types_hrt.h          |    69 -
 .../css_2401_system/hrt/hive_isp_css_defs.h        |   435 -
 .../hrt/hive_isp_css_host_ids_hrt.h                |   119 -
 .../hrt/hive_isp_css_streaming_to_mipi_types_hrt.h |    26 -
 .../css2400/css_2401_system/hrt/hive_types.h       |   128 -
 .../atomisp2/css2400/css_2401_system/hrt/if_defs.h |    22 -
 .../hrt/input_formatter_subsystem_defs.h           |    53 -
 .../css_2401_system/hrt/input_selector_defs.h      |    89 -
 .../css_2401_system/hrt/input_switch_2400_defs.h   |    30 -
 .../css_2401_system/hrt/input_system_ctrl_defs.h   |   254 -
 .../css_2401_system/hrt/input_system_defs.h        |   126 -
 .../css_2401_system/hrt/irq_controller_defs.h      |    28 -
 .../css2400/css_2401_system/hrt/isp2400_support.h  |    38 -
 .../css_2401_system/hrt/isp2401_mamoiada_params.h  |   258 -
 .../css_2401_system/hrt/isp_acquisition_defs.h     |   234 -
 .../css2400/css_2401_system/hrt/isp_capture_defs.h |   310 -
 .../css2400/css_2401_system/hrt/mmu_defs.h         |    23 -
 .../hrt/scalar_processor_2400_params.h             |    20 -
 .../css2400/css_2401_system/hrt/str2mem_defs.h     |    39 -
 .../css_2401_system/hrt/streaming_to_mipi_defs.h   |    28 -
 .../css_2401_system/hrt/timed_controller_defs.h    |    22 -
 .../pci/atomisp2/css2400/css_2401_system/hrt/var.h |    99 -
 .../atomisp2/css2400/css_2401_system/hrt/version.h |    20 -
 .../atomisp2/css2400/css_2401_system/spmem_dump.c  |  3634 ------
 .../media/atomisp/pci/atomisp2/css2400/css_trace.h |   388 -
 .../css2400/hive_isp_css_common/debug_global.h     |    83 -
 .../css2400/hive_isp_css_common/dma_global.h       |   255 -
 .../hive_isp_css_common/event_fifo_global.h        |    20 -
 .../hive_isp_css_common/fifo_monitor_global.h      |    32 -
 .../css2400/hive_isp_css_common/gdc_global.h       |    90 -
 .../css2400/hive_isp_css_common/gp_device_global.h |    85 -
 .../css2400/hive_isp_css_common/gp_timer_global.h  |    33 -
 .../css2400/hive_isp_css_common/gpio_global.h      |    45 -
 .../css2400/hive_isp_css_common/hmem_global.h      |    45 -
 .../css2400/hive_isp_css_common/host/debug.c       |    72 -
 .../css2400/hive_isp_css_common/host/debug_local.h |    21 -
 .../hive_isp_css_common/host/debug_private.h       |    99 -
 .../css2400/hive_isp_css_common/host/dma.c         |   299 -
 .../css2400/hive_isp_css_common/host/dma_local.h   |   207 -
 .../css2400/hive_isp_css_common/host/dma_private.h |    41 -
 .../css2400/hive_isp_css_common/host/event_fifo.c  |    19 -
 .../hive_isp_css_common/host/event_fifo_local.h    |    57 -
 .../hive_isp_css_common/host/event_fifo_private.h  |    75 -
 .../hive_isp_css_common/host/fifo_monitor.c        |   567 -
 .../hive_isp_css_common/host/fifo_monitor_local.h  |    99 -
 .../host/fifo_monitor_private.h                    |    79 -
 .../css2400/hive_isp_css_common/host/gdc.c         |   127 -
 .../css2400/hive_isp_css_common/host/gdc_local.h   |    20 -
 .../css2400/hive_isp_css_common/host/gdc_private.h |    20 -
 .../css2400/hive_isp_css_common/host/gp_device.c   |   108 -
 .../hive_isp_css_common/host/gp_device_local.h     |   143 -
 .../hive_isp_css_common/host/gp_device_private.h   |    46 -
 .../css2400/hive_isp_css_common/host/gp_timer.c    |    70 -
 .../hive_isp_css_common/host/gp_timer_local.h      |    45 -
 .../hive_isp_css_common/host/gp_timer_private.h    |    22 -
 .../css2400/hive_isp_css_common/host/gpio_local.h  |    20 -
 .../hive_isp_css_common/host/gpio_private.h        |    44 -
 .../css2400/hive_isp_css_common/host/hmem.c        |    19 -
 .../css2400/hive_isp_css_common/host/hmem_local.h  |    20 -
 .../hive_isp_css_common/host/hmem_private.h        |    30 -
 .../hive_isp_css_common/host/input_formatter.c     |   228 -
 .../host/input_formatter_local.h                   |   120 -
 .../host/input_formatter_private.h                 |    46 -
 .../hive_isp_css_common/host/input_system.c        |  1823 ---
 .../hive_isp_css_common/host/input_system_local.h  |   533 -
 .../host/input_system_private.h                    |   116 -
 .../css2400/hive_isp_css_common/host/irq.c         |   448 -
 .../css2400/hive_isp_css_common/host/irq_local.h   |   136 -
 .../css2400/hive_isp_css_common/host/irq_private.h |    44 -
 .../css2400/hive_isp_css_common/host/isp.c         |   129 -
 .../css2400/hive_isp_css_common/host/isp_local.h   |    57 -
 .../css2400/hive_isp_css_common/host/isp_private.h |   157 -
 .../css2400/hive_isp_css_common/host/mmu.c         |    50 -
 .../css2400/hive_isp_css_common/host/mmu_local.h   |    20 -
 .../css2400/hive_isp_css_common/host/mmu_private.h |    44 -
 .../atomisp2/css2400/hive_isp_css_common/host/sp.c |    81 -
 .../css2400/hive_isp_css_common/host/sp_local.h    |   101 -
 .../css2400/hive_isp_css_common/host/sp_private.h  |   163 -
 .../hive_isp_css_common/host/system_local.h        |   306 -
 .../css2400/hive_isp_css_common/host/timed_ctrl.c  |    74 -
 .../hive_isp_css_common/host/timed_ctrl_local.h    |    20 -
 .../hive_isp_css_common/host/timed_ctrl_private.h  |    34 -
 .../css2400/hive_isp_css_common/host/vamem_local.h |    20 -
 .../hive_isp_css_common/host/vamem_private.h       |    37 -
 .../css2400/hive_isp_css_common/host/vmem.c        |   258 -
 .../css2400/hive_isp_css_common/host/vmem_local.h  |    55 -
 .../hive_isp_css_common/host/vmem_private.h        |    20 -
 .../hive_isp_css_common/input_formatter_global.h   |   114 -
 .../hive_isp_css_common/input_system_global.h      |   155 -
 .../css2400/hive_isp_css_common/irq_global.h       |    45 -
 .../css2400/hive_isp_css_common/isp_global.h       |   115 -
 .../css2400/hive_isp_css_common/mmu_global.h       |    22 -
 .../css2400/hive_isp_css_common/sp_global.h        |    93 -
 .../css2400/hive_isp_css_common/system_global.h    |   348 -
 .../hive_isp_css_common/timed_ctrl_global.h        |    56 -
 .../css2400/hive_isp_css_common/vamem_global.h     |    34 -
 .../css2400/hive_isp_css_common/vmem_global.h      |    28 -
 .../css2400/hive_isp_css_include/assert_support.h  |   102 -
 .../css2400/hive_isp_css_include/bitop_support.h   |    25 -
 .../atomisp2/css2400/hive_isp_css_include/csi_rx.h |    43 -
 .../atomisp2/css2400/hive_isp_css_include/debug.h  |    47 -
 .../device_access/device_access.h                  |   194 -
 .../atomisp2/css2400/hive_isp_css_include/dma.h    |    47 -
 .../css2400/hive_isp_css_include/error_support.h   |    70 -
 .../css2400/hive_isp_css_include/event_fifo.h      |    46 -
 .../css2400/hive_isp_css_include/fifo_monitor.h    |    46 -
 .../css2400/hive_isp_css_include/gdc_device.h      |    48 -
 .../css2400/hive_isp_css_include/gp_device.h       |    46 -
 .../css2400/hive_isp_css_include/gp_timer.h        |    46 -
 .../atomisp2/css2400/hive_isp_css_include/gpio.h   |    46 -
 .../atomisp2/css2400/hive_isp_css_include/hmem.h   |    46 -
 .../hive_isp_css_include/host/csi_rx_public.h      |   135 -
 .../hive_isp_css_include/host/debug_public.h       |    99 -
 .../css2400/hive_isp_css_include/host/dma_public.h |    73 -
 .../hive_isp_css_include/host/event_fifo_public.h  |    79 -
 .../host/fifo_monitor_public.h                     |   110 -
 .../css2400/hive_isp_css_include/host/gdc_public.h |    59 -
 .../hive_isp_css_include/host/gp_device_public.h   |    58 -
 .../hive_isp_css_include/host/gp_timer_public.h    |    34 -
 .../hive_isp_css_include/host/gpio_public.h        |    45 -
 .../hive_isp_css_include/host/hmem_public.h        |    32 -
 .../hive_isp_css_include/host/ibuf_ctrl_public.h   |    93 -
 .../host/input_formatter_public.h                  |   115 -
 .../host/input_system_public.h                     |   376 -
 .../css2400/hive_isp_css_include/host/irq_public.h |   184 -
 .../css2400/hive_isp_css_include/host/isp_public.h |   186 -
 .../hive_isp_css_include/host/isys_dma_public.h    |    38 -
 .../hive_isp_css_include/host/isys_irq_public.h    |    45 -
 .../hive_isp_css_include/host/isys_public.h        |    37 -
 .../host/isys_stream2mmio_public.h                 |   101 -
 .../css2400/hive_isp_css_include/host/mmu_public.h |    82 -
 .../hive_isp_css_include/host/pixelgen_public.h    |    79 -
 .../css2400/hive_isp_css_include/host/sp_public.h  |   223 -
 .../css2400/hive_isp_css_include/host/tag_public.h |    41 -
 .../hive_isp_css_include/host/timed_ctrl_public.h  |    59 -
 .../hive_isp_css_include/host/vamem_public.h       |    20 -
 .../hive_isp_css_include/host/vmem_public.h        |    20 -
 .../css2400/hive_isp_css_include/ibuf_ctrl.h       |    48 -
 .../css2400/hive_isp_css_include/input_formatter.h |    46 -
 .../css2400/hive_isp_css_include/input_system.h    |    46 -
 .../atomisp2/css2400/hive_isp_css_include/irq.h    |    46 -
 .../atomisp2/css2400/hive_isp_css_include/isp.h    |    46 -
 .../css2400/hive_isp_css_include/isys_dma.h        |    48 -
 .../css2400/hive_isp_css_include/isys_irq.h        |    39 -
 .../hive_isp_css_include/isys_stream2mmio.h        |    48 -
 .../css2400/hive_isp_css_include/math_support.h    |   223 -
 .../memory_access/memory_access.h                  |   174 -
 .../css2400/hive_isp_css_include/memory_realloc.h  |    38 -
 .../css2400/hive_isp_css_include/misc_support.h    |    26 -
 .../css2400/hive_isp_css_include/mmu_device.h      |    48 -
 .../css2400/hive_isp_css_include/pixelgen.h        |    48 -
 .../hive_isp_css_include/platform_support.h        |    41 -
 .../css2400/hive_isp_css_include/print_support.h   |    44 -
 .../atomisp2/css2400/hive_isp_css_include/queue.h  |    46 -
 .../css2400/hive_isp_css_include/resource.h        |    47 -
 .../atomisp2/css2400/hive_isp_css_include/socket.h |    47 -
 .../pci/atomisp2/css2400/hive_isp_css_include/sp.h |    46 -
 .../css2400/hive_isp_css_include/string_support.h  |   165 -
 .../css2400/hive_isp_css_include/system_types.h    |    25 -
 .../atomisp2/css2400/hive_isp_css_include/tag.h    |    45 -
 .../css2400/hive_isp_css_include/timed_ctrl.h      |    46 -
 .../css2400/hive_isp_css_include/type_support.h    |    40 -
 .../atomisp2/css2400/hive_isp_css_include/vamem.h  |    46 -
 .../atomisp2/css2400/hive_isp_css_include/vmem.h   |    46 -
 .../css2400/hive_isp_css_shared/host/queue_local.h |    20 -
 .../hive_isp_css_shared/host/queue_private.h       |    18 -
 .../css2400/hive_isp_css_shared/host/tag.c         |    95 -
 .../css2400/hive_isp_css_shared/host/tag_local.h   |    22 -
 .../css2400/hive_isp_css_shared/host/tag_private.h |    18 -
 .../css2400/hive_isp_css_shared/queue_global.h     |    19 -
 .../css2400/hive_isp_css_shared/sw_event_global.h  |    36 -
 .../css2400/hive_isp_css_shared/tag_global.h       |    56 -
 .../media/atomisp/pci/atomisp2/css2400/ia_css.h    |    57 -
 .../media/atomisp/pci/atomisp2/css2400/ia_css_3a.h |   188 -
 .../pci/atomisp2/css2400/ia_css_acc_types.h        |   468 -
 .../atomisp/pci/atomisp2/css2400/ia_css_buffer.h   |    84 -
 .../atomisp/pci/atomisp2/css2400/ia_css_control.h  |   157 -
 .../pci/atomisp2/css2400/ia_css_device_access.c    |    95 -
 .../pci/atomisp2/css2400/ia_css_device_access.h    |    59 -
 .../atomisp/pci/atomisp2/css2400/ia_css_dvs.h      |   299 -
 .../atomisp/pci/atomisp2/css2400/ia_css_env.h      |    94 -
 .../atomisp/pci/atomisp2/css2400/ia_css_err.h      |    63 -
 .../pci/atomisp2/css2400/ia_css_event_public.h     |   196 -
 .../atomisp/pci/atomisp2/css2400/ia_css_firmware.h |    74 -
 .../atomisp/pci/atomisp2/css2400/ia_css_frac.h     |    37 -
 .../pci/atomisp2/css2400/ia_css_frame_format.h     |   101 -
 .../pci/atomisp2/css2400/ia_css_frame_public.h     |   352 -
 .../pci/atomisp2/css2400/ia_css_host_data.h        |    46 -
 .../pci/atomisp2/css2400/ia_css_input_port.h       |    60 -
 .../atomisp/pci/atomisp2/css2400/ia_css_irq.h      |   235 -
 .../pci/atomisp2/css2400/ia_css_memory_access.c    |    83 -
 .../atomisp/pci/atomisp2/css2400/ia_css_metadata.h |    71 -
 .../atomisp/pci/atomisp2/css2400/ia_css_mipi.h     |    82 -
 .../atomisp/pci/atomisp2/css2400/ia_css_mmu.h      |    32 -
 .../pci/atomisp2/css2400/ia_css_mmu_private.h      |    29 -
 .../atomisp/pci/atomisp2/css2400/ia_css_morph.h    |    39 -
 .../atomisp/pci/atomisp2/css2400/ia_css_pipe.h     |   195 -
 .../pci/atomisp2/css2400/ia_css_pipe_public.h      |   579 -
 .../atomisp/pci/atomisp2/css2400/ia_css_prbs.h     |    53 -
 .../pci/atomisp2/css2400/ia_css_properties.h       |    41 -
 .../atomisp/pci/atomisp2/css2400/ia_css_shading.h  |    40 -
 .../atomisp/pci/atomisp2/css2400/ia_css_stream.h   |   110 -
 .../pci/atomisp2/css2400/ia_css_stream_format.h    |    29 -
 .../pci/atomisp2/css2400/ia_css_stream_public.h    |   582 -
 .../atomisp/pci/atomisp2/css2400/ia_css_timer.h    |    84 -
 .../atomisp/pci/atomisp2/css2400/ia_css_tpg.h      |    78 -
 .../atomisp/pci/atomisp2/css2400/ia_css_types.h    |   616 -
 .../atomisp/pci/atomisp2/css2400/ia_css_version.h  |    40 -
 .../pci/atomisp2/css2400/ia_css_version_data.h     |    33 -
 .../css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.c  |    32 -
 .../css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.h  |    27 -
 .../css2400/isp/kernels/aa/aa_2/ia_css_aa2_param.h |    24 -
 .../css2400/isp/kernels/aa/aa_2/ia_css_aa2_types.h |    48 -
 .../isp/kernels/anr/anr_1.0/ia_css_anr.host.c      |    60 -
 .../isp/kernels/anr/anr_1.0/ia_css_anr.host.h      |    39 -
 .../isp/kernels/anr/anr_1.0/ia_css_anr_param.h     |    25 -
 .../isp/kernels/anr/anr_1.0/ia_css_anr_types.h     |    36 -
 .../isp/kernels/anr/anr_2/ia_css_anr2.host.c       |    46 -
 .../isp/kernels/anr/anr_2/ia_css_anr2.host.h       |    35 -
 .../isp/kernels/anr/anr_2/ia_css_anr2_table.host.c |    52 -
 .../isp/kernels/anr/anr_2/ia_css_anr2_table.host.h |    22 -
 .../isp/kernels/anr/anr_2/ia_css_anr2_types.h      |    32 -
 .../isp/kernels/anr/anr_2/ia_css_anr_param.h       |    27 -
 .../css2400/isp/kernels/bh/bh_2/ia_css_bh.host.c   |    66 -
 .../css2400/isp/kernels/bh/bh_2/ia_css_bh.host.h   |    32 -
 .../css2400/isp/kernels/bh/bh_2/ia_css_bh_param.h  |    40 -
 .../css2400/isp/kernels/bh/bh_2/ia_css_bh_types.h  |    37 -
 .../css2400/isp/kernels/bnlm/ia_css_bnlm.host.c    |   183 -
 .../css2400/isp/kernels/bnlm/ia_css_bnlm.host.h    |    40 -
 .../css2400/isp/kernels/bnlm/ia_css_bnlm_param.h   |    63 -
 .../css2400/isp/kernels/bnlm/ia_css_bnlm_types.h   |   106 -
 .../isp/kernels/bnr/bnr2_2/ia_css_bnr2_2.host.c    |   122 -
 .../isp/kernels/bnr/bnr2_2/ia_css_bnr2_2.host.h    |    35 -
 .../isp/kernels/bnr/bnr2_2/ia_css_bnr2_2_param.h   |    47 -
 .../isp/kernels/bnr/bnr2_2/ia_css_bnr2_2_types.h   |    71 -
 .../isp/kernels/bnr/bnr_1.0/ia_css_bnr.host.c      |    64 -
 .../isp/kernels/bnr/bnr_1.0/ia_css_bnr.host.h      |    34 -
 .../isp/kernels/bnr/bnr_1.0/ia_css_bnr_param.h     |    30 -
 .../isp/kernels/cnr/cnr_1.0/ia_css_cnr.host.c      |    28 -
 .../isp/kernels/cnr/cnr_1.0/ia_css_cnr.host.h      |    25 -
 .../isp/kernels/cnr/cnr_1.0/ia_css_cnr_param.h     |    24 -
 .../isp/kernels/cnr/cnr_2/ia_css_cnr2.host.c       |    76 -
 .../isp/kernels/cnr/cnr_2/ia_css_cnr2.host.h       |    43 -
 .../isp/kernels/cnr/cnr_2/ia_css_cnr2_param.h      |    32 -
 .../isp/kernels/cnr/cnr_2/ia_css_cnr2_types.h      |    55 -
 .../isp/kernels/cnr/cnr_2/ia_css_cnr_param.h       |    20 -
 .../conversion_1.0/ia_css_conversion.host.c        |    36 -
 .../conversion_1.0/ia_css_conversion.host.h        |    33 -
 .../conversion_1.0/ia_css_conversion_param.h       |    28 -
 .../conversion_1.0/ia_css_conversion_types.h       |    32 -
 .../copy_output_1.0/ia_css_copy_output.host.c      |    47 -
 .../copy_output_1.0/ia_css_copy_output.host.h      |    34 -
 .../copy_output_1.0/ia_css_copy_output_param.h     |    26 -
 .../isp/kernels/crop/crop_1.0/ia_css_crop.host.c   |    64 -
 .../isp/kernels/crop/crop_1.0/ia_css_crop.host.h   |    41 -
 .../isp/kernels/crop/crop_1.0/ia_css_crop_param.h  |    32 -
 .../isp/kernels/crop/crop_1.0/ia_css_crop_types.h  |    35 -
 .../isp/kernels/csc/csc_1.0/ia_css_csc.host.c      |   132 -
 .../isp/kernels/csc/csc_1.0/ia_css_csc.host.h      |    54 -
 .../isp/kernels/csc/csc_1.0/ia_css_csc_param.h     |    34 -
 .../isp/kernels/csc/csc_1.0/ia_css_csc_types.h     |    78 -
 .../isp/kernels/ctc/ctc1_5/ia_css_ctc1_5.host.c    |   120 -
 .../isp/kernels/ctc/ctc1_5/ia_css_ctc1_5.host.h    |    33 -
 .../isp/kernels/ctc/ctc1_5/ia_css_ctc1_5_param.h   |    46 -
 .../isp/kernels/ctc/ctc1_5/ia_css_ctc_param.h      |    20 -
 .../isp/kernels/ctc/ctc2/ia_css_ctc2.host.c        |   156 -
 .../isp/kernels/ctc/ctc2/ia_css_ctc2.host.h        |    33 -
 .../isp/kernels/ctc/ctc2/ia_css_ctc2_param.h       |    49 -
 .../isp/kernels/ctc/ctc2/ia_css_ctc2_types.h       |    55 -
 .../isp/kernels/ctc/ctc_1.0/ia_css_ctc.host.c      |    63 -
 .../isp/kernels/ctc/ctc_1.0/ia_css_ctc.host.h      |    36 -
 .../isp/kernels/ctc/ctc_1.0/ia_css_ctc_param.h     |    44 -
 .../kernels/ctc/ctc_1.0/ia_css_ctc_table.host.c    |   215 -
 .../kernels/ctc/ctc_1.0/ia_css_ctc_table.host.h    |    24 -
 .../isp/kernels/ctc/ctc_1.0/ia_css_ctc_types.h     |   110 -
 .../css2400/isp/kernels/de/de_1.0/ia_css_de.host.c |    79 -
 .../css2400/isp/kernels/de/de_1.0/ia_css_de.host.h |    44 -
 .../isp/kernels/de/de_1.0/ia_css_de_param.h        |    27 -
 .../isp/kernels/de/de_1.0/ia_css_de_state.h        |    26 -
 .../isp/kernels/de/de_1.0/ia_css_de_types.h        |    43 -
 .../css2400/isp/kernels/de/de_2/ia_css_de2.host.c  |    54 -
 .../css2400/isp/kernels/de/de_2/ia_css_de2.host.h  |    38 -
 .../css2400/isp/kernels/de/de_2/ia_css_de2_param.h |    30 -
 .../css2400/isp/kernels/de/de_2/ia_css_de2_types.h |    42 -
 .../css2400/isp/kernels/de/de_2/ia_css_de_param.h  |    20 -
 .../css2400/isp/kernels/de/de_2/ia_css_de_state.h  |    21 -
 .../css2400/isp/kernels/dp/dp_1.0/ia_css_dp.host.c |   132 -
 .../css2400/isp/kernels/dp/dp_1.0/ia_css_dp.host.h |    47 -
 .../isp/kernels/dp/dp_1.0/ia_css_dp_param.h        |    36 -
 .../isp/kernels/dp/dp_1.0/ia_css_dp_types.h        |    50 -
 .../css2400/isp/kernels/dpc2/ia_css_dpc2.host.c    |    65 -
 .../css2400/isp/kernels/dpc2/ia_css_dpc2.host.h    |    39 -
 .../css2400/isp/kernels/dpc2/ia_css_dpc2_param.h   |    53 -
 .../css2400/isp/kernels/dpc2/ia_css_dpc2_types.h   |    59 -
 .../isp/kernels/dvs/dvs_1.0/ia_css_dvs.host.c      |   306 -
 .../isp/kernels/dvs/dvs_1.0/ia_css_dvs.host.h      |    60 -
 .../isp/kernels/dvs/dvs_1.0/ia_css_dvs_param.h     |    39 -
 .../isp/kernels/dvs/dvs_1.0/ia_css_dvs_types.h     |    30 -
 .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        |   321 -
 .../isp/kernels/eed1_8/ia_css_eed1_8.host.h        |    45 -
 .../isp/kernels/eed1_8/ia_css_eed1_8_param.h       |   154 -
 .../isp/kernels/eed1_8/ia_css_eed1_8_types.h       |    86 -
 .../isp/kernels/fc/fc_1.0/ia_css_formats.host.c    |    62 -
 .../isp/kernels/fc/fc_1.0/ia_css_formats.host.h    |    45 -
 .../isp/kernels/fc/fc_1.0/ia_css_formats_param.h   |    25 -
 .../isp/kernels/fc/fc_1.0/ia_css_formats_types.h   |    38 -
 .../fixedbds/fixedbds_1.0/ia_css_fixedbds_param.h  |    33 -
 .../fixedbds/fixedbds_1.0/ia_css_fixedbds_types.h  |    26 -
 .../isp/kernels/fpn/fpn_1.0/ia_css_fpn.host.c      |    89 -
 .../isp/kernels/fpn/fpn_1.0/ia_css_fpn.host.h      |    44 -
 .../isp/kernels/fpn/fpn_1.0/ia_css_fpn_param.h     |    35 -
 .../isp/kernels/fpn/fpn_1.0/ia_css_fpn_types.h     |    52 -
 .../css2400/isp/kernels/gc/gc_1.0/ia_css_gc.host.c |   118 -
 .../css2400/isp/kernels/gc/gc_1.0/ia_css_gc.host.h |    65 -
 .../isp/kernels/gc/gc_1.0/ia_css_gc_param.h        |    61 -
 .../isp/kernels/gc/gc_1.0/ia_css_gc_table.host.c   |   214 -
 .../isp/kernels/gc/gc_1.0/ia_css_gc_table.host.h   |    24 -
 .../isp/kernels/gc/gc_1.0/ia_css_gc_types.h        |    97 -
 .../css2400/isp/kernels/gc/gc_2/ia_css_gc2.host.c  |   110 -
 .../css2400/isp/kernels/gc/gc_2/ia_css_gc2.host.h  |    79 -
 .../css2400/isp/kernels/gc/gc_2/ia_css_gc2_param.h |    43 -
 .../isp/kernels/gc/gc_2/ia_css_gc2_table.host.c    |   132 -
 .../isp/kernels/gc/gc_2/ia_css_gc2_table.host.h    |    26 -
 .../css2400/isp/kernels/gc/gc_2/ia_css_gc2_types.h |    54 -
 .../css2400/isp/kernels/hdr/ia_css_hdr.host.c      |    41 -
 .../css2400/isp/kernels/hdr/ia_css_hdr.host.h      |    31 -
 .../css2400/isp/kernels/hdr/ia_css_hdr_param.h     |    53 -
 .../css2400/isp/kernels/hdr/ia_css_hdr_types.h     |    64 -
 .../io_ls/bayer_io_ls/ia_css_bayer_io.host.c       |    86 -
 .../io_ls/bayer_io_ls/ia_css_bayer_io.host.h       |    31 -
 .../io_ls/bayer_io_ls/ia_css_bayer_io_param.h      |    22 -
 .../io_ls/bayer_io_ls/ia_css_bayer_io_types.h      |    22 -
 .../kernels/io_ls/common/ia_css_common_io_param.h  |    22 -
 .../kernels/io_ls/common/ia_css_common_io_types.h  |    31 -
 .../io_ls/yuv444_io_ls/ia_css_yuv444_io_param.h    |    22 -
 .../io_ls/yuv444_io_ls/ia_css_yuv444_io_types.h    |    22 -
 .../ipu2_io_ls/bayer_io_ls/ia_css_bayer_io.host.c  |    86 -
 .../ipu2_io_ls/bayer_io_ls/ia_css_bayer_io.host.h  |    31 -
 .../ipu2_io_ls/bayer_io_ls/ia_css_bayer_io_param.h |    22 -
 .../ipu2_io_ls/bayer_io_ls/ia_css_bayer_io_types.h |    22 -
 .../ipu2_io_ls/common/ia_css_common_io_param.h     |    22 -
 .../ipu2_io_ls/common/ia_css_common_io_types.h     |    31 -
 .../yuv444_io_ls/ia_css_yuv444_io.host.c           |    86 -
 .../yuv444_io_ls/ia_css_yuv444_io.host.h           |    31 -
 .../yuv444_io_ls/ia_css_yuv444_io_param.h          |    22 -
 .../yuv444_io_ls/ia_css_yuv444_io_types.h          |    22 -
 .../iterator/iterator_1.0/ia_css_iterator.host.c   |    80 -
 .../iterator/iterator_1.0/ia_css_iterator.host.h   |    34 -
 .../iterator/iterator_1.0/ia_css_iterator_param.h  |    38 -
 .../isp/kernels/macc/macc1_5/ia_css_macc1_5.host.c |    74 -
 .../isp/kernels/macc/macc1_5/ia_css_macc1_5.host.h |    41 -
 .../kernels/macc/macc1_5/ia_css_macc1_5_param.h    |    31 -
 .../macc/macc1_5/ia_css_macc1_5_table.host.c       |    32 -
 .../macc/macc1_5/ia_css_macc1_5_table.host.h       |    22 -
 .../kernels/macc/macc1_5/ia_css_macc1_5_types.h    |    74 -
 .../isp/kernels/macc/macc_1.0/ia_css_macc.host.c   |    49 -
 .../isp/kernels/macc/macc_1.0/ia_css_macc.host.h   |    42 -
 .../isp/kernels/macc/macc_1.0/ia_css_macc_param.h  |    25 -
 .../kernels/macc/macc_1.0/ia_css_macc_table.host.c |    47 -
 .../kernels/macc/macc_1.0/ia_css_macc_table.host.h |    23 -
 .../isp/kernels/macc/macc_1.0/ia_css_macc_types.h  |    63 -
 .../isp/kernels/norm/norm_1.0/ia_css_norm.host.c   |    16 -
 .../isp/kernels/norm/norm_1.0/ia_css_norm.host.h   |    20 -
 .../isp/kernels/norm/norm_1.0/ia_css_norm_param.h  |    19 -
 .../css2400/isp/kernels/ob/ob2/ia_css_ob2.host.c   |    79 -
 .../css2400/isp/kernels/ob/ob2/ia_css_ob2.host.h   |    40 -
 .../css2400/isp/kernels/ob/ob2/ia_css_ob2_param.h  |    29 -
 .../css2400/isp/kernels/ob/ob2/ia_css_ob2_types.h  |    45 -
 .../css2400/isp/kernels/ob/ob_1.0/ia_css_ob.host.c |   159 -
 .../css2400/isp/kernels/ob/ob_1.0/ia_css_ob.host.h |    53 -
 .../isp/kernels/ob/ob_1.0/ia_css_ob_param.h        |    48 -
 .../isp/kernels/ob/ob_1.0/ia_css_ob_types.h        |    69 -
 .../kernels/output/output_1.0/ia_css_output.host.c |   162 -
 .../kernels/output/output_1.0/ia_css_output.host.h |    75 -
 .../output/output_1.0/ia_css_output_param.h        |    36 -
 .../output/output_1.0/ia_css_output_types.h        |    48 -
 .../kernels/qplane/qplane_2/ia_css_qplane.host.c   |    61 -
 .../kernels/qplane/qplane_2/ia_css_qplane.host.h   |    43 -
 .../kernels/qplane/qplane_2/ia_css_qplane_param.h  |    30 -
 .../kernels/qplane/qplane_2/ia_css_qplane_types.h  |    33 -
 .../isp/kernels/raw/raw_1.0/ia_css_raw.host.c      |   136 -
 .../isp/kernels/raw/raw_1.0/ia_css_raw.host.h      |    38 -
 .../isp/kernels/raw/raw_1.0/ia_css_raw_param.h     |    38 -
 .../isp/kernels/raw/raw_1.0/ia_css_raw_types.h     |    37 -
 .../raw_aa_binning_1.0/ia_css_raa.host.c           |    35 -
 .../raw_aa_binning_1.0/ia_css_raa.host.h           |    27 -
 .../isp/kernels/ref/ref_1.0/ia_css_ref.host.c      |    74 -
 .../isp/kernels/ref/ref_1.0/ia_css_ref.host.h      |    41 -
 .../isp/kernels/ref/ref_1.0/ia_css_ref_param.h     |    36 -
 .../isp/kernels/ref/ref_1.0/ia_css_ref_state.h     |    26 -
 .../isp/kernels/ref/ref_1.0/ia_css_ref_types.h     |    28 -
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.c      |   386 -
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a.host.h      |    77 -
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_param.h     |    54 -
 .../isp/kernels/s3a/s3a_1.0/ia_css_s3a_types.h     |   220 -
 .../css2400/isp/kernels/sc/sc_1.0/ia_css_sc.host.c |   130 -
 .../css2400/isp/kernels/sc/sc_1.0/ia_css_sc.host.h |    77 -
 .../isp/kernels/sc/sc_1.0/ia_css_sc_param.h        |    71 -
 .../isp/kernels/sc/sc_1.0/ia_css_sc_types.h        |   136 -
 .../kernels/sdis/common/ia_css_sdis_common.host.h  |    99 -
 .../kernels/sdis/common/ia_css_sdis_common_types.h |   219 -
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |   423 -
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.h   |   101 -
 .../isp/kernels/sdis/sdis_1.0/ia_css_sdis_types.h  |    53 -
 .../isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c    |   338 -
 .../isp/kernels/sdis/sdis_2/ia_css_sdis2.host.h    |    95 -
 .../isp/kernels/sdis/sdis_2/ia_css_sdis2_types.h   |    69 -
 .../isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.c      |    76 -
 .../isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.h      |    38 -
 .../isp/kernels/tdf/tdf_1.0/ia_css_tdf_param.h     |    43 -
 .../isp/kernels/tdf/tdf_1.0/ia_css_tdf_types.h     |    53 -
 .../isp/kernels/tnr/tnr3/ia_css_tnr3_types.h       |    61 -
 .../isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.c      |   130 -
 .../isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.h      |    56 -
 .../isp/kernels/tnr/tnr_1.0/ia_css_tnr_param.h     |    48 -
 .../isp/kernels/tnr/tnr_1.0/ia_css_tnr_state.h     |    26 -
 .../isp/kernels/tnr/tnr_1.0/ia_css_tnr_types.h     |    60 -
 .../isp/kernels/uds/uds_1.0/ia_css_uds_param.h     |    31 -
 .../css2400/isp/kernels/vf/vf_1.0/ia_css_vf.host.c |   140 -
 .../css2400/isp/kernels/vf/vf_1.0/ia_css_vf.host.h |    47 -
 .../isp/kernels/vf/vf_1.0/ia_css_vf_param.h        |    37 -
 .../isp/kernels/vf/vf_1.0/ia_css_vf_types.h        |    32 -
 .../css2400/isp/kernels/wb/wb_1.0/ia_css_wb.host.c |    89 -
 .../css2400/isp/kernels/wb/wb_1.0/ia_css_wb.host.h |    39 -
 .../isp/kernels/wb/wb_1.0/ia_css_wb_param.h        |    29 -
 .../isp/kernels/wb/wb_1.0/ia_css_wb_types.h        |    47 -
 .../isp/kernels/xnr/xnr_1.0/ia_css_xnr.host.c      |    66 -
 .../isp/kernels/xnr/xnr_1.0/ia_css_xnr.host.h      |    47 -
 .../isp/kernels/xnr/xnr_1.0/ia_css_xnr_param.h     |    51 -
 .../kernels/xnr/xnr_1.0/ia_css_xnr_table.host.c    |    81 -
 .../kernels/xnr/xnr_1.0/ia_css_xnr_table.host.h    |    22 -
 .../isp/kernels/xnr/xnr_1.0/ia_css_xnr_types.h     |    71 -
 .../isp/kernels/xnr/xnr_3.0/ia_css_xnr3.host.c     |   265 -
 .../isp/kernels/xnr/xnr_3.0/ia_css_xnr3.host.h     |    42 -
 .../isp/kernels/xnr/xnr_3.0/ia_css_xnr3_param.h    |    96 -
 .../isp/kernels/xnr/xnr_3.0/ia_css_xnr3_types.h    |    98 -
 .../isp/kernels/ynr/ynr_1.0/ia_css_ynr.host.c      |   219 -
 .../isp/kernels/ynr/ynr_1.0/ia_css_ynr.host.h      |    60 -
 .../isp/kernels/ynr/ynr_1.0/ia_css_ynr_param.h     |    49 -
 .../isp/kernels/ynr/ynr_1.0/ia_css_ynr_state.h     |    26 -
 .../isp/kernels/ynr/ynr_1.0/ia_css_ynr_types.h     |    81 -
 .../isp/kernels/ynr/ynr_2/ia_css_ynr2.host.c       |   125 -
 .../isp/kernels/ynr/ynr_2/ia_css_ynr2.host.h       |    56 -
 .../isp/kernels/ynr/ynr_2/ia_css_ynr2_param.h      |    45 -
 .../isp/kernels/ynr/ynr_2/ia_css_ynr2_types.h      |    94 -
 .../isp/kernels/ynr/ynr_2/ia_css_ynr_param.h       |    20 -
 .../isp/kernels/ynr/ynr_2/ia_css_ynr_state.h       |    21 -
 .../css2400/isp/modes/interface/input_buf.isp.h    |    73 -
 .../css2400/isp/modes/interface/isp_const.h        |   482 -
 .../css2400/isp/modes/interface/isp_types.h        |   128 -
 .../atomisp/pci/atomisp2/css2400/memory_realloc.c  |    81 -
 .../runtime/binary/interface/ia_css_binary.h       |   257 -
 .../atomisp2/css2400/runtime/binary/src/binary.c   |  1838 ---
 .../css2400/runtime/bufq/interface/ia_css_bufq.h   |   197 -
 .../runtime/bufq/interface/ia_css_bufq_comm.h      |    66 -
 .../pci/atomisp2/css2400/runtime/bufq/src/bufq.c   |   589 -
 .../css2400/runtime/debug/interface/ia_css_debug.h |   509 -
 .../debug/interface/ia_css_debug_internal.h        |    31 -
 .../runtime/debug/interface/ia_css_debug_pipe.h    |    84 -
 .../css2400/runtime/debug/src/ia_css_debug.c       |  3596 ------
 .../css2400/runtime/event/interface/ia_css_event.h |    46 -
 .../pci/atomisp2/css2400/runtime/event/src/event.c |   126 -
 .../runtime/eventq/interface/ia_css_eventq.h       |    69 -
 .../atomisp2/css2400/runtime/eventq/src/eventq.c   |    77 -
 .../css2400/runtime/frame/interface/ia_css_frame.h |   180 -
 .../runtime/frame/interface/ia_css_frame_comm.h    |   132 -
 .../pci/atomisp2/css2400/runtime/frame/src/frame.c |  1026 --
 .../css2400/runtime/ifmtr/interface/ia_css_ifmtr.h |    49 -
 .../pci/atomisp2/css2400/runtime/ifmtr/src/ifmtr.c |   569 -
 .../runtime/inputfifo/interface/ia_css_inputfifo.h |    69 -
 .../css2400/runtime/inputfifo/src/inputfifo.c      |   613 -
 .../runtime/isp_param/interface/ia_css_isp_param.h |   118 -
 .../isp_param/interface/ia_css_isp_param_types.h   |    98 -
 .../css2400/runtime/isp_param/src/isp_param.c      |   227 -
 .../css2400/runtime/isys/interface/ia_css_isys.h   |   201 -
 .../runtime/isys/interface/ia_css_isys_comm.h      |    69 -
 .../css2400/runtime/isys/src/csi_rx_rmgr.c         |   179 -
 .../css2400/runtime/isys/src/csi_rx_rmgr.h         |    43 -
 .../css2400/runtime/isys/src/ibuf_ctrl_rmgr.c      |   140 -
 .../css2400/runtime/isys/src/ibuf_ctrl_rmgr.h      |    55 -
 .../css2400/runtime/isys/src/isys_dma_rmgr.c       |   103 -
 .../css2400/runtime/isys/src/isys_dma_rmgr.h       |    41 -
 .../atomisp2/css2400/runtime/isys/src/isys_init.c  |   139 -
 .../runtime/isys/src/isys_stream2mmio_rmgr.c       |   105 -
 .../runtime/isys/src/isys_stream2mmio_rmgr.h       |    41 -
 .../pci/atomisp2/css2400/runtime/isys/src/rx.c     |   607 -
 .../css2400/runtime/isys/src/virtual_isys.c        |   898 --
 .../css2400/runtime/isys/src/virtual_isys.h        |    41 -
 .../runtime/pipeline/interface/ia_css_pipeline.h   |   302 -
 .../pipeline/interface/ia_css_pipeline_common.h    |    42 -
 .../css2400/runtime/pipeline/src/pipeline.c        |   805 --
 .../css2400/runtime/queue/interface/ia_css_queue.h |   192 -
 .../runtime/queue/interface/ia_css_queue_comm.h    |    69 -
 .../pci/atomisp2/css2400/runtime/queue/src/queue.c |   412 -
 .../css2400/runtime/queue/src/queue_access.c       |   192 -
 .../css2400/runtime/queue/src/queue_access.h       |   101 -
 .../css2400/runtime/rmgr/interface/ia_css_rmgr.h   |    88 -
 .../runtime/rmgr/interface/ia_css_rmgr_vbuf.h      |   115 -
 .../pci/atomisp2/css2400/runtime/rmgr/src/rmgr.c   |    55 -
 .../atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c  |   330 -
 .../runtime/spctrl/interface/ia_css_spctrl.h       |    87 -
 .../runtime/spctrl/interface/ia_css_spctrl_comm.h  |    61 -
 .../atomisp2/css2400/runtime/spctrl/src/spctrl.c   |   193 -
 .../tagger/interface/ia_css_tagger_common.h        |    59 -
 .../pci/atomisp2/css2400/runtime/timer/src/timer.c |    48 -
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 11094 ---------------=
----
 .../atomisp/pci/atomisp2/css2400/sh_css_defs.h     |   410 -
 .../atomisp/pci/atomisp2/css2400/sh_css_dvs_info.h |    36 -
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |   315 -
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.h |    54 -
 .../atomisp/pci/atomisp2/css2400/sh_css_frac.h     |    40 -
 .../pci/atomisp2/css2400/sh_css_host_data.c        |    42 -
 .../atomisp/pci/atomisp2/css2400/sh_css_hrt.c      |    84 -
 .../atomisp/pci/atomisp2/css2400/sh_css_hrt.h      |    34 -
 .../atomisp/pci/atomisp2/css2400/sh_css_internal.h |  1089 --
 .../atomisp/pci/atomisp2/css2400/sh_css_legacy.h   |    77 -
 .../atomisp/pci/atomisp2/css2400/sh_css_metadata.c |    16 -
 .../atomisp/pci/atomisp2/css2400/sh_css_metrics.c  |   176 -
 .../atomisp/pci/atomisp2/css2400/sh_css_metrics.h  |    55 -
 .../atomisp/pci/atomisp2/css2400/sh_css_mipi.c     |   749 --
 .../atomisp/pci/atomisp2/css2400/sh_css_mipi.h     |    49 -
 .../atomisp/pci/atomisp2/css2400/sh_css_mmu.c      |    56 -
 .../atomisp/pci/atomisp2/css2400/sh_css_morph.c    |    16 -
 .../pci/atomisp2/css2400/sh_css_param_dvs.c        |   267 -
 .../pci/atomisp2/css2400/sh_css_param_dvs.h        |    86 -
 .../pci/atomisp2/css2400/sh_css_param_shading.c    |   417 -
 .../pci/atomisp2/css2400/sh_css_param_shading.h    |    39 -
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |  5253 ---------
 .../atomisp/pci/atomisp2/css2400/sh_css_params.h   |   188 -
 .../pci/atomisp2/css2400/sh_css_params_internal.h  |    21 -
 .../atomisp/pci/atomisp2/css2400/sh_css_pipe.c     |    16 -
 .../pci/atomisp2/css2400/sh_css_properties.c       |    43 -
 .../atomisp/pci/atomisp2/css2400/sh_css_shading.c  |    16 -
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c |  1803 ---
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.h |   248 -
 .../atomisp/pci/atomisp2/css2400/sh_css_stream.c   |    16 -
 .../pci/atomisp2/css2400/sh_css_stream_format.c    |    76 -
 .../pci/atomisp2/css2400/sh_css_stream_format.h    |    23 -
 .../atomisp/pci/atomisp2/css2400/sh_css_struct.h   |    80 -
 .../atomisp/pci/atomisp2/css2400/sh_css_uds.h      |    37 -
 .../atomisp/pci/atomisp2/css2400/sh_css_version.c  |    30 -
 .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |   727 --
 .../media/atomisp/pci/atomisp2/hmm/hmm_bo.c        |  1528 ---
 .../atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c    |   233 -
 .../atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c   |   252 -
 .../media/atomisp/pci/atomisp2/hmm/hmm_vm.c        |   212 -
 .../atomisp2/hrt/hive_isp_css_custom_host_hrt.h    |   103 -
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c |   125 -
 .../atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h |    56 -
 .../media/atomisp/pci/atomisp2/include/hmm/hmm.h   |   102 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_bo.h      |   319 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_common.h  |    96 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_pool.h    |   115 -
 .../atomisp/pci/atomisp2/include/hmm/hmm_vm.h      |    64 -
 .../atomisp/pci/atomisp2/include/mmu/isp_mmu.h     |   169 -
 .../pci/atomisp2/include/mmu/sh_mmu_mrfld.h        |    24 -
 .../media/atomisp/pci/atomisp2/mmu/isp_mmu.c       |   584 -
 .../media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c  |    75 -
 drivers/staging/media/atomisp/platform/Makefile    |     5 -
 .../media/atomisp/platform/intel-mid/Makefile      |     4 -
 .../platform/intel-mid/atomisp_gmin_platform.c     |   785 --
 drivers/staging/media/davinci_vpfe/Kconfig         |     4 +-
 drivers/staging/media/davinci_vpfe/Makefile        |     5 +
 drivers/staging/media/davinci_vpfe/TODO            |     1 +
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |   143 +-
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |    19 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |    14 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |     9 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |    15 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |     2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |     4 +-
 drivers/staging/media/imx/imx-media-capture.c      |     4 +-
 drivers/staging/media/imx/imx-media-csi.c          |     3 +-
 drivers/staging/media/imx/imx-media-utils.c        |     9 +
 drivers/staging/media/omap4iss/Kconfig             |     4 +-
 drivers/staging/media/tegra-vde/tegra-vde.c        |    98 +-
 drivers/{media/pci =3D> staging/media}/zoran/Kconfig |     2 +-
 .../{media/pci =3D> staging/media}/zoran/Makefile    |     0
 drivers/staging/media/zoran/TODO                   |     4 +
 .../pci =3D> staging/media}/zoran/videocodec.c       |     0
 .../pci =3D> staging/media}/zoran/videocodec.h       |     0
 drivers/{media/pci =3D> staging/media}/zoran/zoran.h |     0
 .../pci =3D> staging/media}/zoran/zoran_card.c       |     0
 .../pci =3D> staging/media}/zoran/zoran_card.h       |     0
 .../pci =3D> staging/media}/zoran/zoran_device.c     |     0
 .../pci =3D> staging/media}/zoran/zoran_device.h     |     0
 .../pci =3D> staging/media}/zoran/zoran_driver.c     |     4 +-
 .../pci =3D> staging/media}/zoran/zoran_procfs.c     |     0
 .../pci =3D> staging/media}/zoran/zoran_procfs.h     |     0
 .../{media/pci =3D> staging/media}/zoran/zr36016.c   |     0
 .../{media/pci =3D> staging/media}/zoran/zr36016.h   |     0
 .../{media/pci =3D> staging/media}/zoran/zr36050.c   |     0
 .../{media/pci =3D> staging/media}/zoran/zr36050.h   |     0
 .../{media/pci =3D> staging/media}/zoran/zr36057.h   |     0
 .../{media/pci =3D> staging/media}/zoran/zr36060.c   |     0
 .../{media/pci =3D> staging/media}/zoran/zr36060.h   |     0
 drivers/video/fbdev/omap2/Kconfig                  |     2 +-
 include/linux/omap-iommu.h                         |     5 +
 include/linux/platform_data/media/mmp-camera.h     |    19 +
 include/linux/sony-laptop.h                        |     4 +
 include/media/dvb-usb-ids.h                        |     1 +
 include/media/dvbdev.h                             |     2 +
 include/media/media-entity.h                       |     2 +-
 include/media/rc-core.h                            |     1 +
 include/media/v4l2-dev.h                           |    25 +-
 include/media/v4l2-device.h                        |     4 +-
 include/media/v4l2-fwnode.h                        |     2 +-
 include/media/v4l2-ioctl.h                         |    12 -
 include/media/videobuf-dvb.h                       |    59 -
 include/media/vsp1.h                               |    45 +-
 include/uapi/linux/lirc.h                          |     6 +
 include/uapi/linux/omap3isp.h                      |    22 +
 include/video/omapfb_dss.h                         |    54 +-
 sound/isa/Kconfig                                  |     3 +-
 1168 files changed, 16815 insertions(+), 176700 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2rx.txt
 create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2tx.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7251.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/panasonic,a=
mg88xx.txt
 create mode 100644 Documentation/devicetree/bindings/media/renesas,rcar-cs=
i2.txt
 delete mode 100644 Documentation/media/uapi/v4l/selection-api-005.rst
 rename Documentation/media/uapi/v4l/{selection-api-004.rst =3D> selection-=
api-configuration.rst} (98%)
 rename Documentation/media/uapi/v4l/{selection-api-006.rst =3D> selection-=
api-examples.rst} (100%)
 rename Documentation/media/uapi/v4l/{selection-api-002.rst =3D> selection-=
api-intro.rst} (100%)
 rename Documentation/media/uapi/v4l/{selection-api-003.rst =3D> selection-=
api-targets.rst} (100%)
 create mode 100644 Documentation/media/uapi/v4l/selection-api-vs-crop-api.=
rst
 create mode 100644 drivers/media/i2c/imx258.c
 create mode 100644 drivers/media/i2c/ov7251.c
 create mode 100644 drivers/media/i2c/video-i2c.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-mci.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-mci.h
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007s.c
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007s.h
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007t.c
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007t.h
 create mode 100644 drivers/media/platform/cadence/Kconfig
 create mode 100644 drivers/media/platform/cadence/Makefile
 create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c
 create mode 100644 drivers/media/platform/cadence/cdns-csi2tx.c
 create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c
 delete mode 100644 drivers/media/platform/vsp1/vsp1_bru.h
 rename drivers/media/platform/vsp1/{vsp1_bru.c =3D> vsp1_brx.c} (60%)
 create mode 100644 drivers/media/platform/vsp1/vsp1_brx.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_uif.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_uif.h
 create mode 100644 drivers/media/tuners/qm1d1b0004.c
 create mode 100644 drivers/media/tuners/qm1d1b0004.h
 delete mode 100644 drivers/media/v4l2-core/videobuf-dvb.c
 delete mode 100644 drivers/staging/media/atomisp/Kconfig
 delete mode 100644 drivers/staging/media/atomisp/Makefile
 delete mode 100644 drivers/staging/media/atomisp/TODO
 delete mode 100644 drivers/staging/media/atomisp/i2c/Kconfig
 delete mode 100644 drivers/staging/media/atomisp/i2c/Makefile
 delete mode 100644 drivers/staging/media/atomisp/i2c/atomisp-gc0310.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/atomisp-libmsrlisthel=
per.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/atomisp-mt9m114.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/atomisp-ov2722.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/gc0310.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/gc2235.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/mt9m114.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov2680.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov2722.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov5693/Kconfig
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov5693/Makefile
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov5693/ad5823.h
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693=
.c
 delete mode 100644 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
 delete mode 100644 drivers/staging/media/atomisp/include/linux/atomisp.h
 delete mode 100644 drivers/staging/media/atomisp/include/linux/atomisp_gmi=
n_platform.h
 delete mode 100644 drivers/staging/media/atomisp/include/linux/atomisp_pla=
tform.h
 delete mode 100644 drivers/staging/media/atomisp/include/linux/libmsrlisth=
elper.h
 delete mode 100644 drivers/staging/media/atomisp/include/media/lm3554.h
 delete mode 100644 drivers/staging/media/atomisp/pci/Kconfig
 delete mode 100644 drivers/staging/media/atomisp/pci/Makefile
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/Makefile
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp-regs=
.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_comm=
on.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_comp=
at.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_comp=
at_css20.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_comp=
at_css20.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_comp=
at_ioctl32.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_comp=
at_ioctl32.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2=
.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2=
.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_dfs_=
tables.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvf=
s.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvf=
s.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_file=
.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_file=
.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops=
.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops=
.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_help=
er.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_inte=
rnal.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioct=
l.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioct=
l.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_subd=
ev.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_subd=
ev.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_tabl=
es.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_trac=
e_event.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2=
.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2=
.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/Make=
file
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/base=
/circbuf/interface/ia_css_circbuf.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/base=
/circbuf/interface/ia_css_circbuf_comm.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/base=
/circbuf/interface/ia_css_circbuf_desc.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/base=
/circbuf/src/circbuf.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/base=
/refcount/interface/ia_css_refcount.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/base=
/refcount/src/refcount.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/came=
ra/pipe/interface/ia_css_pipe_binarydesc.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/came=
ra/pipe/interface/ia_css_pipe_stagedesc.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/came=
ra/pipe/interface/ia_css_pipe_util.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/came=
ra/pipe/src/pipe_binarydesc.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/came=
ra/pipe/src/pipe_stagedesc.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/came=
ra/pipe/src/pipe_util.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/came=
ra/util/interface/ia_css_util.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/came=
ra/util/src/util.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hive_isp_css_2400_system_generated/ia_css_isp_configs.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hive_isp_css_2400_system_generated/ia_css_isp_configs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/bits.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/cell_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/css_receiver_2400_common_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/css_receiver_2400_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/dma_v2_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/gdc_v2_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/gp_timer_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/gpio_block_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/hive_isp_css_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/hive_isp_css_host_ids_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/hive_isp_css_irq_types_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/hive_isp_css_streaming_to_mipi_types_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/hive_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/if_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/input_formatter_subsystem_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/input_selector_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/input_switch_2400_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/input_system_ctrl_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/input_system_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/irq_controller_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/isp2400_mamoiada_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/isp2400_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/isp_acquisition_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/isp_capture_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/mmu_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/scalar_processor_2400_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/str2mem_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/streaming_to_mipi_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/timed_controller_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/var.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/hrt/version.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2400_system/spmem_dump.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/csi_rx_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_confi=
gs.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_confi=
gs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_param=
s.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_param=
s.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_state=
s.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_state=
s.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/csi_rx.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/csi_rx_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/csi_rx_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/ibuf_ctrl.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/ibuf_ctrl_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/ibuf_ctrl_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/input_system_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/input_system_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/isys_dma.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/isys_dma_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/isys_dma_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/isys_irq.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/isys_irq_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/isys_irq_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/isys_stream2mmio.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/isys_stream2mmio_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/isys_stream2mmio_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/pixelgen_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/pixelgen_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/host/system_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/PixelGen_SysBlock_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/bits.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/cell_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/css_receiver_2400_common_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/css_receiver_2400_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/dma_v2_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/gdc_v2_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/gp_timer_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/gpio_block_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/hive_isp_css_2401_irq_types_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/hive_isp_css_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/hive_isp_css_host_ids_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/hive_isp_css_streaming_to_mipi_types_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/hive_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/ibuf_cntrl_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/if_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/input_formatter_subsystem_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/input_selector_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/input_switch_2400_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/input_system_ctrl_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/input_system_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/irq_controller_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/isp2400_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/isp2401_mamoiada_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/isp_acquisition_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/isp_capture_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/mipi_backend_common_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/mipi_backend_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/mmu_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/rx_csi_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/scalar_processor_2400_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/str2mem_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/stream2mmio_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/streaming_to_mipi_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/timed_controller_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/var.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/hrt/version.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/ibuf_ctrl_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/input_system_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/isys_dma_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/isys_irq_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/isys_stream2mmio_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/pixelgen_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/spmem_dump.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_csi2p_system/system_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hive_isp_css_2401_system_generated/ia_css_isp_configs.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hive_isp_css_2401_system_generated/ia_css_isp_configs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/bits.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/cell_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/css_receiver_2400_common_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/css_receiver_2400_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/dma_v2_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/gdc_v2_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/gp_timer_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/gpio_block_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/hive_isp_css_2401_irq_types_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/hive_isp_css_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/hive_isp_css_host_ids_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/hive_isp_css_streaming_to_mipi_types_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/hive_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/if_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/input_formatter_subsystem_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/input_selector_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/input_switch_2400_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/input_system_ctrl_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/input_system_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/irq_controller_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/isp2400_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/isp2401_mamoiada_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/isp_acquisition_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/isp_capture_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/mmu_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/scalar_processor_2400_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/str2mem_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/streaming_to_mipi_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/timed_controller_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/var.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/hrt/version.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
2401_system/spmem_dump.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/css_=
trace.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/debug_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/dma_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/event_fifo_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/fifo_monitor_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/gdc_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/gp_device_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/gp_timer_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/gpio_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/hmem_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/debug.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/debug_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/debug_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/dma.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/dma_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/dma_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/event_fifo.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/event_fifo_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/event_fifo_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/fifo_monitor.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/fifo_monitor_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/fifo_monitor_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gdc.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gdc_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gdc_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gp_device.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gp_device_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gp_device_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gp_timer.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gp_timer_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gp_timer_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gpio_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/gpio_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/hmem.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/hmem_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/hmem_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/input_formatter.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/input_formatter_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/input_formatter_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/input_system.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/input_system_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/input_system_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/irq.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/irq_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/irq_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/isp.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/isp_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/isp_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/mmu.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/mmu_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/mmu_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/sp.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/sp_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/sp_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/system_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/timed_ctrl.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/timed_ctrl_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/timed_ctrl_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/vamem_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/vamem_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/vmem.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/vmem_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/host/vmem_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/input_formatter_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/input_system_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/irq_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/isp_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/mmu_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/sp_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/system_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/timed_ctrl_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/vamem_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_common/vmem_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/assert_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/bitop_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/csi_rx.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/debug.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/device_access/device_access.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/dma.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/error_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/event_fifo.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/fifo_monitor.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/gdc_device.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/gp_device.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/gp_timer.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/gpio.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/hmem.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/csi_rx_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/debug_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/dma_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/event_fifo_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/fifo_monitor_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/gdc_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/gp_device_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/gp_timer_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/gpio_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/hmem_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/ibuf_ctrl_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/input_formatter_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/input_system_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/irq_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/isp_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/isys_dma_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/isys_irq_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/isys_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/isys_stream2mmio_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/mmu_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/pixelgen_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/sp_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/tag_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/timed_ctrl_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/vamem_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/host/vmem_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/ibuf_ctrl.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/input_formatter.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/input_system.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/irq.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/isp.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/isys_dma.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/isys_irq.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/isys_stream2mmio.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/math_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/memory_access/memory_access.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/memory_realloc.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/misc_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/mmu_device.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/pixelgen.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/platform_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/print_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/queue.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/resource.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/socket.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/sp.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/string_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/system_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/tag.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/timed_ctrl.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/type_support.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/vamem.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_include/vmem.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_shared/host/queue_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_shared/host/queue_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_shared/host/tag.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_shared/host/tag_local.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_shared/host/tag_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_shared/queue_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_shared/sw_event_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/hive=
_isp_css_shared/tag_global.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_3a.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_acc_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_buffer.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_control.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_device_access.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_device_access.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_dvs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_env.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_err.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_event_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_firmware.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_frac.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_frame_format.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_frame_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_host_data.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_input_port.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_irq.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_memory_access.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_metadata.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_mipi.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_mmu.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_mmu_private.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_morph.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_pipe.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_pipe_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_prbs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_properties.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_shading.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_stream.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_stream_format.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_stream_public.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_timer.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_tpg.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_version.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/ia_c=
ss_version_data.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/aa/aa_2/ia_css_aa2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/aa/aa_2/ia_css_aa2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/aa/aa_2/ia_css_aa2_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/aa/aa_2/ia_css_aa2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/anr/anr_1.0/ia_css_anr.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/anr/anr_1.0/ia_css_anr.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/anr/anr_1.0/ia_css_anr_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/anr/anr_1.0/ia_css_anr_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/anr/anr_2/ia_css_anr2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/anr/anr_2/ia_css_anr2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/anr/anr_2/ia_css_anr2_table.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/anr/anr_2/ia_css_anr2_table.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/anr/anr_2/ia_css_anr2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/anr/anr_2/ia_css_anr_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bh/bh_2/ia_css_bh.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bh/bh_2/ia_css_bh.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bh/bh_2/ia_css_bh_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bh/bh_2/ia_css_bh_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnlm/ia_css_bnlm.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnlm/ia_css_bnlm.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnlm/ia_css_bnlm_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnlm/ia_css_bnlm_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnr/bnr2_2/ia_css_bnr2_2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnr/bnr2_2/ia_css_bnr2_2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnr/bnr2_2/ia_css_bnr2_2_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnr/bnr2_2/ia_css_bnr2_2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnr/bnr_1.0/ia_css_bnr.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnr/bnr_1.0/ia_css_bnr.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/bnr/bnr_1.0/ia_css_bnr_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/cnr/cnr_1.0/ia_css_cnr.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/cnr/cnr_1.0/ia_css_cnr.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/cnr/cnr_1.0/ia_css_cnr_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/cnr/cnr_2/ia_css_cnr2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/cnr/cnr_2/ia_css_cnr2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/cnr/cnr_2/ia_css_cnr2_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/cnr/cnr_2/ia_css_cnr2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/cnr/cnr_2/ia_css_cnr_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/conversion/conversion_1.0/ia_css_conversion.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/conversion/conversion_1.0/ia_css_conversion.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/conversion/conversion_1.0/ia_css_conversion_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/conversion/conversion_1.0/ia_css_conversion_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/copy_output/copy_output_1.0/ia_css_copy_output.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/copy_output/copy_output_1.0/ia_css_copy_output.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/copy_output/copy_output_1.0/ia_css_copy_output_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/crop/crop_1.0/ia_css_crop.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/crop/crop_1.0/ia_css_crop.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/crop/crop_1.0/ia_css_crop_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/crop/crop_1.0/ia_css_crop_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/csc/csc_1.0/ia_css_csc.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/csc/csc_1.0/ia_css_csc.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/csc/csc_1.0/ia_css_csc_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/csc/csc_1.0/ia_css_csc_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc1_5/ia_css_ctc1_5.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc1_5/ia_css_ctc1_5.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc1_5/ia_css_ctc1_5_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc1_5/ia_css_ctc_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc2/ia_css_ctc2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc2/ia_css_ctc2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc2/ia_css_ctc2_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc2/ia_css_ctc2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc_1.0/ia_css_ctc.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc_1.0/ia_css_ctc.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc_1.0/ia_css_ctc_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc_1.0/ia_css_ctc_table.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc_1.0/ia_css_ctc_table.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ctc/ctc_1.0/ia_css_ctc_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_1.0/ia_css_de.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_1.0/ia_css_de.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_1.0/ia_css_de_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_1.0/ia_css_de_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_1.0/ia_css_de_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_2/ia_css_de2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_2/ia_css_de2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_2/ia_css_de2_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_2/ia_css_de2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_2/ia_css_de_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/de/de_2/ia_css_de_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dp/dp_1.0/ia_css_dp.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dp/dp_1.0/ia_css_dp.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dp/dp_1.0/ia_css_dp_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dp/dp_1.0/ia_css_dp_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dpc2/ia_css_dpc2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dpc2/ia_css_dpc2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dpc2/ia_css_dpc2_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dpc2/ia_css_dpc2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dvs/dvs_1.0/ia_css_dvs.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dvs/dvs_1.0/ia_css_dvs.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dvs/dvs_1.0/ia_css_dvs_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/dvs/dvs_1.0/ia_css_dvs_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/eed1_8/ia_css_eed1_8.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/eed1_8/ia_css_eed1_8.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/eed1_8/ia_css_eed1_8_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/eed1_8/ia_css_eed1_8_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/fc/fc_1.0/ia_css_formats.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/fc/fc_1.0/ia_css_formats.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/fc/fc_1.0/ia_css_formats_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/fc/fc_1.0/ia_css_formats_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/fixedbds/fixedbds_1.0/ia_css_fixedbds_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/fpn/fpn_1.0/ia_css_fpn.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/fpn/fpn_1.0/ia_css_fpn.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/fpn/fpn_1.0/ia_css_fpn_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/fpn/fpn_1.0/ia_css_fpn_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_1.0/ia_css_gc.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_1.0/ia_css_gc.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_1.0/ia_css_gc_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_1.0/ia_css_gc_table.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_1.0/ia_css_gc_table.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_1.0/ia_css_gc_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_2/ia_css_gc2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_2/ia_css_gc2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_2/ia_css_gc2_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_2/ia_css_gc2_table.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_2/ia_css_gc2_table.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/gc/gc_2/ia_css_gc2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/hdr/ia_css_hdr.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/hdr/ia_css_hdr.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/hdr/ia_css_hdr_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/hdr/ia_css_hdr_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/io_ls/bayer_io_ls/ia_css_bayer_io.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/io_ls/bayer_io_ls/ia_css_bayer_io.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/io_ls/bayer_io_ls/ia_css_bayer_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/io_ls/bayer_io_ls/ia_css_bayer_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/io_ls/common/ia_css_common_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/io_ls/common/ia_css_common_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/io_ls/yuv444_io_ls/ia_css_yuv444_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/io_ls/yuv444_io_ls/ia_css_yuv444_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ipu2_io_ls/bayer_io_ls/ia_css_bayer_io.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ipu2_io_ls/bayer_io_ls/ia_css_bayer_io.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ipu2_io_ls/bayer_io_ls/ia_css_bayer_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ipu2_io_ls/bayer_io_ls/ia_css_bayer_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ipu2_io_ls/common/ia_css_common_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ipu2_io_ls/common/ia_css_common_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ipu2_io_ls/yuv444_io_ls/ia_css_yuv444_io.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ipu2_io_ls/yuv444_io_ls/ia_css_yuv444_io.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ipu2_io_ls/yuv444_io_ls/ia_css_yuv444_io_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ipu2_io_ls/yuv444_io_ls/ia_css_yuv444_io_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/iterator/iterator_1.0/ia_css_iterator.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/iterator/iterator_1.0/ia_css_iterator.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/iterator/iterator_1.0/ia_css_iterator_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc1_5/ia_css_macc1_5.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc1_5/ia_css_macc1_5.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc1_5/ia_css_macc1_5_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc1_5/ia_css_macc1_5_table.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc1_5/ia_css_macc1_5_table.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc1_5/ia_css_macc1_5_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc_1.0/ia_css_macc.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc_1.0/ia_css_macc.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc_1.0/ia_css_macc_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc_1.0/ia_css_macc_table.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc_1.0/ia_css_macc_table.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/macc/macc_1.0/ia_css_macc_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/norm/norm_1.0/ia_css_norm.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/norm/norm_1.0/ia_css_norm.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/norm/norm_1.0/ia_css_norm_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ob/ob2/ia_css_ob2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ob/ob2/ia_css_ob2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ob/ob2/ia_css_ob2_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ob/ob2/ia_css_ob2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ob/ob_1.0/ia_css_ob.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ob/ob_1.0/ia_css_ob.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ob/ob_1.0/ia_css_ob_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ob/ob_1.0/ia_css_ob_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/output/output_1.0/ia_css_output.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/output/output_1.0/ia_css_output.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/output/output_1.0/ia_css_output_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/output/output_1.0/ia_css_output_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/qplane/qplane_2/ia_css_qplane.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/qplane/qplane_2/ia_css_qplane.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/qplane/qplane_2/ia_css_qplane_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/qplane/qplane_2/ia_css_qplane_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/raw/raw_1.0/ia_css_raw.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/raw/raw_1.0/ia_css_raw.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/raw/raw_1.0/ia_css_raw_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/raw/raw_1.0/ia_css_raw_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/raw_aa_binning/raw_aa_binning_1.0/ia_css_raa.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/raw_aa_binning/raw_aa_binning_1.0/ia_css_raa.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ref/ref_1.0/ia_css_ref.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ref/ref_1.0/ia_css_ref.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ref/ref_1.0/ia_css_ref_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ref/ref_1.0/ia_css_ref_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ref/ref_1.0/ia_css_ref_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/s3a/s3a_1.0/ia_css_s3a.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/s3a/s3a_1.0/ia_css_s3a.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/s3a/s3a_1.0/ia_css_s3a_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/s3a/s3a_1.0/ia_css_s3a_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sc/sc_1.0/ia_css_sc.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sc/sc_1.0/ia_css_sc.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sc/sc_1.0/ia_css_sc_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sc/sc_1.0/ia_css_sc_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sdis/common/ia_css_sdis_common.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sdis/common/ia_css_sdis_common_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sdis/sdis_1.0/ia_css_sdis.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sdis/sdis_1.0/ia_css_sdis.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sdis/sdis_1.0/ia_css_sdis_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sdis/sdis_2/ia_css_sdis2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sdis/sdis_2/ia_css_sdis2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/sdis/sdis_2/ia_css_sdis2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/tdf/tdf_1.0/ia_css_tdf.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/tdf/tdf_1.0/ia_css_tdf.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/tdf/tdf_1.0/ia_css_tdf_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/tdf/tdf_1.0/ia_css_tdf_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/tnr/tnr3/ia_css_tnr3_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/tnr/tnr_1.0/ia_css_tnr.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/tnr/tnr_1.0/ia_css_tnr.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/tnr/tnr_1.0/ia_css_tnr_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/tnr/tnr_1.0/ia_css_tnr_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/tnr/tnr_1.0/ia_css_tnr_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/uds/uds_1.0/ia_css_uds_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/vf/vf_1.0/ia_css_vf.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/vf/vf_1.0/ia_css_vf.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/vf/vf_1.0/ia_css_vf_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/vf/vf_1.0/ia_css_vf_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/wb/wb_1.0/ia_css_wb.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/wb/wb_1.0/ia_css_wb.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/wb/wb_1.0/ia_css_wb_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/wb/wb_1.0/ia_css_wb_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/xnr/xnr_1.0/ia_css_xnr.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/xnr/xnr_1.0/ia_css_xnr.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/xnr/xnr_1.0/ia_css_xnr_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/xnr/xnr_1.0/ia_css_xnr_table.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/xnr/xnr_1.0/ia_css_xnr_table.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/xnr/xnr_1.0/ia_css_xnr_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/xnr/xnr_3.0/ia_css_xnr3.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/xnr/xnr_3.0/ia_css_xnr3.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/xnr/xnr_3.0/ia_css_xnr3_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/xnr/xnr_3.0/ia_css_xnr3_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_1.0/ia_css_ynr.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_1.0/ia_css_ynr.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_1.0/ia_css_ynr_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_1.0/ia_css_ynr_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_1.0/ia_css_ynr_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_2/ia_css_ynr2.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_2/ia_css_ynr2.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_2/ia_css_ynr2_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_2/ia_css_ynr2_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_2/ia_css_ynr_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
kernels/ynr/ynr_2/ia_css_ynr_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
modes/interface/input_buf.isp.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
modes/interface/isp_const.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/=
modes/interface/isp_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/memo=
ry_realloc.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/binary/interface/ia_css_binary.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/binary/src/binary.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/bufq/interface/ia_css_bufq.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/bufq/interface/ia_css_bufq_comm.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/bufq/src/bufq.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/debug/interface/ia_css_debug.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/debug/interface/ia_css_debug_internal.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/debug/interface/ia_css_debug_pipe.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/debug/src/ia_css_debug.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/event/interface/ia_css_event.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/event/src/event.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/eventq/interface/ia_css_eventq.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/eventq/src/eventq.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/frame/interface/ia_css_frame.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/frame/interface/ia_css_frame_comm.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/frame/src/frame.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/ifmtr/interface/ia_css_ifmtr.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/ifmtr/src/ifmtr.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/inputfifo/interface/ia_css_inputfifo.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/inputfifo/src/inputfifo.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isp_param/interface/ia_css_isp_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isp_param/interface/ia_css_isp_param_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isp_param/src/isp_param.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/interface/ia_css_isys.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/interface/ia_css_isys_comm.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/csi_rx_rmgr.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/csi_rx_rmgr.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/ibuf_ctrl_rmgr.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/ibuf_ctrl_rmgr.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/isys_dma_rmgr.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/isys_dma_rmgr.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/isys_init.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/isys_stream2mmio_rmgr.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/isys_stream2mmio_rmgr.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/rx.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/virtual_isys.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/isys/src/virtual_isys.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/pipeline/interface/ia_css_pipeline.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/pipeline/interface/ia_css_pipeline_common.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/pipeline/src/pipeline.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/queue/interface/ia_css_queue.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/queue/interface/ia_css_queue_comm.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/queue/src/queue.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/queue/src/queue_access.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/queue/src/queue_access.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/rmgr/interface/ia_css_rmgr.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/rmgr/interface/ia_css_rmgr_vbuf.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/rmgr/src/rmgr.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/rmgr/src/rmgr_vbuf.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/spctrl/interface/ia_css_spctrl.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/spctrl/interface/ia_css_spctrl_comm.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/spctrl/src/spctrl.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/tagger/interface/ia_css_tagger_common.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/runt=
ime/timer/src/timer.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_defs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_dvs_info.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_firmware.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_firmware.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_frac.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_host_data.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_hrt.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_internal.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_legacy.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_metadata.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_metrics.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_metrics.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_mipi.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_mipi.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_mmu.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_morph.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_param_dvs.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_param_dvs.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_param_shading.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_param_shading.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_params.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_params.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_params_internal.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_pipe.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_properties.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_shading.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_sp.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_sp.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_stream.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_stream_format.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_stream_format.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_struct.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_uds.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_c=
ss_version.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dyna=
mic_pool.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_rese=
rved_pool.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp=
_css_custom_host_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp=
_css_mm_hrt.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp=
_css_mm_hrt.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/=
hmm.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/=
hmm_bo.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/=
hmm_common.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/=
hmm_pool.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/=
hmm_vm.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/mmu/=
isp_mmu.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/include/mmu/=
sh_mmu_mrfld.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_m=
rfld.c
 delete mode 100644 drivers/staging/media/atomisp/platform/Makefile
 delete mode 100644 drivers/staging/media/atomisp/platform/intel-mid/Makefi=
le
 delete mode 100644 drivers/staging/media/atomisp/platform/intel-mid/atomis=
p_gmin_platform.c
 rename drivers/{media/pci =3D> staging/media}/zoran/Kconfig (97%)
 rename drivers/{media/pci =3D> staging/media}/zoran/Makefile (100%)
 create mode 100644 drivers/staging/media/zoran/TODO
 rename drivers/{media/pci =3D> staging/media}/zoran/videocodec.c (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/videocodec.h (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zoran.h (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zoran_card.c (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zoran_card.h (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zoran_device.c (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zoran_device.h (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zoran_driver.c (99%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zoran_procfs.c (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zoran_procfs.h (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zr36016.c (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zr36016.h (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zr36050.c (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zr36050.h (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zr36057.h (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zr36060.c (100%)
 rename drivers/{media/pci =3D> staging/media}/zoran/zr36060.h (100%)
 delete mode 100644 include/media/videobuf-dvb.h
