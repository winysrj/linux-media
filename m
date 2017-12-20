Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52855 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754664AbdLTN5v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 08:57:51 -0500
Date: Wed, 20 Dec 2017 11:57:44 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc: "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH v4 00/12] Intel IPU3 ImgU patchset
Message-ID: <20171220115744.591a12e2@vento.lan>
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A5972FD4195@FMSMSX114.amr.corp.intel.com>
References: <1508298408-25822-1-git-send-email-yong.zhi@intel.com>
        <6F87890CF0F5204F892DEA1EF0D77A5972FD4195@FMSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Em Fri, 17 Nov 2017 02:58:56 +0000
"Mani, Rajmohan" <rajmohan.mani@intel.com> escreveu:

> Here is an update on the IPU3 documentation that we are currently working on.
> 
> Image processing in IPU3 relies on the following.
> 
> 1) HW configuration to enable ISP and
> 2) setting customer specific 3A Tuning / Algorithm Parameters to achieve desired image quality. 
> 
> We intend to provide documentation on ImgU driver programming interface to help users of this driver to configure and enable ISP HW to meet their needs.  This documentation will include details on complete V4L2 Kernel driver interface and IO-Control parameters, except for the ISP internal algorithm and its parameters (which is Intel proprietary IP).

Sakari asked me to take a look on this thread, specifically on this
email. I took a look on the other e-mails from this thread that are
discussing about this IP block.

I understand that Intel wants to keep their internal 3A algorithm
protected, just like other vendors protect their own algos. It was never
a requirement to open whatever algorithm are used inside a hardware
(or firmware). The only requirement is that firmwares should be licensed
with redistribution permission, ideally merged at linux-firmware git
tree.

Yet, what I don't understand is why Intel also wants to also protect
the interface for such 3A hardware/firmware algorithm. The parameters
that are passed from an userspace application to Intel ISP logic 
doesn't contain the algorithm itself. What's the issue of documenting
the meaning of each parameter?


Thanks,
Mauro
