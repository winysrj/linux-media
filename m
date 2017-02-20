Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751893AbdBTLW1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 06:22:27 -0500
MIME-Version: 1.0
In-Reply-To: <c73d6600-0e0c-d1da-58c7-f6b4d3b6a389@samsung.com>
References: <1487058728-16501-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170214075221eucas1p18648b047f71e9dd95626e5766c74601b@eucas1p1.samsung.com>
 <1487058728-16501-16-git-send-email-m.szyprowski@samsung.com>
 <20170214170316.nsp3g5ht3ldoxc43@kozik-lap> <c73d6600-0e0c-d1da-58c7-f6b4d3b6a389@samsung.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Mon, 20 Feb 2017 13:22:22 +0200
Message-ID: <CAJKOXPe8ORrajSiPmkJzhbsXBgEAJjV8sRrHx3e8ZTRx9khgNQ@mail.gmail.com>
Subject: Re: [PATCH 15/15] ARM: dts: exynos: Remove MFC reserved buffersg
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 20, 2017 at 12:28 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 02/14/2017 06:03 PM, Krzysztof Kozlowski wrote:
>> On Tue, Feb 14, 2017 at 08:52:08AM +0100, Marek Szyprowski wrote:
>>> During my research I found that some of the requirements for the memory
>>> buffers for MFC v6+ devices were blindly copied from the previous (v5)
>>> version and simply turned out to be excessive. The relaxed requirements
>>> are applied by the recent patches to the MFC driver and the driver is
>>> now fully functional even without the reserved memory blocks for all
>>> v6+ variants. This patch removes those reserved memory nodes from all
>> boards having MFC v6+ hardware block.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>
>> Looks okay (for v4.12). Full bisectability depends on changes in MFC
>> driver, right?  I will need a stable branch/tag with driver changes
>> (although recently Arnd did not want driver changes mixed with DTS...).
>
> I'd suggest postponing that dts cleanup patch to v4.13, everything
> should continue to work properly with just the driver patches merged
> and that way there will be no need to pull all 14 driver patches
> into the arm-soc tree.

Yes. I didn't post an update here but to make it clear - the DTS
change in this case have to wait. It cannot go to a branch with the
driver changes (regardless if these as pulled from outside or included
as is).

Best regards,
Krzysztof
