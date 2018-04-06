Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-cys01nam02on0070.outbound.protection.outlook.com ([104.47.37.70]:63234
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752125AbeDFMZA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 08:25:00 -0400
Subject: Re: [PATCH v2] Add udmabuf misc device
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        qemu-devel@nongnu.org,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <20180316074650.5415-1-kraxel@redhat.com>
 <7547e99b-0e3c-264e-e52b-40ad5d52b49a@gmail.com>
 <20180406093307.s7wkhpmddd5d4r7a@sirius.home.kraxel.org>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <5d88baad-a956-6bd5-e0d6-aabae6647f3e@amd.com>
Date: Fri, 6 Apr 2018 14:24:46 +0200
MIME-Version: 1.0
In-Reply-To: <20180406093307.s7wkhpmddd5d4r7a@sirius.home.kraxel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 06.04.2018 um 11:33 schrieb Gerd Hoffmann:
>    Hi,
>
>> The pages backing a DMA-buf are not allowed to move (at least not without a
>> patch set I'm currently working on), but for certain MM operations to work
>> correctly you must be able to modify the page tables entries and move the
>> pages backing them around.
>>
>> For example try to use fork() with some copy on write pages with this
>> approach. You will find that you have only two options to correctly handle
>> this.
> The fork() issue should go away with shared memory pages (no cow).
> I guess this is the reason why vgem is internally backed by shmem.

Yes, exactly that is also an approach which should work fine. Just don't 
try to get this working with get_user_pages().

>
> Hmm.  So I could try to limit the udmabuf driver to shmem too (i.e.
> have the ioctl take a shmem filehandle and offset instead of a virtual
> address).
>
> But maybe it is better then to just extend vgem, i.e. add support to
> create gem objects from existing shmem.
>
> Comments?

Yes, extending vgem instead of creating something new sounds like a good 
idea to me as well.

Regards,
Christian.

>
> cheers,
>    Gerd
>
