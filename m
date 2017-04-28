Return-path: <linux-media-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:50382 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1164100AbdD1Gcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 02:32:41 -0400
Date: Fri, 28 Apr 2017 14:30:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
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
        Stephen Bates <sbates@raithlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 07/21] crypto: shash, caam: Make use of the new sg_map
 helper function
Message-ID: <20170428063039.GB6817@gondor.apana.org.au>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-8-git-send-email-logang@deltatee.com>
 <20170427035603.GA32212@gondor.apana.org.au>
 <94123cbf-3287-f05e-7267-0bcf08ab0a8b@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94123cbf-3287-f05e-7267-0bcf08ab0a8b@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 27, 2017 at 09:45:57AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 26/04/17 09:56 PM, Herbert Xu wrote:
> > On Tue, Apr 25, 2017 at 12:20:54PM -0600, Logan Gunthorpe wrote:
> >> Very straightforward conversion to the new function in the caam driver
> >> and shash library.
> >>
> >> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> >> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >> Cc: "David S. Miller" <davem@davemloft.net>
> >> ---
> >>  crypto/shash.c                | 9 ++++++---
> >>  drivers/crypto/caam/caamalg.c | 8 +++-----
> >>  2 files changed, 9 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/crypto/shash.c b/crypto/shash.c
> >> index 5e31c8d..5914881 100644
> >> --- a/crypto/shash.c
> >> +++ b/crypto/shash.c
> >> @@ -283,10 +283,13 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
> >>  	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
> >>  		void *data;
> >>  
> >> -		data = kmap_atomic(sg_page(sg));
> >> -		err = crypto_shash_digest(desc, data + offset, nbytes,
> >> +		data = sg_map(sg, 0, SG_KMAP_ATOMIC);
> >> +		if (IS_ERR(data))
> >> +			return PTR_ERR(data);
> >> +
> >> +		err = crypto_shash_digest(desc, data, nbytes,
> >>  					  req->result);
> >> -		kunmap_atomic(data);
> >> +		sg_unmap(sg, data, 0, SG_KMAP_ATOMIC);
> >>  		crypto_yield(desc->flags);
> >>  	} else
> >>  		err = crypto_shash_init(desc) ?:
> > 
> > Nack.  This is an optimisation for the special case of a single
> > SG list entry.  In fact in the common case the kmap_atomic should
> > disappear altogether in the no-highmem case.  So replacing it
> > with sg_map is not acceptable.
> 
> What you seem to have missed is that sg_map is just a thin wrapper
> around kmap_atomic. Perhaps with a future check for a mappable page.
> This change should have zero impact on performance.

You are right.  Indeed the existing code looks buggy as they
don't take sg->offset into account when doing the kmap.  Could
you send me some patches that fix these problems first so that
they can be easily backported?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
