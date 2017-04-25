Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49746 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1952036AbdDYSVX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 14:21:23 -0400
From: Logan Gunthorpe <logang@deltatee.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, target-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dm-devel@redhat.com
Cc: Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date: Tue, 25 Apr 2017 12:20:47 -0600
Message-Id: <1493144468-22493-1-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 00/21] Introduce common scatterlist map function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1:

* Rebased onto next-20170424
* Removed the _offset version of these functions per Christoph's
  suggestion
* Added an SG_MAP_MUST_NOT_FAIL flag which will BUG_ON in future cases
  that can't gracefully fail. This removes a bunch of the noise added
  in v1 to a couple of the drivers. (Per David Laight's suggestion)
  This flag is only meant for old code
* Split the libiscsi patch into two (per Christoph's suggestion)
  the prep patch (patch 2 in this series) has already been
  sent separately
* Fixed a locking mistake in the target patch (pointed out by a bot)
* Dropped the nvmet patch and handled it with a different patch
  that has been sent separately
* Dropped the chcr patch as they have already removed the code that
  needed to be changed

I'm still hoping to only get Patch 1 in the series merged. (Any
volunteers?) I'm willing to chase down the maintainers for the remaining
patches separately after the first patch is in.

The patchset is based on next-20170424 and can be found in the sg_map_v2
branch from this git tree:

https://github.com/sbates130272/linux-p2pmem.git

--

Hi Everyone,

As part of my effort to enable P2P DMA transactions with PCI cards,
we've identified the need to be able to safely put IO memory into
scatterlists (and eventually other spots). This probably involves a
conversion from struct page to pfn_t but that migration is a ways off
and those decisions are yet to be made.

As an initial step in that direction, I've started cleaning up some of the
scatterlist code by trying to carve out a better defined layer between it
and it's users. The longer term goal would be to remove sg_page or replace
it with something that can potentially fail.

This patchset is the first step in that effort. I've introduced
a common function to map scatterlist memory and converted all the common
kmap(sg_page()) cases. This removes about 66 sg_page calls (of ~331).

Seeing this is a fairly large cleanup set that touches a wide swath of
the kernel I have limited the people I've sent this to. I'd suggest we look
toward merging the first patch and then I can send the individual subsystem
patches on to their respective maintainers and get them merged
independantly. (This is to avoid the conflicts I created with my last
cleanup set... Sorry) Though, I'm certainly open to other suggestions to get
it merged.

Logan Gunthorpe (21):
  scatterlist: Introduce sg_map helper functions
  libiscsi: Add an internal error code
  libiscsi: Make use of new the sg_map helper function
  target: Make use of the new sg_map function at 16 call sites
  drm/i915: Make use of the new sg_map helper function
  crypto: hifn_795x: Make use of the new sg_map helper function
  crypto: shash, caam: Make use of the new sg_map helper function
  dm-crypt: Make use of the new sg_map helper in 4 call sites
  staging: unisys: visorbus: Make use of the new sg_map helper function
  RDS: Make use of the new sg_map helper function
  scsi: ipr, pmcraid, isci: Make use of the new sg_map helper
  scsi: hisi_sas, mvsas, gdth: Make use of the new sg_map helper
    function
  scsi: arcmsr, ips, megaraid: Make use of the new sg_map helper
    function
  scsi: libfc, csiostor: Change to sg_copy_buffer in two drivers
  xen-blkfront: Make use of the new sg_map helper function
  mmc: sdhci: Make use of the new sg_map helper function
  mmc: spi: Make use of the new sg_map helper function
  mmc: tmio: Make use of the new sg_map helper function
  mmc: sdricoh_cs: Make use of the new sg_map helper function
  mmc: tifm_sd: Make use of the new sg_map helper function
  memstick: Make use of the new sg_map helper function

 crypto/shash.c                                  |   9 ++-
 drivers/block/xen-blkfront.c                    |  20 ++---
 drivers/crypto/caam/caamalg.c                   |   8 +-
 drivers/crypto/hifn_795x.c                      |  32 +++++---
 drivers/gpu/drm/i915/i915_gem.c                 |  27 ++++---
 drivers/md/dm-crypt.c                           |  39 ++++++---
 drivers/memstick/host/jmb38x_ms.c               |  11 +--
 drivers/memstick/host/tifm_ms.c                 |  11 +--
 drivers/mmc/host/mmc_spi.c                      |  26 ++++--
 drivers/mmc/host/sdhci.c                        |  14 ++--
 drivers/mmc/host/sdricoh_cs.c                   |  14 ++--
 drivers/mmc/host/tifm_sd.c                      |  50 +++++++-----
 drivers/mmc/host/tmio_mmc.h                     |   7 +-
 drivers/mmc/host/tmio_mmc_pio.c                 |  12 +++
 drivers/scsi/arcmsr/arcmsr_hba.c                |  16 +++-
 drivers/scsi/csiostor/csio_scsi.c               |  54 +------------
 drivers/scsi/cxgbi/libcxgbi.c                   |   5 ++
 drivers/scsi/gdth.c                             |   9 ++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c          |  14 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c          |  13 ++-
 drivers/scsi/ipr.c                              |  27 ++++---
 drivers/scsi/ips.c                              |   8 +-
 drivers/scsi/isci/request.c                     |  42 ++++++----
 drivers/scsi/libfc/fc_libfc.c                   |  49 +++--------
 drivers/scsi/libiscsi_tcp.c                     |  32 +++++---
 drivers/scsi/megaraid.c                         |   9 ++-
 drivers/scsi/mvsas/mv_sas.c                     |  10 +--
 drivers/scsi/pmcraid.c                          |  19 +++--
 drivers/staging/unisys/visorhba/visorhba_main.c |  12 +--
 drivers/target/iscsi/iscsi_target.c             |  29 ++++---
 drivers/target/target_core_rd.c                 |   3 +-
 drivers/target/target_core_sbc.c                | 103 +++++++++++++++---------
 drivers/target/target_core_transport.c          |  18 +++--
 drivers/target/target_core_user.c               |  45 ++++++++---
 include/linux/scatterlist.h                     |  85 +++++++++++++++++++
 include/scsi/libiscsi_tcp.h                     |   3 +-
 include/target/target_core_backend.h            |   4 +-
 net/rds/ib_recv.c                               |   8 +-
 38 files changed, 553 insertions(+), 344 deletions(-)

--
2.1.4
