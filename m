Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17847 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161376AbcFBQb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2016 12:31:29 -0400
Subject: Re: [PATCH v4 5/7] ARM: Exynos: remove code for MFC custom reserved
 memory handling
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-6-git-send-email-m.szyprowski@samsung.com>
 <574BEBB8.8040606@samsung.com>
 <5a12a8be-0402-dc0c-d242-5d9f3145e001@osg.samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <57505F5B.90101@samsung.com>
Date: Thu, 02 Jun 2016 18:31:23 +0200
MIME-version: 1.0
In-reply-to: <5a12a8be-0402-dc0c-d242-5d9f3145e001@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/2016 05:20 PM, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 05/30/2016 03:28 AM, Krzysztof Kozlowski wrote:
>> On 05/24/2016 03:31 PM, Marek Szyprowski wrote:
>>> Once MFC driver has been converted to generic reserved memory bindings,
>>> there is no need for custom memory reservation code.
>>>
>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> ---
>>>  arch/arm/mach-exynos/Makefile      |  2 -
>>>  arch/arm/mach-exynos/exynos.c      | 19 --------
>>>  arch/arm/mach-exynos/mfc.h         | 16 -------
>>>  arch/arm/mach-exynos/s5p-dev-mfc.c | 93 --------------------------------------
>>>  4 files changed, 130 deletions(-)
>>>  delete mode 100644 arch/arm/mach-exynos/mfc.h
>>>  delete mode 100644 arch/arm/mach-exynos/s5p-dev-mfc.c
>>
>> Thanks, applied.
>>
> 
> This patch can't be applied before patches 2/5 and 3/5, or the custom
> memory regions reservation will break with the current s5p-mfc driver.

Yes, I know. As I understood from talk with Marek, the driver is broken
now so continuous work was not chosen. If it is not correct and full
bisectability is required, then entire patchset requires special
handling - I need a stable tag from media tree. Without this everything
will be broken anyway.

Best regards,
Krzysztof

