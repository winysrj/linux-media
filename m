Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:65399 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932539AbcJQWFF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 18:05:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        x86@kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-mtd@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ceph-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-ext4@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH 00/28] Reenable maybe-uninitialized warnings
Date: Tue, 18 Oct 2016 00:03:28 +0200
Message-Id: <20161017220342.1627073-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a set of patches that I hope to get into v4.9 in some form
in order to turn on the -Wmaybe-uninitialized warnings again.

After talking to Linus in person at Linaro Connect about this, I
spent some time on finding all the remaining warnings, and this
is the resulting patch series. More details are in the description
of the last patch that actually enables the warning.

Let me know if there are other warnings that I missed, and whether
you think these are still appropriate for v4.9 or not.
A couple of patches are non-obvious, and could use some more
detailed review.

	Arnd

Arnd Bergmann (28):
  [v2] netfilter: nf_tables: avoid uninitialized variable warning
  [v2] mtd: mtk: avoid warning in mtk_ecc_encode
  [v2] infiniband: shut up a maybe-uninitialized warning
  f2fs: replace a build-time warning with runtime WARN_ON
  ext2: avoid bogus -Wmaybe-uninitialized warning
  NFSv4.1: work around -Wmaybe-uninitialized warning
  ceph: avoid false positive maybe-uninitialized warning
  staging: lustre: restore initialization of return code
  staging: lustre: remove broken dead code in
    cfs_cpt_table_create_pattern
  UBI: fix uninitialized access of vid_hdr pointer
  block: rdb: false-postive gcc-4.9 -Wmaybe-uninitialized
  [media] rc: print correct variable for z8f0811
  [media] dib0700: fix uninitialized data on 'repeat' event
  iio: accel: sca3000_core: avoid potentially uninitialized variable
  crypto: aesni: avoid -Wmaybe-uninitialized warning
  pcmcia: fix return value of soc_pcmcia_regulator_set
  spi: fsl-espi: avoid processing uninitalized data on error
  drm: avoid uninitialized timestamp use in wait_vblank
  brcmfmac: avoid maybe-uninitialized warning in brcmf_cfg80211_start_ap
  net: bcm63xx: avoid referencing uninitialized variable
  net/hyperv: avoid uninitialized variable
  x86: apm: avoid uninitialized data
  x86: mark target address as output in 'insb' asm
  x86: math-emu: possible uninitialized variable use
  s390: pci: don't print uninitialized data for debugging
  nios2: fix timer initcall return value
  rocker: fix maybe-uninitialized warning
  Kbuild: bring back -Wmaybe-uninitialized warning

 Makefile                                           |  10 +-
 arch/arc/Makefile                                  |   4 +-
 arch/nios2/kernel/time.c                           |   1 +
 arch/s390/pci/pci_dma.c                            |   2 +-
 arch/x86/crypto/aesni-intel_glue.c                 | 121 +++++++++++++--------
 arch/x86/include/asm/io.h                          |   4 +-
 arch/x86/kernel/apm_32.c                           |   5 +-
 arch/x86/math-emu/Makefile                         |   4 +-
 arch/x86/math-emu/reg_compare.c                    |  16 +--
 drivers/block/rbd.c                                |   1 +
 drivers/gpu/drm/drm_irq.c                          |   4 +-
 drivers/infiniband/core/cma.c                      |  56 +++++-----
 drivers/media/i2c/ir-kbd-i2c.c                     |   2 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |  10 +-
 drivers/mtd/nand/mtk_ecc.c                         |  19 ++--
 drivers/mtd/ubi/eba.c                              |   2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |   3 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |   4 +-
 drivers/net/hyperv/netvsc_drv.c                    |   2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   2 +-
 drivers/pcmcia/soc_common.c                        |   2 +-
 drivers/spi/spi-fsl-espi.c                         |   2 +-
 drivers/staging/iio/accel/sca3000_core.c           |   2 +
 .../staging/lustre/lnet/libcfs/linux/linux-cpu.c   |   7 --
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   2 +
 fs/ceph/super.c                                    |   3 +-
 fs/ext2/inode.c                                    |   7 +-
 fs/f2fs/data.c                                     |   7 ++
 fs/nfs/nfs4session.c                               |  10 +-
 net/netfilter/nft_range.c                          |  10 +-
 scripts/Makefile.ubsan                             |   4 +
 31 files changed, 187 insertions(+), 141 deletions(-)

-- 
Cc: x86@kernel.org
Cc: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mtd@lists.infradead.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ceph-devel@vger.kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-ext4@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
2.9.0

