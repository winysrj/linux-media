Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:53585 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753138AbdDRP73 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 11:59:29 -0400
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-17-git-send-email-logang@deltatee.com>
 <063D6719AE5E284EB5DD2968C1650D6DCFFD3CD7@AcuExch.aculab.com>
 <20170418142723.GA27133@char.us.oracle.com>
 <7930aa93-6106-e12f-ba76-e2771d4ec2dc@deltatee.com>
 <20170418155020.GF12001@char.us.oracle.com>
Cc: David Laight <David.Laight@ACULAB.COM>,
        xen-devel@lists.xensource.com, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>,
        "sparmaintainer@unisys.com" <sparmaintainer@unisys.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Steve Wise <swise@opengridcomputing.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <bed54c06-eb00-e682-8a50-236ebb9c1db4@deltatee.com>
Date: Tue, 18 Apr 2017 09:59:09 -0600
MIME-Version: 1.0
In-Reply-To: <20170418155020.GF12001@char.us.oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 16/22] xen-blkfront: Make use of the new sg_map helper
 function
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 18/04/17 09:50 AM, Konrad Rzeszutek Wilk wrote:
> I am not sure if you know, but you can add on each patch the respective
> maintainer via 'CC'. That way you can have certain maintainers CCed only
> on the subsystems they cover. You put it after (or before) your SoB and
> git send-email happilly picks it up.

Yes, but I've seen some maintainers complain when they receive a patch
with no context (ie. cover letter and first patch). So I chose to do it
this way. I expect in this situation, no matter what you do, someone is
going to complain about the approach chosen.

Thanks anyway for the tip.

Logan
