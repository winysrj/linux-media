Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35579 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbbIUM3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 08:29:10 -0400
Message-id: <55FFF7E7.2050609@samsung.com>
Date: Mon, 21 Sep 2015 14:28:23 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 4/4] ARM64: dts: exynos5433: add jpeg node
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
 <1442586060-23657-5-git-send-email-andrzej.p@samsung.com>
 <55FFD2D2.1010508@xs4all.nl> <55FFD4FF.6090306@samsung.com>
 <20150921084133.175b1bda@recife.lan>
In-reply-to: <20150921084133.175b1bda@recife.lan>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 21/09/15 13:41, Mauro Carvalho Chehab wrote:
> Btw, I just got a Samsung TM1 device, with seems to be using an arm64
> SoC. Is this driver providing support for its camera?

The TM1 device (Z3) is based on a Qualcomm 64-bit SoC. The $subject
patch adds support for a standalone JPEG codec IP block of Samsung
Exynos5433 SoC, which can be found for instance in Galaxy Note4.
Perhaps someone else can provide more details regarding the TM1's camera
status.

-- 
Regards,
Sylwester
