Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25835 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbbIUJ7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 05:59:30 -0400
Subject: Re: [PATCH 4/4] ARM64: dts: exynos5433: add jpeg node
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
 <1442586060-23657-5-git-send-email-andrzej.p@samsung.com>
 <55FFD2D2.1010508@xs4all.nl>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <55FFD4FF.6090306@samsung.com>
Date: Mon, 21 Sep 2015 11:59:27 +0200
MIME-version: 1.0
In-reply-to: <55FFD2D2.1010508@xs4all.nl>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

W dniu 21.09.2015 o 11:50, Hans Verkuil pisze:
> On 18-09-15 16:21, Andrzej Pietrasiewicz wrote:
>> From: Marek Szyprowski <m.szyprowski@samsung.com>
>>
>> Add Exynos 5433 jpeg h/w codec node.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>> ---
>>   arch/arm64/boot/dts/exynos/exynos5433.dtsi | 21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
>
> This dtsi file doesn't exist in the media-git tree. What is the story here?
>
> Should this go through a different subsystem?
>
> I think the media subsystem can take patches 1-3 and whoever does DT patches can
> take this patch, right?
>

The cover letter explains that the series is rebased onto Mauro's
master with Kukjin's branch merged. The latter does contain
the exynos5433.dtsi. That said, yes, taking patches 1-3 in
media subsystem and leaving DT patch to someone else is the
way to go.

Andrzej
