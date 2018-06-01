Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.netline.ch ([148.251.143.178]:33308 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbeFAOHg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 10:07:36 -0400
Subject: Re: [PATCH 1/5] dma_buf: remove device parameter from attach callback
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
References: <20180601120020.11520-1-christian.koenig@amd.com>
 <651a24e0-ac58-e5cb-d95f-c9a88bf552dc@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
From: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Message-ID: <df02be8b-530e-b691-35f1-ed657d71a508@daenzer.net>
Date: Fri, 1 Jun 2018 16:02:17 +0200
MIME-Version: 1.0
In-Reply-To: <651a24e0-ac58-e5cb-d95f-c9a88bf552dc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-06-01 02:11 PM, Christian König wrote:
> Sorry, accidentally send this series without a cover letter.
> 
> This is a cleanup to the DMA-buf interface, which is also a prerequisite
> to unpinned DMA-buf operation.
> 
> Patch #1 and #2 just remove unused functionality and clean up callback
> parameters.
> 
> Patch #3 and #4 introduce taking the reservation lock during
> mapping/unmapping of DMA-bufs.
> 
> This introduces a common lock where both exporter as well as importer
> can then use in the future for unpinned DMA-buf operation.
> 
> This of course means that exporters should now not take this reservation
> lock manually any more. The DRM drivers don't seem to actually do that,
> but I'm not 100% sure about other implementations.
> 
> Patch #5 then makes use of the new lock to simplify the DMA-buf import
> handling in amdgpu.

Please rebase this series on top of
https://patchwork.freedesktop.org/patch/226311/ and update the
documentation in amdgpu_prime.c as needed in each patch.


-- 
Earthling Michel Dänzer               |               http://www.amd.com
Libre software enthusiast             |             Mesa and X developer
