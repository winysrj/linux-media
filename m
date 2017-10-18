Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:20281 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751243AbdJROm2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Oct 2017 10:42:28 -0400
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH v4 00/12] Intel IPU3 ImgU patchset
Date: Wed, 18 Oct 2017 14:42:25 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D1AE2A712@ORSMSX106.amr.corp.intel.com>
References: <1508298408-25822-1-git-send-email-yong.zhi@intel.com>
 <20171018062319.GB10605@lst.de>
In-Reply-To: <20171018062319.GB10605@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Christoph,

Thanks for the message.

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Tuesday, October 17, 2017 11:23 PM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian
> Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan
> <rajmohan.mani@intel.com>; Toivonen, Tuukka
> <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>;
> arnd@arndb.de; hch@lst.de; robin.murphy@arm.com; iommu@lists.linux-
> foundation.org
> Subject: Re: [PATCH v4 00/12] Intel IPU3 ImgU patchset
> 
> Please keep everyone on CC for all the patches, othervise they are complete
> unreviable and will be ignored.

Last time, Tomasz instructed me to cc you and other iommu experts only for mmu/dmamap patches(3 of 12), should I resend the 12 patches to both Linux-media and iommu list? or to Linux-media and cc everyone? Or just send the missing patches to iommu list and you folks this time? 

Yong 
