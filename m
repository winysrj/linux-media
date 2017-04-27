Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:58237 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936373AbdD0VyC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 17:54:02 -0400
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-16-git-send-email-logang@deltatee.com>
 <20170426073720.okv33ly2ldepilti@dhcp-3-128.uk.xensource.com>
 <df6586e2-7d45-6b0b-facb-4dea882df06e@deltatee.com>
 <20170427205339.GB26330@obsidianresearch.com>
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
Message-ID: <02ba3c7b-5fab-a06c-fbbf-c3be1c0fae1b@deltatee.com>
Date: Thu, 27 Apr 2017 15:53:37 -0600
MIME-Version: 1.0
In-Reply-To: <20170427205339.GB26330@obsidianresearch.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 15/21] xen-blkfront: Make use of the new sg_map helper
 function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 27/04/17 02:53 PM, Jason Gunthorpe wrote:
> blkfront is one of the drivers I looked at, and it appears to only be
> memcpying with the bvec_data pointer, so I wonder why it does not use
> sg_copy_X_buffer instead..

Yes, sort of...

But you'd potentially end up calling sg_copy_to_buffer multiple times
per page within the sg (given that gnttab_foreach_grant_in_range might
call blkif_copy_from_grant/blkif_setup_rw_req_grant multiple times).
Even calling sg_copy_to_buffer once per page seems rather inefficient as
it uses sg_miter internally.

Switching the for_each_sg to sg_miter is probably the nicer solution as
it takes care of the mapping and the offset/length accounting for you
and will have similar performance.

But, yes, if performance is not an issue, switching it to
sg_copy_to_buffer would be a less invasive change than sg_miter. Which
the same might be said about a lot of these cases.

Unfortunately, changing from kmap_atomic (which is a null operation in a
lot of cases) to sg_copy_X_buffer is a pretty big performance hit.

Logan
