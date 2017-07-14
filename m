Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:52061 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdGNJ0y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:26:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/14] gcc-7 warnings
Date: Fri, 14 Jul 2017 11:25:12 +0200
Message-Id: <20170714092540.1217397-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series should shut up all warnings introduced by gcc-6 or gcc-7 on
today's linux-next, as observed in "allmodconfig" builds on x86,
arm and arm64.

I have sent some of these before, but some others are new, as I had
at some point disabled the -Wint-in-bool-context warning in my
randconfig testing and did not notice the other warnings.

I have another series to address all -Wformat-overflow warnings,
and one more patch to turn off the -Wformat-truncation warnings
unless we build with "make W=1". I'll send that separately.

Most of these are consist of trivial refactoring of the code to
shut up false-positive warnings, the one exception being
"staging:iio:resolver:ad2s1210 fix negative IIO_ANGL_VEL read",
which fixes a regression against linux-3.1 that has gone
unnoticed since then. Still, review from subsystem maintainers
would be appreciated.

I would suggest that Andrew Morton can pick these up into linux-mm
so we can make sure they all make it into the release. Alternatively
Linus might feel like picking them all up himself.

While I did not mark the harmless ones for stable backports,
Greg may also want to pick them up once they go upstream, to
help build-test the stable kernels with gcc-7.

      Arnd

Arnd Bergmann (14):
  [SUBMITTED 20170511] ide: avoid warning for timings calculation
  [SUBMITTED 20170511] ata: avoid gcc-7 warning in ata_timing_quantize
  [SUBMITTED 20170314] drm/vmwgfx: avoid gcc-7 parentheses warning
  x86: math-emu: avoid -Wint-in-bool-context warning
  isdn: isdnloop: suppress a gcc-7 warning
  acpi: thermal: fix gcc-6/ccache warning
  proc/kcore: hide a harmless warning
  Input: adxl34x - fix gcc-7 -Wint-in-bool-context warning
  SFI: fix tautological-compare warning
  staging:iio:resolver:ad2s1210 fix negative IIO_ANGL_VEL read
  IB/uverbs: fix gcc-7 type warning
  drm/nouveau/clk: fix gcc-7 -Wint-in-bool-context warning
  iopoll: avoid -Wint-in-bool-context warning
  [media] fix warning on v4l2_subdev_call() result interpreted as bool

 arch/x86/math-emu/fpu_emu.h                          |  2 +-
 drivers/acpi/processor_thermal.c                     |  6 ++++--
 drivers/ata/libata-core.c                            | 20 ++++++++++----------
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/gt215.c      |  6 +++---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c              |  2 +-
 drivers/ide/ide-timings.c                            | 18 +++++++++---------
 drivers/infiniband/core/uverbs.h                     | 14 ++++++++------
 drivers/input/misc/adxl34x.c                         |  2 +-
 drivers/isdn/isdnloop/isdnloop.c                     |  2 +-
 drivers/media/pci/cx18/cx18-ioctl.c                  |  6 ++++--
 drivers/media/pci/saa7146/mxb.c                      |  5 +++--
 drivers/media/platform/atmel/atmel-isc.c             |  4 ++--
 drivers/media/platform/atmel/atmel-isi.c             |  4 ++--
 drivers/media/platform/blackfin/bfin_capture.c       |  4 ++--
 drivers/media/platform/omap3isp/ispccdc.c            |  5 +++--
 drivers/media/platform/pxa_camera.c                  |  3 ++-
 drivers/media/platform/rcar-vin/rcar-core.c          |  2 +-
 drivers/media/platform/rcar-vin/rcar-dma.c           |  4 +++-
 drivers/media/platform/soc_camera/soc_camera.c       |  4 ++--
 drivers/media/platform/stm32/stm32-dcmi.c            |  4 ++--
 drivers/media/platform/ti-vpe/cal.c                  |  6 ++++--
 drivers/sfi/sfi_core.c                               |  9 ++++++---
 drivers/staging/iio/resolver/ad2s1210.c              |  2 +-
 .../staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 13 +++++++------
 fs/proc/kcore.c                                      | 10 ++++++----
 include/linux/iopoll.h                               |  6 ++++--
 include/linux/regmap.h                               |  2 +-
 27 files changed, 93 insertions(+), 72 deletions(-)

-- 
2.9.0
