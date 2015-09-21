Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38296 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbbIULlj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 07:41:39 -0400
Date: Mon, 21 Sep 2015 08:41:33 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 4/4] ARM64: dts: exynos5433: add jpeg node
Message-ID: <20150921084133.175b1bda@recife.lan>
In-Reply-To: <55FFD4FF.6090306@samsung.com>
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
	<1442586060-23657-5-git-send-email-andrzej.p@samsung.com>
	<55FFD2D2.1010508@xs4all.nl>
	<55FFD4FF.6090306@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Sep 2015 11:59:27 +0200
Andrzej Pietrasiewicz <andrzej.p@samsung.com> escreveu:

> Hi Hans,
> 
> W dniu 21.09.2015 o 11:50, Hans Verkuil pisze:
> > On 18-09-15 16:21, Andrzej Pietrasiewicz wrote:
> >> From: Marek Szyprowski <m.szyprowski@samsung.com>
> >>
> >> Add Exynos 5433 jpeg h/w codec node.
> >>
> >> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> >> ---
> >>   arch/arm64/boot/dts/exynos/exynos5433.dtsi | 21 +++++++++++++++++++++
> >>   1 file changed, 21 insertions(+)
> >>
> >> diff --git a/arch/arm64/boot/dts/exynos/exynos5433.dtsi b/arch/arm64/boot/dts/exynos/exynos5433.dtsi
> >
> > This dtsi file doesn't exist in the media-git tree. What is the story here?
> >
> > Should this go through a different subsystem?
> >
> > I think the media subsystem can take patches 1-3 and whoever does DT patches can
> > take this patch, right?
> >
> 
> The cover letter explains that the series is rebased onto Mauro's
> master with Kukjin's branch merged. The latter does contain
> the exynos5433.dtsi. That said, yes, taking patches 1-3 in
> media subsystem and leaving DT patch to someone else is the
> way to go.

I'm ok with such strategy, provided that the new driver builds fine with
COMPILE_TEST without the need of the dtsi patch.

Please also notice that, if the driver uses MC, it has to wait for
the MC next gen support to be merged, and may need to be rebased, due
to a few changes at the MC internal APIs: one function got renamed
(the function that create links between two pads) and we're now using
lists for links (that will only affect the driver if it has its own
graph traversal routines).

Btw, I just got a Samsung TM1 device, with seems to be using an arm64
SoC. Is this driver providing support for its camera?

Regards,
Mauro.
