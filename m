Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.189]:53260 "EHLO
        smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdDROOR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 10:14:17 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: 'Logan Gunthorpe' <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Ming Lin <ming.l@ssi.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>,
        "sparmaintainer@unisys.com" <sparmaintainer@unisys.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>
CC: Steve Wise <swise@opengridcomputing.com>,
        Stephen Bates <sbates@raithlin.com>
Subject: RE: [PATCH 16/22] xen-blkfront: Make use of the new sg_map helper
 function
Date: Tue, 18 Apr 2017 14:13:59 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DCFFD3CD7@AcuExch.aculab.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-17-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-17-git-send-email-logang@deltatee.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Logan Gunthorpe
> Sent: 13 April 2017 23:05
> Straightforward conversion to the new helper, except due to
> the lack of error path, we have to warn if unmapable memory
> is ever present in the sgl.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  drivers/block/xen-blkfront.c | 33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 5067a0a..7dcf41d 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -807,8 +807,19 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
>  		BUG_ON(sg->offset + sg->length > PAGE_SIZE);
> 
>  		if (setup.need_copy) {
> -			setup.bvec_off = sg->offset;
> -			setup.bvec_data = kmap_atomic(sg_page(sg));
> +			setup.bvec_off = 0;
> +			setup.bvec_data = sg_map(sg, SG_KMAP_ATOMIC);
> +			if (IS_ERR(setup.bvec_data)) {
> +				/*
> +				 * This should really never happen unless
> +				 * the code is changed to use memory that is
> +				 * not mappable in the sg. Seeing there is a
> +				 * questionable error path out of here,
> +				 * we WARN.
> +				 */
> +				WARN(1, "Non-mappable memory used in sg!");
> +				return 1;
> +			}
...

Perhaps add a flag to mark failure as 'unexpected' and trace (and panic?)
inside sg_map().

	David
