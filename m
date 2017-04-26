Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.ctxuk.citrix.com ([185.25.65.24]:8051 "EHLO
        SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1036116AbdDZHhh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 03:37:37 -0400
Date: Wed, 26 Apr 2017 08:37:20 +0100
From: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
To: Logan Gunthorpe <logang@deltatee.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-raid@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <linux-scsi@vger.kernel.org>, <open-iscsi@googlegroups.com>,
        <megaraidlinux.pdl@broadcom.com>, <sparmaintainer@unisys.com>,
        <devel@driverdev.osuosl.org>, <target-devel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Stephen Bates <sbates@raithlin.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v2 15/21] xen-blkfront: Make use of the new sg_map helper
 function
Message-ID: <20170426073720.okv33ly2ldepilti@dhcp-3-128.uk.xensource.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-16-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1493144468-22493-16-git-send-email-logang@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 25, 2017 at 12:21:02PM -0600, Logan Gunthorpe wrote:
> Straightforward conversion to the new helper, except due to the lack
> of error path, we have to use SG_MAP_MUST_NOT_FAIL which may BUG_ON in
> certain cases in the future.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: "Roger Pau Monné" <roger.pau@citrix.com>
> ---
>  drivers/block/xen-blkfront.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 3945963..ed62175 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -816,8 +816,9 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
>  		BUG_ON(sg->offset + sg->length > PAGE_SIZE);
>  
>  		if (setup.need_copy) {
> -			setup.bvec_off = sg->offset;
> -			setup.bvec_data = kmap_atomic(sg_page(sg));
> +			setup.bvec_off = 0;
> +			setup.bvec_data = sg_map(sg, 0, SG_KMAP_ATOMIC |
> +						 SG_MAP_MUST_NOT_FAIL);

I assume that sg_map already adds sg->offset to the address?

Also wondering whether we can get rid of bvec_off and just increment bvec_data,
adding Julien who IIRC added this code.

>  		}
>  
>  		gnttab_foreach_grant_in_range(sg_page(sg),
> @@ -827,7 +828,7 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
>  					      &setup);
>  
>  		if (setup.need_copy)
> -			kunmap_atomic(setup.bvec_data);
> +			sg_unmap(sg, setup.bvec_data, 0, SG_KMAP_ATOMIC);
>  	}
>  	if (setup.segments)
>  		kunmap_atomic(setup.segments);
> @@ -1053,7 +1054,7 @@ static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
>  		case XEN_SCSI_DISK5_MAJOR:
>  		case XEN_SCSI_DISK6_MAJOR:
>  		case XEN_SCSI_DISK7_MAJOR:
> -			*offset = (*minor / PARTS_PER_DISK) + 
> +			*offset = (*minor / PARTS_PER_DISK) +
>  				((major - XEN_SCSI_DISK1_MAJOR + 1) * 16) +
>  				EMULATED_SD_DISK_NAME_OFFSET;
>  			*minor = *minor +
> @@ -1068,7 +1069,7 @@ static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
>  		case XEN_SCSI_DISK13_MAJOR:
>  		case XEN_SCSI_DISK14_MAJOR:
>  		case XEN_SCSI_DISK15_MAJOR:
> -			*offset = (*minor / PARTS_PER_DISK) + 
> +			*offset = (*minor / PARTS_PER_DISK) +
>  				((major - XEN_SCSI_DISK8_MAJOR + 8) * 16) +
>  				EMULATED_SD_DISK_NAME_OFFSET;
>  			*minor = *minor +
> @@ -1119,7 +1120,7 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
>  	if (!VDEV_IS_EXTENDED(info->vdevice)) {
>  		err = xen_translate_vdev(info->vdevice, &minor, &offset);
>  		if (err)
> -			return err;		
> +			return err;

Cosmetic changes should go in a separate patch please.

Roger.
