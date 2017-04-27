Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:56967 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937587AbdD0Poe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 11:44:34 -0400
To: Christoph Hellwig <hch@lst.de>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-2-git-send-email-logang@deltatee.com>
 <20170426074416.GA7936@lst.de>
 <4736d44e-bbcf-5d59-a1a9-317d0f4da847@deltatee.com>
 <20170427065338.GA20677@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org,
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
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <3b7f3aba-d609-dca7-149f-107757d63fb0@deltatee.com>
Date: Thu, 27 Apr 2017 09:44:18 -0600
MIME-Version: 1.0
In-Reply-To: <20170427065338.GA20677@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 01/21] scatterlist: Introduce sg_map helper functions
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 27/04/17 12:53 AM, Christoph Hellwig wrote:
> I think you'll need to follow the existing kmap semantics and never
> fail the iomem version either.  Otherwise you'll have a special case
> that's almost never used that has a different error path.
>
> Again, wrong way.  Suddenly making things fail for your special case
> that normally don't fail is a receipe for bugs.

I don't disagree but these restrictions make the problem impossible to
solve? If there is iomem behind a page in an SGL and someone tries to
map it, we either have to fail or we break iomem safety which was your
original concern.

Logan
