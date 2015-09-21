Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37395 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbIUMzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 08:55:32 -0400
Subject: Re: [PATCH 4/4] ARM64: dts: exynos5433: add jpeg node
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
 <1442586060-23657-5-git-send-email-andrzej.p@samsung.com>
 <55FFD2D2.1010508@xs4all.nl> <55FFD4FF.6090306@samsung.com>
 <20150921084133.175b1bda@recife.lan>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <55FFFE40.8070801@samsung.com>
Date: Mon, 21 Sep 2015 14:55:28 +0200
MIME-version: 1.0
In-reply-to: <20150921084133.175b1bda@recife.lan>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

W dniu 21.09.2015 o 13:41, Mauro Carvalho Chehab pisze:

<snip>

>>>
>>> I think the media subsystem can take patches 1-3 and whoever does DT patches can
>>> take this patch, right?
>>>
>>
>> The cover letter explains that the series is rebased onto Mauro's
>> master with Kukjin's branch merged. The latter does contain
>> the exynos5433.dtsi. That said, yes, taking patches 1-3 in
>> media subsystem and leaving DT patch to someone else is the
>> way to go.
>
> I'm ok with such strategy, provided that the new driver builds fine with
> COMPILE_TEST without the need of the dtsi patch.
>

I've checked. It does compile with COMPILE_TEST.


> Please also notice that, if the driver uses MC, it has to wait for
> the MC next gen support to be merged,

No, it does not. It is a rather simple mem2mem device.

Sylwester has answered about camera support which is a different
topic.

Andrzej
