Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:54401 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935204AbdDZUZG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 16:25:06 -0400
To: Christoph Hellwig <hch@lst.de>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-2-git-send-email-logang@deltatee.com>
 <20170426074416.GA7936@lst.de>
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
Message-ID: <4736d44e-bbcf-5d59-a1a9-317d0f4da847@deltatee.com>
Date: Wed, 26 Apr 2017 12:11:33 -0600
MIME-Version: 1.0
In-Reply-To: <20170426074416.GA7936@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 01/21] scatterlist: Introduce sg_map helper functions
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 26/04/17 01:44 AM, Christoph Hellwig wrote:
> I think we'll at least need a draft of those to make sense of these
> patches.  Otherwise they just look very clumsy.

Ok, I'll work up a draft proposal and send it in a couple days. But
without a lot of cleanup such as this series it's not going to even be
able to compile.

> I'm sorry but this API is just a trainwreck.  Right now we have the
> nice little kmap_atomic API, which never fails and has a very nice
> calling convention where we just pass back the return address, but does
> not support sleeping inside the critical section.
> 
> And kmap, whіch may fail and requires the original page to be passed
> back.  Anything that mixes these two concepts up is simply a non-starter.

Ok, well for starters I think you are mistaken about kmap being able to
fail. I'm having a hard time finding many users of that function that
bother to check for an error when calling it. The main difficulty we
have now is that neither of those functions are expected to fail and we
need them to be able to in cases where the page doesn't map to system
RAM. This patch series is trying to address it for users of scatterlist.
I'm certainly open to other suggestions.

I also have to disagree that kmap and kmap_atomic are all that "nice".
Except for the sleeping restriction and performance, they effectively do
the same thing. And it was necessary to write a macro wrapper around
kunmap_atomic to ensure that users of that function don't screw it up.
(See 597781f3e5.) I'd say the kmap/kmap_atomic functions are the
trainwreck and I'm trying to do my best to cleanup a few cases.

There are a fair number of cases in the kernel that do something like:

if (something)
    x = kmap(page);
else
    x = kmap_atomic(page);
...
if (something)
    kunmap(page)
else
    kunmap_atomic(x)

Which just seems cumbersome to me.

In any case, if you can accept an sg_kmap and sg_kmap_atomic api just
say so and I'll make the change. But I'll still need a flags variable
for SG_MAP_MUST_NOT_FAIL to support legacy cases that have no fail path
and both of those functions will need to be pretty nearly replicas of
each other.

Logan
