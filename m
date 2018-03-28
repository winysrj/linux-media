Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0051.outbound.protection.outlook.com ([104.47.34.51]:44962
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751193AbeC1QDB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 12:03:01 -0400
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
To: Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@infradead.org>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-2-christian.koenig@amd.com>
 <20180328123830.GB25060@infradead.org>
 <613a6c91-7e72-5589-77e6-587ec973d553@gmail.com>
 <c81df70d-191d-bf8e-293a-413dd633e1fc@deltatee.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <5498e9b5-8fe5-8999-a44e-f7dc483bc9ce@amd.com>
Date: Wed, 28 Mar 2018 18:02:46 +0200
MIME-Version: 1.0
In-Reply-To: <c81df70d-191d-bf8e-293a-413dd633e1fc@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.03.2018 um 17:47 schrieb Logan Gunthorpe:
>
> On 28/03/18 09:07 AM, Christian König wrote:
>> Am 28.03.2018 um 14:38 schrieb Christoph Hellwig:
>>> On Sun, Mar 25, 2018 at 12:59:54PM +0200, Christian König wrote:
>>>> From: "wdavis@nvidia.com" <wdavis@nvidia.com>
>>>>
>>>> Add an interface to find the first device which is upstream of both
>>>> devices.
>>> Please work with Logan and base this on top of the outstanding peer
>>> to peer patchset.
>> Can you point me to that? The last code I could find about that was from
>> 2015.
> The latest posted series is here:
>
> https://lkml.org/lkml/2018/3/12/830
>
> However, we've made some significant changes to the area that's similar
> to what you are doing. You can find lasted un-posted here:
>
> https://github.com/sbates130272/linux-p2pmem/tree/pci-p2p-v4-pre2
>
> Specifically this function would be of interest to you:
>
> https://github.com/sbates130272/linux-p2pmem/blob/0e9468ae2a5a5198513dd12990151e09105f0351/drivers/pci/p2pdma.c#L239
>
> However, the difference between what we are doing is that we are
> interested in the distance through the common upstream device and you
> appear to be finding the actual common device.

Yeah, that looks very similar to what I picked up from the older 
patches, going to read up on that after my vacation.

Just in general why are you interested in the "distance" of the devices?

And BTW: At least for writes that Peer 2 Peer transactions between 
different root complexes work is actually more common than the other way 
around.

So I'm a bit torn between using a blacklist or a whitelist. A whitelist 
is certainly more conservative approach, but that could get a bit long.

Thanks,
Christian.

>
> Thanks,
>
> Logan
