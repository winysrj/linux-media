Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41825
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753562AbcKIRVf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 12:21:35 -0500
Subject: Re: [PATCH 00/12] media: Exynos GScaller driver fixes
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <CGME20161109142406eucas1p2c3c158d10fd96d97c57a32ab402acd2e@eucas1p2.samsung.com>
 <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <517f0587-6df0-9a35-44f6-55087e1717a7@osg.samsung.com>
Date: Wed, 9 Nov 2016 14:21:24 -0300
MIME-Version: 1.0
In-Reply-To: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Marek,

On 11/09/2016 11:23 AM, Marek Szyprowski wrote:
> Hi!
> 
> This is a collection of various fixes and cleanups for Exynos GScaller
> media driver. Most of them comes from the forgotten patchset posted long
> time ago by Ulf Hansson:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg80592.html
> 
> While testing and rebasing them, I added some more cleanups. Tested on
> Exynos5422-based Odroid XU3 board.
> 

I've tested this series on a Exynos5800-based Peach Pi Chromebook. The
patches were tested on top of Sylwester's for-v4.10/media/next branch:

git://linuxtv.org/snawrocki/samsung.git for-v4.10/media/next

So feel free to add for the whole series:

Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
