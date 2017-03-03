Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36664 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751703AbdCCS5p (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 13:57:45 -0500
Received: by mail-qk0-f182.google.com with SMTP id 1so71931778qkl.3
        for <linux-media@vger.kernel.org>; Fri, 03 Mar 2017 10:57:33 -0800 (PST)
Subject: Re: [RFC PATCH 10/12] staging: android: ion: Use CMA APIs directly
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
 <1488491084-17252-11-git-send-email-labbott@redhat.com>
 <2140021.hmlAgxcLbU@avalon>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com,
        devel@driverdev.osuosl.org, romlem@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, Mark Brown <broonie@kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Laura Abbott <labbott@redhat.com>
Message-ID: <0541f57b-4060-ea10-7173-26ae77777518@redhat.com>
Date: Fri, 3 Mar 2017 10:50:20 -0800
MIME-Version: 1.0
In-Reply-To: <2140021.hmlAgxcLbU@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/03/2017 08:41 AM, Laurent Pinchart wrote:
> Hi Laura,
> 
> Thank you for the patch.
> 
> On Thursday 02 Mar 2017 13:44:42 Laura Abbott wrote:
>> When CMA was first introduced, its primary use was for DMA allocation
>> and the only way to get CMA memory was to call dma_alloc_coherent. This
>> put Ion in an awkward position since there was no device structure
>> readily available and setting one up messed up the coherency model.
>> These days, CMA can be allocated directly from the APIs. Switch to using
>> this model to avoid needing a dummy device. This also avoids awkward
>> caching questions.
> 
> If the DMA mapping API isn't suitable for today's requirements anymore, I 
> believe that's what needs to be fixed, instead of working around the problem 
> by introducing another use-case-specific API.
> 

I don't think this is a usecase specific API. CMA has been decoupled from
DMA already because it's used in other places. The trying to go through
DMA was just another layer of abstraction, especially since there isn't
a device available for allocation.

Thanks,
Laura
