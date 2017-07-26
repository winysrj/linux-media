Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:34277 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdGZNwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 09:52:10 -0400
Received: by mail-yw0-f170.google.com with SMTP id i6so54014649ywb.1
        for <linux-media@vger.kernel.org>; Wed, 26 Jul 2017 06:52:10 -0700 (PDT)
Received: from mail-yw0-f182.google.com (mail-yw0-f182.google.com. [209.85.161.182])
        by smtp.gmail.com with ESMTPSA id k70sm1197327ywe.40.2017.07.26.06.52.07
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jul 2017 06:52:08 -0700 (PDT)
Received: by mail-yw0-f182.google.com with SMTP id l82so29777008ywc.2
        for <linux-media@vger.kernel.org>; Wed, 26 Jul 2017 06:52:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170720220904.icclurhemtkk7sx7@valkosipuli.retiisi.org.uk>
References: <1500433978-2350-1-git-send-email-yong.zhi@intel.com>
 <CAK8P3a0Muca-NB0+yuotTHEixhx8jG9Dytsd_wE9=SfNdGSGBg@mail.gmail.com> <20170720220904.icclurhemtkk7sx7@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 26 Jul 2017 22:51:46 +0900
Message-ID: <CAAFQd5DD-x+SA9d406AcXSEvNmqmex2CFmdnbst7vzxssVXo3g@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] intel-ipu3: Add DMA API implementation
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>, Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 21, 2017 at 7:09 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Arnd,
>
> On Wed, Jul 19, 2017 at 09:24:41AM +0200, Arnd Bergmann wrote:
>> On Wed, Jul 19, 2017 at 5:12 AM, Yong Zhi <yong.zhi@intel.com> wrote:
>> > From: Tomasz Figa <tfiga@chromium.org>
>> >
>> > This patch adds support for the IPU3 DMA mapping API.
>> >
>> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>>
>> This needs some explanation on why you decided to go down the
>> route of adding your own dma_map_ops. It's not obvious at all,
>> and and I'm still concerned that this complicates things more than
>> it helps.
>
> There are a few considerations here --- they could be documented in the
> patch commit message
>
> - The device has its own MMU. The default x86 DMA ops assume there isn't.
>
> - As this is an image signal processor device, the buffers are typically
>   large (often in the range of tens of MB) and they do not need to be
>   physically contiguous. The current implementation of e.g.
>   drivers/iommu/intel-iommu.c allocate memory using alloc_pages() which is
>   unfeasible for such single allocations. Neither CMA is needed.
>
>   Also other IOMMU implementations have their own DMA ops currently.
>
> I agree it'd be nice to unify these in the long run but I don't think this
> stands apart from the rest currently --- except that the MMU is only used
> by a single PCI device, the same which it is contained in.

On top of what Sakari said, it just perfectly matches what V4L2
videobuf2 framework expects. It does all the buffer mapping and
synchronization using DMA mapping and given the x86 DMA ops being
useless for this device, it makes everything that videobuf2 does using
them useless too.

Best regards,
Tomasz
