Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:40942 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751242AbdDNQEA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 12:04:00 -0400
To: Christoph Hellwig <hch@lst.de>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-10-git-send-email-logang@deltatee.com>
 <20170414083921.GC25471@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Ming Lin <ming.l@ssi.samsung.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org,
        linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org,
        open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        Steve Wise <swise@opengridcomputing.com>,
        Stephen Bates <sbates@raithlin.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <302ae5ab-d515-5427-2e54-d58a9cdb8241@deltatee.com>
Date: Fri, 14 Apr 2017 10:03:43 -0600
MIME-Version: 1.0
In-Reply-To: <20170414083921.GC25471@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 09/22] dm-crypt: Make use of the new sg_map helper in 4
 call sites
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 14/04/17 02:39 AM, Christoph Hellwig wrote:
> On Thu, Apr 13, 2017 at 04:05:22PM -0600, Logan Gunthorpe wrote:
>> Very straightforward conversion to the new function in all four spots.
> 
> I think the right fix here is to switch dm-crypt to the ahash API
> that takes a scatterlist.

Hmm, well I'm not sure I understand the code enough to make that
conversion. But I was looking at it. One tricky bit seems to be that
crypt_iv_lmk_one adds a seed, skips the first 16 bytes in the page and
then hashes another 16 bytes from other data. What would you do
construct a new sgl for it and pass it to the ahash api?

The other thing is crypt_iv_lmk_post also seems to modify the page after
the hash with a  crypto_xor so you'd still need at least one kmap in there.

Logan
