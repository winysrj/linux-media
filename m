Return-path: <linux-media-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41737 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752070AbdDNIfV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 04:35:21 -0400
Date: Fri, 14 Apr 2017 10:35:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Ming Lin <ming.l@ssi.samsung.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org,
        open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        Steve Wise <swise@opengridcomputing.com>,
        Stephen Bates <sbates@raithlin.com>
Subject: Re: [PATCH 01/22] scatterlist: Introduce sg_map helper functions
Message-ID: <20170414083518.GA25471@lst.de>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com> <1492121135-4437-2-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1492121135-4437-2-git-send-email-logang@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 0007b79..b95934b 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -37,6 +37,9 @@
>  
>  #include <uapi/linux/dma-buf.h>
>  
> +/* Prevent the highmem.h macro from aliasing ops->kunmap_atomic */
> +#undef kunmap_atomic
> +
>  static inline int is_dma_buf_file(struct file *);
>  
>  struct dma_buf_list {

I think the right fix here is to rename the operation to unmap_atomic
and send out a little patch for that ASAP.

> + *   Flags can be any of:
> + *	* SG_KMAP	 - Use kmap to create the mapping
> + *	* SG_KMAP_ATOMIC - Use kmap_atomic to map the page atommically.
> + *			   Thus, the rules of that function apply: the cpu
> + *			   may not sleep until it is unmaped.
> + *
> + *   Also, consider carefully whether this function is appropriate. It is
> + *   largely not recommended for new code and if the sgl came from another
> + *   subsystem and you don't know what kind of memory might be in the list
> + *   then you definitely should not call it. Non-mappable memory may be in
> + *   the sgl and thus this function may fail unexpectedly.
> + **/
> +static inline void *sg_map_offset(struct scatterlist *sg, size_t offset,
> +				   int flags)

I'd rather have separate functions for kmap vs kmap_atomic instead of
the flags parameter.  And while you're at it just always pass the 0
offset parameter instead of adding a wrapper..

Otherwise this looks good to me.
