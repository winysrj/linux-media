Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:39314 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750750AbdDNFGh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 01:06:37 -0400
To: Christoph Hellwig <hch@lst.de>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-3-git-send-email-logang@deltatee.com>
 <20170414045951.GA22206@lst.de>
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
Message-ID: <4df3e41b-591e-a500-a428-4bc529224030@deltatee.com>
Date: Thu, 13 Apr 2017 23:06:16 -0600
MIME-Version: 1.0
In-Reply-To: <20170414045951.GA22206@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/22] nvmet: Make use of the new sg_map helper function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 13/04/17 10:59 PM, Christoph Hellwig wrote:
> On Thu, Apr 13, 2017 at 04:05:15PM -0600, Logan Gunthorpe wrote:
>> This is a straight forward conversion in two places. Should kmap fail,
>> the code will return an INVALD_DATA error in the completion.
> 
> It really should be using nvmet_copy_from_sgl to make things safer,
> as we don't want to rely on any particular SG list layout.  In fact
> I'm pretty sure I did the conversion at some point, but it must never
> have made it upstream.

Ha, I did the conversion too a couple times for my RFC series. I can
change this patch to do that. Or maybe I'll just send a patch for that
separately seeing it doesn't depend on anything and is pretty simple. I
can do that next week.

Thanks,

Logan
