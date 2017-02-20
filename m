Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44007 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753094AbdBTK35 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 05:29:57 -0500
Subject: Re: [PATCH 15/15] ARM: dts: exynos: Remove MFC reserved buffersg
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <c73d6600-0e0c-d1da-58c7-f6b4d3b6a389@samsung.com>
Date: Mon, 20 Feb 2017 11:28:35 +0100
MIME-version: 1.0
In-reply-to: <20170214170316.nsp3g5ht3ldoxc43@kozik-lap>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8bit
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075221eucas1p18648b047f71e9dd95626e5766c74601b@eucas1p1.samsung.com>
 <1487058728-16501-16-git-send-email-m.szyprowski@samsung.com>
 <20170214170316.nsp3g5ht3ldoxc43@kozik-lap>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/2017 06:03 PM, Krzysztof Kozlowski wrote:
> On Tue, Feb 14, 2017 at 08:52:08AM +0100, Marek Szyprowski wrote:
>> During my research I found that some of the requirements for the memory
>> buffers for MFC v6+ devices were blindly copied from the previous (v5)
>> version and simply turned out to be excessive. The relaxed requirements
>> are applied by the recent patches to the MFC driver and the driver is
>> now fully functional even without the reserved memory blocks for all
>> v6+ variants. This patch removes those reserved memory nodes from all
> boards having MFC v6+ hardware block.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
> 
> Looks okay (for v4.12). Full bisectability depends on changes in MFC
> driver, right?  I will need a stable branch/tag with driver changes
> (although recently Arnd did not want driver changes mixed with DTS...).

I'd suggest postponing that dts cleanup patch to v4.13, everything
should continue to work properly with just the driver patches merged
and that way there will be no need to pull all 14 driver patches
into the arm-soc tree.

--
Regards,
Sylwester
