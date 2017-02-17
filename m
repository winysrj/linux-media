Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57175
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935000AbdBQVve (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 16:51:34 -0500
Subject: Re: [PATCH 00/15] Exynos MFC v6+ - remove the need for the reserved
 memory
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <CGME20170214075214eucas1p1574c18c0fa166cdda50838b9fb8cc23b@eucas1p1.samsung.com>
 <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Message-ID: <9d06fac3-3384-fd66-df7a-f945f663bbf9@osg.samsung.com>
Date: Fri, 17 Feb 2017 18:51:19 -0300
MIME-Version: 1.0
In-Reply-To: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 02/14/2017 04:51 AM, Marek Szyprowski wrote:
> Dear All,
> 
> This patchset is a result of my work on enabling full support for MFC device
> (multimedia codec) on Exynos 5433 on ARM64 architecture. Initially I thought
> that to let it working on ARM64 architecture with IOMMU, I would need to
> solve the issue related to the fact that s5p-mfc driver was depending on the
> first-fit allocation method in the DMA-mapping / IOMMU glue code (ARM64 use
> different algorithm). It turned out, that there is a much simpler way.
> 

A nice side effect of these patches is that I don't see anymore a page fault
error with CMA when sharing dma-buf between s5p-fmc and exynos-gsc drivers.

Following GST pipeline used to lead to a system crash, but it's working now:

$ gst-launch-1.0 filesrc location=test.mp4 ! qtdemux ! h264parse ! \
v4l2video2dec capture-io-mode=dmabuf ! v4l2video0convert \
output-io-mode=dmabuf-import capture-io-mode=dmabuf ! kmssink

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
