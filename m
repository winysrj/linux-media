Return-path: <linux-media-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39343 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1432475AbdDZHoU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 03:44:20 -0400
Date: Wed, 26 Apr 2017 09:44:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org,
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
        Stephen Bates <sbates@raithlin.com>
Subject: Re: [PATCH v2 01/21] scatterlist: Introduce sg_map helper functions
Message-ID: <20170426074416.GA7936@lst.de>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com> <1493144468-22493-2-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1493144468-22493-2-git-send-email-logang@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 25, 2017 at 12:20:48PM -0600, Logan Gunthorpe wrote:
> This patch introduces functions which kmap the pages inside an sgl.
> These functions replace a common pattern of kmap(sg_page(sg)) that is
> used in more than 50 places within the kernel.
> 
> The motivation for this work is to eventually safely support sgls that
> contain io memory. In order for that to work, any access to the contents
> of an iomem SGL will need to be done with iomemcpy or hit some warning.
> (The exact details of how this will work have yet to be worked out.)

I think we'll at least need a draft of those to make sense of these
patches.  Otherwise they just look very clumsy.

> + *   Use this function to map a page in the scatterlist at the specified
> + *   offset. sg->offset is already added for you. Note: the semantics of
> + *   this function are that it may fail. Thus, its output should be checked
> + *   with IS_ERR and PTR_ERR. Otherwise, a pointer to the specified offset
> + *   in the mapped page is returned.
> + *
> + *   Flags can be any of:
> + *	* SG_KMAP		- Use kmap to create the mapping
> + *	* SG_KMAP_ATOMIC	- Use kmap_atomic to map the page atommically.
> + *				  Thus, the rules of that function apply: the
> + *				  cpu may not sleep until it is unmaped.
> + *	* SG_MAP_MUST_NOT_FAIL	- Indicate that sg_map must not fail.
> + *				  If it does, it will issue a BUG_ON instead.
> + *				  This is intended for legacy code only, it
> + *				  is not to be used in new code.

I'm sorry but this API is just a trainwreck.  Right now we have the
nice little kmap_atomic API, which never fails and has a very nice
calling convention where we just pass back the return address, but does
not support sleeping inside the critical section.

And kmap, whіch may fail and requires the original page to be passed
back.  Anything that mixes these two concepts up is simply a non-starter.
