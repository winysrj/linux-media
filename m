Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24278 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755574AbdKGBF0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Nov 2017 20:05:26 -0500
Subject: [PATCH 0/3] introduce get_user_pages_longterm()
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Sean Hefty <sean.hefty@intel.com>, Jan Kara <jack@suse.cz>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Ledford <dledford@redhat.com>, stable@vger.kernel.org,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-media@vger.kernel.org
Date: Mon, 06 Nov 2017 16:57:10 -0800
Message-ID: <151001623063.16354.14661493921524115663.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrew,

Here is a new get_user_pages api for cases where a driver intends to
keep an elevated page count indefinitely. This is distinct from usages
like iov_iter_get_pages where the elevated page counts are transient.
The iov_iter_get_pages cases immediately turn around and submit the
pages to a device driver which will put_page when the i/o operation
completes (under kernel control).

In the longterm case userspace is responsible for dropping the page
reference at some undefined point in the future. This is untenable for
filesystem-dax case where the filesystem is in control of the lifetime
of the block / page and needs reasonable limits on how long it can wait
for pages in a mapping to become idle.

Fixing filesystems to actually wait for dax pages to be idle before
blocks from a truncate/hole-punch operation are repurposed is saved for
a later patch series.

Also, allowing longterm registration of dax mappings is a future patch
series that introduces a "map with lease" semantic where the kernel can
revoke a lease and force userspace to drop its page references.

I have also tagged these for -stable to purposely break cases that might
assume that longterm memory registrations for filesystem-dax mappings
were supported by the kernel. The behavior regression this policy change
implies is one of the reasons we maintain the "dax enabled. Warning:
EXPERIMENTAL, use at your own risk" notification when mounting a
filesystem in dax mode.

It is worth noting the device-dax interface does not suffer the same
constraints since it does not support file space management operations
like hole-punch.

---

Dan Williams (3):
      mm: introduce get_user_pages_longterm
      IB/core: disable memory registration of fileystem-dax vmas
      [media] v4l2: disable filesystem-dax mapping support


 drivers/infiniband/core/umem.c            |    2 -
 drivers/media/v4l2-core/videobuf-dma-sg.c |    5 +-
 include/linux/mm.h                        |    3 +
 mm/gup.c                                  |   75 +++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 3 deletions(-)
