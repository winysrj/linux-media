Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:36715 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938586AbdD0P1x (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 11:27:53 -0400
Date: Thu, 27 Apr 2017 09:27:20 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Logan Gunthorpe <logang@deltatee.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@ml01.01.org,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, target-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dm-devel@redhat.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Stephen Bates <sbates@raithlin.com>
Subject: Re: [PATCH v2 01/21] scatterlist: Introduce sg_map helper functions
Message-ID: <20170427152720.GA7662@obsidianresearch.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-2-git-send-email-logang@deltatee.com>
 <20170426074416.GA7936@lst.de>
 <4736d44e-bbcf-5d59-a1a9-317d0f4da847@deltatee.com>
 <20170427065338.GA20677@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170427065338.GA20677@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 27, 2017 at 08:53:38AM +0200, Christoph Hellwig wrote:

> > The main difficulty we
> > have now is that neither of those functions are expected to fail and we
> > need them to be able to in cases where the page doesn't map to system
> > RAM. This patch series is trying to address it for users of scatterlist.
> > I'm certainly open to other suggestions.
> 
> I think you'll need to follow the existing kmap semantics and never
> fail the iomem version either.  Otherwise you'll have a special case
> that's almost never used that has a different error path.

How about first switching as many call sites as possible to use
sg_copy_X_buffer instead of kmap?

A random audit of Logan's series suggests this is actually a fairly
common thing.

eg drivers/mmc/host/sdhci.c is only doing this:

                                        buffer = sdhci_kmap_atomic(sg, &flags);
                                        memcpy(buffer, align, size);
                                        sdhci_kunmap_atomic(buffer, &flags);

drivers/scsi/mvsas/mv_sas.c is this:

+			to = sg_map(sg_resp, 0, SG_KMAP_ATOMIC);
+			memcpy(to,
+			       slot->response + sizeof(struct mvs_err_info),
+			       sg_dma_len(sg_resp));
+			sg_unmap(sg_resp, to, 0, SG_KMAP_ATOMIC);

etc.

Lots of other places seem similar, if not sometimes a little bit more
convoluted..

Switching all the trivial cases to use copy might bring more clarity
as to what is actually required for the remaining few users? If there
are only a few then it may no longer matter if the API is not idyllic.

Jason
