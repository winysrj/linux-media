Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38471 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753531AbeC1PHX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 11:07:23 -0400
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
To: Christoph Hellwig <hch@infradead.org>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-2-christian.koenig@amd.com>
 <20180328123830.GB25060@infradead.org>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <613a6c91-7e72-5589-77e6-587ec973d553@gmail.com>
Date: Wed, 28 Mar 2018 17:07:20 +0200
MIME-Version: 1.0
In-Reply-To: <20180328123830.GB25060@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.03.2018 um 14:38 schrieb Christoph Hellwig:
> On Sun, Mar 25, 2018 at 12:59:54PM +0200, Christian König wrote:
>> From: "wdavis@nvidia.com" <wdavis@nvidia.com>
>>
>> Add an interface to find the first device which is upstream of both
>> devices.
> Please work with Logan and base this on top of the outstanding peer
> to peer patchset.

Can you point me to that? The last code I could find about that was from 
2015.

Thanks,
Christian.
