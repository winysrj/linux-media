Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:40315 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752659AbeFAPR1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 11:17:27 -0400
Received: by mail-wr0-f194.google.com with SMTP id l41-v6so36727695wre.7
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2018 08:17:27 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 1/5] dma_buf: remove device parameter from attach callback
To: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20180601120020.11520-1-christian.koenig@amd.com>
 <651a24e0-ac58-e5cb-d95f-c9a88bf552dc@gmail.com>
 <df02be8b-530e-b691-35f1-ed657d71a508@daenzer.net>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <64e8f2dd-5b09-397f-05ac-67646dfb5394@gmail.com>
Date: Fri, 1 Jun 2018 17:17:24 +0200
MIME-Version: 1.0
In-Reply-To: <df02be8b-530e-b691-35f1-ed657d71a508@daenzer.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 01.06.2018 um 16:02 schrieb Michel Dänzer:
> On 2018-06-01 02:11 PM, Christian König wrote:
>> Sorry, accidentally send this series without a cover letter.
>>
>> This is a cleanup to the DMA-buf interface, which is also a prerequisite
>> to unpinned DMA-buf operation.
>>
>> Patch #1 and #2 just remove unused functionality and clean up callback
>> parameters.
>>
>> Patch #3 and #4 introduce taking the reservation lock during
>> mapping/unmapping of DMA-bufs.
>>
>> This introduces a common lock where both exporter as well as importer
>> can then use in the future for unpinned DMA-buf operation.
>>
>> This of course means that exporters should now not take this reservation
>> lock manually any more. The DRM drivers don't seem to actually do that,
>> but I'm not 100% sure about other implementations.
>>
>> Patch #5 then makes use of the new lock to simplify the DMA-buf import
>> handling in amdgpu.
> Please rebase this series on top of
> https://patchwork.freedesktop.org/patch/226311/ and update the
> documentation in amdgpu_prime.c as needed in each patch.

Sure. In this case can we get your patches committed to 
amd-staging-drm-next ASAP?

Thanks,
Christian.
