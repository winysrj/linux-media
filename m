Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:58463 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754713AbdD0XEH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 19:04:07 -0400
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-16-git-send-email-logang@deltatee.com>
 <20170426073720.okv33ly2ldepilti@dhcp-3-128.uk.xensource.com>
 <df6586e2-7d45-6b0b-facb-4dea882df06e@deltatee.com>
 <20170427205339.GB26330@obsidianresearch.com>
 <02ba3c7b-5fab-a06c-fbbf-c3be1c0fae1b@deltatee.com>
 <20170427221132.GA30036@obsidianresearch.com>
Cc: =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
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
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <3a7c0d27-0744-4e91-b37f-3885c50455e8@deltatee.com>
Date: Thu, 27 Apr 2017 17:03:45 -0600
MIME-Version: 1.0
In-Reply-To: <20170427221132.GA30036@obsidianresearch.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 15/21] xen-blkfront: Make use of the new sg_map helper
 function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 27/04/17 04:11 PM, Jason Gunthorpe wrote:
> On Thu, Apr 27, 2017 at 03:53:37PM -0600, Logan Gunthorpe wrote:
> Well, that is in the current form, with more users it would make sense
> to optimize for the single page case, eg by providing the existing
> call, providing a faster single-page-only variant of the copy, perhaps
> even one that is inlined.

Ok, does it make sense then to have an sg_copy_page_to_buffer (or some
such... I'm having trouble thinking of a sane name that isn't too long).
That just does k(un)map_atomic and memcpy? I could try that if it makes
sense to people.

>> Switching the for_each_sg to sg_miter is probably the nicer solution as
>> it takes care of the mapping and the offset/length accounting for you
>> and will have similar performance.
> 
> sg_miter will still fail when the sg contains __iomem, however I would
> expect that the sg_copy will work with iomem, by using the __iomem
> memcpy variant.

Yes, that's true. Any sg_miters that ever see iomem will need to be
converted to support it. This isn't much different than the other
kmap(sg_page()) users I was converting that will also fail if they see
iomem. Though, I suspect an sg_miter user would be easier to convert to
iomem than a random kmap user.

Logan
