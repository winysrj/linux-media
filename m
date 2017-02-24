Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59585 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdBXG0P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 01:26:15 -0500
Subject: Re: [PATCH 14/15] media: s5p-mfc: Use preallocated block allocator
 always for MFC v6+
To: Shuah Khan <shuahkhan@gmail.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>, shuahkh@osg.samsung.com
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <eb7357b5-d218-14a2-f9ba-c05902e6fa53@samsung.com>
Date: Fri, 24 Feb 2017 07:26:08 +0100
MIME-version: 1.0
In-reply-to: <CAKocOOO+JLD7pcL2A-8adi1hwDjw55Y2jMQ3Ki6oVTWdSn1W+A@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
References: <CGME20170214075221eucas1p1c0acfa79289ebff6306c01e47c3e83a7@eucas1p1.samsung.com>
 <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <1487058728-16501-15-git-send-email-m.szyprowski@samsung.com>
 <CAKocOOO+JLD7pcL2A-8adi1hwDjw55Y2jMQ3Ki6oVTWdSn1W+A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah


On 2017-02-23 22:43, Shuah Khan wrote:
> On Tue, Feb 14, 2017 at 12:52 AM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> It turned out that all versions of MFC v6+ hardware doesn't have a strict
>> requirement for ALL buffers to be allocated on higher addresses than the
>> firmware base like it was documented for MFC v5. This requirement is true
>> only for the device and per-context buffers. All video data buffers can be
>> allocated anywhere for all MFC v6+ versions. Basing on this fact, the
>> special DMA configuration based on two reserved memory regions is not
>> really needed for MFC v6+ devices, because the memory requirements for the
>> firmware, device and per-context buffers can be fulfilled by the simple
>> probe-time pre-allocated block allocator instroduced in previous patch.
>>
>> This patch enables support for such pre-allocated block based allocator
>> always for MFC v6+ devices. Due to the limitations of the memory management
>> subsystem the largest supported size of the pre-allocated buffer when no
>> CMA (Contiguous Memory Allocator) is enabled is 4MiB.
>>
>> This patch also removes the requirement to provide two reserved memory
>> regions for MFC v6+ devices in device tree. Now the driver is fully
>> functional without them.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Hi Marek,
>
> This patch breaks display manager. exynos_drm_gem_create() isn't happy.
> dmesg and console are flooded with
>
> odroid login: [  209.170566] [drm:exynos_drm_gem_create] *ERROR* failed to allo.
> [  212.173222] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  215.354790] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  218.736464] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  221.837128] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  226.284827] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  229.242498] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  232.063150] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  235.799993] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  239.472061] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  242.567465] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  246.500541] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  249.996018] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  253.837272] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  257.048782] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  260.084819] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  263.448611] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  266.271074] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  269.011558] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  272.039066] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  275.404938] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  278.339033] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  281.274751] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  284.641202] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  287.461039] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  291.062011] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  294.746870] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
> [  298.246570] [drm:exynos_drm_gem_create] *ERROR* failed to allocate buffer.
>
> I don't think this is an acceptable behavior. It is a regression.

This is a really poor bug report... Could you elaborate a bit how to 
reproduce
this? Could you provide your kernel config and information about test 
environment?

I suspect that you use CMA without IOMMU and you have too small global 
CMA region.
After this patch MFC driver uses global CMA region instead of the MFC's 
private
ones, so one has to ensure that the global region is large enough.

 > [...]

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
