Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:40802 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbdDNPex (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 11:34:53 -0400
To: Christoph Hellwig <hch@lst.de>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-2-git-send-email-logang@deltatee.com>
 <20170414083518.GA25471@lst.de>
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
Message-ID: <18f05078-5b2c-2e9b-c8ad-e23c02942b58@deltatee.com>
Date: Fri, 14 Apr 2017 09:34:28 -0600
MIME-Version: 1.0
In-Reply-To: <20170414083518.GA25471@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/22] scatterlist: Introduce sg_map helper functions
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 14/04/17 02:35 AM, Christoph Hellwig wrote:
>> +
>>  static inline int is_dma_buf_file(struct file *);
>>  
>>  struct dma_buf_list {
> 
> I think the right fix here is to rename the operation to unmap_atomic
> and send out a little patch for that ASAP.

Ok, I can do that next week.

> I'd rather have separate functions for kmap vs kmap_atomic instead of
> the flags parameter.  And while you're at it just always pass the 0
> offset parameter instead of adding a wrapper..
> 
> Otherwise this looks good to me.

I settled on the flags because I thought the interface could be expanded
to do more things like automatically copy iomem to a bounce buffer (with
a flag). It'd also be possible to add things like vmap and
physical_address to the interface which would cover even more sg_page
users. All the implementations would then share the common offset
calculations, and switching between them becomes a matter of changing a
couple flags.

If you're still not convinced by the above arguments  then I'll change
it but I did have reasons for choosing to do it this way.

I am fine with removing the offset versions. I will make that change.

Thanks,

Logan
