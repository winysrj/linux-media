Return-path: <linux-media-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:59338 "EHLO
        pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdBUPId (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 10:08:33 -0500
Subject: Re: [PATCH] dma-buf: add support for compat ioctl
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <CGME20170221132114eucas1p2e527d5b5516494ba54aa91f48b3e227f@eucas1p2.samsung.com>
 <1487683261-2655-1-git-send-email-m.szyprowski@samsung.com>
 <917aff70-64f7-7224-a015-0e77951bbc1d@vodafone.de>
 <dbcfe0d9-cdc3-e715-2535-0a2b7ffec3a5@samsung.com>
 <ac1ddfe4-1667-bdb0-c4da-35c8cf85fbed@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <ef70688e-35a5-00a5-44e0-575bc18d1752@vodafone.de>
Date: Tue, 21 Feb 2017 16:08:25 +0100
MIME-Version: 1.0
In-Reply-To: <ac1ddfe4-1667-bdb0-c4da-35c8cf85fbed@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.02.2017 um 15:55 schrieb Marek Szyprowski:
> Dear All,
>
> On 2017-02-21 15:37, Marek Szyprowski wrote:
>> Hi Christian,
>>
>> On 2017-02-21 14:59, Christian König wrote:
>>> Am 21.02.2017 um 14:21 schrieb Marek Szyprowski:
>>>> Add compat ioctl support to dma-buf. This lets one to use 
>>>> DMA_BUF_IOCTL_SYNC
>>>> ioctl from 32bit application on 64bit kernel. Data structures for 
>>>> both 32
>>>> and 64bit modes are same, so there is no need for additional 
>>>> translation
>>>> layer.
>>>
>>> Well I might be wrong, but IIRC compat_ioctl was just optional and 
>>> if not specified unlocked_ioctl was called instead.
>>>
>>> If that is true your patch wouldn't have any effect at all.
>>
>> Well, then why I got -ENOTTY in the 32bit test app for this ioctl on 
>> 64bit ARM64 kernel without this patch?
>>
>
> I've checked in fs/compat_ioctl.c, I see no fallback in 
> COMPAT_SYSCALL_DEFINE3,
> so one has to provide compat_ioctl callback to have ioctl working with 
> 32bit
> apps.

Then my memory cheated on me.

In this case the patch is Reviewed-by: Christian König 
<christian.koenig@amd.com>.

Regards,
Christian.

>
> Best regards
