Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab2J0UmG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:06 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg6M3019798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 00/68] Get rid of all warnings
Date: Sat, 27 Oct 2012 18:40:18 -0200
Message-Id: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are too many warnings at the media tree, making impossible
to know when a new patch is adding new warnings or not. Get
rid of all of them (with make allyesconfig, i386).

Individual patches got c/c to the driver MAINTAINERS, using
	./scripts/get_maintainer.pl --no-git-fallback --no-l <patch>

If you're a maintainer for the touched drivers and weren't
c/c, please send me a patch updating the MAINTAINERS entries
for the boards you're maintaining.

PS.: The patches are also on my "experimental" tree, at branch
	"warnings_fix":

Mauro Carvalho Chehab (68):
  [media] siano: get rid of warning: no previous prototype
  [media] drxd_hard: get rid of warning: no previous prototype
  [media] rtl2830.c: get rid of warning: no previous prototype
  [media] rtl2832: get rid of warning: no previous prototype
  [media] stb0899_drv: get rid of warning: no previous prototype
  [media] stv0367: get rid of warning: no previous prototype
  [media] tda10071: get rid of warning: no previous prototype
  [media] tda18271c2dd.c: get rid of warning: no previous prototype
  [media] cx18: get rid of warning: no previous prototype
  [media] cx23885: get rid of warning: no previous prototype
  [media] cx23885-alsa: fix a false gcc warning at dprintk()
  [media] cx25821: get rid of warning: no previous prototype
  [media] dm1105: get rid of warning: no previous prototype
  [media] ivtv: get rid of warning: no previous prototype
  [media] ivtv-ioctl.c: remove an useless check
  [media] mantis: get rid of warning: no previous prototype
  [media] saa7164: get rid of warning: no previous prototype
  [media] radio-aimslab.c: get rid of warning: no previous prototype
  [media] radio-isa: get rid of warning: no previous prototype
  [media] radio-sf16fmi: get rid of warning: no previous prototype
  [media] ene_cir: get rid of warning: no previous prototype
  [media] ite-cir.c: get rid of warning: no previous prototype
  [media] nuvoton-cir: get rid of warning: no previous prototype
  [media] nuvoton-cir: carrier detect support is broken - remove it
  [media] max2165: get rid of warning: no previous prototype
  [media] au0828: get rid of warning: no previous prototype
  [media] cx231xx: get rid of warning: no previous prototype
  [media] cx231xx-avcore: get rid of a sophisticated do-nothing code
  [media] az6027: get rid of warning: no previous prototype
  [media] dvb-usb-v2: get rid of warning: no previous prototype
  [media] lmedm04: get rid of warning: no previous prototype
  [media] vp702x: get rid of warning: no previous prototype
  [media] pvrusb2: get rid of warning: no previous prototype
  [media] pwc-if: get rid of warning: no previous prototype
  [media] pwc-if: must check vb2_queue_init() success
  [media] dib9000: get rid of warning: no previous prototype
  [media] gscpa: get rid of warning: suggest braces around empty body
  [media] jeilinj: fix return of the response code
  [media] gspca: warning fix: index is unsigned, so it will never be
    below 0
  [media] dt3155v4l: vb2_queue_init() can now fail. Check is required
  [media] go7007-v4l2: warning fix: index is unsigned, so it will never
    be below 0
  [media] dvb_frontend: Don't declare values twice at a table
  [media] cx88: reorder inline to prevent a gcc warning
  [media] cx88: get rid of a warning at dprintk() macro
  [media] dmxdev: fix a comparition of unsigned expression warning
  [media] drxk: get rid of some unused vars
  [media] dvb-frontends: get rid of some "always false" warnings
  [media] soc_camera/ov2640: Don't use a temp var for an unused value
  [media] ngene: better comment unused code to avoid warnings
  [media] saa7134,saa7164: warning: comparison of unsigned fixes
  [media] meye: fix a warning
  [media] m2m-deinterlace: remove unused vars
  [media] tlg2300: index is unsigned, so never below zero
  [media] fmdrv: better define fmdbg() macro to avoid warnings
  [media] v4l2-common: h_bp var is unused at v4l2_detect_gtf()
  [media] tua9001: fix a warning
  [media] anysee: fix a warning
  [media] em28xx-cards: fix a warning
  [media] s2255drv: index is always positive
  [media] usbvision-core: fix a warning
  [media] zr364xx: urb actual_length is unsigned
  [media] bttv-driver: fix two warnings
  [media] cx25840-core: get rid of warning: no previous prototype
  [media] au0828-dvb: ret is never tested. Get rid of it
  [media] soc_camera: ret is never used. get rid of it
  [media] fmdrv: Don't check if unsigned are below zero
  fintek-cir: get rid of warning: no previous prototype     Cc: Linux
    Media Mailing List <linux-media@vger.kernel.org>
  radio tea5764, si4713: get rid of warning: no previous prototype    
    drivers/media/radio/radio-tea5764.c:148:5: warning: no previous
    prototype for 'tea5764_i2c_read' [-Wmissing-prototypes]    
    drivers/media/radio/radio-tea5764.c:168:5: warning: no previous
    prototype for 'tea5764_i2c_write' [-Wmissing-prototypes]    
    drivers/media/radio/si4713-i2c.c:1772:6: warning: no previous
    prototype for 'si4713_ioctl' [-Wmissing-prototypes]

 drivers/media/common/siano/smscoreapi.c            |  2 +-
 drivers/media/dvb-core/dmxdev.c                    |  2 +-
 drivers/media/dvb-core/dvb_frontend.c              | 10 -----
 drivers/media/dvb-frontends/cx22700.c              |  4 +-
 drivers/media/dvb-frontends/cx24123.c              |  2 +-
 drivers/media/dvb-frontends/dib9000.h              |  2 +-
 drivers/media/dvb-frontends/drxd_hard.c            |  8 ++--
 drivers/media/dvb-frontends/drxk_hard.c            | 15 --------
 drivers/media/dvb-frontends/drxk_hard.h            |  6 +--
 drivers/media/dvb-frontends/l64781.c               |  4 +-
 drivers/media/dvb-frontends/mt312.c                |  4 +-
 drivers/media/dvb-frontends/rtl2830.c              |  6 +--
 drivers/media/dvb-frontends/rtl2832.c              |  6 +--
 drivers/media/dvb-frontends/stb0899_drv.c          |  2 +-
 drivers/media/dvb-frontends/stv0367.c              | 19 ++++-----
 drivers/media/dvb-frontends/tda10071.c             |  6 ++-
 drivers/media/dvb-frontends/tda18271c2dd.c         |  1 +
 drivers/media/i2c/cx25840/cx25840-core.c           |  2 +-
 drivers/media/i2c/soc_camera/ov2640.c              |  6 +--
 drivers/media/pci/bt8xx/bttv-driver.c              |  7 ++--
 drivers/media/pci/cx18/cx18-alsa-main.c            |  2 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.c             |  1 +
 drivers/media/pci/cx18/cx18-streams.c              |  2 +-
 drivers/media/pci/cx23885/altera-ci.c              | 45 +++++++++++-----------
 drivers/media/pci/cx23885/cimax2.c                 | 17 ++++----
 drivers/media/pci/cx23885/cx23885-alsa.c           |  6 ++-
 drivers/media/pci/cx23885/cx23885-av.c             |  1 +
 drivers/media/pci/cx23885/cx23885-cards.c          |  2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |  2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-f300.c           |  1 +
 drivers/media/pci/cx23885/cx23885-input.c          |  1 +
 drivers/media/pci/cx23885/cx23885-input.h          |  2 +-
 drivers/media/pci/cx23885/cx23885-ioctl.c          |  2 +
 drivers/media/pci/cx23885/cx23885-ir.c             |  1 +
 drivers/media/pci/cx23885/cx23888-ir.c             |  1 +
 drivers/media/pci/cx23885/netup-init.c             |  1 +
 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 16 ++++----
 drivers/media/pci/cx25821/cx25821-biffuncs.h       |  6 +--
 drivers/media/pci/cx25821/cx25821-i2c.c            |  4 +-
 .../media/pci/cx25821/cx25821-video-upstream-ch2.c | 24 +++++++-----
 drivers/media/pci/cx25821/cx25821-video-upstream.c | 32 ++++++++-------
 drivers/media/pci/cx25821/cx25821-video.c          |  8 ++--
 drivers/media/pci/cx88/cx88-alsa.c                 | 14 ++++---
 drivers/media/pci/cx88/cx88-blackbird.c            |  7 ++--
 drivers/media/pci/cx88/cx88-core.c                 | 12 +++---
 drivers/media/pci/cx88/cx88-mpeg.c                 | 14 ++++---
 drivers/media/pci/cx88/cx88.h                      |  4 +-
 drivers/media/pci/dm1105/dm1105.c                  |  4 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |  2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |  6 ++-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h             |  4 --
 drivers/media/pci/ivtv/ivtv-firmware.c             |  2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |  4 +-
 drivers/media/pci/mantis/mantis_input.c            |  5 ++-
 drivers/media/pci/mantis/mantis_uart.c             |  2 +-
 drivers/media/pci/mantis/mantis_vp1033.c           |  6 +--
 drivers/media/pci/meye/meye.c                      |  2 +-
 drivers/media/pci/ngene/ngene-cards.c              |  4 +-
 drivers/media/pci/ngene/ngene-core.c               |  4 +-
 drivers/media/pci/saa7134/saa7134-core.c           |  3 +-
 drivers/media/pci/saa7134/saa7134-video.c          |  2 +-
 drivers/media/pci/saa7164/saa7164-api.c            | 26 +++++++------
 drivers/media/pci/saa7164/saa7164-bus.c            |  6 +--
 drivers/media/pci/saa7164/saa7164-cmd.c            | 16 ++++----
 drivers/media/pci/saa7164/saa7164-core.c           |  4 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        | 15 ++++----
 drivers/media/pci/saa7164/saa7164-fw.c             |  8 ++--
 drivers/media/pci/saa7164/saa7164-vbi.c            |  6 ++-
 drivers/media/platform/m2m-deinterlace.c           | 10 +----
 drivers/media/platform/soc_camera/soc_camera.c     |  4 +-
 drivers/media/radio/radio-aimslab.c                |  2 +-
 drivers/media/radio/radio-isa.c                    | 10 +++--
 drivers/media/radio/radio-sf16fmi.c                |  2 +-
 drivers/media/radio/radio-tea5764.c                |  4 +-
 drivers/media/radio/si4713-i2c.c                   |  2 +-
 drivers/media/radio/wl128x/fmdrv.h                 |  2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |  2 +-
 drivers/media/radio/wl128x/fmdrv_rx.c              |  2 +-
 drivers/media/rc/ene_ir.c                          |  2 +-
 drivers/media/rc/fintek-cir.c                      |  4 +-
 drivers/media/rc/ite-cir.c                         |  4 +-
 drivers/media/rc/nuvoton-cir.c                     | 11 ++----
 drivers/media/rc/nuvoton-cir.h                     |  1 -
 drivers/media/tuners/max2165.c                     |  2 +-
 drivers/media/tuners/tua9001.c                     |  2 +-
 drivers/media/usb/au0828/au0828-cards.c            |  2 +-
 drivers/media/usb/au0828/au0828-dvb.c              |  5 +--
 drivers/media/usb/au0828/au0828-video.c            | 16 ++++----
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |  9 +----
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  8 ++--
 drivers/media/usb/cx231xx/cx231xx-i2c.c            |  4 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        | 14 +++----
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |  2 +-
 drivers/media/usb/dvb-usb-v2/usb_urb.c             |  8 ++--
 drivers/media/usb/dvb-usb/az6027.c                 | 11 +++---
 drivers/media/usb/dvb-usb/vp702x.c                 |  8 ++--
 drivers/media/usb/em28xx/em28xx-cards.c            |  2 +-
 drivers/media/usb/gspca/gspca.c                    |  3 +-
 drivers/media/usb/gspca/gspca.h                    |  2 +-
 drivers/media/usb/gspca/jeilinj.c                  |  6 +--
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |  4 +-
 drivers/media/usb/pwc/pwc-if.c                     |  8 +++-
 drivers/media/usb/s2255/s2255drv.c                 |  2 +-
 drivers/media/usb/tlg2300/pd-video.c               |  4 +-
 drivers/media/usb/usbvision/usbvision.h            |  2 +-
 drivers/media/usb/zr364xx/zr364xx.c                |  3 +-
 drivers/media/v4l2-core/v4l2-common.c              |  3 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |  4 +-
 drivers/staging/media/go7007/go7007-v4l2.c         |  2 +-
 111 files changed, 340 insertions(+), 335 deletions(-)

-- 
1.7.11.7

