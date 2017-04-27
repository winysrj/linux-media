Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:52619 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968478AbdD0UyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 16:54:10 -0400
Date: Thu, 27 Apr 2017 14:53:39 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@ml01.01.org,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, target-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20170427205339.GB26330@obsidianresearch.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-16-git-send-email-logang@deltatee.com>
 <20170426073720.okv33ly2ldepilti@dhcp-3-128.uk.xensource.com>
 <df6586e2-7d45-6b0b-facb-4dea882df06e@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df6586e2-7d45-6b0b-facb-4dea882df06e@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 27, 2017 at 02:19:24PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 26/04/17 01:37 AM, Roger Pau Monné wrote:
> > On Tue, Apr 25, 2017 at 12:21:02PM -0600, Logan Gunthorpe wrote:
> >> Straightforward conversion to the new helper, except due to the lack
> >> of error path, we have to use SG_MAP_MUST_NOT_FAIL which may BUG_ON in
> >> certain cases in the future.
> >>
> >> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> >> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> >> Cc: Juergen Gross <jgross@suse.com>
> >> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> Cc: "Roger Pau Monné" <roger.pau@citrix.com>
> >>  drivers/block/xen-blkfront.c | 20 +++++++++++---------
> >>  1 file changed, 11 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> >> index 3945963..ed62175 100644
> >> +++ b/drivers/block/xen-blkfront.c
> >> @@ -816,8 +816,9 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
> >>  		BUG_ON(sg->offset + sg->length > PAGE_SIZE);
> >>  
> >>  		if (setup.need_copy) {
> >> -			setup.bvec_off = sg->offset;
> >> -			setup.bvec_data = kmap_atomic(sg_page(sg));
> >> +			setup.bvec_off = 0;
> >> +			setup.bvec_data = sg_map(sg, 0, SG_KMAP_ATOMIC |
> >> +						 SG_MAP_MUST_NOT_FAIL);
> > 
> > I assume that sg_map already adds sg->offset to the address?
> 
> Correct.
> 
> > Also wondering whether we can get rid of bvec_off and just increment bvec_data,
> > adding Julien who IIRC added this code.
> 
> bvec_off is used to keep track of the offset within the current mapping
> so it's not a great idea given that you'd want to kunmap_atomic the
> original address and not something with an offset. It would be nice if
> this could be converted to use the sg_miter interface but that's a much
> more invasive change that would require someone who knows this code and
> can properly test it. I'd be very grateful if someone actually took that on.

blkfront is one of the drivers I looked at, and it appears to only be
memcpying with the bvec_data pointer, so I wonder why it does not use
sg_copy_X_buffer instead..

Jason
