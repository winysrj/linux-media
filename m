Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:40856 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753957AbdDNPhf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 11:37:35 -0400
To: Christoph Hellwig <hch@lst.de>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-4-git-send-email-logang@deltatee.com>
 <20170414083607.GB25471@lst.de>
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
Message-ID: <85eda3a6-edab-e59e-d2d4-c3af5599d0fd@deltatee.com>
Date: Fri, 14 Apr 2017 09:37:20 -0600
MIME-Version: 1.0
In-Reply-To: <20170414083607.GB25471@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 03/22] libiscsi: Make use of new the sg_map helper
 function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 14/04/17 02:36 AM, Christoph Hellwig wrote:
> On Thu, Apr 13, 2017 at 04:05:16PM -0600, Logan Gunthorpe wrote:
>> Convert the kmap and kmap_atomic uses to the sg_map function. We now
>> store the flags for the kmap instead of a boolean to indicate
>> atomicitiy. We also propogate a possible kmap error down and create
>> a new ISCSI_TCP_INTERNAL_ERR error type for this.
> 
> Can you split out the new error handling into a separate prep patch
> which should go to the iscsi maintainers ASAP?
> 

Yes, I can do that. I'd just have thought they'd want to see the use
case for the new error before accepting a patch like that...

Logan
