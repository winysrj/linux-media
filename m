Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60378 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbcFCG5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2016 02:57:51 -0400
Subject: Re: [PATCH v4 5/7] ARM: Exynos: remove code for MFC custom reserved
 memory handling
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
 <1464096690-23605-6-git-send-email-m.szyprowski@samsung.com>
 <574BEBB8.8040606@samsung.com>
 <5a12a8be-0402-dc0c-d242-5d9f3145e001@osg.samsung.com>
 <57505F5B.90101@samsung.com>
 <e715a7d0-eb25-9d68-27ad-25cf03c499ca@osg.samsung.com>
Cc: devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-id: <57512A6A.1050209@samsung.com>
Date: Fri, 03 Jun 2016 08:57:46 +0200
MIME-version: 1.0
In-reply-to: <e715a7d0-eb25-9d68-27ad-25cf03c499ca@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/2016 07:25 PM, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 06/02/2016 12:31 PM, Krzysztof Kozlowski wrote:
>> On 06/02/2016 05:20 PM, Javier Martinez Canillas wrote:
>>> Hello Krzysztof,
>>>
>>> On 05/30/2016 03:28 AM, Krzysztof Kozlowski wrote:
>>>> On 05/24/2016 03:31 PM, Marek Szyprowski wrote:
>>>>> Once MFC driver has been converted to generic reserved memory bindings,
>>>>> there is no need for custom memory reservation code.
>>>>>
>>>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>>> ---
>>>>>  arch/arm/mach-exynos/Makefile      |  2 -
>>>>>  arch/arm/mach-exynos/exynos.c      | 19 --------
>>>>>  arch/arm/mach-exynos/mfc.h         | 16 -------
>>>>>  arch/arm/mach-exynos/s5p-dev-mfc.c | 93 --------------------------------------
>>>>>  4 files changed, 130 deletions(-)
>>>>>  delete mode 100644 arch/arm/mach-exynos/mfc.h
>>>>>  delete mode 100644 arch/arm/mach-exynos/s5p-dev-mfc.c
>>>>
>>>> Thanks, applied.
>>>>
>>>
>>> This patch can't be applied before patches 2/5 and 3/5, or the custom
>>> memory regions reservation will break with the current s5p-mfc driver.
>>
>> Yes, I know. As I understood from talk with Marek, the driver is broken
>> now so continuous work was not chosen. If it is not correct and full
> 
> It's true that the driven is currently broken in mainline and is not really
> stable, I posted fixes for all the issues I found (mostly in module removal
> and insert paths).
> 
> But with just the following patch from Ayaka on top of mainline, I'm able to
> have video decoding working: https://lkml.org/lkml/2016/5/6/577

Which is still a "future" patch, not current state...
> 
> Marek mentioned that bisectability is only partially broken because the old
> binding will still work after this series if IOMMU is enabled (because the
> properties are ignored in this case). But will break if IOMMU isn't enabled
> which will be the case for some boards that fails to boot with IOMMU due the
> bootloader leaving the FIMD enabled doing DMA operations automatically AFAIU. 
> 
> Now, I'm OK with not keeping backwards compatibility for the MFC dt bindings
> since arguably the driver has been broken for a long time and nobody cared
> and also I don't think anyone in practice boots a new kernel with an old DTB
> for Exynos.
> 
> But I don't think is correct to introduce a new issue as is the case if this
> patch is applied before the previous patches in the series since this causes
> the driver to probe to fail and the following warn on boot (while it used to
> at least probe correctly in mainline):

Okay but the patches will go through separate tree. This is not a
problem, as I said, I just need a stable tag from media tree with first
four patches (Mauro?).

Best regards,
Krzysztof

