Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:53360 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423300AbdD0WLx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 18:11:53 -0400
Date: Thu, 27 Apr 2017 16:11:32 -0600
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
Message-ID: <20170427221132.GA30036@obsidianresearch.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-16-git-send-email-logang@deltatee.com>
 <20170426073720.okv33ly2ldepilti@dhcp-3-128.uk.xensource.com>
 <df6586e2-7d45-6b0b-facb-4dea882df06e@deltatee.com>
 <20170427205339.GB26330@obsidianresearch.com>
 <02ba3c7b-5fab-a06c-fbbf-c3be1c0fae1b@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02ba3c7b-5fab-a06c-fbbf-c3be1c0fae1b@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 27, 2017 at 03:53:37PM -0600, Logan Gunthorpe wrote:
> On 27/04/17 02:53 PM, Jason Gunthorpe wrote:
> > blkfront is one of the drivers I looked at, and it appears to only be
> > memcpying with the bvec_data pointer, so I wonder why it does not use
> > sg_copy_X_buffer instead..
> 
> But you'd potentially end up calling sg_copy_to_buffer multiple times
> per page within the sg (given that gnttab_foreach_grant_in_range might
> call blkif_copy_from_grant/blkif_setup_rw_req_grant multiple times).
> Even calling sg_copy_to_buffer once per page seems rather inefficient as
> it uses sg_miter internally.

Well, that is in the current form, with more users it would make sense
to optimize for the single page case, eg by providing the existing
call, providing a faster single-page-only variant of the copy, perhaps
even one that is inlined.

> Switching the for_each_sg to sg_miter is probably the nicer solution as
> it takes care of the mapping and the offset/length accounting for you
> and will have similar performance.

sg_miter will still fail when the sg contains __iomem, however I would
expect that the sg_copy will work with iomem, by using the __iomem
memcpy variant.

So, sg_copy should always be preferred in this new world with mixed
__iomem since it is the only primitive that can transparently handle
it.

Jason
