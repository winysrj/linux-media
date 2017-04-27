Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:57048 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755443AbdD0P6Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 11:58:16 -0400
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Christoph Hellwig <hch@lst.de>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-2-git-send-email-logang@deltatee.com>
 <20170426074416.GA7936@lst.de>
 <4736d44e-bbcf-5d59-a1a9-317d0f4da847@deltatee.com>
 <20170427065338.GA20677@lst.de> <20170427152720.GA7662@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
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
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <cb1ed262-110b-2a6c-f9da-e41c2fc0969d@deltatee.com>
Date: Thu, 27 Apr 2017 09:57:58 -0600
MIME-Version: 1.0
In-Reply-To: <20170427152720.GA7662@obsidianresearch.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 01/21] scatterlist: Introduce sg_map helper functions
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 27/04/17 09:27 AM, Jason Gunthorpe wrote:
> On Thu, Apr 27, 2017 at 08:53:38AM +0200, Christoph Hellwig wrote:
> How about first switching as many call sites as possible to use
> sg_copy_X_buffer instead of kmap?

Yeah, I could look at doing that first.

One problem is we might get more Naks of the form of Herbert Xu's who
might be concerned with the performance implications.

These are definitely a bit more invasive changes than thin wrappers
around kmap calls.

> A random audit of Logan's series suggests this is actually a fairly
> common thing.

It's not _that_ common but there are a significant fraction. One of my
patches actually did this to two places that seemed to be reimplementing
the sg_copy_X_buffer logic.

Thanks,

Logan
