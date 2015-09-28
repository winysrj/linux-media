Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33310 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbbI1MCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2015 08:02:33 -0400
Subject: Re: [PATCH 4/4] ARM64: dts: exynos5433: add jpeg node
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
 <55FFD4FF.6090306@samsung.com> <5608FFBD.1030306@samsung.com>
 <2466182.YdnXZtSWXI@amdc1976>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Message-ID: <56092C54.1070507@samsung.com>
Date: Mon, 28 Sep 2015 21:02:28 +0900
MIME-Version: 1.0
In-Reply-To: <2466182.YdnXZtSWXI@amdc1976>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 28.09.2015 o 20:54, Bartlomiej Zolnierkiewicz pisze:
> 
> Hi,
> 
> On Monday, September 28, 2015 05:52:13 PM Krzysztof Kozlowski wrote:
>> W dniu 21.09.2015 o 18:59, Andrzej Pietrasiewicz pisze:
>>> Hi Hans,
>>>
>>> W dniu 21.09.2015 o 11:50, Hans Verkuil pisze:
>>>> On 18-09-15 16:21, Andrzej Pietrasiewicz wrote:
>>>>> From: Marek Szyprowski <m.szyprowski@samsung.com>
>>>>>
>>>>> Add Exynos 5433 jpeg h/w codec node.
>>>>>
>>>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>>> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>>>>> ---
>>>>>   arch/arm64/boot/dts/exynos/exynos5433.dtsi | 21 +++++++++++++++++++++
>>>>>   1 file changed, 21 insertions(+)
>>>>>
>>>>> diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi
>>>>> b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
>>>>
>>>> This dtsi file doesn't exist in the media-git tree. What is the story
>>>> here?
>>>>
>>>> Should this go through a different subsystem?
>>>>
>>>> I think the media subsystem can take patches 1-3 and whoever does DT
>>>> patches can
>>>> take this patch, right?
>>>>
>>>
>>> The cover letter explains that the series is rebased onto Mauro's
>>> master with Kukjin's branch merged. The latter does contain
>>> the exynos5433.dtsi. That said, yes, taking patches 1-3 in
>>> media subsystem and leaving DT patch to someone else is the
>>> way to go.
>>
>> Although Kukjin picked Exynos 5433 ARM64 patches but they were not
>> accepted upstream by arm-soc. He rolled it for few releases but:
>> 1. Reason for not accepting by arm-soc was not resolved - there is no DTS.
>> 2. Kukjin did not rebase the branch for 4.4... which maybe means that he
>> wants to drop it?
>> 3. Anyone (but me...) can send Galaxy Note4 (Exynos5433) DTS file based
>> on sources on opensource.samsung.com. The DTS there is for 32-bit but it
>> can be probably easily adjusted for ARM64.
>>
>> All of this means that Device Tree support for this driver can't be
>> merged now and effort for mainlining 5433 may be unfortunately wasted...
> 
> Exynos5433 support is being incrementally merged (clocks, drm, phy,
> pinctrl, thermal and tty support is already in upstream or -next).
> 
> I don't know why DTS changes got stuck in Kukjin's tree (Kukjin,
> could you please explain?) but I think that this shouldn't not stop
> us from continuing Exynos5433 upstreaming effort.

I already explained. There is no DTS, so the pull request was rejected
(pull request for v4.0 I believe).

It was not about adding drivers for 5433's clocks/phy/pinctrl etc. It
was about DTS.

Best regards,
Krzysztof

