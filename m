Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56857
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932673AbdBQUPg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 15:15:36 -0500
Subject: Re: [PATCH 12/15] media: s5p-mfc: Add support for probe-time
 preallocated block based allocator
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075220eucas1p21d7f82fa19a9f058bb6fbe0a994478cc@eucas1p2.samsung.com>
 <1487058728-16501-13-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <a83c8503-113a-fdbe-d2ca-0639c94e02b0@osg.samsung.com>
Date: Fri, 17 Feb 2017 17:14:42 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-13-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:52 AM, Marek Szyprowski wrote:
> Current MFC driver depends on the fact that when IOMMU is available, the
> DMA-mapping framework and its IOMMU glue will use first-fit allocator.
> This was true for ARM architecture, but its not for ARM64 arch. However, in
> case of MFC v6+ hardware and latest firmware, it turned out that there is
> no strict requirement for ALL buffers to be allocated on higher addresses
> than the firmware base. This requirement is true only for the device and
> per-context buffers. All video data buffers can be allocated anywhere for
> all MFC v6+ versions.
> 
> Such relaxed requirements for the memory buffers can be easily fulfilled
> by allocating firmware, device and per-context buffers from the probe-time
> preallocated larger buffer. This patch adds support for it. This way the
> driver finally works fine on ARM64 architecture. The size of the
> preallocated buffer is 8 MiB, what is enough for three instances H264
> decoders or encoders (other codecs have smaller memory requirements).
> If one needs more for particular use case, one can use "mem" module
> parameter to force larger (or smaller) buffer (for example by adding
> "s5p_mfc.mem=16M" to kernel command line).
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,

-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
