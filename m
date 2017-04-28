Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:32852 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163345AbdD1TB6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 15:01:58 -0400
To: Herbert Xu <herbert@gondor.apana.org.au>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-8-git-send-email-logang@deltatee.com>
 <20170427035603.GA32212@gondor.apana.org.au>
 <94123cbf-3287-f05e-7267-0bcf08ab0a8b@deltatee.com>
 <20170428063039.GB6817@gondor.apana.org.au>
 <5a08708b-c3b8-41fe-96de-607a109eacbd@deltatee.com>
 <20170428175147.GA9596@gondor.apana.org.au>
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
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d5242ef0-2670-63e4-02ce-a6d2368b7292@deltatee.com>
Date: Fri, 28 Apr 2017 13:01:39 -0600
MIME-Version: 1.0
In-Reply-To: <20170428175147.GA9596@gondor.apana.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 07/21] crypto: shash, caam: Make use of the new sg_map
 helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 28/04/17 11:51 AM, Herbert Xu wrote:
> On Fri, Apr 28, 2017 at 10:53:45AM -0600, Logan Gunthorpe wrote:
>>
>>
>> On 28/04/17 12:30 AM, Herbert Xu wrote:
>>> You are right.  Indeed the existing code looks buggy as they
>>> don't take sg->offset into account when doing the kmap.  Could
>>> you send me some patches that fix these problems first so that
>>> they can be easily backported?
>>
>> Ok, I think the only buggy one in crypto is hifn_795x. Shash and caam
>> both do have the sg->offset accounted for. I'll send a patch for the
>> buggy one shortly.
> 
> I think they're all buggy when sg->offset is greater than PAGE_SIZE.

Yes, technically. But that's a _very_ common mistake. Pretty nearly
every case I looked at did not take that into account. I don't think
sg's that point to more than one continuous page are all that common.

Fixing all those cases without making a common function is a waste of
time IMO.

Logan
