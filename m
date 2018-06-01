Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.netline.ch ([148.251.143.178]:36170 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753369AbeFAPag (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 11:30:36 -0400
Subject: Re: [PATCH 1/5] dma_buf: remove device parameter from attach callback
To: christian.koenig@amd.com
Cc: linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20180601120020.11520-1-christian.koenig@amd.com>
 <651a24e0-ac58-e5cb-d95f-c9a88bf552dc@gmail.com>
 <df02be8b-530e-b691-35f1-ed657d71a508@daenzer.net>
 <64e8f2dd-5b09-397f-05ac-67646dfb5394@gmail.com>
From: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Message-ID: <2abb36c3-cb6e-ec08-2144-265301ef18dd@daenzer.net>
Date: Fri, 1 Jun 2018 17:30:28 +0200
MIME-Version: 1.0
In-Reply-To: <64e8f2dd-5b09-397f-05ac-67646dfb5394@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-06-01 05:17 PM, Christian König wrote:
> Am 01.06.2018 um 16:02 schrieb Michel Dänzer:
>> On 2018-06-01 02:11 PM, Christian König wrote:
>>> Sorry, accidentally send this series without a cover letter.
>>>
>>> This is a cleanup to the DMA-buf interface, which is also a prerequisite
>>> to unpinned DMA-buf operation.
>>>
>>> Patch #1 and #2 just remove unused functionality and clean up callback
>>> parameters.
>>>
>>> Patch #3 and #4 introduce taking the reservation lock during
>>> mapping/unmapping of DMA-bufs.
>>>
>>> This introduces a common lock where both exporter as well as importer
>>> can then use in the future for unpinned DMA-buf operation.
>>>
>>> This of course means that exporters should now not take this reservation
>>> lock manually any more. The DRM drivers don't seem to actually do that,
>>> but I'm not 100% sure about other implementations.
>>>
>>> Patch #5 then makes use of the new lock to simplify the DMA-buf import
>>> handling in amdgpu.
>> Please rebase this series on top of
>> https://patchwork.freedesktop.org/patch/226311/ and update the
>> documentation in amdgpu_prime.c as needed in each patch.
> 
> Sure. In this case can we get your patches committed to
> amd-staging-drm-next ASAP?

Sure, done.


-- 
Earthling Michel Dänzer               |               http://www.amd.com
Libre software enthusiast             |             Mesa and X developer
