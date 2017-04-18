Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22288 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753493AbdDRPvj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 11:51:39 -0400
Date: Tue, 18 Apr 2017 11:50:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        xen-devel@lists.xensource.com, Christoph Hellwig <hch@lst.de>,
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
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>,
        "sparmaintainer@unisys.com" <sparmaintainer@unisys.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH 16/22] xen-blkfront: Make use of the new sg_map helper
 function
Message-ID: <20170418155020.GF12001@char.us.oracle.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-17-git-send-email-logang@deltatee.com>
 <063D6719AE5E284EB5DD2968C1650D6DCFFD3CD7@AcuExch.aculab.com>
 <20170418142723.GA27133@char.us.oracle.com>
 <7930aa93-6106-e12f-ba76-e2771d4ec2dc@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7930aa93-6106-e12f-ba76-e2771d4ec2dc@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 18, 2017 at 09:42:20AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 18/04/17 08:27 AM, Konrad Rzeszutek Wilk wrote:
> > Interesting that you didn't CC any of the maintainers. Could you 
> > do that in the future please?
> 
> Please read the cover letter. The distribution list for the patchset
> would have been way too large to cc every maintainer (even as limited as
> it was, I had mailing lists yelling at me). My plan was to get buy in

I am not sure if you know, but you can add on each patch the respective
maintainer via 'CC'. That way you can have certain maintainers CCed only
on the subsystems they cover. You put it after (or before) your SoB and
git send-email happilly picks it up.

It does mean that for every patch you have to run something like this:

$ more add_cc 
#!/bin/bash

git diff HEAD^.. > /tmp/a
echo "---"
scripts/get_maintainer.pl --no-l /tmp/a | while read file
do
    echo "Cc: $file"
done

Or such.


> for the first patch, get it merged and resend the rest independently to
> their respective maintainers. Of course, though, I'd be open to other
> suggestions.
> 
> >>>
> >>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> >>> ---
> >>>  drivers/block/xen-blkfront.c | 33 +++++++++++++++++++++++++++------
> >>>  1 file changed, 27 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> >>> index 5067a0a..7dcf41d 100644
> >>> --- a/drivers/block/xen-blkfront.c
> >>> +++ b/drivers/block/xen-blkfront.c
> >>> @@ -807,8 +807,19 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
> >>>  		BUG_ON(sg->offset + sg->length > PAGE_SIZE);
> >>>
> >>>  		if (setup.need_copy) {
> >>> -			setup.bvec_off = sg->offset;
> >>> -			setup.bvec_data = kmap_atomic(sg_page(sg));
> >>> +			setup.bvec_off = 0;
> >>> +			setup.bvec_data = sg_map(sg, SG_KMAP_ATOMIC);
> >>> +			if (IS_ERR(setup.bvec_data)) {
> >>> +				/*
> >>> +				 * This should really never happen unless
> >>> +				 * the code is changed to use memory that is
> >>> +				 * not mappable in the sg. Seeing there is a
> >>> +				 * questionable error path out of here,
> >>> +				 * we WARN.
> >>> +				 */
> >>> +				WARN(1, "Non-mappable memory used in sg!");
> >>> +				return 1;
> >>> +			}
> >> ...
> >>
> >> Perhaps add a flag to mark failure as 'unexpected' and trace (and panic?)
> >> inside sg_map().
> 
> Thanks, that's a good suggestion. I'll make the change for v2.
> 
> Logan
